codeunit 60007 "Update Employee Accruals"
{
    trigger OnRun();
    var
        i: Integer;
        NewStartDate: Date;
        NewEndDate: Date;
    begin
        if WORKDATE = CALCDATE('-CM', WORKDATE) then begin
            PeriodStartDate := CALCDATE('-CM', WORKDATE);
            PeriodEndDate := CALCDATE('CM', WORKDATE);
            Employee.RESET;
            if Employee.FINDFIRST then
                repeat
                    AccrualComponentsEmployee.RESET;
                    AccrualComponentsEmployee.SETRANGE("Worker ID", Employee."No.");
                    if AccrualComponentsEmployee.FINDFIRST then
                        repeat
                            CLEAR(EmployeeLastPeriodDate);
                            EmployeeInterimAccrualLines2.RESET;
                            EmployeeInterimAccrualLines2.SETRANGE("Accrual ID", AccrualComponentsEmployee."Accrual ID");
                            EmployeeInterimAccrualLines2.SETRANGE("Worker ID", Employee."No.");
                            if EmployeeInterimAccrualLines2.FINDLAST then
                                EmployeeLastPeriodDate := EmployeeInterimAccrualLines2."Start Date";
                            EmployeeEarningCodes.RESET;
                            EmployeeEarningCodes.SETRANGE(Worker, Employee."No.");
                            EmployeeEarningCodes.SETRANGE("Earning Code Group", Employee."Earning Code Group");
                            EmployeeEarningCodes.SETRANGE("Calc Accrual", true);
                            if EmployeeEarningCodes.FINDFIRST then
                                repeat
                                    PerDayAmount += EmployeeEarningCodes."Package Amount";
                                until EmployeeEarningCodes.NEXT = 0;
                            if PerDayAmount <> 0 then
                                PerDayAmount := PerDayAmount / 30;
                            CLEAR(i);
                            EmployeeInterimAccrualLines2.RESET;
                            EmployeeInterimAccrualLines2.SETRANGE("Worker ID", Employee."No.");
                            EmployeeInterimAccrualLines2.SETFILTER("Start Date", '>%1', PeriodStartDate);
                            if (EmployeeInterimAccrualLines2.FINDFIRST) and (EmployeeInterimAccrualLines2.COUNT < AccrualComponentsEmployee."Months Ahead Calculate") and
                               (EmployeeInterimAccrualLines2.COUNT <> 0) then begin
                                for i := 1 to EmployeeInterimAccrualLines2.COUNT do begin
                                    EmployeeInterimAccrualLines3.RESET;
                                    EmployeeInterimAccrualLines3.SETRANGE("Worker ID", Employee."No.");
                                    if EmployeeInterimAccrualLines3.FINDLAST then;
                                    CLEAR(NewStartDate);
                                    CLEAR(NewEndDate);
                                    NewStartDate := CALCDATE('CM+1D', EmployeeInterimAccrualLines3."Start Date");
                                    NewEndDate := CALCDATE('CM', NewStartDate);
                                    EmployeeInterimAccrualLines.INIT;
                                    EmployeeInterimAccrualLines."Accrual ID" := AccrualComponentsEmployee."Accrual ID";
                                    EmployeeInterimAccrualLines."Line No." := EmployeeInterimAccrualLines3."Line No." + 10000;
                                    EmployeeInterimAccrualLines."Worker ID" := Employee."No.";
                                    EmployeeInterimAccrualLines."Seq No" := EmployeeInterimAccrualLines3."Seq No" + 1;
                                    EmployeeInterimAccrualLines.Month := EmployeeInterimAccrualLines3.Month + 1;
                                    EmployeeInterimAccrualLines."Start Date" := NewStartDate;
                                    EmployeeInterimAccrualLines."End Date" := NewEndDate;
                                    EmployeeInterimAccrualLines."Accrual Interval Basis Date" := AccrualComponentsEmployee."Accrual Interval Basis Date";
                                    EmployeeInterimAccrualLines."Accrual Basis Date" := AccrualComponentsEmployee."Accrual Basis Date";
                                    EmployeeInterimAccrualLines."Monthly Accrual Units" := AccrualComponentsEmployee."Accrual Units Per Month";
                                    EmployeeInterimAccrualLines."Monthly Accrual Amount" :=
                                                AccrualComponentsEmployee."Accrual Units Per Month" * PerDayAmount;
                                    EmployeeInterimAccrualLines."Max Carryforward" := AccrualComponentsEmployee."Max Carry Forward";
                                    EmployeeInterimAccrualLines.INSERT;
                                end;
                            end;
                            AccrualComponentCalculate.OnAfterValidateAccrualLeaves(Employee."No.", EmployeeLastPeriodDate, '', Employee."Earning Code Group");
                        until AccrualComponentsEmployee.NEXT = 0;

                until Employee.NEXT = 0;
        end;
        MESSAGE('Done');
    end;

    var
        Employee: Record Employee;
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        Period: Record Date;
        AccrualComponentsEmployee: Record "Accrual Components Employee";
        EmployeeInterimAccrualLines2: Record "Employee Interim Accurals";
        EmployeeInterimAccrualLines3: Record "Employee Interim Accurals";
        EmployeeEarningCodes: Record "Payroll Earning Code Wrkr";
        PerDayAmount: Decimal;
        EmployeeLastPeriodDate: Date;
        AccrualComponentCalculate: Codeunit "Accrual Component Calculate";
}