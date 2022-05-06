page 60229 "Sector List"
{
    Caption = 'Sector List';
    CardPageID = "Sector Card";
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Sector;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sector ID"; Rec."Sector ID")
                {
                    ApplicationArea = All;
                }
                field("Sector Name"; Rec."Sector Name")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}