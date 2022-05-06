report 60537 "Salary Update File New"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = TRUE;
    UseRequestPage = false;

    dataset
    {
        dataitem(PayrollStatementEmployee; "Payroll Statement Employee")
        {
            trigger OnAfterGetRecord()
            var
                EmployeeRecL: Record Employee;
                EmployeeBackAccountRecG: Record "Employee Bank Account";
                PayrollStatementRecL: Record "Payroll Statement";
            begin
                if SumOfEarningCodeAmount(PayrollStatementEmployee) < 0 then
                    CurrReport.Skip();

                EmployeeRecL.Reset();
                EmployeeRecL.SetRange("No.", PayrollStatementEmployee.Worker);
                if EmployeeRecL.FindFirst() then;

                EmployeeBackAccountRecG.Reset();
                EmployeeBackAccountRecG.SetRange("Employee Id", PayrollStatementEmployee.Worker);
                EmployeeBackAccountRecG.SetRange(Primary, true);
                if EmployeeBackAccountRecG.FindFirst() then;

                PayrollStatementRecL.Reset();
                PayrollStatementRecL.SetRange("Pay Cycle", PayrollStatementEmployee."Payroll Pay Cycle");
                PayrollStatementRecL.SetRange("Pay Period Start Date", PayrollStatementEmployee."Pay Period Start Date");
                PayrollStatementRecL.SetRange("Pay Period End Date", PayrollStatementEmployee."Pay Period End Date");
                PayrollStatementRecL.SetRange("Payroll Statement ID", PayrollStatementEmployee."Payroll Statement ID");
                if PayrollStatementRecL.FindFirst() then;

                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn(Format(EmployeeBackAccountRecG."Routing Number"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EmployeeRecL.FullName(), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PayrollStatementEmployee."Currency Code", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EmployeeBackAccountRecG.IBAN, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(EmployeeBackAccountRecG."Bank Code", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PayrollStatementRecL."Payroll Statement Description", false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Format(SumOfEarningCodeAmount(PayrollStatementEmployee)), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('SAL', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('/REF/', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
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
    trigger OnInitReport()
    begin
        ExcelBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    begin
        ExcelBuffer.CreateNewBook('Salary Update Files');
        ExcelBuffer.WriteSheet('Salary Update Files', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.OpenExcel();
    end;

    VAR
        ExcelBuffer: Record "Excel Buffer" temporary;
        PayrollStatement: Record "Payroll Statement";
        PayMonth: Code[20];
        PayYear: Integer;
        PayCycle: Code[50];
        PayPeriodRec: Record "Pay Periods";
        PayrollStatementID: Code[20];
        PayPeriodCode: Code[50];
        PayPeriodStartDate: Date;
        PayPeriodEndDate: Date;
        NextRowNo: Integer;

    procedure SumOfEarningCodeAmount(PayrollStatementEmployee: Record "Payroll Statement Employee"): Decimal
    var
        PayrollStatementRec: Record "Payroll Statement Lines";
        EarningAmountDecL: Decimal;
    begin
        Clear(EarningAmountDecL);
        PayrollStatementRec.RESET;
        PayrollStatementRec.SETRANGE("Payroll Statment Employee", PayrollStatementEmployee.Worker);
        PayrollStatementRec.SETRANGE("Payroll Pay Cycle", PayrollStatementEmployee."Payroll Pay Cycle");
        PayrollStatementRec.SETRANGE("Payroll Statement ID", PayrollStatementEmployee."Payroll Statement ID");
        if PayrollStatementRec.FindSet() then
            repeat
                EarningAmountDecL += PayrollStatementRec."Earning Code Amount";
            until PayrollStatementRec.Next() = 0;
        exit(EarningAmountDecL);
    end;
}