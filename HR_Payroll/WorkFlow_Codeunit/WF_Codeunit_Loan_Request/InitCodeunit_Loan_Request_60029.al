codeunit 60029 InitCodeunit_Loan_Request
{
    //Events creation Start   Asset Assignment Register
    [IntegrationEvent(false, false)]
    procedure OnSendLoan_Request_Approval(var LoanReqRec: Record "Loan Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoan_Request_Approval(var LoanReqRec: Record "Loan Request")
    begin
    end;
    //Event Creation End

    procedure Is_Loan_Request_Enabled(var LoanReqRec: Record "Loan Request"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_Loan_Request;
    begin
        exit(WFMngt.CanExecuteWorkflow(LoanReqRec, WFCode.RunWorkflowOnSend_Loan_RequestApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        LoanReqRec: Record "Loan Request";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not Is_Loan_Request_Enabled(LoanReqRec) then
            Error(NoWorkflowEnb);
    end;

    procedure Is_Loan_RequestApprovalWorkflowEnabled(RequisitionRequests: record "Asset Assignment Register"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_Loan_RequestApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        LoanReqRec: Record "Loan Request";
        RFQEventMgt: Codeunit WFCode_Loan_Request;
}