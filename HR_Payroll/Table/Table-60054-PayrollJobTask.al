table 60054 "Payroll Job Task"
{
    DrillDownPageID = "Payroll Job Tasks";
    LookupPageID = "Payroll Job Tasks";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Job Task ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Note; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Job Task ID")
        {
            Clustered = true;
        }
    }
}

