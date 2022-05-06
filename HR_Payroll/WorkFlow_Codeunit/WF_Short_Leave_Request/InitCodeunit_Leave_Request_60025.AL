codeunit 60057 InitCodeunit_Short_Leave_Req
{
    //Events creation Start   Leave Req WF
    [IntegrationEvent(false, false)]
    procedure OnSend_ShortLeaveReq_Approval(var ShortLeaveReqRec: Record "Short Leave Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancel_ShortLeaveReq_Approval(var ShortLeaveReqRec: Record "Short Leave Header")
    begin
    end;
    //Event Creation End
    procedure Is_ShortLeaveReq_Enabled(var ShortLeaveReqRec: Record "Short Leave Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_Short_Leave_Request;
    begin
        exit(WFMngt.CanExecuteWorkflow(ShortLeaveReqRec, WFCode.RunWorkflowOnSend_ShortLeaveReq_ApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        ShortLeaveReqRec: Record "Short Leave Header";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not Is_ShortLeaveReq_Enabled(ShortLeaveReqRec) then
            Error(NoWorkflowEnb);
    end;

    procedure Is_ShortLeaveReq_ApprovalWorkflowEnabled(ShortLeaveReqRec: record "Short Leave Header"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(ShortLeaveReqRec, RFQEventMgt.RunWorkflowOnSend_ShortLeaveReq_ApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        RFQEventMgt: Codeunit WFCode_Short_Leave_Request;
}