page 60095 "Payroll Job Tasks"
{
    PageType = List;
    SourceTable = "Payroll Job Task";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Task ID"; Rec."Job Task ID")
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