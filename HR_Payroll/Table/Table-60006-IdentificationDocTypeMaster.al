table 60006 "Identification Doc Type Master"
{
    Caption = 'Identification Doc Type Master';
    LookupPageID = "Idetification DocType List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TESTFIELD(Code);
            end;
        }
        field(3; "Maintain Document Type"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Required For Visa Request"; Boolean)
        {
            Description = '#Visa&IqamaProcess';
            DataClassification = CustomerContent;
        }
        field(5; "Documents Expiry Notification"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        IdentificationMaster.RESET;
        IdentificationMaster.SETRANGE("Identification Type", Code);
        if IdentificationMaster.FINDFIRST then
            ERROR('Identification Document Type cannot be deleted.');
    end;

    var
        IdentificationMaster: Record "Identification Master";
}