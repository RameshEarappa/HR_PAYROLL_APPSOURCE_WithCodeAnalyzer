table 60090 "Seperation Master"
{
    DrillDownPageID = "Seperation List";
    LookupPageID = "Seperation List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Seperation Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Seperation Reason"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Sepration Reason Code"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Seperation Code", "Seperation Reason")
        {
            Clustered = true;
        }
    }
}