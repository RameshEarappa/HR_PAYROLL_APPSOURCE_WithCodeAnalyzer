page 60104 "Payroll Job Screening"
{
    PageType = List;
    SourceTable = "Payroll Job Screening";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Screening Type"; Rec."Screening Type")
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