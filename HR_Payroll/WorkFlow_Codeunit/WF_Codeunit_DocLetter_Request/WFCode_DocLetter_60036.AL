codeunit 60036 WFCode_DocLetter
{
    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        Send_DocLetterReq: TextConst ENU = 'LT Approval Request for Document Letter is requested', ENG = 'LT Approval Request for Document Letter is requested';
        AppReq_DocLetter: TextConst ENU = 'LT Approval Request for Document Letter is approved', ENG = 'LT Approval Request for Document Letter is approved';
        RejReq_DocLetter: TextConst ENU = 'LT Approval Request for Document Letter is rejected', ENG = 'LT Approval Request for Document Letteris rejected';
        DelReq_DocLetter: TextConst ENU = 'LT Approval Request for Document Letter is delegated', ENG = 'LT Approval Request for Document Letter is delegated';
        SendForPendAppTxt: TextConst ENU = 'LT Status of Document Letter changed to Pending approval', ENG = 'LT Status of Document Letter changed to Pending approval';
        CancelForPendAppTxt: TextConst ENU = 'LT Approval Rquest for Document Letter is Canceled', ENG = 'LT Approval request for Document Letter is Canceled';
        Release_DocLetterTxt: TextConst ENU = 'LT ReleaseDocLetter', ENG = 'LT ReleaseDocLetter';
        ReOpen_DocLetterTxt: TextConst ENU = 'LT ReOpenDocLetter', ENG = 'LT ReOpenDocLetter';
        DocLetter_Message: TextConst ENU = 'LT DocLetterMessage', ENG = 'LT DocLetterMessage';
        DocLetterSend_Message: TextConst ENU = 'LT DocLetterSendMessage', ENG = 'LT DocLetterSendMessage';
        SendForRejectTxt: TextConst ENU = 'LT Status of Document Letter changed to Reject', ENG = 'LT Status of Document Letter changed to Reject';
        Send_DocLetterReject_DocLetterReq: TextConst ENU = 'LT Approval Request for Document Letter is Rejected', ENG = 'LT Approval Request for Document Letter is Rejected';

    //Events Subscribe Start
    //Send For Approval Event************************************************************************************ start
    procedure RunWorkflowOnSend_DocLetterApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_DocLetterApproval');
    end;

    procedure RunWorkflowOnSend_DocLetterRejectCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_DocLetterReject');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_DocLetterRec, 'OnSendDocLetter_Approval', '', true, true)]
    procedure RunWorkflowOnSend_DocLetterApproval(var DocLetterRec: Record "Document Request")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSend_DocLetterApprovalCode, DocLetterRec);
    end;

    //Cancel For Approval Event************************************************************************************ End
    procedure RunWorkflowOnCancel_DocLetterApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnCancel_NEW_DocLetterApproval');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_DocLetterRec, 'OnCancelDocLetter_Approval', '', true, true)]
    procedure RunWorkflowOnCancel_DocLetterApproval(var DocLetterRec: Record "Document Request")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancel_DocLetterApprovalCode, DocLetterRec);
    end;

    //Approve Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnApprove_DocLetterApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApprove_NEW_DocLetterApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    procedure RunWorkflowOnApprove_DocLetterApproval(var ApprovalEntry: Record "Approval Entry")
    var
        RequisitionRequestsRec: Record "Document Request";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if not l_ApprovalEntry.FindLast then begin
            RequisitionRequestsRec.Reset();
            RequisitionRequestsRec.SetRange("Document Request ID", ApprovalEntry."Document No.");
            if RequisitionRequestsRec.FindFirst() then begin
                RequisitionRequestsRec."WorkFlow Status" := RequisitionRequestsRec."WorkFlow Status"::Released;
                RequisitionRequestsRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApprove_DocLetterApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Reject Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnReject_DocLetterApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnReject_NEW_DocLetterApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    procedure RunWorkflowOnReject_DocLetterApproval(var ApprovalEntry: Record "Approval Entry")
    var
        DocLetterRecRec: Record "Document Request";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if l_ApprovalEntry.FindFirst() then begin
            DocLetterRecRec.Reset();
            DocLetterRecRec.SetRange("Document Request ID", ApprovalEntry."Document No.");
            if DocLetterRecRec.FindFirst() then begin
                DocLetterRecRec."WorkFlow Status" := DocLetterRecRec."WorkFlow Status"::Open;
                DocLetterRecRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(SetStatusToReject_LT_Code_DocLetter(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Delegate Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnDelegate_DocLetterApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegate_DocLetterApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', true, true)]
    procedure RunWorkflowOnDelegate_DocLetterApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegate_DocLetterApprovalCode, ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Events Subscribe End

    //Code for changeing approval status Pending approval in Transfer Orders
    procedure SetStatusToPendingApprovalCode_DocLetter(): Code[128] // Done
    begin
        exit(UpperCase('SetStatusToPendingApproval_NEW_DocLetter'));
    end;

    procedure SetStatusToReject_LT_Code_DocLetter(): Code[128]
    begin
        exit(UpperCase('SetStatusToReject_LT__NEW_DocLetter'));
    end;

    procedure SetStatusToPendingApproval_DocLetter(var Variant: Variant)
    var
        RecRef: RecordRef;
        DocLetterRec: Record "Document Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Document Request":
                begin
                    RecRef.SetTable(DocLetterRec);
                    DocLetterRec.Validate("WorkFlow Status", DocLetterRec."WorkFlow Status"::"Pending Approval");
                    DocLetterRec.Modify();
                    Variant := DocLetterRec;
                end;
        end;
    end;

    procedure SetStatusToReject_LT_DocLetter(var Variant: Variant)
    var
        RecRef: RecordRef;
        DocLetterRec: Record "Document Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Document Request":
                begin
                    DocLetterRec := Variant;
                    DocLetterRec.Validate("WorkFlow Status", DocLetterRec."WorkFlow Status"::Rejected);
                    DocLetterRec.Modify();
                    Variant := DocLetterRec;
                end;
        end;
    end;

    //Code for approval status changes to Released in Transfer Order
    procedure Release_DocLetterCode(): Code[128]
    begin
        exit(UpperCase('Release_NEW_DocLetter'));
    end;

    procedure Release_DocLetter(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        DocLetterRec: Record "Document Request";
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
                    Release_DocLetter(Variant);
                end;
            DATABASE::"Document Request":
                begin
                    RecRef.SetTable(DocLetterRec);
                    DocLetterRec.Validate("WorkFlow Status", DocLetterRec."WorkFlow Status"::Released);
                    DocLetterRec.Modify();
                    Variant := DocLetterRec;
                    ApprovalEntry2.Get(GetEntryAprovalEntryTable(DocLetterRec));
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
    procedure ReOpen_DocLetterCode(): Code[128]
    begin
        exit(UpperCase('ReOpen_NEW_DocLetter'));
    end;

    procedure ReOpen_DocLetter(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        DocLetterRec: Record "Document Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpen_DocLetter(Variant);
                end;
            DATABASE::"Document Request":
                begin
                    DocLetterRec := Variant;
                    DocLetterRec.Validate("WorkFlow Status", DocLetterRec."WorkFlow Status"::Open);
                    DocLetterRec.Modify();
                    Variant := DocLetterRec;
                end;
        end;
    end;

    //Code For MEssage Notification start
    procedure DocLetterMessageCode(): Code[128]
    begin
        exit(UpperCase('DocLetter_NEW_Message'));
    end;

    procedure DocLetterMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        DocLetterRec: Record "Document Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Document Request":
                begin
                    RecRef.SetTable(DocLetterRec);
                    Message('The approval request for the record has been canceled.');
                    Variant := DocLetterRec;
                end;
        end;
    end;

    procedure DocLetterSendMessageCode(): Code[128]
    begin
        exit(UpperCase('DocLetter_NEW_SendMessage'));
    end;

    procedure DocLetterSendMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        DocLetterRec: Record "Document Request";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Document Request":
                begin
                    RecRef.SetTable(DocLetterRec);
                    Message('The approval request for the record has been sent.');
                    Variant := DocLetterRec;
                end;
        end;
    end;
    //Code For Message Notification END

    //Inserting Transfer Order Details to Approval Entry Table
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        DocLetterRec: Record "Document Request";
    begin
        case RecRef.Number of
            database::"Document Request":
                begin
                    RecRef.SetTable(DocLetterRec);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := DocLetterRec."Document Request ID";
                end;
        end;
    end;

    //Adding Events to event Library
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_DocLetterApprovalCode, Database::"Document Request", Send_DocLetterReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApprove_DocLetterApprovalCode, Database::"Approval Entry", AppReq_DocLetter, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancel_DocLetterApprovalCode, Database::"Document Request", CancelForPendAppTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReject_DocLetterApprovalCode, Database::"Approval Entry", RejReq_DocLetter, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegate_DocLetterApprovalCode, Database::"Approval Entry", DelReq_DocLetter, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_DocLetterRejectCode, Database::"Document Request", Send_DocLetterReject_DocLetterReq, 0, false);
    end;

    //Adding Newly created responses to workflowResponselibrary
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_DocLetter, 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Release_DocLetterCode, 0, Release_DocLetterTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpen_DocLetterCode, 0, ReOpen_DocLetterTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(DocLetterMessageCode, 0, DocLetter_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(DocLetterSendMessageCode, 0, DocLetterSend_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToReject_LT_Code_DocLetter, 0, SendForRejectTxt, 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit InitCodeunit_DocLetterRec;
    begin
        case ResponseFunctionName of
            WorkFlowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnApprove_DocLetterApprovalCode());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForDocLetter(var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of

                SetStatusToPendingApprovalCode_DocLetter():
                    begin
                        SetStatusToPendingApproval_DocLetter(Variant);
                        ResponseExecuted := true;
                    end;
                Release_DocLetterCode():
                    begin
                        Release_DocLetter(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpen_DocLetterCode():
                    begin
                        ReOpen_DocLetter(Variant);
                        ResponseExecuted := true;
                    end;
                SendEmailCodeDocLetter():
                    begin
                        SendEmailRFQ(Variant);
                        ResponseExecuted := true;
                    end;
                DocLetterMessageCode():
                    begin
                        DocLetterMessage(Variant);
                        ResponseExecuted := true;
                    end;
                DocLetterSendMessageCode():
                    begin
                        DocLetterSendMessage(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToReject_LT_Code_DocLetter():
                    begin
                        SetStatusToReject_LT_DocLetter(Variant);
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
            database::"Document Request":
                IsSufficient := IsRFQSufficeintApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)");
        end;
    end;
    //Approver ChaIN End

    // Emial Notificaion Creation Start
    procedure SendEmailCodeDocLetter(): Code[128]
    begin
        exit(UpperCase('SendEmail_NEW_DocLetter'));
    end;

    procedure SendEmailRFQ(var Variant: Variant)
    var
        RecRef: RecordRef;
        RFQHeader: Record "Document Request";
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
            DATABASE::"Document Request":
                begin
                    TableId := RecRef.Number;
                    RecRef.SetTable(RFQHeader);
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Table ID", TableId);
                    ApprovalEntry.SetRange("Document No.", RFQHeader."Document Request ID");
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

    local procedure GetEntryAprovalEntryTable(DocLetterRec: Record "Document Request"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", DocLetterRec."Document Request ID");
        ApprovalEntry.SetRange("Record ID to Approve", DocLetterRec.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Document Request");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;
}