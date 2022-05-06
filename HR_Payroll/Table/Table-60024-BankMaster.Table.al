table 60024 "Bank Master"
{
    LookupPageID = "Bank Master";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        }
        field(2; "Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
        }
        field(3; "Bank Name in Arabic"; Text[50])
        {
            Caption = 'Bank Name in Arabic';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Bank Code")
        {
            Clustered = true;
        }
        key(Key2; "Bank Name", "Bank Name in Arabic")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Bank Code", "Bank Name", "Bank Name in Arabic")
        {
        }
    }

    trigger OnDelete()
    var
        EmployeeBankAccountRecL: Record "Employee Bank Account";
    begin
        EmployeeBankAccountRecL.RESET;
        EmployeeBankAccountRecL.SETRANGE("Bank Code", "Bank Code");
        if EmployeeBankAccountRecL.FINDFIRST then
            ERROR('Bank Master details already assigned to Employees %1 , Cannot be Deleted.', EmployeeBankAccountRecL."Employee Id");
    end;
}