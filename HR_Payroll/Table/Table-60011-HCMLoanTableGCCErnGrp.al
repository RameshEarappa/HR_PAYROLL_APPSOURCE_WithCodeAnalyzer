table 60011 "HCM Loan Table GCC ErnGrp"
{
    Caption = 'HCM Loan Table GCC ErnGrp';
    DrillDownPageID = "HCM Loan Table GCC ErnGrps";
    LookupPageID = "HCM Loan Table GCC ErnGrps";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Loan Code"; Code[50])
        {
            TableRelation = "Loan Type Setup"."Loan Code" WHERE(Active = FILTER(true));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if LoanTypeSetup.GET("Loan Code") then begin
                    Rec.TRANSFERFIELDS(LoanTypeSetup);
                end;
            end;
        }
        field(2; "Loan Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Arabic Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Earning Code for Principal"; Code[20])
        {
            TableRelation = "Payroll Earning Code"."Earning Code";
            DataClassification = CustomerContent;
        }
        field(5; "Earning Code for Interest"; Code[20])
        {
            TableRelation = "Payroll Earning Code"."Earning Code";
            DataClassification = CustomerContent;
        }
        field(6; "Earning Code Selection"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "No. of times Earning Code"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Min Loan Amount"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Min Loan Amount" > "Max Loan Amount" then
                    ERROR(Text50003, "Min Loan Amount", "Max Loan Amount");
            end;
        }
        field(9; "Max Loan Amount"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Max Loan Amount" < "Min Loan Amount" then
                    ERROR(Text50002, "Max Loan Amount", "Min Loan Amount");

            end;
        }
        field(10; "Interest Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Allow Multiple Loans"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(12; Active; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Calculation Basis"; Option)
        {
            OptionCaption = ',Multiple Earning Code,Min/Max Amount';
            OptionMembers = ,"Multiple Earning Code","Min/Max Amount";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Calculation Basis" = "Calculation Basis"::"Min/Max Amount" then begin
                    "No. of times Earning Code" := 0;
                    MultipleEarningCodes.SETRANGE("Loan Code", "Loan Code");
                    if MultipleEarningCodes.FINDSET then
                        repeat

                            MultipleEarningCodes.DELETE;
                        until MultipleEarningCodes.NEXT = 0;
                end;

                if "Calculation Basis" = "Calculation Basis"::"Multiple Earning Code" then begin
                    "Min Loan Amount" := 0;
                    "Max Loan Amount" := 0;
                end;
            end;
        }
        field(21; "Number of Installment"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(22; "No. of Loans in a Year"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(91; "Earning Code Group"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Earning Code Groups";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Earning Code Group", "Loan Code")
        {
            Clustered = true;
        }
        key(Key2; "Loan Code")
        {
        }
    }

    var
        LoanTypeSetup: Record "Loan Type Setup";
        MultipleEarningCodes: Record "Multiple Earning Codes";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text50002: Label 'Maximum Loan Amount %1 cannot be less than Minimum Loan Amount %2 !';
        Text50003: Label 'Minimum Loan Amount %1 cannot be greater than Maximum Loan Amount %2 !';
}