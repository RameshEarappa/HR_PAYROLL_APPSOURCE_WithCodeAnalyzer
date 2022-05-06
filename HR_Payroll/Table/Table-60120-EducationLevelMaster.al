table 60120 "Education Level Master"
{
    LookupPageID = "Education Level Master";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Level Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Level Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Level Code")
        {
            Clustered = true;
        }
    }
}