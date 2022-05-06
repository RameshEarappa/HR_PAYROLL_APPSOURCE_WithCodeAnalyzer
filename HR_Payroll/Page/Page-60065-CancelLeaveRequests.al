page 60065 "Cancel Leave Requests"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Cancel Leave Request";
    UsageCategory = Administration;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = GenOpenBoolG;
                field("Leave Request ID";
                Rec."Leave Request ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Personnel Number"; Rec."Personnel Number")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Start Day Type"; Rec."Leave Start Day Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("End Date"; Rec."End Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Days"; Rec."Leave Days")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave End Day Type"; Rec."Leave End Day Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Remarks"; Rec."Leave Remarks")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Submission Date"; Rec."Submission Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cancellation Remarks"; Rec."Cancel Remarks")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Submit For Approval")
            {
                Caption = 'Submit For Approval';
                Enabled = NOT OpenApprovalEntriesExist;
                ApplicationArea = All;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AdvanceWorkflowCUL: Codeunit "Advance Workflow";
                begin
                    CancelAndDeleteApprovalEntryTrans_LT(Rec.RecordId);
                    Rec.TESTFIELD("Workflow Status", Rec."Workflow Status"::Open);
                    if WfInitCod.IsLeaveCancel_Enabled(rec) then begin
                        LoopOfSeq_LT(Rec."Personnel Number", Rec."Leave Request ID");
                        WfInitCod.OnSendLeaveCancel_Approval(Rec);
                        AdvanceWorkflowCUL.DeleteExtraLine_ApprovalEntry_LT(Rec.RecordId);
                        AdvanceWorkflowCUL.LeaveRequest_SwapApprovalUser_Advance_LT(Rec.RecordId);
                        AdvanceWorkflowCUL.DeleteExtraLine_ApprovalEntry_LT(Rec.RecordId);

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
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Workflow Status", Rec."Workflow Status"::"Pending For Approval");
                    if Rec."Workflow Status" = Rec."Workflow Status"::Approved then
                        ERROR('You cannot cancel approved leaves');
                    WfInitCod.OnCancelLeaveCancel_Approval(Rec);
                    CancelAndDeleteApprovalEntryTrans_LT(Rec.RecordId);
                end;
            }
            action(Reopen)
            {
                Enabled = GenOpenBoolG;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    if Rec."Workflow Status" = Rec."Workflow Status"::"Pending For Approval" then
                        ERROR(Text001);
                    BlockPosting('Auto post Enable, you cannot reopen.');
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Enabled = PostBtnG;
                trigger OnAction()
                var
                    AdvancePayollSetupRecL: Record "Advance Payroll Setup"; // @mma0786
                begin
                    BlockPosting('Auto post Enable, you cannot post manually.');
                    Rec.TESTFIELD("Workflow Status", Rec."Workflow Status"::Approved);
                    Rec.PostLeaveCancel(CancelLeave);
                    Message('Leave Cancellation has been posted successfully.');
                end;
            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Promoted = true;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        AdvancePayollSetupRecL: Record "Advance Payroll Setup";
                    begin
                        AdvancePayollSetupRecL.Reset();
                        AdvancePayollSetupRecL.Get();
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                        Rec.TESTFIELD("Workflow Status", Rec."Workflow Status"::Approved);
                        if AdvancePayollSetupRecL."Auto Post Cancel Leave Request" then
                            Rec.PostLeaveCancel(CancelLeave);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';
                    Promoted = true;
                    PromotedCategory = Category4;
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
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Promoted = true;
                    PromotedCategory = Category4;

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
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    WfCodeU: Codeunit WFCode_LeaveCancelReq;

                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Cancel Leave Request");
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
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        Text001: Label 'The approval process must be cancelled or completed to reopen this document.';
        CancelLeave: Record "Cancel Leave Request";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WfInitCod: Codeunit InitCU_LeaveCancelReq;
        i: Integer;
        GenOpenBoolG: boolean;
        PostBtnG: Boolean;

    procedure BlockPosting(ErrTxt: Text[50])
    var
        AdvancePayrollSetupRecL: Record "Advance Payroll Setup";
    begin
        AdvancePayrollSetupRecL.Reset();
        if AdvancePayrollSetupRecL.Get() then;

        if AdvancePayrollSetupRecL."Auto Post Cancel Leave Request" then
            Error(ErrTxt);
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        AdvcePayrllSetupRecL: Record "Advance Payroll Setup";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

        if (Rec."Workflow Status" = Rec."Workflow Status"::Open) then
            GenOpenBoolG := true
        else
            GenOpenBoolG := false;

        AdvcePayrllSetupRecL.Reset();
        AdvcePayrllSetupRecL.Get();

        if NOT AdvcePayrllSetupRecL."Auto Post Cancel Leave Request" then
            PostBtnG := true
        else
            PostBtnG := false;
    end;

    procedure CreateDutyResumptionEntry()
    var
        Text00001: Label 'Duty Resumption Entries already exist';
    begin
    end;

    procedure InsertApprovalEntryTrans_LT(TransID: Code[30]; SenderID: Code[50]; ReportingID: Code[50]; DelegateID: Code[50]; SequenceID: Integer)
    var
        ApprovalEntrtyTranscationRec_L: Record "Approval Entrty Transcation";
    begin
        ApprovalEntrtyTranscationRec_L.RESET;
        ApprovalEntrtyTranscationRec_L.INIT;
        ApprovalEntrtyTranscationRec_L."Trans ID" := TransID;
        ApprovalEntrtyTranscationRec_L."Advance Payrolll Type" := ApprovalEntrtyTranscationRec_L."Advance Payrolll Type"::"Cancel Leave Requests";
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
        ApprovalLevelSetupRec_L.SETRANGE("Advance Payrolll Type", ApprovalLevelSetupRec_L."Advance Payrolll Type"::"Cancel Leave Requests");
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

    //Creating Manual Notfication because of Customization of Advanced WF
    local procedure GetEntryAprovalEntryTableCLR(CancelLeaveRequest: Record "Cancel Leave Request"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", CancelLeaveRequest."Leave Request ID");
        ApprovalEntry.SetRange("Record ID to Approve", CancelLeaveRequest.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Cancel Leave Request");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;

    local procedure CreateManulNotificationWF(CancelLeaveRequest: Record "Cancel Leave Request")
    var
        NotificationEntry: Record "Notification Entry";
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Get(GetEntryAprovalEntryTableCLR(CancelLeaveRequest));
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