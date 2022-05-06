table 60135 Region
{
    Caption = 'Region';
    LookupPageID = "Region Master";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Region Code"; Code[20])
        {
            Caption = 'Region Code';
            DataClassification = CustomerContent;
        }
        field(2; "Region Name"; Text[50])
        {
            Caption = 'Region Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Region Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Region Code", "Region Name")
        {
        }
    }

    trigger OnDelete()
    begin
        EmployeeRec_G.RESET;
        EmployeeRec_G.SETRANGE(Region, "Region Code");
        IF EmployeeRec_G.FINDFIRST THEN
            ERROR('Region cannot be deleted while dependent employee exist. Cannot delete.');
    end;

    var
        EmployeeRec_G: Record Employee;
}