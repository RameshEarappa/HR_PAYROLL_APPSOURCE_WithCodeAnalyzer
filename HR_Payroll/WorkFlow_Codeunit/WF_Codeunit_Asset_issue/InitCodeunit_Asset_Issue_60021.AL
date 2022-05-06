codeunit 60021 InitCodeunit_Asset_Issue
{
    //Events creation Start   Asset Assignment Register
    [IntegrationEvent(false, false)]
    procedure OnSendAssetIssue_Approval(var AssetAssignmentRegister: Record "Asset Assignment Register")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelAssetIssue_Approval(var AssetAssignmentRegister: Record "Asset Assignment Register")
    begin
    end;
    //Event Creation End

    procedure IsAssetIssue_Enabled(var AssetAssignmentRegister: Record "Asset Assignment Register"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_Asset_Issue;
    begin
        exit(WFMngt.CanExecuteWorkflow(AssetAssignmentRegister, WFCode.RunWorkflowOnSend_AssetIssueApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        AssetAssignmentRegister: Record "Asset Assignment Register";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsAssetIssue_Enabled(AssetAssignmentRegister) then
            Error(NoWorkflowEnb);
    end;

    procedure IsAssetIssueApprovalWorkflowEnabled(RequisitionRequests: record "Asset Assignment Register"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_AssetIssueApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        RFQEventMgt: Codeunit "WFCode_Asset_Issue";
}