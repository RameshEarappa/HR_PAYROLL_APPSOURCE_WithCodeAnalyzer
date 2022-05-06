codeunit 60006 "Create Accrual Interim Line"
{
    trigger OnRun();
    var
        CarryEmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        AccrualComponentsEmployee: Record "Accrual Components Employee";
        MonthsAheadCalculate: Integer;
        InterimAccrualCount: Integer;
        i: Integer;
        Variance: Integer;
    begin
        IF WORKDATE = CALCDATE('-CM', WORKDATE) THEN BEGIN
            PeriodStartDate := CALCDATE('-CM', WORKDATE);
            PeriodEndDate := CALCDATE('CM', WORKDATE);
            Employee.RESET;
            IF Employee.FindSet() THEN
                REPEAT
                    AccrualComponentsEmployee.RESET;
                    AccrualComponentsEmployee.SETRANGE("Worker ID", Employee."No.");
                    IF AccrualComponentsEmployee.FINDLAST THEN;
                    EmployeeInterimAccrualLines3.RESET;
                    EmployeeInterimAccrualLines3.SETRANGE("Worker ID", Employee."No.");
                    EmployeeInterimAccrualLines3.SETFILTER("Start Date", '>%1', PeriodStartDate);
                    IF (EmployeeInterimAccrualLines3.FINDFIRST) AND (EmployeeInterimAccrualLines3.COUNT < AccrualComponentsEmployee."Months Ahead Calculate") THEN BEGIN
                        InterimAccrualCount := EmployeeInterimAccrualLines3.COUNT;
                        MonthsAheadCalculate := AccrualComponentsEmployee."Months Ahead Calculate";
                        Variance := MonthsAheadCalculate - InterimAccrualCount;
                        FOR i := 1 TO Variance DO BEGIN
                            EmployeeInterimAccrualLines2.RESET;
                            EmployeeInterimAccrualLines2.SETCURRENTKEY(Month, "Seq No");
                            EmployeeInterimAccrualLines2.SETRANGE("Worker ID", Employee."No.");
                            IF EmployeeInterimAccrualLines2.FINDLAST THEN BEGIN
                                CLEAR(PeriodStartDate);
                                CLEAR(PeriodEndDate);
                                PeriodStartDate := CALCDATE('CM+1D', EmployeeInterimAccrualLines2."Start Date");
                                PeriodEndDate := CALCDATE('CM', CALCDATE('CM+1D', EmployeeInterimAccrualLines2."Start Date"));
                                Period.RESET;
                                Period.SETCURRENTKEY("Period Type", "Period Start");
                                Period.SETRANGE("Period Type", Period."Period Type"::Month);
                                Period.SETRANGE("Period Start", PeriodStartDate, PeriodEndDate);
                                IF Period.FINDFIRST THEN BEGIN
                                    EmployeeInterimAccrualLines.INIT;
                                    EmployeeInterimAccrualLines."Accrual ID" := EmployeeInterimAccrualLines2."Accrual ID";
                                    EmployeeInterimAccrualLines."Line No." := EmployeeInterimAccrualLines2."Line No." + 10000;
                                    EmployeeInterimAccrualLines."Worker ID" := Employee."No.";
                                    EmployeeInterimAccrualLines."Seq No" := EmployeeInterimAccrualLines2."Seq No" + 1;
                                    EmployeeInterimAccrualLines.Month := EmployeeInterimAccrualLines2.Month + 1;
                                    EmployeeInterimAccrualLines."Start Date" := Period."Period Start";
                                    EmployeeInterimAccrualLines."End Date" := Period."Period End";
                                    EmployeeInterimAccrualLines."Accrual Interval Basis Date" := EmployeeInterimAccrualLines2."Accrual Interval Basis Date";
                                    EmployeeInterimAccrualLines."Accrual Basis Date" := EmployeeInterimAccrualLines2."Accrual Basis Date";
                                    EmployeeInterimAccrualLines."Monthly Accrual Units" := EmployeeInterimAccrualLines2."Monthly Accrual Units";
                                    EmployeeInterimAccrualLines."Max Carryforward" := EmployeeInterimAccrualLines2."Max Carryforward";
                                    EmployeeInterimAccrualLines."Adjustment Units" := EmployeeInterimAccrualLines2."Adjustment Units";
                                    IF EmployeeInterimAccrualLines.INSERT THEN BEGIN
                                        AccrualComponentsEmployee.RESET;
                                        AccrualComponentsEmployee.SETRANGE("Accrual ID", EmployeeInterimAccrualLines."Accrual ID");
                                        AccrualComponentsEmployee.SETRANGE("Worker ID", EmployeeInterimAccrualLines."Worker ID");
                                        IF AccrualComponentsEmployee.FINDFIRST THEN BEGIN
                                            CarryEmployeeInterimAccrualLines.RESET;
                                            CarryEmployeeInterimAccrualLines.SETRANGE("Accrual ID", EmployeeInterimAccrualLines2."Accrual ID");
                                            CarryEmployeeInterimAccrualLines.SETRANGE("Worker ID", Employee."No.");
                                            CarryEmployeeInterimAccrualLines.SETRANGE("Carryforward Month", TRUE);
                                            IF CarryEmployeeInterimAccrualLines.FINDFIRST THEN BEGIN
                                                IF (Period."Period Start" = CALCDATE('-CM+' + FORMAT(AccrualComponentsEmployee."Roll Over Period") + 'M', CarryEmployeeInterimAccrualLines."Start Date")) THEN BEGIN
                                                    EmployeeInterimAccrualLines."Carryforward Month" := TRUE;
                                                    IF EmployeeInterimAccrualLines2."Closing Balance" > AccrualComponentsEmployee."Max Carry Forward" THEN
                                                        EmployeeInterimAccrualLines."Carryforward Deduction" := AccrualComponentsEmployee."Max Carry Forward"
                                                END;
                                            END
                                            ELSE BEGIN
                                                IF (Period."Period Start" = CALCDATE('-CM+' + FORMAT(AccrualComponentsEmployee."Roll Over Period") + 'M', AccrualComponentsEmployee."Accrual Basis Date")) THEN BEGIN
                                                    EmployeeInterimAccrualLines."Carryforward Month" := TRUE;
                                                    IF EmployeeInterimAccrualLines2."Closing Balance" > AccrualComponentsEmployee."Max Carry Forward" THEN
                                                        EmployeeInterimAccrualLines."Carryforward Deduction" := AccrualComponentsEmployee."Max Carry Forward"
                                                END;
                                            END;
                                            EmployeeInterimAccrualLines."Opening Balance Unit" := EmployeeInterimAccrualLines2."Closing Balance";
                                            EmployeeInterimAccrualLines."Closing Balance" := (EmployeeInterimAccrualLines."Opening Balance Unit"
                                                                                        + EmployeeInterimAccrualLines."Carryforward Deduction"
                                                                                        + EmployeeInterimAccrualLines."Monthly Accrual Units"
                                                                                        + EmployeeInterimAccrualLines."Adjustment Units")
                                                                                        - EmployeeInterimAccrualLines."Leaves Consumed Units";
                                            EmployeeInterimAccrualLines.MODIFY;
                                        END;
                                    END;
                                END;
                            END;
                        END;
                    END;
                UNTIL Employee.NEXT = 0;
        END;
    end;

    var
        Employee: Record Employee;
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        EmployeeInterimAccrualLines2: Record "Employee Interim Accurals";
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        Period: Record Date;
        EmployeeInterimAccrualLines3: Record "Employee Interim Accurals";
}