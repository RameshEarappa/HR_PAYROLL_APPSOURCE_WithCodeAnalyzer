codeunit 60037 InitCodeunit_Final_Sett
{
    //Events creation Start  
    [IntegrationEvent(false, false)]
    procedure OnSendF_And_F_Approval(var FAndF: Record "Full and Final Calculation")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelF_And_F_Approval(var FAndF: Record "Full and Final Calculation")
    begin
    end;
    //Event Creation End

    procedure IsF_And_F_Enabled(var FAndF: Record "Full and Final Calculation"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_Final_Sett;
    begin
        exit(WFMngt.CanExecuteWorkflow(FAndF, WFCode.RunWorkflowOnSend_F_And_FApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        FAndF: Record "Full and Final Calculation";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsF_And_F_Enabled(FAndF) then
            Error(NoWorkflowEnb);
    end;

    procedure IsF_And_FApprovalWorkflowEnabled(RequisitionRequests: Record "Full and Final Calculation"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_F_And_FApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        FNFRec: Record "Full and Final Calculation";
        RFQEventMgt: Codeunit WFCode_Final_Sett;
}