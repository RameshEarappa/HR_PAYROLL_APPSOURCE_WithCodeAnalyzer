report 60008 "Retire Position Duration"
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
                    field(Position; PositionID)
                    {
                        Editable = false;
                        ApplicationArea = all;
                    }
                    field("Activation Date"; ActivationDate)
                    {
                        Editable = false;
                        ApplicationArea = all;
                    }
                    field("Retirement Date"; RetirementDate)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    trigger OnPreReport();
    begin
        if Retire and (RetirementDate <> 0D) then begin
            RetirePositionDuration2.RESET;
            RetirePositionDuration2.SETRANGE("Positin ID", RetirePositionDuration."Positin ID");
            RetirePositionDuration2.SETRANGE("Line No.", RetirePositionDuration."Line No.");
            if RetirePositionDuration2.FINDFIRST then begin
                RetirePositionDuration2.VALIDATE(Retirement, RetirementDate);
                RetirePositionDuration2.MODIFY;
            end;
        end;
    end;

    var
        PositionID: Code[20];
        ActivationDate: Date;
        RetirementDate: Date;
        RetirePositionDuration: Record "Payroll Position Duration";
        Retire: Boolean;
        NewRec: Boolean;
        RetirePositionDuration2: Record "Payroll Position Duration";

    procedure SetValuesToRetire(l_AssignmentStart: Date; l_AssignmentEnd: Date; l_Position: Code[20]; l_Retire: Boolean; l_PosDuration: Record "Payroll Position Duration");
    begin
        ActivationDate := l_AssignmentStart;
        RetirementDate := l_AssignmentEnd;
        PositionID := l_Position;
        RetirePositionDuration := l_PosDuration;
        Retire := l_Retire;
    end;

    procedure SetValuesToNewRec(l_AssignmentStart: Date; l_AssignmentEnd: Date; l_Position: Code[20]; l_NewRec: Boolean; l_PosDuration: Record "Payroll Position Duration");
    begin
        ActivationDate := l_AssignmentStart;
        RetirementDate := l_AssignmentEnd;
        PositionID := l_Position;
        NewRec := l_NewRec;
    end;
}