page 60117 "Payroll Job Pos. Worker Assign"
{
    AutoSplitKey = true;
    Caption = 'Position Worker Assign';
    DelayedInsert = true;
    DeleteAllowed = true;
    Editable = false;
    MultipleNewLines = true;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Payroll Job Pos. Worker Assign";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Worker; Rec.Worker)
                {
                    ApplicationArea = All;
                }
                field("Worker Name"; EmployeeName)
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
                field("Reason Code"; Rec."Reason Code")
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
            action(Edit)
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CLEAR(AssignWoker);
                    AssignWoker.SetValues(Rec."Assignment Start", Rec."Assignment End", Rec."Position ID", Rec.Worker, Rec."Line No.");
                    AssignWoker.RUNMODAL;
                end;
            }
            action("End")
            {
                Image = "Action";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("Assignment End");
                    CLEAR(AssignWoker);
                    AssignWoker.SetValues(Rec."Assignment Start", Rec."Assignment End", Rec."Position ID", Rec.Worker, Rec."Line No.");
                    AssignWoker.RUNMODAL;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SETFILTER("Assignment Start", '<=%1', WORKDATE);
        Rec.SETFILTER("Assignment End", '>=%1|%2', WORKDATE, 0D);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.SETFILTER("Assignment Start", '<=%1', WORKDATE);
        Rec.SETFILTER("Assignment End", '>=%1|%2', WORKDATE, 0D);

        CLEAR(EmployeeName);
        if Employee.GET(Rec.Worker) then
            EmployeeName := Employee.FullName;
    end;

    trigger OnOpenPage()
    begin
        CLEAR(EmployeeName);
        if Employee.GET(Rec.Worker) then
            EmployeeName := Employee.FullName;
    end;

    var
        AssignWoker: Report "Worker Assigment";
        EmployeeName: Text;
        Employee: Record Employee;
}