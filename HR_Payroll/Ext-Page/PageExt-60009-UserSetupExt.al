pageextension 60009 UserSetupExt extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Employee Id"; Rec."Employee Id")
            {
                ApplicationArea = All;
            }
            field("HR Manager"; Rec."HR Manager")
            {
                ApplicationArea = All;
            }
            field(Finances; Rec.Finances)
            {
                ApplicationArea = All;
            }
            field("Profile ID"; Rec."Profile ID")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            group("E-signatures")
            {
                Caption = 'E-signature';
                Image = Register;
                Visible = false;
                action("E-signature")
                {
                    Caption = 'E-signature';
                    Image = UserCertificate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                }
            }
        }
    }
}