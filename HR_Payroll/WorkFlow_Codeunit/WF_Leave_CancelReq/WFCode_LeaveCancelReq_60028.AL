codeunit 60028 WFCode_LeaveCancelReq
{
    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        Send_LeaveCancelReq: TextConst ENU = 'LT Approval Request for Leave Cancel is requested', ENG = 'LT Approval Request for Leave Cancel is requested';
        AppReq_LeaveCancel: TextConst ENU = 'LT Approval Request for Leave Cancel is approved', ENG = 'LT Approval Request for Leave Cancel is approved';
        RejReq_LeaveCancel: TextConst ENU = 'LT Approval Request for Leave Cancel is rejected', ENG = 'LT Approval Request for Leave Cancelis rejected';
        DelReq_LeaveCancel: TextConst ENU = 'LT Approval Request for Leave Cancel is delegated', ENG = 'LT Approval Request for Leave Cancel is delegated';
        SendForPendAppTxt: TextConst ENU = 'LT Status of Leave Cancel changed to Pending approval', ENG = 'LT Status of Leave Cancel changed to Pending approval';
        CancelForPendAppTxt: TextConst ENU = 'LT Approval Rquest for Leave Cancel is Canceled', ENG = 'LT Approval request for Leave Cancel is Canceled';
        Release_LeaveCancelTxt: TextConst ENU = 'LT ReleaseLeaveCancel', ENG = 'LT ReleaseLeaveCancel';
        ReOpen_LeaveCancelTxt: TextConst ENU = 'LT ReOpenLeaveCancel', ENG = 'LT ReOpenLeaveCancel';
        LeaveCancel_Message: TextConst ENU = 'LT LeaveCancelMessage', ENG = 'LT LeaveCancelMessage';
        LeaveCancelSend_Message: TextConst ENU = 'LT LeaveCancelSendMessage', ENG = 'LT LeaveCancelSendMessage';
        SendForRejectTxt: TextConst ENU = 'LT Status of Leave Cancel changed to Reject', ENG = 'LT Status of Leave Cancel changed to Reject';
        Send_LeaveCancelReject_LeaveCancelReq: TextConst ENU = 'LT Approval Request for Leave Cancel is Rejected', ENG = 'LT Approval Request for Leave Cancel is Rejected';

    //Events Subscribe Start
    //Send For Approval Event************************************************************************************ start
    procedure RunWorkflowOnSend_LeaveCancelApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_LeaveCancelApproval');
    end;

    procedure RunWorkflowOnSend_LeaveCancelRejectCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_LeaveCancelReject');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCU_LeaveCancelReq, 'OnSendLeaveCancel_Approval', '', true, true)]
    procedure RunWorkflowOnSend_LeaveCancelApproval(var LeaveCancelReq: Record "Cancel Leave Request")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSend_LeaveCancelApprovalCode, LeaveCancelReq);
    end;

    //Cancel For Approval Event************************************************************************************ End
    procedure RunWorkflowOnCancel_LeaveCancelApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnCancel_NEW_LeaveCancelApproval');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCU_LeaveCancelReq, 'OnCancelLeaveCancel_Approval', '', true, true)]
    procedure RunWorkflowOnCancel_LeaveCancelApproval(var LeaveCancelReq: Record "Cancel Leave Request")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancel_LeaveCancelApprovalCode, LeaveCancelReq);
    end;

    //Approve Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnApprove_LeaveCancelApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApprove_NEW_LeaveCancelApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    procedure RunWorkflowOnApprove_LeaveCancelApproval(var ApprovalEntry: Record "Approval Entry")
    var
        RequisitionRequestsRec: Record "Cancel Leave Request";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if not l_ApprovalEntry.FindLast then begin
            RequisitionRequestsRec.Reset();
            RequisitionRequestsRec.SetRange("Leave Request ID", ApprovalEntry."Document No.");
            if RequisitionRequestsRec.FindFirst() then begin
                RequisitionRequestsRec."WorkFlow Status" := RequisitionRequestsRec."WorkFlow Status"::Approved;
                RequisitionRequestsRec.Modify(true);
                RequisitionRequestsRec.PostLeaveCancel(RequisitionRequestsRec);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApprove_LeaveCancelApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    //Reject Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnReject_LeaveCancelApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnReject_NEW_LeaveCancelApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    procedure RunWorkflowOnReject_LeaveCancelApproval(var ApprovalEntry: Record "Approval Entry")
    var
        CanLeavRecRec: Record "Cancel Leave Request";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if l_ApprovalEntry.FindFirst() then begin
            CanLeavRecRec.Reset();
            CanLeavRecRec.SetRange(RecID, ApprovalEntry."Record ID to Approve");
            if CanLeavRecRec.FindFirst() then begin
                CanLeavRecRec."WorkFlow Status" := CanLeavRecRec."WorkFlow Status"::Rejected;
                CanLeavRecRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(SetStatusToReject_LT_Code_LeaveCancel(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    //Delegate Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnDelegate_LeaveCancelApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegate_LeaveCancelApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', true, true)]
    procedure RunWorkflowOnDelegate_LeaveCancelApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegate_LeaveCancelApprovalCode, ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Events Subscribe End

    //Code for changeing approval status Pending approval in Transfer Orders
    procedure SetStatusToPendingApprovalCode_LeaveCancel(): Code[128] // Done
    begin
        exit(UpperCase('SetStatusToPendingApproval_NEW_LeaveCancel'));
    end;

    procedure SetStatusToReject_LT_Code_LeaveCancel(): Code[128]
    begin
        exit(UpperCase('SetStatusToReject_LT__NEW_LeaveCancel'));
    end;

    procedure SetStatusToPendingApproval_LeaveCancel(var Variant: Variant)
    var
        RecRef: RecordRef;
        CanLeavRec: Record "Cancel Leave Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Cancel Leave Request":
                begin
                    RecRef.SetTable(CanLeavRec);
                    CanLeavRec.Validate("WorkFlow Status", CanLeavRec."WorkFlow Status"::"Pending For Approval");
                    CanLeavRec.Modify();
                    Variant := CanLeavRec;
                end;
        end;
    end;

    procedure SetStatusToReject_LT_LeaveCancel(var Variant: Variant)
    var
        RecRef: RecordRef;
        CanLeavRec: Record "Cancel Leave Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Cancel Leave Request":
                begin
                    Message('Reject');
                    RecRef.SetTable(CanLeavRec);
                    CanLeavRec.Validate("WorkFlow Status", CanLeavRec."WorkFlow Status"::Rejected);
                    CanLeavRec.Modify();
                    Variant := CanLeavRec;
                end;
        end;
    end;

    //Code for approval status changes to Released in Transfer Order
    procedure Release_LeaveCancelCode(): Code[128]
    begin
        exit(UpperCase('Release_NEW_LeaveCancel'));
    end;

    procedure Release_LeaveCancel(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        CanLeavRec: Record "Cancel Leave Request";
        ApprovalEntry2: Record "Approval Entry";
        NotificationEntry: Record "Notification Entry";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    Release_LeaveCancel(Variant);
                end;
            DATABASE::"Cancel Leave Request":
                begin
                    RecRef.SetTable(CanLeavRec);
                    CanLeavRec.Validate("WorkFlow Status", CanLeavRec."WorkFlow Status"::Approved);
                    CanLeavRec.Modify();
                    Variant := CanLeavRec;
                    CanLeavRec.PostLeaveCancel(CanLeavRec);
                    ApprovalEntry2.Get(GetEntryAprovalEntryTable(CanLeavRec));
                    NotificationEntry.CreateNotificationEntry(NotificationEntry.Type::Approval,
                    ApprovalEntry2."Sender ID",
                    ApprovalEntry2,
                    Page::"Approval Entries",
                    GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Requests to Approve", ApprovalEntry2, false),
                    UserId);
                end;
        end;
    end;

    //Code for approval status changes to Open When Cancel or Reopen
    procedure ReOpen_LeaveCancelCode(): Code[128]
    begin
        exit(UpperCase('ReOpen_NEW_LeaveCancel'));
    end;

    procedure ReOpen_LeaveCancel(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        CanLeavRec: Record "Cancel Leave Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpen_LeaveCancel(Variant);

                end;
            DATABASE::"Cancel Leave Request":
                begin
                    RecRef.SetTable(CanLeavRec);
                    CanLeavRec.Validate("WorkFlow Status", CanLeavRec."WorkFlow Status"::Open);
                    CanLeavRec.Modify();
                    Variant := CanLeavRec;
                end;
        end;
    end;

    //Code For MEssage Notification start
    procedure LeaveCancelMessageCode(): Code[128]
    begin
        exit(UpperCase('LeaveCancel_NEW_Message'));
    end;

    procedure LeaveCancelMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        CanLeavRec: Record "Cancel Leave Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Cancel Leave Request":
                begin
                    RecRef.SetTable(CanLeavRec);
                    Message('The approval request for the record has been canceled.');
                    Variant := CanLeavRec;
                end;
        end;
    end;

    procedure LeaveCancelSendMessageCode(): Code[128]
    begin
        exit(UpperCase('LeaveCancel_NEW_SendMessage'));
    end;

    procedure LeaveCancelSendMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        CanLeavRec: Record "Cancel Leave Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Cancel Leave Request":
                begin
                    RecRef.SetTable(CanLeavRec);
                    Message('The approval request for the record has been sent.');
                    Variant := CanLeavRec;
                end;
        end;
    end;
    //Code For Message Notification END

    //Inserting Transfer Order Details to Approval Entry Table
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        CanLeavRec: Record "Cancel Leave Request";
    begin
        case RecRef.Number of
            database::"Cancel Leave Request":
                begin
                    RecRef.SetTable(CanLeavRec);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := CanLeavRec."Leave Request ID";
                end;
        end;
    end;

    //Adding Events to event Library
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_LeaveCancelApprovalCode, Database::"Cancel Leave Request", Send_LeaveCancelReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApprove_LeaveCancelApprovalCode, Database::"Approval Entry", AppReq_LeaveCancel, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancel_LeaveCancelApprovalCode, Database::"Cancel Leave Request", CancelForPendAppTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReject_LeaveCancelApprovalCode, Database::"Approval Entry", RejReq_LeaveCancel, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegate_LeaveCancelApprovalCode, Database::"Approval Entry", DelReq_LeaveCancel, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_LeaveCancelRejectCode, Database::"Cancel Leave Request", Send_LeaveCancelReject_LeaveCancelReq, 0, false);
    end;

    //Adding Newly created responses to workflowResponselibrary
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_LeaveCancel, 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Release_LeaveCancelCode, 0, Release_LeaveCancelTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpen_LeaveCancelCode, 0, ReOpen_LeaveCancelTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(LeaveCancelMessageCode, 0, LeaveCancel_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(LeaveCancelSendMessageCode, 0, LeaveCancelSend_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToReject_LT_Code_LeaveCancel, 0, SendForRejectTxt, 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit InitCU_LeaveCancelReq;
    begin
        case ResponseFunctionName of
            WorkFlowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnApprove_LeaveCancelApprovalCode());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForLeaveCancel(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of

                SetStatusToPendingApprovalCode_LeaveCancel():
                    begin
                        SetStatusToPendingApproval_LeaveCancel(Variant);
                        ResponseExecuted := true;
                    end;
                Release_LeaveCancelCode():
                    begin
                        Release_LeaveCancel(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpen_LeaveCancelCode():
                    begin
                        ReOpen_LeaveCancel(Variant);
                        ResponseExecuted := true;
                    end;
                SendEmailCodeLeaveCancel():
                    begin
                        SendEmailRFQ(Variant);
                        ResponseExecuted := true;
                    end;
                LeaveCancelMessageCode():
                    begin
                        LeaveCancelMessage(Variant);
                        ResponseExecuted := true;
                    end;
                LeaveCancelSendMessageCode():
                    begin
                        LeaveCancelSendMessage(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToReject_LT_Code_LeaveCancel():
                    begin
                        Message('Workflow');
                        SetStatusToReject_LT_LeaveCancel(Variant);
                        ResponseExecuted := true;
                    end;
            end;
    end;
    //Approver Chain Setup
    procedure IsRFQSufficeintApprover(UserSetup: Record "User Setup"; ApprovalAmountLCY: Decimal): Boolean
    begin
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);
        IF UserSetup."Unlimited Purchase Approval" OR
        ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND (UserSetup."Purchase Amount Approval Limit" <> 0))
        THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterIsSufficientApprover', '', true, true)]
    local procedure OnAfterIsSufficientApprover(UserSetup: Record "User Setup"; ApprovalEntryArgument: Record "Approval Entry"; var IsSufficient: Boolean)
    begin
        case ApprovalEntryArgument."Table ID" of
            database::"Cancel Leave Request":
                IsSufficient := IsRFQSufficeintApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)");
        end;
    end;
    //Approver ChaIN End

    // Emial Notificaion Creation Start
    procedure SendEmailCodeLeaveCancel(): Code[128]
    begin
        exit(UpperCase('SendEmail_NEW_LeaveCancel'));
    end;

    procedure SendEmailRFQ(var Variant: Variant)
    var
        RecRef: RecordRef;
        RFQHeader: Record "Cancel Leave Request";
        ComapnyInfo: Record "Company Information";
        FileName: Text;
        FileManagement: Codeunit "File Management";
        DocumentUrl: Text;
        PageManagement: Codeunit "Page Management";
        ApprovalEntry: Record "Approval Entry";
        TableId: Integer;
        UserSetup: Record "User Setup";
        RfqNo: Code[80];
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Cancel Leave Request":
                begin
                    TableId := RecRef.Number;
                    RecRef.SetTable(RFQHeader);
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Table ID", TableId);
                    ApprovalEntry.SetRange("Document No.", RFQHeader."Leave Request ID");
                    if ApprovalEntry.FindSet then begin
                        repeat
                            if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or (ApprovalEntry.Status = ApprovalEntry.Status::Created) then begin
                                UserSetup.Reset();
                                if UserSetup.Get(ApprovalEntry."Approver ID") then
                                    UserSetup.TestField("E-Mail");
                                Variant := RFQHeader;
                            end;
                        until ApprovalEntry.Next = 0;
                    end;
                end;
        end;
    end;

    local procedure GetEntryAprovalEntryTable(CanLeavRec: Record "Cancel Leave Request"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", CanLeavRec."Leave Request ID");
        ApprovalEntry.SetRange("Record ID to Approve", CanLeavRec.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Cancel Leave Request");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;
}