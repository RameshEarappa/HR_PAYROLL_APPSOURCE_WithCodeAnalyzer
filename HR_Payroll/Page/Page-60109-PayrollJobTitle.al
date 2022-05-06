page 60109 "Payroll Job Title"
{
    PageType = List;
    SourceTable = "Payroll Job Title";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Title"; Rec."Job Title")
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