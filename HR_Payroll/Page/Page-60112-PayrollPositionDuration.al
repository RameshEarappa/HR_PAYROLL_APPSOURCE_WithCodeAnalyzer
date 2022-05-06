page 60112 "Payroll Position Duration"
{
    AutoSplitKey = true;
    Caption = 'Position Duration';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Payroll Position Duration";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Activation; Rec.Activation)
                {
                    ApplicationArea = All;
                }
                field(Retirement; Rec.Retirement)
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
            action(Retire)
            {
                ApplicationArea = All;
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Activation);
                    CLEAR(RetirePosDuration);
                    RetirePosDuration.SetValuesToRetire(Rec.Activation, Rec.Retirement, Rec."Positin ID", true, Rec);
                    RetirePosDuration.RUNMODAL;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SETFILTER(Activation, '<=%1', WORKDATE);
        Rec.SETFILTER(Retirement, '>=%1|%2', WORKDATE, 0D);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.SETFILTER(Activation, '<=%1', WORKDATE);
        Rec.SETFILTER(Retirement, '>=%1|%2', WORKDATE, 0D);
    end;

    var
        RetirePosDuration: Report "Retire Position Duration";
}