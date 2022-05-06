report 60534 "DME Payslip"
{
    Caption = 'DME Payslip';
    DefaultLayout = RDLC;
    // RDLCLayout = 'Payslip.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(CompanyInformation_Logo; CompanyInformation.Picture) { }
            column(CompanyInformation_Name; CompanyInformation.Name) { }
            column(CompanyInformation_address; CompanyInformation.Address) { }
            column(CompanyInformation_Address2; CompanyInformation."Address 2") { }
            column(CompanyInformation_PostalCode; CompanyInformation."Post Code") { }
            column(CountryRegRecG_Country; CountryRegRecG.Name) { }
            column(PayPeriodCode; PayPeriodCode) { }
            column(No_; "No.") { }
            column(FullName; FullName) { }
            column(GetEmployeeDesignation_; GetEmployeeDesignation("No.")) { }
            column(Joining_Date; FORMAT("Joining Date", 0, '<Day,2>-<Month Text>-<Year4>')) { }
            column(Currency_Code; Currency.Code) { }
            column(BankAccountNumber1; EmployeeBacnkDetailsRecG."Bank Acccount Number") { }
            column(BankName; EmployeeBacnkDetailsRecG."Bank Name") { }
            column(IBAN_EmployeeBankAccount; EmployeeBacnkDetailsRecG.IBAN) { }
            column(AnnualLeaveBalance; GetEmployeeAnnualLeaveBalance("No.")) { }
            column(LOP; Get_LOP_Balance("No.")) { }

            dataitem(PayrollStatementLines; "Payroll Statement Lines")
            {
                DataItemLink = "Payroll Statment Employee" = FIELD("No.");
                DataItemTableView = SORTING("Payroll Statement ID", "Payroll Statment Employee", "Line No.");
                column(Payroll_Statement_ID; "Payroll Statement ID") { }
                column(Payroll_Earning_Code_Desc; "Payroll Earning Code Desc") { }
                column(Earning_Code_Amount; "Earning Code Amount") { }
                column(PayrollEmployeeID; PayrollStatementLines."Payroll Statment Employee") { }
                column(PayrollEmployeeID_Worker; PayrollStatementLines.Worker) { }
                column(TotalDeductions_; TotalDeductions) { }
                column(TotalPayments_; TotalPayments) { }
                column(NetPaymentinSAR_; NetPaymentinSAR) { }
                column(Currency_Code_Line; GetEmployeeCurrencyCode(Worker, "Payroll Statement ID")) { }

                trigger OnPreDataItem();
                begin
                    TotalDeductions := 0;
                    TotalPayments := 0;
                    NetPaymentinSAR := 0;
                    PayrollStatementLines.SETRANGE("Payroll Pay Cycle", PayCycle);
                    PayrollStatementLines.SETRANGE("Payroll Month", FORMAT(PayMonth));
                    PayrollStatementLines.SETRANGE("Payroll Year", PayYear);
                end;

                trigger OnAfterGetRecord();
                begin
                    if PayrollStatementLines."Earning Code Amount" < 0 then
                        TotalDeductions += PayrollStatementLines."Earning Code Amount"
                    else
                        TotalPayments += PayrollStatementLines."Earning Code Amount";

                    NetPaymentinSAR := CurrencyExchangeRate.ExchangeAmount((TotalPayments + TotalDeductions), Currency.Code, PayrollStatementLines."Currency Code", TODAY);
                end;
            }
            dataitem("Employee Bank Account"; "Employee Bank Account")
            {
                DataItemLink = "Employee Id" = FIELD("No.");
                DataItemTableView = SORTING("Employee Id", "Bank Code", "Bank Acccount Number") WHERE(Primary = FILTER(true));
                column(BankNameinArabic_EmployeeBankAccount1; "Employee Bank Account"."Bank Name in Arabic") { }
            }

            trigger OnPreDataItem();
            begin
                PayCyclePayPeriod := FORMAT(PayYear);
            end;

            trigger OnAfterGetRecord();
            begin
                CountryRegRecG.Reset();
                if CountryRegRecG.Get(CompanyInformation."Country/Region Code") then;

                EmployeeBacnkDetailsRecG.Reset();
                EmployeeBacnkDetailsRecG.SetRange("Employee Id", "No.");
                EmployeeBacnkDetailsRecG.SetRange(Primary, true);
                if EmployeeBacnkDetailsRecG.FindFirst() then;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Pay Cycle"; PayCycle)
                {
                    TableRelation = "Pay Cycles"."Pay Cycle";
                    ApplicationArea = All;
                }
                field("Pay Period"; PayPeriodCode)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PayPeriod.RESET;
                        PayPeriod.SETRANGE("Pay Cycle", PayCycle);
                        PayPeriod.SetRange("Enable Payroll Statements", true);
                        if PAGE.RUNMODAL(PAGE::"Pay Periods List", PayPeriod) = ACTION::LookupOK then begin
                            PayPeriodCode := PayPeriod.Month + ' ' + FORMAT(PayPeriod.Year);
                            PayMonth := PayPeriod.Month;
                            PayYear := PayPeriod.Year;
                            PeriodStartDateG := PayPeriod."Period Start Date";
                            PeriodEndDateG := PayPeriod."Period End Date";
                        end;
                    end;
                }
            }
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

    procedure GetEmployeeCurrencyCode(EmployeeNo: Code[20]; StateID: Code[20]): Code[150]
    var
        PayrollStatEmployeeRecL: Record "Payroll Statement Employee";
    begin
        PayrollStatEmployeeRecL.Reset();
        PayrollStatEmployeeRecL.SetRange("Payroll Statement ID", StateID);
        PayrollStatEmployeeRecL.SetRange(Worker, EmployeeNo);
        if PayrollStatEmployeeRecL.FindFirst() then
            exit(PayrollStatEmployeeRecL."Currency Code");
    end;

    procedure GetEmployeeAnnualLeaveBalance(Employee_P: Code[20]): Decimal
    var
        EmployeeErnCodeGrpRecL: Record "Employee Earning Code Groups";
        HCMLeaveTypeWrkrRecL: Record "HCM Leave Types Wrkr";
        AccuralComponentEmployeeRecL: Record "Accrual Components";
        EmplIntrimAccRecL: Record "Employee Interim Accurals";
    begin
        EmployeeErnCodeGrpRecL.Reset();
        EmployeeErnCodeGrpRecL.SetRange("Employee Code", Employee_P);
        EmployeeErnCodeGrpRecL.SetFilter("Valid To", '%1', 0D);
        if EmployeeErnCodeGrpRecL.FindFirst() then begin
            HCMLeaveTypeWrkrRecL.Reset();
            HCMLeaveTypeWrkrRecL.SetRange(Accrued, true);
            HCMLeaveTypeWrkrRecL.SetRange(Worker, Employee_P);
            HCMLeaveTypeWrkrRecL.SetRange("Earning Code Group", EmployeeErnCodeGrpRecL."Earning Code Group");
            if HCMLeaveTypeWrkrRecL.FindFirst() then begin
                AccuralComponentEmployeeRecL.Reset();
                AccuralComponentEmployeeRecL.SetRange("Accrual ID", HCMLeaveTypeWrkrRecL."Accrual ID");
                if AccuralComponentEmployeeRecL.FindFirst() then begin
                    EmplIntrimAccRecL.Reset();
                    EmplIntrimAccRecL.SetRange("Accrual ID", AccuralComponentEmployeeRecL."Accrual ID");
                    EmplIntrimAccRecL.SetRange("Start Date", PeriodStartDateG);
                    if EmplIntrimAccRecL.FindFirst() then
                        exit(EmplIntrimAccRecL."Closing Balance");
                end;
            end;
        end;
    end;

    procedure Get_LOP_Balance(Employee_P: Code[20]): Decimal
    var
        EmployeeErnCodeGrpRecL: Record "Employee Earning Code Groups";
        HCMLeaveTypeWrkrRecL: Record "HCM Leave Types Wrkr";
        AccuralComponentEmployeeRecL: Record "Accrual Components";
        EmplIntrimAccRecL: Record "Employee Interim Accurals";
        WorkCalcRecL: Record EmployeeWorkDate_GCC;
        FirstHalfL: Decimal;
        SecondHalf: Decimal;
    begin
        EmployeeErnCodeGrpRecL.Reset();
        EmployeeErnCodeGrpRecL.SetRange("Employee Code", Employee_P);
        EmployeeErnCodeGrpRecL.SetFilter("Valid To", '%1', 0D);
        if EmployeeErnCodeGrpRecL.FindFirst() then begin
            HCMLeaveTypeWrkrRecL.Reset();
            HCMLeaveTypeWrkrRecL.SetRange("Pay Type", HCMLeaveTypeWrkrRecL."Pay Type"::UnPaid);
            HCMLeaveTypeWrkrRecL.SetRange(Worker, Employee_P);
            HCMLeaveTypeWrkrRecL.SetRange("Earning Code Group", EmployeeErnCodeGrpRecL."Earning Code Group");
            if HCMLeaveTypeWrkrRecL.FindFirst() then begin
                Clear(FirstHalfL);
                WorkCalcRecL.Reset();
                WorkCalcRecL.SetRange("First Half Leave Type", HCMLeaveTypeWrkrRecL."Leave Type Id");
                WorkCalcRecL.SetFilter("Trans Date", '%1..%2', PeriodStartDateG, PeriodEndDateG);
                if WorkCalcRecL.FindSet() then begin
                    FirstHalfL := WorkCalcRecL.Count();
                end;
                Clear(SecondHalf);
                WorkCalcRecL.Reset();
                WorkCalcRecL.SetRange("Second Half Leave Type", HCMLeaveTypeWrkrRecL."Leave Type Id");
                WorkCalcRecL.SetFilter("Trans Date", '%1..%2', PeriodStartDateG, PeriodEndDateG);
                if WorkCalcRecL.FindSet() then begin
                    SecondHalf := WorkCalcRecL.Count();
                end;
                FirstHalfL := FirstHalfL / 2;
                SecondHalf := SecondHalf / 2;
            end;
        end;
        exit((FirstHalfL + SecondHalf));
    end;

    procedure SetVal(PayPeriodCode_P: Code[50]; PayMonth_P: Code[50]; PayYear_P: Integer; PeriodStartDateG_P: Date; PeriodEndDateG_P: Date; PayCycle_P: Code[50])
    begin
        PayPeriodCode := PayPeriodCode_P;
        PayMonth := PayMonth_P;
        PayYear := PayYear_P;
        PeriodStartDateG := PeriodStartDateG_P;
        PeriodEndDateG := PeriodEndDateG_P;
        PayCycle := PayCycle_P;
    end;
}