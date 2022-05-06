page 60003 "Idetification DocType List"
{
    Caption = 'Identification Type Master';
    UsageCategory = Lists;
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Identification Doc Type Master";
    SourceTableView = SORTING(Code) ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Maintain Document Type"; Rec."Maintain Document Type")
                {
                    ApplicationArea = All;
                }
                field("Required For Visa Request"; Rec."Required For Visa Request")
                {
                    ApplicationArea = All;
                }
                field("Documents Expiry Notification"; Rec."Documents Expiry Notification")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}