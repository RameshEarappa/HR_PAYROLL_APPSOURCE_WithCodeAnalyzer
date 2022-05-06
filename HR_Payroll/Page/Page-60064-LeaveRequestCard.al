page 60064 "Leave Request Card"
{
    Caption = 'Leave Request';
    PageType = Card;
    SourceTable = "Leave Request Header";
    UsageCategory = Documents;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = GenBoolG;
                field("Leave Request ID"; Rec."Leave Request ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Personnel Number"; Rec."Personnel Number")
                {
                    Caption = 'Employee ID';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        LeaveType: Record "HCM Leave Types Wrkr";
                    begin
                        Valid_IsCompensatoryLeave_LT;
                        LeaveType.SetRange(Worker, Rec."Personnel Number");
                        LeaveType.SetRange("Leave Type Id", Rec."Leave Type");
                        if LeaveType.FindFirst() then begin
                            if LeaveType."Is Paternity Leave" then
                                IsperBool := true
                            else
                                if LeaveType."Adoption leave" then
                                    IsperBool := true
                                else
                                    IsperBool := false;
                        end;
                    end;
                }
                field("Short Name"; Rec."Short Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Dependent ID"; Rec."Dependent ID")
                {
                    ApplicationArea = All;
                    Editable = IsperBool;
                }
                field("Dependent Name"; Rec."Dependent Name")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        LeaveType: Record "HCM Leave Types Wrkr";
                    begin
                        Valid_IsCompensatoryLeave_LT;
                    end;
                }
                field("Leave Start Day Type"; Rec."Leave Start Day Type")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        LeaveType: Record "HCM Leave Types Wrkr";
                    begin
                        Valid_IsCompensatoryLeave_LT;
                    end;
                }
                field("Leave End Day Type"; Rec."Leave End Day Type")
                {
                    ApplicationArea = All;
                }
                field("Compensatory Leave Date"; Rec."Compensatory Leave Date")
                {
                    ApplicationArea = All;
                    Editable = CheckBoolG;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Entitlement Days"; Rec."Entitlement Days")
                {
                    ApplicationArea = ALl;
                    Enabled = false;
                }
                field("Consumed Leaves"; Rec."Consumed Leaves")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Alternative Start Date"; Rec."Alternative Start Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Leave Days"; Rec."Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Leave Remarks"; Rec."Leave Remarks")
                {
                    ApplicationArea = All;
                }
                field("Alternative End Date"; Rec."Alternative End Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(LTA; Rec.LTA)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Cover Resource"; Rec."Cover Resource")
                {
                    ApplicationArea = All;
                }
                field("Submission Date"; Rec."Submission Date")
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
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                group("Resumption Details")
                {
                    Caption = 'Resumption Details';
                    field("Resumption Date"; Rec."Resumption Date")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Resumption Type"; Rec."Resumption Type")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Duty Resumption Request"; Rec."Duty Resumption Request")
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Visible = false;
                    }
                    field("Net Leave Days"; Rec."Net Leave Days")
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Visible = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Request Approval")
            {
                Caption = 'Approvals';

                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Enabled = WorkFlowBoolG;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WfInitCode: Codeunit InitCodeunit_Leave_Request;
                        AdvanceWorkflowCUL: Codeunit "Advance Workflow";
                        Employee: Record Employee;
                        l_LeaveType: Record "HCM Leave Types Wrkr";
                    begin
                        Rec.TESTFIELD("Personnel Number");
                        Rec.TESTFIELD("Start Date");
                        Rec.TESTFIELD("End Date");
                        Rec.TESTFIELD(Posted, false);
                        Rec.TESTFIELD("Workflow Status", Rec."Workflow Status"::Open);
                        if CheckBoolG then
                            Rec.TestField("Compensatory Leave Date");
                        CheckAttachmentsIfAfterdat;

                        CancelAndDeleteApprovalEntryTrans_LT(Rec.RecordId);
                        Rec.TESTFIELD(Posted, false);
                        if not CONFIRM('Do you want to Submit the leave request?') then
                            exit;

                        if Rec."Leave Days" = 0 then
                            ERROR('Leave days cannot be zero');

                        l_LeaveType.Reset();
                        l_LeaveType.SetRange(Worker, Rec."Personnel Number");
                        l_LeaveType.SetRange("Leave Type Id", Rec."Leave Type");
                        if l_LeaveType.FindFirst() then;
                        Employee.GET(Rec."Personnel Number");
                        IF NOT (l_LeaveType.Gender = l_LeaveType.Gender::" ") THEN
                            IF l_LeaveType.Gender <> Employee.Gender THEN
                                ERROR('This leave is for Gender %1', l_LeaveType.Gender);

                        IF l_LeaveType."Marital Status" <> '' THEN
                            IF l_LeaveType."Marital Status" <> Employee."Marital Status" THEN
                                ERROR('This leave is only for employees with Marital Status %1', l_LeaveType."Marital Status");

                        IF l_LeaveType.Nationality <> '' THEN
                            IF l_LeaveType.Nationality <> Employee.Nationality THEN
                                ERROR('This leave %1 is only for %2 Nationality', Rec."Leave Type", l_LeaveType.Nationality);

                        IF l_LeaveType."Religion ID" <> '' THEN
                            IF l_LeaveType."Religion ID" <> Employee."Employee Religion" THEN
                                ERROR('This leave %1 can be applied only by the religion %2', Rec."Leave Type", l_LeaveType."Religion ID");

                        Rec.SubmitLeave(Rec);
                        if WfInitCode.Is_LeaveReq_Enabled(Rec) then begin
                            LoopOfSeq_LT(Rec."Personnel Number", Rec."Leave Request ID");

                            WfInitCode.OnSend_LeaveReq_Approval(Rec);
                            AdvanceWorkflowCUL.DeleteExtraLine_ApprovalEntry_LT(Rec.RecordId);
                            AdvanceWorkflowCUL.LeaveRequest_SwapApprovalUser_Advance_LT(Rec.RecordId);
                            AdvanceWorkflowCUL.DeleteExtraLine_ApprovalEntry_LT(Rec.RecordId);
                            CancelAndDeleteApprovalEntryTrans_LT(Rec.RecordId);

                            //Creating Manual Notfication because of Customization of Advanced WF
                            CreateManulNotificationWF(Rec);
                            //Stop Creating Manual Notfication
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
                    PromotedOnly = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        INitWf: Codeunit InitCodeunit_Leave_Request;
                        DutyResumption: Record "Duty Resumption";
                    begin
                        CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                        if LeaveRequestHeader.FINDFIRST then begin
                            if LeaveRequestHeader."Workflow Status" = LeaveRequestHeader."Workflow Status"::Released then
                                ERROR('You cannot cancel approved leaves');

                            DutyResumption.Reset();
                            DutyResumption.SetRange("Leave Request ID", Rec."Leave Request ID");
                            if DutyResumption.FindFirst() then
                                if (DutyResumption."Workflow Status" = DutyResumption."Workflow Status"::"Pending Approval") or (DutyResumption."Workflow Status" = DutyResumption."Workflow Status"::Released) then
                                    Error('You cannot cancel approved leaves');

                            INitWf.OnCancel_LeaveReq_Approval(rec);
                            CancelAndDeleteApprovalEntryTrans_LT(Rec.RecordId);
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
                        AdvancePayrollSetupRecG.Reset();
                        if AdvancePayrollSetupRecG.Get() then;
                        if AdvancePayrollSetupRecG."Auto Post Leave Request" then
                            Error('Auto post active you cannot Reopen this documents.');

                        if Rec."Workflow Status" = Rec."Workflow Status"::"Pending For Approval" then
                            ERROR(Text001);

                        if Rec."Workflow Status" = Rec."Workflow Status"::Rejected then
                            ERROR('You Cannot reopen Cancelled Leave request');
                        Rec.TESTFIELD(Posted, false);
                        Rec.Reopen(Rec);
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
                    var
                        LeaveRequestHeaderRecL: Record "Leave Request Header";
                    begin
                        if not CONFIRM('Do you want to post the leave request?') then
                            exit;

                        CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                        if LeaveRequestHeader.FINDFIRST then begin
                            if LeaveRequestHeader."Leave Days" = 0 then
                                ERROR('Leave days cannot be zero');
                            LeaveRequestHeader.TESTFIELD("Workflow Status", LeaveRequestHeader."Workflow Status"::Released); //21.20.2020
                            if LeaveRequestHeader.Posted then
                                ERROR('Leave request is already posted');
                            if not (LeaveRequestHeader."Workflow Status" = LeaveRequestHeader."Workflow Status"::Released) then
                                ERROR('Workflow Status must be Approved, Current value is %1', LeaveRequestHeader."Workflow Status");
                            LeaveRequestHeader.PostLeave(LeaveRequestHeader);
                        end;
                    end;
                }
            }
            action("Swap USer")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = SaveView;
                Visible = false;
                trigger OnAction()
                var
                    AdvanceWorkflowCUL: Codeunit "Advance Workflow";
                begin
                    AdvanceWorkflowCUL.LeaveRequest_SwapApprovalUser_Advance_LT(Rec.RecordId);
                end;
            }
            action("Attachment")
            {
                ApplicationArea = All;
                Image = Attachments;
                Promoted = true;
                Caption = 'Attachment';
                PromotedCategory = Process;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                trigger
                OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GETTABLE(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RUNMODAL;
                end;
            }

            group(Resumption)
            {
                Caption = 'Resumption';
                action("Dutys Resumption")
                {
                    Caption = 'Duty Resumption';
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Posted, true);
                        if Rec."Workflow Status" = Rec."Workflow Status"::Rejected then
                            ERROR('Leave Request is Cancelled, You cannot create duty resumption');
                        CreateDutyResumptionEntry;
                    end;
                }
                action("Duty Resumption")
                {
                    Caption = 'Duty Resumption';
                    Enabled = true;
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Posted, true);
                        if Rec."Workflow Status" = Rec."Workflow Status"::Rejected then
                            ERROR('Leave Request is Cancelled, You cannot create duty resumption');
                        CreateDutyResumptionEntry;
                    end;
                }
                action("On Time Resumption")
                {
                    Caption = 'On Time Resumption';
                    ApplicationArea = All;
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;
                    trigger OnAction()
                    begin
                        if not CONFIRM('Do you want to Update On Time Resumption?') then
                            exit;

                        CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                        Rec.UpdateOntimeResumption;
                    end;
                }

                action("Cancel Leave Request")
                {
                    Image = Cancel;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CancelLeaveRequest: Record "Cancel Leave Request";
                    begin
                        if Rec."Resumption Date" <> 0D then
                            ERROR('Cannot Cancel the Leave request,Duty Resumption created for this Leave');

                        Rec.TESTFIELD(Posted, true);
                        CancelLeaveRequest.RESET;
                        CancelLeaveRequest.SETRANGE("Leave Request ID", Rec."Leave Request ID");
                        if not CancelLeaveRequest.FINDFIRST then begin
                            if not CONFIRM('Do you want to Cancel the Leave Request ?', true) then
                                exit;
                            CancelLeaveRequest.INIT;
                            CancelLeaveRequest.TRANSFERFIELDS(Rec);
                            CancelLeaveRequest."Workflow Status" := CancelLeaveRequest."Workflow Status"::Open;
                            CancelLeaveRequest."Created Date" := WORKDATE;
                            CancelLeaveRequest."Created By" := USERID;
                            CancelLeaveRequest."Created Date Time" := CURRENTDATETIME;
                            CancelLeaveRequest."Submission Date" := 0D;

                            CancelLeaveRequest.INSERT;
                            COMMIT;
                        end;
                        PAGE.RUNMODAL(60065, CancelLeaveRequest);
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
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApprovalEntryRecL: Record "Approval Entry";
                        AdvaceSetup: Record "Advance Payroll Setup";
                    begin
                        AdvaceSetup.Reset();
                        AdvaceSetup.Get();
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                        ApprovalEntryRecL.Reset();
                        ApprovalEntryRecL.SetRange("Record ID to Approve", Rec.RecordId);
                        ApprovalEntryRecL.SetRange("Sequence No.", GetMaxApprovalSequanceNo());
                        ApprovalEntryRecL.SetRange(Status, ApprovalEntryRecL.Status::Approved);
                        if ApprovalEntryRecL.FindFirst() then begin
                            CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                            if LeaveRequestHeader.FINDFIRST then begin
                                if LeaveRequestHeader."Leave Days" = 0 then
                                    ERROR('Leave days cannot be zero');
                                if NOT AdvaceSetup."Auto Post Leave Request" then
                                    LeaveRequestHeader.TESTFIELD("Workflow Status", Rec."Workflow Status"::Released);
                                if LeaveRequestHeader.Posted then
                                    ERROR('Leave request is already posted');
                                if NOT AdvaceSetup."Auto Post Leave Request" then
                                    if not (LeaveRequestHeader."Workflow Status" = LeaveRequestHeader."Workflow Status"::Released) then
                                        ERROR('Workflow Status must be Approved, Current value is %1', LeaveRequestHeader."Workflow Status");
                                Rec.PostLeave(LeaveRequestHeader);
                            end;
                        end;
                    end;
                }

                action(Reject)
                {
                    ApplicationArea = All;

                    Caption = 'Reject';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
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
                    PromotedCategory = Process;
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
            action(Approvals)
            {
                AccessByPermission = TableData "Approval Entry" = R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Promoted = true;
                PromotedCategory = Category4;
                Image = Approvals;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Leave Request Header");
                    ApprovalEntry.SETRANGE("Record ID to Approve", Rec.RecordId);
                    ApprovalEntry.SETRANGE("Related to Change", FALSE);
                    PAGE.RUN(70010, ApprovalEntry);
                end;
            }
            action(Comments)
            {
                ApplicationArea = Suite;
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'View or add comments.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    RecRef: RecordRef;
                    ApprovalEntry: Record "Approval Entry";
                    RecID: RecordID;
                begin
                    RecRef.GET(Rec.RECORDID);
                    RecID := RecRef.RECORDID;
                    CLEAR(ApprovalsMgmt);
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", RecID.TABLENO);
                    ApprovalEntry.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    ApprovalEntry.SETRANGE("Related to Change", false);
                    if ApprovalEntry.FINDFIRST then
                        ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef, ApprovalEntry."Workflow Step Instance ID");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
        Valid_IsCompensatoryLeave_LT;
    end;


    trigger OnAfterGetCurrRecord()
    begin
        Valid_IsCompensatoryLeave_LT;
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility;
    end;

    var
        CheckBoolG: Boolean;
        IsperBool: Boolean;
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
        i: Integer;
        ShowRecCommentsEnabled: Boolean;
        AdvancePayrollSetupRecG: Record "Advance Payroll Setup";
        WorkFlowBoolG: Boolean;
        ReopenBoolG: Boolean;
        GenBoolG: Boolean;

    procedure Valid_IsCompensatoryLeave_LT()
    var
        LeaveType: Record "HCM Leave Types Wrkr";
    begin
        LeaveType.RESET;
        LeaveType.SETRANGE(Worker, Rec."Personnel Number");
        LeaveType.SETRANGE("Leave Type Id", Rec."Leave Type");
        LeaveType.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if LeaveType.FINDFIRST then begin
            if LeaveType."Is Compensatory Leave" then
                CheckBoolG := true
            else
                CheckBoolG := false;
        end;
    end;

    procedure CheckAttachmentsIfAfterdat()
    var
        LeaveType: Record "HCM Leave Types Wrkr";
        DocumentAttachment: Record "Document Attachment";
    begin
        LeaveType.RESET;
        LeaveType.SETRANGE(Worker, Rec."Personnel Number");
        LeaveType.SETRANGE("Leave Type Id", Rec."Leave Type");
        LeaveType.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if LeaveType.FINDFIRST then begin
            if LeaveType."Attachment Mandate" then begin
                if Rec."Leave Days" > LeaveType."Attachments After Days" then begin
                    DocumentAttachment.Reset();
                    DocumentAttachment.SetRange("No.", Rec."Leave Request ID");
                    DocumentAttachment.SetRange("Table ID", Database::"Leave Request Header");
                    if not DocumentAttachment.FindFirst() then
                        Error('Attachments required !');
                end;
            end;
        end;
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        AdvancePayrollSetupRecG.Reset();
        if AdvancePayrollSetupRecG.Get() then;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

        if (Rec.Posted) AND (AdvancePayrollSetupRecG."Auto Post Leave Request") then
            EnableLeavePost := false
        else
            EnableLeavePost := true;


        if Rec."Leave Request ID" <> '' then begin
            if (Rec."Workflow Status" = Rec."Workflow Status"::Open) or (Rec."Workflow Status" = Rec."Workflow Status"::Open) then
                EditLeaveRequest := true
            else
                EditLeaveRequest := false;
        end;

        if Rec."Duty Resumption Request" then
            DutyResumeEdit := false
        else
            DutyResumeEdit := true;

        Clear(WorkFlowBoolG);
        if (NOT OpenApprovalEntriesExist) AND (Rec."Workflow Status" = Rec."Workflow Status"::Open) then
            WorkFlowBoolG := true
        else
            WorkFlowBoolG := false;

        Clear(ReopenBoolG);
        if ((Rec."Workflow Status" <> Rec."Workflow Status"::Open) AND (NOT Rec.Posted)) then
            ReopenBoolG := true
        else
            ReopenBoolG := false;

        if (Rec."Workflow Status" <> Rec."Workflow Status"::Released) AND (Rec."Workflow Status" <> Rec."Workflow Status"::"Pending For Approval") then
            GenBoolG := true
        else
            GenBoolG := false;
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
            DutyResume.INSERT;
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

    procedure GetEmployeePostionEmployeeID_LT(EmployeeID: Code[30]): Code[50]
    var
        PayrollJobPosWorkerAssignRec_L: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRec_L: Record "Payroll Position";
    begin
        PayrollJobPosWorkerAssignRec_L.RESET;
        PayrollJobPosWorkerAssignRec_L.SETRANGE(Worker, EmployeeID);
        PayrollJobPosWorkerAssignRec_L.SETRANGE("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRec_L.FINDFIRST then begin
            PayrollPositionRec_L.RESET;
            PayrollPositionRec_L.SETRANGE("Position ID", PayrollJobPosWorkerAssignRec_L."Position ID");
            if PayrollPositionRec_L.FINDFIRST then
                exit(PayrollPositionRec_L.Worker);
        end;
    end;

    procedure InsertApprovalEntryTrans_LT(TransID: Code[30]; SenderID: Code[50]; ReportingID: Code[50]; DelegateID: Code[50]; SequenceID: Integer)
    var
        ApprovalEntrtyTranscationRec_L: Record "Approval Entrty Transcation";
    begin
        ApprovalEntrtyTranscationRec_L.RESET;
        ApprovalEntrtyTranscationRec_L.INIT;
        ApprovalEntrtyTranscationRec_L."Trans ID" := TransID;
        ApprovalEntrtyTranscationRec_L."Advance Payrolll Type" := ApprovalEntrtyTranscationRec_L."Advance Payrolll Type"::Leaves;
        ApprovalEntrtyTranscationRec_L."Employee ID - Sender" := SenderID;
        ApprovalEntrtyTranscationRec_L."Reporting ID - Approver" := ReportingID;
        ApprovalEntrtyTranscationRec_L."Delegate ID" := DelegateID;
        ApprovalEntrtyTranscationRec_L."Sequence No." := SequenceID;
        ApprovalEntrtyTranscationRec_L."Document RecordsID" := Rec.RecordId;
        ApprovalEntrtyTranscationRec_L.INSERT;
    end;

    procedure LoopOfSeq_LT(EmpID: Code[50]; TransID: Code[30])
    var
        ApprovalLevelSetupRec_L: Record "Approval Level Setup";
        UserSetupRec_L: Record "User Setup";
        UserSetupRec2_L: Record "User Setup";
        OneEmpID: Code[50];
        TwoEmpID: Code[50];
        ThreeEmpID: Code[50];
        PreEmpID: Code[50];
        SenderID_L: Code[50];
        ReportingID_L: Code[50];
        CountForLoop_L: Integer;
        Delegate_L: Code[80];
        SeqNo_L: Integer;
        IsFinalPos: Boolean;
    begin
        CLEAR(SenderID_L);
        CLEAR(ReportingID_L);
        CLEAR(OneEmpID);
        CLEAR(TwoEmpID);
        CLEAR(ThreeEmpID);
        CLEAR(Delegate_L);
        IsFinalPos := false;

        ApprovalLevelSetupRec_L.RESET;
        ApprovalLevelSetupRec_L.SETRANGE("Advance Payrolll Type", ApprovalLevelSetupRec_L."Advance Payrolll Type"::Leaves);
        if ApprovalLevelSetupRec_L.FINDFIRST then begin
            SenderID_L := EmpID;
            CountForLoop_L := ApprovalLevelSetupRec_L.Level;
            SeqNo_L := 0;
            for i := 1 to CountForLoop_L do begin
                ReportingID_L := GetEmployeePostionEmployeeID_LT(SenderID_L);
                if GetEmployeePostionEmployeeID_FinalPosituion_LT(SenderID_L) then begin
                    if (ReportingID_L = '') then begin
                        ReportingID_L := SenderID_L;
                        IsFinalPos := true;
                    end;
                    i := ApprovalLevelSetupRec_L.Level + 1;
                end;

                SeqNo_L += 1;
                if ReportingID_L = '' then
                    ERROR('Next level Approval Position Not Define');

                UserSetupRec_L.RESET;
                UserSetupRec_L.SETRANGE("Employee Id", SenderID_L);
                if not UserSetupRec_L.FINDFIRST then
                    ERROR('Employee Id  %1 must have a value in User Setup', SenderID_L);
                UserSetupRec_L.TESTFIELD("User ID");

                UserSetupRec2_L.RESET;
                UserSetupRec2_L.SETRANGE("Employee Id", ReportingID_L);
                if not UserSetupRec2_L.FINDFIRST then
                    ERROR('Employee Id  %1 must have a value in User Setup', ReportingID_L);
                UserSetupRec2_L.TESTFIELD("User ID");

                Delegate_L := CheckDelegateForEmployee_LT(ReportingID_L);


                if i <= ApprovalLevelSetupRec_L.Level then begin
                    InsertApprovalEntryTrans_LT(TransID,
                                                 UserSetupRec_L."User ID",
                                                 UserSetupRec2_L."User ID",
                                                 Delegate_L,
                                                 SeqNo_L);
                end else
                    if (GetEmployeePostionEmployeeID_FinalPosituion_LT(SenderID_L)) and (i > ApprovalLevelSetupRec_L.Level) then begin
                        InsertApprovalEntryTrans_LT(TransID,
                                                      UserSetupRec_L."User ID",
                                                      UserSetupRec2_L."User ID",
                                                      Delegate_L,
                                                      SeqNo_L);
                        IsFinalPos := true;
                    end;
                OneEmpID := SenderID_L;
                SenderID_L := ReportingID_L;
            end;
            if not IsFinalPos then
                IF ApprovalLevelSetupRec_L."Direct Approve By Finance" THEN BEGIN
                    IF ApprovalLevelSetupRec_L."Finance User ID" <> '' THEN BEGIN
                        CLEAR(Delegate_L);
                        IF CheckDelegateForEmployee_LT2(ApprovalLevelSetupRec_L."Finance User ID", 2) <> '' THEN
                            Delegate_L := CheckDelegateForEmployee_LT2(ApprovalLevelSetupRec_L."Finance User ID", 2)
                        ELSE
                            CLEAR(Delegate_L);

                        InsertApprovalEntryTrans_LT(TransID, UserSetupRec2_L."User ID", ApprovalLevelSetupRec_L."Finance User ID", Delegate_L, (SeqNo_L + 1));

                    END ELSE
                        IF ApprovalLevelSetupRec_L."Finance User ID 2" <> '' THEN BEGIN
                            CLEAR(Delegate_L);
                            IF CheckDelegateForEmployee_LT2(ApprovalLevelSetupRec_L."Finance User ID 2", 2) <> '' THEN
                                Delegate_L := CheckDelegateForEmployee_LT2(ApprovalLevelSetupRec_L."Finance User ID 2", 2)
                            ELSE
                                CLEAR(Delegate_L);

                            InsertApprovalEntryTrans_LT(TransID, UserSetupRec2_L."User ID", ApprovalLevelSetupRec_L."Finance User ID 2", Delegate_L, (SeqNo_L + 2));
                        END;
                END;
        end;
    end;

    procedure CheckDelegateForEmployee_LT2(checkDelegateInfo_P: Code[150]; IsEmployeeOrUser: Integer): Code[80]
    var
        DelegateWFLTRec_L: Record "Delegate - WFLT";
        UserSetupRecL: Record "User Setup";
    begin
        IF IsEmployeeOrUser = 1 THEN BEGIN
            DelegateWFLTRec_L.RESET;
            DelegateWFLTRec_L.SETRANGE("Employee Code", checkDelegateInfo_P);
            IF DelegateWFLTRec_L.FINDFIRST THEN BEGIN
                IF DelegateWFLTRec_L."Delegate ID" <> '' THEN
                    IF (DelegateWFLTRec_L."From Date" >= TODAY) AND (DelegateWFLTRec_L."To Date" <= TODAY) THEN
                        EXIT(DelegateWFLTRec_L."Delegate ID");
            END;
        END ELSE
            IF IsEmployeeOrUser = 2 THEN BEGIN
                UserSetupRecL.RESET;
                UserSetupRecL.SETRANGE("User ID", checkDelegateInfo_P);
                IF UserSetupRecL.FINDFIRST THEN
                    UserSetupRecL.TESTFIELD("Employee Id");

                DelegateWFLTRec_L.RESET;
                DelegateWFLTRec_L.SETRANGE("Employee Code", UserSetupRecL."Employee Id");
                IF DelegateWFLTRec_L.FINDFIRST THEN BEGIN
                    IF DelegateWFLTRec_L."Delegate ID" <> '' THEN BEGIN
                        IF (DelegateWFLTRec_L."From Date" <= TODAY) AND (DelegateWFLTRec_L."To Date" >= TODAY) THEN BEGIN
                            EXIT(DelegateWFLTRec_L."Delegate ID");
                        END
                    END;
                END;
            END;
    end;

    procedure CancelAndDeleteApprovalEntryTrans_LT(DocNo_P: RecordId)
    var
        ApprovalEntrtyTranscation: Record "Approval Entrty Transcation";
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntrtyTranscation.RESET;
        ApprovalEntrtyTranscation.SETRANGE("Document RecordsID", DocNo_P);
        if ApprovalEntrtyTranscation.FINDSET then begin
            ApprovalEntrtyTranscation.DELETEALL;
        end;
    end;

    procedure CheckDelegateForEmployee_LT(EmployeeCode_P: Code[30]): Code[80]
    var
        DelegateWFLTRec_L: Record "Delegate - WFLT";
    begin
        DelegateWFLTRec_L.RESET;
        DelegateWFLTRec_L.SETCURRENTKEY("Employee Code");
        DelegateWFLTRec_L.SETRANGE("Employee Code", EmployeeCode_P);
        if DelegateWFLTRec_L.FINDLAST then
            IF (DelegateWFLTRec_L."From Date" <= TODAY) AND (DelegateWFLTRec_L."To Date" >= TODAY) THEN begin
                EXIT(DelegateWFLTRec_L."Delegate ID");
            end;
    end;

    procedure GetEmployeePostionEmployeeID_FinalPosituion_LT(EmployeeID: Code[30]): Boolean
    var
        PayrollJobPosWorkerAssignRec_L: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRec_L: Record "Payroll Position";
    begin
        PayrollJobPosWorkerAssignRec_L.RESET;
        PayrollJobPosWorkerAssignRec_L.SETRANGE(Worker, EmployeeID);
        PayrollJobPosWorkerAssignRec_L.SETRANGE("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRec_L.FINDFIRST then begin
            PayrollPositionRec_L.RESET;
            PayrollPositionRec_L.SETRANGE("Position ID", PayrollJobPosWorkerAssignRec_L."Position ID");
            if PayrollPositionRec_L.FINDFIRST then
                if PayrollPositionRec_L."Final authority" then
                    exit(true)
                else
                    exit(false);
        end;
    end;

    procedure GetMaxApprovalSequanceNo(): Integer
    var
        ApprovalEntryRecL: Record "Approval Entry";
    begin
        ApprovalEntryRecL.Reset();
        ApprovalEntryRecL.SetCurrentKey("Entry No.");
        ApprovalEntryRecL.SetRange("Record ID to Approve", Rec.RecordId);
        ApprovalEntryRecL.Ascending(true);
        if ApprovalEntryRecL.FindLast() then
            exit(ApprovalEntryRecL."Sequence No.");
    end;

    //Creating Manual Notfication because of Customization of Advanced WF
    local procedure GetEntryAprovalEntryTableLR(LeaveRequest: Record "Leave Request Header"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", LeaveRequest."Leave Request ID");
        ApprovalEntry.SetRange("Record ID to Approve", LeaveRequest.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Leave Request Header");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;


    local procedure CreateManulNotificationWF(LeaveRequest: Record "Leave Request Header")
    var
        NotificationEntry: Record "Notification Entry";
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Get(GetEntryAprovalEntryTableLR(LeaveRequest));
        NotificationEntry.CreateNotificationEntry(
        NotificationEntry.Type::Approval,
        ApprovalEntry."Approver ID",
        ApprovalEntry,
        Page::"Approval Entries",
        GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Requests to Approve", ApprovalEntry, false),
                            ApprovalEntry."Sender ID");
    end;
    //Stop Creating Manual Notfication
}