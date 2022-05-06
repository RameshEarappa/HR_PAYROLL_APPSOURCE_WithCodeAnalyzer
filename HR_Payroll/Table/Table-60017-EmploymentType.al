table 60017 "Employment Type"
{
    Caption = 'Employment Type';
    LookupPageID = "Employment Type";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employment Type ID"; Code[20])
        {
            Caption = 'Employnment Type ID';
            DataClassification = CustomerContent;
        }
        field(2; "Employment Type"; Text[30])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Employment Type ID", "Employment Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(group; "Employment Type ID", "Employment Type")
        {
        }
    }

    trigger
   OnDelete()
    var
        EmployeRecL: Record Employee;
    begin
        EmployeRecL.Reset();
        EmployeRecL.SetRange("Employment Type", "Employment Type ID");
        if EmployeRecL.FindFirst() then
            Error('Employment Type already attached to a position, cannot be deleted. ');
    end;
}