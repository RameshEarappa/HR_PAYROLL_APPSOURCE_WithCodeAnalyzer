page 70120 "Excel Report Filter"
{
    Caption = 'SD Salary Update File';
    ApplicationArea = All;
    PageType = StandardDialog;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group("Report Filter")
            {
                field("Pay Cycle"; "Pay Cycle")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PayCycleRecG: Record "Pay Cycles";
                    begin
                        PayCycleRecG.RESET;
                        if PAGE.RUNMODAL(PAGE::"Pay Cycles", PayCycleRecG) = ACTION::LookupOK then begin
                            "Pay Cycle" := PayCycleRecG."Pay Cycle";
                        end;
                    end;
                }
                field("Pay Period"; "Pay Period")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PayPeriodRec.RESET;
                        PayPeriodRec.SETRANGE("Pay Cycle", "Pay Cycle");
                        if PAGE.RUNMODAL(PAGE::"Pay Periods List", PayPeriodRec) = ACTION::LookupOK then begin
                            "Pay Period" := PayPeriodRec.Month + ' ' + FORMAT(PayPeriodRec.Year);
                            PayMonth := PayPeriodRec.Month;
                            PayYear := PayPeriodRec.Year;
                            PayPeriodStartDate := PayPeriodRec."Period Start Date";
                            PayPeriodEndDate := PayPeriodRec."Period End Date";
                        end;
                    end;
                }
                field("Payroll Statement ID"; "Payroll Statement ID")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if "Pay Cycle" = '' then
                            ERROR('Please select Pay Cycle');

                        if "Pay Period" = '' then
                            ERROR('Please select Pay Period');

                        PayrollStatement.RESET;
                        PayrollStatement.FILTERGROUP(2);
                        PayrollStatement.SETRANGE("Pay Cycle", "Pay Cycle");
                        PayrollStatement.SETRANGE("Pay Period Start Date", PayPeriodStartDate);
                        PayrollStatement.SETRANGE("Pay Period End Date", PayPeriodEndDate);
                        PayrollStatement.FILTERGROUP(0);
                        if PAGE.RUNMODAL(PAGE::"Payroll Statements", PayrollStatement) = ACTION::LookupOK then begin
                            "Payroll Statement ID" := PayrollStatement."Payroll Statement ID";
                        end;
                    end;
                }
            }
        }

    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        PayrollStatementEmployee: Record "Payroll Statement Employee";
    begin
        PayrollStatementEmployee.Reset();
        PayrollStatementEmployee.SetRange("Payroll Pay Cycle", "Pay Cycle");
        PayrollStatementEmployee.SetRange("Pay Period Start Date", PayPeriodStartDate);
        PayrollStatementEmployee.SetRange("Pay Period End Date", PayPeriodEndDate);
        PayrollStatementEmployee.SetRange("Payroll Statement ID", "Payroll Statement ID");
        if PayrollStatementEmployee.FindFirst() then;
        if CloseAction IN [ACTION::OK, ACTION::LookupOK] then
            Report.RunModal(Report::"Salary Update File New", false, false, PayrollStatementEmployee);
    end;

    var
        "Pay Cycle": Code[50];
        "Pay Period": Code[50];
        PayrollStatement: Record "Payroll Statement";
        PayMonth: Code[20];
        PayYear: Integer;
        PayPeriodRec: Record "Pay Periods";
        PayPeriodStartDate: Date;
        PayPeriodEndDate: Date;
        "Payroll Statement ID": Code[20];
}