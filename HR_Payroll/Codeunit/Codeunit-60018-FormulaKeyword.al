codeunit 60018 "Formula Keyword"
{
    var
        PayCycle: Record "Pay Cycles";
        PayPeriod: Record "Pay Periods";

    procedure P_PeriodEndDate(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer): Date;
    var
        PayPeriod: Record "Pay Periods";
        PayCycle: Record "Pay Cycles";
    begin
        PayPeriod.RESET;
        PayPeriod.SETRANGE("Pay Cycle", PayrollPayCycleRecId);
        PayPeriod.SETRANGE("Line No.", PayrollPayPeriodRecId);
        if PayPeriod.FINDFIRST then
            exit(NORMALDATE(PayPeriod."Period End Date"))
        else
            exit(0D);
    end;

    procedure P_PeriodEndDateMonth(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer): Integer;
    begin
        PayPeriod.RESET;
        PayPeriod.SETRANGE("Pay Cycle", PayrollPayCycleRecId);
        PayPeriod.SETRANGE("Line No.", PayrollPayPeriodRecId);
        if PayPeriod.FINDFIRST then
            exit(DATE2DMY(PayPeriod."Period End Date", 2))
        else
            exit(0);
    end;

    procedure P_PeriodEndDateYear(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer): Integer;
    begin
        PayPeriod.RESET;
        PayPeriod.SETRANGE("Pay Cycle", PayrollPayCycleRecId);
        PayPeriod.SETRANGE("Line No.", PayrollPayPeriodRecId);
        if PayPeriod.FINDFIRST then
            exit(DATE2DMY(PayPeriod."Period End Date", 3))
        else
            exit(0);
    end;

    procedure P_PeriodStartDate(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer): Date;
    begin
        PayPeriod.RESET;
        PayPeriod.SETRANGE("Pay Cycle", PayrollPayCycleRecId);
        PayPeriod.SETRANGE("Line No.", PayrollPayPeriodRecId);
        if PayPeriod.FINDFIRST then
            exit(NORMALDATE(PayPeriod."Period Start Date"))
        else
            exit(0D);
    end;

    procedure P_PeriodStartDateMonth(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer): Integer;
    begin
        PayPeriod.RESET;
        PayPeriod.SETRANGE("Pay Cycle", PayrollPayCycleRecId);
        PayPeriod.SETRANGE("Line No.", PayrollPayPeriodRecId);
        if PayPeriod.FINDFIRST then
            exit(DATE2DMY(PayPeriod."Period Start Date", 2))
        else
            exit(0);
    end;

    procedure P_PeriodStartDateYear(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer): Integer;
    begin
        PayPeriod.RESET;
        PayPeriod.SETRANGE("Pay Cycle", PayrollPayCycleRecId);
        PayPeriod.SETRANGE("Line No.", PayrollPayPeriodRecId);
        if PayPeriod.FINDFIRST then
            exit(DATE2DMY(PayPeriod."Period Start Date", 3))
        else
            exit(0);
    end;

    procedure P_ProbationEndDate(HcmWorkerRecId: Code[20]): Date;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Employment End Date" <> 0D then
            exit(NORMALDATE(Employee."Employment End Date"))
        else
            exit(0D);
    end;

    procedure P_ProbationStartDate(HcmWorkerRecId: Code[20]): Date;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Employment Date" <> 0D then
            exit(NORMALDATE(Employee."Employment Date"))
        else
            exit(0D);
    end;

    procedure P_ProRataDays(HcmWorkerRecId: Code[20]): Integer;
    var
        Employee: Record Employee;
    begin
    end;

    procedure P_SeparationDate(HcmWorkerRecId: Code[20]): Date;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Employment End Date" <> 0D then
            exit(Employee."Employment End Date")
        else
            exit(19000101D);
    end;

    procedure P_SeparationReason(HcmWorkerRecId: Code[20]): Integer;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Seperation Reason" <> '' then
            exit(Employee."Seperation Reason Code")
        else
            exit(0);
    end;

    procedure P_ServiceDays(HcmWorkerRecId: Code[20]; PeriodEndDate: Date): Integer;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if (Employee."Employment End Date" <> 0D) then
            exit((Employee."Employment End Date" - Employee."Joining Date") + 1)
        else
            exit((PeriodEndDate - Employee."Joining Date") + 1)
    end;

    procedure P_EMPLOYEENATIONALITY(HcmWorkerRecId: Code[20]): Code[150];
    var
        Employee: Record Employee;
    begin
        Employee.Reset();
        if Employee.GET(HcmWorkerRecId) then
            exit(Employee."Emp National Code");
    end;

    procedure P_LEAVEENCASHMENTUNITS(FromDate: Date;
    ToDate: Date;
    HcmWorkerRecId: Code[20];
    l_FandFJournal: Record "Full and Final Calculation"): Decimal;
    var
        EmployeeInterimAccruals: Record "Employee Interim Accurals";
        LeaveCalcDays: Decimal;
        TerminationDays: Decimal;
    begin
        EmployeeInterimAccruals.RESET;
        EmployeeInterimAccruals.SETRANGE("Worker ID", HcmWorkerRecId);
        EmployeeInterimAccruals.SETRANGE("Start Date", FromDate, ToDate);
        if EmployeeInterimAccruals.FINDLAST then begin
            CLEAR(TerminationDays);
            TerminationDays := l_FandFJournal."Termination Date" - CALCDATE('-CM', l_FandFJournal."Termination Date");

            CLEAR(LeaveCalcDays);
            LeaveCalcDays := ROUND(EmployeeInterimAccruals."Opening Balance Unit" + ((EmployeeInterimAccruals."Monthly Accrual Units" / (CALCDATE('CM', l_FandFJournal."Termination Date") - CALCDATE('-CM', l_FandFJournal."Termination Date"))) * TerminationDays), 1, '=');

            exit(LeaveCalcDays);
        end;
    end;

    procedure P_TotalNoOfWorkingHours(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
        //To do method not defined yet
    end;

    procedure P_WOT1(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
        //To do method not defined yet
    end;

    procedure P_WOT2(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
        //To do method not defined yet
    end;

    procedure P_WOT3(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
        //To do method not defined yet
    end;

    procedure P_CountOfPublicHoliday(HcmWorkerRecId: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    var
        EmployeeWorkDateRec: Record EmployeeWorkDate_GCC;
    begin
        EmployeeWorkDateRec.RESET;
        EmployeeWorkDateRec.SETRANGE("Employee Code", HcmWorkerRecId);
        EmployeeWorkDateRec.SETFILTER("Trans Date", '>=%1', FromDate);
        EmployeeWorkDateRec.SETFILTER("Trans Date", '<=%1', ToDate);
        EmployeeWorkDateRec.SETRANGE("Calculation Type", EmployeeWorkDateRec."Calculation Type"::"Public Holiday");
        if EmployeeWorkDateRec.FINDFIRST then
            exit(EmployeeWorkDateRec.COUNT)
        else
            exit(0);
    end;

    procedure P_CountOfPublicHolidayInPresentPeriod(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
    end;

    procedure P_CountOfWeeklyOff(HcmWorkerRecId: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    var
        EmployeeWorkDateRec: Record EmployeeWorkDate_GCC;
    begin
        EmployeeWorkDateRec.RESET;
        EmployeeWorkDateRec.SETRANGE("Employee Code", HcmWorkerRecId);
        EmployeeWorkDateRec.SETFILTER("Trans Date", '>=%1', FromDate);
        EmployeeWorkDateRec.SETFILTER("Trans Date", '<=%1', ToDate);
        EmployeeWorkDateRec.SETRANGE("Calculation Type", EmployeeWorkDateRec."Calculation Type"::"Weekly Off");
        if EmployeeWorkDateRec.FINDFIRST then
            exit(EmployeeWorkDateRec.COUNT)
        else
            exit(0);
    end;

    procedure P_CountOfWeeklyOffInPresentPeriod(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
    end;

    procedure P_DaysInPayCyclePeriod(HcmWorkerRecId: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    var
        EmployeeWorkDateRec: Record EmployeeWorkDate_GCC;
        PayPeriod: Record "Pay Periods";
    begin
        if (FromDate <> 0D) and (NORMALDATE(ToDate) <> 0D) then
            exit((NORMALDATE(ToDate) - FromDate) + 1)
        else
            exit(0);
    end;

    procedure P_EmployeeBirthDate(HcmWorkerRecId: Code[20]): Date;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Birth Date" <> 0D then
            exit(Employee."Birth Date")
        else
            exit(0D);
    end;

    procedure P_EmployeeJoinDate(HcmWorkerRecId: Code[20]): Date;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Joining Date" <> 0D then
            exit(Employee."Joining Date")
        else
            exit(0D);
    end;

    procedure P_EmployeeJoinDateMonth(HcmWorkerRecId: Code[20]): Integer;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Joining Date" <> 0D then
            exit(DATE2DMY(Employee."Joining Date", 2))
        else
            exit(0);
    end;

    procedure P_EmployeeJoinDateYear(HcmWorkerRecId: Code[20]): Integer;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Joining Date" <> 0D then
            exit(DATE2DMY(Employee."Joining Date", 3))
        else
            exit(0);
    end;

    procedure P_EmployeeStatus(HcmWorkerRecId: Code[20]): Integer;
    var
        Employee: Record Employee;
    begin
    end;

    procedure P_FinancialYearEndDate(FromDate: Date; ToDate: Date): Date;
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.RESET;
        AccountingPeriod.SETRANGE("New Fiscal Year", true);
        AccountingPeriod."Starting Date" := FromDate;
        if AccountingPeriod.FIND('=>') then begin
            exit(AccountingPeriod."Starting Date" - 1);
        end
        else begin
            AccountingPeriod.RESET;
            if AccountingPeriod.FINDLAST then
                exit(NORMALDATE(AccountingPeriod."Starting Date"));
        end;
    end;

    procedure P_FinancialYearStartDate(FromDate: Date; ToDate: Date): Date;
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.RESET;
        AccountingPeriod.SETRANGE("New Fiscal Year", true);
        AccountingPeriod."Starting Date" := FromDate;
        if AccountingPeriod.FIND('=<') then begin
            exit(NORMALDATE(AccountingPeriod."Starting Date"));
        end
        else begin
            AccountingPeriod.RESET;
            if AccountingPeriod.FINDFIRST then
                exit(NORMALDATE(AccountingPeriod."Starting Date"));
        end;
    end;

    procedure P_CalendarYearEndDate(ToDate: Date): Date;
    begin
        if ToDate <> 0D then
            exit(CALCDATE('CY', ToDate))
        else
            exit(0D);
    end;

    procedure P_CalendarYearStartDate(FromDate: Date): Date;
    begin
        if FromDate <> 0D then
            exit(CALCDATE('-CY', FromDate))
        else
            exit(0D);
    end;

    procedure P_CalendarYearDays(FromDate: Date; ToDate: Date): Integer;
    begin
        if (FromDate <> 0D) and (NORMALDATE(ToDate) <> 0D) then begin
            exit((CALCDATE('CY', NORMALDATE(ToDate)) - CALCDATE('-CY', FromDate)) + 1);
        end
        else
            exit(0);
    end;

    procedure P_CalendarYearWorkingDays(CalendarID: Code[20]; FromDate: Date; ToDate: Date): Integer;
    var
        WorkCalendarDate: Record "Work Calendar Date";
        WorkCalendarStartDate: Date;
        WorkCalendarEndDate: Date;
    begin
        WorkCalendarStartDate := CALCDATE('-CY', FromDate);
        WorkCalendarEndDate := CALCDATE('CY', ToDate);
        WorkCalendarDate.RESET;
        WorkCalendarDate.SETRANGE("Calendar ID", CalendarID);
        WorkCalendarDate.SETRANGE("Trans Date", WorkCalendarStartDate, WorkCalendarEndDate);
        WorkCalendarDate.SETRANGE("Calculation Type", WorkCalendarDate."Calculation Type"::"Working Day");
        if WorkCalendarDate.FINDFIRST then
            exit(WorkCalendarDate.COUNT)
        else
            exit(0);
    end;

    procedure P_PayrollCalcYearDays(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
    end;

    procedure P_PayrollCalcMonthDays(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
    end;

    procedure P_PayrollCalcYearDaysExcPH(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
    end;

    procedure P_PayrollCalcYearWorkingDays(HcmWorkerRecId: Code[20]; PayrollPayCycleRecId: Code[20]; PayrollPayPeriodRecId: Integer; FromDate: Date; ToDate: Date): Date;
    begin
    end;

    procedure P_AnnualSalary(HcmWorkerRecId: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    var
        Employee: Record Employee;
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
    begin
        Employee.GET(HcmWorkerRecId);
        EmployeeEarningCodeGroups.RESET;
        EmployeeEarningCodeGroups.SETRANGE("Employee Code", Employee."No.");
        EmployeeEarningCodeGroups.SETFILTER("Valid From", '<=%1', FromDate);
        EmployeeEarningCodeGroups.SETFILTER("Valid To", '>=%1|%2', ToDate, 0D);
        if EmployeeEarningCodeGroups.FINDFIRST then
            exit(EmployeeEarningCodeGroups."Gross Salary")
        else
            exit(0);
    end;

    procedure P_AdultTicketFare(HcmWorkerRecId: Code[20]): Decimal;
    VAR
        Sector: Record Sector;
        Employee: Record Employee;
    begin
        IF Employee.GET(HcmWorkerRecId) THEN BEGIN
            IF Employee."Sector ID" <> '' THEN BEGIN
                IF Sector.GET(Employee."Sector ID") THEN
                    EXIT(Sector."Economy Adult Ticket Fare")
                ELSE
                    EXIT(0);
            END
            ELSE
                EXIT(0);
        END;
    end;

    procedure P_InfantTicketFare(HcmWorkerRecId: Code[20]): Decimal;
    VAR
        Sector: Record Sector;
        Employee: Record Employee;
    begin
        IF Employee.GET(HcmWorkerRecId) THEN BEGIN
            IF Employee."Sector ID" <> '' THEN BEGIN
                IF Sector.GET(Employee."Sector ID") THEN
                    EXIT(Sector."Economy Infant Ticket Fare")
                ELSE
                    EXIT(0);
            END
            ELSE
                EXIT(0);
        END;
    end;

    procedure P_ChildTicketFare(HcmWorkerRecId: Code[20]): Decimal;
    VAR
        Sector: Record Sector;
        Employee: Record Employee;
    begin
        IF Employee.GET(HcmWorkerRecId) THEN BEGIN
            IF Employee."Sector ID" <> '' THEN BEGIN
                IF Sector.GET(Employee."Sector ID") THEN
                    EXIT(Sector."Economy Child Ticket Fare")
                ELSE
                    EXIT(0);
            END
            ELSE
                EXIT(0);
        END;
    end;

    procedure P_CostOfLiving(EmpID: Code[20]): Decimal;
    var
        Employee: Record Employee;
        EmployeeEarningCodes: Record "Payroll Earning Code Wrkr";
    begin
        Employee.GET(EmpID);
        EmployeeEarningCodes.RESET;
        EmployeeEarningCodes.SETRANGE(Worker, Employee."No.");
        EmployeeEarningCodes.SETRANGE("Pay Component Type", EmployeeEarningCodes."Pay Component Type"::"Cost of Living");
        if EmployeeEarningCodes.FINDFIRST then
            exit(EmployeeEarningCodes."Cost of Living Rate")
        else
            exit(0);
    end;

    procedure P_EmployeeMaritalStatus(EmpID: Code[20]): Text;
    var
        Employee: Record Employee;
    begin
        Employee.GET(EmpID);
        exit(Employee."Marital Status");
    end;

    procedure P_AdultCount(EmpID: Code[20]): Integer;
    var
        Employee: Record Employee;
        EmployeeDependent: Record "Employee Dependents Master";
    begin
        Employee.GET(EmpID);
        EmployeeDependent.RESET;
        EmployeeDependent.SETRANGE("Employee ID", Employee."No.");
    end;

    procedure P_ChildCount(EmpID: Code[20]): Integer;
    var
        Employee: Record Employee;
        EmployeeDependent: Record "Employee Dependents Master";
    begin
        Employee.GET(EmpID);
        EmployeeDependent.RESET;
        EmployeeDependent.SETRANGE("Employee ID", Employee."No.");
        EmployeeDependent.SETRANGE(Relationship, EmployeeDependent.Relationship::Child);
        if EmployeeDependent.FINDFIRST then
            exit(EmployeeDependent.COUNT)
        else
            exit(0);
    end;

    procedure P_ChildCountAgeLessThan12(EmpID: Code[20]): Integer;
    var
        Employee: Record Employee;
        EmployeeDependent: Record "Employee Dependents Master";
        ChildCount: Integer;
        Age: Decimal;
        NoOfDays: Integer;
    begin
        Employee.GET(EmpID);
        EmployeeDependent.RESET;
        EmployeeDependent.SETRANGE("Employee ID", Employee."No.");
        EmployeeDependent.SETRANGE(Relationship, EmployeeDependent.Relationship::Child);
        if EmployeeDependent.FINDFIRST then BEGIN
            REPEAT
                CLEAR(Age);
                CLEAR(NoOfDays);
                NoOfDays := TODAY() - EmployeeDependent."Date of Birth";
                Age := ROUND((NoOfDays / 365.27), 0.1);
                IF (Age >= 2) AND (Age <= 12) THEN
                    ChildCount += 1;
            UNTIL EmployeeDependent.Next() = 0;
            EXIT(ChildCount);
        END
        ELSE
            EXIT(0);
    end;

    procedure P_ChildCountAgeLessThan2(EmpID: Code[20]): Integer;
    var
        Employee: Record Employee;
        EmployeeDependent: Record "Employee Dependents Master";
        ChildCount: Integer;
        Age: Decimal;
        NoOfDays: Integer;
    begin
        Employee.GET(EmpID);
        EmployeeDependent.RESET;
        EmployeeDependent.SETRANGE("Employee ID", Employee."No.");
        EmployeeDependent.SETRANGE(Relationship, EmployeeDependent.Relationship::Child);
        if EmployeeDependent.FINDFIRST then BEGIN
            REPEAT
                CLEAR(Age);
                CLEAR(NoOfDays);
                NoOfDays := TODAY() - EmployeeDependent."Date of Birth";
                Age := ROUND((NoOfDays / 365.27), 0.1);
                IF Age <= 2 THEN
                    ChildCount += 1;
            UNTIL EmployeeDependent.Next() = 0;
            EXIT(ChildCount);
        END
        ELSE
            EXIT(0);
    end;

    procedure P_ChildCountAgeGreaterThan12(EmpID: Code[20]): Integer;
    var
        Employee: Record Employee;
        EmployeeDependent: Record "Employee Dependents Master";
        ChildCount: Integer;
        Age: Decimal;
        NoOfDays: Integer;
    begin
        Employee.GET(EmpID);
        EmployeeDependent.RESET;
        EmployeeDependent.SETRANGE("Employee ID", Employee."No.");
        EmployeeDependent.SETRANGE(Relationship, EmployeeDependent.Relationship::Child);
        if EmployeeDependent.FINDFIRST then BEGIN
            REPEAT
                CLEAR(Age);
                CLEAR(NoOfDays);
                NoOfDays := TODAY() - EmployeeDependent."Date of Birth";
                Age := ROUND((NoOfDays / 365.27), 0.1);
                IF Age > 12 THEN
                    ChildCount += 1;
            UNTIL EmployeeDependent.Next() = 0;
            EXIT(ChildCount);
        END
        ELSE
            EXIT(0);
    end;

    procedure P_COLR(HcmWorkerRecId: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    var
        Employee: Record Employee;
        EarningCodeEmp: Record "Payroll Earning Code Wrkr";
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
    begin
        Employee.GET(HcmWorkerRecId);
        EmployeeEarningCodeGroups.RESET;
        EmployeeEarningCodeGroups.SETRANGE("Employee Code", Employee."No.");
        EmployeeEarningCodeGroups.SETFILTER("Valid From", '<=%1', NORMALDATE(ToDate));
        EmployeeEarningCodeGroups.SETFILTER("Valid To", '>=%1|%2', NORMALDATE(ToDate), 0D);
        if EmployeeEarningCodeGroups.FINDFIRST then;

        EarningCodeEmp.RESET;
        EarningCodeEmp.SETRANGE(Worker, HcmWorkerRecId);
        EarningCodeEmp.SETRANGE("Earning Code Group", EmployeeEarningCodeGroups."Earning Code Group");
        EarningCodeEmp.SETRANGE("Pay Component Type", EarningCodeEmp."Pay Component Type"::"Cost of Living");
        if EarningCodeEmp.FINDFIRST then
            exit(EarningCodeEmp."Cost of Living Rate")
        else
            exit(0);
    end;

    procedure P_SpouseCount(EmpID: Code[20]): Integer;
    var
        Employee: Record Employee;
        EmployeeDependent: Record "Employee Dependents Master";
    begin
        Employee.GET(EmpID);
        EmployeeDependent.RESET;
        EmployeeDependent.SETRANGE("Employee ID", Employee."No.");
        EmployeeDependent.SETRANGE(Relationship, EmployeeDependent.Relationship::Spouse);
        if EmployeeDependent.FINDFIRST then
            exit(EmployeeDependent.COUNT)
        else
            exit(0);
    end;

    procedure P_CountOfFemaleMarriedChild(EmpID: Code[20]): Integer;
    var
        Employee: Record Employee;
        EmployeeDependent: Record "Employee Dependents Master";
    begin

        Employee.GET(EmpID);
        EmployeeDependent.RESET;
        EmployeeDependent.SETRANGE("Employee ID", Employee."No.");
        EmployeeDependent.SETRANGE(Relationship, EmployeeDependent.Relationship::Child);
        EmployeeDependent.SETRANGE("Marital Status", Employee."Marital Status");
        if EmployeeDependent.FINDFIRST then
            exit(EmployeeDependent.COUNT)
        else
            exit(0);
    end;

    procedure P_DaysInPeriod(HcmWorkerRecId: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    var
        EmployeeWorkDateRec: Record EmployeeWorkDate_GCC;
    begin
        EmployeeWorkDateRec.RESET;
        EmployeeWorkDateRec.SETRANGE("Employee Code", HcmWorkerRecId);
        EmployeeWorkDateRec.SETRANGE("Trans Date", FromDate, ToDate);
        if EmployeeWorkDateRec.FINDFIRST then
            exit(EmployeeWorkDateRec.COUNT)
        else
            exit(0);
    end;

    procedure P_PeriodAccruedUnits(Worker: Code[20]; StartDate: Date; EndDate: Date): Decimal;
    var
        Employee: Record Employee;
        EmployeeInterimAccruals: Record "Employee Interim Accurals";
    begin
        Employee.GET(Worker);
        EmployeeInterimAccruals.RESET;
        EmployeeInterimAccruals.SETRANGE("Worker ID", Employee."No.");
        EmployeeInterimAccruals.SETRANGE("Start Date", StartDate);
        EmployeeInterimAccruals.SETRANGE("End Date", EndDate);
        if EmployeeInterimAccruals.FINDFIRST then
            exit(EmployeeInterimAccruals."Monthly Accrual Units")
        else
            exit(0);
    end;

    procedure P_TotalAbsenceHours(Worker: Code[20]; StartDate: Date; EndDate: Date): Decimal;
    var
        Employee: Record Employee;
        TimeAttendance: Record "Time Attendance";
    begin
        Employee.GET(Worker);
        TimeAttendance.RESET;
        TimeAttendance.SETCURRENTKEY("Employee ID", Date, Confirmed);
        TimeAttendance.SETRANGE("Employee ID", Worker);
        TimeAttendance.SETRANGE(Date, StartDate, EndDate);
        TimeAttendance.SETRANGE(Confirmed, true);
        TimeAttendance.CALCSUMS("Absent Hours");
        exit(TimeAttendance."Absent Hours");
    end;

    procedure P_PermissibleABHrs(): Decimal;
    var
        HRSetup: Record "Human Resources Setup";
    begin
        HRSetup.GET;
        exit(HRSetup."Permissible Short Leave Hrs");
    end;

    procedure P_SERVICEYEARS(HcmWorkerRecId: Code[20]; PeriodEndDate: Date): Decimal;
    var
        Employee: Record Employee;
        Period: Record Date;
        ServiceYears: Decimal;
    begin
        Employee.GET(HcmWorkerRecId);
        ServiceYears := ((PeriodEndDate - Employee."Joining Date") + 1) / 365;
        exit(ROUND(ServiceYears, 0.01));
    end;

    procedure P_SeparationMonth(HcmWorkerRecId: Code[20]): Integer;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Employment End Date" <> 0D then
            exit(DATE2DMY(Employee."Employment End Date", 2))
        else
            exit(0);
    end;

    procedure P_UNSATISFACTORY_PERF_SERYRS(HcmWorkerRecId: Code[20]): Integer;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        exit(Employee."Unsatisfactory Grade");
    end;

    procedure P_ServiceDaysFandF(HcmWorkerRecId: Code[20]; PeriodEndDate: Date): Integer;
    var
        Employee: Record Employee;
    begin
        Employee.GET(HcmWorkerRecId);
        if Employee."Employment End Date" <> 0D then
            exit((Employee."Employment End Date" - Employee."Joining Date") + 1)
        else
            exit((PeriodEndDate - Employee."Joining Date") + 1)
    end;
}