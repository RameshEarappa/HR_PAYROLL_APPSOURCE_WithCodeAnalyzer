report 60535 "Full N Final Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './HR_Payroll/Layout_Reports/Report-60535-FullNFinal/FullandFinal_New.rdl';

    dataset
    {
        dataitem("Full and Final Calculation"; "Full and Final Calculation")
        {
            RequestFilterFields = "Journal ID";
            column(CompanyInformation_Logo; CompanyInformation.Picture) { }
            column(CompanyInformation_Name; CompanyInformation.Name) { }
            column(CompanyInformation_address; CompanyInformation.Address) { }
            column(CompanyInformation_Address2; CompanyInformation."Address 2") { }
            column(CompanyInformation_PostalCode; CompanyInformation."Post Code") { }
            column(CountryRegRecG_Country; CountryRegRecG.Name) { }
            column(PayPeriodCode; PayPeriodCode) { }
            column(No_; "Employee No.") { }
            column(FullName; "Employee Name") { }
            column(GetEmployeeDesignation_; GetEmployeeDesignation("Employee No.")) { }
            column(Joining_Date; FORMAT("Joining Date", 0, '<Day,2>-<Month Text>-<Year4>')) { }
            column(BankAccountNumber1; EmployeeBacnkDetailsRecG."Bank Acccount Number") { }
            column(BankName; EmployeeBacnkDetailsRecG."Bank Name") { }
            column(IBAN_EmployeeBankAccount; EmployeeBacnkDetailsRecG.IBAN) { }
            column(Service_Days; "Service Days") { }
            column(Termination_Date; FORMAT("Termination Date", 0, '<Day,2>-<Month Text>-<Year4>')) { }
            column(FSLoanEMIAmountG; FSLoanEMIAmountG) { }
            column(Payroll_Amount; "Payroll Amount") { }
            column(Indemnity_Gratuity_Amount; "Indemnity/Gratuity Amount") { }
            column(Leave_Encashment; "Leave Encashment") { }
            column(Loan_Recovery; "Loan Recovery") { }
            column(Currency; Currency) { }
            column(AmountInWord_LT; AmountInWord[2]) { }
            column(AmountInWord_LT1; AmountInWord[1]) { }
            column(TotalAmountForWordG; TotalAmountForWordG) { }
            column(TerminationReason; TerminationReason("Employee No.")) { }

            dataitem("Leave Encashment"; "Leave Encashment")
            {
                DataItemLink = "Employee No." = FIELD("Employee No."), "Journal ID" = field("Journal ID");
                column(Leave_Units; "Leave Units") { }
                column(Leave_Encashment_Amount; "Leave Encashment Amount") { }
            }

            dataitem("Payroll Earning Code Wrkr"; "Payroll Earning Code Wrkr")
            {
                DataItemLink = Worker = field("Employee No.");
                column(Earning_Code_Emplo; "Earning Code") { }
                column(Description; Description) { }
                column(Package_Amount; "Package Amount") { }
            }

            dataitem("FS - Earning Code"; "FS - Earning Code")
            {
                DataItemLink = "Employee No." = FIELD("Employee No."), "Journal ID" = field("Journal ID");
                DataItemTableView = sorting("Pay Period Start");
                column(Earning_Code; "Earning Code") { }
                column(Earning_Description; "Earning Description") { }
                column(Earning_Code_Amount; "Earning Code Amount") { }
                column(Benefit_Code; "Benefit Code") { }
                column(Benefit_Description; "Benefit Description") { }
                column(Benefit_Amount; "Benefit Amount") { }
                column(Pay_Period_Start; FORMAT("Pay Period Start", 0, '<Month Text>-<Year4>')) { }
                column(Pay_Period_Start_sort; "Pay Period Start") { }
                column(Pay_Period_End; "Pay Period End") { }
                column(TotalDeductions; TotalDeductions) { }
                column(TotalPayments; TotalPayments) { }
                column(LineDudG; LineDudG) { }
                column(LineEarningG; LineEarningG) { }
                column(StartEndCountG; StartEndCountG) { }

                trigger OnAfterGetRecord()
                var
                    FsReaningCodeRecL: Record "FS - Earning Code";
                    FsReaningCodeRec2L: Record "FS - Earning Code";
                    FsReaningCodeRec3L: Record "FS - Earning Code";
                    LastDate: Date;
                    FirstDate: Date;
                begin
                    Clear(TotalPayments);
                    Clear(TotalDeductions);
                    Clear(LineDudG);
                    Clear(LineEarningG);

                    FsReaningCodeRecL.Reset();
                    FsReaningCodeRecL.SetRange("Journal ID", "Journal ID");
                    FsReaningCodeRecL.SetRange("Employee No.", "Employee No.");
                    FsReaningCodeRecL.SetFilter("Earning Code Amount", '>%1', 0);
                    FsReaningCodeRecL.SetRange("Pay Period Start", "Pay Period Start");
                    if FsReaningCodeRecL.FindSet() then
                        repeat
                            TotalPayments += FsReaningCodeRecL."Earning Code Amount";
                        until FsReaningCodeRecL.Next() = 0;

                    FsReaningCodeRec2L.Reset();
                    FsReaningCodeRec2L.SetRange("Journal ID", "Journal ID");
                    FsReaningCodeRec2L.SetRange("Employee No.", "Employee No.");
                    FsReaningCodeRec2L.SetFilter("Earning Code Amount", '<%1', 0);
                    FsReaningCodeRec2L.SetRange("Pay Period Start", "Pay Period Start");
                    if FsReaningCodeRec2L.FindSet() then
                        repeat
                            TotalDeductions += FsReaningCodeRec2L."Earning Code Amount";
                        until FsReaningCodeRec2L.Next() = 0;

                    if "Earning Code Amount" > 0 then
                        LineEarningG := "Earning Code Amount"
                    else
                        LineDudG := "Earning Code Amount";

                    if (DATE2DMY("Pay Period Start", 2) = DATE2DMY("Full and Final Calculation"."Termination Date", 2)) then begin
                        Clear(StartEndCountG);
                        StartEndCountG := ("Full and Final Calculation"."Termination Date" - "Pay Period Start") + 1;
                    end else begin
                        Clear(StartEndCountG);
                        StartEndCountG := ("Pay Period End" - "Pay Period Start") + 1;
                    end;
                end;
            }

            dataitem(EmployeeEarningCodeOnly; "FS - Earning Code")
            {
                DataItemLink = "Employee No." = FIELD("Employee No."), "Journal ID" = field("Journal ID");
                DataItemTableView = sorting("Pay Period Start") where("Earning Code Amount" = filter(<> 0), "Final Settlement Component" = const(true));
                column(Earning_Description_EOS; "Earning Description") { }
                column(Earning_Code_Amount_EOS; "Earning Code Amount") { }
            }

            trigger OnAfterGetRecord();
            begin
                CountryRegRecG.Reset();
                if CountryRegRecG.Get(CompanyInformation."Country/Region Code") then;

                EmployeeBacnkDetailsRecG.Reset();
                EmployeeBacnkDetailsRecG.SetRange("Employee Id", "Employee No.");
                EmployeeBacnkDetailsRecG.SetRange(Primary, true);
                if EmployeeBacnkDetailsRecG.FindFirst() then;
                Clear(FSLoanEMIAmountG);
                FSLoanRec.Reset();
                FSLoanRec.SetRange("Employee No.", "Employee No.");
                FSLoanRec.SetRange("Journal ID", "Journal ID");
                if FSLoanRec.FindSet() then
                    repeat
                        FSLoanEMIAmountG += FSLoanRec."EMI Amount";
                    until FSLoanRec.Next() = 0;

                TotalAmountForWordG := Round(("Payroll Amount" + "Indemnity/Gratuity Amount" + "Loan Recovery" + "Leave Encashment"), 1, '>');
                CheckReportG.InitTextVariable();
                CheckReportG.FormatNoText(AmountInWord, TotalAmountForWordG, Currency);
            end;
        }
    }
    trigger OnPreReport();
    begin
        if CompanyInformation.GET() then
            CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        PayCyclePayPeriod: Text;
        PayYear: Integer;
        PayMonth: Code[50];
        PayrollStatementLinesPosTemp: Record "Payroll Statement Lines" temporary;
        PayrollStatementLinesNegTemp: Record "Payroll Statement Lines" temporary;
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
        Currency: Record Currency;
        TotalDeductions: Decimal;
        TotalPayments: Decimal;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        NetPaymentinSAR: Decimal;
        PayCycle: Code[50];
        PayPeriodCode: Code[50];
        PayPeriod: Record "Pay Periods";
        ValueDate: Code[50];
        PeriodStartDateG: Date;
        PeriodEndDateG: Date;
        EmployeeBankAccountRecG: Record "Employee Bank Account";
        CountryRegRecG: Record "Country/Region";
        EmployeeBacnkDetailsRecG: Record "Employee Bank Account";
        LoanTypeSetupRecG: Record "Loan Type Setup";
        FSLoanRec: Record "FS Loans";
        FSLoanEMIAmountG: Decimal;
        LineDudG: Decimal;
        LineEarningG: Decimal;
        CheckReportG: Codeunit "Amount In Words Seconds";
        AmountInWord: array[2] of Text[250];
        TotalAmountForWordG: Decimal;
        StartEndCountG: Integer;


    procedure GetEmployeeDesignation(EmployeeNo: Code[20]): Text
    var
        PayrollJobPosWorkerAssignRecG: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRecG: Record "Payroll Position";
    begin
        PayrollJobPosWorkerAssignRecG.Reset();
        PayrollJobPosWorkerAssignRecG.SetRange(Worker, EmployeeNo);
        PayrollJobPosWorkerAssignRecG.SetRange("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRecG.FindFirst() then begin
            PayrollPositionRecG.Reset();
            PayrollPositionRecG.SetRange("Position ID", PayrollJobPosWorkerAssignRecG."Position ID");
            if PayrollPositionRecG.FindFirst() then
                exit(PayrollPositionRecG.Description);
        end;
    end;

    procedure TerminationReason(EmpID: Code[20]): Text
    var
        EmployeeRecL: Record Employee;
        SeperationMasterRecL: Record "Seperation Master";
    begin
        EmployeeRecL.Reset();
        if EmployeeRecL.Get(EmpID) then begin
            SeperationMasterRecL.Reset();
            SeperationMasterRecL.SetRange("Seperation Code", EmployeeRecL."Seperation Reason");
            if SeperationMasterRecL.FindFirst() then
                exit(SeperationMasterRecL."Seperation Reason");
        end;
    end;
}