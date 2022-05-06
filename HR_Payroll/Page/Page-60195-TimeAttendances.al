page 60195 "Time Attendances"
{
    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Time Attendance";
    SourceTableView = SORTING("Employee ID", Date)
                      ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Total Hours"; Rec."Total Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Normal Hrs"; Rec."Normal Hrs")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Worked Hours"; Rec."Worked Hours")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Overtime Hrs"; Rec."Overtime Hrs")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Absent Hours"; Rec."Absent Hours")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Indoor Check-in"; Rec."Indoor Check-in")
                {
                    ApplicationArea = All;
                }
                field("Outdoor Check-out"; Rec."Outdoor Check-out")
                {
                    ApplicationArea = All;
                }
                field(Confirmed; Rec.Confirmed)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Attendance Details")
            {
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                RunObject = Page "Time Attend. Details";
                RunPageLink = "Employee ID" = FIELD("Employee ID"), "Check -In Date" = FIELD(Date);
                RunPageView = SORTING("Employee ID", "Check -In Date", "Check -In Time") ORDER(Ascending);

            }
            action(Confirm)
            {
                Ellipsis = true;
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if CONFIRM(Text55016, true) then begin
                        CLEAR(TimeAttendance);
                        CurrPage.SETSELECTIONFILTER(TimeAttendance);
                        if TimeAttendance.FINDSET then
                            repeat
                                if TimeAttendance.Confirmed = false then begin
                                    TimeAttendance.Confirmed := true;
                                    TimeAttendance.MODIFY;
                                end;
                            until TimeAttendance.NEXT = 0;
                        MESSAGE(Text55017);
                    end
                    else
                        exit;
                end;
            }
            action(Unconfirm)
            {
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Detailsenable;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if CONFIRM(Text55016, true) then begin

                        CLEAR(TimeAttendance);
                        CurrPage.SETSELECTIONFILTER(TimeAttendance);
                        if TimeAttendance.FINDSET then
                            repeat
                                if TimeAttendance.Confirmed = true then begin
                                    TimeAttendance.Confirmed := false;
                                    TimeAttendance.MODIFY;
                                end;
                            until TimeAttendance.NEXT = 0;
                        MESSAGE(Text55018);
                    end
                    else
                        exit;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Detailsenable := true;
    end;

    var
        Text55016: Label 'Do you want to check Validation for all records ?';
        TimeAttendance: Record "Time Attendance";
        Detailsenable: Boolean;
        Text55017: Label 'Details has been Confirmed !';
        Text55018: Label 'Details has been Unconfirmed !';
}