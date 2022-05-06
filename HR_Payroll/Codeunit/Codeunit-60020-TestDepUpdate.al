codeunit 61011 "Test Dep Update"
{
    trigger OnRun();
    begin
        EmployeeDependentsMaster.RESET;
        if EmployeeDependentsMaster.FINDSET then begin
            repeat
                EmployeeDependentsMaster."Workflow Status" := EmployeeDependentsMaster."Workflow Status"::Released;
                EmployeeDependentsMaster.Status := EmployeeDependentsMaster.Status::Active;
                EmployeeDependentsMaster.MODIFY;
            until EmployeeDependentsMaster.NEXT = 0;
        end;
    end;

    var
        EmployeeDependentsMaster: Record "Employee Dependents Master";
}