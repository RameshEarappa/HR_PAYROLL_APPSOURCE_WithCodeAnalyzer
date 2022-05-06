report 60040 "Payroll Variance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'HR_Payroll\Layout_Reports\Report-60040-PayrollVarianceReport\PayrollVarianceReport.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(EmpNo; Employee."No.")
            {
            }
            column(EmpFullName; Employee."First Name" + Employee."Middle Name" + Employee."Last Name")
            {
            }
            column(EmpDepart; Employee.Department)
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(CompLogo; CompInfo.Picture)
            {
            }
            column(ReportCaption; ReportCaption)
            {
            }
            column(EmpIDCaption; EmpIDCaption)
            {
            }
            column(EmpNameCaption; EmpNameCaption)
            {
            }
            column(DeptCaption; DeptCaption)
            {
            }
            column(BasicCaption; BasicCaption)
            {
            }
            column(OtherAllowCaption; OtherAllowCaption)
            {
            }
            column(OtherEarningCaption; OtherEarningCaption)
            {
            }
            column(DedcutCaption; DedcutCaption)
            {
            }
            column(NetPayCaption; NetPayCaption)
            {
            }
            column(VarianceCaption; VarianceCaption)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(BasicAmountCurrentMonth; BasicAmountCurrentMonth)
                {
                }
                column(BasicAmountCompareMonth; BasicAmountCompareMonth)
                {
                }
                column(DeductionsCompareMonth; DeductionsCompareMonth)
                {
                }
                column(DeductionsCurrentMonth; DeductionsCurrentMonth)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    BasicAmountCompareMonth := 0;
                    BasicAmountCurrentMonth := 0;
                    DeductionsCompareMonth := 0;
                    DeductionsCurrentMonth := 0;
                    PayrollStatementLineCurrentMonth.RESET;
                    PayrollStatementLineCurrentMonth.SETRANGE("Payroll Statment Employee", Employee."No.");
                    PayrollStatementLineCurrentMonth.SETRANGE("Payroll Pay Cycle", PayCycle);
                    PayrollStatementLineCurrentMonth.SETRANGE("Payroll Year", CurrentPayrollPeriodYear);
                    PayrollStatementLineCurrentMonth.SETRANGE("Payroll Month", CurrentPayrollPeriodMonth);
                    if PayrollStatementLineCurrentMonth.FINDSET then
                        repeat
                            if PayrollStatementLineCurrentMonth."Earniing Code Short Name" = 'BS' then
                                BasicAmountCurrentMonth := PayrollStatementLineCurrentMonth."Earning Code Amount";
                            if PayrollStatementLineCurrentMonth."Earning Code Amount" < 0 then
                                DeductionsCurrentMonth += PayrollStatementLineCurrentMonth."Earning Code Amount";
                        until PayrollStatementLineCurrentMonth.NEXT = 0;

                    PayrollStatementLineCurrentMonth.SETRANGE("Payroll Year");
                    PayrollStatementLineCurrentMonth.SETRANGE("Payroll Month");
                    PayrollStatementLineCurrentMonth.SETRANGE("Payroll Year", ComparePayrollPeriodYear);
                    PayrollStatementLineCurrentMonth.SETRANGE("Payroll Month", ComparePayrollPeriodMonth);
                    if PayrollStatementLineCurrentMonth.FINDSET then
                        repeat
                            if PayrollStatementLineCurrentMonth."Earniing Code Short Name" = 'BS' then
                                BasicAmountCompareMonth := PayrollStatementLineCurrentMonth."Earning Code Amount";
                            if PayrollStatementLineCurrentMonth."Earning Code Amount" < 0 then
                                DeductionsCompareMonth += PayrollStatementLineCurrentMonth."Earning Code Amount";
                        until PayrollStatementLineCurrentMonth.NEXT = 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                PayrollStatementLineCurrentMonth.RESET;
                PayrollStatementLineCurrentMonth.SETRANGE("Payroll Statment Employee", Employee."No.");
                PayrollStatementLineCurrentMonth.SETRANGE("Payroll Pay Cycle", PayCycle);
                PayrollStatementLineCurrentMonth.SETRANGE("Payroll Year", CurrentPayrollPeriodYear);
                PayrollStatementLineCurrentMonth.SETRANGE("Payroll Month", CurrentPayrollPeriodMonth);
                if not PayrollStatementLineCurrentMonth.FINDFIRST then
                    CurrReport.SKIP;
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
                field("Current Pay Period"; CurrentPayPeriod)
                {

                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PayPeriod.RESET;
                        PayPeriod.SETRANGE("Pay Cycle", PayCycle);
                        if PAGE.RUNMODAL(PAGE::"Pay Periods List", PayPeriod) = ACTION::LookupOK then begin
                            CurrentPayPeriod := PayPeriod.Month + ' ' + FORMAT(PayPeriod.Year);
                            CurrentPayrollPeriodMonth := PayPeriod.Month;
                            CurrentPayrollPeriodYear := PayPeriod.Year;
                        end;
                    end;
                }
                field("Compare With Pay Period"; CompareWithPayPeriod)
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PayPeriod.RESET;
                        PayPeriod.SETRANGE("Pay Cycle", PayCycle);
                        if PAGE.RUNMODAL(PAGE::"Pay Periods List", PayPeriod) = ACTION::LookupOK then begin
                            CompareWithPayPeriod := PayPeriod.Month + ' ' + FORMAT(PayPeriod.Year);
                            ComparePayrollPeriodMonth := PayPeriod.Month;
                            ComparePayrollPeriodYear := PayPeriod.Year;
                        end;
                    end;
                }
            }
        }
    }


    trigger OnPreReport();
    begin
        if CompInfo.GET then
            CompInfo.CALCFIELDS(CompInfo.Picture);
    end;

    var
        CompInfo: Record "Company Information";
        ReportCaption: Label 'Payroll variance report';
        EmpIDCaption: Label 'Emp ID';
        EmpNameCaption: Label 'Employee Name';
        DeptCaption: Label 'Department';
        BasicCaption: Label 'Basic';
        OtherAllowCaption: Label 'Other allowance';
        OtherEarningCaption: Label 'Other earnings';
        DedcutCaption: Label 'Deductions';
        NetPayCaption: Label 'Net pay';
        VarianceCaption: Label 'Variance';
        CurrentPayPeriod: Code[50];
        CompareWithPayPeriod: Code[50];
        PayCycle: Code[10];
        PayPeriod: Record "Pay Periods";
        CurrentPayrollPeriodYear: Integer;
        CurrentPayrollPeriodMonth: Code[10];
        ComparePayrollPeriodYear: Integer;
        ComparePayrollPeriodMonth: Code[10];
        DateRec: Record Date;
        OtherAllowances: Decimal;
        OtherEarnings: Decimal;
        DeductionsCurrentMonth: Decimal;
        NetPay: Decimal;
        Variance: Decimal;
        BasicAmountCurrentMonth: Decimal;
        PayrollStatementLineCurrentMonth: Record "Payroll Statement Lines";
        PayrollStatementLineCompareMonth: Record "Payroll Statement Lines";
        BasicAmountCompareMonth: Decimal;
        DeductionsCompareMonth: Decimal;
}