page 60076 "Educational Claim Card"
{
    PageType = Card;
    SourceTable = "Educational Claim Header LT";
    SourceTableView = SORTING("Claim ID", "Employee No.") ORDER(Ascending);
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Claim ID"; Rec."Claim ID")
                {
                    Editable = false;
                    NotBlank = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = HrBool;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        AvoideMutliformOpen_LT;
                    end;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Grade Category"; Rec."Grade Category")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                }
                field("Claim Date"; Rec."Claim Date")
                {
                    ApplicationArea = All;
                    Editable = EnableControlG;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        IF Rec."Approval Status" = Rec."Approval Status"::Released THEN
                            JournalEnableBoolG := TRUE
                        ELSE
                            JournalEnableBoolG := FALSE;
                        EnableControl_LT();
                        CurrPage.UPDATE;
                    end;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = All;
                    OptionCaption = ' ,Payroll,Finance';
                    Visible = false;
                    trigger OnValidate()
                    begin
                        payEditable;
                    end;
                }
                field("Pay Month"; Rec."Pay Month")
                {
                    ApplicationArea = All;
                    Enabled = PayBoolG;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        IF Rec."Approval Status" <> Rec."Approval Status"::Released THEN
                            ERROR('Approval Status should be open');
                    end;
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = All;
                    Enabled = PayBoolG;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        IF Rec."Approval Status" <> Rec."Approval Status"::Released THEN
                            ERROR('Approval Status should be open');
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = EnableControlG;
                    Enabled = EnableControlG;
                }
                field("Academic year"; Rec."Academic year")
                {
                    ApplicationArea = All;
                    Caption = 'Academic Year';
                    Editable = EnableControlG;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        AvoideMutliformOpen_LT
                    end;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
            }
            part("Educational Claim Subform"; "Educational Claim Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Claim ID" = field("Claim ID"), "Employee No." = field("Employee No."), "Academic year" = field("Academic year");
            }
        }
    }

    actions
    {
        area(creation)
        {
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
                        EduClamLineRecL: Record "Educational Claim Lines LT";
                        RecordLink: Record "Record Link";
                    begin
                        Rec.TESTFIELD(Posted, FALSE);
                        Rec.TESTFIELD("Employee No.");
                        Rec.TESTFIELD("Claim Date");
                        Rec.TESTFIELD("Posting Type");
                        Rec.TESTFIELD("Academic year");
                        IF Rec."Posting Type" = Rec."Posting Type"::Payroll THEN BEGIN
                            Rec.TESTFIELD("Pay Month");
                            Rec.TESTFIELD("Pay Period");
                        END;
                        EduClamLineRecL.RESET;
                        EduClamLineRecL.SETRANGE("Claim ID", Rec."Claim ID");
                        EduClamLineRecL.SETRANGE("Employee No.", Rec."Employee No.");
                        EduClamLineRecL.SETFILTER("Dependent ID", '<>%1', '');
                        IF EduClamLineRecL.FINDSET THEN BEGIN
                            REPEAT
                                EduClamLineRecL.TESTFIELD("Selected Claim Amount");
                                EduClamLineRecL.TESTFIELD("Selected Currency");
                                EduClamLineRecL.TESTFIELD("Current Claim Amount");
                                IF EduClamLineRecL."Current Claim Amount" <= 0 THEN
                                    ERROR('Current Claim Amount should not be Zero in Line No. %1 ', EduClamLineRecL."Line No.");
                                IF (EduClamLineRecL."Period End Date" = 0D) OR (EduClamLineRecL."Period Start Date" = 0D) THEN
                                    ERROR('Period Start Date and End Date should not be Blank.');

                            UNTIL EduClamLineRecL.NEXT = 0;
                        END ELSE
                            ERROR('Please add Line and proceed.');

                        EduClamLineRecL.RESET;
                        EduClamLineRecL.SETRANGE("Claim ID", Rec."Claim ID");
                        EduClamLineRecL.SETRANGE("Employee No.", Rec."Employee No.");
                        EduClamLineRecL.SETRANGE("Academic year", Rec."Academic year");
                        EduClamLineRecL.SETRANGE("Allowance Type", EduClamLineRecL."Allowance Type"::"Educational Book Allowance");
                        IF NOT EduClamLineRecL.FINDFIRST THEN
                            ERROR(EduAllErr);

                        RecordLink.RESET;
                        RecordLink.SETRANGE("Record ID", Rec.RECORDID);
                        IF NOT RecordLink.FINDFIRST THEN
                            ERROR('Attachment is mandatory');

                        payEditable;
                        EnableControl_LT();
                        SetControlAppearance;
                        CurrPage.UPDATE;

                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = WFPendingAppBoolG;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        EduClamLineRecL: Record "Educational Claim Lines LT";
                    begin

                        Rec.TESTFIELD(Posted, FALSE);
                        Rec.TESTFIELD("Employee No.");
                        Rec.TESTFIELD("Claim Date");
                        Rec.TESTFIELD("Posting Type");
                        Rec.TESTFIELD("Academic year");
                        IF Rec."Posting Type" = Rec."Posting Type"::Payroll THEN BEGIN
                            Rec.TESTFIELD("Pay Month");
                            Rec.TESTFIELD("Pay Period");
                        END;

                        EduClamLineRecL.RESET;
                        EduClamLineRecL.SETRANGE("Claim ID", Rec."Claim ID");
                        EduClamLineRecL.SETRANGE("Employee No.", Rec."Employee No.");
                        EduClamLineRecL.SETFILTER("Dependent ID", '<>%1', '');
                        IF NOT EduClamLineRecL.FINDSET THEN
                            ERROR('Please add Line and proceed.');
                        IF CONFIRM(Text0001, FALSE) THEN BEGIN
                            Rec.VALIDATE("Approval Status", Rec."Approval Status"::Open);
                        END;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';
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
                        ApprovalEntry.SETRANGE("Related to Change", FALSE);
                        IF ApprovalEntry.FINDFIRST THEN
                            ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef, ApprovalEntry."Workflow Step Instance ID");
                    end;
                }
            }
            group(ActionGroup24)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';
                    Visible = false;
                    ApplicationArea = All;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        Rec.TESTFIELD(Posted, FALSE);

                        IF Rec."Approval Status" = Rec."Approval Status"::Released THEN BEGIN
                            Rec."Approval Status" := Rec."Approval Status"::Open;
                            Rec.MODIFY();
                        END;
                    end;
                }
            }
            group("Journal Creation")
            {
                Caption = 'Journal Creation';
                Image = SendApprovalRequest;
                action(CreateJournal)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Journal';
                    Enabled = CreateJournalControlG;
                    Image = Journals;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ToolTip = 'Create Journal';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TESTFIELD(Posted, FALSE);
                        CreateJournal_LT();
                    end;
                }
                action("Payrol AdjustmentJournal")
                {
                    ApplicationArea = Suite;
                    Caption = 'Payroll Adjustment Journal';
                    Enabled = PayrollControlG;
                    Image = AdjustEntries;
                    Promoted = true;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ToolTip = 'Payrol AdjustmentJournal';
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TESTFIELD(Posted, FALSE);
                        PayrollAdjmtJournal_Header_LT();
                    end;
                }
                action("Check Condtion")
                {
                    Image = Process;
                    Promoted = true;
                    PromotedIsBig = true;
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        CreateJournal_PayrollAdj;
        payEditable;
        EnableControl_LT;
        CheckUser;
    end;

    trigger OnOpenPage()
    begin
        CheckUser;
        payEditable;

        EnableControl_LT();
        SetControlAppearance;
        CreateJournal_PayrollAdj;
    end;

    var
        [InDataSet]
        PayBoolG: Boolean;
        [InDataSet]
        JournalEnableBoolG: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        [InDataSet]
        EnableControlG: Boolean;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ApprovalEntries: Page "Approval Entries";
        EducationalClaimHeaderLT: Record "Educational Claim Header LT";
        ApprovalEntryRec: Record "Approval Entry";
        [InDataSet]
        PayrollControlG: Boolean;
        [InDataSet]
        CreateJournalControlG: Boolean;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GenJournalBatch: Record "Gen. Journal Batch";
        lineRec: Record "Educational Claim Lines LT";
        EduAllReminder: Label 'EduAllReminder';
        EduAllErr: Label 'Book Allowance is not selected \Please Select Book Allowance';
        EducationalClaimLinesLTRec_G: Record "Educational Claim Lines LT";
        EducationalClaimLinesLTRec_2_G: Record "Educational Claim Lines LT";
        EduAllowanceType_G: Integer;
        EducationalClaimLinesLTRec_3_G: Record "Educational Claim Lines LT";
        EduBookAllowanceType_G: Integer;
        OverallLoop: Integer;
        LastDependentID: Code[30];
        Text0001: Label 'Are you sure you want to cancel the approval request.';
        ApprovalEntryRec_G: Record "Approval Entry";
        EducationalClaimHeaderLTRec_G: Record "Educational Claim Header LT";
        [InDataSet]
        CancelContrlaVarG: Boolean;
        CheckOldDepID_G: Code[30];
        EducationalClaimLinesLTRec_4_G: Record "Educational Claim Lines LT";
        [InDataSet]
        HrBool: Boolean;
        WFOpenBoolG: Boolean;
        WFPendingAppBoolG: Boolean;


    local procedure CreateJournal_LT()
    var
        HumanResourcesSetupRecL: Record "Human Resources Setup";
        GenJournalLineRecL: Record "Gen. Journal Line";
        GenJournalLineRecL2: Record "Gen. Journal Line";
        EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
        NewLineNoL: Integer;
        NewDocumentNoL: Code[20];
        UpdateDimensions: Codeunit "Update Dimensions";
    begin
        HumanResourcesSetupRecL.RESET;
        HumanResourcesSetupRecL.GET;

        GenJournalBatch.GET(HumanResourcesSetupRecL."Edu. Claim Journal Template", HumanResourcesSetupRecL."Edu. Claim Journal Batch");
        GenJournalBatch.TESTFIELD("No. Series");

        NewDocumentNoL := GenerateLineDocNo_LT(HumanResourcesSetupRecL."Edu. Claim Journal Batch", TODAY, HumanResourcesSetupRecL."Edu. Claim Journal Template");
        NewDocumentNoL := NoSeriesManagement.GetNextNo(GenJournalBatch."No. Series", TODAY, TRUE);
        GenJournalLineRecL2.RESET;
        GenJournalLineRecL2.SETRANGE("Journal Batch Name", HumanResourcesSetupRecL."Edu. Claim Journal Batch");
        GenJournalLineRecL2.SETRANGE("Journal Template Name", HumanResourcesSetupRecL."Edu. Claim Journal Template");
        GenJournalLineRecL2.DELETEALL;

        EducationalClaimLinesRecL.RESET;
        EducationalClaimLinesRecL.SETRANGE("Claim ID", Rec."Claim ID");
        EducationalClaimLinesRecL.SETRANGE("Employee No.", Rec."Employee No.");
        IF EducationalClaimLinesRecL.FINDSET THEN BEGIN
            REPEAT
                GenJournalLineRecL2.RESET;
                GenJournalLineRecL2.SETRANGE("Journal Batch Name", HumanResourcesSetupRecL."Edu. Claim Journal Batch");
                GenJournalLineRecL2.SETRANGE("Journal Template Name", HumanResourcesSetupRecL."Edu. Claim Journal Template");
                GenJournalLineRecL2.SETRANGE("Document No.", NewDocumentNoL);
                IF GenJournalLineRecL2.FINDLAST THEN;
                GenJournalLineRecL.INIT;
                GenJournalLineRecL."Journal Batch Name" := HumanResourcesSetupRecL."Edu. Claim Journal Batch";//);
                GenJournalLineRecL."Journal Template Name" := HumanResourcesSetupRecL."Edu. Claim Journal Template";//);
                GenJournalLineRecL."Line No." := GenJournalLineRecL2."Line No." + 10000;
                GenJournalLineRecL.INSERT;
                GenJournalLineRecL.VALIDATE("Document No.", NewDocumentNoL);
                GenJournalLineRecL.VALIDATE("Document Date", EducationalClaimLinesRecL."Claim Date");
                GenJournalLineRecL.VALIDATE("Posting Date", TODAY);
                GenJournalLineRecL.VALIDATE("Document Type", GenJournalLineRecL."Document Type"::Payment);
                IF EducationalClaimLinesRecL."Allowance Type" = EducationalClaimLinesRecL."Allowance Type"::"Educational Allowance" THEN BEGIN
                    GenJournalLineRecL.VALIDATE("Account Type", GenJournalLineRecL."Account Type"::"G/L Account");
                    GenJournalLineRecL.VALIDATE("Account No.", HumanResourcesSetupRecL."Education Allowance Credit");
                    GenJournalLineRecL.VALIDATE("Bal. Account Type", GenJournalLineRecL."Account Type"::"G/L Account");
                    GenJournalLineRecL.VALIDATE("Bal. Account No.", HumanResourcesSetupRecL."Education Allowance Debit");
                    GenJournalLineRecL.VALIDATE(Amount, EducationalClaimLinesRecL."Current Claim Amount");
                END
                ELSE
                    IF EducationalClaimLinesRecL."Allowance Type" = EducationalClaimLinesRecL."Allowance Type"::"Educational Book Allowance" THEN BEGIN
                        GenJournalLineRecL.VALIDATE("Account Type", GenJournalLineRecL."Account Type"::"G/L Account");
                        GenJournalLineRecL.VALIDATE("Account No.", HumanResourcesSetupRecL."Edu. Book Allowance Credit");
                        GenJournalLineRecL.VALIDATE("Bal. Account Type", GenJournalLineRecL."Account Type"::"G/L Account");
                        GenJournalLineRecL.VALIDATE("Bal. Account No.", HumanResourcesSetupRecL."Edu. Book Allowance Debit");
                        GenJournalLineRecL.VALIDATE(Amount, EducationalClaimLinesRecL."Current Claim Amount");
                    END
                    ELSE
                        IF EducationalClaimLinesRecL."Allowance Type" = EducationalClaimLinesRecL."Allowance Type"::"Special Need Allowance" THEN BEGIN
                            GenJournalLineRecL.VALIDATE("Account Type", GenJournalLineRecL."Account Type"::"G/L Account");
                            GenJournalLineRecL.VALIDATE("Account No.", HumanResourcesSetupRecL."Special Need Allowance Credit");
                            GenJournalLineRecL.VALIDATE("Bal. Account Type", GenJournalLineRecL."Account Type"::"G/L Account");
                            GenJournalLineRecL.VALIDATE("Bal. Account No.", HumanResourcesSetupRecL."Special Need Allowance Debit");
                            GenJournalLineRecL.VALIDATE(Amount, EducationalClaimLinesRecL."Current Claim Amount");
                        END;
                UpdateDimensions.ValidateShortCutDimension(GenJournalLineRecL, EducationalClaimLinesRecL."Employee No.");
                GenJournalLineRecL.MODIFY;
            UNTIL EducationalClaimLinesRecL.NEXT = 0;
        END;
        MESSAGE('Journal Created Successfully. Document No.: %1', NewDocumentNoL);
        Rec.Posted := TRUE;
        Rec.MODIFY();
    end;

    local procedure GenerateLineDocNo_LT(BatchName: Code[10]; PostingDate: Date; TemplateName: Code[20]) DocumentNo: Code[20]
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        GenJournalBatch.GET(TemplateName, BatchName);
        IF GenJournalBatch."No. Series" <> '' THEN
            DocumentNo := NoSeriesManagement.GetNextNo(GenJournalBatch."No. Series", PostingDate, TRUE);
    end;

    local procedure PayrolAdjustmentJournal_LT()
    var
        PayrollAdjmtJournalheaderRecL: Record "Payroll Adjmt. Journal header";
        PayrollAdjmtJournalLinesRecL: Record "Payroll Adjmt. Journal Lines";
        HumanResourcesSetupRecL: Record "Human Resources Setup";
        EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
    begin
    end;

    local procedure PayrollAdjmtJournal_Header_LT()
    var
        PayrollAdjmtJournalheaderRecL: Record "Payroll Adjmt. Journal header";
        PayPeriodsRecL: Record "Pay Periods";
        AdvPayrollSetup: Record "Advance Payroll Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        JournalNoL: Code[20];
        EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
    begin
        AdvPayrollSetup.GET;
        PayPeriodsRecL.RESET;
        PayPeriodsRecL.SETRANGE("Pay Cycle", Rec."Pay Month");
        IF PayPeriodsRecL.FINDFIRST THEN BEGIN
            PayrollAdjmtJournalheaderRecL.INIT;
            JournalNoL := NoSeriesManagement.GetNextNo(AdvPayrollSetup."Payroll Adj Journal No. Series", TODAY, TRUE);
            PayrollAdjmtJournalheaderRecL.VALIDATE("Journal No.", JournalNoL);
            PayrollAdjmtJournalheaderRecL.Description := 'Education Allowance Payroll Adjustment';
            PayrollAdjmtJournalheaderRecL.VALIDATE("Pay Cycle", Rec."Pay Month");
            PayrollAdjmtJournalheaderRecL.VALIDATE("Pay Period Start", PayPeriodsRecL."Period Start Date");
            PayrollAdjmtJournalheaderRecL.VALIDATE("Pay Period End", PayPeriodsRecL."Period End Date");
            PayrollAdjmtJournalheaderRecL.VALIDATE("Pay Period Start", Rec."Pay Period Start");
            PayrollAdjmtJournalheaderRecL.VALIDATE("Pay Period End", Rec."Pay Period End");
            PayrollAdjmtJournalheaderRecL."Create By" := USERID;
            PayrollAdjmtJournalheaderRecL.VALIDATE("Created DateTime", CURRENTDATETIME);
            PayrollAdjmtJournalheaderRecL."Posted By" := USERID;
            PayrollAdjmtJournalheaderRecL.Posted := TRUE;
            PayrollAdjmtJournalheaderRecL.VALIDATE("Posted DateTime", CURRENTDATETIME);

            IF PayrollAdjmtJournalheaderRecL.INSERT THEN BEGIN
                EducationalClaimLinesRecL.RESET;
                EducationalClaimLinesRecL.SETRANGE("Claim ID", Rec."Claim ID");
                EducationalClaimLinesRecL.SETRANGE("Employee No.", Rec."Employee No.");
                EducationalClaimLinesRecL.SETRANGE("Allowance Type", EducationalClaimLinesRecL."Allowance Type"::"Educational Allowance");
                IF EducationalClaimLinesRecL.FINDFIRST THEN
                    PayrollAdjmtJournal_Line_For_EducationalAllowance_LT(JournalNoL);

                EducationalClaimLinesRecL.RESET;
                EducationalClaimLinesRecL.SETRANGE("Claim ID", Rec."Claim ID");
                EducationalClaimLinesRecL.SETRANGE("Employee No.", Rec."Employee No.");
                EducationalClaimLinesRecL.SETRANGE("Allowance Type", EducationalClaimLinesRecL."Allowance Type"::"Educational Book Allowance");
                IF EducationalClaimLinesRecL.FINDFIRST THEN
                    PayrollAdjmtJournal_Line_For_EducationaBookAllowance_LT(JournalNoL);

                EducationalClaimLinesRecL.RESET;
                EducationalClaimLinesRecL.SETRANGE("Claim ID", Rec."Claim ID");
                EducationalClaimLinesRecL.SETRANGE("Employee No.", Rec."Employee No.");
                EducationalClaimLinesRecL.SETRANGE("Allowance Type", EducationalClaimLinesRecL."Allowance Type"::"Special Need Allowance");
                IF EducationalClaimLinesRecL.FINDFIRST THEN
                    PayrollAdjmtJournal_Line_For_SpecialNeedAllowance_LT(JournalNoL);

                MESSAGE('Payroll Adjustment Created Successfully  %1', JournalNoL);
                Rec.Posted := TRUE;
                Rec.MODIFY();
            END;
        END;
    end;

    local procedure PayrollAdjmtJournal_Line_For_EducationalAllowance_LT(JournalNoP: Code[20])
    var
        PayrollAdjmtJournalLinesRecL: Record "Payroll Adjmt. Journal Lines";
        HumanResourcesSetupRecL: Record "Human Resources Setup";
        EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
        TotalAmountDecG: Decimal;
        EmployeeRecG: Record Employee;
        EarningCodeGroupsRecL: Record "Earning Code Groups";
        PayrollAdjmtJournalLinesRec2L: Record "Payroll Adjmt. Journal Lines";
        NewLineNoL: Integer;
    begin
        HumanResourcesSetupRecL.RESET;
        HumanResourcesSetupRecL.GET;
        EmployeeRecG.RESET;
        EmployeeRecG.GET(Rec."Employee No.");

        EducationalClaimLinesRecL.RESET;
        EducationalClaimLinesRecL.SETRANGE("Claim ID", Rec."Claim ID");
        EducationalClaimLinesRecL.SETRANGE("Employee No.", Rec."Employee No.");
        EducationalClaimLinesRecL.SETRANGE("Allowance Type", EducationalClaimLinesRecL."Allowance Type"::"Educational Allowance");
        IF EducationalClaimLinesRecL.FINDSET THEN BEGIN
            REPEAT
                TotalAmountDecG += EducationalClaimLinesRecL."Current Claim Amount";
            UNTIL EducationalClaimLinesRecL.NEXT = 0;
        END;

        PayrollAdjmtJournalLinesRec2L.RESET;
        PayrollAdjmtJournalLinesRec2L.SETRANGE("Journal No.", JournalNoP);
        IF PayrollAdjmtJournalLinesRec2L.FINDLAST THEN
            NewLineNoL := PayrollAdjmtJournalLinesRec2L."Line No." + 10000
        ELSE
            NewLineNoL := 10000;
        PayrollAdjmtJournalLinesRecL.INIT;
        PayrollAdjmtJournalLinesRecL.VALIDATE("Journal No.", JournalNoP);
        PayrollAdjmtJournalLinesRecL.VALIDATE("Line No.", NewLineNoL);
        PayrollAdjmtJournalLinesRecL.VALIDATE("Employee Code", Rec."Employee No.");
        PayrollAdjmtJournalLinesRecL.VALIDATE("Employee Name", EmployeeRecG."First Name");
        PayrollAdjmtJournalLinesRecL.VALIDATE("Earning Code", HumanResourcesSetupRecL."Edu. Allow. Payroll Component");
        PayrollAdjmtJournalLinesRecL.VALIDATE(Amount, TotalAmountDecG);
        PayrollAdjmtJournalLinesRecL.INSERT;
    end;

    local procedure PayrollAdjmtJournal_Line_For_EducationaBookAllowance_LT(JournalNoP: Code[20])
    var
        PayrollAdjmtJournalLinesRecL: Record "Payroll Adjmt. Journal Lines";
        HumanResourcesSetupRecL: Record "Human Resources Setup";
        EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
        TotalAmountDecG: Decimal;
        EmployeeRecG: Record Employee;
        EarningCodeGroupsRecL: Record "Earning Code Groups";
        PayrollAdjmtJournalLinesRec2L: Record "Payroll Adjmt. Journal Lines";
        NewLineNoL: Integer;
    begin
        HumanResourcesSetupRecL.RESET;
        HumanResourcesSetupRecL.GET;
        EmployeeRecG.RESET;
        EmployeeRecG.GET(Rec."Employee No.");

        EducationalClaimLinesRecL.RESET;
        EducationalClaimLinesRecL.SETRANGE("Claim ID", Rec."Claim ID");
        EducationalClaimLinesRecL.SETRANGE("Employee No.", Rec."Employee No.");
        EducationalClaimLinesRecL.SETRANGE("Allowance Type", EducationalClaimLinesRecL."Allowance Type"::"Educational Book Allowance");
        IF EducationalClaimLinesRecL.FINDSET THEN BEGIN
            REPEAT
                TotalAmountDecG += EducationalClaimLinesRecL."Current Claim Amount";
            UNTIL EducationalClaimLinesRecL.NEXT = 0;
        END;
        PayrollAdjmtJournalLinesRec2L.RESET;
        PayrollAdjmtJournalLinesRec2L.SETRANGE("Journal No.", JournalNoP);
        IF PayrollAdjmtJournalLinesRec2L.FINDLAST THEN
            NewLineNoL := PayrollAdjmtJournalLinesRec2L."Line No." + 10000
        ELSE
            NewLineNoL := 10000;
        PayrollAdjmtJournalLinesRecL.INIT;
        PayrollAdjmtJournalLinesRecL.VALIDATE("Journal No.", JournalNoP);
        PayrollAdjmtJournalLinesRecL.VALIDATE("Line No.", NewLineNoL);
        PayrollAdjmtJournalLinesRecL.VALIDATE("Employee Code", Rec."Employee No.");
        PayrollAdjmtJournalLinesRecL.VALIDATE("Employee Name", EmployeeRecG."First Name");
        PayrollAdjmtJournalLinesRecL.VALIDATE("Earning Code", HumanResourcesSetupRecL."Edu Book Payroll Component");
        PayrollAdjmtJournalLinesRecL.VALIDATE(Amount, TotalAmountDecG);
        PayrollAdjmtJournalLinesRecL.INSERT;
    end;

    local procedure PayrollAdjmtJournal_Line_For_SpecialNeedAllowance_LT(JournalNoP: Code[20])
    var
        PayrollAdjmtJournalLinesRecL: Record "Payroll Adjmt. Journal Lines";
        HumanResourcesSetupRecL: Record "Human Resources Setup";
        EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
        TotalAmountDecG: Decimal;
        EmployeeRecG: Record Employee;
        EarningCodeGroupsRecL: Record "Earning Code Groups";
        PayrollAdjmtJournalLinesRec2L: Record "Payroll Adjmt. Journal Lines";
        NewLineNoL: Integer;
    begin
        HumanResourcesSetupRecL.RESET;
        HumanResourcesSetupRecL.GET;
        EmployeeRecG.RESET;
        EmployeeRecG.GET(Rec."Employee No.");

        EducationalClaimLinesRecL.RESET;
        EducationalClaimLinesRecL.SETRANGE("Claim ID", Rec."Claim ID");
        EducationalClaimLinesRecL.SETRANGE("Employee No.", Rec."Employee No.");
        EducationalClaimLinesRecL.SETRANGE("Allowance Type", EducationalClaimLinesRecL."Allowance Type"::"Special Need Allowance");
        IF EducationalClaimLinesRecL.FINDSET THEN BEGIN
            REPEAT
                TotalAmountDecG += EducationalClaimLinesRecL."Current Claim Amount";
            UNTIL EducationalClaimLinesRecL.NEXT = 0;
        END;

        PayrollAdjmtJournalLinesRec2L.RESET;
        PayrollAdjmtJournalLinesRec2L.SETRANGE("Journal No.", JournalNoP);
        IF PayrollAdjmtJournalLinesRec2L.FINDLAST THEN
            NewLineNoL := PayrollAdjmtJournalLinesRec2L."Line No." + 10000
        ELSE
            NewLineNoL := 10000;
        PayrollAdjmtJournalLinesRecL.INIT;
        PayrollAdjmtJournalLinesRecL.VALIDATE("Journal No.", JournalNoP);
        PayrollAdjmtJournalLinesRecL.VALIDATE("Line No.", NewLineNoL);
        PayrollAdjmtJournalLinesRecL.VALIDATE("Employee Code", Rec."Employee No.");
        PayrollAdjmtJournalLinesRecL.VALIDATE("Employee Name", EmployeeRecG."First Name");
        PayrollAdjmtJournalLinesRecL.VALIDATE("Earning Code", HumanResourcesSetupRecL."Special Need Payroll Component");
        PayrollAdjmtJournalLinesRecL.VALIDATE(Amount, TotalAmountDecG);
        PayrollAdjmtJournalLinesRecL.INSERT;
    end;

    local procedure EnableControl_LT()
    begin

        IF Rec."Approval Status" = Rec."Approval Status"::Open THEN
            EnableControlG := TRUE
        ELSE
            EnableControlG := FALSE;
    end;

    local procedure SetControlAppearance()
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

        if Rec."Approval Status" = Rec."Approval Status"::Open then
            WFOpenBoolG := true
        else
            WFOpenBoolG := false;

        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then
            WFPendingAppBoolG := true
        else
            WFPendingAppBoolG := false;
    end;

    local procedure CreateJournal_PayrollAdj()
    begin
        IF Rec."Approval Status" = Rec."Approval Status"::Released THEN BEGIN
            IF Rec."Posting Type" = Rec."Posting Type"::Payroll THEN BEGIN
                CreateJournalControlG := FALSE;
                PayrollControlG := TRUE
            END
            ELSE
                IF Rec."Posting Type" = Rec."Posting Type"::Payroll THEN BEGIN
                    PayrollControlG := FALSE;
                    CreateJournalControlG := TRUE
                END
        END ELSE BEGIN
            PayrollControlG := FALSE;
            CreateJournalControlG := FALSE;
        END;
        IF Rec.Posted THEN BEGIN
            PayrollControlG := FALSE;
            CreateJournalControlG := FALSE;
        END;


        IF (Rec."Approval Status" = Rec."Approval Status"::"Pending Approval") OR (Rec."Approval Status" = Rec."Approval Status"::Released) THEN
            CancelContrlaVarG := TRUE
        ELSE
            CancelContrlaVarG := FALSE;
    end;

    local procedure payEditable()
    begin
        IF Rec."Approval Status" = Rec."Approval Status"::Open THEN BEGIN
            IF Rec."Posting Type" <> Rec."Posting Type"::Finance THEN
                PayBoolG := FALSE
            ELSE
                PayBoolG := TRUE;
        END ELSE
            PayBoolG := FALSE;
    end;

    procedure CheckAllowanceDepentedCount_Edu_LT()
    begin
        CLEAR(EduAllowanceType_G);
        CLEAR(EduBookAllowanceType_G);
        CLEAR(OverallLoop);
        EducationalClaimLinesLTRec_G.RESET;
        EducationalClaimLinesLTRec_G.SETCURRENTKEY("Dependent ID", "Claim ID", "Academic year");
        EducationalClaimLinesLTRec_G.SETRANGE("Claim ID", Rec."Claim ID");
        EducationalClaimLinesLTRec_G.SETRANGE("Academic year", Rec."Academic year");
        EducationalClaimLinesLTRec_G.SETRANGE("Employee No.", Rec."Employee No.");
        IF EducationalClaimLinesLTRec_G.FINDSET THEN BEGIN
            REPEAT
                IF LastDependentID <> EducationalClaimLinesLTRec_G."Dependent ID" THEN BEGIN
                    EducationalClaimLinesLTRec_2_G.RESET;
                    EducationalClaimLinesLTRec_2_G.SETRANGE("Academic year", Rec."Academic year");
                    EducationalClaimLinesLTRec_2_G.SETRANGE("Dependent ID", EducationalClaimLinesLTRec_G."Dependent ID");
                    EducationalClaimLinesLTRec_2_G.SETRANGE("Employee No.", EducationalClaimLinesLTRec_G."Employee No.");
                    EducationalClaimLinesLTRec_2_G.SETFILTER("Allowance Type", '%1|%2', EducationalClaimLinesLTRec_2_G."Allowance Type"::"Educational Allowance", EducationalClaimLinesLTRec_3_G."Allowance Type"::"Educational Book Allowance");
                    IF EducationalClaimLinesLTRec_2_G.FINDFIRST THEN BEGIN
                        EduAllowanceType_G += 1;
                    END;
                END;
                LastDependentID := EducationalClaimLinesLTRec_G."Dependent ID";
            UNTIL EducationalClaimLinesLTRec_G.NEXT = 0;
        END;

        CLEAR(EduBookAllowanceType_G);
        EducationalClaimLinesLTRec_3_G.RESET;
        EducationalClaimLinesLTRec_3_G.SETCURRENTKEY("Dependent ID", "Academic year");
        EducationalClaimLinesLTRec_3_G.SETRANGE("Academic year", Rec."Academic year");
        EducationalClaimLinesLTRec_3_G.SETRANGE("Employee No.", Rec."Employee No.");
        EducationalClaimLinesLTRec_3_G.SETFILTER("Allowance Type", '%1|%2', EducationalClaimLinesLTRec_3_G."Allowance Type"::"Educational Allowance", EducationalClaimLinesLTRec_3_G."Allowance Type"::"Educational Book Allowance");
        IF EducationalClaimLinesLTRec_3_G.FINDSET THEN BEGIN
            REPEAT
                IF CheckOldDepID_G <> EducationalClaimLinesLTRec_3_G."Dependent ID" THEN BEGIN
                    EduBookAllowanceType_G += 1;
                END;
                CheckOldDepID_G := EducationalClaimLinesLTRec_3_G."Dependent ID";
            UNTIL EducationalClaimLinesLTRec_3_G.NEXT = 0;
        END;
        IF (EduBookAllowanceType_G) > GetAllowanceMaxCount2_LT THEN
            ERROR('You can apply claim only for %1 Depdendents.', GetAllowanceMaxCount2_LT)
        ELSE
            IF EduAllowanceType_G > GetAllowanceMaxCount2_LT THEN
                ERROR('You can apply claim only for %1 Depdendents.', GetAllowanceMaxCount2_LT);
    end;

    procedure GetAllowanceMaxCount2_LT(): Integer
    var
        EducationalAllowanceLTRecL: Record "Educational Allowance LT";
        EmployeeEarningCodeGroupsRecL: Record "Employee Earning Code Groups";
        EducationalClaimHeaderLT: Record "Educational Claim Header LT";
        EducationalClaimLinesLT: Record "Educational Claim Lines LT";
    begin
        EducationalClaimHeaderLT.RESET;
        EducationalClaimHeaderLT.SETRANGE("Claim ID", Rec."Claim ID");
        EducationalClaimHeaderLT.SETRANGE("Employee No.", Rec."Employee No.");
        IF EducationalClaimHeaderLT.FINDFIRST THEN BEGIN
            EmployeeEarningCodeGroupsRecL.RESET;
            EmployeeEarningCodeGroupsRecL.SETRANGE("Employee Code", EducationalClaimHeaderLT."Employee No.");
            EmployeeEarningCodeGroupsRecL.SETFILTER("Valid To", '%1', 0D);
            IF EmployeeEarningCodeGroupsRecL.FINDFIRST THEN BEGIN
                EducationalAllowanceLTRecL.RESET;
                EducationalAllowanceLTRecL.SETRANGE("Grade Category", EmployeeEarningCodeGroupsRecL."Grade Category");
                EducationalAllowanceLTRecL.SETRANGE("Earnings Code Group", EmployeeEarningCodeGroupsRecL."Earning Code Group");
                IF EducationalAllowanceLTRecL.FINDFIRST THEN
                    EXIT(EducationalAllowanceLTRecL."Count of children eligible");
            END;
        END;
    end;

    procedure AvoideMutliformOpen_LT()
    var
        EducationalClaimHeaderLTRec_L: Record "Educational Claim Header LT";
    begin
        EducationalClaimHeaderLTRec_L.RESET;
        EducationalClaimHeaderLTRec_L.SETRANGE("Employee No.", Rec."Employee No.");
        EducationalClaimHeaderLTRec_L.SETRANGE("Academic year", Rec."Academic year");
        EducationalClaimHeaderLTRec_L.SETRANGE(Posted, FALSE);
        IF EducationalClaimHeaderLTRec_L.FINDFIRST THEN BEGIN
            ERROR('Open document already exists, please update or cancel the existing document %1', EducationalClaimHeaderLTRec_L."Claim ID");
        END;
    end;

    procedure CancelApprovalRequest_rec(EducationalClaimHeaderLT_G: Record "Educational Claim Header LT")
    begin
        CurrPage.SETSELECTIONFILTER(EducationalClaimHeaderLTRec_G);
        ApprovalEntryRec_G.RESET;
        ApprovalEntryRec_G.SETRANGE("Document No.", EducationalClaimHeaderLT_G."Claim ID");
        IF ApprovalEntryRec_G.FINDSET THEN
            ApprovalEntryRec_G.DELETEALL;
    end;

    local procedure CheckUser()
    var
        UserSetup: Record "User Setup";
    begin
        IF CURRENTCLIENTTYPE = CLIENTTYPE::Web THEN BEGIN
            UserSetup.RESET;
            UserSetup.SETRANGE("User ID", USERID);
            UserSetup.SETRANGE("HR Manager", TRUE);
            IF UserSetup.FINDFIRST THEN BEGIN
                IF Rec."Approval Status" = Rec."Approval Status"::Released THEN
                    HrBool := TRUE
                ELSE
                    HrBool := FALSE
            END
            ELSE BEGIN
                HrBool := FALSE;
            END;
        END
        ELSE BEGIN
            IF Rec."Approval Status" = Rec."Approval Status"::Released THEN
                HrBool := TRUE
            ELSE
                HrBool := FALSE
        END;
        HrBool := TRUE;
    end;
}