page 60213 "Bank Master"
{
    PageType = List;
    SourceTable = "Bank Master";
    Caption = 'Bank Master List';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = ALL;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = ALL;
                }
                field("Bank Name in Arabic"; Rec."Bank Name in Arabic")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}

