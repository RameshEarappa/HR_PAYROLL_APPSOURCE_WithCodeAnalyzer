page 60355 "Sub Department"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sub Department";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Department ID"; Rec."Department ID")
                {
                    ApplicationArea = All;
                }
                field("Sub Department ID"; Rec."Sub Department ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}