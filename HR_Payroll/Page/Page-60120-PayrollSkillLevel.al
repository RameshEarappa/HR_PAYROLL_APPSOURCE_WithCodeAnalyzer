page 60120 "Payroll Skill Level"
{
    PageType = List;
    SourceTable = "Payroll Skill Level";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Level ID"; Rec."Level ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}