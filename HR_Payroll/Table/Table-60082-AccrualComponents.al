table 60082 "Accrual Components"
{
    LookupPageId = "Accrual Component List";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Accrual ID"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Accrual ID" <> xRec."Accrual ID" then begin
                    AdvancePayrollSetup.GET;
                    NoSeriesMngmnt.TestManual(AdvancePayrollSetup."Accrual Nos.");
                    AdvancePayrollSetup."Accrual Nos." := '';
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Accrual ID" = '' then begin
                    AdvancePayrollSetup.GET;
                    AdvancePayrollSetup.TESTFIELD("Accrual Nos.");
                    "Accrual ID" := NoSeriesMngmnt.GetNextNo(AdvancePayrollSetup."Accrual Nos.", TODAY, true);
                end;
            eND;
        }
        field(7; "Months Ahead Calculate"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Consumption Split by Month"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Accrual Interval Basis Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Accrual Basis Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Interval Month Start"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Accrual Units Per Month"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Opening Additional Accural"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Max Carry Forward"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(25; "CarryForward Lapse After Month"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Repeat After Months"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Avail Allow Till"; Option)
        {
            OptionCaption = 'Accrual Till Date,End of Period';
            OptionMembers = "Accrual Till Date","End of Period";
            DataClassification = CustomerContent;
        }
        field(300; "Allow Negative"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(350; "Roll Over Period"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Accrual ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Accrual ID" = '' then begin
            AdvancePayrollSetup.GET;
            AdvancePayrollSetup.TESTFIELD("Accrual Nos.");
            "Accrual ID" := NoSeriesMngmnt.GetNextNo(AdvancePayrollSetup."Accrual Nos.", TODAY, true);
        end;
    end;

    var
        AdvancePayrollSetup: Record "Advance Payroll Setup";
        NoSeriesMngmnt: Codeunit NoSeriesManagement;
}