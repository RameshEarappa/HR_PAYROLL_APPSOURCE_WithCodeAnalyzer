table 60061 "Payroll Job Education"
{
    DrillDownPageID = "Payroll Job Education";
    LookupPageID = "Payroll Job Education";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Education Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Education Level"; Code[20])
        {
            TableRelation = "Education Level Master";
            DataClassification = CustomerContent;
        }
        field(4; "Education Stream"; Code[20])
        {
            TableRelation = "Education Stream";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Education Code")
        {
            Clustered = true;
        }
    }
}

