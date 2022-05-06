table 60083 "Insurance Category"
{
    LookupPageId = "Insurance Category";
    DrillDownPageId = "Insurance Category";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Insurance Category Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; Active; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Insurance Category Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Insurance Category Code", Description, Active)
        {
        }
    }
}