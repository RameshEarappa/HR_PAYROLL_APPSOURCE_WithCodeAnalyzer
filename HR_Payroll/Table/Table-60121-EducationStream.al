table 60121 "Education Stream"
{
    LookupPageID = "Education Stream";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Stream Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Stream Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Stream Code")
        {
            Clustered = true;
        }
    }
}