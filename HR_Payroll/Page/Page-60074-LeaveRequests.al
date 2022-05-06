page 60074 "Leave Requests"
{
    Caption = 'Leave Request List';
    CardPageID = "Leave Request Card";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Leave Request Header";
    UsageCategory = Lists;
    ApplicationArea = All;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Leave Request ID"; Rec."Leave Request ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Personnel Number"; Rec."Personnel Number")
                {
                    Caption = 'Employee ID';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Short Name"; Rec."Short Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Leave Description';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Start Day Type"; Rec."Leave Start Day Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Days"; Rec."Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Leave End Day Type"; Rec."Leave End Day Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Leave Remarks"; Rec."Leave Remarks")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Cover Resource"; Rec."Cover Resource")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Submission Date"; Rec."Submission Date")
                {
                    ApplicationArea = All;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Cancelled"; Rec."Leave Cancelled")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Planner ID"; Rec."Leave Planner ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Resumption Type"; Rec."Resumption Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Resumption Date"; Rec."Resumption Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Net Leave Days"; Rec."Net Leave Days")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Duty Resumption Request"; Rec."Duty Resumption Request")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Enabled = NOT OpenApprovalEntriesExist;
                Image = SendApprovalRequest;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    LeaveRequestCardPage_G.CancelAndDeleteApprovalEntryTrans_LT(rec.RecordId);
                    Rec.TESTFIELD(Posted, false);
                    if not CONFIRM('Do you want to Submit the leave request?') then
                        exit;

                    CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                    if LeaveRequestHeader.FINDFIRST then begin
                        Rec.SubmitLeave(LeaveRequestHeader);
                        Rec.TESTFIELD(Posted, false);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Enabled = CanCancelApprovalForRecord;
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                    if LeaveRequestHeader.FINDFIRST then begin
                        if LeaveRequestHeader."Workflow Status" = LeaveRequestHeader."Workflow Status"::Released then
                            ERROR('You cannot cancel approved leaves');
                        LeaveRequestCardPage_G.CancelAndDeleteApprovalEntryTrans_LT(rec.RecordId);
                    end;
                end;
            }
            action(Reopen)
            {
                Enabled = ReopenBoolG;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                    if LeaveRequestHeader.FINDFIRST then begin
                        if LeaveRequestHeader."Workflow Status" = LeaveRequestHeader."Workflow Status"::"Pending For Approval" then
                            ERROR(Text001);

                        LeaveRequestHeader.TESTFIELD(Posted, false);
                        Rec.Reopen(LeaveRequestHeader);
                    end;
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Enabled = EnableLeavePost;
                ApplicationArea = All;
                Image = Post;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Workflow Status", Rec."Workflow Status"::Released);
                    if not CONFIRM('Do you want to post the leave request?') then
                        exit;

                    CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                    if LeaveRequestHeader.FINDFIRST then begin
                        LeaveRequestHeader.TESTFIELD("Workflow Status", Rec."Workflow Status"::Released);
                        Rec.TESTFIELD(Posted, false);
                        Rec.PostLeave(LeaveRequestHeader);
                    end;
                end;
            }
            group(Resumption)
            {
                Caption = 'Resumption';
                action("Duty Resumption")
                {
                    Caption = 'Duty Resumption';
                    Enabled = DutyResumeEdit;
                    ApplicationArea = All;
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Posted, true);
                        CreateDutyResumptionEntry;
                    end;
                }
                action("Late Resumption")
                {
                    Caption = 'Late Resumption';
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;
                    Visible = false;
                }
                action("On Time Resumption")
                {
                    Caption = 'On Time Resumption';
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnAction()
                    begin
                        if not CONFIRM('Do you want to Update On Time Resumption?') then
                            exit;

                        CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                        Rec.UpdateOntimeResumption;
                    end;
                }
            }
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
                    Enabled = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
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

                    trigger OnAction()
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

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility;
    end;

    var
        DutyResume: Record "Duty Resumption";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        P_DutyResume: Page "Duty Resumption";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        Text001: Label 'The approval process must be cancelled or completed to reopen this document.';
        LeaveRequestHeader: Record "Leave Request Header";
        EnableLeavePost: Boolean;
        EditLeaveRequest: Boolean;
        [InDataSet]
        DutyResumeEdit: Boolean;
        LeaveRequestCardPage_G: Page "Leave Request Card";
        ReopenBoolG: Boolean;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        if Rec.Posted then
            EnableLeavePost := false
        else
            EnableLeavePost := true;


        if Rec."Leave Request ID" <> '' then begin
            if (Rec."Workflow Status" = Rec."Workflow Status"::Open) or (Rec."Workflow Status" = Rec."Workflow Status"::Open) then
                EditLeaveRequest := true
            else
                EditLeaveRequest := false;
        end;

        if (Rec."Duty Resumption Request") or (Rec."Duty Resumption ID" <> '') then
            DutyResumeEdit := false
        else
            DutyResumeEdit := true;

        if Rec."Workflow Status" <> Rec."Workflow Status"::Open then
            ReopenBoolG := true
        else
            ReopenBoolG := false;
    end;

    procedure CreateDutyResumptionEntry()
    var
        Text00001: Label 'Duty Resumption Entries already exist';
    begin
        DutyResume.RESET;
        if not DutyResume.GET(Rec."Leave Request ID") then begin
            DutyResume.INIT;
            DutyResume.VALIDATE("Leave Request ID", Rec."Leave Request ID");
            DutyResume.VALIDATE("Personnel Number", Rec."Personnel Number");
            DutyResume.VALIDATE("Start Date", Rec."Start Date");
            DutyResume.VALIDATE("End Date", Rec."End Date");
            DutyResume.VALIDATE("Leave Type", Rec."Leave Type");
            DutyResume.INSERT(true);
        end;
        CLEAR(P_DutyResume);
        CLEAR(DutyResume);
        DutyResume.SETRANGE("Leave Request ID", Rec."Leave Request ID");
        if DutyResume.FINDFIRST then begin
            Rec.FILTERGROUP(2);
            P_DutyResume.SETTABLEVIEW(DutyResume);
            P_DutyResume.RUN;
            Rec.FILTERGROUP(0);
        end;
    end;
}