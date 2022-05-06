page 60161 "Loan Request"
{
    Caption = 'Loan Request';
    PageType = Card;
    SourceTable = "Loan Request";
    SourceTableView = SORTING("Entry No.", "Loan Request ID") ORDER(Ascending);
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Request ID"; Rec."Loan Request ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee ID")
                {
                    Enabled = VarEditable;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("WorkFlow Status"; Rec."WorkFlow Status")
                {
                    Caption = 'Workflow Status';
                    ApplicationArea = All;
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    Editable = VarEditable;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    Editable = VarEditable;
                    ApplicationArea = All;
                }
                field("Request Amount"; Rec."Request Amount")
                {
                    Editable = VarEditable;
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Number of Installments"; Rec."Number of Installments")
                {
                    Editable = VarEditable;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Created Time"; Rec."Created Time")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Total Installment Amount"; Rec."Total Installment Amount")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    Editable = WFRelBoolG;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        LoanType;
                    end;
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    Editable = LoanTypeBoolG;
                    Visible = true;
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Journal Created"; Rec."Journal Created")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            part("Installment Generation"; "Loan Generation")
            {
                Caption = 'Installment Generation';
                Editable = false;
                SubPageLink = "Loan Request ID" = FIELD("Loan Request ID");
                SubPageView = SORTING("Entry No.") ORDER(Ascending);
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action("Create Journal")
                {
                    Caption = 'Create Journal';
                    Enabled = JournalButton;
                    Image = PostApplication;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        if (Rec."Posting Type" = Rec."Posting Type"::Finance) and (Rec."Journal Created" = false) then
                            CreateJournal;
                        if (Rec."Posting Type" = Rec."Posting Type"::Payroll) and (Rec."Journal Created" = false) then
                            PayrollAdjmtJournal;
                    end;
                }
                action("Send for Approval")
                {
                    Caption = 'Send for Approval';
                    Enabled = SendForBoolG;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntry: Record "Approval Entry";
                        wfcode: Codeunit InitCodeunit_Loan_Request;
                    begin
                        Rec.TESTFIELD("Employee ID");
                        Rec.TESTFIELD("Loan Type");
                        Rec.TESTFIELD("Request Amount");
                        Rec.TESTFIELD("Number of Installments");
                        Rec.TESTFIELD("Repayment Start Date");
                        wfcode.Is_Loan_Request_Enabled(rec);
                        wfcode.OnSendLoan_Request_Approval(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Enabled = CanAppReqBoolG;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        WfCode: Codeunit InitCodeunit_Loan_Request;
                    begin
                        Rec.TestField("WorkFlow Status", Rec."WorkFlow Status"::"Pending For Approval");
                        WfCode.OnCancelLoan_Request_Approval(rec);
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
                        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Loan Request");
                        ApprovalEntry.SETRANGE("Record ID to Approve", Rec.RecordId);
                        ApprovalEntry.SETRANGE("Related to Change", FALSE);
                        PAGE.RUN(70010, ApprovalEntry);
                    end;
                }
                action(Reopen)
                {
                    Enabled = ReopenBoolG;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        LoanInstallmentGenerationRecG.RESET;
                        LoanInstallmentGenerationRecG.SETRANGE("Loan Request ID", Rec."Loan Request ID");
                        LoanInstallmentGenerationRecG.SETRANGE("Employee ID", Rec."Employee ID");
                        LoanInstallmentGenerationRecG.SETRANGE(Loan, Rec."Loan Type");
                        if LoanInstallmentGenerationRecG.FINDSET then begin
                            CounterLineG := LoanInstallmentGenerationRecG.COUNT;
                            if CounterLineG > 0 then
                                ERROR('Installment Lines generated,cannot Re-open the Request.');
                        end;
                        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::"Pending For Approval" then
                            ERROR(Text001);

                        Rec.Reopen(Rec);
                    end;
                }
                action("Attachment")
                {
                    ApplicationArea = All;
                    Image = Attachments;
                    Promoted = true;
                    Caption = 'Attachment';
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                    trigger
                    OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GETTABLE(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RUNMODAL;
                    end;
                }
                action("Journal Lines")
                {
                    Image = Journals;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        if LoanTypeSetup.GET(Rec."Loan Type") then;
                        LoanTypeSetup.TESTFIELD("Loan Type Journal Batch");
                        LoanTypeSetup.TESTFIELD("Loan Type Template");
                        GenJournalLine.SETRANGE("Journal Batch Name", LoanTypeSetup."Loan Type Journal Batch");
                        GenJournalLine.SETRANGE("Journal Template Name", LoanTypeSetup."Loan Type Template");
                        GenJournalLine.SETRANGE("Document No.", Rec."Journal Document No.");
                        if GenJournalLine.FINDFIRST then
                            PAGE.RUN(PAGE::"General Journal", GenJournalLine)
                        else
                            ERROR(Text5004, Rec."Loan Request ID");
                    end;
                }
                action("Create Installment")
                {
                    Enabled = CreateInstallBoolG;
                    Image = CreateInteraction;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        newdate: Date;
                        PrincipalAmount: Decimal;
                        ReountOffValueG: Decimal;
                    begin
                        Rec.TESTFIELD("Request Amount");
                        Rec.TESTFIELD("Number of Installments");
                        Rec.TESTFIELD("Repayment Start Date");
                        if Rec."Installment Created" = true then
                            ERROR(Text50001);
                        PrincipalAmnt := 0;
                        InterestAmnt := 0;
                        PrincipalAmnt := ROUND(((Rec."Request Amount") / (Rec."Number of Installments")), 0.01);
                        InterestAmnt := ROUND(((Rec."Request Amount") * ((Rec."Interest Rate") / 100) / (Rec."Number of Installments")), 0.01);
                        EmployeeEarningCodeGroups.SETRANGE("Employee Code", Rec."Employee ID");
                        if EmployeeEarningCodeGroups.FINDFIRST then;

                        CLEAR(PrincipalAmount);
                        CLEAR(ReountOffValueG);
                        for i := 1 to Rec."Number of Installments" do begin
                            if LoanInstallmentGeneration.FINDLAST then;
                            LoanInstallmentGeneration."Entry No." := LoanInstallmentGeneration."Entry No." + 1;
                            LoanInstallmentGeneration."Loan Request ID" := Rec."Loan Request ID";
                            LoanInstallmentGeneration.Loan := Rec."Loan Type";
                            LoanInstallmentGeneration."Loan Description" := Rec."Loan Description";
                            LoanInstallmentGeneration."Employee ID" := Rec."Employee ID";
                            LoanInstallmentGeneration."Employee Name" := Rec."Employee Name";
                            LoanInstallmentGeneration.Currency := EmployeeEarningCodeGroups.Currency;
                            if i > 1 then
                                LoanInstallmentGeneration."Installament Date" := CALCDATE('1M', VarDate)
                            else
                                LoanInstallmentGeneration."Installament Date" := Rec."Repayment Start Date";
                            VarDate := LoanInstallmentGeneration."Installament Date";
                            LoanInstallmentGeneration."Interest Installment Amount" := InterestAmnt;
                            if i = Rec."Number of Installments" then begin
                                ReountOffValueG := ROUND(Rec."Request Amount" - (ROUND(PrincipalAmnt, 0.01) * Rec."Number of Installments"), 0.01);
                                LoanInstallmentGeneration."Principal Installment Amount" := (ROUND(PrincipalAmnt, 0.01) + ReountOffValueG);
                            end else
                                LoanInstallmentGeneration."Principal Installment Amount" := ROUND(PrincipalAmnt, 0.01);
                            LoanInstallmentGeneration.Status := LoanInstallmentGeneration.Status::Unrecovered;
                            LoanInstallmentGeneration.INSERT;
                            Rec."Total Installment Amount" := Rec."Total Installment Amount" + LoanInstallmentGeneration."Interest Installment Amount";
                            Rec."Installment Created" := true;
                            VarEditable := false;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EditableFun;
        if (Rec."Installment Created" = true) and (Rec."Journal Created" = false) then
            JournalButton := true;
        SetControlVisibility;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        EditableFun;
        if Rec."Journal Created" then
            Error('Journal Created, you cannot modify.');
    end;

    trigger OnOpenPage()
    begin
        VarEditable := true;
        if (Rec."Installment Created" = true) and (Rec."Journal Created" = false) then
            JournalButton := true;
        SetControlVisibility;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        LoanRequest: Record "Loan Request";
    begin
        LoanRequest.RESET;
        CurrPage.SETSELECTIONFILTER(LoanRequest);
        if LoanRequest.FINDFIRST then begin
            if (LoanRequest."Loan Request ID" <> '') then begin
                Rec.TESTFIELD("Employee ID");
                Rec.TESTFIELD("Loan Type");
                Rec.TESTFIELD("Number of Installments");
            end;
        end;
    end;

    var
        LoanInstallmentGeneration: Record "Loan Installment Generation";
        i: Integer;
        Installmentamount: Decimal;
        Text50001: Label 'Installment Lines Already Created !!';
        PrincipalAmnt: Decimal;
        InterestAmnt: Decimal;
        PeriodLength: DateFormula;
        [InDataSet]
        VarEditable: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        LeaveRequestHeader: Record "Leave Request Header";
        Text001: Label 'Loan Request workflow status must be cancelled or completed to open the document !';
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
        Text5002: Label 'Workflow Status should be Approved to create Installments !';
        UserSetup: Record "User Setup";
        LoanRequest: Record "Loan Request";
        VarDate: Date;
        GenJournalLine: Record "Gen. Journal Line";
        LoanTypeSetup: Record "Loan Type Setup";
        GenJournalBatch: Record "Gen. Journal Batch";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text50003: Label 'Journal Created Successfully with Document No.%1 !';
        EditJournal: Boolean;
        GeneralJournal: Page "General Journal";
        Text5004: Label 'Journal Lines does not exist again Loan Request %1';
        JournalButton: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        LoanInstallmentGenerationRecG: Record "Loan Installment Generation";
        CounterLineG: Integer;
        JournalCreatedBool: Boolean;
        SendForBoolG: Boolean;
        ReopenBoolG: Boolean;
        CreateInstallBoolG: Boolean;
        CanAppReqBoolG: Boolean;
        WFRelBoolG: Boolean;
        LoanTypeBoolG: Boolean;

    local procedure EditableFun()
    begin
        if Rec."Installment Created" = true then
            VarEditable := false;
        if Rec."WorkFlow Status" <> Rec."WorkFlow Status"::Open then
            VarEditable := false
        else
            VarEditable := true;
    end;

    local procedure CreateJournal()
    var
        GenJournalLineRecL: Record "Gen. Journal Line";
        GenJournalLineRecL2: Record "Gen. Journal Line";
        GenJournalLineRecL3: Record "Gen. Journal Line";
        EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
        NewLineNoL: Integer;
        NewDocumentNoL: Code[20];
        UpdateDimensions: Codeunit "Update Dimensions";
        AdvancePayrollSetupRecL: Record "Advance Payroll Setup";
        GenJournalTemplate: Record "Gen. Journal Template";
        EmployeeRecL: Record Employee;
        Months: Code[90];
        Years: Integer;
        HCMLoanTableGCCWrkrRecL: Record "HCM Loan Table GCC Wrkr";
    begin
        LoanTypeSetup.SETRANGE("Loan Code", Rec."Loan Type");
        IF LoanTypeSetup.FINDFIRST THEN;

        AdvancePayrollSetupRecL.RESET;
        AdvancePayrollSetupRecL.GET;
        GenJournalBatch.GET(LoanTypeSetup."Loan Type Template", LoanTypeSetup."Loan Type Journal Batch");
        GenJournalBatch.TESTFIELD("No. Series");
        NewDocumentNoL := NoSeriesManagement.GetNextNo(GenJournalBatch."No. Series", TODAY, TRUE);

        GenJournalLineRecL2.RESET;
        GenJournalLineRecL2.SETRANGE("Journal Batch Name", LoanTypeSetup."Loan Type Journal Batch");
        GenJournalLineRecL2.SETRANGE("Journal Template Name", LoanTypeSetup."Loan Type Template");
        GenJournalLineRecL2.SETRANGE("Document No.", NewDocumentNoL);
        IF GenJournalLineRecL2.FINDLAST THEN;

        GenJournalLineRecL.INIT;
        GenJournalLineRecL."Journal Batch Name" := LoanTypeSetup."Loan Type Journal Batch";
        GenJournalLineRecL."Journal Template Name" := LoanTypeSetup."Loan Type Template";
        GenJournalLineRecL.VALIDATE("Posting No. Series", GenJournalBatch."Posting No. Series");
        GenJournalLineRecL3.RESET;
        GenJournalLineRecL3.SETRANGE("Journal Batch Name", LoanTypeSetup."Loan Type Journal Batch");
        GenJournalLineRecL3.SETRANGE("Journal Template Name", LoanTypeSetup."Loan Type Template");
        IF GenJournalLineRecL3.FINDLAST THEN
            GenJournalLineRecL."Line No." := GenJournalLineRecL3."Line No." + 10000
        ELSE
            GenJournalLineRecL."Line No." := 10000;

        GenJournalLineRecL.INSERT;
        IF GenJournalTemplate.GET(LoanTypeSetup."Loan Type Template") THEN
            GenJournalLineRecL.VALIDATE("Source Code", GenJournalTemplate."Source Code");

        GenJournalLineRecL.VALIDATE("Document No.", NewDocumentNoL);
        GenJournalLineRecL.VALIDATE("Document Date", Rec."Request Date");
        GenJournalLineRecL.VALIDATE("Posting Date", TODAY);
        GenJournalLineRecL.VALIDATE("Document Type", GenJournalLineRecL."Document Type"::Payment);
        GenJournalLineRecL.VALIDATE("Account Type", GenJournalLineRecL."Account Type"::"G/L Account");
        GenJournalLineRecL.VALIDATE("Account No.", LoanTypeSetup."Main Account No.");
        IF LoanTypeSetup."Vendor Posting" THEN BEGIN
            EmployeeRecL.GET(Rec."Employee ID");
            EmployeeRecL.TestField("Vendor Account");
            GenJournalLineRecL.VALIDATE("Bal. Account Type", GenJournalLineRecL."Account Type"::Vendor);
            GenJournalLineRecL.VALIDATE("Bal. Account No.", EmployeeRecL."Vendor Account");
        END
        ELSE BEGIN
            GenJournalLineRecL.VALIDATE("Bal. Account Type", GenJournalLineRecL."Account Type"::"G/L Account");
            GenJournalLineRecL.VALIDATE("Bal. Account No.", LoanTypeSetup."Offset Account No.");
        END;
        GenJournalLineRecL.VALIDATE(Amount, Rec."Request Amount");
        Months := FORMAT(Rec."Repayment Start Date", 0, '<Month Text>');
        Years := DATE2DMY(Rec."Repayment Start Date", 3);
        HCMLoanTableGCCWrkrRecL.RESET;
        HCMLoanTableGCCWrkrRecL.SETRANGE(Worker, Rec."Employee ID");
        HCMLoanTableGCCWrkrRecL.SETRANGE("Loan Code", Rec."Loan Type");
        IF HCMLoanTableGCCWrkrRecL.FINDFIRST THEN BEGIN
            GenJournalLineRecL.Description := HCMLoanTableGCCWrkrRecL."Loan Description" + ' for the Month of ( ' + Months + '. ' + FORMAT(Years) + ')';
        END;
        EmployeeRecL.RESET;
        EmployeeRecL.GET(Rec."Employee ID");
        GenJournalLineRecL.Comment := EmployeeRecL.FullName;
        EmployeeRecL.GET(Rec."Employee ID");
        IF EmployeeRecL."Global Dimension 2 Code" <> '' THEN BEGIN
            GenJournalLineRecL.ValidateShortcutDimCode(2, EmployeeRecL."Global Dimension 2 Code");
            GenJournalLineRecL.VALIDATE("Shortcut Dimension 2 Code", EmployeeRecL."Global Dimension 2 Code");
        END;
        IF GenJournalLineRecL.MODIFY THEN BEGIN
            UpdateDimensions.ValidateShortCutDimension(GenJournalLineRecL, Rec."Employee ID");
            EditJournal := FALSE;
            Rec."Journal Created" := TRUE;
            JournalButton := FALSE;
            MESSAGE(Text50003, NewDocumentNoL);
            Rec.VALIDATE("Journal Document No.", NewDocumentNoL);
            Rec.MODIFY;
        END;
    end;

    local procedure PayrollAdjmtJournal()
    var
        PayrollAdjmtJournalheaderRecL: Record "Payroll Adjmt. Journal header";
        PayPeriod: Record "Pay Periods";
        AdvPayrollSetup: Record "Advance Payroll Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentNo: Code[20];
    begin
        AdvPayrollSetup.GET;
        PayPeriod.SETRANGE("Pay Cycle", Rec."Pay Cycle");
        PayPeriod.SetRange(Year, Rec."Pay Year");
        PayPeriod.SetRange(Month, Rec."Pay Month");
        if PayPeriod.FINDFIRST then begin
            PayrollAdjmtJournalheaderRecL.INIT;
            AdvPayrollSetup.TestField("Payroll Adj Journal No. Series");
            DocumentNo := NoSeriesManagement.GetNextNo(AdvPayrollSetup."Payroll Adj Journal No. Series", TODAY, true);
            PayrollAdjmtJournalheaderRecL.VALIDATE("Journal No.", DocumentNo);
            PayrollAdjmtJournalheaderRecL.Description := 'Loan Request Payroll Adjustment';
            PayrollAdjmtJournalheaderRecL.VALIDATE("Pay Cycle", Rec."Pay Cycle");
            PayrollAdjmtJournalheaderRecL.VALIDATE("Pay Period Start", PayPeriod."Period Start Date");
            PayrollAdjmtJournalheaderRecL.VALIDATE("Pay Period End", PayPeriod."Period End Date");
            PayrollAdjmtJournalheaderRecL."Create By" := USERID;
            PayrollAdjmtJournalheaderRecL.VALIDATE("Created DateTime", CURRENTDATETIME);
            PayrollAdjmtJournalheaderRecL."Posted By" := USERID;
            PayrollAdjmtJournalheaderRecL.VALIDATE("Posted DateTime", CURRENTDATETIME);
            if PayrollAdjmtJournalheaderRecL.INSERT then begin
                PayrollAdjmtJournalLine(DocumentNo);
                Rec."Journal Created" := true;
                JournalButton := false;
                MESSAGE('Payroll Adjustment Created Successfully  %1', DocumentNo);
            end;
        end;
    end;

    local procedure PayrollAdjmtJournalLine("DocumentNo.": Code[20])
    var
        PayrollAdjmtJournalLines1: Record "Payroll Adjmt. Journal Lines";
        PayrollAdjmtJournalLines: Record "Payroll Adjmt. Journal Lines";
        NewLineNo: Integer;
    begin
        LoanTypeSetup.SETRANGE("Loan Code", Rec."Loan Type");
        if LoanTypeSetup.FINDFIRST then;

        PayrollAdjmtJournalLines.RESET;
        PayrollAdjmtJournalLines.SETRANGE("Journal No.", "DocumentNo.");
        if PayrollAdjmtJournalLines.FINDLAST then
            NewLineNo := PayrollAdjmtJournalLines."Line No." + 10000
        else
            NewLineNo := 10000;

        PayrollAdjmtJournalLines1.INIT;
        PayrollAdjmtJournalLines1.VALIDATE("Journal No.", "DocumentNo.");
        PayrollAdjmtJournalLines1.VALIDATE("Line No.", NewLineNo);
        PayrollAdjmtJournalLines1.VALIDATE("Employee Code", Rec."Employee ID");
        PayrollAdjmtJournalLines1.VALIDATE("Employee Name", Rec."Employee Name");
        PayrollAdjmtJournalLines1.VALIDATE("Earning Code", LoanTypeSetup."Payout Earning Code");
        PayrollAdjmtJournalLines1.VALIDATE(Amount, Rec."Request Amount");
        PayrollAdjmtJournalLines1.INSERT;
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        Clear(SendForBoolG);
        if (NOT OpenApprovalEntriesExist) AND (Rec."Workflow Status" = Rec."Workflow Status"::Open) then
            SendForBoolG := true
        else
            SendForBoolG := false;

        Clear(ReopenBoolG);
        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            ReopenBoolG := true
        else
            ReopenBoolG := false;

        Clear(CreateInstallBoolG);
        if (Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released) then
            CreateInstallBoolG := true
        else
            CreateInstallBoolG := false;

        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::"Pending For Approval" then
            CanAppReqBoolG := true
        else
            CanAppReqBoolG := false;

        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::Released then
            WFRelBoolG := true
        else
            WFRelBoolG := false;

        LoanType;
    end;

    procedure LoanType()
    begin
        if Rec."Posting Type" = Rec."Posting Type"::Payroll then
            LoanTypeBoolG := true
        else
            LoanTypeBoolG := false;
    end;
}