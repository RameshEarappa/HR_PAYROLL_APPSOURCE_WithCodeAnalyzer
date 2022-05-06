page 60278 "Region Master"
{
    PageType = List;
    SourceTable = Region;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Region Code"; Rec."Region Code")
                {
                    ApplicationArea = all;
                }
                field("Region Name"; Rec."Region Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}