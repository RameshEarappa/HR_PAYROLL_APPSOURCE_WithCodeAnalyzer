page 60148 "Asset Issue List"
{
    CardPageID = "Asset Issue";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Asset Assignment Register";
    SourceTableView = WHERE("Transaction Type" = FILTER(Issue), Posted = FILTER(false));
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Issue Document No."; Rec."Issue Document No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("FA No"; Rec."FA No")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("FA Description"; Rec."FA Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Issue to/Return by"; Rec."Issue to/Return by")
                {
                    Caption = 'Issue to';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Asset Custody Type"; Rec."Asset Custody Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("WorkFlow Status"; Rec."WorkFlow Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Action")
            {
                Caption = 'Action';
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'POST';
                    Ellipsis = true;
                    Enabled = WFRelBoolG;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(AssetAssignmentRegister);
                        if AssetAssignmentRegister.FINDSET then begin
                            Rec.TESTFIELD("WorkFlow Status", Rec."WorkFlow Status"::Released);
                            Post_Action;
                            Rec.DELETE
                        end;
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = WFOpenBoolG;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TESTFIELD("Issue Document No.");
                        Rec.TESTFIELD("FA No");
                        Rec.TESTFIELD("Issue to/Return by");
                        Rec.TESTFIELD("Issue Date");
                        Rec.TESTFIELD("Document Date");
                        RecordIDUpDate(Rec);

                        AssetAssiReg.RESET;
                        AssetAssiReg.SETRANGE("FA No", Rec."FA No");
                        AssetAssiReg.SETFILTER("WorkFlow Status", '%1|%2', AssetAssiReg."WorkFlow Status"::"Pending For Approval", AssetAssiReg."WorkFlow Status"::Released);

                        if AssetAssiReg.FINDSET then begin
                            repeat
                                if AssetAssiReg."WorkFlow Status" <> AssetAssiReg."WorkFlow Status"::Open then
                                    if AssetAssiReg."Asset Custody Type" = AssetAssiReg."Asset Custody Type"::Employee then begin
                                        Employee.RESET;
                                        if Employee.GET(AssetAssiReg."Issue to/Return by") then;
                                        ERROR('This Asset has been requested by  %2 - %1', Employee.FullName, Employee."No.");
                                    end else begin
                                        if AssetAssiReg."Asset Custody Type" = AssetAssiReg."Asset Custody Type"::Department then begin
                                            PayrollDepartment.RESET;
                                            if PayrollDepartment.GET(AssetAssiReg."Issue to/Return by") then;
                                            ERROR('This Asset has been requested by %1', PayrollDepartment.Description);

                                        end;
                                    end;
                            until AssetAssiReg.NEXT = 0;
                        end;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = WFPendingBoolG;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec."WorkFlow Status" := Rec."WorkFlow Status"::Open;
                        Cancel := true;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalEntry: Record "Approval Entry";
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Asset Assignment Register");
                        ApprovalEntry.SETRANGE("Record ID to Approve", Rec.RecordId);
                        ApprovalEntry.SETRANGE("Related to Change", FALSE);
                        PAGE.RUN(70010, ApprovalEntry);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = PostAction;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        CurrPage.SETSELECTIONFILTER(AssetAssignmentRegister);
                        if AssetAssignmentRegister.FINDSET then begin
                            if (AssetAssignmentRegister."WorkFlow Status" = AssetAssignmentRegister."WorkFlow Status"::Rejected) or (AssetAssignmentRegister."WorkFlow Status" = AssetAssignmentRegister."WorkFlow Status"::Released) then begin
                                AssetAssignmentRegister."WorkFlow Status" := AssetAssignmentRegister."WorkFlow Status"::Open;
                                AssetAssignmentRegister.MODIFY;
                            end else
                                ERROR('You cannot reopen untill the document the workFlow is approved or rejected');
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlVisibility;

        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Rejected) or (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            PostAction := true;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;

        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Rejected) or (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            PostAction := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Rejected) or (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            PostAction := true;
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility;

        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Rejected) or (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            PostAction := true;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        RecRef: RecordRef;
        RecordLinkRec: Record "Record Link";
        FASetup: Record "FA Setup";
        NoSeriesCU: Codeunit NoSeriesManagement;
        FA_Rec: Record "Fixed Asset";
        PostAction: Boolean;
        AssetAssignmentRegister: Record "Asset Assignment Register";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenAction: Boolean;
        FixedAssetRec: Record "Fixed Asset";
        EmployeeRec: Record Employee;
        AssetAssiReg: Record "Asset Assignment Register";
        Cancel: Boolean;
        Employee: Record Employee;
        PayrollDepartment: Record "Payroll Department";
        AssetAssignmentRegisterG: Record "Asset Assignment Register";
        WFRelBoolG: Boolean;
        WFOpenBoolG: Boolean;
        WFPendingBoolG: Boolean;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        if rec."WorkFlow Status" = Rec."WorkFlow Status"::Released then
            WFRelBoolG := true
        else
            WFRelBoolG := false;

        if rec."WorkFlow Status" = Rec."WorkFlow Status"::Open then
            WFOpenBoolG := true
        else
            WFOpenBoolG := false;

        if rec."WorkFlow Status" = Rec."WorkFlow Status"::"Pending For Approval" then
            WFPendingBoolG := true
        else
            WFPendingBoolG := false;
    end;

    procedure RecordIDUpDate(var AssetAssignmentRegister: Record "Asset Assignment Register")
    var
        RecRef: RecordRef;
    begin
        RecRef.GETTABLE(AssetAssignmentRegister);
        AssetAssignmentRegister.RecID := RecRef.RECORDID;
        AssetAssignmentRegister.MODIFY(true);
    end;

    local procedure Post_Action()
    var
        AssetAssRegRec: Record "Asset Assignment Register";
    begin
        AssetAssRegRec.INIT;
        AssetAssRegRec."Issue Document No." := Rec."Issue Document No.";
        FASetup.GET;
        AssetAssRegRec.VALIDATE("FA No", Rec."FA No");
        AssetAssRegRec."FA Description" := Rec."FA Description";
        AssetAssRegRec."Asset Owner" := Rec."Asset Owner";
        AssetAssRegRec.Posted := true;
        AssetAssRegRec."Asset Custody Type" := Rec."Asset Custody Type";
        AssetAssRegRec."Posting Date" := WORKDATE;
        AssetAssRegRec."Posting Date" := WORKDATE;
        AssetAssRegRec."Company Name" := Rec."Company Name";
        AssetAssRegRec."Issue to/Return by" := Rec."Issue to/Return by";
        AssetAssRegRec.Name := Rec.Name;
        AssetAssRegRec."Document Date" := Rec."Document Date";
        AssetAssRegRec."Issue Date" := Rec."Issue Date";
        AssetAssRegRec."Issued Till" := Rec."Issued Till";
        AssetAssRegRec.Status := AssetAssRegRec.Status::Issued;
        AssetAssRegRec.VALIDATE("Posting Date", TODAY);
        AssetAssRegRec."Asset Owner" := Rec."Asset Owner";
        if AssetAssRegRec.INSERT then begin
            if Rec."Asset Custody Type" = Rec."Asset Custody Type"::Employee then begin
                FA_Rec.RESET;
                if FA_Rec.GET(Rec."FA No") then begin
                end;
            end else
                if Rec."Asset Custody Type" = Rec."Asset Custody Type"::Department then begin
                    if FA_Rec.GET(Rec."FA No") then begin
                        FA_Rec.MODIFY;
                    end;
                end;
        end;
    end;
}