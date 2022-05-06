page 60147 "Asset Issue"
{
    Caption = 'Asset Issue';
    DeleteAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Asset Assignment Register";
    SourceTableView = SORTING("Issue Document No.", "Posted Issue Document No", "Return Document No.", "Posted Return Document No")
                      ORDER(Ascending);
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Issue Document No."; Rec."Issue Document No.")
                {
                    Caption = 'Document No.';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("FA No"; Rec."FA No")
                {
                    Caption = 'Fixed Asset No.';
                    Editable = Edit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    TableRelation = "Fixed Asset" where("Asset Custody" = filter(Employer));
                    trigger OnValidate()
                    begin
                        AssetAssiReg.RESET;
                        AssetAssiReg.SETRANGE("FA No", Rec."FA No");
                        if AssetAssiReg.FINDSET then begin
                            repeat
                                if AssetAssiReg."WorkFlow Status" <> AssetAssiReg."WorkFlow Status"::Open then begin

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

                                end;
                            until AssetAssiReg.NEXT = 0;
                        end;
                    end;
                }
                field("FA Description"; Rec."FA Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Asset Owner"; Rec."Asset Owner")
                {
                    Editable = false;
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        Employee: Record Employee;
                    begin
                        Employee.RESET;
                        Employee.SETRANGE("No.", Rec."Asset Owner");
                        if Employee.FINDFIRST then
                            PAGE.RUNMODAL(5201, Employee);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Employee: Record Employee;
                    begin
                        Employee.RESET;
                        Employee.SETRANGE("No.", Rec."Asset Owner");
                        if Employee.FINDFIRST then
                            PAGE.RUNMODAL(5201, Employee);
                    end;
                }
                field("Asset Owner Name"; Rec."Asset Owner Name")
                {
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Asset Custody Type"; Rec."Asset Custody Type")
                {
                    Caption = 'Issue Type';
                    Editable = Edit;
                    ApplicationArea = All;
                }
                field("Issue to/Return by"; Rec."Issue to/Return by")
                {
                    Caption = 'Issue to';
                    Editable = Edit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Sub Department"; Rec."Sub Department")
                {
                    Editable = Edit2;
                    ApplicationArea = All;
                }
                field("Sub Department Name"; Rec."Sub Department Name")
                {
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = Edit;
                    ApplicationArea = All;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    Editable = Edit;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Issued Till"; Rec."Issued Till")
                {
                    Editable = Edit;
                    ApplicationArea = All;
                }
                field("WorkFlow Status"; Rec."WorkFlow Status")
                {
                    Editable = false;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released then
                            PostAction := true;
                    end;
                }
                field(Posted; Rec.Posted)
                {
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
                        IF Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released THEN
                            Post_Action
                        ELSE
                            ERROR('Workflow Status should be Released')
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
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

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
                    Visible = OpenApprovalEntriesExistForCurrUser;

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
                    Visible = OpenApprovalEntriesExistForCurrUser;

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
                        Ass_Iss_Init: Codeunit InitCodeunit_Asset_Issue;
                    begin
                        Rec.TESTFIELD("Issue Document No.");
                        Rec.TESTFIELD("FA No");
                        Rec.TESTFIELD("Issue to/Return by");
                        Rec.TESTFIELD("Issue Date");
                        Rec.TESTFIELD("Document Date");
                        RecordIDUpDate(Rec);
                        AssetAssiReg.RESET;
                        AssetAssiReg.SETRANGE("FA No", Rec."FA No");
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

                        FixedAssetRec.RESET;
                        if FixedAssetRec.GET(Rec."FA No") then begin
                            if (FixedAssetRec."Issued to Department" <> '') or (FixedAssetRec."Issued to Employee" <> '') then
                                ERROR('Asset has been issued to other Employee or Department');
                        end;
                        CancelAndDeleteApprovalEntryTrans_LT(Rec."Issue Document No.");
                        FixedAssetRec_G.RESET;
                        FixedAssetRec_G.SETRANGE("No.", Rec."FA No");
                        if FixedAssetRec_G.FINDFIRST then begin
                            LoopOfSeq_LT(Rec."Asset Owner", Rec."Issue Document No.");
                            Ass_Iss_Init.IsAssetIssueApprovalWorkflowEnabled(Rec);
                            Ass_Iss_Init.OnSendAssetIssue_Approval(Rec);
                        end;
                    End;
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
                        Ass_Iss_Init: Codeunit InitCodeunit_Asset_Issue;
                    begin
                        Ass_Iss_Init.OnCancelAssetIssue_Approval(Rec);
                        Cancel := true;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Promoted = true;
                    PromotedCategory = Category4;
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';
                    trigger OnAction()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApprovalEntry: Record "Approval Entry";
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Asset Assignment Register");
                        ApprovalEntry.SETRANGE("Record ID to Approve", Rec.RecordId);
                        ApprovalEntry.SETRANGE("Related to Change", FALSE);
                        PAGE.RUN(70010, ApprovalEntry);
                    end;
                }
                action(ApprovalsDelete)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals Delete';
                    Image = Delete;
                    Visible = false;

                    trigger OnAction()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApprovalEntry: Record "Approval Entry";
                    begin
                        if Confirm('you want to delete all recors ?') then begin
                            ApprovalEntry.RESET;
                            ApprovalEntry.DeleteAll();
                        end;
                    end;
                }

                action(Comments)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'View or add comments.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

                        RecRef: RecordRef;
                        ApprovalEntry: Record "Approval Entry";
                        RecID: RecordID;
                        InitialiseAllCodeunit: Codeunit InitialiseAllCodeunit;
                    begin
                        InitialiseAllCodeunit.Run();
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
                        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::"Pending For Approval" then
                            ERROR('WorkFlow status should be Approved for reopen');

                        Rec."WorkFlow Status" := Rec."WorkFlow Status"::Open;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlVisibility;


        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::Open then
            Edit := true
        else
            Edit := false;

        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Open) and (Rec."Asset Custody Type" <> Rec."Asset Custody Type"::Employee) then
            Edit2 := true
        else
            Edit2 := false;

        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Rejected) or (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            PostAction := true;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;

        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::Open then
            Edit := true
        else
            Edit := false;

        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Open) and (Rec."Asset Custody Type" <> Rec."Asset Custody Type"::Employee) then
            Edit2 := true
        else
            Edit2 := false;
        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Rejected) or (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            PostAction := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Rejected) or (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            PostAction := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Date" := TODAY;
        Rec."Issue Date" := TODAY;
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
        NoSeriesRec: Record "No. Series";
        NoSeriesCU: Codeunit NoSeriesManagement;
        FASetup: Record "FA Setup";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        AssetAssiReg: Record "Asset Assignment Register";
        [InDataSet]
        Edit: Boolean;
        RecRef: RecordRef;
        RecordLinkRec: Record "Record Link";
        FA_Rec: Record "Fixed Asset";
        [InDataSet]
        PostAction: Boolean;
        FixedAssetRec: Record "Fixed Asset";
        EmployeeRec: Record Employee;
        Cancel: Boolean;
        SubDepRec: Record "Sub Department";
        [InDataSet]
        Edit2: Boolean;
        Employee: Record Employee;
        PayrollDepartment: Record "Payroll Department";
        FixedAssetRec_G: Record "Fixed Asset";
        ___________Customise_Work_flow_____________: Boolean;
        i: Integer;
        WFRelBoolG: Boolean;
        WFOpenBoolG: Boolean;
        WFPendingBoolG: Boolean;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
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

    local procedure Post_Action()
    var
        AssetAssRegRec: Record "Asset Assignment Register";
    begin

        AssetAssRegRec.INIT;
        AssetAssRegRec."Issue Document No." := Rec."Issue Document No.";
        FASetup.GET;
        AssetAssRegRec."Posted Issue Document No" := NoSeriesCU.GetNextNo(FASetup."Posted Issue Document No", WORKDATE, false);
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
        AssetAssRegRec."Sub Department" := Rec."Sub Department";
        if AssetAssRegRec.INSERT then begin
            CurrPage.Update();

            if Rec."Asset Custody Type" = Rec."Asset Custody Type"::Employee then begin
                FA_Rec.RESET;
                if FA_Rec.GET(Rec."FA No") then begin
                    FA_Rec."Asset Custody" := FA_Rec."Asset Custody"::Employee;
                    FA_Rec."Issued to Employee" := Rec."Issue to/Return by";
                    FA_Rec."Issued to Department" := '';
                    if FA_Rec.MODIFY then begin
                        Message('POSTED');
                        Rec.Delete()
                    End;
                end;
            end else
                if Rec."Asset Custody Type" = Rec."Asset Custody Type"::Department then begin
                    if FA_Rec.GET(Rec."FA No") then begin
                        FA_Rec."Asset Custody" := FA_Rec."Asset Custody"::Department;
                        FA_Rec."Issued to Department" := Rec."Issue to/Return by";
                        FA_Rec."Issued to Employee" := '';
                        if FA_Rec.MODIFY then begin
                            Message('POSTED');
                            Rec.Delete()
                        end;
                    end;
                end;
        end;
    end;

    procedure RecordIDUpDate(var AssetAssignmentRegister: Record "Asset Assignment Register")
    var
        RecRef: RecordRef;
    begin
        RecRef.GETTABLE(AssetAssignmentRegister);
        AssetAssignmentRegister.RecID := RecRef.RECORDID;
        AssetAssignmentRegister.MODIFY(true);
    end;

    local procedure UpdateUserIDBaseOnResponsiableEmployee_LT(EmployeeNo_P: Code[30])
    var
        WorkflowUserGroupRec_L: Record "Workflow User Group";
        WorkflowUserGroupMemberRec_L: Record "Workflow User Group Member";
        WorkflowTableRelationValueRec_L: Record "Workflow Table Relation Value";
        UserSetupRec_L: Record "User Setup";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        UserSetupRec_L.RESET;
        if not UserSetupRec_L.FINDFIRST then
            ERROR('Employee %1 Not have any User ID in  User Setup', EmployeeNo_P)
        else begin
            WorkflowStepArgument.RESET;
            if WorkflowStepArgument.FINDFIRST then;
            WorkflowUserGroupMemberRec_L.RESET;
            WorkflowUserGroupMemberRec_L.SETRANGE("Workflow User Group Code", WorkflowStepArgument."Workflow User Group Code");
            WorkflowUserGroupMemberRec_L.SETRANGE("Sequence No.", 1);
            if WorkflowUserGroupMemberRec_L.FINDFIRST then begin
                WorkflowUserGroupMemberRec_L.RENAME(WorkflowStepArgument."Workflow User Group Code", UserSetupRec_L."User ID");
                WorkflowUserGroupMemberRec_L.VALIDATE("User Name", UserSetupRec_L."User ID");
                WorkflowUserGroupMemberRec_L.MODIFY;
            end else begin
                WorkflowUserGroupMemberRec_L.INIT;
                WorkflowUserGroupMemberRec_L.VALIDATE("Workflow User Group Code", WorkflowStepArgument."Workflow User Group Code");
                WorkflowUserGroupMemberRec_L.VALIDATE("User Name", UserSetupRec_L."User ID");
                WorkflowUserGroupMemberRec_L.VALIDATE("Sequence No.", 1);
                WorkflowUserGroupMemberRec_L.INSERT;
            end;
        end;
    end;

    procedure GetEmployeePostionEmployeeID_LT(EmployeeID: Code[30]): Code[50]
    var
        PayrollJobPosWorkerAssignRec_L: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRec_L: Record "Payroll Position";
    begin
        PayrollJobPosWorkerAssignRec_L.RESET;
        PayrollJobPosWorkerAssignRec_L.SETRANGE(Worker, EmployeeID);
        PayrollJobPosWorkerAssignRec_L.SETRANGE("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRec_L.FINDFIRST then begin
            PayrollPositionRec_L.RESET;
            PayrollPositionRec_L.SETRANGE("Position ID", PayrollJobPosWorkerAssignRec_L."Position ID");
            if PayrollPositionRec_L.FINDFIRST then
                exit(PayrollPositionRec_L.Worker);
        end;
    end;

    procedure InsertApprovalEntryTrans_LT(TransID: Code[30]; SenderID: Code[50]; ReportingID: Code[50]; DelegateID: Code[50]; SequenceID: Integer)
    var
        ApprovalEntrtyTranscationRec_L: Record "Approval Entrty Transcation";
    begin
        ApprovalEntrtyTranscationRec_L.RESET;
        ApprovalEntrtyTranscationRec_L.INIT;
        ApprovalEntrtyTranscationRec_L."Trans ID" := TransID;
        ApprovalEntrtyTranscationRec_L."Advance Payrolll Type" := ApprovalEntrtyTranscationRec_L."Advance Payrolll Type"::Leaves;
        ApprovalEntrtyTranscationRec_L."Employee ID - Sender" := SenderID;
        ApprovalEntrtyTranscationRec_L."Reporting ID - Approver" := ReportingID;
        ApprovalEntrtyTranscationRec_L."Delegate ID" := DelegateID;
        ApprovalEntrtyTranscationRec_L."Sequence No." := SequenceID;
        ApprovalEntrtyTranscationRec_L.INSERT;
    end;

    procedure LoopOfSeq_LT(EmpID: Code[50]; TransID: Code[30])
    var
        ApprovalLevelSetupRec_L: Record "Approval Level Setup";
        UserSetupRec_L: Record "User Setup";
        UserSetupRec2_L: Record "User Setup";
        OneEmpID: Code[50];
        TwoEmpID: Code[50];
        ThreeEmpID: Code[50];
        PreEmpID: Code[50];
        SenderID_L: Code[50];
        ReportingID_L: Code[50];
        CountForLoop_L: Integer;
        Delegate_L: Code[80];
        SeqNo_L: Integer;
    begin
        CLEAR(SenderID_L);
        CLEAR(ReportingID_L);
        CLEAR(OneEmpID);
        CLEAR(TwoEmpID);
        CLEAR(ThreeEmpID);
        CLEAR(Delegate_L);

        ApprovalLevelSetupRec_L.RESET;
        ApprovalLevelSetupRec_L.SETRANGE("Advance Payrolll Type", ApprovalLevelSetupRec_L."Advance Payrolll Type"::"Asset Issue");
        if ApprovalLevelSetupRec_L.FINDFIRST then begin

            UserSetupRec_L.RESET;
            if not UserSetupRec_L.FINDFIRST then
                ERROR('Employee Id  %1 must have a value in User Setup', EmpID);

            UserSetupRec_L.TESTFIELD("User ID");

            if not ApprovalLevelSetupRec_L."Direct Approve By Finance" then begin
                CLEAR(Delegate_L);
                if CheckDelegateForEmployee_LT(UserSetupRec_L."User ID", 2) <> '' then
                    Delegate_L := CheckDelegateForEmployee_LT(UserSetupRec_L."User ID", 2)
                else
                    Delegate_L := UserSetupRec_L."User ID";
                InsertApprovalEntryTrans_LT(TransID, USERID, UserSetupRec_L."User ID", Delegate_L, SeqNo_L);

                if (ApprovalLevelSetupRec_L."Finance User ID" <> '') then begin
                    CLEAR(Delegate_L);
                    if CheckDelegateForEmployee_LT(ApprovalLevelSetupRec_L."Finance User ID", 2) <> '' then
                        Delegate_L := CheckDelegateForEmployee_LT(UserSetupRec_L."User ID", 2)
                    else
                        Delegate_L := ApprovalLevelSetupRec_L."Finance User ID";
                    InsertApprovalEntryTrans_LT(TransID, USERID, ApprovalLevelSetupRec_L."Finance User ID", Delegate_L, SeqNo_L);
                end
            end;

            if (ApprovalLevelSetupRec_L."Finance User ID" <> '') and (ApprovalLevelSetupRec_L."Direct Approve By Finance") then begin
                CLEAR(Delegate_L);
                if CheckDelegateForEmployee_LT(ApprovalLevelSetupRec_L."Finance User ID", 2) <> '' then
                    Delegate_L := CheckDelegateForEmployee_LT(UserSetupRec_L."User ID", 2)
                else
                    Delegate_L := ApprovalLevelSetupRec_L."Finance User ID";
                InsertApprovalEntryTrans_LT(TransID, USERID, ApprovalLevelSetupRec_L."Finance User ID", Delegate_L, SeqNo_L);
            end
        end;
    end;

    procedure CancelAndDeleteApprovalEntryTrans_LT(DocNo_P: Code[50])
    var
        ApprovalEntrtyTranscation: Record "Approval Entrty Transcation";
    begin
        ApprovalEntrtyTranscation.RESET;
        ApprovalEntrtyTranscation.SETRANGE("Trans ID", DocNo_P);
        if ApprovalEntrtyTranscation.FINDSET then
            ApprovalEntrtyTranscation.DELETEALL;
    end;

    procedure CheckDelegateForEmployee_LT(checkDelegateInfo_P: Code[150]; IsEmployeeOrUser: Integer): Code[80]
    var
        DelegateWFLTRec_L: Record "Delegate - WFLT";
        UserSetupRecL: Record "User Setup";
    begin
        if IsEmployeeOrUser = 1 then begin
            DelegateWFLTRec_L.RESET;
            DelegateWFLTRec_L.SETRANGE("Employee Code", checkDelegateInfo_P);
            if DelegateWFLTRec_L.FINDFIRST then begin
                if DelegateWFLTRec_L."Delegate ID" <> '' then
                    if (DelegateWFLTRec_L."From Date" >= TODAY) and (DelegateWFLTRec_L."To Date" <= TODAY) then
                        exit(DelegateWFLTRec_L."Delegate ID");
            end;
        end else
            if IsEmployeeOrUser = 2 then begin
                UserSetupRecL.RESET;
                UserSetupRecL.SETRANGE("User ID", checkDelegateInfo_P);
                if UserSetupRecL.FINDFIRST then;

                DelegateWFLTRec_L.RESET;
                if DelegateWFLTRec_L.FINDFIRST then begin
                    if DelegateWFLTRec_L."Delegate ID" <> '' then begin
                        if (DelegateWFLTRec_L."From Date" <= TODAY) and (DelegateWFLTRec_L."To Date" >= TODAY) then begin
                            exit(DelegateWFLTRec_L."Delegate ID");
                        end
                    end;
                end;
            end;
    end;

    procedure GetEmployeePostionEmployeeID_FinalPosituion_LT(EmployeeID: Code[30]): Boolean
    var
        PayrollJobPosWorkerAssignRec_L: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRec_L: Record "Payroll Position";
    begin
        PayrollJobPosWorkerAssignRec_L.RESET;
        PayrollJobPosWorkerAssignRec_L.SETRANGE(Worker, EmployeeID);
        PayrollJobPosWorkerAssignRec_L.SETRANGE("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRec_L.FINDFIRST then begin
            PayrollPositionRec_L.RESET;
            PayrollPositionRec_L.SETRANGE("Position ID", PayrollJobPosWorkerAssignRec_L."Position ID");
            if PayrollPositionRec_L.FINDFIRST then
                if PayrollPositionRec_L."Final authority" then
                    exit(true)
                else
                    exit(false);
        end;
    end;
}