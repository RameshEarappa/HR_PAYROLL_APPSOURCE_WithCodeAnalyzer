table 60087 "Employee Interim Accurals"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Worker ID"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; Month; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Opening Balance Unit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Opening Balance Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Carryforward Deduction"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Monthly Accrual Units"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Monthly Accrual Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Adjustment Units"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Adjustment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Leaves Consumed Units"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Leaves Consumed Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Closing Balance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Carryforward Month"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Max Carryforward"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Accrual ID"; Code[20])
        {
            TableRelation = "Accrual Components";
            DataClassification = CustomerContent;
        }
        field(19; "Accrual Basis Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Accrual Interval Basis Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Seq No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Closing Balance Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Accrual ID", "Worker ID", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Month, "Seq No")
        {
        }
    }
}