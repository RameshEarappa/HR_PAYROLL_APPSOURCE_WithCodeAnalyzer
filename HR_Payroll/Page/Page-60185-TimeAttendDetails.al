page 60185 "Time Attend. Details"
{
    PageType = List;
    SourceTable = "Time Attendance - Details";
    SourceTableView = SORTING("Employee ID", "Check -In Date", "Check -In Time", Confirmed)
                      ORDER(Ascending);
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee ID"; Rec."Employee ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Full Name"; Rec."Employee Full Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Date; Rec."Check -In Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Check -In Time")
                {
                    Editable = Editablebool;
                    ApplicationArea = All;
                }
                field("End Time"; Rec."Check -Out Time")
                {
                    Editable = Editablebool;
                    ApplicationArea = All;
                }
                field("Total Working Hrs"; Rec."Total Working Hrs")
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
                field("Working Hrs"; Rec."Working Hrs")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Absent Hrs"; Rec."Absent Hrs")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Overtime Hrs"; Rec."Overtime Hrs")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Gate In"; Rec."Gate In")
                {
                    Editable = Editablebool;
                    ApplicationArea = All;
                }
                field("Gate Out"; Rec."Gate Out")
                {
                    Editable = Editablebool;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Attendance")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.CheckSameDayCheckin;
                    ValidateChanges;
                    UpdateTimeAttendance;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EditableFun;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ValidateChanges;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ValidateChanges;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ValidateChanges;
    end;

    trigger OnOpenPage()
    begin
        Editablebool := true;
    end;

    var
        TimeAttendance: Record "Time Attendance";
        TimeAttendanceDetails: Record "Time Attendance - Details";
        TotalHrs: Decimal;
        WorkingHrs: Decimal;
        HrsWorked: Decimal;
        Editablebool: Boolean;
        Text50001: Label 'Cannot make changes since the details have already being confirmed !';
        TimeAttendanceDetails1: Record "Time Attendance - Details";
        Text50002: Label 'Do you want to Update the details in Header ?';
        Text50003: Label 'Details has been updated in Header!';
        OvertimeHrs: Decimal;

    local procedure UpdateTimeAttendance()
    begin
        if CONFIRM(Text50002, true) then begin
            TimeAttendanceDetails1.SETRANGE("Employee ID", Rec."Employee ID");
            TimeAttendanceDetails1.SETRANGE("Check -In Date", Rec."Check -In Date");
            if TimeAttendanceDetails1.FINDSET then
                repeat
                    TimeAttendance.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                    TimeAttendance.SETRANGE(Confirmed, false);
                    TimeAttendance.SETRANGE(Date, TimeAttendanceDetails1."Check -In Date");
                    if TimeAttendance.FINDFIRST then begin
                        TimeAttendance."Start Time" := 000000T;
                        TimeAttendance."End Time" := 000000T;
                        TimeAttendance."Absent Hours" := 0;
                        TimeAttendance."Worked Hours" := 0;
                        TimeAttendance."Overtime Hrs" := 0;
                        TimeAttendance."Total Hours" := 0;
                        TimeAttendance.MODIFY;

                        TimeAttendanceDetails.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                        TimeAttendanceDetails.SETRANGE("Check -In Date", TimeAttendanceDetails1."Check -In Date");
                        if TimeAttendanceDetails.FINDFIRST then;

                        TimeAttendance."Start Time" := TimeAttendanceDetails."Check -In Time";
                        TimeAttendance."Normal Hrs" := TimeAttendanceDetails."Normal Hrs";

                        TimeAttendanceDetails.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                        TimeAttendanceDetails.SETRANGE("Check -In Date", TimeAttendanceDetails1."Check -In Date");
                        if TimeAttendanceDetails.FINDLAST then;

                        TimeAttendance."End Time" := TimeAttendanceDetails."Check -Out Time";

                        TotalHrs := 0;
                        WorkingHrs := 0;

                        TimeAttendanceDetails.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                        TimeAttendanceDetails.SETRANGE("Check -In Date", TimeAttendanceDetails1."Check -In Date");
                        if TimeAttendanceDetails.FINDSET then
                            repeat
                                TotalHrs := TotalHrs + TimeAttendanceDetails."Total Working Hrs";
                                WorkingHrs := WorkingHrs + TimeAttendanceDetails."Working Hrs";
                                OvertimeHrs := OvertimeHrs + TimeAttendanceDetails."Overtime Hrs";
                                TimeAttendanceDetails.RENAME(TimeAttendanceDetails."Employee ID", TimeAttendanceDetails."Check -In Date", TimeAttendanceDetails."Check -In Time", true);
                            until TimeAttendanceDetails.NEXT = 0;

                        TimeAttendance."Total Hours" := TotalHrs;
                        TimeAttendance."Worked Hours" := WorkingHrs;
                        TimeAttendance."Absent Hours" := TimeAttendance."Normal Hrs" - TimeAttendance."Worked Hours";
                        TimeAttendance."Overtime Hrs" := OvertimeHrs;
                        TimeAttendance.Confirmed := false;
                        TimeAttendance.MODIFY;
                    end;
                until TimeAttendanceDetails1.NEXT = 0;
            MESSAGE(Text50003);
        end;
        CurrPage.UPDATE;
    end;

    local procedure EditableFun()
    begin
        TimeAttendance.SETRANGE("Employee ID", Rec."Employee ID");
        TimeAttendance.SETRANGE(Date, Rec."Check -In Date");
        TimeAttendance.SETRANGE(Confirmed, true);
        if TimeAttendance.FINDFIRST then
            Editablebool := false;
    end;

    local procedure MakeHeader()
    begin
        if CONFIRM(Text50002, true) then begin
            TimeAttendanceDetails1.SETRANGE(Confirmed, false);
            if TimeAttendanceDetails1.FINDSET then
                repeat

                    TimeAttendance.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                    TimeAttendance.SETRANGE(Confirmed, false);
                    TimeAttendance.SETRANGE(Date, TimeAttendanceDetails1."Check -In Date");
                    if TimeAttendance.FINDFIRST then begin

                        TimeAttendanceDetails.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                        TimeAttendanceDetails.SETRANGE("Check -In Date", TimeAttendanceDetails1."Check -In Date");
                        if TimeAttendanceDetails.FINDFIRST then;

                        TimeAttendance."Start Time" := TimeAttendanceDetails."Check -In Time";
                        TimeAttendance."Normal Hrs" := TimeAttendanceDetails."Normal Hrs";

                        TimeAttendanceDetails.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                        TimeAttendanceDetails.SETRANGE("Check -In Date", TimeAttendanceDetails1."Check -In Date");
                        if TimeAttendanceDetails.FINDLAST then;

                        TimeAttendance."End Time" := TimeAttendanceDetails."Check -Out Time";

                        TotalHrs := 0;
                        WorkingHrs := 0;

                        TimeAttendanceDetails.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                        TimeAttendanceDetails.SETRANGE("Check -In Date", TimeAttendanceDetails1."Check -In Date");
                        if TimeAttendanceDetails.FINDSET then
                            repeat
                                TimeAttendanceDetails.Confirmed := true;
                                TimeAttendanceDetails.MODIFY(true);
                                TotalHrs := TotalHrs + TimeAttendanceDetails."Total Working Hrs";
                                WorkingHrs := WorkingHrs + TimeAttendanceDetails."Working Hrs";

                            until TimeAttendanceDetails.NEXT = 0;

                        TimeAttendance."Total Hours" := TotalHrs;
                        TimeAttendance."Worked Hours" := WorkingHrs;

                        if WorkingHrs < TimeAttendance."Normal Hrs" then
                            HrsWorked := ABS(TimeAttendance."Normal Hrs" - TimeAttendance."Worked Hours");

                        if TimeAttendanceDetails1."Day Type" = TimeAttendanceDetails1."Day Type"::"Working Day" then begin
                            if TimeAttendance."Normal Hrs" < WorkingHrs then
                                TimeAttendance."Overtime Hrs" := WorkingHrs - TimeAttendance."Normal Hrs"
                            else begin

                                TimeAttendance."Absent Hours" := HrsWorked;
                            end;
                        end
                        else begin
                            TimeAttendance."Overtime Hrs" := TotalHrs;
                            TimeAttendance."Normal Hrs" := 0;
                            TimeAttendance."Absent Hours" := 0;
                        end;

                        TimeAttendance.Confirmed := false;
                        TimeAttendance.MODIFY;

                    end;
                until TimeAttendanceDetails1.NEXT = 0;
        end
        else
            exit;
        CurrPage.UPDATE;
    end;

    local procedure ValidateChanges()
    begin
        TimeAttendance.SETRANGE("Employee ID", Rec."Employee ID");
        TimeAttendance.SETRANGE(Date, Rec."Check -In Date");
        TimeAttendance.SETRANGE(Confirmed, true);
        if TimeAttendance.FINDFIRST then
            ERROR(Text50001);
    end;
}