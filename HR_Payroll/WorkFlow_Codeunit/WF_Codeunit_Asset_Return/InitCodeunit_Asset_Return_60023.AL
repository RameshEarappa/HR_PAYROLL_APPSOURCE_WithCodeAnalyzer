codeunit 60023 InitCodeunit_Asset_Return
{
    //Events creation Start   Asset Assignment Register
    [IntegrationEvent(false, false)]
    procedure OnSendAssetReturn_Approval(var AssetAssignmentRegister: Record "Asset Assignment Register")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelAssetReturn_Approval(var AssetAssignmentRegister: Record "Asset Assignment Register")
    begin
    end;
    //Event Creation End

    procedure IsAssetReturn_Enabled(var AssetAssignmentRegister: Record "Asset Assignment Register"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WFCode_Asset_Return;
    begin
        exit(WFMngt.CanExecuteWorkflow(AssetAssignmentRegister, WFCode.RunWorkflowOnSend_AssetReturnApprovalCode))
    end;

    local procedure CheckWorkflowEnabled(): Boolean
    var
        AssetAssignmentRegister: Record "Asset Assignment Register";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsAssetReturn_Enabled(AssetAssignmentRegister) then
            Error(NoWorkflowEnb);
    end;

    procedure IsAssetReturnApprovalWorkflowEnabled(RequisitionRequests: record "Asset Assignment Register"): Boolean
    begin
        exit(WFMngt.CanExecuteWorkflow(RequisitionRequests, RFQEventMgt.RunWorkflowOnSend_AssetReturnApprovalCode()));
    end;

    var
        WFMngt: Codeunit "Workflow Management";
        RFQEventMgt: Codeunit "WFCode_Asset_Return";
}