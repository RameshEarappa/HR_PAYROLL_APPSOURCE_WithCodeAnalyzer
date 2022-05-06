codeunit 60003 "Update Employee Workdate"
{
    trigger OnRun();
    begin
        EmployeeWorkDate.RESET;
        EmployeeWorkDate.SETRANGE("First Half Leave Type", 'PRESENT');
        EmployeeWorkDate.SETRANGE("Second Half Leave Type", 'PRESENT');
        if EmployeeWorkDate.FINDFIRST then
            repeat
                EmployeeWorkDate."First Half Leave Type" := 'PR';
                EmployeeWorkDate."Second Half Leave Type" := 'PR';
                EmployeeWorkDate.MODIFY;
            until EmployeeWorkDate.NEXT = 0;
        MESSAGE('Done');
    end;

    var
        EmployeeWorkDate: Record EmployeeWorkDate_GCC;
}