table 60057 "Payroll Job Certificate"
{
    DrillDownPageID = "Payroll Job Certificates";
    LookupPageID = "Payroll Job Certificates";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Certificate Type"; Code[20])
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
        key(Key1; "Certificate Type")
        {
            Clustered = true;
        }
    }
}