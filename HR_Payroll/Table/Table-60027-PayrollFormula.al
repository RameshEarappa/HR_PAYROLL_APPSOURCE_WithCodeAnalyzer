table 60027 "Payroll Formula"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Formula Key"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Formula description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Formula Key Type"; Option)
        {
            OptionCaption = 'Parameter,Pay Component,Benefit,Leave Type,Custom';
            OptionMembers = Parameter,"Pay Component",Benefit,"Leave Type",Custom;
            DataClassification = CustomerContent;
        }
        field(4; Formula; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Short Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Formula Key")
        {
            Clustered = true;
        }
        key(Key2; "Short Name")
        {
        }
        key(Key3; "Formula Key Type")
        {
        }
        key(Key4; "Short Name", "Formula Key Type")
        {
        }
    }
}