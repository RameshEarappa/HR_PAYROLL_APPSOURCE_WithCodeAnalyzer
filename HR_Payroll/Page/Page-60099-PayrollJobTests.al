page 60099 "Payroll Job Tests"
{
    PageType = List;
    SourceTable = "Payroll Job Test Type";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Test Type"; Rec."Test Type")
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