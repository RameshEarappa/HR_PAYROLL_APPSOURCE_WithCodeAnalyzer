table 60077 "Insurance Service Provider"
{
    Caption = 'Insurance Service Provider';
    LookupPageId = "Insurance Servicec Prov. List";
    DrillDownPageId = "Insurance Servicec Prov. List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Insurance Provider Code"; Code[20])
        {
            Caption = 'Insurance Service Provider Code';
            Description = 'Insurance Service Provider Code';
            DataClassification = CustomerContent;
        }
        field(2; "Insurance Service Provider"; Text[50])
        {
            Caption = 'Insurance Service Provider';
            DataClassification = CustomerContent;
        }
        field(3; Address; Text[50])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(4; "Contact Person"; Text[50])
        {
            Caption = 'Contact Person';
            DataClassification = CustomerContent;
        }
        field(5; Email; Text[50])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
        }
        field(6; Telephone; Text[50])
        {
            Caption = 'Telephone';
            DataClassification = CustomerContent;
        }
        field(7; Website; Text[50])
        {
            Caption = 'Website';
            DataClassification = CustomerContent;
        }
        field(8; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
        }
        field(9; "Insurance Type"; Text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Insurance Provider Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Insurance Provider Code", "Insurance Service Provider", Active)
        {
        }
    }
}