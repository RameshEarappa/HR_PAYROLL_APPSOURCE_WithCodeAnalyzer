codeunit 60040 WFCode_Payroll
{
    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        Send_PayrollStatReq: TextConst ENU = 'LT Approval Request for Payroll Statement   is requested', ENG = 'LT Approval Request for Payroll Statement   is requested';
        AppReq_PayrollStat: TextConst ENU = 'LT Approval Request for Payroll Statement   is approved', ENG = 'LT Approval Request for Payroll Statement   is approved';
        RejReq_PayrollStat: TextConst ENU = 'LT Approval Request for Payroll Statement   is rejected', ENG = 'LT Approval Request for Payroll Statement  is rejected';
        DelReq_PayrollStat: TextConst ENU = 'LT Approval Request for Payroll Statement   is delegated', ENG = 'LT Approval Request for Payroll Statement   is delegated';
        SendForPendAppTxt: TextConst ENU = 'LT Status of Payroll Statement   changed to Pending approval', ENG = 'LT Status of Payroll Statement   changed to Pending approval';
        CancelForPendAppTxt: TextConst ENU = 'LT Approval Rquest for Payroll Statement   is Canceled', ENG = 'LT Approval request for Payroll Statement   is Canceled';
        Release_PayrollStatTxt: TextConst ENU = 'LT ReleasePayrollStat', ENG = 'LT ReleasePayrollStat';
        ReOpen_PayrollStatTxt: TextConst ENU = 'LT ReOpenPayrollStat', ENG = 'LT ReOpenPayrollStat';
        PayrollStat_Message: TextConst ENU = 'LT PayrollStatMessage', ENG = 'LT PayrollStatMessage';
        PayrollStatSend_Message: TextConst ENU = 'LT PayrollStatSendMessage', ENG = 'LT PayrollStatSendMessage';
        SendForRejectTxt: TextConst ENU = 'LT Status of Payroll Statement   changed to Reject', ENG = 'LT Status of Payroll Statement   changed to Reject';
        Send_PayrollStatReject_PayrollStatReq: TextConst ENU = 'LT Approval Request for Payroll Statement   is Rejected', ENG = 'LT Approval Request for Payroll Statement   is Rejected';
    //Events Subscribe Start

    //Send For Approval Event************************************************************************************ start
    procedure RunWorkflowOnSend_PayrollStatApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_PayrollStatApproval');
    end;

    procedure RunWorkflowOnSend_PayrollStatRejectCode(): Code[128]
    begin
        exit('RunWorkflowOnSend_NEW_PayrollStatReject');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_Payroll, 'OnSendPayrollStat_Approval', '', true, true)]
    procedure RunWorkflowOnSend_PayrollStatApproval(var PayrollRec: Record "Payroll Statement")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSend_PayrollStatApprovalCode, PayrollRec);
    end;
    //Cancel For Approval Event************************************************************************************ End
    procedure RunWorkflowOnCancel_PayrollStatApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnCancel_NEW_PayrollStatApproval');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::InitCodeunit_Payroll, 'OnCancelPayrollStat_Approval', '', true, true)]
    procedure RunWorkflowOnCancel_PayrollStatApproval(var PayrollRec: Record "Payroll Statement")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancel_PayrollStatApprovalCode, PayrollRec);
    end;

    //Approve Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnApprove_PayrollStatApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApprove_NEW_PayrollStatApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    procedure RunWorkflowOnApprove_PayrollStatApproval(var ApprovalEntry: Record "Approval Entry")
    var
        RequisitionRequestsRec: Record "Payroll Statement";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if not l_ApprovalEntry.FindLast then begin
            RequisitionRequestsRec.Reset();
            RequisitionRequestsRec.SetRange("Payroll Statement ID", ApprovalEntry."Document No.");
            if RequisitionRequestsRec.FindFirst() then begin
                RequisitionRequestsRec."WorkFlow Status" := RequisitionRequestsRec."WorkFlow Status"::Approved;
                RequisitionRequestsRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApprove_PayrollStatApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Reject Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnReject_PayrollStatApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnReject_NEW_PayrollStatApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    procedure RunWorkflowOnReject_PayrollStatApproval(var ApprovalEntry: Record "Approval Entry")
    var
        PayrollRecRec: Record "Payroll Statement";
        l_ApprovalEntry: Record "Approval Entry";
    begin
        l_ApprovalEntry.Reset;
        l_ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        l_ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        l_ApprovalEntry.SetFilter(Status, '%1|%2', l_ApprovalEntry.Status::Open, l_ApprovalEntry.Status::Created);
        if l_ApprovalEntry.FindFirst() then begin
            PayrollRecRec.Reset();
            PayrollRecRec.SetRange(RecID, ApprovalEntry."Record ID to Approve");
            if PayrollRecRec.FindFirst() then begin
                PayrollRecRec."WorkFlow Status" := PayrollRecRec."WorkFlow Status"::Open;//Krishna
                PayrollRecRec.Modify(true);
            end;
        end;
        WFMngt.HandleEventOnKnownWorkflowInstance(SetStatusToReject_LT_Code_PayrollStat(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Delegate Approval reques Event************************************************************************************ End
    procedure RunWorkflowOnDelegate_PayrollStatApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegate_PayrollStatApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', true, true)]
    procedure RunWorkflowOnDelegate_PayrollStatApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegate_PayrollStatApprovalCode, ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;
    //Events Subscribe End

    //Code for changeing approval status Pending approval in Transfer Orders
    procedure SetStatusToPendingApprovalCode_PayrollStat(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApproval_NEW_PayrollStat'));
    end;

    procedure SetStatusToReject_LT_Code_PayrollStat(): Code[128]
    begin
        exit(UpperCase('SetStatusToReject_LT__NEW_PayrollStat'));
    end;

    procedure SetStatusToPendingApproval_PayrollStat(var Variant: Variant)
    var
        RecRef: RecordRef;
        PayrollRec: Record "Payroll Statement";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Payroll Statement":
                begin
                    RecRef.SetTable(PayrollRec);
                    PayrollRec.Validate("WorkFlow Status", PayrollRec."WorkFlow Status"::"Pending Approval");
                    PayrollRec.Modify();
                    Variant := PayrollRec;
                end;
        end;
    end;

    procedure SetStatusToReject_LT_PayrollStat(var Variant: Variant)
    var
        RecRef: RecordRef;
        PayrollRec: Record "Payroll Statement";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Payroll Statement":
                begin
                    Message('Reject');
                    RecRef.SetTable(PayrollRec);
                    PayrollRec.Validate("WorkFlow Status", PayrollRec."WorkFlow Status"::Rejected);
                    PayrollRec.Modify();
                    Variant := PayrollRec;
                end;
        end;
    end;

    //Code for approval status changes to Released in Transfer Order
    procedure Release_PayrollStatCode(): Code[128]
    begin
        exit(UpperCase('Release_NEW_PayrollStat'));
    end;

    procedure Release_PayrollStat(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        PayrollRec: Record "Payroll Statement";
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
                    Release_PayrollStat(Variant);
                end;
            DATABASE::"Payroll Statement":
                begin
                    RecRef.SetTable(PayrollRec);
                    PayrollRec.Validate("WorkFlow Status", PayrollRec."WorkFlow Status"::Approved);
                    PayrollRec.Modify();
                    Variant := PayrollRec;
                    ApprovalEntry2.Get(GetEntryAprovalEntryTable(PayrollRec));
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
    procedure ReOpen_PayrollStatCode(): Code[128]
    begin
        exit(UpperCase('ReOpen_NEW_PayrollStat'));
    end;

    procedure ReOpen_PayrollStat(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        PayrollRec: Record "Payroll Statement";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpen_PayrollStat(Variant);
                end;
            DATABASE::"Payroll Statement":
                begin
                    RecRef.SetTable(PayrollRec);
                    PayrollRec.Validate("WorkFlow Status", PayrollRec."WorkFlow Status"::Open);
                    PayrollRec.Modify();
                    Variant := PayrollRec;
                end;
        end;
    end;

    //Code For MEssage Notification start
    procedure PayrollStatMessageCode(): Code[128]
    begin
        exit(UpperCase('PayrollStat_NEW_Message'));
    end;

    procedure PayrollStatMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        PayrollRec: Record "Payroll Statement";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Payroll Statement":
                begin
                    RecRef.SetTable(PayrollRec);
                    Message('The approval request for the record has been canceled.');
                    Variant := PayrollRec;
                end;
        end;
    end;

    procedure PayrollStatSendMessageCode(): Code[128]
    begin
        exit(UpperCase('PayrollStat_NEW_SendMessage'));
    end;

    procedure PayrollStatSendMessage(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        PayrollRec: Record "Payroll Statement";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Payroll Statement":
                begin
                    RecRef.SetTable(PayrollRec);
                    Message('The approval request for the record has been sent.');
                    Variant := PayrollRec;
                end;
        end;
    end;
    //Code For Message Notification END

    //Inserting Transfer Order Details to Approval Entry Table
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        PayrollRec: Record "Payroll Statement";
    begin
        case RecRef.Number of
            database::"Payroll Statement":
                begin
                    RecRef.SetTable(PayrollRec);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := PayrollRec."Payroll Statement ID";
                end;
        end;
    end;

    //Adding Events to event Library
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_PayrollStatApprovalCode, Database::"Payroll Statement", Send_PayrollStatReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApprove_PayrollStatApprovalCode, Database::"Approval Entry", AppReq_PayrollStat, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancel_PayrollStatApprovalCode, Database::"Payroll Statement", CancelForPendAppTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReject_PayrollStatApprovalCode, Database::"Approval Entry", RejReq_PayrollStat, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegate_PayrollStatApprovalCode, Database::"Approval Entry", DelReq_PayrollStat, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSend_PayrollStatRejectCode, Database::"Payroll Statement", Send_PayrollStatReject_PayrollStatReq, 0, false);
    end;

    //Adding Newly created responses to workflowResponselibrary
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCode_PayrollStat, 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(Release_PayrollStatCode, 0, Release_PayrollStatTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpen_PayrollStatCode, 0, ReOpen_PayrollStatTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(PayrollStatMessageCode, 0, PayrollStat_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(PayrollStatSendMessageCode, 0, PayrollStatSend_Message, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToReject_LT_Code_PayrollStat, 0, SendForRejectTxt, 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit InitCodeunit_Payroll;
    begin
        case ResponseFunctionName of
            WorkFlowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnApprove_PayrollStatApprovalCode());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForPayrollStat(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of

                SetStatusToPendingApprovalCode_PayrollStat():
                    begin
                        SetStatusToPendingApproval_PayrollStat(Variant);
                        ResponseExecuted := true;
                    end;
                Release_PayrollStatCode():
                    begin
                        Release_PayrollStat(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpen_PayrollStatCode():
                    begin
                        ReOpen_PayrollStat(Variant);
                        ResponseExecuted := true;
                    end;
                SendEmailCodePayrollStat():
                    begin
                        SendEmailRFQ(Variant);
                        ResponseExecuted := true;
                    end;
                PayrollStatMessageCode():
                    begin
                        PayrollStatMessage(Variant);
                        ResponseExecuted := true;
                    end;
                PayrollStatSendMessageCode():
                    begin
                        PayrollStatSendMessage(Variant);
                        ResponseExecuted := true;
                    end;
                SetStatusToReject_LT_Code_PayrollStat():
                    begin
                        Message('Workflow');
                        SetStatusToReject_LT_PayrollStat(Variant);
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
            database::"Payroll Statement":
                IsSufficient := IsRFQSufficeintApprover(UserSetup, ApprovalEntryArgument."Amount (LCY)");
        end;
    end;
    //Approver ChaIN End

    // Emial Notificaion Creation Start
    procedure SendEmailCodePayrollStat(): Code[128]
    begin
        exit(UpperCase('SendEmail_NEW_PayrollStat'));
    end;

    procedure SendEmailRFQ(var Variant: Variant)
    var
        RecRef: RecordRef;
        RFQHeader: Record "Payroll Statement";
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
            DATABASE::"Payroll Statement":
                begin
                    TableId := RecRef.Number;
                    RecRef.SetTable(RFQHeader);
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Table ID", TableId);
                    ApprovalEntry.SetRange("Document No.", RFQHeader."Payroll Statement ID");
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

    local procedure GetEntryAprovalEntryTable(PayrollRec: Record "Payroll Statement"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", PayrollRec."Payroll Statement ID");
        ApprovalEntry.SetRange("Record ID to Approve", PayrollRec.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Payroll Statement");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;
}