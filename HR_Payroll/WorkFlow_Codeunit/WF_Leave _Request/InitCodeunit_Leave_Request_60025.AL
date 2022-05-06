codeunit 60025 InitCodeunit_Leave_Request
{
    Permissions = tabledata 454 = rimd;
    //Events creation Start   Leave Req WF
    [IntegrationEvent(false, false)]
    procedure OnSend_LeaveReq_Approval(var LeaveReqRec: Record "Leave Request Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancel_LeaveReq_Approval(var LeaveReqRec: Record "Leave Request Header")
    begin
    end;
    //Event Creation End
    procedure Is_LeaveReq_Enabled(var LeaveReqRec: Record "Leave Request Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_Leave_Request;
    begin
        exit(WFMngt.CanExecuteWorkflow(LeaveReqRec, WFCode.RunWorkflowOnSend_LeaveReq_ApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        LeaveReqRec: Record "Leave Request Header";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not Is_LeaveReq_Enabled(LeaveReqRec) then
            Error(NoWorkflowEnb);
    end;

    procedure Is_LeaveReq_ApprovalWorkflowEnabled(RequisitionRequests: record "Leave Request Header"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_LeaveReq_ApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        RFQEventMgt: Codeunit WFCode_Leave_Request;
}