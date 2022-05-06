table 60106 "Marital Sstatus Option"
{
    LookupPageID = "Marital Status Option Page";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; Status; Text[30])
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Status, "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Status)
        {
        }
    }

    trigger OnDelete()
    begin
        EmpRec.RESET;
        EmpRec.SETRANGE("Marital Status", Status);
        if EmpRec.FINDFIRST then
            ERROR(Error001);
    end;

    var
        EmpRec: Record Employee;
        Error001: Label 'Marital Status cannot be Deleted.';
}