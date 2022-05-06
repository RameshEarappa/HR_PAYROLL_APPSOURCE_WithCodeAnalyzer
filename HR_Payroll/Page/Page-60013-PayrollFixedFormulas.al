page 60013 "Payroll Fixed Formulas"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Payroll Formula";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Formula Key"; Rec."Formula Key")
                {
                    ApplicationArea = All;
                }
                field("Formula description"; Rec."Formula description")
                {
                    ApplicationArea = All;
                }
                field("Formula Key Type"; Rec."Formula Key Type")
                {
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = All;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Options)
            {
                Caption = 'Options';
                Image = Departments;
                action("Generate default formulas")
                {
                    ApplicationArea = All;
                    Image = ImportCodes;

                    trigger OnAction()
                    begin
                        InsertDefaultFormulas;
                        MESSAGE('Default Formulas Generated');
                    end;
                }
            }
        }
    }

    var
        PayrollFormula: Record "Payroll Formula";

    procedure InsertDefaultFormulas()
    begin
        FixedFormula('P_PeriodEndDate', 'Payroll period end date.', 0);
        FixedFormula('P_PeriodEndDateMonth', 'Payroll period end date - month', 0);
        FixedFormula('P_PeriodEndDateYear', 'Payroll period end date - year', 0);
        FixedFormula('P_PeriodStartDate', 'Payroll period start date', 0);
        FixedFormula('P_PeriodStartDateMonth', 'Payroll period start date - month', 0);
        FixedFormula('P_PeriodStartDateYear', 'Payroll period start date - year', 0);
        FixedFormula('P_ProbationEndDate', 'Employee probation period end date', 0);
        FixedFormula('P_ProbationStartDate', 'Employee probation period start date', 0);
        FixedFormula('P_ProRataDays', 'Employee pro rata days', 0);
        FixedFormula('P_SeparationDate', 'Employee separation date', 0);
        FixedFormula('P_SeparationMonth', 'Employee separation Month', 0);
        FixedFormula('P_SeparationYear', 'Employee separation Year', 0);
        FixedFormula('P_SeparationReason', 'Employee separation reason', 0);
        FixedFormula('P_ServiceDays', 'Employee service days, employment start date and payroll period end date', 0);
        FixedFormula('P_CountOfPublicHoliday', 'Total number of public holidays in payroll period', 0);
        FixedFormula('P_CountOfPublicHolidayInPresentPeriod', 'Total number of public holidays in payroll period present days', 0);
        FixedFormula('P_CountOfWeeklyOff', 'Total number of weekly off holidays in payroll period.', 0);
        FixedFormula('P_CountOfWeeklyOffInPresentPeriod', 'Total number of weekly off in payroll period present days', 0);
        FixedFormula('P_DaysInPeriod', 'Total number of days in payroll period', 0);
        FixedFormula('P_TotalNoOfWorkingHours', 'Total number Of working hours in the period', 0);
        FixedFormula('P_WOT1', 'WOT1', 0);
        FixedFormula('P_WOT2', 'WOT2', 0);
        FixedFormula('P_WOT3', 'WOT3', 0);
        FixedFormula('P_EmployeeBirthDate', 'Employee birth date', 0);
        FixedFormula('P_EmployeeJoinDate', 'Employee joining Date', 0);
        FixedFormula('P_EmployeeJoinDateMonth', 'Employee joining date - month', 0);
        FixedFormula('P_EmployeeJoinDateYear', 'Employee joining date - year', 0);
        FixedFormula('P_EmployeeStatus', 'Employee status', 0);
        FixedFormula('P_FinancialYearEndDate', 'Financial year end date', 0);
        FixedFormula('P_FinancialYearStartDate', 'Financial year start date', 0);
        FixedFormula('P_CalendarYearEndDate', 'Calendar year end date', 0);
        FixedFormula('P_CalendarYearStartDate', 'Calendar year start date', 0);
        FixedFormula('P_CalendarYearDays', 'Total number of calendar year days', 0);
        FixedFormula('P_PayrollCalcYearDays', 'Total number of payroll calculation year days', 0);
        FixedFormula('P_AnnualSalary', 'Employee annual salary', 0);
        FixedFormula('P_CalendarYearWorkingDays', 'Total number of calendar year working days', 0);
        FixedFormula('P_PayrollCalcYearDaysExcPH', 'Total number of payroll calculation year days excluding public holidays', 0);
        FixedFormula('P_PayrollCalcYearWorkingDays', 'Total number of payroll calculation year working days', 0);
        FixedFormula('P_PayrollCalcMonthDays', 'Total number of payroll calculation month days', 0);
        FixedFormula('P_AdultTicketFare', 'Employee adult ticket fare', 0);
        FixedFormula('P_InfantTicketFare', 'Employee infant ticket fare', 0);
        FixedFormula('P_ChildTicketFare', 'Employee Child ticket fare', 0);
        FixedFormula('P_DaysInPeriodInclStopDays', 'Total number of days including stop days in payroll period', 0);
        FixedFormula('P_DaysInPayCyclePeriod', 'Total number of days in pay cycle period', 0);
        FixedFormula('P_EmployeeGender', 'Gender of employee', 0);
        FixedFormula('P_EmployeeMaritalStatus', 'Marital status of employee', 0);
        FixedFormula('P_EmployeeGender', 'Gender of employee', 0);
        FixedFormula('P_OvertimeHrsWeeklyOff', 'Overtime hours worked in pay period - Weekly off', 0);
        FixedFormula('P_OvertimeHrsPublicHoliday', 'Overtime hours worked in pay period - Public holiday', 0);
        FixedFormula('P_OvertimeHrsWorkingDay', 'Overtime hours worked in pay period - Working day', 0);
        FixedFormula('P_NormalHrs', 'Normal hours worked in pay period', 0);
        FixedFormula('P_StandardWorkHrs', 'Standard work hours per day in calendar', 0);
        FixedFormula('P_EmployeeNationality', 'Nationality of employee', 0);
        FixedFormula('P_Social', 'Social consideration for married', 0);
        FixedFormula('P_Bridging', 'Bridging consideration for married', 0);
        FixedFormula('P_Housing', 'Housing consideration for married', 0);
        FixedFormula('P_ServiceMonths', 'Employee service months, employment start date and payroll period end date', 0);
        FixedFormula('P_EmployeeNationality', 'Nationality of employee', 0);
        FixedFormula('P_CalendarYearWorkingDaysPH', 'Calendar year working days and public holidays', 0);
        FixedFormula('P_COLR', 'Cost Of Living for Employee', 0);
        FixedFormula('P_CHILDCOUNT', 'Count Of Children', 0);
        FixedFormula('P_ChildBelow12', 'Count of Children Below 12 Years', 0);
        FixedFormula('P_ChildAbove12', 'Count of Children Above 12 Years', 0);
        FixedFormula('P_ChildBelow2', 'Count of Children Below 2 Years', 0);
        FixedFormula('P_SPOUSECOUNT', 'Count of Spuses', 0);
        FixedFormula('P_CountOfFemaleMarriedChild', 'Count of Depended Female Child Marital Status', 0);
        FixedFormula('P_PeriodAccruedUnits', 'Employee Period Accrued Units from Interim accruals', 0);
        FixedFormula('P_TotalAbsenceHours', 'Employee Total Absent Hours for the period', 0);
        FixedFormula('P_PermissibleABHrs', 'Employee Permissible Absent Hours', 0);
        FixedFormula('P_SERVICEYEARS', 'Employee Service Years', 0);
        FixedFormula('P_UNSATISFACTORY_PERF_SERYRS', 'No Of Years Unsatisfactory Grade', 0);
        FixedFormula('P_LEAVEENCASHMENTUNITS', 'Full and Final Settlement Leave Encashment Units', 0);
    end;

    procedure FixedFormula(FormulaKey: Code[100]; FormulaDescription: Text[250]; FormulaKeyType: Option Parameter,"Pay Component",Benefit,"Leave Type",Custom)
    begin
        if FormulaKey <> '' then begin
            if not PayrollFormula.GET(FormulaKey) then begin
                PayrollFormula.INIT;
                PayrollFormula."Formula Key" := FormulaKey;
                PayrollFormula."Formula description" := FormulaDescription;
                PayrollFormula."Formula Key Type" := FormulaKeyType;
                PayrollFormula.INSERT;
            end;
        end;
    end;
}