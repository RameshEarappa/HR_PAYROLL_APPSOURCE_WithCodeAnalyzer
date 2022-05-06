codeunit 60017 "Cac Dates"
{
    trigger OnRun();
    var
        RecordLink: Record "Record Link";
        RecordRef: RecordRef;
        Emp: Record Employee;
        RecordId: RecordID;
        RecordLink2: Record "Record Link";
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
    begin
        MESSAGE('%1', CALCDATE('-CM+' + FORMAT(24) + 'M', 20190101D));
    end;
}

