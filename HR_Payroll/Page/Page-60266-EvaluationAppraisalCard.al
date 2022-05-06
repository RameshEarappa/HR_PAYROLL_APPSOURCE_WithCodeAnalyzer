page 60266 "Evaluation Appraisal Card"
{
    PageType = Card;
    SourceTable = "Evaluation Appraisal Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Performance ID"; Rec."Performance ID")
                {
                    ApplicationArea = All;
                }
                field("Date of Review"; Rec."Date of Review")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                }
                field("Line Manager"; Rec."Line Manager")
                {
                    ApplicationArea = All;
                }
                field("Date of Join"; Rec."Date of Join")
                {
                    ApplicationArea = All;
                }
                field("Document Created"; Rec."Document Created")
                {
                    ApplicationArea = All;
                }
                field("Evalutation Agree"; Rec."Evalutation Agree")
                {
                    ApplicationArea = All;
                }
                field("Workflow status"; Rec."Workflow status")
                {
                    ApplicationArea = All;
                }
            }
            group("Comments By Manager")
            {

                field("Final Comments By Manager"; Rec."Final Comments By Manager")
                {
                    ApplicationArea = All;
                    Editable = HRBooleanG;
                    MultiLine = true;
                }
                field("Final Comments By HR"; Rec."Final Comments By HR")
                {
                    ApplicationArea = All;
                    Editable = HRBooleanG;
                    MultiLine = true;
                }
            }
            part("Evaluation Appraisal Subform"; "Evaluation Appraisal Subform")
            {
                ApplicationArea = All;
                Editable = ListPageBoolG;
                SubPageLink = "Performance ID" = FIELD("Performance ID"),
                              "Employee Code" = FIELD("Employee Code");
            }
            part("Factor Rating Scale"; "Factor Rating Scale")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        EvaluationAppraisalLine: Record "Evaluation Appraisal Line";
                    begin
                        Rec.TESTFIELD("Date of Review");
                        Rec.TESTFIELD("Employee Code");
                        Rec.TESTFIELD("Document Created");
                        Rec.TESTFIELD("Employee Code");

                        EvaluationAppraisalLine.RESET;
                        EvaluationAppraisalLine.SETRANGE("Performance ID", Rec."Performance ID");
                        EvaluationAppraisalLine.SETRANGE("Employee Code", Rec."Employee Code");
                        EvaluationAppraisalLine.SETRANGE(IndentationColumn, 2);
                        if EvaluationAppraisalLine.FINDSET then
                            repeat
                                if EvaluationAppraisalLine."Evaluation Rating" <= 0 then
                                    ERROR(Text0001, EvaluationAppraisalLine."Performance Appraisal Type", EvaluationAppraisalLine."Rating Factor Description");
                            until EvaluationAppraisalLine.NEXT = 0;

                        CurrPage.UPDATE;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = Rec."Workflow Status" = Rec."Workflow Status"::"Pending Approval";
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = Rec."WorkFlow Status" <> Rec."WorkFlow Status"::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction();
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        if Rec."Workflow status" = Rec."Workflow status"::"Pending Approval" then
                            ERROR('WorkFlow status should be Approved for reopen');

                        Rec."Workflow status" := Rec."Workflow status"::Open;
                        CurrPage.UPDATE;
                    end;
                }
            }
            group("Approval Entry")
            {
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction();
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntry.RESET;
                        ApprovalEntry.SETRANGE("Document No.", Rec."Performance ID");
                        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Evaluation Appraisal Header");
                        if ApprovalEntry.FINDSET then
                            PAGE.RUNMODAL(658, ApprovalEntry);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SetControlVisibility;
    end;

    trigger OnOpenPage();
    begin
        HRBooleanG := true;
        ListPageBoolG := true;
        SetControlVisibility;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ApprovalEntry: Record "Approval Entry";
        EvaluationAppraisalLine: Record "Evaluation Appraisal Line";
        HRBooleanG: Boolean;
        UserSetupRecG: Record "User Setup";
        ActiveSessionRecG: Record "Active Session";
        ListPageBoolG: Boolean;
        Text0001: Label 'Evaluation Rating Must have value in  for \ Appraisal Type  : "  %1 "   \  Rating Factor :  " %2  ".';

    local procedure SetControlVisibility();
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        TicketingToolsHeaderRecL: Record "Loan Adjustment Header";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
    end;
}