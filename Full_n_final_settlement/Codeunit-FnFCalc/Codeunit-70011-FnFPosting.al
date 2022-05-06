codeunit 70011 "FnF Posting"
{
    var
        GenJrnLineRecG: Record "Gen. Journal Line";
        GenJrnLineRec2G: Record "Gen. Journal Line";
        GenJournalBatchRecG: Record "Gen. Journal Batch";
        NoSeriesMgntCUG: Codeunit NoSeriesManagement;
        AdvancePayrollSetupRecG: Record "Advance Payroll Setup";
        PayrollEarningCodeRecG: Record "Payroll Earning Code";
        HCMBenefitRecG: Record "HCM Benefit";
        LeaveEncashmentsRecG: Record "Leave Encashment";
        FsLoansRecG: Record "FS Loans";
        FSEarninfCodeRec_P: Record "FS - Earning Code";

    procedure CreateGeneralJournalLine(JournalID_P: Code[20]; EmployeeCode_P: Code[20]): Code[30]
    var
        DocumentsNo_L: Code[20];
        Employee: Record Employee;
    begin
        AdvancePayrollSetupRecG.Get();
        AdvancePayrollSetupRecG.TestField("FnF Journal Template Name");
        AdvancePayrollSetupRecG.TestField("FnF Journal Batch Name");

        // Start No. Series Setup
        GenJournalBatchRecG.Reset();
        GenJournalBatchRecG.SetRange("Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Template Name");
        GenJournalBatchRecG.SetRange(Name, AdvancePayrollSetupRecG."FnF Journal Batch Name");
        if GenJournalBatchRecG.FindFirst() then
            GenJournalBatchRecG.TestField("No. Series");
        // Stop No. Series Setup

        // Start Checking Old Records/Delete
        GenJrnLineRec2G.Reset();
        GenJrnLineRec2G.SetRange("Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Template Name");
        GenJrnLineRec2G.SetRange("Journal Batch Name", AdvancePayrollSetupRecG."FnF Journal Batch Name");
        GenJrnLineRec2G.SetRange("External Document No.", JournalID_P);
        GenJrnLineRec2G.DeleteAll();
        // Stop Checking Old Records/Delete

        // Start Documents No.
        Clear(DocumentsNo_L);
        DocumentsNo_L := NoSeriesMgntCUG.GetNextNo(GenJournalBatchRecG."No. Series", Today, true);
        // Stop documents No.

        // Start Inserting Gen. Journal Lines
        FSEarninfCodeRec_P.Reset();
        FSEarninfCodeRec_P.SetRange("Journal ID", JournalID_P);
        FSEarninfCodeRec_P.SetRange("Employee No.", EmployeeCode_P);
        if FSEarninfCodeRec_P.FindFirst() then begin
            repeat
                // Start Earning Code Lines
                if (FSEarninfCodeRec_P."Earning Code" <> '') and (FSEarninfCodeRec_P."Earning Code Amount" > 0) then begin
                    if CheckFinAccrualEarningCode(FSEarninfCodeRec_P."Earning Code") then begin
                        GenJrnLineRecG.Init();
                        GenJrnLineRecG.Validate("Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Template Name");
                        GenJrnLineRecG.Validate("Journal Batch Name", AdvancePayrollSetupRecG."FnF Journal Batch Name");
                        GenJrnLineRecG.Validate("Document No.", DocumentsNo_L);
                        GenJrnLineRecG.Validate("Line No.", GetNextLineNo(AdvancePayrollSetupRecG."FnF Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Batch Name", DocumentsNo_L));
                        GenJrnLineRecG.Validate("Document Date", Today);
                        GenJrnLineRecG.Validate("Posting Date", Today);
                        GenJrnLineRecG."Document Type" := GenJrnLineRecG."Document Type"::" ";
                        GenJrnLineRecG.Insert(true);

                        PayrollEarningCodeRecG.Reset();
                        PayrollEarningCodeRecG.SetRange("Earning Code", FSEarninfCodeRec_P."Earning Code");
                        if PayrollEarningCodeRecG.FindFirst() then;

                        PayrollEarningCodeRecG.TestField("Main Account No.");
                        GenJrnLineRecG.Validate("Account Type", PayrollEarningCodeRecG."Main Account Type");
                        GenJrnLineRecG.Validate("Account No.", PayrollEarningCodeRecG."Main Account No.");

                        IF AdvancePayrollSetupRecG."F and F Vendor Posting" THEN BEGIN
                            Employee.GET(EmployeeCode_P);
                            Employee.TESTFIELD("Vendor Account");
                            GenJrnLineRecG.Validate("Bal. Account Type", GenJrnLineRecG."Bal. Account Type"::Vendor);
                            GenJrnLineRecG.Validate("Bal. Account No.", Employee."Vendor Account");
                        END
                        ELSE BEGIN
                            PayrollEarningCodeRecG.TestField("Offset Account No.");
                            GenJrnLineRecG.Validate("Bal. Account Type", PayrollEarningCodeRecG."Offset Account Type");
                            GenJrnLineRecG.Validate("Bal. Account No.", PayrollEarningCodeRecG."Offset Account No.");
                        END;
                        GenJrnLineRecG.Validate("Credit Amount", FSEarninfCodeRec_P."Earning Code Amount");
                        GenJrnLineRecG.Validate("Debit Amount", FSEarninfCodeRec_P."Earning Code Amount");
                        GenJrnLineRecG.Validate(Amount, FSEarninfCodeRec_P."Earning Code Amount");
                        GenJrnLineRecG."External Document No." := JournalID_P;
                        GenJrnLineRecG.Validate("Currency Code", FSEarninfCodeRec_P.Currency);
                        GenJrnLineRecG.Modify();
                    end;
                end;
                // Stop Earning Code Lines

                // Start Benefit Code Lines
                if (FSEarninfCodeRec_P."Benefit Code" <> '') and (FSEarninfCodeRec_P."Benefit Amount" > 0) then begin
                    if CheckFinAccrualBenefitCode(FSEarninfCodeRec_P."Benefit Code") then begin
                        GenJrnLineRecG.Init();
                        GenJrnLineRecG.Validate("Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Template Name");
                        GenJrnLineRecG.Validate("Journal Batch Name", AdvancePayrollSetupRecG."FnF Journal Batch Name");
                        GenJrnLineRecG.Validate("Document No.", DocumentsNo_L);
                        GenJrnLineRecG.Validate("Line No.", GetNextLineNo(AdvancePayrollSetupRecG."FnF Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Batch Name", DocumentsNo_L));
                        GenJrnLineRecG.Validate("Document Date", Today);
                        GenJrnLineRecG.Validate("Posting Date", Today);
                        GenJrnLineRecG."Document Type" := GenJrnLineRecG."Document Type"::" ";
                        GenJrnLineRecG.Insert(true);

                        HCMBenefitRecG.Reset();
                        HCMBenefitRecG.SetRange("Benefit Id", FSEarninfCodeRec_P."Benefit Code");
                        if HCMBenefitRecG.FindSet() then;

                        HCMBenefitRecG.TestField("Main Account No.");

                        GenJrnLineRecG.Validate("Account Type", HCMBenefitRecG."Main Account Type");
                        GenJrnLineRecG.Validate("Account No.", HCMBenefitRecG."Main Account No.");

                        IF AdvancePayrollSetupRecG."F and F Vendor Posting" THEN BEGIN
                            Employee.GET(EmployeeCode_P);
                            Employee.TESTFIELD("Vendor Account");
                            GenJrnLineRecG.Validate("Bal. Account Type", GenJrnLineRecG."Bal. Account Type"::Vendor);
                            GenJrnLineRecG.Validate("Bal. Account No.", Employee."Vendor Account");
                        END
                        ELSE BEGIN
                            HCMBenefitRecG.TestField("Offset Account No.");
                            GenJrnLineRecG.Validate("Bal. Account Type", HCMBenefitRecG."Offset Account Type");
                            GenJrnLineRecG.Validate("Bal. Account No.", HCMBenefitRecG."Offset Account No.");
                        END;
                        GenJrnLineRecG.Validate("Credit Amount", FSEarninfCodeRec_P."Benefit Amount");
                        GenJrnLineRecG.Validate("Debit Amount", FSEarninfCodeRec_P."Benefit Amount");
                        GenJrnLineRecG.Validate(Amount, FSEarninfCodeRec_P."Benefit Amount");
                        GenJrnLineRecG."External Document No." := JournalID_P;
                        GenJrnLineRecG.Validate("Currency Code", FSEarninfCodeRec_P.Currency);
                        GenJrnLineRecG.Modify();
                    end;
                end;
            // Stop Benefit Code Lines
            until FSEarninfCodeRec_P.Next() = 0;

            // Start Leave
            LeaveEncashmentsRecG.Reset();
            LeaveEncashmentsRecG.SetRange("Journal ID", JournalID_P);
            LeaveEncashmentsRecG.SetRange("Employee No.", EmployeeCode_P);
            if LeaveEncashmentsRecG.FindSet() then begin
                repeat
                    GenJrnLineRecG.Init();
                    GenJrnLineRecG.Validate("Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Template Name");
                    GenJrnLineRecG.Validate("Journal Batch Name", AdvancePayrollSetupRecG."FnF Journal Batch Name");
                    GenJrnLineRecG.Validate("Document No.", DocumentsNo_L);
                    GenJrnLineRecG.Validate("Line No.", GetNextLineNo(AdvancePayrollSetupRecG."FnF Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Batch Name", DocumentsNo_L));
                    GenJrnLineRecG.Validate("Document Date", Today);
                    GenJrnLineRecG.Validate("Posting Date", Today);
                    GenJrnLineRecG."Document Type" := GenJrnLineRecG."Document Type"::" ";
                    GenJrnLineRecG.Insert(true);

                    AdvancePayrollSetupRecG.TestField("Leave Encashment Credit A/C");

                    GenJrnLineRecG.Validate("Account Type", AdvancePayrollSetupRecG."Leave Encashment Cr A/C Type");
                    GenJrnLineRecG.Validate("Account No.", AdvancePayrollSetupRecG."Leave Encashment Credit A/C");

                    IF AdvancePayrollSetupRecG."F and F Vendor Posting" THEN BEGIN
                        Employee.GET(EmployeeCode_P);
                        Employee.TESTFIELD("Vendor Account");
                        GenJrnLineRecG.Validate("Bal. Account Type", GenJrnLineRecG."Bal. Account Type"::Vendor);
                        GenJrnLineRecG.Validate("Bal. Account No.", Employee."Vendor Account");
                    END
                    ELSE BEGIN
                        AdvancePayrollSetupRecG.TestField("Leave Encashment Debit A/C");
                        GenJrnLineRecG.Validate("Bal. Account Type", AdvancePayrollSetupRecG."Leave Encashment Dr A/C Type");
                        GenJrnLineRecG.Validate("Bal. Account No.", AdvancePayrollSetupRecG."Leave Encashment Debit A/C");
                    END;

                    GenJrnLineRecG.Validate("Credit Amount", LeaveEncashmentsRecG."Leave Encashment Amount");
                    GenJrnLineRecG.Validate("Debit Amount", LeaveEncashmentsRecG."Leave Encashment Amount");
                    GenJrnLineRecG.Validate(Amount, LeaveEncashmentsRecG."Leave Encashment Amount");
                    GenJrnLineRecG.Validate("Currency Code", FSEarninfCodeRec_P.Currency);
                    GenJrnLineRecG."External Document No." := JournalID_P;
                    GenJrnLineRecG.Modify();
                until LeaveEncashmentsRecG.Next() = 0;
            end;
            // Stop Leave
            // Start Loans
            FsLoansRecG.Reset();
            FsLoansRecG.SetRange("Journal ID", JournalID_P);
            FsLoansRecG.SetRange("Employee No.", EmployeeCode_P);
            if FsLoansRecG.FindSet() then begin
                repeat
                    if CheckFinAccrualEarningCode(FsLoansRecG."EmployeeEarning Code") then begin

                        GenJrnLineRecG.Init();
                        GenJrnLineRecG.Validate("Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Template Name");
                        GenJrnLineRecG.Validate("Journal Batch Name", AdvancePayrollSetupRecG."FnF Journal Batch Name");
                        GenJrnLineRecG.Validate("Document No.", DocumentsNo_L);
                        GenJrnLineRecG.Validate("Line No.", GetNextLineNo(AdvancePayrollSetupRecG."FnF Journal Template Name", AdvancePayrollSetupRecG."FnF Journal Batch Name", DocumentsNo_L));
                        GenJrnLineRecG.Validate("Document Date", Today);
                        GenJrnLineRecG.Validate("Posting Date", Today);
                        GenJrnLineRecG."Document Type" := GenJrnLineRecG."Document Type"::" ";
                        GenJrnLineRecG.Insert(true);

                        PayrollEarningCodeRecG.Reset();
                        PayrollEarningCodeRecG.SetRange("Earning Code", FsLoansRecG."EmployeeEarning Code");
                        if PayrollEarningCodeRecG.FindFirst() then;

                        PayrollEarningCodeRecG.TestField("Main Account No.");


                        GenJrnLineRecG.Validate("Account Type", PayrollEarningCodeRecG."Main Account Type");
                        GenJrnLineRecG.Validate("Account No.", PayrollEarningCodeRecG."Main Account No.");

                        IF AdvancePayrollSetupRecG."F and F Vendor Posting" THEN BEGIN
                            Employee.GET(EmployeeCode_P);
                            Employee.TESTFIELD("Vendor Account");
                            GenJrnLineRecG.Validate("Bal. Account Type", GenJrnLineRecG."Bal. Account Type"::Vendor);
                            GenJrnLineRecG.Validate("Bal. Account No.", Employee."Vendor Account");
                        END
                        ELSE BEGIN
                            PayrollEarningCodeRecG.TestField("Offset Account No.");
                            GenJrnLineRecG.Validate("Bal. Account Type", PayrollEarningCodeRecG."Offset Account Type");
                            GenJrnLineRecG.Validate("Bal. Account No.", PayrollEarningCodeRecG."Offset Account No.");
                        END;

                        GenJrnLineRecG.Validate("Credit Amount", FsLoansRecG."Installment Amount");
                        GenJrnLineRecG.Validate("Debit Amount", FsLoansRecG."Installment Amount");
                        GenJrnLineRecG.Validate(Amount, FsLoansRecG."Installment Amount");

                        GenJrnLineRecG.Validate("Currency Code", FSEarninfCodeRec_P.Currency);
                        GenJrnLineRecG."External Document No." := JournalID_P;
                        GenJrnLineRecG.Modify();
                    end;
                until FsLoansRecG.Next() = 0;
            end;
            // Stop Loans
        end;
        // Stop Inserting Gen. Journal Lines
        exit(DocumentsNo_L);
    end;

    procedure GetNextLineNo(TemplateCode_P: Code[20]; BatchCode_P: code[20]; DocNo_P: Code[20]): Integer
    var
        GenJrnLineRecL: Record "Gen. Journal Line";
    begin
        GenJrnLineRecL.Reset();
        GenJrnLineRecL.SetRange("Journal Template Name", TemplateCode_P);
        GenJrnLineRecL.SetRange("Journal Batch Name", BatchCode_P);
        if GenJrnLineRecL.FindLast() then;
        exit(GenJrnLineRecL."Line No." + 10000);
    end;

    procedure CheckFinAccrualEarningCode(EarnuingCode_P: Code[20]): Boolean
    var
        PayrollEarningCodeRec_L: Record "Payroll Earning Code";
    begin
        PayrollEarningCodeRec_L.Reset();
        PayrollEarningCodeRec_L.SetRange("Earning Code", EarnuingCode_P);
        if PayrollEarningCodeRec_L.FindFirst() then;
        exit(PayrollEarningCodeRec_L."Fin Accrual Required");
    end;

    procedure CheckFinAccrualBenefitCode(BenefitCode_P: Code[20]): Boolean
    var
        HCMBenefitRec_L: Record "HCM Benefit";
    begin
        HCMBenefitRec_L.Reset();
        HCMBenefitRec_L.SetRange("Benefit Id", BenefitCode_P);
        if HCMBenefitRec_L.FindFirst() then;
        exit(HCMBenefitRec_L."Fin Accrual Required");
    end;
}