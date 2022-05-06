codeunit 60011 "Assign Primary Pos. Batch Job"
{

    trigger OnRun();
    begin
        Employee.RESET;
        if Employee.FINDFIRST then begin
            repeat
                PayrollJobPosWorkerAssign.RESET;
                PayrollJobPosWorkerAssign.SETRANGE(Worker, Employee."No.");
                if PayrollJobPosWorkerAssign.FINDFIRST then
                    repeat
                        if (PayrollJobPosWorkerAssign."Effective Start Date" <= WORKDATE) and
                           ((PayrollJobPosWorkerAssign."Effective End Date" >= WORKDATE) or (PayrollJobPosWorkerAssign."Effective End Date" = 0D)) then
                            PayrollJobPosWorkerAssign."Is Primary Position" := true
                        else
                            PayrollJobPosWorkerAssign."Is Primary Position" := false;
                        PayrollJobPosWorkerAssign.MODIFY;
                    until PayrollJobPosWorkerAssign.NEXT = 0;
            until Employee.NEXT = 0;
        end;
    end;

    var
        PayrollJobPosWorkerAssign: Record "Payroll Job Pos. Worker Assign";
        Employee: Record Employee;
}