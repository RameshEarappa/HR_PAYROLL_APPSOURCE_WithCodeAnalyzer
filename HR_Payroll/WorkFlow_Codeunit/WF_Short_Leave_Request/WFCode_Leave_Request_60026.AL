codeunit 60056 WFCode_Short_Leave_Request
{
    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        Send_Leave_Req: TextConst ENU = 'LT Approval Request for Short Leave Request is requested', ENG = 'LT Approval Request for Short Leave Request is requested';
        AppReq_Leave_Req: TextConst ENU = 'LT Approval Request for Short Leave Request is approved', ENG = 'LT Approval Request for Short Leave Request is approved';
        RejReq_Leave_Req: TextConst ENU = 'LT Approval Request for Short Leave Request is rejected', ENG = 'LT Approval Request for Short Leave Requestis rejected';
        DelReq_Leave_Req: TextConst ENU = 'LT Approval Request for Short Leave Request is delegated', ENG = 'LT Approval Request for Short Leave Request is delegated';
        SendForPendAppTxt: TextConst ENU = 'LT Status of Short Leave Request changed to Pending approval', ENG = 'LT Status of Short Leave Request changed to Pending approval';
        CancelForPendAppTxt: TextConst ENU = 'LT Approval Rquest for Short Leave Request is Canceled', ENG = 'LT Approval request for Short Leave Request is Canceled';
        Release_LeaveReq_Txt: TextConst ENU = 'LT ReleaseShortLeaveReq_', ENG = 'LT ReleaseShortLeaveReq_';
        ReOpen_LeaveReq_Txt: TextConst ENU = 'LT ReOpenShortLeaveReq_', ENG = 'LT ReOpenShortLeaveReq_';
        LeaveReq__Message: TextConst ENU = 'LT ShortLeaveReq_Message', ENG = 'LT ShortLeaveReq_Message';
        LeaveReq_Send_Message: TextConst ENU = 'LT ShortLeaveReq_SendMessage', ENG = 'LT ShortLeaveReq_SendMessage';
        SendForRejectTxt: TextConst ENU = 'LT Status of Short Leave Request changed to Reject', ENG = 'LT Status of Short Leave Request changed to Reject';
        Send_LeaveReq_Reject_LeaveReq_Req: TextConst ENU = 'LT Approval Request for Short Leave Request is Rejected', ENG = 'LT Approval Request for Short Leave Request is Rejected';

    //Events Subscribe Start

    //Send For Approval Event************************************************************************************ start
    procedure RunWorkflowOnSend_ShortLeaveReq_ApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_ShortLeaveReq_Approval');
    end;

    procedure RunWorkflowOnSend_ShortLeaveReq_RejectCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_ShortLeaveReq_Reject');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_Short_Leave_Req, 'OnSend_ShortLeaveReq_Approval', '', true, true)]
    procedure RunWorkflowOnSend_ShortLeaveReq_Approval(var ShortLeaveReqRec: Record "Short Leave Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSend_ShortLeaveReq_ApprovalCode, ShortLeaveReqRec);
    end;

    //Cancel For Approval Event************************************************************************************ End
    procedure RunWorkflowOnCancel_ShortLeaveReq_ApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnCancel_NEW_ShortLeaveReq_Approval');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_Short_Leave_Req, 'OnCancel_ShortLeaveReq_Approval', '', true, true)]
    procedure RunWorkflowOnCancel_ShortLeaveReq_Approval(var ShortLeaveReqRec: Record "Short Leave Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancel_ShortLeaveReq_ApprovalCode, ShortLeaveReqRec);
    end;

    //Approve Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnApprove_ShortLeaveReq_ApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApprove_NEW_ShortLeaveReq_Approval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    procedure RunWorkflowOnApprove_ShortLeaveReq_Approval(var ApprovalEntry: Record "Approval Entry")
    var
        ShortLeaveReqRec: Record "Short Leave Header";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if not l_ApprovalEntry.FindLast then begin
            ShortLeaveReqRec.Reset();
            ShortLeaveReqRec.SetRange("Short Leave Request ID", ApprovalEntry."Document No.");
            if ShortLeaveReqRec.FindFirst() then begin
                ShortLeaveReqRec."WorkFlow Status" := ShortLeaveReqRec."WorkFlow Status"::Released;
                ShortLeaveReqRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApprove_ShortLeaveReq_ApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Reject Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnReject_ShortLeaveReq_ApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnReject_NEW_ShortLeaveReq_Approval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    procedure RunWorkflowOnReject_ShortLeaveReq_Approval(var ApprovalEntry: Record "Approval Entry")
    var
        l_ApprovalEntry: Record "Approval Entry";
        ShortLeaveReqRec: Record "Short Leave Header";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if l_ApprovalEntry.FindFirst() then begin
            ShortLeaveReqRec.Reset();
            ShortLeaveReqRec.SetRange(RecID, ApprovalEntry."Record ID to Approve");
            if ShortLeaveReqRec.FindFirst() then begin
                ShortLeaveReqRec."WorkFlow Status" := ShortLeaveReqRec."WorkFlow Status"::Rejected;
                ShortLeaveReqRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(SetStatusToReject_LT_Code_ShortLeaveReq_(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Delegate Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnDelegate_ShortLeaveReq_ApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegate_ShortLeaveReq_Approval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', true, true)]
    procedure RunWorkflowOnDelegate_ShortLeaveReq_Approval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegate_ShortLeaveReq_ApprovalCode, ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Events Subscribe End

    //Code for changeing approval status Pending approval in Transfer Orders
    procedure SetStatusToPendingApprovalCode_ShortLeaveReq_(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_NEW_ShortLeaveReq_'));
    end;

    procedure SetStatusToReject_LT_Code_ShortLeaveReq_(): Code[128]
    begin
        exit(UpperCase('SetStatusToReject_LT__NEW_ShortLeaveReq_'));
    end;

    procedure SetStatusToPendingApproval_ShortLeaveReq_(var Variant: Variant)
    var
        RecRef: RecordRef;
        ShortLeaveReqRec: Record "Short Leave Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Short Leave Header":
                begin
                    RecRef.SetTable(ShortLeaveReqRec);
                    ShortLeaveReqRec.Validate("WorkFlow Status", ShortLeaveReqRec."WorkFlow Status"::"Pending For Approval");
                    ShortLeaveReqRec.Modify();
                    Variant := ShortLeaveReqRec;
                end;
        end;
    end;

    procedure SetStatusToReject_LT_ShortLeaveReq_(var Variant: Variant)
    var
        RecRef: RecordRef;
        ShortLeaveReqRec: Record "Short Leave Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Short Leave Header":
                begin
                    Message('Reject');
                    RecRef.SetTable(ShortLeaveReqRec);
                    ShortLeaveReqRec.Validate("WorkFlow Status", ShortLeaveReqRec."WorkFlow Status"::Rejected);
                    ShortLeaveReqRec.Modify();
                    Variant := ShortLeaveReqRec;
                end;
        end;
    end;

    //Code for approval status changes to Released in Transfer Order
    procedure Release_ShortLeaveReq_Code(): Code[128]
    begin
        exit(UpperCase('Release_NEW_ShortLeaveReq_'));
    end;

    procedure Release_ShortLeaveReq_(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        ShortLeaveReqRec: Record "Short Leave Header";
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
                    Release_ShortLeaveReq_(Variant);
                end;
            DATABASE::"Short Leave Header":
                begin
                    RecRef.SetTable(ShortLeaveReqRec);
                    ShortLeaveReqRec.Validate("WorkFlow Status", ShortLeaveReqRec."WorkFlow Status"::Released);
                    ShortLeaveReqRec.Modify();
                    Variant := ShortLeaveReqRec;
                    ApprovalEntry2.Get(GetEntryAprovalEntryTable(ShortLeaveReqRec));
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
    procedure ReOpen_ShortLeaveReq_Code(): Code[128]
    begin
        exit(UpperCase('ReOpen_NEW_ShortLeaveReq_'));
    end;

    procedure ReOpen_ShortLeaveReq_(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        ShortLeaveReqRec: Record "Short Leave Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpen_ShortLeaveReq_(Variant);
                end;
            DATABASE::"Short Leave Header":
                begin
                    RecRef.SetTable(ShortLeaveReqRec);
                    ShortLeaveReqRec.Validate("WorkFlow Status", ShortLeaveReqRec."WorkFlow Status"::Open);
                    ShortLeaveReqRec.Modify();
                    Variant := ShortLeaveReqRec;
                end;
        end;
    end;

    //Code For MEssage Notification start
    procedure ShortLeaveReq_MessageCode(): Code[128]
    begin
        exit(UpperCase('ShortLeaveReq__NEW_Message'));
    end;

    procedure ShortLeaveReq_Message(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        ShortLeaveReqRec: Record "Short Leave Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Short Leave Header":
                begin
                    RecRef.SetTable(ShortLeaveReqRec);
                    Message('The approval request for the record has been canceled.');
                    Variant := ShortLeaveReqRec;
                end;
        end;
    end;

    procedure ShortLeaveReq_SendMessageCode(): Code[128]
    begin
        exit(UpperCase('ShortLeaveReq__NEW_SendMessage'));
    end;

    procedure ShortLeaveReq_SendMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        ShortLeaveReqRec: Record "Short Leave Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Short Leave Header":
                begin
                    RecRef.SetTable(ShortLeaveReqRec);
                    Message('The approval request for the record has been sent.');
                    Variant := ShortLeaveReqRec;
                end;
        end;
    end;
    //Code For Message Notification END

    //Inserting Transfer Order Details to Approval Entry Table
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ShortLeaveReqRec: Record "Short Leave Header";
    begin
        case RecRef.Number of
            database::"Short Leave Header":
                begin
                    RecRef.SetTable(ShortLeaveReqRec);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := ShortLeaveReqRec."Short Leave Request ID";
                end;
        end;
    end;

    //Adding Events to event Library
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_ShortLeaveReq_ApprovalCode, Database::"Short Leave Header", Send_Leave_Req, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApprove_ShortLeaveReq_ApprovalCode, Database::"Approval Entry", AppReq_Leave_Req, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancel_ShortLeaveReq_ApprovalCode, Database::"Short Leave Header", CancelForPendAppTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReject_ShortLeaveReq_ApprovalCode, Database::"Approval Entry", RejReq_Leave_Req, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegate_ShortLeaveReq_ApprovalCode, Database::"Approval Entry", DelReq_Leave_Req, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_ShortLeaveReq_RejectCode, Database::"Short Leave Header", Send_LeaveReq_Reject_LeaveReq_Req, 0, false);
    end;

    //Adding Newly created responses to workflowResponselibrary
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_ShortLeaveReq_, 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Release_ShortLeaveReq_Code, 0, Release_LeaveReq_Txt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpen_ShortLeaveReq_Code, 0, ReOpen_LeaveReq_Txt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ShortLeaveReq_MessageCode, 0, LeaveReq__Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ShortLeaveReq_SendMessageCode, 0, LeaveReq_Send_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToReject_LT_Code_ShortLeaveReq_, 0, SendForRejectTxt, 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit InitCodeunit_Leave_Request;
    begin
        case ResponseFunctionName of
            WorkFlowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnApprove_ShortLeaveReq_ApprovalCode());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForLeaveReq_(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of

                SetStatusToPendingApprovalCode_ShortLeaveReq_():
                    begin
                        SetStatusToPendingApproval_ShortLeaveReq_(Variant);
                        ResponseExecuted := true;
                    end;
                Release_ShortLeaveReq_Code():
                    begin
                        Release_ShortLeaveReq_(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpen_ShortLeaveReq_Code():
                    begin
                        ReOpen_ShortLeaveReq_(Variant);
                        ResponseExecuted := true;
                    end;
                SendEmailCodeLeaveReq_():
                    begin
                        SendEmailRFQ(Variant);
                        ResponseExecuted := true;
                    end;
                ShortLeaveReq_MessageCode():
                    begin
                        ShortLeaveReq_Message(Variant);
                        ResponseExecuted := true;
                    end;
                ShortLeaveReq_SendMessageCode():
                    begin
                        ShortLeaveReq_SendMessage(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToReject_LT_Code_ShortLeaveReq_():
                    begin
                        Message('Workflow');
                        SetStatusToReject_LT_ShortLeaveReq_(Variant);
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
            database::"Short Leave Header":
                IsSufficient := IsRFQSufficeintApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)");
        end;
    end;
    //Approver ChaIN End

    // Emial Notificaion Creation Start

    procedure SendEmailCodeLeaveReq_(): Code[128]
    begin
        exit(UpperCase('SendEmail_NEW_LeaveReq_'));
    end;

    procedure SendEmailRFQ(var Variant: Variant)
    var
        RecRef: RecordRef;
        RFQHeader: Record "Short Leave Header";
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
            DATABASE::"Short Leave Header":
                begin
                    TableId := RecRef.Number;
                    RecRef.SetTable(RFQHeader);
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Table ID", TableId);
                    ApprovalEntry.SetRange("Document No.", RFQHeader."Short Leave Request ID");
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

    //Insert Email Notiifcation Entries Start
    procedure InsertEmailNotification(var Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry";
        ShortLeaveReqRec: Record "Short Leave Header";
        l_ApprovalEntry: Record "Approval Entry";
        Recref: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            Database::"Short Leave Header":
                begin
                end;
        end;
    end;
    //Insert Email Notification Entries End

    //Code to Open Record from Request to Appprove page
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', false, false)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; VAR CardPageID: Integer)
    begin
        CASE RecordRef.NUMBER OF
            DATABASE::"Leave Request Header":
                CardPageID := Page::"Leave Request Card";
            Database::"Cancel Leave Request":
                CardPageID := Page::"Cancel Leave Requests";
            Database::"Duty Resumption":
                CardPageID := Page::"Duty Resumption";
            Database::"Document Request":
                CardPageID := Page::"Document request Card";
            Database::"Asset Assignment Register":
                CardPageID := Page::"Asset Issue";
            Database::"Loan Request":
                CardPageID := Page::"Loan Request";
            Database::"Loan Adjustment Header":
                CardPageID := Page::"Loan Adjustment";
            Database::"Payroll Statement":
                CardPageID := Page::"Payroll Statements";
            Database::"Short Leave Header":
                CardPageID := Page::"Short Leave Request Card";
        end;
    end;

    local procedure GetEntryAprovalEntryTable(ShortLeaveReqRec: Record "Short Leave Header"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", ShortLeaveReqRec."Short Leave Request Id");
        ApprovalEntry.SetRange("Record ID to Approve", ShortLeaveReqRec.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Short Leave Header");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;
}