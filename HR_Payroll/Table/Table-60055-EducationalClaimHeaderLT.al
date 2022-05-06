table 60055 "Educational Claim Header LT"
{
    DataCaptionFields = "Claim ID", "Employee No.", "Employee Name";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Claim ID"; Code[20])
        {
            Editable = true;
            NotBlank = false;
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
            begin
                CLEAR("Employee Name");
                CLEAR("Grade Category");
                CLEAR("Earning Code Group");
                CLEAR("Claim Date");
                CLEAR(Description);
                CLEAR("Academic year");
                if "Claim ID" = '' then begin
                    AdvancePayrollSetupRecG.GET;
                    "Claim ID" := NoSeriesManagementCUG.GetNextNo(AdvancePayrollSetupRecG."Educational Claim Nos.", TODAY, true);
                end;
                EmployeeRecG.RESET;
                if EmployeeRecG.GET("Employee No.") then begin
                    "Employee Name" := EmployeeRecG."First Name";
                    "Grade Category" := EmployeeRecG."Grade Category";
                    "Earning Code Group" := EmployeeRecG."Earning Code Group";
                    "Claim Date" := TODAY;
                    UserSetup.RESET;
                    UserSetup.SETRANGE("Employee Id", "Employee No.");
                    if UserSetup.FINDFIRST then
                        User_ID := UserSetup."User ID";
                end;
            end;
        }
        field(13; "Employee Name"; Text[80])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14; "Grade Category"; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; "Earning Code Group"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(16; "Claim Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                LineRec.RESET;
                LineRec.SETRANGE("Claim ID", "Claim ID");
                if LineRec.FINDSET then begin
                    repeat
                        LineRec."Claim Date" := "Claim Date";
                        LineRec.MODIFY;
                    until LineRec.NEXT = 0;
                end;
            end;
        }
        field(17; "Approval Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Released;
            DataClassification = CustomerContent;
        }
        field(18; "Posting Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Payroll,Finance';
            OptionMembers = " ",Payroll,Finance;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Posting Type" <> "Posting Type"::Payroll then begin
                    CLEAR("Pay Month");
                    CLEAR("Pay Period");
                end;
            end;
        }
        field(19; Description; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(20; Posted; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(21; "Academic year"; Code[20])
        {
            TableRelation = "Academic Period LT" WHERE(Closed = CONST(false));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
            begin
                if xRec."Academic year" <> Rec."Academic year" then begin
                    EducationalClaimLinesRecL.RESET;
                    EducationalClaimLinesRecL.SETRANGE("Claim ID", "Claim ID");
                    EducationalClaimLinesRecL.SETRANGE("Employee No.", "Employee No.");
                    if EducationalClaimLinesRecL.FINDSET then
                        EducationalClaimLinesRecL.DELETEALL
                end;
            end;
        }
        field(22; "Pay Month"; Code[20])
        {
            Caption = 'Pay Cycle';
            TableRelation = "Pay Cycles";
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                if PAGE.RUNMODAL(PAGE::"Pay Cycles", PrecayCycleRec) = ACTION::LookupOK then;
                "Pay Month" := PrecayCycleRec."Pay Cycle";
            end;

            trigger OnValidate()
            begin
                if "Pay Month" = '' then
                    CLEAR("Pay Period");
            end;
        }
        field(23; "Pay Period"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                PayPeriodsRec.RESET;
                PayPeriodsRec.SETRANGE("Pay Cycle", "Pay Month");
                PayPeriodsRec.SETRANGE(Status, PayPeriodsRec.Status::Open);
                if PAGE.RUNMODAL(PAGE::"Pay Periods List", PayPeriodsRec) = ACTION::LookupOK then begin
                    if (PayPeriodsRec."Period End Date" < "Claim Date") then
                        ERROR('Pay Period should be greater than Claim Date.');

                    "Pay Period" := PayPeriodsRec.Month + ' ' + FORMAT(PayPeriodsRec.Year);
                    "Pay Period Start" := PayPeriodsRec."Period Start Date";
                    "Pay Period End" := PayPeriodsRec."Period End Date";
                end
            end;
        }
        field(24; "Pay Period Start"; Date)
        {
            Description = 'Not usede in page';
            DataClassification = CustomerContent;
        }
        field(25; "Pay Period End"; Date)
        {
            Description = 'Not usede in page';
            DataClassification = CustomerContent;
        }
        field(26; User_ID; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Claim ID", "Employee No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Group1; "Claim ID", "Employee Name")
        {
        }
    }

    trigger OnDelete()
    var
        EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
    begin
        if "Approval Status" <> "Approval Status"::Open then
            ERROR('Approval Status Should be Open to delete Educational Claim.');

        EducationalClaimLinesRecL.RESET;
        EducationalClaimLinesRecL.SETRANGE("Claim ID", "Claim ID");
        EducationalClaimLinesRecL.SETRANGE("Employee No.", "Employee No.");
        if EducationalClaimLinesRecL.FINDSET then
            EducationalClaimLinesRecL.DELETEALL
    end;

    trigger OnInsert()
    begin
        if "Claim ID" = '' then begin
            AdvancePayrollSetupRecG.GET;
            "Claim ID" := NoSeriesManagementCUG.GetNextNo(AdvancePayrollSetupRecG."Educational Claim Nos.", TODAY, true);
        end;
        "Posting Type" := "Posting Type"::Finance;
        if CURRENTCLIENTTYPE = CLIENTTYPE::Web then begin
            UserSetup.RESET;
            UserSetup.SETRANGE("User ID", USERID);
            if UserSetup.FINDFIRST then
                VALIDATE("Employee No.", UserSetup."Employee Id");
        end;
    end;

    trigger OnModify()
    begin
        if Posted then
            ERROR('Posted must be Unchecked');
    end;

    var
        EmployeeRecG: Record Employee;
        NoSeriesManagementCUG: Codeunit NoSeriesManagement;
        AdvancePayrollSetupRecG: Record "Advance Payroll Setup";
        PrecayCycleRec: Record "Pay Cycles";
        PayPeriodsRec: Record "Pay Periods";
        LineRec: Record "Educational Claim Lines LT";
        UserSetup: Record "User Setup";
}