page 60068 "Pay Cycles"
{
    CardPageID = "Pay Cycle Card";
    PageType = List;
    SourceTable = "Pay Cycles";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Pay Cycle Frequency"; Rec."Pay Cycle Frequency")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}