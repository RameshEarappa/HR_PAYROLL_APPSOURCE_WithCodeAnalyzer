page 60228 "Work Location"
{
    PageType = List;
    SourceTable = "Work Location";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Work Location Code"; Rec."Work Location Code")
                {
                    ApplicationArea = All;
                }
                field("Work Location Name"; Rec."Work Location Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}