tableextension 60009 UserSetupExt extends "User Setup"
{
    fields
    {
        field(60000; "E-signature"; BLOB)
        {
            Caption = 'E-signature';
            Description = 'ALFA';
            SubType = Bitmap;
            DataClassification = CustomerContent;
        }
        field(60001; "Employee Id"; Code[20])
        {
            TableRelation = Employee."No.";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                UserSetupRecL: Record 91;
            begin
                UserSetupRecL.RESET;
                UserSetupRecL.SETRANGE("Employee Id", "Employee Id");
                IF UserSetupRecL.FINDFIRST THEN
                    ERROR(Text006, "Employee Id", UserSetupRecL."User ID");
            end;
        }
        field(60002; "HR Manager"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60003; Finances; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60004; "Profile ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Page Metadata" where(PageType = filter(RoleCenter));
        }
    }

    var
        Text006: Label 'Employee %1  Already assign in User %2 .';
}