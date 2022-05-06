page 60166 "Levtech #WF"
{
    PageType = List;
    SourceTable = "Approval Entry";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
                field("Approval Code"; Rec."Approval Code")
                {
                    ApplicationArea = All;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = All;
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ApplicationArea = All;
                }
                field("Available Credit Limit (LCY)"; Rec."Available Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Pending Approvals"; Rec."Pending Approvals")
                {
                    ApplicationArea = All;
                }
                field("Record to Approve ID"; FORMAT(Rec."Record ID to Approve", 0, 1))
                {
                    ApplicationArea = All;
                }
                field("Delegation Date Formula"; Rec."Delegation Date Formula")
                {
                    ApplicationArea = All;
                }
                field("Number of Approved Requests"; Rec."Number of Approved Requests")
                {
                    ApplicationArea = All;
                }
                field("Number of Rejected Requests"; Rec."Number of Rejected Requests")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Workflow Step Instance ID"; Rec."Workflow Step Instance ID")
                {
                    ApplicationArea = All;
                }
                field("Related to Change"; Rec."Related to Change")
                {
                    ApplicationArea = All;
                }
                field("Advance Date"; Rec."Advance Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Delete Approval Entrty Transcation Record")
            {
                Image = Delete;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ApprovalEntrtyTranscation: Record "Approval Entrty Transcation";
                begin
                    ApprovalEntrtyTranscation.Reset();
                    ApprovalEntrtyTranscation.DeleteAll();
                end;
            }
        }
    }
}

