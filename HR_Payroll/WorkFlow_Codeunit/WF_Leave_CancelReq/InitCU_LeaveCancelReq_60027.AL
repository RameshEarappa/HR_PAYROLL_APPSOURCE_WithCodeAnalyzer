codeunit 60027 InitCU_LeaveCancelReq
{
    //Events creation Start   Asset Assignment Register
    [IntegrationEvent(false, false)]
    procedure OnSendLeaveCancel_Approval(var LeaveCancelReq: Record "Cancel Leave Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLeaveCancel_Approval(var LeaveCancelReq: Record "Cancel Leave Request")
    begin
    end;
    //Event Creation End

    procedure IsLeaveCancel_Enabled(var LeaveCancelReq: Record "Cancel Leave Request"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_LeaveCancelReq;
    begin
        exit(WFMngt.CanExecuteWorkflow(LeaveCancelReq, WFCode.RunWorkflowOnSend_LeaveCancelApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        LeaveCancelReq: Record "Cancel Leave Request";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsLeaveCancel_Enabled(LeaveCancelReq) then
            Error(NoWorkflowEnb);
    end;

    procedure IsLeaveCancelApprovalWorkflowEnabled(RequisitionRequests: Record "Cancel Leave Request"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_LeaveCancelApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        RFQEventMgt: Codeunit WFCode_LeaveCancelReq;
}