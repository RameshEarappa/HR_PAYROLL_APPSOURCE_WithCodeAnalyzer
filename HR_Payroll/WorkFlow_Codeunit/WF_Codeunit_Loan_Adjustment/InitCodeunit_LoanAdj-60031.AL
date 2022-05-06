codeunit 60031 InitCodeunit_Loan_Adj
{
    //Events creation Start   
    [IntegrationEvent(false, false)]
    procedure OnSendLoan_Adj_Approval(var LoanAdjRec: Record "Loan Adjustment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoan_Adj_Approval(var LoanAdjRec: Record "Loan Adjustment Header")
    begin
    end;
    //Event Creation End

    procedure IsLoan_Adj_Enabled(var LoanAdjRec: Record "Loan Adjustment Header"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_Loan_Adj;
    begin
        exit(WFMngt.CanExecuteWorkflow(LoanAdjRec, WFCode.RunWorkflowOnSend_Loan_AdjApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        LoanAdjRec: Record "Loan Adjustment Header";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsLoan_Adj_Enabled(LoanAdjRec) then
            Error(NoWorkflowEnb);
    end;

    procedure IsLoan_AdjApprovalWorkflowEnabled(RequisitionRequests: record "Loan Adjustment Header"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_Loan_AdjApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        RFQEventMgt: Codeunit WFCode_Loan_Adj;
}