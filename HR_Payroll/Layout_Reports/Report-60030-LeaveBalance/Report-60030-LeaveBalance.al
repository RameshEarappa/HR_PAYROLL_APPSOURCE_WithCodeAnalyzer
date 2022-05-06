report 60030 "Leave Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'HR_Payroll\Layout_Reports\Report-60030-LeaveBalance\leavebalance.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(EmployeeID; Employee."No.")
            {
            }
            column(EmployeeIDCaption; EmployeeIDCaption)
            {
            }
            column(EmployeeName; Employee."First Name" + Employee."Middle Name" + Employee."Last Name")
            {
            }
            column(EmployeeNameCaption; EmployeeNameCaption)
            {
            }
            column(EmployeeDepartment; Employee.Department)
            {
            }
            column(DepartmentCaption; DepartmentCaption)
            {
            }
            column(LeaveBalanceCaption; LeaveBalanceCaption)
            {
            }
            column(CompName; CompanyInformation.Name)
            {
            }
            column(FiltersValue; PayPeriodCode)
            {
            }
            column(CompLogo; CompanyInformation.Picture)
            {
            }
            dataitem(EmployeeAccurals; "Employee Interim Accurals")
            {
                DataItemLink = "Worker ID" = FIELD("No.");
                DataItemTableView = SORTING("Accrual ID", "Worker ID", "Line No.");
                column(LeaveBalance; EmployeeAccurals."Closing Balance")
                {
                }
                column(EmpID; EmployeeAccurals."Worker ID")
                {
                }

                trigger OnPreDataItem();
                begin
                    EmployeeAccurals.SETRANGE("Accrual ID", AccrualID);
                    EmployeeAccurals.SETRANGE("Start Date", PayPeriodStartDate);
                    EmployeeAccurals.SETRANGE("End Date", PayPeriodEndDate);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                EmployeeEarningCodeGroupsRecG.RESET;
                EmployeeEarningCodeGroupsRecG.SETRANGE("Valid To", 0D);
                EmployeeEarningCodeGroupsRecG.SETRANGE("Employee Code", "No.");
                if EmployeeEarningCodeGroupsRecG.FINDFIRST then begin
                    HCMLeaveTypesWrkrRecG.RESET;
                    HCMLeaveTypesWrkrRecG.SETRANGE(Accrued, true);
                    HCMLeaveTypesWrkrRecG.SETRANGE(Worker, EmployeeEarningCodeGroupsRecG."Employee Code");
                    if HCMLeaveTypesWrkrRecG.FINDFIRST then
                        AccrualID := HCMLeaveTypesWrkrRecG."Accrual ID";
                end;
            end;
        }
    }

    requestpage
    {
        SourceTable = "Pay Cycles";

        layout
        {
            area(content)
            {
                field("Pay Cycle"; PayCycleCode)
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
                        PayPeriodRec.SETRANGE("Pay Cycle", PayCycleCode);
                        if PAGE.RUNMODAL(PAGE::"Pay Periods List", PayPeriodRec) = ACTION::LookupOK then begin
                            PayPeriodCode := PayPeriodRec.Month + ' ' + FORMAT(PayPeriodRec.Year);
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



    trigger OnPreReport();
    begin
        if CompanyInformation.GET then
            CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        EmployeeIDCaption: Label 'Employee ID';
        EmployeeNameCaption: Label 'Employee Name';
        DepartmentCaption: Label 'Department';
        LeaveBalanceCaption: Label 'Annual leave days balance';
        CompanyInformation: Record "Company Information";
        AccrualID: Code[30];
        StartDate: Date;
        EndDate: Date;
        PayPeriod: Record "Pay Periods";
        FiltersValue: Code[100];
        PayCycleCode: Code[50];
        PayPeriodCode: Code[50];
        PayPeriodStartDate: Date;
        PayPeriodEndDate: Date;
        PayPeriodRec: Record "Pay Periods";
        PayMonthCode: Code[50];
        PayYear: Integer;
        PayMonth: Code[50];
        EmployeeEarningCodeGroupsRecG: Record "Employee Earning Code Groups";
        HCMLeaveTypesWrkrRecG: Record "HCM Leave Types Wrkr";
}