page 60233 "Loan Requests"
{
    CardPageID = "Loan Request";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Loan Request";
    SourceTableView = SORTING("Entry No.")
                      ORDER(Ascending);
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan Request ID"; Rec."Loan Request ID")
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
                field("Loan Type"; Rec."Loan Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field("Request Amount"; Rec."Request Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Number of Installments"; Rec."Number of Installments")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; Rec."Created Time")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Installment Created"; Rec."Installment Created")
                {
                    ApplicationArea = All;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("WorkFlow Status"; Rec."WorkFlow Status")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Text001: Label 'The approval process must be cancelled or completed to reopen this document.';
        LeaveRequestHeader: Record "Leave Request Header";
}