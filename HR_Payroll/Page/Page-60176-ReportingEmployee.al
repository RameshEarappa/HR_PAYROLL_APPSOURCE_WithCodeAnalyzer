page 60176 "Reporting Employee"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Employee;
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInit()
    begin
        UserSetupRec.RESET;
        UserSetupRec.SETRANGE("User ID", USERID);
        if UserSetupRec.FINDFIRST then begin
            PayrollPosRec.RESET;
            PayrollPosRec.SETRANGE("Is Primary Position", true);
            if PayrollPosRec.FINDFIRST then begin
                repeat
                    RepPosRec2.RESET;
                    RepPosRec2.SETRANGE("Reports to Position", PayrollPosRec."Position ID");
                    if RepPosRec2.FINDSET then begin
                        PayrollPosRec2.RESET;
                        PayrollPosRec2.SETRANGE("Position ID", RepPosRec2."Position ID");
                        if PayrollPosRec2.FINDFIRST then begin
                            if Rec.GET(PayrollPosRec2.Worker) then
                                Rec.MARK(true);
                        end;
                    end;
                until PayrollPosRec.NEXT = 0;
            end;
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.MARKEDONLY(true);
    end;

    var
        UserEmployee: Text;
        UserSetupRec: Record "User Setup";
        EmpRec: Record Employee;
        EmpRec2: Record Employee;
        PayrollPosRec: Record "Payroll Job Pos. Worker Assign";
        RepPosRec: Record "Payroll Position";
        PayrollPosRec2: Record "Payroll Job Pos. Worker Assign";
        RepPosRec2: Record "Payroll Position";
}