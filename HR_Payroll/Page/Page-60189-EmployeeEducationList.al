page 60189 "Employee Education List"
{
    CardPageID = "Employee Education Card";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll Job Education Line";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line  No."; Rec."Line  No.")
                {
                    ApplicationArea = All;
                }
                field("Emp ID"; Rec."Emp ID")
                {
                    ApplicationArea = All;
                }
                field("Emp Full Name"; Rec."Emp Full Name")
                {
                    ApplicationArea = All;
                }
                field("Education Level"; Rec."Education Level")
                {
                    ApplicationArea = All;
                }
                field(Education; Rec.Education)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Grade Pass"; Rec."Grade Pass")
                {
                    ApplicationArea = All;
                }
                field("Passing Year"; Rec."Passing Year")
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
                ApplicationArea = all;
                Image = New;

                trigger OnAction()
                begin
                    CLEAR(LineNoG);
                    LineNoG := GetNewLineNumber(Rec."Emp ID");
                    PayrollJobEducationLineRecG.INIT;
                    PayrollJobEducationLineRecG.VALIDATE("Emp ID", Rec."Emp ID");
                    PayrollJobEducationLineRecG.VALIDATE("Line  No.", LineNoG);
                    PayrollJobEducationLineRecG.INSERT(true);
                    COMMIT;
                    PAGE.RUNMODAL(60192, PayrollJobEducationLineRecG);
                end;
            }
        }
    }

    var
        PayrollJobEducationLineRecG: Record "Payroll Job Education Line";
        LineNoG: Integer;

    local procedure GetNewLineNumber(EmplNo: Code[20]): Integer
    var
        PayrollJobEducationLineRecL: Record "Payroll Job Education Line";
    begin
        PayrollJobEducationLineRecL.RESET;
        PayrollJobEducationLineRecL.SETRANGE("Emp ID", EmplNo);
        if not PayrollJobEducationLineRecL.FINDLAST then
            exit(10000)
        else begin
            exit(PayrollJobEducationLineRecL."Line  No." + 10000);
        end;
    end;
}