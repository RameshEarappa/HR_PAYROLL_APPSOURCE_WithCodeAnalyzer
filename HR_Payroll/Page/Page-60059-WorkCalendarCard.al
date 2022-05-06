page 60059 "Work Calendar Card"
{
    PageType = Document;
    SourceTable = "Work Calendar Header";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Calendar ID"; Rec."Calendar ID")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Work Time Template"; Rec."Work Time Template")
                {
                    ApplicationArea = All;
                }
                group("Dates")
                {
                    field("From Date"; Rec."From Date")
                    {
                        ApplicationArea = All;
                    }
                    field("To Date"; Rec."To Date")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            part("Work Calendar Date"; "Work Calendar Date")
            {
                SubPageLink = "Calendar ID" = FIELD("Calendar ID");
                ApplicationArea = All;
            }
            part("Work Cal Date Lines"; "Work Cal Date Lines")
            {
                Provider = "Work Calendar Date";
                ApplicationArea = All;
                SubPageLink = "Calendar ID" = FIELD("Calendar ID"), "Trans Date" = FIELD("Trans Date");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Date Calculations")
            {
                Caption = 'Date Calculations';
                Image = Calculator;

                action("Calculate Date")
                {
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.CalculateDate;
                    end;
                }
                action("Update Calculation Type")
                {
                    Image = Recalculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.UpdateCalculationType;
                    end;
                }
                action("Ramadn Calendars")
                {
                    Image = CalendarWorkcenter;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CLEAR(CardRamadnPage);
                        TimeRamadanRec.RESET;
                        TimeRamadanRec.SETRANGE("Work Time ID", Rec."Calendar ID");
                        if not TimeRamadanRec.FINDFIRST then begin
                            TimeRamadanRec.INIT;
                            TimeRamadanRec.VALIDATE("Work Time ID", Rec."Calendar ID");
                            TimeRamadanRec.INSERT(true);
                            CardRamadnPage.SETTABLEVIEW(TimeRamadanRec);
                        end else begin
                            CardRamadnPage.SETTABLEVIEW(TimeRamadanRec);
                            CardRamadnPage.RUNMODAL
                        end;
                    end;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        WorkCalendarDate: Record "Work Calendar Date";
    begin
        WorkCalendarDate.RESET;
        WorkCalendarDate.SETRANGE("Calendar ID", Rec."Calendar ID");
        WorkCalendarDate.SETRANGE("Has Changed", true);
        if WorkCalendarDate.FINDFIRST then begin
            ERROR('Calculation Type Modified, Please update the Employee Cacluation Type');
        end;
    end;

    var
        CardRamadnPage: Page "Work Time Template Card-Ramadn";
        TimeRamadanRec: Record "Work Time Template - Ramadn";

}