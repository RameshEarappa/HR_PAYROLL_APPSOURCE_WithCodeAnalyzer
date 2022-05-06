report 60007 "Worker Assigment"
{
    ProcessingOnly = true;
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Assignment Start"; AssignmentStart)
                    {
                        ApplicationArea = all;
                    }
                    field("Assignment End"; AssignmentEnd)
                    {
                        ApplicationArea = all;
                    }
                    field(Position; PositionCode)
                    {
                        ApplicationArea = all;
                    }
                    field(Worker; WorkerCode)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    trigger OnPreReport();
    begin
        ValidateAssignWorkerDates;
        PayrollWorkerAssignment.RESET;
        PayrollWorkerAssignment.SETRANGE("Position ID", PositionCode);
        PayrollWorkerAssignment.SETRANGE(Worker, WorkerCode);
        PayrollWorkerAssignment.SETRANGE("Line No.", LineNo);
        if PayrollWorkerAssignment.FINDFIRST then begin
            PayrollWorkerAssignment."Assignment Start" := AssignmentStart;
            PayrollWorkerAssignment."Assignment End" := AssignmentEnd;
            PayrollWorkerAssignment.MODIFY;
        end;
        ValidateAssignWorkerEndDate;
    end;

    var
        AssignmentStart: Date;
        AssignmentEnd: Date;
        PositionCode: Code[20];
        WorkerCode: Code[20];
        LineNo: Integer;
        PayrollWorkerAssignment: Record "Payroll Job Pos. Worker Assign";
        PayrollWorkerAssign: Record "Payroll Job Pos. Worker Assign";

    procedure SetValues(l_AssignmentStart: Date; l_AssignmentEnd: Date; l_Position: Code[20]; l_worker: Code[20]; l_LineNo: Integer);
    begin
        AssignmentStart := l_AssignmentStart;
        AssignmentEnd := l_AssignmentEnd;
        PositionCode := l_Position;
        WorkerCode := l_worker;
        LineNo := l_LineNo;
    end;

    procedure ValidateAssignWorkerEndDate();
    begin
        PayrollWorkerAssign.RESET;
        PayrollWorkerAssign.SETRANGE("Position ID", PositionCode);
        PayrollWorkerAssign.SETRANGE(Worker, WorkerCode);
        PayrollWorkerAssign.SETRANGE("Assignment End", 0D);
        if PayrollWorkerAssign.FINDFIRST then
            ERROR('The duration that you specified overlaps with another record of position %1. Adjust the dates which you entered', PositionCode);
    end;

    procedure ValidateAssignWorkerDates();
    begin
        PayrollWorkerAssign.RESET;
        PayrollWorkerAssign.SETRANGE("Position ID", PositionCode);
        PayrollWorkerAssign.SETRANGE(Worker, WorkerCode);
        PayrollWorkerAssign.SETFILTER("Assignment Start", '>%1', AssignmentStart);
        PayrollWorkerAssign.SETFILTER("Assignment End", '<%1', AssignmentEnd);
        if PayrollWorkerAssign.FINDFIRST then
            ERROR('The duration that you specified overlaps with another record of position %1. Adjust the dates which you entered', PositionCode);
    end;
}