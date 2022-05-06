codeunit 60039 InitCodeunit_Payroll
{
    //Events creation Start   
    [IntegrationEvent(false, false)]
    procedure OnSendPayrollStat_Approval(var PayrollRec: Record "Payroll Statement")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPayrollStat_Approval(var PayrollRec: Record "Payroll Statement")
    begin
    end;
    //Event Creation End

    procedure IsPayrollStat_Enabled(var PayrollRec: Record "Payroll Statement"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_Payroll;
    begin
        exit(WFMngt.CanExecuteWorkflow(PayrollRec, WFCode.RunWorkflowOnSend_PayrollStatApprovalCode))
    end;

    procedure CheckWorkflowEnabled(var PayrollRec: Record "Payroll Statement"): Boolean
    VAR
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsPayrollStat_Enabled(PayrollRec) then
            Error(NoWorkflowEnb);
    end;

    procedure IsPayrollStatApprovalWorkflowEnabled(RequisitionRequests: Record "Payroll Statement"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_PayrollStatApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        PayrollRec: Record "Payroll Statement";
        RFQEventMgt: Codeunit WFCode_Payroll;
}