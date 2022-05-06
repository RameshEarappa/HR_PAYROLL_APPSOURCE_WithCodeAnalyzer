table 60097 "Leave Encashment"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Journal ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Leave Encashment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Leave Units"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Journal ID", "Employee No.")
        {
            Clustered = true;
        }
    }
}