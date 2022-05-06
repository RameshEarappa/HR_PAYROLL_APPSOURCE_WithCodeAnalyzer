table 60127 "Evaluation Appraisal Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Performance ID"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EmployeeRecL: Record Employee;
            begin
                TESTFIELD("Date of Review");
                EmployeeRecL.RESET;
                if EmployeeRecL.GET("Employee Code") then begin
                    EmployeeRecL.TESTFIELD("Joining Date");
                    if ("Date of Review" - EmployeeRecL."Joining Date") >= 365 then
                        ERROR(Text002, EmployeeRecL.FullName);
                end;
                if "Employee Code" <> xRec."Employee Code" then begin
                    EvaluationAppraisalLineRecG.RESET;
                    EvaluationAppraisalLineRecG.SETRANGE("Performance ID", "Performance ID");
                    EvaluationAppraisalLineRecG.SETRANGE("Employee Code", "Employee Code");
                    if EvaluationAppraisalLineRecG.FINDSET then
                        EvaluationAppraisalLineRecG.DELETEALL;
                end;
                FillEmployeeDetails("Employee Code");
            end;
        }
        field(3; "Employee Name"; Text[150])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; Department; Code[100])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5; Position; Code[100])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "Line Manager"; Code[150])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7; "Date of Join"; Date)
        {
            Caption = 'Date of Joining';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(8; "Date of Review"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Document Created"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(10; "Evalutation Agree"; Boolean)
        {
            Caption = 'Evalutation Agreed By Employee';
            Description = 'Evalution Mutually Agreed with EmployeeBoolean';
            DataClassification = CustomerContent;
        }
        field(11; "User - ID"; Code[150])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(12; "Records - ID"; RecordID)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(13; "Final Comments By employee"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Final Comments By Manager"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Final Comments By HR"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(16; "Earning Code Group"; Code[10])
        {
            Editable = false;
            TableRelation = "Earning Code Groups";
            DataClassification = CustomerContent;
        }
        field(17; "Workflow status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";
            DataClassification = CustomerContent;
        }
        field(18; "Total Sum"; Decimal)
        {
            CalcFormula = Sum("Evaluation Appraisal Line"."Evaluation Rating" WHERE("Performance ID" = FIELD("Performance ID"),
                                                                                     "Employee Code" = FIELD("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Performance ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        EvaluationAppraisalLineRecL: Record "Evaluation Appraisal Line";
    begin
        EvaluationAppraisalLineRecL.RESET;
        EvaluationAppraisalLineRecL.SETRANGE("Performance ID", "Performance ID");
        EvaluationAppraisalLineRecL.SETRANGE("Employee Code", "Employee Code");
        if EvaluationAppraisalLineRecL.FINDSET then
            EvaluationAppraisalLineRecL.DELETEALL;
    end;

    trigger OnInsert()
    begin
        AdvancePayrollSetupRecG.RESET;
        AdvancePayrollSetupRecG.GET;
        if "Performance ID" = '' then begin
            AdvancePayrollSetupRecG.TESTFIELD("Performance Appraisal Ser. No.");
            "Performance ID" := NoSeriesManagementCUG.GetNextNo(AdvancePayrollSetupRecG."Performance Appraisal Ser. No.", TODAY, true);
            "Document Created" := TODAY;
            "User - ID" := USERID;
            "Records - ID" := RECORDID;
        end;
    end;

    var
        NoSeriesManagementCUG: Codeunit NoSeriesManagement;
        PreTypeTxtG: Code[250];
        AdvancePayrollSetupRecG: Record "Advance Payroll Setup";
        EvaluationFactorTypeMasterRecG: Record "Evaluation Factor Type Master";
        EvaluationAppraisalLineRecG: Record "Evaluation Appraisal Line";
        EvaluationRQSubMasterRecG: Record "Evaluation RQ Sub Master";
        Text001: Label 'Rating Factor for Employee''s Earning Code Group is Not define.';
        Text002: Label 'Service days of Employee  " %1 "  is beyond 365 days, Please initiats Performance Evaluation for selected Employee.';

    local procedure FillEmployeeDetails(EmployeeCode_P: Code[20])
    var
        EmployeeRecL: Record Employee;
    begin
        EmployeeRecL.RESET;
        if EmployeeRecL.GET(EmployeeCode_P) then begin
            "Employee Name" := EmployeeRecL.FullName;
            Department := EmployeeRecL.Department;
            Position := EmployeeRecL.Position;
            "Line Manager" := EmployeeRecL."Line manager";
            "Date of Join" := EmployeeRecL."Joining Date";
            EmployeeRecL.TESTFIELD("Earning Code Group");
            CheckQRMAsterSetup(EmployeeRecL."Earning Code Group");
            "Earning Code Group" := EmployeeRecL."Earning Code Group";
            MODIFY;
        end;

        if "Performance ID" <> '' then
            ImportQuestionBaseOnECG(EmployeeRecL."Earning Code Group");
    end;

    local procedure ImportQuestionBaseOnECG(EarningCodeGroup_P: Code[150])
    var
        EvaluationRQSubMasterRecL: Record "Evaluation RQ Sub Master";
        EvaluationAppraisalLineRecL: Record "Evaluation Appraisal Line";
    begin
        EvaluationRQSubMasterRecL.RESET;
        EvaluationRQSubMasterRecL.SETCURRENTKEY("Performance Appraisal Type");
        EvaluationRQSubMasterRecL.SETRANGE("Earning Code Group", EarningCodeGroup_P);
        if EvaluationRQSubMasterRecL.FINDSET then begin
            repeat
                if PreTypeTxtG <> EvaluationRQSubMasterRecL."Performance Appraisal Type" then begin
                    EvaluationAppraisalLineRecL.INIT;
                    EvaluationAppraisalLineRecL."Performance ID" := "Performance ID";
                    EvaluationAppraisalLineRecL."Employee Code" := "Employee Code";
                    EvaluationAppraisalLineRecL."Line No." += 10000;
                    EvaluationAppraisalLineRecL."Performance Appraisal Type" := EvaluationRQSubMasterRecL."Performance Appraisal Type";
                    EvaluationFactorTypeMasterRecG.RESET;
                    EvaluationFactorTypeMasterRecG.GET(EvaluationRQSubMasterRecL."Performance Appraisal Type");
                    EvaluationAppraisalLineRecL."Rating Factors" := EvaluationFactorTypeMasterRecG.Description;
                    EvaluationAppraisalLineRecL.IndentationColumn := 1;
                    EvaluationAppraisalLineRecL.INSERT;

                    PreTypeTxtG := EvaluationRQSubMasterRecL."Performance Appraisal Type";

                    EvaluationAppraisalLineRecL.INIT;
                    EvaluationAppraisalLineRecL."Performance ID" := "Performance ID";
                    EvaluationAppraisalLineRecL."Employee Code" := "Employee Code";
                    EvaluationAppraisalLineRecL."Line No." += 10000;
                    EvaluationAppraisalLineRecL."Performance Appraisal Type" := EvaluationRQSubMasterRecL."Performance Appraisal Type";
                    EvaluationAppraisalLineRecL."Rating Factors" := EvaluationRQSubMasterRecL."Rating Factor";
                    EvaluationAppraisalLineRecL."Rating Factor Description" := EvaluationRQSubMasterRecL."Rating Factor Description";
                    EvaluationAppraisalLineRecL.IndentationColumn := 2;
                    EvaluationAppraisalLineRecL."Maximum Rating" := EvaluationRQSubMasterRecL.Weightage;
                    EvaluationAppraisalLineRecL.INSERT;
                end else begin

                    EvaluationAppraisalLineRecL.INIT;
                    EvaluationAppraisalLineRecL."Performance ID" := "Performance ID";
                    EvaluationAppraisalLineRecL."Employee Code" := "Employee Code";
                    EvaluationAppraisalLineRecL."Line No." += 10000;
                    EvaluationAppraisalLineRecL."Performance Appraisal Type" := EvaluationRQSubMasterRecL."Performance Appraisal Type";
                    EvaluationAppraisalLineRecL."Rating Factors" := EvaluationRQSubMasterRecL."Rating Factor";
                    EvaluationAppraisalLineRecL."Rating Factor Description" := EvaluationRQSubMasterRecL."Rating Factor Description";
                    EvaluationAppraisalLineRecL.IndentationColumn := 2;
                    EvaluationAppraisalLineRecL."Maximum Rating" := EvaluationRQSubMasterRecL.Weightage;
                    EvaluationAppraisalLineRecL.INSERT;

                    PreTypeTxtG := EvaluationRQSubMasterRecL."Performance Appraisal Type";
                end
            until EvaluationRQSubMasterRecL.NEXT = 0;
        end;
    end;

    local procedure CheckQRMAsterSetup(EarningCodeGroup_Pcode: Code[30])
    begin
        EvaluationRQSubMasterRecG.RESET;
        EvaluationRQSubMasterRecG.SETRANGE("Earning Code Group", EarningCodeGroup_Pcode);
        if not EvaluationRQSubMasterRecG.FINDFIRST then
            ERROR(Text001);
    end;
}