page 70160 "Employee Prof.Exp. RC List"
{
    CardPageID = "Employee Prof. Exp Card";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Employee Prof. Exp.";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Emp No."; Rec."Emp No.")
                {
                    ApplicationArea = All;
                }
                field("Emp FullName"; Rec."Emp FullName")
                {
                    ApplicationArea = All;
                }
                field(Employer; Rec.Employer)
                {
                    ApplicationArea = All;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                }
                field("Internet Address"; Rec."Internet Address")
                {
                    ApplicationArea = All;
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(NEW)
            {
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CLEAR(LineNoG);
                    LineNoG := GetNewLineNumber(Rec."Emp No.");
                    EmployeeProfExpRecG.INIT;
                    EmployeeProfExpRecG.VALIDATE("Emp No.", Rec."Emp No.");
                    EmployeeProfExpRecG.VALIDATE("Line No.", LineNoG);
                    EmployeeProfExpRecG.INSERT(true);
                    COMMIT;
                    PAGE.RUNMODAL(60194, EmployeeProfExpRecG);
                end;
            }
        }
    }

    var
        EmployeeProfExpRecG: Record "Employee Prof. Exp.";
        LineNoG: Integer;

    local procedure GetNewLineNumber(EmplNo: Code[20]): Integer
    var
        EmployeeProfExpRecL: Record "Employee Prof. Exp.";
    begin
        EmployeeProfExpRecL.RESET;
        EmployeeProfExpRecL.SETRANGE("Emp No.", EmplNo);
        if not EmployeeProfExpRecL.FINDLAST then
            exit(10000)
        else begin
            exit(EmployeeProfExpRecL."Line No." + 10000);
        end;
    end;

    trigger OnInit()
    begin
        PageUserFilter();
    end;

    procedure PageUserFilter()
    var
        Rcodeunit: Codeunit "ESS RC Page";
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Emp No.", Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;
}