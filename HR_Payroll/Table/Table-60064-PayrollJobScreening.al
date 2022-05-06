table 60064 "Payroll Job Screening"
{
    DrillDownPageID = "Payroll Job Screening";
    LookupPageID = "Payroll Job Screening";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Screening Type"; Code[20])
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
        key(Key1; "Screening Type")
        {
            Clustered = true;
        }
    }
}