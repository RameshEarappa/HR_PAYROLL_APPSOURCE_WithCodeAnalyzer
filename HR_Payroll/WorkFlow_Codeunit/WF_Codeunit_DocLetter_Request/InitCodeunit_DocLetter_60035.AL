codeunit 60035 InitCodeunit_DocLetterRec
{
    //Events creation Start  
    [IntegrationEvent(false, false)]
    procedure OnSendDocLetter_Approval(var DocLetterRec: Record "Document Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelDocLetter_Approval(var DocLetterRec: Record "Document Request")
    begin
    end;
    //Event Creation End

    procedure IsDocLetter_Enabled(var DocLetterRec: Record "Document Request"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_DocLetter;
    begin
        exit(WFMngt.CanExecuteWorkflow(DocLetterRec, WFCode.RunWorkflowOnSend_DocLetterApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        DocLetterRec: Record "Document Request";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsDocLetter_Enabled(DocLetterRec) then
            Error(NoWorkflowEnb);
    end;

    procedure IsDocLetterApprovalWorkflowEnabled(RequisitionRequests: Record "Document Request"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_DocLetterApprovalCode()));
    end;


    var
        WFMngt: Codeunit "Workflow Management";
        Rec: Record "Document Request";
        RFQEventMgt: Codeunit WFCode_DocLetter;
}