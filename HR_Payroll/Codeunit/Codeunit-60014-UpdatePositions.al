codeunit 60014 "Update Positions"
{
    trigger OnRun();
    begin
        if PayrollPosition.FINDFIRST then
            repeat
                if PayrollPosition."Position ID" <> '' then begin
                    PayrollWorkerAssign.RESET;
                    PayrollWorkerAssign.SETRANGE("Position ID", PayrollPosition."Position ID");
                    PayrollWorkerAssign.SETFILTER(Worker, '<>%1', '');
                    if PayrollWorkerAssign.FINDFIRST then
                        PayrollPosition."Open Position" := false
                    else
                        PayrollPosition."Open Position" := true;

                    PayrollPosDuration.RESET;
                    PayrollPosDuration.SETRANGE("Positin ID", PayrollPosition."Position ID");
                    PayrollPosDuration.SETFILTER(Activation, '<=%', WORKDATE);
                    PayrollPosDuration.SETFILTER(Retirement, '>=%1|%2', WORKDATE, 0D);
                    if PayrollPosDuration.FINDFIRST then
                        PayrollPosition."Inactive Position" := false
                    else
                        PayrollPosition."Inactive Position" := true;
                    PayrollPosition.MODIFY;
                end;
            until PayrollPosition.NEXT = 0;
    end;

    var
        PayrollPosition: Record "Payroll Position";
        PosWorkerAssignment: Record "Payroll Job Pos. Worker Assign";
        PayrollPosDuration: Record "Payroll Position Duration";
        PayrollWorkerAssign: Record "Payroll Job Pos. Worker Assign";
}