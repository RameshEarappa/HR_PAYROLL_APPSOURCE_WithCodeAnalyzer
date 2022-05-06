table 60019 "Sub Department"
{
    LookupPageID = "Sub Department";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Department ID"; Code[20])
        {
            TableRelation = "Payroll Department";
            DataClassification = CustomerContent;
        }
        field(2; "Sub Department ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Department ID", "Sub Department ID")
        {
            Clustered = true;
        }
    }
}