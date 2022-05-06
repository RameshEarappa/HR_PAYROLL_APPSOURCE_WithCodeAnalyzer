codeunit 60033 InitCodeunit_Duty_Resumption
{
    //Events creation Start   
    [IntegrationEvent(false, false)]
    procedure OnSendDuty_Resumption_Approval(var DutyResRec: Record "Duty Resumption")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelDuty_Resumption_Approval(var DutyResRec: Record "Duty Resumption")
    begin
    end;
    //Event Creation End

    procedure IsDuty_Resumption_Enabled(var DutyResRec: Record "Duty Resumption"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_Duty_Resumption;
    begin
        exit(WFMngt.CanExecuteWorkflow(DutyResRec, WFCode.RunWorkflowOnSend_Duty_ResumptionApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        DutyResRec: Record "Duty Resumption";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsDuty_Resumption_Enabled(DutyResRec) then
            Error(NoWorkflowEnb);
    end;

    procedure IsDuty_ResumptionApprovalWorkflowEnabled(RequisitionRequests: Record "Duty Resumption"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_Duty_ResumptionApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        RFQEventMgt: Codeunit WFCode_Duty_Resumption;
}