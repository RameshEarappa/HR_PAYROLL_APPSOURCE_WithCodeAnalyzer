page 60137 "Interim Accruals Workers Subpg"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Employee Interim Accurals";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Opening Balance Unit"; Rec."Opening Balance Unit")
                {
                    ApplicationArea = All;
                }
                field("Opening Balance Amount"; Rec."Opening Balance Amount")
                {
                    ApplicationArea = All;
                }
                field("Carryforward Deduction"; Rec."Carryforward Deduction")
                {
                    ApplicationArea = All;
                }
                field("Monthly Accrual Units"; Rec."Monthly Accrual Units")
                {
                    ApplicationArea = All;
                }
                field("Monthly Accrual Amount"; Rec."Monthly Accrual Amount")
                {
                    ApplicationArea = All;
                }
                field("Adjustment Units"; Rec."Adjustment Units")
                {
                    ApplicationArea = All;
                }
                field("Adjustment Amount"; Rec."Adjustment Amount")
                {
                    ApplicationArea = All;
                }
                field("Leaves Consumed Units"; Rec."Leaves Consumed Units")
                {
                    ApplicationArea = All;
                }
                field("Leaves Consumed Amount"; Rec."Leaves Consumed Amount")
                {
                    ApplicationArea = All;
                }
                field("Carryforward Month"; Rec."Carryforward Month")
                {
                    ApplicationArea = All;
                }
                field("Closing Balance"; Rec."Closing Balance")
                {
                    ApplicationArea = All;
                }
                field("Closing Balance Amount"; Rec."Closing Balance Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}