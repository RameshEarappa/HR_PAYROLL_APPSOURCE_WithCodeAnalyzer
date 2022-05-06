page 60180 "Loan Adjustments"
{
    CardPageID = "Loan Adjustment";
    Caption = 'Loan Adjustment';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Loan Adjustment Header";
    SourceTableView = SORTING("Loan Adjustment ID") ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Adjustment ID"; Rec."Loan Adjustment ID")
                {
                    ApplicationArea = All;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Adjustment Type"; Rec."Adjustment Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    ApplicationArea = All;
                }
                field("Loan Request ID"; Rec."Loan Request ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}