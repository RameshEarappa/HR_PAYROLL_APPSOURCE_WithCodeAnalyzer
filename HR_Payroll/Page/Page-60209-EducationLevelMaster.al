page 60209 "Education Level Master"
{
    PageType = List;
    SourceTable = "Education Level Master";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Level Code"; Rec."Level Code")
                {
                    ApplicationArea = All;
                }
                field("Level Description"; Rec."Level Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}