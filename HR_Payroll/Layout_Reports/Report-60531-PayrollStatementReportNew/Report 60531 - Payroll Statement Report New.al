report 60531 "Payroll Statement Report New"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'HR_Payroll\Layout_Reports\Report-60531-PayrollStatementReportNew\payrollstatementreport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(EmpNo; Employee."No.") { }
            column(EmpFullName; Employee."First Name" + '  ' + Employee."Middle Name" + '  ' + Employee."Last Name") { }
            column(CompName; CompInfo.Name) { }
            column(CompanyImage; CompInfo.Picture) { }
            column(BasicSalaryCaption; BasicSalaryCaption) { }
            column(CostOfAllowCaption; CostOfAllowCaption) { }
            column(ErsNoCaption; ErsNoCaption) { }
            column(EmpNameCaption; EmpNameCaption) { }
            column(GrdStep; GrdStep) { }
            column(GradeStepCaption; GradeStepCaption) { }
            column(Designation_LT; GetPayrollPositionDesc_LT(Employee."No.")) { }
            column(Departments_LT; GetPayrollPositionDepartments_LT(Employee."No.")) { }
            column(JoiningDate_Employee_LT; Employee."Joining Date") { }
            column(TerminationDate_Employee_LT; Employee."Termination Date") { }
            dataitem(PayrollStatementLines; "Payroll Statement Lines")
            {
                DataItemLink = "Payroll Statment Employee" = FIELD("No.");
                DataItemTableView = SORTING("Payroll Statement ID", "Payroll Statment Employee", "Line No.");
                column(CostOfAllowance; CostOfAllowance) { }
                column(EarningCodeDesc; PayrollStatementLines."Payroll Earning Code Desc") { }
                column(EmpNoLines; PayrollStatementLines."Payroll Statment Employee") { }
                column(SerialNo; SerialNo) { }
                column(BasicSalary; BasicSalary) { }
                column(CurrencyCode_PayrollStatementLines; PayrollStatementLines."Currency Code") { }
                column(EarnCode; PayrollStatementLines."Earniing Code Short Name") { }
                column(EarningCodeAmount; PayrollStatementLines."Earning Code Amount") { }
                column(TotalDeductions; TotalDeductions) { }
                column(TotalCostOfAllowance; TotalCostOfAllowance) { }
                column(TotalBasicSalary; TotalBasicSalary) { }
                column(GrandTotalEmoulments; GrandTotalEmoulments) { }
                column(GrandTotalDeductions; GrandTotalDeductions) { }
                column(TotalPayment_LT; GrandTotalEmoulments + GrandTotalDeductions) { }
                column(PaymentInSAR; PaymentInSAR) { }
                column(TotalPaymentInSAR; TotalPaymentInSAR) { }
                column(TotalEmoulmants; TotalEmoulments) { }
                column(LumpsumDecG; LumpsumDecG) { }

                trigger OnAfterGetRecord();
                begin
                    CLEAR(BasicSalary);
                    if PayrollStatementLines."Earniing Code Short Name" = 'BS' then
                        BasicSalary := PayrollStatementLines."Earning Code Amount";

                    CLEAR(CostOfAllowance);
                    if PayrollStatementLines."Earniing Code Short Name" = 'COL' then
                        CostOfAllowance := PayrollStatementLines."Earning Code Amount";

                    TotalBasicSalary += BasicSalary;
                    CLEAR(LumpsumDecG);
                    if PayrollStatementLines."Earniing Code Short Name" = 'LA' then
                        LumpsumDecG := PayrollStatementLines."Earning Code Amount";

                end;

                trigger OnPreDataItem();
                begin
                    BasicSalary := 0;
                    CostOfAllowance := 0;
                    PayrollStatementLines.SETRANGE("Payroll Pay Cycle", PayCycle);
                    PayrollStatementLines.SETRANGE("Payroll Month", FORMAT(PayMonth));
                    PayrollStatementLines.SETRANGE("Payroll Year", PayYear);
                    PayrollStatementLines.SETRANGE("Payroll Statement ID", PayrollStatementID);
                end;
            }
            dataitem("Employee Bank Account"; "Employee Bank Account")
            {
                DataItemLink = "Employee Id" = FIELD("No.");
                DataItemTableView = WHERE(Primary = FILTER(true));
                column(BankAccountNumber; "Employee Bank Account"."Bank Acccount Number")
                {
                }
                column(BankName; "Employee Bank Account"."Bank Name")
                {
                }
                column(IBANNumber; "Employee Bank Account".IBAN)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                GrdStep := '';
                TotalDeductions := 0;
                TotalEmoulments := 0;

                SerialNo += 1;

                PayrollStatementRec.RESET;
                PayrollStatementRec.SETRANGE("Payroll Statment Employee", Employee."No.");
                PayrollStatementRec.SETRANGE("Payroll Pay Cycle", PayCycle);
                PayrollStatementRec.SETRANGE("Payroll Month", FORMAT(PayMonth));
                PayrollStatementRec.SETRANGE("Payroll Year", PayYear);
                PayrollStatementRec.SETRANGE("Payroll Statement ID", PayrollStatementID);
                if not PayrollStatementRec.FINDFIRST then
                    CurrReport.SKIP
                else
                    PayrollStatementRec.SETRANGE("Earniing Code Short Name", 'COL');
                if PayrollStatementRec.FINDFIRST then
                    CostOfAllowance := PayrollStatementRec."Earning Code Amount";
                PayrollStatementRec.SETRANGE("Earniing Code Short Name");
                PayrollStatementRec.SETFILTER("Earning Code Amount", '>%1', 0);
                if PayrollStatementRec.FINDSET then
                    repeat
                        TotalEmoulments := TotalEmoulments + PayrollStatementRec."Earning Code Amount";
                    until PayrollStatementRec.NEXT = 0;

                PayrollStatementRec.SETRANGE("Earning Code Amount");
                PayrollStatementRec.SETFILTER("Earning Code Amount", '<%1', 0);
                if PayrollStatementRec.FINDSET then
                    repeat
                        TotalDeductions += PayrollStatementRec."Earning Code Amount";
                    until PayrollStatementRec.NEXT = 0;

                PaymentInSAR := CurrencyExchangeRate.ExchangeAmount(TotalEmoulments + TotalDeductions, 'USD', '', 0D);

                GrandTotalDeductions += TotalDeductions;
                GrandTotalEmoulments += TotalEmoulments;
                TotalCostOfAllowance += CostOfAllowance;
                TotalPaymentInSAR += PaymentInSAR;
            end;

            trigger OnPreDataItem();
            begin
                GrandTotalEmoulments := 0;
                GrandTotalDeductions := 0;
                TotalBasicSalary := 0;
                TotalCostOfAllowance := 0;
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
                        PayPeriodRec.RESET;
                        PayPeriodRec.SETRANGE("Pay Cycle", PayCycle);
                        if PAGE.RUNMODAL(PAGE::"Pay Periods List", PayPeriodRec) = ACTION::LookupOK then begin
                            PayPeriodCode := PayPeriodRec.Month + ' ' + FORMAT(PayPeriodRec.Year);
                            PayMonth := PayPeriodRec.Month;
                            PayYear := PayPeriodRec.Year;
                            PayPeriodStartDate := PayPeriodRec."Period Start Date";
                            PayPeriodEndDate := PayPeriodRec."Period End Date";
                        end;
                    end;
                }
                field("Payroll Statement ID"; PayrollStatementID)
                {
                    ApplicationArea = All;
                    TableRelation = "Payroll Statement"."Payroll Statement ID";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if PayCycle = '' then
                            ERROR('Please select Pay Cycle');

                        if PayPeriodCode = '' then
                            ERROR('Please select Pay Period');

                        PayrollStatement.RESET;
                        PayrollStatement.FILTERGROUP(2);
                        PayrollStatement.SETRANGE("Pay Cycle", PayCycle);
                        PayrollStatement.SETRANGE("Pay Period Start Date", PayPeriodStartDate);
                        PayrollStatement.SETRANGE("Pay Period End Date", PayPeriodEndDate);
                        PayrollStatement.FILTERGROUP(0);
                        if PAGE.RUNMODAL(PAGE::"Payroll Statements", PayrollStatement) = ACTION::LookupOK then begin
                            PayrollStatementID := PayrollStatement."Payroll Statement ID";
                        end;
                    end;
                }
            }
        }
    }

    trigger OnPreReport();
    begin
        if CompInfo.GET then;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        LumpsumDecG: Decimal;
        PayMonth: Code[20];
        PayYear: Integer;
        PayCycle: Code[50];
        PayPeriodRec: Record "Pay Periods";
        PayrollStatementID: Code[20];
        BasicSalaryCaption: Label 'BASIC SALARY';
        CostOfAllowCaption: Label 'COST OF L. ALLOWANCE';
        ErsNoCaption: Label 'ERS NO';
        EmpNameCaption: Label 'NAME';
        GradeStepCaption: Label 'GRADE / STEP';
        BasicSalary: Decimal;
        CostOfAllowance: Decimal;
        CompInfo: Record "Company Information";
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
        GrdStep: Code[20];
        SerialNo: Integer;
        TotalEmoulments: Decimal;
        FinalCostOfAllowance: Decimal;
        PayrollStatementRec: Record "Payroll Statement Lines";
        TotalDeductions: Decimal;
        PayPeriodCode: Code[50];
        TotalBasicSalary: Decimal;
        TotalCostOfAllowance: Decimal;
        GrandTotalEmoulments: Decimal;
        GrandTotalDeductions: Decimal;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        PaymentInSAR: Decimal;
        TotalPaymentInSAR: Decimal;
        PayrollStatement: Record "Payroll Statement";
        PayPeriodStartDate: Date;
        PayPeriodEndDate: Date;

    procedure SetData(PayCycle_P: Code[150]; PayPeriodCode_P: Code[150]; PayrollStatementID_P: Code[150]; PaySDate_P: Date; PayEDae_P: Date);
    begin
        PayCycle := PayCycle_P;

        PayPeriodRec.RESET;
        PayPeriodRec.SETRANGE("Pay Cycle", PayCycle_P);
        PayPeriodRec.SETRANGE("Period Start Date", PaySDate_P);
        PayPeriodRec.SETRANGE("Period End Date", PayEDae_P);
        if PayPeriodRec.FINDFIRST then begin
            PayPeriodCode := PayPeriodRec.Month + ' ' + FORMAT(PayPeriodRec.Year);
            PayMonth := PayPeriodRec.Month;
            PayYear := PayPeriodRec.Year;
            PayPeriodStartDate := PayPeriodRec."Period Start Date";
            PayPeriodEndDate := PayPeriodRec."Period End Date";
        end;
        PayrollStatementID := PayrollStatementID_P;
    end;

    local procedure GetPayrollPositionDesc_LT(EmpCode: Code[20]): Text;
    var
        PayrollPositionRecL: Record "Payroll Position";
        PayrollJobPosWorkerAssignRecL: Record "Payroll Job Pos. Worker Assign";
    begin
        PayrollJobPosWorkerAssignRecL.RESET;
        PayrollJobPosWorkerAssignRecL.SETRANGE(Worker, EmpCode);
        PayrollJobPosWorkerAssignRecL.SETRANGE("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRecL.FINDFIRST then begin
            PayrollPositionRecL.RESET;
            PayrollPositionRecL.SETRANGE("Position ID", PayrollJobPosWorkerAssignRecL."Position ID");
            if PayrollPositionRecL.FINDFIRST then
                exit(PayrollPositionRecL.Description);
        end;
    end;

    local procedure GetPayrollPositionDepartments_LT(EmpCode: Code[20]): Text;
    var
        PayrollPositionRecL: Record "Payroll Position";
        PayrollJobPosWorkerAssignRecL: Record "Payroll Job Pos. Worker Assign";
        PayrollDepartment: Record "Payroll Department";
    begin
        PayrollJobPosWorkerAssignRecL.RESET;
        PayrollJobPosWorkerAssignRecL.SETRANGE(Worker, EmpCode);
        PayrollJobPosWorkerAssignRecL.SETRANGE("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRecL.FINDFIRST then begin
            PayrollPositionRecL.RESET;
            PayrollPositionRecL.SETRANGE("Position ID", PayrollJobPosWorkerAssignRecL."Position ID");
            if PayrollPositionRecL.FINDFIRST then begin
                PayrollDepartment.RESET;
                PayrollDepartment.SETRANGE("Department ID", PayrollPositionRecL.Department);
                if PayrollDepartment.FINDFIRST then
                    exit(PayrollDepartment.Description);
            end;
        end;
    end;
}