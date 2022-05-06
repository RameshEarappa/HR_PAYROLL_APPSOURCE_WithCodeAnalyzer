codeunit 60034 WFCode_Duty_Resumption
{
    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        Send_Duty_ResumptionReq: TextConst ENU = 'LT Approval Request for Duty Resumption is requested', ENG = 'LT Approval Request for Duty Resumption is requested';
        AppReq_Duty_Resumption: TextConst ENU = 'LT Approval Request for Duty Resumption is approved', ENG = 'LT Approval Request for Duty Resumption is approved';
        DelReq_Duty_Resumption: TextConst ENU = 'LT Approval Request for Duty Resumption is delegated', ENG = 'LT Approval Request for Duty Resumption is delegated';
        SendForPendAppTxt: TextConst ENU = 'LT Status of Duty Resumption changed to Pending approval', ENG = 'LT Status of Duty Resumption changed to Pending approval';
        CancelForPendAppTxt: TextConst ENU = 'LT Approval Rquest for Duty Resumption is Canceled', ENG = 'LT Approval request for Duty Resumption is Canceled';
        Release_Duty_ResumptionTxt: TextConst ENU = 'LT ReleaseDuty_Resumption', ENG = 'LT ReleaseDuty_Resumption';
        ReOpen_Duty_ResumptionTxt: TextConst ENU = 'LT ReOpenDuty_Resumption', ENG = 'LT ReOpenDuty_Resumption';
        Duty_Resumption_Message: TextConst ENU = 'LT Duty_ResumptionMessage', ENG = 'LT Duty_ResumptionMessage';
        Duty_ResumptionSend_Message: TextConst ENU = 'LT Duty_ResumptionSendMessage', ENG = 'LT Duty_ResumptionSendMessage';
        SendForRejectTxt: TextConst ENU = 'LT Status of Duty Resumption changed to Reject', ENG = 'LT Status of Duty Resumption changed to Reject';
        Send_Duty_ResumptionReject_Duty_ResumptionReq: TextConst ENU = 'LT Approval Request for Duty Resumption is Rejected', ENG = 'LT Approval Request for Duty Resumption is Rejected';
    //Events Subscribe Start

    //Send For Approval Event************************************************************************************ start
    procedure RunWorkflowOnSend_Duty_ResumptionApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_Duty_ResumptionApproval');
    end;

    procedure RunWorkflowOnSend_Duty_ResumptionRejectCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_Duty_ResumptionReject');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_Duty_Resumption, 'OnSendDuty_Resumption_Approval', '', true, true)]
    procedure RunWorkflowOnSend_Duty_ResumptionApproval(var DutyResRec: Record "Duty Resumption")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSend_Duty_ResumptionApprovalCode, DutyResRec);
    end;
    //Cancel For Approval Event************************************************************************************ End
    procedure RunWorkflowOnCancel_Duty_ResumptionApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnCancel_NEW_Duty_ResumptionApproval');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_Duty_Resumption, 'OnCancelDuty_Resumption_Approval', '', true, true)]
    procedure RunWorkflowOnCancel_Duty_ResumptionApproval(var DutyResRec: Record "Duty Resumption")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancel_Duty_ResumptionApprovalCode, DutyResRec);
    end;
    //Approve Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnApprove_Duty_ResumptionApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApprove_NEW_Duty_ResumptionApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    procedure RunWorkflowOnApprove_Duty_ResumptionApproval(var ApprovalEntry: Record "Approval Entry")
    var
        RequisitionRequestsRec: Record "Duty Resumption";
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
                RequisitionRequestsRec."WorkFlow Status" := RequisitionRequestsRec."WorkFlow Status"::Released;
                RequisitionRequestsRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApprove_Duty_ResumptionApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Reject Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnReject_Duty_ResumptionApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnReject_NEW_Duty_ResumptionApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    procedure RunWorkflowOnReject_Duty_ResumptionApproval(var ApprovalEntry: Record "Approval Entry")
    var
        DutyResRecRec: Record "Duty Resumption";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if l_ApprovalEntry.FindFirst() then begin
            DutyResRecRec.Reset();
            DutyResRecRec.SetRange(RecID, ApprovalEntry."Record ID to Approve");
            if DutyResRecRec.FindFirst() then begin
                DutyResRecRec."WorkFlow Status" := DutyResRecRec."WorkFlow Status"::Rejected;
                DutyResRecRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(SetStatusToReject_LT_Code_Duty_Resumption(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Delegate Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnDelegate_Duty_ResumptionApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegate_Duty_ResumptionApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', true, true)]
    procedure RunWorkflowOnDelegate_Duty_ResumptionApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegate_Duty_ResumptionApprovalCode, ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Events Subscribe End

    //Code for changeing approval status Pending approval in Transfer Orders
    procedure SetStatusToPendingApprovalCode_Duty_Resumption(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_NEW_Duty_Resumption'));
    end;

    procedure SetStatusToReject_LT_Code_Duty_Resumption(): Code[128]
    begin
        exit(UpperCase('SetStatusToReject_LT__NEW_Duty_Resumption'));
    end;

    procedure SetStatusToPendingApproval_Duty_Resumption(var Variant: Variant)
    var
        RecRef: RecordRef;
        DutyResRec: Record "Duty Resumption";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Duty Resumption":
                begin
                    RecRef.SetTable(DutyResRec);
                    DutyResRec.Validate("WorkFlow Status", DutyResRec."WorkFlow Status"::"Pending Approval");
                    DutyResRec.Modify();
                    Variant := DutyResRec;
                end;
        end;
    end;

    procedure SetStatusToReject_LT_Duty_Resumption(var Variant: Variant)
    var
        RecRef: RecordRef;
        DutyResRec: Record "Duty Resumption";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Duty Resumption":
                begin
                    Message('Reject');
                    RecRef.SetTable(DutyResRec);
                    DutyResRec.Validate("WorkFlow Status", DutyResRec."WorkFlow Status"::Rejected);
                    DutyResRec.Modify();
                    Variant := DutyResRec;
                end;
        end;
    end;

    //Code for approval status changes to Released in Transfer Order
    procedure Release_Duty_ResumptionCode(): Code[128]
    begin
        exit(UpperCase('Release_NEW_Duty_Resumption'));
    end;

    procedure Release_Duty_Resumption(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        DutyResRec: Record "Duty Resumption";
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
                    Release_Duty_Resumption(Variant);
                end;
            DATABASE::"Duty Resumption":
                begin
                    RecRef.SetTable(DutyResRec);
                    DutyResRec.Validate("WorkFlow Status", DutyResRec."WorkFlow Status"::Released);
                    DutyResRec.Modify();
                    Variant := DutyResRec;
                    ApprovalEntry2.Get(GetEntryAprovalEntryTable(DutyResRec));
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
    procedure ReOpen_Duty_ResumptionCode(): Code[128]
    begin
        exit(UpperCase('ReOpen_NEW_Duty_Resumption'));
    end;

    procedure ReOpen_Duty_Resumption(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        DutyResRec: Record "Duty Resumption";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpen_Duty_Resumption(Variant);

                end;
            DATABASE::"Duty Resumption":
                begin
                    RecRef.SetTable(DutyResRec);
                    DutyResRec.Validate("WorkFlow Status", DutyResRec."WorkFlow Status"::Open);
                    DutyResRec.Modify();
                    Variant := DutyResRec;
                end;
        end;
    end;

    //Code For MEssage Notification start
    procedure Duty_ResumptionMessageCode(): Code[128]
    begin
        exit(UpperCase('Duty_Resumption_NEW_Message'));
    end;

    procedure Duty_ResumptionMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        DutyResRec: Record "Duty Resumption";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Duty Resumption":
                begin
                    RecRef.SetTable(DutyResRec);
                    Message('The approval request for the record has been canceled.');
                    Variant := DutyResRec;
                end;
        end;
    end;

    procedure Duty_ResumptionSendMessageCode(): Code[128]
    begin
        exit(UpperCase('Duty_Resumption_NEW_SendMessage'));
    end;

    procedure Duty_ResumptionSendMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        DutyResRec: Record "Duty Resumption";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Duty Resumption":
                begin
                    RecRef.SetTable(DutyResRec);
                    Message('The approval request for the record has been sent.');
                    Variant := DutyResRec;
                end;
        end;
    end;
    //Code For Message Notification END

    //Inserting Transfer Order Details to Approval Entry Table
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        DutyResRec: Record "Duty Resumption";
    begin
        case RecRef.Number of
            database::"Duty Resumption":
                begin
                    RecRef.SetTable(DutyResRec);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := DutyResRec."Leave Request ID";
                end;
        end;
    end;

    //Adding Events to event Library
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_Duty_ResumptionApprovalCode, Database::"Duty Resumption", Send_Duty_ResumptionReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApprove_Duty_ResumptionApprovalCode, Database::"Approval Entry", AppReq_Duty_Resumption, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancel_Duty_ResumptionApprovalCode, Database::"Duty Resumption", CancelForPendAppTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegate_Duty_ResumptionApprovalCode, Database::"Approval Entry", DelReq_Duty_Resumption, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_Duty_ResumptionRejectCode, Database::"Duty Resumption", Send_Duty_ResumptionReject_Duty_ResumptionReq, 0, false);
    end;

    //Adding Newly created responses to workflowResponselibrary
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_Duty_Resumption, 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Release_Duty_ResumptionCode, 0, Release_Duty_ResumptionTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpen_Duty_ResumptionCode, 0, ReOpen_Duty_ResumptionTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Duty_ResumptionMessageCode, 0, Duty_Resumption_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Duty_ResumptionSendMessageCode, 0, Duty_ResumptionSend_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToReject_LT_Code_Duty_Resumption, 0, SendForRejectTxt, 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit InitCodeunit_Duty_Resumption;
    begin
        case ResponseFunctionName of
            WorkFlowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnApprove_Duty_ResumptionApprovalCode());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForDuty_Resumption(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of

                SetStatusToPendingApprovalCode_Duty_Resumption():
                    begin
                        SetStatusToPendingApproval_Duty_Resumption(Variant);
                        ResponseExecuted := true;
                    end;
                Release_Duty_ResumptionCode():
                    begin
                        Release_Duty_Resumption(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpen_Duty_ResumptionCode():
                    begin
                        ReOpen_Duty_Resumption(Variant);
                        ResponseExecuted := true;
                    end;
                SendEmailCodeDuty_Resumption():
                    begin
                        SendEmailRFQ(Variant);
                        ResponseExecuted := true;
                    end;
                Duty_ResumptionMessageCode():
                    begin
                        Duty_ResumptionMessage(Variant);
                        ResponseExecuted := true;
                    end;
                Duty_ResumptionSendMessageCode():
                    begin
                        Duty_ResumptionSendMessage(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToReject_LT_Code_Duty_Resumption():
                    begin
                        Message('Workflow');
                        SetStatusToReject_LT_Duty_Resumption(Variant);
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
            database::"Duty Resumption":
                IsSufficient := IsRFQSufficeintApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)");
        end;
    end;
    //Approver ChaIN End

    // Emial Notificaion Creation Start

    procedure SendEmailCodeDuty_Resumption(): Code[128]
    begin
        exit(UpperCase('SendEmail_NEW_Duty_Resumption'));
    end;

    procedure SendEmailRFQ(var Variant: Variant)
    var
        RecRef: RecordRef;
        RFQHeader: Record "Duty Resumption";
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
            DATABASE::"Duty Resumption":
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

    local procedure GetEntryAprovalEntryTable(DutyResRec: Record "Duty Resumption"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", DutyResRec."Leave Request ID");
        ApprovalEntry.SetRange("Record ID to Approve", DutyResRec.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Duty Resumption");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;
}