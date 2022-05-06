page 60118 "Work Time MonSubform -Ramadn"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Work Time Line - Ramadn";
    SourceTableView = WHERE(Weekday = CONST(Monday));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("From Time"; Rec."From Time")
                {
                    ApplicationArea = All;
                }
                field("To Time"; Rec."To Time")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Shift Split"; Rec."Shift Split")
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
            action("Copy Day")
            {
                Caption = 'Copy Day';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    WorkTimeTemplate: Record "Work Time Template - Ramadn";
                    CopyDay: Report "CopyWorkTime Templat- Ramadn";
                begin
                    WorkTimeTemplate.RESET;
                    WorkTimeTemplate.SETRANGE("Work Time ID", Rec."Work Time ID");
                    if WorkTimeTemplate.FINDFIRST then;
                    CLEAR(CopyDay);
                    CopyDay.SetFromWeekday(Rec.Weekday, WorkTimeTemplate);
                    CopyDay.RUNMODAL;
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Weekday := Rec.Weekday::Monday;
    end;
}