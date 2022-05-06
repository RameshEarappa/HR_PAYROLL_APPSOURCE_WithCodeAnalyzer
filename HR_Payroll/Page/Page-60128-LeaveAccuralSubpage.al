page 60128 "Leave Accural Subpage"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Accrual Component Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Interval Month Start"; Rec."Interval Month Start")
                {
                    ApplicationArea = All;
                }
                field("Interval Month End"; Rec."Interval Month End")
                {
                    ApplicationArea = All;
                }
                field("Accrual Units Per Month"; Rec."Accrual Units Per Month")
                {
                    ApplicationArea = All;
                }
                field("Opening Additional Accural"; Rec."Opening Additional Accural")
                {
                    ApplicationArea = All;
                }
                field("Max Carry Forward"; Rec."Max Carry Forward")
                {
                    ApplicationArea = All;
                }
                field("CarryForward Lapse After Month"; Rec."CarryForward Lapse After Month")
                {
                    ApplicationArea = All;
                }
                field("Repeat After Months"; Rec."Repeat After Months")
                {
                    ApplicationArea = All;
                }
                field("Avail Allow Till"; Rec."Avail Allow Till")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

