table 60084 "Accrual Components Employee"
{
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
        }
        field(3; "Accrual Interval Basis"; Option)
        {
            OptionCaption = ' ,Fixed,Employee Joining Date,Probation End/Confirm,Original Hire Date,Define Per Employee';
            OptionMembers = " ","Fixed","Employee Joining Date","Probation End/Confirm","Original Hire Date","Define Per Employee";
            DataClassification = CustomerContent;
        }
        field(4; "Accrual Frequency"; Option)
        {
            OptionCaption = ' ,Daily,Weekly,Monthly,Annually';
            OptionMembers = " ",Daily,Weekly,Monthly,Annually;
            DataClassification = CustomerContent;
        }
        field(5; "Accrual Policy Enrollment"; Option)
        {
            OptionCaption = ' ,Prorated,Full Accural,No Accural';
            OptionMembers = " ",Prorated,"Full Accural","No Accural";
            DataClassification = CustomerContent;
        }
        field(6; "Accrual Award Date"; Option)
        {
            OptionCaption = ' ,Accural Period Start,Accural Period End';
            OptionMembers = " ","Accural Period Start","Accural Period End";
            DataClassification = CustomerContent;
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
        field(11; "Worker ID"; Code[20])
        {
            TableRelation = Employee;
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
        field(301; "Carryforward Date"; Date)
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
        key(Key1; "Accrual ID", "Worker ID")
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