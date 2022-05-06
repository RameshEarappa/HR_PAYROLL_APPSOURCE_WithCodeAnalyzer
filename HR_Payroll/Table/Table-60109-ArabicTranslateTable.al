table 60109 "Arabic Translate Table"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Eng Code"; Code[150])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Arabic Text"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Eng Code")
        {
            Clustered = true;
        }
    }
}

