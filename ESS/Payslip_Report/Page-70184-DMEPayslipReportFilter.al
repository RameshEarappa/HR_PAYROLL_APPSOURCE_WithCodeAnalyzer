page 70184 "Payslip Report Filter"
{
    Caption = 'Employee Payslip Report Filter';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group("Report Filter")
            {
                field("Pay Cycle"; "Pay Cycle")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    Visible = false;
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
                        PayPeriodRec.SetRange("Enable Payroll Statements", true);
                        if PAGE.RUNMODAL(PAGE::"Pay Periods List", PayPeriodRec) = ACTION::LookupOK then begin
                            "Pay Period" := PayPeriodRec.Month + ' ' + FORMAT(PayPeriodRec.Year);
                            PayMonth := PayPeriodRec.Month;
                            PayYear := PayPeriodRec.Year;
                            PayPeriodStartDate := PayPeriodRec."Period Start Date";
                            PayPeriodEndDate := PayPeriodRec."Period End Date";
                        end;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        EmployeeRecL.Reset();
        EmployeeRecL.SetRange("No.", GetEmployeeID());
        if EmployeeRecL.FindFirst() then;
        EmployeePosRecL.Reset();
        EmployeePosRecL.SetRange(Worker, EmployeeRecL."No.");
        EmployeePosRecL.SetRange("Is Primary Position", true);
        if EmployeePosRecL.FindFirst() then begin
            PayrollPositionRecL.Reset();
            PayrollPositionRecL.SetRange("Position ID", EmployeePosRecL."Position ID");
            if PayrollPositionRecL.FindFirst() then;
        end;
        PayrollPositionRecL.TestField("Pay Cycle");
        "Pay Cycle" := PayrollPositionRecL."Pay Cycle";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction IN [ACTION::OK, ACTION::LookupOK] then begin
            EmployeeRecL.Reset();
            EmployeeRecL.SetRange("No.", GetEmployeeID());
            if EmployeeRecL.FindFirst() then;
            Clear(DMEPayslip);
            DMEPayslip.SetVal("Pay Period",
                                PayMonth,
                                PayYear,
                                PayPeriodStartDate,
                                PayPeriodEndDate,
                                "Pay Cycle");
            DMEPayslip.SetTableView(EmployeeRecL);
            DMEPayslip.UseRequestPage(false);
            DMEPayslip.Run();
        end;
    end;

    var
        "Pay Cycle": Code[50];
        "Pay Period": Code[50];
        PayMonth: Code[20];
        PayYear: Integer;
        PayPeriodRec: Record "Pay Periods";
        PayPeriodStartDate: Date;
        PayPeriodEndDate: Date;
        "Payroll Statement ID": Code[20];
        UserSetupRecG: Record "User Setup";
        DMEPayslip: Report "DME Payslip";
        EmployeeRecL: Record Employee;
        EmployeePosRecL: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRecL: Record "Payroll Position";

    procedure SetPayCycle(PCycle_P: Code[50])
    begin
        "Pay Cycle" := PCycle_P;
    end;

    procedure GetEmployeeID(): Code[20]
    begin
        UserSetupRecG.Reset();
        UserSetupRecG.SetRange("User ID", Database.UserId);
        if UserSetupRecG.FindFirst() then
            UserSetupRecG.TestField("Employee Id");

        exit(UserSetupRecG."Employee Id");
    end;
}