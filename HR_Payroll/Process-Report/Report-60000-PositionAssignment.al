report 60000 "Position Assignment"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord();
            begin
                // ---->> Assign worker Position
                PayrollPosition.GET(PositionCode);
                PayrollPosition.TESTFIELD("Pay Cycle");

                PayrollJobs.GET(PayrollPosition.Job);

                PositionWorkerAssignment2.RESET;
                PositionWorkerAssignment2.SETRANGE("Position ID", PositionCode);
                PositionWorkerAssignment2.SETFILTER(Worker, '<>%1', Employee."No.");
                if PositionWorkerAssignment2.FINDFIRST then
                    ERROR('Position is assigned as Primary Position for the employee %1', PositionWorkerAssignment2.Worker);

                PositionWorkerAssignment3.RESET;
                PositionWorkerAssignment3.SETRANGE(Worker, EmpCode);
                PositionWorkerAssignment3.SETRANGE("Position ID", PositionCode);
                if not PositionWorkerAssignment3.FINDFIRST then begin
                    PositionWorkerAssignment2.RESET;
                    PositionWorkerAssignment2.SETRANGE(Worker, EmpCode);
                    if PositionWorkerAssignment2.FINDLAST then;
                    PositionWorkerAssignment.INIT;
                    PositionWorkerAssignment.Worker := EmpCode;
                    PositionWorkerAssignment."Line No." := PositionWorkerAssignment2."Line No." + 10000;
                    PositionWorkerAssignment."Position ID" := PositionCode;
                    PositionWorkerAssignment."Assignment Start" := AssgnStartDate;
                    PositionWorkerAssignment."Assignment End" := AssgnEndDate;
                    PositionWorkerAssignment."Emp. Earning Code Group" := PayrollJobs."Earning Code Group";
                    if PositionWorkerAssignment.INSERT then begin
                        if PayrollPosition.GET(PositionCode) then begin
                            PayrollPosition."Open Position" := false;
                            PayrollPosition.MODIFY;
                        end;
                    end;
                end
                else begin
                    ERROR('Employee Position Assigment is already exist for employee %1 and Position %2.', EmpCode, PositionCode);
                end;
                // ---->> Assign worker Position
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(General)
                {
                    field("Employee Code"; EmpCode)
                    {
                        Editable = false;
                        ApplicationArea = all;
                    }
                    field(Position; PositionCode)
                    {
                        TableRelation = "Payroll Position"."Position ID" WHERE("Open Position" = CONST(true));
                        ApplicationArea = all;
                    }
                    group(Assignment)
                    {
                        field("Start Date"; AssgnStartDate)

                        {
                            ApplicationArea = all;
                            trigger OnValidate();
                            begin
                                if (AssgnEndDate <> 0D) and (AssgnStartDate > AssgnEndDate) then
                                    ERROR('Assignment Start Date Should be Before Assignment End');
                            end;
                        }
                        field("End Date"; AssgnEndDate)
                        {
                            ApplicationArea = all;
                            trigger OnValidate();
                            begin
                                if (AssgnStartDate <> 0D) and (AssgnStartDate > AssgnEndDate) then
                                    ERROR('Assignment End Date should be after Assignment Start');
                            end;
                        }
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean;
        begin
            if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
                PayrollPosition.GET(PositionCode);

                Employee.GET(EmpCode);
                if AssgnStartDate <> 0D then
                    if (Employee."Joining Date" > AssgnStartDate) then
                        ERROR('Start Date and End Date should not be before Employee Joining Date %1', Employee."Joining Date");

                if AssgnEndDate <> 0D then
                    if (Employee."Joining Date" > AssgnEndDate) then
                        ERROR('Start Date and End Date should not be before Employee Joining Date %1', Employee."Joining Date");

                PositionWorkerAssignment.RESET;
                PositionWorkerAssignment.SETRANGE("Position ID", PositionCode);
                PositionWorkerAssignment.SETRANGE(Worker, EmpCode);
                PositionWorkerAssignment.SETFILTER("Effective Start Date", '<=%1', AssgnStartDate);
                PositionWorkerAssignment.SETFILTER("Effective End Date", '>=%1|%2', AssgnStartDate, 0D);
                if PositionWorkerAssignment.FINDFIRST then
                    ERROR('Position assignment period is overlaps with another period for this worker');
            end;

        end;
    }

    trigger OnPreReport();
    begin
        if AssgnStartDate = 0D then
            ERROR(StartDateError);
    end;

    var
        EmpCode: Code[20];
        AssgnStartDate: Date;
        AssgnEndDate: Date;
        PositionCode: Code[20];
        StartDateError: Label '"Assignment Start Date can not be blank. "';
        PositionWorkerAssignment: Record "Payroll Job Pos. Worker Assign";
        PayrollPosition: Record "Payroll Position";
        Employee: Record Employee;
        PositionWorkerAssignment2: Record "Payroll Job Pos. Worker Assign";
        PositionWorkerAssignment3: Record "Payroll Job Pos. Worker Assign";
        PositionWorkerAssignmentArchive: Record "Payroll Pos. Worker Assn. Arch";
        PayrollJobs: Record "Payroll Jobs";

    procedure SetEmpPosDetails(Emp_p: Code[20]; l_PosCode: Code[20]);
    begin
        EmpCode := Emp_p;
        PositionCode := l_PosCode;
    end;

    procedure EmpCreation(E_EmpID: Code[20]; E_PosCode: Code[20]; E_AssStart: Date; E_AssEnd: Date);
    begin
        EmpCode := E_EmpID;
        PositionCode := E_PosCode;
        AssgnStartDate := E_AssStart;
        AssgnEndDate := E_AssEnd;
    end;
}