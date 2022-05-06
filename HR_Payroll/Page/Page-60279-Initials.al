page 60279 Initials
{
    PageType = List;
    SourceTable = Initials;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Initials Code"; Rec."Initials Code")
                {
                    ApplicationArea = all;
                }
                field(Initials; Rec.Initials)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}