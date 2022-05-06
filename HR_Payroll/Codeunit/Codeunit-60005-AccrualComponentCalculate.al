codeunit 60005 "Accrual Component Calculate"
{
    var
        ActualPeriodStartDate: Date;
        ActualPeriodEndDate: Date;
        EmployeeInterimAccrualLines2: Record "Employee Interim Accurals";
        EmployeeInterimAccrualLines3: Record "Employee Interim Accurals";
        PerDayAmount: Decimal;
        AdvancePayrollSetup: Record "Advance Payroll Setup";

    procedure CalculateAccruals(EmployeeNo: Code[20]; EarningCodeGroup: Code[20]; AccrualID: Code[20]; LeaveID: Code[20]; EffectiveStartDate: Date; EffectiveEndDate: Date);
    var
        AccrualComponentsEmployee: Record "Accrual Components Employee";
        AccrualComponents: Record "Accrual Components";
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        HCMLeaveTypesErnGrp: Record "HCM Leave Types ErnGrp";
        Employee: Record Employee;
        Period: Record Date;
        "Count": Integer;
        LineNo: Integer;
        EmployeeEarningCodes: Record "Payroll Earning Code Wrkr";
        CarryEmployeeInterimAccrualLines: Record "Employee Interim Accurals";
    begin
        Employee.GET(EmployeeNo);
        EmployeeInterimAccrualLines3.RESET;
        EmployeeInterimAccrualLines3.SETRANGE("Worker ID", EmployeeNo);
        IF NOT EmployeeInterimAccrualLines3.FINDFIRST THEN BEGIN
            CLEAR(PerDayAmount);
            EmployeeEarningCodes.RESET;
            EmployeeEarningCodes.SETRANGE(Worker, EmployeeNo);
            EmployeeEarningCodes.SETRANGE("Earning Code Group", EarningCodeGroup);
            EmployeeEarningCodes.SETRANGE("Calc Accrual", TRUE);
            IF EmployeeEarningCodes.FINDFIRST THEN
                REPEAT
                    PerDayAmount += EmployeeEarningCodes."Package Amount";
                UNTIL EmployeeEarningCodes.NEXT = 0;
            IF PerDayAmount <> 0 THEN
                PerDayAmount := PerDayAmount / 30;
            AdvancePayrollSetup.GET;
            HCMLeaveTypesErnGrp.RESET;
            HCMLeaveTypesErnGrp.SETRANGE(HCMLeaveTypesErnGrp."Earning Code Group", EarningCodeGroup);
            HCMLeaveTypesErnGrp.SETRANGE("Leave Type Id", LeaveID);
            IF HCMLeaveTypesErnGrp.FINDFIRST THEN BEGIN
                AccrualComponents.RESET;
                AccrualComponents.SETRANGE("Accrual ID", HCMLeaveTypesErnGrp."Accrual ID");
                IF AccrualComponents.FINDFIRST THEN BEGIN
                    AccrualComponentsEmployee.INIT;
                    AccrualComponentsEmployee.TRANSFERFIELDS(AccrualComponents);
                    AccrualComponentsEmployee."Worker ID" := EmployeeNo;
                    IF AdvancePayrollSetup."Accrual Effective Start Date" > EffectiveStartDate THEN
                        AccrualComponentsEmployee."Accrual Basis Date" := AdvancePayrollSetup."Accrual Effective Start Date"
                    ELSE
                        AccrualComponentsEmployee."Accrual Basis Date" := EffectiveStartDate;

                    AccrualComponentsEmployee."Accrual Interval Basis Date" := HCMLeaveTypesErnGrp."Accrual Interval Basis Date";
                    IF AccrualComponentsEmployee.INSERT THEN BEGIN
                        IF AdvancePayrollSetup."Accrual Effective Start Date" > EffectiveStartDate THEN
                            ActualPeriodStartDate := CALCDATE('-CM', AdvancePayrollSetup."Accrual Effective Start Date")
                        ELSE
                            ActualPeriodStartDate := CALCDATE('-CM', EffectiveStartDate);
                        ActualPeriodEndDate := CALCDATE('-CM-1D+' + FORMAT(AccrualComponentsEmployee."Months Ahead Calculate") + 'M', ActualPeriodStartDate);
                        Period.RESET;
                        Period.SETCURRENTKEY("Period Type", "Period Start");
                        Period.SETRANGE("Period Type", Period."Period Type"::Month);
                        Period.SETRANGE("Period Start", ActualPeriodStartDate, ActualPeriodEndDate);
                        IF Period.FINDFIRST THEN BEGIN
                            CLEAR(Count);
                            REPEAT
                                Count += 1;
                                LineNo += 10000;
                                EmployeeInterimAccrualLines.INIT;
                                EmployeeInterimAccrualLines."Accrual ID" := AccrualComponentsEmployee."Accrual ID";
                                EmployeeInterimAccrualLines."Line No." := LineNo;
                                EmployeeInterimAccrualLines."Worker ID" := EmployeeNo;
                                EmployeeInterimAccrualLines."Seq No" := Count;
                                EmployeeInterimAccrualLines.Month := Count;
                                EmployeeInterimAccrualLines."Start Date" := Period."Period Start";
                                EmployeeInterimAccrualLines."End Date" := Period."Period End";
                                EmployeeInterimAccrualLines."Accrual Interval Basis Date" := AccrualComponentsEmployee."Accrual Interval Basis Date";
                                EmployeeInterimAccrualLines."Accrual Basis Date" := AccrualComponentsEmployee."Accrual Basis Date";
                                EmployeeInterimAccrualLines."Monthly Accrual Units" := AccrualComponentsEmployee."Accrual Units Per Month";
                                EmployeeInterimAccrualLines."Monthly Accrual Amount" := AccrualComponentsEmployee."Accrual Units Per Month" * PerDayAmount;
                                EmployeeInterimAccrualLines."Max Carryforward" := AccrualComponentsEmployee."Max Carry Forward";
                                EmployeeInterimAccrualLines.INSERT;
                                IF Count = 1 THEN BEGIN
                                    EmployeeInterimAccrualLines."Closing Balance" := (EmployeeInterimAccrualLines."Opening Balance Unit"
                                                                                   + EmployeeInterimAccrualLines."Carryforward Deduction"
                                                                                   + EmployeeInterimAccrualLines."Monthly Accrual Units"
                                                                                   + EmployeeInterimAccrualLines."Adjustment Units")
                                                                                   - EmployeeInterimAccrualLines."Leaves Consumed Units";
                                    EmployeeInterimAccrualLines."Closing Balance Amount" := EmployeeInterimAccrualLines."Closing Balance" * PerDayAmount;

                                    EmployeeInterimAccrualLines.MODIFY;

                                END
                                ELSE BEGIN
                                    EmployeeInterimAccrualLines2.RESET;
                                    EmployeeInterimAccrualLines2.SETRANGE("Accrual ID", AccrualComponentsEmployee."Accrual ID");
                                    EmployeeInterimAccrualLines2.SETRANGE("Worker ID", EmployeeNo);
                                    EmployeeInterimAccrualLines2.SETRANGE("Seq No", Count - 1);
                                    IF EmployeeInterimAccrualLines2.FINDFIRST THEN BEGIN
                                        CarryEmployeeInterimAccrualLines.RESET;
                                        CarryEmployeeInterimAccrualLines.SETRANGE("Accrual ID", AccrualComponentsEmployee."Accrual ID");
                                        CarryEmployeeInterimAccrualLines.SETRANGE("Worker ID", EmployeeNo);
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
                                        EmployeeInterimAccrualLines."Opening Balance Amount" := EmployeeInterimAccrualLines2."Closing Balance" * PerDayAmount;
                                        EmployeeInterimAccrualLines."Closing Balance" := (EmployeeInterimAccrualLines."Opening Balance Unit"
                                                                                    + EmployeeInterimAccrualLines."Carryforward Deduction"
                                                                                    + EmployeeInterimAccrualLines."Monthly Accrual Units"
                                                                                    + EmployeeInterimAccrualLines."Adjustment Units")
                                                                                    - EmployeeInterimAccrualLines."Leaves Consumed Units";
                                        EmployeeInterimAccrualLines."Closing Balance Amount" := EmployeeInterimAccrualLines."Closing Balance" * PerDayAmount;
                                        EmployeeInterimAccrualLines.MODIFY;
                                    END;
                                END;
                            UNTIL Period.NEXT = 0;
                        END;
                    END;
                END;
            END;
        END
        ELSE BEGIN
            UpdateAccruals(EmployeeNo, EarningCodeGroup, AccrualID, LeaveID, EffectiveStartDate, EffectiveEndDate);
        END;
    end;

    procedure UpdateAccruals(EmployeeNo: Code[20]; EarningCodeGroup: Code[20]; AccrualID: Code[20]; LeaveID: Code[20]; EffectiveStartDate: Date; EffectiveEndDate: Date);
    var
        AccrualComponentsEmployee: Record "Accrual Components Employee";
        AccrualComponents: Record "Accrual Components";
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        HCMLeaveTypesErnGrp: Record "HCM Leave Types ErnGrp";
        Employee: Record Employee;
        Period: Record Date;
        "Count": Integer;
        LineNo: Integer;
        EmployeeEarningCodes: Record "Payroll Earning Code Wrkr";
        SeqNo: Integer;
        CarryEmployeeInterimAccrualLines: Record "Employee Interim Accurals";
    begin
        Employee.GET(EmployeeNo);
        AdvancePayrollSetup.GET;
        IF AdvancePayrollSetup."Accrual Effective Start Date" > EffectiveStartDate THEN
            EffectiveStartDate := CALCDATE('-CM', AdvancePayrollSetup."Accrual Effective Start Date")
        ELSE
            EffectiveStartDate := CALCDATE('-CM', EffectiveStartDate);

        IF AccrualID <> '' THEN BEGIN
            EmployeeInterimAccrualLines3.RESET;
            EmployeeInterimAccrualLines3.SETRANGE("Worker ID", EmployeeNo);
            EmployeeInterimAccrualLines3.SETFILTER("Start Date", '>=%1', EffectiveStartDate);
            EmployeeInterimAccrualLines3.SETFILTER("Leaves Consumed Units", '<>%1', 0);
            IF EmployeeInterimAccrualLines3.FINDFIRST THEN
                ERROR('Leave applied in the period %1. Cancel the leaves and assign the position', FORMAT(EmployeeInterimAccrualLines3."Start Date") + '-' + FORMAT(EmployeeInterimAccrualLines3."End Date"));
            EmployeeInterimAccrualLines3.RESET;
            EmployeeInterimAccrualLines3.SETRANGE("Worker ID", EmployeeNo);
            EmployeeInterimAccrualLines3.SETFILTER("Start Date", '>=%1', EffectiveStartDate);
            EmployeeInterimAccrualLines3.DELETEALL;

            EmployeeInterimAccrualLines3.RESET;
            EmployeeInterimAccrualLines3.SETRANGE("Worker ID", EmployeeNo);
            IF EmployeeInterimAccrualLines3.FINDFIRST THEN
                REPEAT
                    EmployeeInterimAccrualLines2 := EmployeeInterimAccrualLines3;
                    EmployeeInterimAccrualLines2.RENAME(AccrualID, EmployeeInterimAccrualLines3."Worker ID", EmployeeInterimAccrualLines3."Line No.");
                UNTIL EmployeeInterimAccrualLines3.NEXT = 0;
        END;
        CLEAR(EmployeeInterimAccrualLines2);
        CLEAR(EmployeeInterimAccrualLines3);

        HCMLeaveTypesErnGrp.RESET;
        HCMLeaveTypesErnGrp.SETRANGE(HCMLeaveTypesErnGrp."Earning Code Group", EarningCodeGroup);
        HCMLeaveTypesErnGrp.SETRANGE("Leave Type Id", LeaveID);
        IF HCMLeaveTypesErnGrp.FINDFIRST THEN BEGIN

            AccrualComponents.RESET;
            AccrualComponents.SETRANGE("Accrual ID", HCMLeaveTypesErnGrp."Accrual ID");
            IF AccrualComponents.FINDFIRST THEN BEGIN
                AccrualComponentsEmployee.RESET;
                AccrualComponentsEmployee.SETRANGE("Worker ID", EmployeeNo);
                AccrualComponentsEmployee.DELETEALL;

                AccrualComponentsEmployee.INIT;
                AccrualComponentsEmployee.TRANSFERFIELDS(AccrualComponents);
                AccrualComponentsEmployee."Worker ID" := EmployeeNo;
                AccrualComponentsEmployee."Accrual Basis Date" := AdvancePayrollSetup."Accrual Effective Start Date";
                AccrualComponentsEmployee."Accrual Interval Basis Date" := HCMLeaveTypesErnGrp."Accrual Interval Basis Date";
                IF AccrualComponentsEmployee.INSERT THEN BEGIN
                    CLEAR(PerDayAmount);
                    EmployeeEarningCodes.RESET;
                    EmployeeEarningCodes.SETRANGE(Worker, EmployeeNo);
                    EmployeeEarningCodes.SETRANGE("Earning Code Group", EarningCodeGroup);
                    EmployeeEarningCodes.SETRANGE("Calc Accrual", TRUE);
                    IF EmployeeEarningCodes.FINDFIRST THEN
                        REPEAT
                            PerDayAmount += EmployeeEarningCodes."Package Amount";
                        UNTIL EmployeeEarningCodes.NEXT = 0;
                    IF PerDayAmount <> 0 THEN
                        PerDayAmount := PerDayAmount / 30;

                    IF AdvancePayrollSetup."Accrual Effective Start Date" > EffectiveStartDate THEN
                        ActualPeriodStartDate := CALCDATE('-CM', AdvancePayrollSetup."Accrual Effective Start Date")
                    ELSE
                        ActualPeriodStartDate := CALCDATE('-CM', EffectiveStartDate);
                    ActualPeriodEndDate := CALCDATE('-CM-1D+' + FORMAT(AccrualComponentsEmployee."Months Ahead Calculate") + 'M', ActualPeriodStartDate);
                    Period.RESET;
                    Period.SETCURRENTKEY("Period Type", "Period Start");
                    Period.SETRANGE("Period Type", Period."Period Type"::Month);
                    Period.SETRANGE("Period Start", ActualPeriodStartDate, ActualPeriodEndDate);
                    IF Period.FINDFIRST THEN BEGIN
                        CLEAR(Count);
                        REPEAT
                            CLEAR(SeqNo);
                            CLEAR(LineNo);
                            Count += 1;
                            EmployeeInterimAccrualLines3.RESET;
                            EmployeeInterimAccrualLines3.SETRANGE("Worker ID", EmployeeNo);
                            IF EmployeeInterimAccrualLines3.FINDLAST THEN;
                            SeqNo := EmployeeInterimAccrualLines3."Seq No" + 1;
                            LineNo += EmployeeInterimAccrualLines3."Line No." + 10000;
                            EmployeeInterimAccrualLines.INIT;
                            EmployeeInterimAccrualLines."Accrual ID" := AccrualComponentsEmployee."Accrual ID";
                            EmployeeInterimAccrualLines."Line No." := LineNo;
                            EmployeeInterimAccrualLines."Worker ID" := EmployeeNo;
                            EmployeeInterimAccrualLines."Seq No" := EmployeeInterimAccrualLines3."Seq No" + 1;
                            EmployeeInterimAccrualLines.Month := EmployeeInterimAccrualLines3.Month + 1;
                            EmployeeInterimAccrualLines."Start Date" := Period."Period Start";
                            EmployeeInterimAccrualLines."End Date" := Period."Period End";
                            EmployeeInterimAccrualLines."Accrual Interval Basis Date" := HCMLeaveTypesErnGrp."Accrual Interval Basis Date";
                            EmployeeInterimAccrualLines."Accrual Basis Date" := HCMLeaveTypesErnGrp."Accrual Basis Date";
                            EmployeeInterimAccrualLines."Monthly Accrual Units" := AccrualComponentsEmployee."Accrual Units Per Month";
                            EmployeeInterimAccrualLines."Monthly Accrual Amount" := AccrualComponentsEmployee."Accrual Units Per Month" * PerDayAmount;
                            EmployeeInterimAccrualLines."Max Carryforward" := AccrualComponentsEmployee."Max Carry Forward";
                            EmployeeInterimAccrualLines.INSERT;
                            IF Count = 1 THEN BEGIN
                                EmployeeInterimAccrualLines."Opening Balance Unit" := EmployeeInterimAccrualLines3."Closing Balance";
                                EmployeeInterimAccrualLines."Opening Balance Amount" := EmployeeInterimAccrualLines3."Closing Balance" * PerDayAmount;
                                EmployeeInterimAccrualLines."Closing Balance" := (EmployeeInterimAccrualLines."Opening Balance Unit"
                                                                              + EmployeeInterimAccrualLines."Carryforward Deduction"
                                                                              + EmployeeInterimAccrualLines."Monthly Accrual Units"
                                                                              + EmployeeInterimAccrualLines."Adjustment Units")
                                                                              - EmployeeInterimAccrualLines."Leaves Consumed Units";
                                EmployeeInterimAccrualLines."Closing Balance Amount" := EmployeeInterimAccrualLines."Closing Balance" * PerDayAmount;
                                EmployeeInterimAccrualLines.MODIFY;

                            END
                            ELSE BEGIN
                                EmployeeInterimAccrualLines2.RESET;
                                EmployeeInterimAccrualLines2.SETRANGE("Accrual ID", AccrualComponentsEmployee."Accrual ID");
                                EmployeeInterimAccrualLines2.SETRANGE("Worker ID", EmployeeNo);
                                EmployeeInterimAccrualLines2.SETRANGE("Seq No", SeqNo - 1);
                                IF EmployeeInterimAccrualLines2.FINDFIRST THEN BEGIN
                                    CarryEmployeeInterimAccrualLines.RESET;
                                    CarryEmployeeInterimAccrualLines.SETRANGE("Accrual ID", AccrualComponentsEmployee."Accrual ID");
                                    CarryEmployeeInterimAccrualLines.SETRANGE("Worker ID", EmployeeNo);
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
                                    EmployeeInterimAccrualLines."Opening Balance Amount" := EmployeeInterimAccrualLines2."Closing Balance" * PerDayAmount;
                                    EmployeeInterimAccrualLines."Closing Balance" := (EmployeeInterimAccrualLines."Opening Balance Unit"
                                                                                + EmployeeInterimAccrualLines."Carryforward Deduction"
                                                                                + EmployeeInterimAccrualLines."Monthly Accrual Units"
                                                                                + EmployeeInterimAccrualLines."Adjustment Units")
                                                                                - EmployeeInterimAccrualLines."Leaves Consumed Units";
                                    EmployeeInterimAccrualLines."Closing Balance Amount" := EmployeeInterimAccrualLines."Closing Balance" * PerDayAmount;
                                    EmployeeInterimAccrualLines.MODIFY;
                                END;
                            END;
                        UNTIL Period.NEXT = 0;
                    END;
                END;
            END;
        END;
    end;

    procedure ValidateAccrualLeaves(EmployeeNo: Code[20];
                                    LeaveID: Code[20];
                                    EffectiveStartDate: Date;
                                    EffectiveEndDate: Date;
                                    EarningCodeGroup: Code[20];
                                    AccrualID: Code[20];
                                    LeaveDays: Decimal);
    var
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        LeaveType: Record "HCM Leave Types Wrkr";
        AccrualComponentEmployee: Record "Accrual Components Employee";
        NoOfLeaveDaysFirstMonth: Decimal;
        NoOfLeaveDaysSecondMonth: Decimal;
        Period: Record Date;
        EmployeeEarngCodeGrp: Record "Employee Earning Code Groups";
        WorkCalendarDate: Record "Work Calendar Date";
        PublicHolidays: Integer;
        WeeklyOffDays: Integer;
        EmployeeWorkDate: Record EmployeeWorkDate_GCC;
    begin
        Period.RESET;
        Period.SETRANGE("Period Type", Period."Period Type"::Month);
        Period.SETRANGE("Period Start", CALCDATE('-CM', EffectiveStartDate), CALCDATE('CM', EffectiveEndDate));
        IF Period.FINDFIRST THEN
            REPEAT
                CLEAR(LeaveDays);
                LeaveType.RESET;
                LeaveType.SETRANGE(LeaveType.Worker, EmployeeNo);
                LeaveType.SETRANGE("Leave Type Id", LeaveID);
                LeaveType.SETRANGE("Earning Code Group", EarningCodeGroup);
                IF LeaveType.FINDFIRST THEN;

                EmployeeWorkDate.RESET;
                EmployeeWorkDate.SETRANGE("Employee Code", EmployeeNo);
                EmployeeWorkDate.SETRANGE("First Half Leave Type", LeaveType."Leave Type Id");
                EmployeeWorkDate.SETRANGE("Trans Date", Period."Period Start", NORMALDATE(Period."Period End"));
                IF EmployeeWorkDate.FINDFIRST THEN
                    LeaveDays := EmployeeWorkDate.COUNT;

                EmployeeWorkDate.RESET;
                EmployeeWorkDate.SETRANGE("Employee Code", EmployeeNo);
                EmployeeWorkDate.SETRANGE("Second Half Leave Type", LeaveType."Leave Type Id");
                EmployeeWorkDate.SETRANGE("Trans Date", Period."Period Start", NORMALDATE(Period."Period End"));
                IF EmployeeWorkDate.FINDFIRST THEN
                    LeaveDays += EmployeeWorkDate.COUNT;

                IF LeaveDays <> 0 THEN
                    LeaveDays := LeaveDays / 2;

                EmployeeInterimAccrualLines.RESET;
                EmployeeInterimAccrualLines.SETRANGE("Accrual ID", LeaveType."Accrual ID");
                EmployeeInterimAccrualLines.SETRANGE("Worker ID", EmployeeNo);
                EmployeeInterimAccrualLines.SETRANGE("Start Date", Period."Period Start");
                IF EmployeeInterimAccrualLines.FINDFIRST THEN BEGIN
                    IF NOT LeaveType."Allow Negative" THEN
                        IF EmployeeInterimAccrualLines."Closing Balance" < LeaveDays THEN
                            ERROR('You donot have enough balance of leaves');
                    EmployeeInterimAccrualLines."Leaves Consumed Units" := LeaveDays;
                    EmployeeInterimAccrualLines.MODIFY;
                END;
            UNTIL Period.NEXT = 0;
    end;

    procedure OnAfterValidateAccrualLeaves(EmployeeNo: Code[20];
                                           EffectiveStartDate: Date;
                                           LeaveID: Code[20];
                                           EarningCodeGroup: Code[20]);
    var
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        LeaveType: Record "HCM Leave Types Wrkr";
        AccrualComponentEmployee: Record "Accrual Components Employee";
        EmployeeEarningCodes: Record "Payroll Earning Code Wrkr";
    begin
        CLEAR(PerDayAmount);
        EmployeeEarningCodes.RESET;
        EmployeeEarningCodes.SETRANGE(Worker, EmployeeNo);
        EmployeeEarningCodes.SETRANGE("Earning Code Group", EarningCodeGroup);
        EmployeeEarningCodes.SETRANGE("Calc Accrual", true);
        if EmployeeEarningCodes.FINDFIRST then
            repeat
                PerDayAmount += EmployeeEarningCodes."Package Amount";
            until EmployeeEarningCodes.NEXT = 0;
        if PerDayAmount <> 0 then
            PerDayAmount := PerDayAmount / 30;

        EmployeeInterimAccrualLines.RESET;
        EmployeeInterimAccrualLines.SETRANGE("Worker ID", EmployeeNo);
        EmployeeInterimAccrualLines.SETFILTER("Start Date", '>=%1', CALCDATE('-CM', EffectiveStartDate));
        if EmployeeInterimAccrualLines.FINDSET then
            repeat
                EmployeeInterimAccrualLines2.RESET;
                EmployeeInterimAccrualLines2.SETRANGE("Worker ID", EmployeeNo);
                EmployeeInterimAccrualLines2.SETRANGE("Seq No", EmployeeInterimAccrualLines."Seq No" - 1);
                if EmployeeInterimAccrualLines2.FINDFIRST then begin
                    EmployeeInterimAccrualLines."Opening Balance Unit" := EmployeeInterimAccrualLines2."Closing Balance";
                    EmployeeInterimAccrualLines."Opening Balance Amount" := EmployeeInterimAccrualLines2."Closing Balance" * PerDayAmount;
                    if EmployeeInterimAccrualLines."Carryforward Month" then
                        if EmployeeInterimAccrualLines2."Closing Balance" > EmployeeInterimAccrualLines."Max Carryforward" then
                            EmployeeInterimAccrualLines."Carryforward Deduction" := EmployeeInterimAccrualLines."Max Carryforward"
                                                                                  - EmployeeInterimAccrualLines2."Closing Balance"
                        else
                            EmployeeInterimAccrualLines."Carryforward Deduction" := 0;
                end;
                EmployeeInterimAccrualLines."Closing Balance" := (EmployeeInterimAccrualLines."Opening Balance Unit"
                                                                        + EmployeeInterimAccrualLines."Carryforward Deduction"
                                                                        + EmployeeInterimAccrualLines."Monthly Accrual Units"
                                                                        + EmployeeInterimAccrualLines."Adjustment Units")
                                                                        - EmployeeInterimAccrualLines."Leaves Consumed Units";
                EmployeeInterimAccrualLines."Closing Balance Amount" := EmployeeInterimAccrualLines."Closing Balance" * PerDayAmount;
                EmployeeInterimAccrualLines."Monthly Accrual Amount" := EmployeeInterimAccrualLines."Monthly Accrual Units" * PerDayAmount;
                EmployeeInterimAccrualLines."Leaves Consumed Amount" := EmployeeInterimAccrualLines."Leaves Consumed Units" * PerDayAmount;

                EmployeeInterimAccrualLines."Adjustment Amount" := EmployeeInterimAccrualLines."Adjustment Units" * PerDayAmount;
                EmployeeInterimAccrualLines.MODIFY;
            until EmployeeInterimAccrualLines.NEXT = 0;
    end;

    procedure ValidateCancelledAccrualLeaves(EmployeeNo: Code[20]; LeaveID: Code[20]; EffectiveStartDate: Date; EffectiveEndDate: Date; EarningCodeGroup: Code[20]; AccrualID: Code[20]; LeaveDays: Decimal);
    var
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        LeaveType: Record "HCM Leave Types Wrkr";
        AccrualComponentEmployee: Record "Accrual Components Employee";
        NoOfLeaveDaysFirstMonth: Decimal;
        NoOfLeaveDaysSecondMonth: Decimal;
        Period: Record Date;
        EmployeeEarngCodeGrp: Record "Employee Earning Code Groups";
        WorkCalendarDate: Record "Work Calendar Date";
        PublicHolidays: Integer;
        WeeklyOffDays: Integer;
    begin
        LeaveType.RESET;
        LeaveType.SETRANGE(LeaveType.Worker, EmployeeNo);
        LeaveType.SETRANGE("Leave Type Id", LeaveID);
        LeaveType.SETRANGE("Earning Code Group", EarningCodeGroup);
        if LeaveType.FINDFIRST then;

        AccrualComponentEmployee.RESET;
        AccrualComponentEmployee.SETRANGE("Worker ID", EmployeeNo);
        AccrualComponentEmployee.SETRANGE("Accrual ID", LeaveType."Accrual ID");
        if AccrualComponentEmployee.FINDFIRST then begin
            if AccrualComponentEmployee."Consumption Split by Month" then begin
                if DATE2DMY(EffectiveStartDate, 2) = DATE2DMY(EffectiveEndDate, 2) then begin
                    EmployeeInterimAccrualLines.RESET;
                    EmployeeInterimAccrualLines.SETRANGE("Accrual ID", AccrualComponentEmployee."Accrual ID");
                    EmployeeInterimAccrualLines.SETRANGE("Worker ID", AccrualComponentEmployee."Worker ID");
                    EmployeeInterimAccrualLines.SETRANGE("Start Date", CALCDATE('-CM', EffectiveStartDate));
                    if EmployeeInterimAccrualLines.FINDFIRST then begin
                        if not LeaveType."Allow Negative" then
                            EmployeeInterimAccrualLines."Leaves Consumed Units" -= LeaveDays;
                        EmployeeInterimAccrualLines.MODIFY;
                    end;
                end
                else begin
                    NoOfLeaveDaysFirstMonth := 0;
                    NoOfLeaveDaysSecondMonth := 0;
                    Period.RESET;
                    Period.SETRANGE("Period Type", Period."Period Type"::Date);
                    Period.SETRANGE("Period Start", EffectiveStartDate, CALCDATE('CM', EffectiveStartDate));
                    if Period.FINDFIRST then
                        NoOfLeaveDaysFirstMonth := Period.COUNT;
                    if LeaveType."Exc Public Holidays" then begin
                        EmployeeEarngCodeGrp.RESET;
                        EmployeeEarngCodeGrp.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                        EmployeeEarngCodeGrp.SETRANGE("Employee Code", EmployeeNo);
                        EmployeeEarngCodeGrp.SETFILTER("Valid From", '<=%1', EffectiveEndDate);
                        EmployeeEarngCodeGrp.SETFILTER("Valid To", '>=%1|%2', EffectiveEndDate, 0D);
                        if EmployeeEarngCodeGrp.FINDLAST then begin
                            WorkCalendarDate.RESET;
                            WorkCalendarDate.SETRANGE("Calendar ID", EmployeeEarngCodeGrp.Calander);
                            WorkCalendarDate.SETRANGE("Trans Date", EffectiveStartDate, CALCDATE('CM', EffectiveStartDate));
                            WorkCalendarDate.SETRANGE("Calculation Type", WorkCalendarDate."Calculation Type"::"Public Holiday");
                            if WorkCalendarDate.FINDFIRST then
                                PublicHolidays := WorkCalendarDate.COUNT;
                        end;
                    end;

                    if LeaveType."Exc Week Offs" then begin
                        EmployeeEarngCodeGrp.RESET;
                        EmployeeEarngCodeGrp.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                        EmployeeEarngCodeGrp.SETRANGE("Employee Code", EmployeeNo);
                        EmployeeEarngCodeGrp.SETFILTER("Valid From", '<=%1', EffectiveEndDate);
                        EmployeeEarngCodeGrp.SETFILTER("Valid To", '>=%1|%2', EffectiveEndDate, 0D);
                        if EmployeeEarngCodeGrp.FINDLAST then begin
                            WorkCalendarDate.RESET;
                            WorkCalendarDate.SETRANGE("Calendar ID", EmployeeEarngCodeGrp.Calander);
                            WorkCalendarDate.SETRANGE("Trans Date", EffectiveStartDate, CALCDATE('CM', EffectiveStartDate));
                            WorkCalendarDate.SETRANGE("Calculation Type", WorkCalendarDate."Calculation Type"::"Weekly Off");
                            if WorkCalendarDate.FINDFIRST then
                                WeeklyOffDays := WorkCalendarDate.COUNT;
                        end;
                    end;
                    NoOfLeaveDaysFirstMonth := NoOfLeaveDaysFirstMonth - (PublicHolidays + WeeklyOffDays);
                    CLEAR(WeeklyOffDays);
                    CLEAR(PublicHolidays);

                    EmployeeInterimAccrualLines.RESET;
                    EmployeeInterimAccrualLines.SETRANGE("Accrual ID", AccrualComponentEmployee."Accrual ID");
                    EmployeeInterimAccrualLines.SETRANGE("Worker ID", AccrualComponentEmployee."Worker ID");
                    EmployeeInterimAccrualLines.SETRANGE("Start Date", CALCDATE('-CM', EffectiveStartDate));
                    if EmployeeInterimAccrualLines.FINDFIRST then begin
                        EmployeeInterimAccrualLines."Leaves Consumed Units" -= NoOfLeaveDaysFirstMonth;
                        EmployeeInterimAccrualLines.MODIFY;
                    end;

                    Period.RESET;
                    Period.SETRANGE("Period Type", Period."Period Type"::Date);
                    Period.SETRANGE("Period Start", CALCDATE('-CM', EffectiveEndDate), EffectiveEndDate);
                    if Period.FINDFIRST then
                        NoOfLeaveDaysSecondMonth := Period.COUNT;
                    if LeaveType."Exc Public Holidays" then begin
                        EmployeeEarngCodeGrp.RESET;
                        EmployeeEarngCodeGrp.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                        EmployeeEarngCodeGrp.SETRANGE("Employee Code", EmployeeNo);
                        EmployeeEarngCodeGrp.SETFILTER("Valid From", '<=%1', EffectiveEndDate);
                        EmployeeEarngCodeGrp.SETFILTER("Valid To", '>=%1|%2', EffectiveEndDate, 0D);
                        if EmployeeEarngCodeGrp.FINDLAST then begin
                            WorkCalendarDate.RESET;
                            WorkCalendarDate.SETRANGE("Calendar ID", EmployeeEarngCodeGrp.Calander);
                            WorkCalendarDate.SETRANGE("Trans Date", CALCDATE('-CM', EffectiveEndDate), EffectiveEndDate);
                            WorkCalendarDate.SETRANGE("Calculation Type", WorkCalendarDate."Calculation Type"::"Public Holiday");
                            if WorkCalendarDate.FINDFIRST then
                                PublicHolidays := WorkCalendarDate.COUNT;
                        end;
                    end;

                    if LeaveType."Exc Week Offs" then begin
                        EmployeeEarngCodeGrp.RESET;
                        EmployeeEarngCodeGrp.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                        EmployeeEarngCodeGrp.SETRANGE("Employee Code", EmployeeNo);
                        EmployeeEarngCodeGrp.SETFILTER("Valid From", '<=%1', EffectiveEndDate);
                        EmployeeEarngCodeGrp.SETFILTER("Valid To", '>=%1|%2', EffectiveEndDate, 0D);
                        if EmployeeEarngCodeGrp.FINDLAST then begin
                            WorkCalendarDate.RESET;
                            WorkCalendarDate.SETRANGE("Calendar ID", EmployeeEarngCodeGrp.Calander);
                            WorkCalendarDate.SETRANGE("Trans Date", CALCDATE('-CM', EffectiveEndDate), EffectiveEndDate);
                            WorkCalendarDate.SETRANGE("Calculation Type", WorkCalendarDate."Calculation Type"::"Weekly Off");
                            if WorkCalendarDate.FINDFIRST then
                                WeeklyOffDays := WorkCalendarDate.COUNT;
                        end;
                    end;

                    NoOfLeaveDaysSecondMonth := NoOfLeaveDaysSecondMonth - (WeeklyOffDays + PublicHolidays);
                    EmployeeInterimAccrualLines.RESET;
                    EmployeeInterimAccrualLines.SETRANGE("Accrual ID", AccrualComponentEmployee."Accrual ID");
                    EmployeeInterimAccrualLines.SETRANGE("Worker ID", AccrualComponentEmployee."Worker ID");
                    EmployeeInterimAccrualLines.SETRANGE("Start Date", CALCDATE('-CM', EffectiveEndDate));
                    if EmployeeInterimAccrualLines.FINDFIRST then begin
                        EmployeeInterimAccrualLines."Leaves Consumed Units" -= NoOfLeaveDaysSecondMonth;
                        EmployeeInterimAccrualLines.MODIFY;
                    end;
                end;
            end
            else begin
                EmployeeInterimAccrualLines.RESET;
                EmployeeInterimAccrualLines.SETRANGE("Accrual ID", AccrualComponentEmployee."Accrual ID");
                EmployeeInterimAccrualLines.SETRANGE("Worker ID", AccrualComponentEmployee."Worker ID");
                EmployeeInterimAccrualLines.SETRANGE("Start Date", CALCDATE('-CM', EffectiveEndDate));
                if EmployeeInterimAccrualLines.FINDFIRST then begin
                    EmployeeInterimAccrualLines."Leaves Consumed Units" -= LeaveDays;
                    EmployeeInterimAccrualLines.MODIFY;
                end;
            end;
        end;
    end;

    procedure CheckAccrualLeavesBalance(EmployeeNo: Code[20]; LeaveID: Code[20]; EffectiveStartDate: Date; EffectiveEndDate: Date; EarningCodeGroup: Code[20]; AccrualID: Code[20]; LeaveDays: Decimal);
    var
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        LeaveType: Record "HCM Leave Types Wrkr";
        AccrualComponentEmployee: Record "Accrual Components Employee";
        NoOfLeaveDaysFirstMonth: Decimal;
        NoOfLeaveDaysSecondMonth: Decimal;
        Period: Record Date;
        EmployeeEarngCodeGrp: Record "Employee Earning Code Groups";
        WorkCalendarDate: Record "Work Calendar Date";
        PublicHolidays: Integer;
        WeeklyOffDays: Integer;
        EmployeeWorkDate: Record EmployeeWorkDate_GCC;
        AppliedLeaves: Decimal;
    begin
        Period.RESET;
        Period.SETRANGE("Period Type", Period."Period Type"::Month);
        Period.SETRANGE("Period Start", CALCDATE('-CM', EffectiveStartDate), CALCDATE('CM', EffectiveEndDate));
        if Period.FINDFIRST then
            repeat
                CLEAR(AppliedLeaves);
                LeaveType.RESET;
                LeaveType.SETRANGE(LeaveType.Worker, EmployeeNo);
                LeaveType.SETRANGE("Leave Type Id", LeaveID);
                LeaveType.SETRANGE("Earning Code Group", EarningCodeGroup);
                if LeaveType.FINDFIRST then;

                EmployeeWorkDate.RESET;
                EmployeeWorkDate.SETRANGE("Employee Code", EmployeeNo);
                EmployeeWorkDate.SETRANGE("First Half Leave Type", LeaveType."Leave Type Id");
                EmployeeWorkDate.SETRANGE("Trans Date", Period."Period Start", NORMALDATE(Period."Period End"));
                if EmployeeWorkDate.FINDFIRST then
                    AppliedLeaves += EmployeeWorkDate.COUNT;

                EmployeeWorkDate.RESET;
                EmployeeWorkDate.SETRANGE("Employee Code", EmployeeNo);
                EmployeeWorkDate.SETRANGE("Second Half Leave Type", LeaveType."Leave Type Id");
                EmployeeWorkDate.SETRANGE("Trans Date", Period."Period Start", NORMALDATE(Period."Period End"));
                if EmployeeWorkDate.FINDFIRST then
                    AppliedLeaves += EmployeeWorkDate.COUNT;

                if AppliedLeaves <> 0 then
                    AppliedLeaves := AppliedLeaves / 2;

                EmployeeInterimAccrualLines.RESET;
                EmployeeInterimAccrualLines.SETRANGE("Accrual ID", LeaveType."Accrual ID");
                EmployeeInterimAccrualLines.SETRANGE("Worker ID", EmployeeNo);
                EmployeeInterimAccrualLines.SETRANGE("Start Date", Period."Period Start");
                if EmployeeInterimAccrualLines.FINDFIRST then begin
                    if not LeaveType."Allow Negative" then
                        if EmployeeInterimAccrualLines."Closing Balance" < AppliedLeaves + LeaveDays then
                            ERROR('You donot have enough balance of leaves');
                end;
            until Period.NEXT = 0;
    end;

    procedure ValidateAdjustmentLeaves(EmployeeNo: Code[20]; LeaveID: Code[20]; EffectiveStartDate: Date; EffectiveEndDate: Date; EarningCodeGroup: Code[20]; AccrualID: Code[20]; LeaveDays: Decimal);
    var
        AccrualComponentEmployee: Record "Accrual Components Employee";
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        LeaveType: Record "HCM Leave Types Wrkr";
    begin
        LeaveType.RESET;
        LeaveType.SETRANGE(LeaveType.Worker, EmployeeNo);
        LeaveType.SETRANGE("Leave Type Id", LeaveID);
        LeaveType.SETRANGE("Earning Code Group", EarningCodeGroup);
        if LeaveType.FINDFIRST then;

        AccrualComponentEmployee.RESET;
        AccrualComponentEmployee.SETRANGE("Worker ID", EmployeeNo);
        AccrualComponentEmployee.SETRANGE("Accrual ID", LeaveType."Accrual ID");
        if AccrualComponentEmployee.FINDFIRST then begin
            EmployeeInterimAccrualLines.RESET;
            EmployeeInterimAccrualLines.SETRANGE("Accrual ID", AccrualComponentEmployee."Accrual ID");
            EmployeeInterimAccrualLines.SETRANGE("Worker ID", AccrualComponentEmployee."Worker ID");
            EmployeeInterimAccrualLines.SETRANGE("Start Date", CALCDATE('-CM', EffectiveEndDate));
            if EmployeeInterimAccrualLines.FINDFIRST then begin
                EmployeeInterimAccrualLines."Adjustment Units" := LeaveDays;
                EmployeeInterimAccrualLines.MODIFY;
            end;
        end;
    end;

    procedure ValidateOpeningBalanceLeaves(EmployeeNo: Code[20]; LeaveID: Code[20]; EffectiveStartDate: Date; EffectiveEndDate: Date; EarningCodeGroup: Code[20]; AccrualID: Code[20]; LeaveDays: Decimal);
    var
        AccrualComponentEmployee: Record "Accrual Components Employee";
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        LeaveType: Record "HCM Leave Types Wrkr";
    begin
        LeaveType.RESET;
        LeaveType.SETRANGE(LeaveType.Worker, EmployeeNo);
        LeaveType.SETRANGE("Leave Type Id", LeaveID);
        LeaveType.SETRANGE("Earning Code Group", EarningCodeGroup);
        if LeaveType.FINDFIRST then;

        AccrualComponentEmployee.RESET;
        AccrualComponentEmployee.SETRANGE("Worker ID", EmployeeNo);
        AccrualComponentEmployee.SETRANGE("Accrual ID", LeaveType."Accrual ID");
        if AccrualComponentEmployee.FINDFIRST then begin
            EmployeeInterimAccrualLines.RESET;
            EmployeeInterimAccrualLines.SETRANGE("Accrual ID", AccrualComponentEmployee."Accrual ID");
            EmployeeInterimAccrualLines.SETRANGE("Worker ID", AccrualComponentEmployee."Worker ID");
            EmployeeInterimAccrualLines.SETRANGE("Start Date", CALCDATE('-CM', EffectiveEndDate));
            if EmployeeInterimAccrualLines.FINDFIRST then begin
                EmployeeInterimAccrualLines."Opening Balance Unit" := LeaveDays;
                EmployeeInterimAccrualLines.MODIFY;
            end;
        end;
    end;
}