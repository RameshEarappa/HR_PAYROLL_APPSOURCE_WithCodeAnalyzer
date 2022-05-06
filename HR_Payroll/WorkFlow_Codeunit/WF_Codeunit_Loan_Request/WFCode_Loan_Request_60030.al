codeunit 60030 WFCode_Loan_Request
{
    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        Send_Loan_RequestReq: TextConst ENU = 'LT Approval Request for Loan_Request is requested', ENG = 'LT Approval Request for Loan_Request is requested';
        AppReq_Loan_Request: TextConst ENU = 'LT Approval Request for Loan_Request is approved', ENG = 'LT Approval Request for Loan_Request is approved';
        RejReq_Loan_Request: TextConst ENU = 'LT Approval Request for Loan_Request is rejected', ENG = 'LT Approval Request for Loan_Requestis rejected';
        DelReq_Loan_Request: TextConst ENU = 'LT Approval Request for Loan_Request is delegated', ENG = 'LT Approval Request for Loan_Request is delegated';
        SendForPendAppTxt: TextConst ENU = 'LT Status of Loan_Request changed to Pending approval', ENG = 'LT Status of Loan_Request changed to Pending approval';
        CancelForPendAppTxt: TextConst ENU = 'LT Approval Rquest for Loan_Request is Canceled', ENG = 'LT Approval request for Loan_Request is Canceled';
        Release_Loan_RequestTxt: TextConst ENU = 'LT Release_Loan_Request', ENG = 'LT Release_Loan_Request';
        ReOpen_Loan_RequestTxt: TextConst ENU = 'LT ReOpen_Loan_Request', ENG = 'LT ReOpen_Loan_Request';
        Loan_Request_Message: TextConst ENU = 'LT Loan_RequestMessage', ENG = 'LT Loan_RequestMessage';
        Loan_Request_Send_Message: TextConst ENU = 'LT Loan_RequestSendMessage', ENG = 'LT Loan_RequestSendMessage';
        SendForRejectTxt: TextConst ENU = 'LT Status of Loan_Request changed to Reject', ENG = 'LT Status of Loan_Request changed to Reject';
        Send_Loan_RequestReject_Loan_RequestReq: TextConst ENU = 'LT Approval Request for Loan_Request is Rejected', ENG = 'LT Approval Request for Loan_Request is Rejected';
    //Events Subscribe Start

    //Send For Approval Event************************************************************************************ start
    procedure RunWorkflowOnSend_Loan_RequestApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_Loan_RequestApproval');
    end;

    procedure RunWorkflowOnSend_Loan_RequestRejectCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_Loan_RequestReject');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_Loan_Request, 'OnSendLoan_Request_Approval', '', true, true)]
    procedure RunWorkflowOnSend_Loan_RequestApproval(var LoanReqRec: Record "Loan Request")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSend_Loan_RequestApprovalCode, LoanReqRec);
    end;

    //Cancel For Approval Event************************************************************************************ End
    procedure RunWorkflowOnCancel_Loan_RequestApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnCancel_NEW_Loan_RequestApproval');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_Loan_Request, 'OnCancelLoan_Request_Approval', '', true, true)]
    procedure RunWorkflowOnCancel_Loan_RequestApproval(var LoanReqRec: Record "Loan Request")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancel_Loan_RequestApprovalCode, LoanReqRec);
    end;

    //Approve Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnApprove_Loan_RequestApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApprove_NEW_Loan_RequestApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    procedure RunWorkflowOnApprove_Loan_RequestApproval(var ApprovalEntry: Record "Approval Entry")
    var
        RequisitionRequestsRec: Record "Loan Request";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if not l_ApprovalEntry.FindLast then begin
            RequisitionRequestsRec.Reset();
            RequisitionRequestsRec.SetRange("Loan Request ID", ApprovalEntry."Document No.");
            if RequisitionRequestsRec.FindFirst() then begin
                RequisitionRequestsRec."WorkFlow Status" := RequisitionRequestsRec."WorkFlow Status"::Released;
                RequisitionRequestsRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApprove_Loan_RequestApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Reject Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnReject_Loan_RequestApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnReject_NEW_Loan_RequestApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    procedure RunWorkflowOnReject_Loan_RequestApproval(var ApprovalEntry: Record "Approval Entry")
    var
        LoanReqRec: Record "Loan Request";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if l_ApprovalEntry.FindFirst() then begin
            LoanReqRec.Reset();
            LoanReqRec.SetRange("Loan Request ID", ApprovalEntry."Document No.");
            if LoanReqRec.FindFirst() then begin
                LoanReqRec."WorkFlow Status" := LoanReqRec."WorkFlow Status"::Open;
                LoanReqRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(SetStatusToReject_LT_Code_Loan_Request(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Delegate Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnDelegate_Loan_RequestApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegate_Loan_RequestApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', true, true)]
    procedure RunWorkflowOnDelegate_Loan_RequestApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegate_Loan_RequestApprovalCode, ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Events Subscribe End

    //Code for changeing approval status Pending approval in Transfer Orders
    procedure SetStatusToPendingApprovalCode_Loan_Request(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_NEW_Loan_Request'));
    end;

    procedure SetStatusToReject_LT_Code_Loan_Request(): Code[128]
    begin
        exit(UpperCase('SetStatusToReject_LT__NEW_Loan_Request'));
    end;

    procedure SetStatusToPendingApproval_Loan_Request(var Variant: Variant)
    var
        RecRef: RecordRef;
        LoanReqRec: Record "Loan Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Loan Request":
                begin
                    RecRef.SetTable(LoanReqRec);
                    LoanReqRec.Validate("WorkFlow Status", LoanReqRec."WorkFlow Status"::"Pending For Approval");
                    LoanReqRec.Modify();
                    Variant := LoanReqRec;
                end;
        end;
    end;

    procedure SetStatusToReject_LT_Loan_Request(var Variant: Variant)
    var
        RecRef: RecordRef;
        LoanReqRec: Record "Loan Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Loan Request":
                begin
                    Message('Reject');
                    RecRef.SetTable(LoanReqRec);
                    LoanReqRec.Validate("WorkFlow Status", LoanReqRec."WorkFlow Status"::Rejected);
                    LoanReqRec.Modify();
                    Variant := LoanReqRec;
                end;
        end;
    end;

    //Code for approval status changes to Released in Transfer Order
    procedure Release_Loan_RequestCode(): Code[128]
    begin
        exit(UpperCase('Release_NEW_Loan_Request'));
    end;

    procedure Release_Loan_Request(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        loanReqRec: Record "Loan Request";
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
                    Release_Loan_Request(Variant);
                end;
            DATABASE::"Loan Request":
                begin
                    RecRef.SetTable(loanReqRec);
                    loanReqRec.Validate("WorkFlow Status", loanReqRec."WorkFlow Status"::Released);
                    loanReqRec.Modify();
                    Variant := loanReqRec;
                    ApprovalEntry2.Get(GetEntryAprovalEntryTable(loanReqRec));
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
    procedure ReOpen_Loan_RequestCode(): Code[128]
    begin
        exit(UpperCase('ReOpen_NEW_Loan_Request'));
    end;

    procedure ReOpen_Loan_Request(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        LoanReqRec: Record "Loan Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpen_Loan_Request(Variant);
                end;
            DATABASE::"Loan Request":
                begin
                    RecRef.SetTable(LoanReqRec);
                    LoanReqRec.Validate("WorkFlow Status", LoanReqRec."WorkFlow Status"::Open);
                    LoanReqRec.Modify();
                    Variant := LoanReqRec;
                end;
        end;
    end;

    //Code For MEssage Notification start
    procedure Loan_RequestMessageCode(): Code[128]
    begin
        exit(UpperCase('Loan_Request_NEW_Message'));
    end;

    procedure Loan_RequestMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        LoanReqRec: Record "Loan Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Loan Request":
                begin
                    RecRef.SetTable(LoanReqRec);
                    Message('The approval request for the record has been canceled.');
                    Variant := LoanReqRec;
                end;
        end;
    end;

    procedure Loan_RequestSendMessageCode(): Code[128]
    begin
        exit(UpperCase('Loan_Request_NEW_SendMessage'));
    end;

    procedure Loan_RequestSendMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        LoanReqRec: Record "Loan Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Loan Request":
                begin
                    RecRef.SetTable(LoanReqRec);
                    Message('The approval request for the record has been sent.');
                    Variant := LoanReqRec;
                end;
        end;
    end;
    //Code For Message Notification END

    //Inserting Transfer Order Details to Approval Entry Table
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        LoanReqRec: Record "Loan Request";
    begin
        case RecRef.Number of
            database::"Loan Request":
                begin
                    RecRef.SetTable(LoanReqRec);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := LoanReqRec."Loan Request ID";

                end;
        end;
    end;

    //Adding Events to event Library
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_Loan_RequestApprovalCode, Database::"Loan Request", Send_Loan_RequestReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApprove_Loan_RequestApprovalCode, Database::"Approval Entry", AppReq_Loan_Request, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancel_Loan_RequestApprovalCode, Database::"Loan Request", CancelForPendAppTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReject_Loan_RequestApprovalCode, Database::"Approval Entry", RejReq_Loan_Request, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegate_Loan_RequestApprovalCode, Database::"Approval Entry", DelReq_Loan_Request, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_Loan_RequestRejectCode, Database::"Loan Request", Send_Loan_RequestReject_Loan_RequestReq, 0, false);
    end;

    //Adding Newly created responses to workflowResponselibrary
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_Loan_Request, 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Release_Loan_RequestCode, 0, Release_Loan_RequestTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpen_Loan_RequestCode, 0, ReOpen_Loan_RequestTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Loan_RequestMessageCode, 0, Loan_Request_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Loan_RequestSendMessageCode, 0, Loan_Request_Send_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToReject_LT_Code_Loan_Request, 0, SendForRejectTxt, 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit InitCodeunit_Loan_Request;
    begin
        case ResponseFunctionName of
            WorkFlowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnApprove_Loan_RequestApprovalCode());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForLoan_Request(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of
                SetStatusToPendingApprovalCode_Loan_Request():
                    begin
                        SetStatusToPendingApproval_Loan_Request(Variant);
                        ResponseExecuted := true;
                    end;
                Release_Loan_RequestCode():
                    begin
                        Release_Loan_Request(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpen_Loan_RequestCode():
                    begin
                        ReOpen_Loan_Request(Variant);
                        ResponseExecuted := true;
                    end;
                SendEmailCodeLoan_Request():
                    begin
                        SendEmailRFQ(Variant);
                        ResponseExecuted := true;
                    end;
                Loan_RequestMessageCode():
                    begin
                        Loan_RequestMessage(Variant);
                        ResponseExecuted := true;
                    end;
                Loan_RequestSendMessageCode():
                    begin
                        Loan_RequestSendMessage(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToReject_LT_Code_Loan_Request():
                    begin
                        Message('Workflow');
                        SetStatusToReject_LT_Loan_Request(Variant);
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
            database::"Loan Request":
                IsSufficient := IsRFQSufficeintApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)");
        end;
    end;
    //Approver ChaIN End

    // Emial Notificaion Creation Start
    procedure SendEmailCodeLoan_Request(): Code[128]
    begin
        exit(UpperCase('SendEmail_NEW_Loan_Request'));
    end;

    procedure SendEmailRFQ(var Variant: Variant)
    var
        RecRef: RecordRef;
        RFQHeader: Record "Loan Request";
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
            DATABASE::"Loan Request":
                begin
                    TableId := RecRef.Number;
                    RecRef.SetTable(RFQHeader);
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Table ID", TableId);
                    ApprovalEntry.SetRange("Document No.", RFQHeader."Loan Request ID");
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

    local procedure GetEntryAprovalEntryTable(LoanRequest: Record "Loan Request"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", LoanRequest."Loan Request ID");
        ApprovalEntry.SetRange("Record ID to Approve", LoanRequest.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Loan Request");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;
}