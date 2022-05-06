page 70170 "Emp. Position Assigts RC List"
{
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Payroll Job Pos. Worker Assign";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Worker; Rec.Worker)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Position ID"; Rec."Position ID")
                {
                    ApplicationArea = All;
                }
                field("Assignment Start"; Rec."Assignment Start")
                {
                    ApplicationArea = All;
                }
                field("Assignment End"; Rec."Assignment End")
                {
                    ApplicationArea = All;
                }
                field("Is Primary Position"; Rec."Is Primary Position")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        if Rec."Is Primary Position" then begin
                            EmployeePostionAssingment.RESET;
                            EmployeePostionAssingment.SETRANGE("Position ID", Rec."Position ID");
                            EmployeePostionAssingment.SETRANGE(Worker, Rec.Worker);
                            EmployeePostionAssingment.SETRANGE("Is Primary Position", true);
                            if EmployeePostionAssingment.FINDFIRST then
                                ERROR('You cannot assign more than one position at a time');
                            EditAssignPrimaryPosition := true;
                        end
                        else begin
                            EditAssignPrimaryPosition := false;
                        end;
                    end;
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    ApplicationArea = All;
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Assign Position")
            {
                ApplicationArea = All;
                Enabled = EditAssignPosition;
                Image = RegisterPick;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PositionWorkerAssignment);
                    if PositionWorkerAssignment.FINDSET then;
                    Rec.AssignNewPosition(PositionWorkerAssignment);
                end;
            }
            action("Assign Primary Position")
            {
                ApplicationArea = All;
                Image = Register;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AdvacePayrollSetupRecL: Record "Advance Payroll Setup";
                begin
                    AdvacePayrollSetupRecL.Reset();
                    AdvacePayrollSetupRecL.Get();
                    AdvacePayrollSetupRecL.TestField("Accrual Effective Start Date");
                    if not CONFIRM('Do you want to assign primary position ?') then
                        exit;
                    CurrPage.SETSELECTIONFILTER(PositionWorkerAssignment);
                    if PositionWorkerAssignment.FINDSET then;
                    Rec.AssignPrimaryPosition(PositionWorkerAssignment);
                    ValidateEmployee;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Is Primary Position" then
            EditAssignPrimaryPosition := true
        else
            EditAssignPrimaryPosition := false;

        CLEAR(EditAssignPosition);
        PayrollJobPosWorkerAssign.RESET;
        PayrollJobPosWorkerAssign.SETRANGE(Worker, Rec.Worker);
        PayrollJobPosWorkerAssign.SETRANGE("Is Primary Position", false);
        PayrollJobPosWorkerAssign.SETRANGE("Position Assigned", false);
        if PayrollJobPosWorkerAssign.FINDFIRST then
            EditAssignPosition := false
        else
            EditAssignPosition := true;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Is Primary Position" then
            EditAssignPrimaryPosition := true
        else
            EditAssignPrimaryPosition := false;

        CLEAR(EditAssignPosition);
        PayrollJobPosWorkerAssign.RESET;
        PayrollJobPosWorkerAssign.SETRANGE(Worker, Rec.Worker);
        PayrollJobPosWorkerAssign.SETRANGE("Is Primary Position", false);
        PayrollJobPosWorkerAssign.SETRANGE("Position Assigned", false);
        if PayrollJobPosWorkerAssign.FINDFIRST then
            EditAssignPosition := false
        else
            EditAssignPosition := true;
    end;

    var
        EmployeePostionAssingment: Record "Payroll Job Pos. Worker Assign";
        EditAssignPrimaryPosition: Boolean;
        PositionWorkerAssignment: Record "Payroll Job Pos. Worker Assign";

        [InDataSet]
        EditAssignPosition: Boolean;
        PayrollJobPosWorkerAssign: Record "Payroll Job Pos. Worker Assign";

    trigger OnInit()
    begin
        PageUserFilter();
    end;

    procedure PageUserFilter()
    var
        Rcodeunit: Codeunit "ESS RC Page";
    begin
        Rec.FilterGroup(2);
        Rec.SetRange(Worker, Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;

    local procedure ValidateEmployee()
    var
        EmpRec: Record Employee;
        PositionRec: Record "Payroll Position";
        DepartmentRec: Record "Payroll Department";
        PayrollJobsRec: Record "Payroll Jobs";
    begin
        if EmpRec.GET(Rec.Worker) then begin
            if PositionRec.GET(Rec."Position ID") then begin
                EmpRec.Department := PositionRec.Department;
                EmpRec."Sub Department" := PositionRec."Sub Department";
                EmpRec."Line manager" := PositionRec."Worker Name";
                EmpRec."First Reporting ID" := PositionRec.Worker;
                EmpRec."Job Title" := PositionRec.Title;
                PayrollJobsRec.RESET;
                PayrollJobsRec.SETRANGE(Job, PositionRec.Job);
                if PayrollJobsRec.FINDFIRST then
                    EmpRec."Grade Category" := PayrollJobsRec."Grade Category";
            end;
            if DepartmentRec.GET(PositionRec.Department) then
                EmpRec.HOD := DepartmentRec."HOD Name";
            EmpRec.VALIDATE(Position, Rec."Position ID");
            EmpRec.MODIFY(true);
        end;
    end;
}

