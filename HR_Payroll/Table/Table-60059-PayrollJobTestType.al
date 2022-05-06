table 60059 "Payroll Job Test Type"
{
    DrillDownPageID = "Payroll Job Tests";
    LookupPageID = "Payroll Job Tests";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Test Type"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Test Type")
        {
            Clustered = true;
        }
    }
}

