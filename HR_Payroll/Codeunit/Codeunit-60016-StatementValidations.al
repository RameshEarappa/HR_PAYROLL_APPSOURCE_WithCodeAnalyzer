codeunit 60016 "Statement Validations"
{
    local procedure CheckValidations(StatementID: Code[20]);
    var
        PayrollStatementEmployee: Record "Payroll Statement Employee";
        EmployeeWorkDate_GCC: Record EmployeeWorkDate_GCC;
        Employee: Record Employee;
    begin
        PayrollStatementEmployee.RESET;
        PayrollStatementEmployee.SETRANGE("Payroll Statement ID", StatementID);
        if PayrollStatementEmployee.FINDSET then
            repeat

                Employee.RESET;
                Employee.SETRANGE("No.", PayrollStatementEmployee.Worker);
                if Employee.FINDFIRST then begin
                end else
                    ERROR('Not a valid employee %1', PayrollStatementEmployee.Worker);

                EmployeeWorkDate_GCC.RESET;
                EmployeeWorkDate_GCC.SETRANGE("Employee Code", PayrollStatementEmployee.Worker);
                EmployeeWorkDate_GCC.SETRANGE("Trans Date", PayrollStatementEmployee."Pay Period Start Date");
                if not EmployeeWorkDate_GCC.FINDFIRST then
                    ERROR('Payperiod start not matches with employee %1', EmployeeWorkDate_GCC."Employee Code");

                EmployeeWorkDate_GCC.RESET;
                EmployeeWorkDate_GCC.SETRANGE("Employee Code", PayrollStatementEmployee.Worker);
                EmployeeWorkDate_GCC.SETRANGE("Trans Date", PayrollStatementEmployee."Pay Period End Date");
                if not EmployeeWorkDate_GCC.FINDFIRST then
                    ERROR('Payperiod End not matches with employee %1', EmployeeWorkDate_GCC."Employee Code");
            until PayrollStatementEmployee.NEXT = 0;
    end;
}