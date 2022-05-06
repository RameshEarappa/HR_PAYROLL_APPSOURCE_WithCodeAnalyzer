report 60536 "Payroll JV Export Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = TRUE;
    UseRequestPage = FALSE;
    dataset
    {
        dataitem(PayrollAdjmtJournalLines; "Payroll Statement Lines")
        {
            trigger OnPreDataItem()
            begin
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn('Employee Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Employee Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Account', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Pay Element', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Debit', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Credit', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Amt(US$)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Amt(AED)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            end;

            trigger OnAfterGetRecord()
            var
                PreviousEmployeeCodeCodeL: Code[20];
            begin

                if PreviousEmployeeCodeCodeL <> PayrollAdjmtJournalLines.Worker then;

                if PayrollAdjmtJournalLines."Payroll Earning Code" <> '' then
                    Main_OffsetAccountEarningCodeLines(PayrollAdjmtJournalLines);

                if PayrollAdjmtJournalLines."Benefit Code" <> '' then
                    Main_OffsetAccountBenefitCodeLines(PayrollAdjmtJournalLines);

            end;
        }
    }
    trigger OnInitReport()
    begin
        ExcelBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    begin
        ExcelBuffer.CreateNewBook('Payroll JV Export');
        ExcelBuffer.WriteSheet('Payroll JV Export', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
    end;

    VAR
        ExcelBuffer: Record "Excel Buffer" temporary;

    procedure Main_OffsetAccountEarningCodeLines(PayrollAdjmtJournalLines_P: Record "Payroll Statement Lines")
    var
        EmployeeRecL: Record Employee;
        EmployeeBackAccountRecG: Record "Employee Bank Account";
        PayrollStatementRecL: Record "Payroll Statement";
        PayrollEarningCodeRecL: Record "Payroll Earning Code";
        ExchangeRateCUL: Record "Currency Exchange Rate";
        GenLedgerSetupRecL: Record "General Ledger Setup";
        AmntUSDDecL: Decimal;
    begin
        GenLedgerSetupRecL.Reset();
        if GenLedgerSetupRecL.Get() then;

        PayrollEarningCodeRecL.Reset();
        PayrollEarningCodeRecL.SetRange("Earning Code", PayrollAdjmtJournalLines_P."Payroll Earning Code");
        PayrollEarningCodeRecL.SetRange("Fin Accrual Required", true);
        if PayrollEarningCodeRecL.FindFirst() then begin

            EmployeeRecL.Reset();
            EmployeeRecL.SetRange("No.", PayrollAdjmtJournalLines.Worker);
            if EmployeeRecL.FindFirst() then;

            Clear(AmntUSDDecL);
            AmntUSDDecL := ExchangeRateCUL.ExchangeAmtFCYToLCY(WorkDate(),
                                                                GenLedgerSetupRecL."LCY Code",
                                                                PayrollAdjmtJournalLines_P."Earning Code Amount",
                                                                ExchangeRateCUL.ExchangeRate(WorkDate(), GenLedgerSetupRecL."LCY Code"));

            ExcelBuffer.NewRow();
            ExcelBuffer.AddColumn(EmployeeRecL."No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(EmployeeRecL.FullName(), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PayrollEarningCodeRecL."Main Account No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PayrollEarningCodeRecL.Description, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

            ExcelBuffer.AddColumn(ROUND(PayrollAdjmtJournalLines_P."Earning Code Amount", 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Debit
            ExcelBuffer.AddColumn(ROUND(0, 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Credit
            ExcelBuffer.AddColumn(ROUND(AmntUSDDecL, 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Amount USD
            ExcelBuffer.AddColumn(ROUND(PayrollAdjmtJournalLines_P."Earning Code Amount", 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Amount AED

            ExcelBuffer.NewRow();
            ExcelBuffer.AddColumn(EmployeeRecL."No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(EmployeeRecL.FullName(), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PayrollEarningCodeRecL."Offset Account No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(PayrollEarningCodeRecL.Description, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

            ExcelBuffer.AddColumn(ROUND(0, 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Debit
            ExcelBuffer.AddColumn(ROUND(PayrollAdjmtJournalLines_P."Earning Code Amount", 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Credit
            ExcelBuffer.AddColumn(ROUND(AmntUSDDecL, 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Amount USD
            ExcelBuffer.AddColumn(ROUND(PayrollAdjmtJournalLines_P."Earning Code Amount", 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Amount AED
        end;
    end;

    procedure Main_OffsetAccountBenefitCodeLines(PayrollAdjmtJournalLines_P: Record "Payroll Statement Lines")
    var
        EmployeeRecL: Record Employee;
        EmployeeBackAccountRecG: Record "Employee Bank Account";
        PayrollStatementRecL: Record "Payroll Statement";
        ExchangeRateCUL: Record "Currency Exchange Rate";
        GenLedgerSetupRecL: Record "General Ledger Setup";
        HcmBenefitRecL: Record "HCM Benefit";
        AmntUSDDecL: Decimal;
    begin
        GenLedgerSetupRecL.Reset();
        if GenLedgerSetupRecL.Get() then;

        HcmBenefitRecL.Reset();
        HcmBenefitRecL.SetRange("Benefit Id", PayrollAdjmtJournalLines_P."Benefit Code");
        HcmBenefitRecL.SetRange("Fin Accrual Required", true);
        if HcmBenefitRecL.FindFirst() then begin

            EmployeeRecL.Reset();
            EmployeeRecL.SetRange("No.", PayrollAdjmtJournalLines.Worker);
            if EmployeeRecL.FindFirst() then;

            Clear(AmntUSDDecL);
            AmntUSDDecL := ExchangeRateCUL.ExchangeAmtFCYToLCY(WorkDate(),
                                                                GenLedgerSetupRecL."LCY Code",
                                                                PayrollAdjmtJournalLines_P."Benefit Amount",
                                                                ExchangeRateCUL.ExchangeRate(WorkDate(), GenLedgerSetupRecL."LCY Code"));

            ExcelBuffer.NewRow();
            ExcelBuffer.AddColumn(EmployeeRecL."No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(EmployeeRecL.FullName(), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(HcmBenefitRecL."Main Account No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(HcmBenefitRecL.Description, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

            ExcelBuffer.AddColumn(ROUND(PayrollAdjmtJournalLines_P."Benefit Amount", 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Debit
            ExcelBuffer.AddColumn(ROUND(0, 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Text); // Credit
            ExcelBuffer.AddColumn(ROUND(AmntUSDDecL, 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Amount USD
            ExcelBuffer.AddColumn(ROUND(PayrollAdjmtJournalLines_P."Benefit Amount", 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Amount AED

            ExcelBuffer.NewRow();
            ExcelBuffer.AddColumn(EmployeeRecL."No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(EmployeeRecL.FullName(), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(HcmBenefitRecL."Offset Account No.", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(HcmBenefitRecL.Description, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

            ExcelBuffer.AddColumn(ROUND(0, 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Debit
            ExcelBuffer.AddColumn(ROUND(PayrollAdjmtJournalLines_P."Benefit Amount", 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Credit
            ExcelBuffer.AddColumn(ROUND(AmntUSDDecL, 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Amount USD
            ExcelBuffer.AddColumn(ROUND(PayrollAdjmtJournalLines_P."Benefit Amount", 0.01, '>'), false, '', true, false, false, '0.00', ExcelBuffer."Cell Type"::Number); // Amount AED
        end;
    end;
}