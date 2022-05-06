tableextension 60014 EmployeeExt extends Employee
{

    fields
    {
        modify(Initials)
        {
            TableRelation = Initials;
            trigger OnAfterValidate()
            begin
                "Search Name" := Initials + ' ' + "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            end;
        }

        field(60000; "Earning Code Group"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                EarningCodeGrps: Record "Earning Code Groups";
                PayrollEarningCodeErnGrp: Record "Payroll Earning Code ErnGrp";
                HCMLeaveTypesErnGrp: Record "HCM Leave Types ErnGrp";
                HCMLoanTableGCCErnGrp: Record "HCM Loan Table GCC ErnGrp";
                HCMBenefitErnGrp: Record "HCM Benefit ErnGrp";
            begin
                IF (xRec."Earning Code Group" <> "Earning Code Group") AND
                    ("Earning Code Group" = '') THEN
                    DeleteEarningGroupsData(xRec."Earning Code Group");

                IF "Earning Code Group" <> '' THEN
                    InsertEarningGroupData;
            end;
        }
        field(60001; "Joining Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Joining Date" <> 0D THEN BEGIN
                    PayrollJobPosWorkerAssign.RESET;
                    PayrollJobPosWorkerAssign.SETRANGE(Worker, Rec."No.");
                    PayrollJobPosWorkerAssign.SETRANGE("Position Assigned", FALSE);
                    IF PayrollJobPosWorkerAssign.FINDFIRST THEN BEGIN
                        PayrollJobPosWorkerAssign.VALIDATE("Assignment Start", "Joining Date");
                        PayrollJobPosWorkerAssign.MODIFY(TRUE);
                    END;
                END;
                Validate("Employment Date", "Joining Date");
            end;
        }
        field(60002; "Probation Period"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD("Joining Date");
                IF "Probation Period" <> 0D THEN
                    IF "Probation Period" <= "Joining Date" THEN
                        ERROR('Probation Period should be greater than Joining Date');
            end;
        }
        field(60003; "Employee Religion"; Code[20])
        {
            TableRelation = "Payroll Religion";
            DataClassification = CustomerContent;
        }
        field(60004; Nationality; Text[50])
        {
            Caption = 'Nationality';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CountryRegion: Record 9;
            begin
                "Emp National Code" := Nationality;
                CountryRegion.RESET;
                IF CountryRegion.GET(Nationality) THEN
                    Nationality := CountryRegion.Name;
            end;
        }
        field(60005; "Marital Status"; Text[30])
        {
            TableRelation = "Marital Status";
            DataClassification = CustomerContent;
        }
        field(60006; "Seperation Reason"; Text[250])
        {
            TableRelation = "Seperation Master"."Seperation Reason";
            DataClassification = CustomerContent;
        }
        field(60007; "Hold Payment from Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60008; Type; Option)
        {
            OptionMembers = " ","New Addition","Request Change","Delete Dependent";
            DataClassification = CustomerContent;
        }
        field(60009; Remarks; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(60010; "Increment Step Number"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60011; "Unsatisfactory Grade"; Integer)
        {
            Caption = 'No of Years with Unsatisfactory Grade';
            DataClassification = CustomerContent;
        }
        field(60012; "Seperation Reason Code"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60013; "Employee Request No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60014; "Employee Name in Arabic"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(60015; "Grade Category"; Code[50])
        {
            TableRelation = "Payroll Grade Category";
            DataClassification = CustomerContent;
        }
        field(60016; Grade; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60017; "Sub Grade"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60018; "Employment End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60019; Position; Code[20])
        {
            TableRelation = "Payroll Position";
            DataClassification = CustomerContent;
        }
        field(60020; "Position Assignment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60021; "Identification Type"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60022; "Identification No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60023; "Issue Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60024; "Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60025; "Issuing Country"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60026; Department; Code[20])
        {
            Caption = 'Department';
            TableRelation = "Payroll Department";
            DataClassification = CustomerContent;
        }
        field(60027; "Line manager"; Text[50])
        {
            Caption = 'Line Manager';
            DataClassification = CustomerContent;
        }
        field(60028; HOD; Text[50])
        {
            Caption = 'HOD';
            DataClassification = CustomerContent;
        }
        field(60029; "Contract No"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(60030; "Contract Version No."; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(60031; "Registry Reference No."; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(60032; "Employment Type"; Code[20])
        {
            Caption = 'Employment Type';
            TableRelation = "Employment Type";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF EmplTypeREc.GET("Employment Type") THEN
                    "Employment Type" := EmplTypeREc."Employment Type";
            end;
        }
        field(60033; "Sub Department"; Code[20])
        {
            Caption = 'Sub Department';
            TableRelation = "Sub Department" WHERE("Department ID" = FIELD(Department));
            DataClassification = CustomerContent;
        }
        field(60034; "Age As Of Date"; Text[30])
        {
            Caption = 'Age As Of Date';
            DataClassification = CustomerContent;
        }
        field(60035; Region; Text[35])
        {
            Caption = 'Region';
            TableRelation = Region;
            DataClassification = CustomerContent;
        }
        field(60036; "Work Location"; Text[50])
        {
            Caption = 'Work Location';
            TableRelation = "Work Location";
            DataClassification = CustomerContent;
        }
        field(60037; "Position Name In Arabic"; Text[50])
        {
            Caption = 'Position Name In Arabic';
            DataClassification = CustomerContent;
        }
        field(60038; "Nationality In Arabic"; Text[50])
        {
            Caption = 'Nationality In Arabic';
            DataClassification = CustomerContent;
        }
        field(60039; "Job Title as per Iqama"; Text[50])
        {
            Caption = 'Job Title as per Iqama';
            DataClassification = CustomerContent;
        }
        field(60040; "Sector ID"; Code[20])
        {
            Caption = 'Sector ID';
            TableRelation = Sector;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CLEAR("Search Name");
                IF SectorRec.GET("Sector ID") THEN
                    "Sector Name" := SectorRec."Sector Name";
            end;

        }
        field(60041; "Sector Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(60042; "Old Employee ID"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(60043; "Employee Full Name In Arabic"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(60044; "Personal   Title in Arabic"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(60045; "First Reporting ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60046; "Employee Copy"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60047; "Increment step"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Increment step" = '' THEN
                    "Increment Step Number" := 0;
            end;
        }
        field(60048; "Professional Title in Arabic"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(60049; "D.O.J Hijiri"; Text[50])
        {
            Description = '#WFLevtech';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(60050; "B.O.D Hijiri"; Text[50])
        {
            Description = '#WFLevtech';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(60051; "Emp National Code"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(60052; "Blood Group"; Option)
        {
            OptionMembers = " ","O−","O+","A−","A+","B−","B+","AB−","AB+";
            DataClassification = CustomerContent;
        }

        field(60053; "Employee Notice Period In Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60054; "Sponcer"; Code[250])
        {
            TableRelation = Company;
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            var
                CompanyRecL: Record Company;
            begin
                CompanyRecL.Reset();
                if CompanyRecL.Get(Sponcer) then begin
                    Clear(Sponcer);
                    Sponcer := UpperCase(CompanyRecL.Name);
                end;
            end;
        }

        field(60055; "Probation Months"; Integer)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                AdvPayrollSetupRecL: Record "Advance Payroll Setup";
                DateExpr: Text;
            begin
                AdvPayrollSetupRecL.Reset();
                AdvPayrollSetupRecL.Get();
                if "Probation Months" > AdvPayrollSetupRecL."Probation Months" then
                    Error('Probation  Mothas cannoot greater than %1', AdvPayrollSetupRecL."Probation Months");

                DateExpr := '<' + Format("Probation Months") + 'M>';
                "Probation Period" := CalcDate(dateExpr, "Joining Date");
            end;
        }
        field(60150; "Revoke Termination Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60151; "Vendor Account"; Code[20])
        {
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(60152; "Department Value"; Code[20])
        {
            Editable = FALSE;
            FieldClass = FlowField;
            CalcFormula = lookup("Payroll Department"."Department Value" WHERE("Department ID" = field(Department)));
        }
        modify("First Name")
        {
            trigger OnAfterValidate()
            begin
                "Search Name" := Initials + ' ' + "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            end;
        }
        modify("Last Name")
        {
            trigger OnAfterValidate()
            begin
                "Search Name" := Initials + ' ' + "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            end;
        }
        modify("Birth Date")
        {
            trigger OnAfterValidate()
            var
            begin
                CLEAR(Age);
                Age := -("Birth Date" - TODAY);
                VALIDATE("Age As Of Date", FORMAT(ROUND(Age / 365.27)));
            end;
        }

    }
    trigger OnBeforeDelete()
    var
        EmpPos: Record "Payroll Job Pos. Worker Assign";
    begin
        EmpPos.Reset();
        EmpPos.SetRange(Worker, "No.");
        EmpPos.SetRange("Is Primary Position", true);
        if EmpPos.FindFirst() then
            Error('Primary Position already been assigned to the Employee, Cannot be deleted.');
    end;

    local procedure DeleteEarningGroupsData(ErngGrp_p: Code[20])
    var
        EarningCodeGroups: Record "Earning Code Groups";
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
        HCMLeaveTypesWrkr: Record "HCM Leave Types Wrkr";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        HCMLoanTableGCCWrkr: Record "HCM Loan Table GCC Wrkr";
    begin
        EarningCodeGroups.RESET;
        EarningCodeGroups.GET(ErngGrp_p);
        PayrollEarningCodeWrkr.RESET;
        PayrollEarningCodeWrkr.SETRANGE("Earning Code", EarningCodeGroups."Earning Code Group");
    end;

    local procedure InsertEarningGroupData()
    var
        EarningCodeGroups: Record "Earning Code Groups";
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
        HCMLeaveTypesWrkr: Record "HCM Leave Types Wrkr";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        HCMLoanTableGCCWrkr: Record "HCM Loan Table GCC Wrkr";
        PayrollEarningCodeErnGrp: Record "Payroll Earning Code ErnGrp";
        HCMLeaveTypesErnGrp: Record "HCM Leave Types ErnGrp";
        HCMLoanTableGCCErnGrp: Record "HCM Loan Table GCC ErnGrp";
        HCMBenefitErnGrp: Record "HCM Benefit ErnGrp";
    begin
        EarningCodeGroups.RESET;
        EarningCodeGroups.GET("Earning Code Group");

        PayrollEarningCodeErnGrp.RESET;
        PayrollEarningCodeErnGrp.SETRANGE(PayrollEarningCodeErnGrp."Earning Code Group", Rec."Earning Code Group");
        IF PayrollEarningCodeErnGrp.FINDSET THEN
            REPEAT
                PayrollEarningCodeWrkr.RESET;
                IF NOT PayrollEarningCodeWrkr.GET("No.", PayrollEarningCodeErnGrp."Earning Code") THEN BEGIN
                    PayrollEarningCodeWrkr.INIT;
                    PayrollEarningCodeWrkr.TRANSFERFIELDS(PayrollEarningCodeErnGrp);
                    PayrollEarningCodeWrkr.Worker := Rec."No.";
                    PayrollEarningCodeWrkr."Earning Code Group" := "Earning Code Group";
                    PayrollEarningCodeWrkr.INSERT;
                END
                ELSE BEGIN
                    PayrollEarningCodeWrkr.TRANSFERFIELDS(PayrollEarningCodeErnGrp);
                    PayrollEarningCodeWrkr."Earning Code Group" := "Earning Code Group";
                    PayrollEarningCodeWrkr.Worker := Rec."No.";
                    PayrollEarningCodeWrkr.MODIFY;
                END;
            UNTIL PayrollEarningCodeErnGrp.NEXT = 0;

        HCMLeaveTypesErnGrp.RESET;
        HCMLeaveTypesErnGrp.SETRANGE(HCMLeaveTypesErnGrp."Earning Code Group", Rec."Earning Code Group");
        IF HCMLeaveTypesErnGrp.FINDSET THEN
            REPEAT
                HCMLeaveTypesWrkr.RESET;
                IF NOT HCMLeaveTypesWrkr.GET("No.", HCMLeaveTypesErnGrp."Leave Type Id") THEN BEGIN
                    HCMLeaveTypesWrkr.INIT;
                    HCMLeaveTypesWrkr.TRANSFERFIELDS(HCMLeaveTypesErnGrp);
                    HCMLeaveTypesWrkr.Worker := Rec."No.";
                    HCMLeaveTypesWrkr."Earning Code Group" := "Earning Code Group";
                    HCMLeaveTypesWrkr.INSERT;
                END
                ELSE BEGIN
                    HCMLeaveTypesWrkr.TRANSFERFIELDS(HCMLeaveTypesErnGrp);
                    HCMLeaveTypesWrkr."Earning Code Group" := "Earning Code Group";
                    HCMLeaveTypesWrkr.Worker := Rec."No.";
                    HCMLeaveTypesWrkr.MODIFY;
                END;
            UNTIL HCMLeaveTypesErnGrp.NEXT = 0;

        HCMLoanTableGCCErnGrp.RESET;
        HCMLoanTableGCCErnGrp.SETRANGE(HCMLoanTableGCCErnGrp."Earning Code for Interest", Rec."Earning Code Group");
        IF HCMLoanTableGCCErnGrp.FINDSET THEN
            REPEAT
                HCMLoanTableGCCWrkr.RESET;
                IF NOT HCMLoanTableGCCWrkr.GET("No.", HCMLoanTableGCCErnGrp."Interest Percentage") THEN BEGIN
                    HCMLoanTableGCCWrkr.INIT;
                    HCMLoanTableGCCWrkr.TRANSFERFIELDS(HCMLoanTableGCCErnGrp);
                    HCMLoanTableGCCWrkr."Earning Code Group" := Rec."No.";
                    HCMLoanTableGCCWrkr.Worker := "Earning Code Group";
                    HCMLoanTableGCCWrkr.INSERT;
                END
                ELSE BEGIN
                    HCMLoanTableGCCWrkr.TRANSFERFIELDS(HCMLoanTableGCCErnGrp);
                    HCMLoanTableGCCWrkr.Worker := "Earning Code Group";
                    HCMLoanTableGCCWrkr."Earning Code Group" := Rec."No.";
                    HCMLoanTableGCCWrkr.MODIFY;
                END;
            UNTIL HCMLoanTableGCCErnGrp.NEXT = 0;

        HCMBenefitErnGrp.RESET;
        HCMBenefitErnGrp.SETRANGE(HCMBenefitErnGrp."Earning Code Group", Rec."Earning Code Group");
        IF HCMBenefitErnGrp.FINDSET THEN
            REPEAT
                HCMBenefitWrkr.RESET;
                IF NOT HCMBenefitWrkr.GET("No.", HCMBenefitErnGrp."Benefit Id") THEN BEGIN
                    HCMBenefitWrkr.INIT;
                    HCMBenefitWrkr.TRANSFERFIELDS(HCMBenefitErnGrp);
                    HCMBenefitWrkr.Worker := Rec."No.";
                    HCMBenefitWrkr.INSERT;
                END
                ELSE BEGIN
                    HCMBenefitWrkr.TRANSFERFIELDS(HCMBenefitErnGrp);
                    HCMBenefitWrkr.Worker := Rec."No.";
                    HCMBenefitWrkr.MODIFY;
                END;
            UNTIL HCMBenefitErnGrp.NEXT = 0;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record "Employee";
        Res: Record "Resource";
        PostCode: Record "Post Code";
        AlternativeAddr: Record "Alternative Address";
        EmployeeQualification: Record "Employee Qualification";
        Relative: Record "Employee Relative";
        EmployeeAbsence: Record "Employee Absence";
        MiscArticleInformation: Record "Misc. Article Information";
        ConfidentialInformation: Record "Confidential Information";
        HumanResComment: Record "Human Resource Comment Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        EmployeeResUpdate: Codeunit "Employee/Resource Update";
        EmployeeSalespersonUpdate: Codeunit "Employee/Salesperson Update";
        DimMgt: Codeunit DimensionManagement;
        Text000: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        EmplTypeREc: Record "Employment Type";
        InitialsRec: Record "Initials";
        Age: Integer;
        SectorRec: Record "Sector";
        PayrollJobPosRec: Record "Payroll Job Pos. Worker Assign";
        Error001: Label 'Selected Employee cannot be deleted.';
        PayrollJobPosWorkerAssign: Record "Payroll Job Pos. Worker Assign";
        CountryRegion: Record "Country/Region";
}