page 60084 "Payroll Statements"
{
    DelayedInsert = false;
    PageType = Worksheet;
    SourceTable = "Payroll Statement";
    ApplicationArea = All;
    UsageCategory = Lists;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','',Report,'',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    layout
    {
        area(content)
        {
            field("Exclude Cancelled"; ExcludeCancelled)
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if ExcludeCancelled then
                        Rec.SETFILTER(Status, '<>%1', Rec.Status::Cancelled)
                    else
                        Rec.SETRANGE(Status);
                    CurrPage.UPDATE;
                end;
            }
            repeater(Group)
            {
                field("Payroll Statement ID"; Rec."Payroll Statement ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Payroll Statement Description"; Rec."Payroll Statement Description")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Editable = CheckBoolG;
                }
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Editable = CheckBoolG;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Editable = CheckBoolG;
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Is Opening"; Rec."Is Opening")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Created Date and Time"; Rec."Created Date and Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Statement Type"; Rec."Statement Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Confirmed; Rec.Confirmed)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Enable Payroll Statements"; Rec."Enable Payroll Statements")
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
            action("Generate Payroll Statement2")
            {
                Enabled = CheckBoolG;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PayrollStatement);
                    if PayrollStatement.FINDFIRST then begin
                    end;
                end;
            }
            action("Generate Payroll Statement DLL API Report")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedOnly = true;
                Enabled = CheckBoolG;
                Caption = 'Generate Payroll Statement DLL API';
                Visible = FALSE;
                trigger OnAction()
                var
                    GeneratePayrollStatementL: Report "Generate Payroll Statement DLL";
                begin
                    CurrPage.SETSELECTIONFILTER(PayrollStatement);
                    if PayrollStatement.FINDFIRST then begin
                        CLEAR(GeneratePayrollStatementL);
                        GeneratePayrollStatementL.SetValues(PayrollStatement);
                        GeneratePayrollStatementL.RUNMODAL;
                    end;
                end;
            }
            action("Generate Payroll Statement")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedOnly = true;
                Enabled = CheckBoolG;
                Caption = 'Generate Payroll Statement';
                trigger OnAction()
                var
                    GeneratePayrollStatementL: Report "Generate Payroll Statement";
                begin
                    CurrPage.SETSELECTIONFILTER(PayrollStatement);
                    if PayrollStatement.FINDFIRST then begin
                        CLEAR(GeneratePayrollStatementL);
                        GeneratePayrollStatementL.SetValues(PayrollStatement);
                        GeneratePayrollStatementL.RUNMODAL;
                    end;
                end;
            }
            action("Payroll Statement Employees")
            {
                Caption = 'Payroll Statement Employees';
                Enabled = EditPayrollStatementEmployee;
                Image = PaymentJournal;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Page "Payroll Statement Employees";
                RunPageLink = "Payroll Statement ID" = FIELD("Payroll Statement ID");
            }
            action("Payroll Error Log")
            {
                Image = ErrorLog;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Page "Payroll Error Log";
                RunPageLink = "Payroll Statement ID" = FIELD("Payroll Statement ID");
                RunPageView = SORTING("Entry No.");
                ApplicationArea = All;
            }
            group("Request Approval")
            {
                action("Submit For Approval")
                {
                    Caption = 'Submit For Approval';
                    Enabled = CheckBoolG;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        wfcode: Codeunit InitCodeunit_Payroll;
                    begin
                        if not CONFIRM('Do you want to Submit the Payroll Statement?') then
                            exit;

                        CurrPage.SETSELECTIONFILTER(PayrollStatement);
                        if PayrollStatement.FINDFIRST then begin
                            wfcode.CheckWorkflowEnabled(Rec);
                            wfcode.OnSendPayrollStat_Approval(Rec);
                        end;
                        CurrPage.UPDATE;
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Enabled = WFPendingBoolG;
                    Image = CancelApprovalRequest;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        wfcode: Codeunit InitCodeunit_Payroll;
                    begin
                        CurrPage.SETSELECTIONFILTER(PayrollStatement);
                        if PayrollStatement.FINDFIRST then begin
                            PayrollStatement.TESTFIELD("Workflow Status", PayrollStatement."Workflow Status"::"Pending Approval");
                            wfcode.OnCancelPayrollStat_Approval(Rec);
                        end;
                        CurrPage.UPDATE;
                    end;
                }
            }

            group("Appr&oval")
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
                        ApprovalEntry.RESET;
                        ApprovalEntry.SETRANGE("Table ID", Rec.RecID.TABLENO);
                        ApprovalEntry.SetRange("Record ID to Approve", Rec.RecID);
                        if ApprovalEntry.FindSet() then begin
                            PAGE.RUNMODAL(658, ApprovalEntry);
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
            action(Reopen)
            {
                Enabled = WFReopenBoolG;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Confirmed then
                        exit;
                    CurrPage.SETSELECTIONFILTER(PayrollStatement);
                    if PayrollStatement.FINDFIRST then begin
                        if PayrollStatement."Workflow Status" = PayrollStatement."Workflow Status"::"Pending Approval" then
                            ERROR(Text001);
                    end;
                    Rec.Reopen(PayrollStatement);
                    CurrPage.UPDATE;
                end;
            }
            action("Confirm Payroll Statement")
            {
                Enabled = WFApprovedBoolG;
                Image = Confirm;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PayPeriod: Record "Pay Periods";
                begin
                    if Rec.Confirmed then
                        Error('Already Confirmed.');
                    CLEAR(PayrollStatement);
                    CurrPage.SETSELECTIONFILTER(PayrollStatement);
                    if PayrollStatement.FINDFIRST then begin
                        PayrollStatement.TESTFIELD("Workflow Status", PayrollStatement."Workflow Status"::Approved);
                        //
                        PayrollStatement2.RESET;
                        PayrollStatement2.SETRANGE("Pay Period Start Date", CALCDATE('-CM', PayrollStatement."Pay Period Start Date" - 1));
                        if PayrollStatement2.FINDFIRST then
                            if not (PayrollStatement2.Status = PayrollStatement2.Status::Confirmed) then
                                ERROR('Previous Payroll Statement is not confirmed. Please confirm it to continue');
                        if not CONFIRM('Do you want to confirm the Payroll Statement ?', true) then
                            exit;
                        Rec.ConfirmPayroll(PayrollStatement);
                    end;
                    CurrPage.UPDATE;
                end;
            }
            action(Post)
            {
                Enabled = CheckBool3G;
                Image = Post;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PayPeriod: Record "Pay Periods";
                begin
                    if not CONFIRM('This action will post payroll and create journal lines, Do you want to continue?', true) then
                        exit;
                    CurrPage.SETSELECTIONFILTER(PayrollStatement);
                    if PayrollStatement.FINDFIRST then begin
                        PayrollStatement.TESTFIELD("Workflow Status", PayrollStatement."Workflow Status"::Approved);
                        CLEAR(PayrollStatementJV);
                        PayrollStatementJV.SetValue(PayrollStatement."Payroll Statement ID");
                        PayrollStatementJV.RUN;
                    end;
                    Rec.Posted := true;
                    CurrPage.UPDATE;
                end;
            }
            action("Notify Employees")
            {
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedOnly = true;
                Visible = false;
            }

            action("Enable Payslip")
            {
                Image = ExecuteAndPostBatch;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedOnly = true;
                Visible = true;
                Enabled = CheckBool3G;
                trigger OnAction()
                var
                    PayPeriod: Record "Pay Periods";
                begin
                    PayPeriod.RESET;
                    PayPeriod.SETRANGE("Pay Cycle", Rec."Pay Cycle");
                    PayPeriod.SetRange("Period Start Date", Rec."Pay Period Start Date");
                    if PayPeriod.FindFirst() then begin
                        PayPeriod."Enable Payroll Statements" := true;
                        PayPeriod.Modify();
                        Rec."Enable Payroll Statements" := true;
                        Rec.Modify();
                        Message('Pay slip has been Enable for Employees.');
                    end;
                end;
            }
            action("Report")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PayrollStatementRecL: Record "Payroll Statement";
                begin
                    CurrPage.SETSELECTIONFILTER(PayrollStatementRecL);
                    if PayrollStatementRecL.FINDFIRST then begin
                        CLEAR(PayrollStatementRep);
                        PayrollStatementRep.SetData(PayrollStatementRecL."Pay Cycle",
                        PayrollStatementRecL."Pay Period",
                       PayrollStatementRecL."Payroll Statement ID",
                       PayrollStatementRecL."Pay Period Start Date",
                       PayrollStatementRecL."Pay Period End Date");
                        PayrollStatementRep.RUNMODAL;
                    end;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SetControlVisibility;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControlVisibility;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
        if Rec.Status = Rec.Status::Processing then begin
            EditPayrollStatementEmployee := false;
        end
        else begin
            EditPayrollStatementEmployee := true;
        end;
        EditPost;
        PayrollStatementEmployee.RESET;
        PayrollStatementEmployee.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
        if PayrollStatementEmployee.FINDFIRST then
            PayrollstatementEmployeeEntriesExist := false
        else
            PayrollstatementEmployeeEntriesExist := true;
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility;
        ExcludeCancelled := true;
        Rec.SETFILTER(Status, '<>%1', Rec.Status::Cancelled);
        EditPost;

        PayrollStatementEmployee.RESET;
        PayrollStatementEmployee.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
        if PayrollStatementEmployee.FINDFIRST then
            PayrollstatementEmployeeEntriesExist := false
        else
            PayrollstatementEmployeeEntriesExist := true;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        PayrollStatementRecL: Record "Payroll Statement";
    begin
        PayrollStatementRecL.RESET;
        CurrPage.SETSELECTIONFILTER(PayrollStatementRecL);
        if PayrollStatementRecL.FINDFIRST then begin
            if PayrollStatementRecL."Payroll Statement ID" <> '' then begin
                PayrollStatementRecL.TESTFIELD("Payroll Statement Description");
                PayrollStatementRecL.TESTFIELD("Pay Period");
                PayrollStatementRecL.TESTFIELD("Pay Cycle");
            end;
        end;
    end;

    var
        ExcludeCancelled: Boolean;
        EditPayrollStatementEmployee: Boolean;
        PayrollStatement: Record "Payroll Statement";
        Statement_No: Code[10];
        PayrollStatementJV: Codeunit "Payroll Statement JV";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Text001: Label 'The approval process must be cancelled or completed to reopen this document.';
        EiditPostBool: Boolean;
        [InDataSet]
        GenPayStatBool: Boolean;
        [InDataSet]
        PayrollstatementEmployeeEntriesExist: Boolean;
        PayrollStatementEmployee: Record "Payroll Statement Employee";
        PayrollStatement2: Record "Payroll Statement";
        PayrollStatementRep: Report "Payroll Statement Report New";
        CheckBoolG: Boolean;
        WFApprovedBoolG: Boolean;
        CheckBool3G: Boolean;
        WFReopenBoolG: Boolean;
        WFPendingBoolG: Boolean;

    local procedure EditPost()
    begin
        EiditPostBool := false;

        if Rec."Workflow Status" = Rec."Workflow Status"::Open then
            GenPayStatBool := true
        else
            GenPayStatBool := false;
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

        Clear(CheckBoolG);
        if Rec."Workflow Status" = Rec."Workflow Status"::Open then
            CheckBoolG := true
        else
            CheckBoolG := false;

        Clear(WFPendingBoolG);
        if Rec."Workflow Status" = Rec."Workflow Status"::"Pending Approval" then
            WFPendingBoolG := true
        else
            WFPendingBoolG := false;

        Clear(WFApprovedBoolG);
        if Rec."Workflow Status" = Rec."Workflow Status"::Approved then
            WFApprovedBoolG := true
        else
            WFApprovedBoolG := false;

        Clear(CheckBool3G);
        if Rec.Status = Rec.Status::Confirmed then
            CheckBool3G := true
        else
            CheckBool3G := false;

        Clear(WFReopenBoolG);
        if (Rec."Workflow Status" = Rec."Workflow Status"::Approved) AND (NOT Rec.Confirmed) then
            WFReopenBoolG := true
        else
            WFReopenBoolG := false;
    end;
}