page 60284 "Document request Card"
{
    Caption = 'Document request Card';
    PageType = Card;
    SourceTable = "Document Request";
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document Request ID"; Rec."Document Request ID")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Addressee; Rec.Addressee)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Document format ID"; Rec."Document format ID")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Certificate For Dependent"; Rec."Certificate For Dependent")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dependent Name"; Rec."Dependent Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document Title"; Rec."Document Title")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("WorkFlow Status"; Rec."WorkFlow Status")
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
            action(Completed)
            {
                Caption = 'Completed';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released then begin
                        Email_Confirmation.Employee_Document_request_Card_Notify(Rec);
                        Message('Document Letter Request has been completed.');
                        Rec.Completed := true;
                        Rec.Modify();
                    end else
                        ERROR('WorkFlow status should be Approved');
                end;
            }
            group(ActionGroup11)
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

                    trigger OnAction();
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

                    trigger OnAction();
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

                    trigger OnAction();
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
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        Wfcode: Codeunit InitCodeunit_DocLetterRec;
                    begin
                        Rec.TESTFIELD("Document Request ID");
                        Rec.TESTFIELD("Employee ID");
                        Rec.TESTFIELD(Addressee);
                        Rec.TESTFIELD("Document format ID");
                        Rec.TESTFIELD("Request Date");
                        Rec.TESTFIELD("Document Date");
                        Wfcode.IsDocLetter_Enabled(rec);
                        Wfcode.OnSendDocLetter_Approval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WfCode: Codeunit InitCodeunit_DocLetterRec;
                    begin
                        WfCode.OnCancelDocLetter_Approval(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = ReopenBoolG;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction();
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                        pa: page "Requests to Approve";
                    begin
                        Rec.TestField(Completed, false);
                        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released then
                            Rec."WorkFlow Status" := Rec."WorkFlow Status"::Open;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction();
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApprovalEntry: Record "Approval Entry";
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Document Request");
                        ApprovalEntry.SETRANGE("Record ID to Approve", Rec.RecordId);
                        ApprovalEntry.SETRANGE("Related to Change", FALSE);
                        PAGE.RUN(70010, ApprovalEntry);
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'View or add comments.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        RecRef: RecordRef;
                        ApprovalEntry: Record "Approval Entry";
                        RecID: RecordID;
                    begin
                        RecRef.GET(Rec.RECORDID);
                        RecID := RecRef.RECORDID;
                        CLEAR(ApprovalsMgmt);
                        ApprovalEntry.RESET;
                        ApprovalEntry.SETRANGE("Table ID", RecID.TABLENO);
                        ApprovalEntry.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                        ApprovalEntry.SETRANGE("Related to Change", false);
                        if ApprovalEntry.FINDFIRST then
                            ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef, ApprovalEntry."Workflow Step Instance ID");
                    end;
                }
            }
            group("Report")
            {
                Caption = 'Report';
                Image = SendApprovalRequest;
                action("Document ")
                {
                    Caption = 'Print Document';
                    Enabled = PrintDocBoolG;
                    Image = PrintAttachment;
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        LeaveAnalysis: Report "Leave Analysis";
                        DocumentsReqRec: Record "Document Request";
                    begin
                        CurrPage.SetSelectionFilter(DocumentsReqRec);
                        if DocumentsReqRec.FindFirst() then;

                        if NOT GetActiveHRManagerDetails then
                            Error('Only HR will print this report.');

                        Rec.TESTFIELD("Employee ID");
                        Rec.TESTFIELD(Addressee);
                        Rec.TESTFIELD("Request Date");
                        Rec.TESTFIELD("WorkFlow Status", Rec."WorkFlow Status"::Released);

                        IF Rec."Document format ID" = Rec."Document format ID"::" " THEN
                            ERROR('Select the Document format ID');

                        if Rec."Document format ID" = Rec."Document format ID"::"Salary Certificate" then
                            Report.RunModal(Report::"Salary Certificate", false, false, DocumentsReqRec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        SetControlVisibility();
    end;

    trigger OnAfterGetRecord();
    begin
        SetControlVisibility();
    end;

    trigger OnOpenPage();
    begin
        SetControlVisibility();
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Email_Confirmation: Codeunit "Send Email To HR & Employee";
        Rec2: Record "Document Request";
        Trans_SalaryRep: Report "Transfer of Salary";
        EmployeeDependentsMaster: Record "Employee Dependents Master";
        IdentificationMasterRec: Record "Identification Master";
        EmpRec: Record Employee;
        ReopenBoolG: boolean;
        PrintDocBoolG: Boolean;

    procedure GetActiveHRManagerDetails(): Boolean
    var
        UserSetupRecG: Record "User Setup";
        EmployeeRecL: Record Employee;
    begin
        UserSetupRecG.Reset();
        UserSetupRecG.SetRange("HR Manager", true);
        UserSetupRecG.SetRange("User ID", UserId);
        if UserSetupRecG.FindFirst() then
            exit(true);
    end;

    local procedure SetControlVisibility();
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

        Clear(ReopenBoolG);
        if Rec."WorkFlow Status" <> Rec."WorkFlow Status"::Open then
            ReopenBoolG := true
        else
            ReopenBoolG := false;

        Clear(PrintDocBoolG);
        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            PrintDocBoolG := true
        else
            PrintDocBoolG := false;
    end;
}