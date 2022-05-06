table 60018 Initials
{
    Caption = 'Initials';
    LookupPageID = Initials;
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Initials Code"; Code[20])
        {
            Caption = 'Initials Code';
            DataClassification = CustomerContent;
        }
        field(2; Initials; Text[30])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Initials Code")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        EmpRec.RESET;
        EmpRec.SETRANGE(Initials, "Initials Code");
        if EmpRec.FINDFIRST then
            ERROR(Error001);
    end;

    var
        EmpRec: Record Employee;
        Error001: Label 'Initials cannot be deleted.';
}