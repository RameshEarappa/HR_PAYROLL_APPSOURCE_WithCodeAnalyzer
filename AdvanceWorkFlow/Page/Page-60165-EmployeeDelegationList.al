page 60165 "Employee Delegation List"
{
    PageType = List;
    SourceTable = "Delegate - WFLT";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Delegate No."; Rec."Delegate No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                }
                field("Delegate To"; Rec."Delegate To")
                {
                    ApplicationArea = All;
                }
                field("Delegate ID"; Rec."Delegate ID")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

