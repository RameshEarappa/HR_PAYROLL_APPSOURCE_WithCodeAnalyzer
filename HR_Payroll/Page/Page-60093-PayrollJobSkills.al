page 60093 "Payroll Job Skills"
{
    PageType = List;
    SourceTable = "Payroll Job Skill Master";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Skill ID"; Rec."Skill ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Skill Type"; Rec."Skill Type")
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