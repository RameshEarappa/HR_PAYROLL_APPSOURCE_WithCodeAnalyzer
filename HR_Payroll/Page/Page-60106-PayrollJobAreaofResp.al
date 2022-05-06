page 60106 "Payroll Job Area of Resp."
{
    PageType = List;
    SourceTable = "Payroll Job Area Of Resp.";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Area of Responsibility"; Rec."Area of Responsibility")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}