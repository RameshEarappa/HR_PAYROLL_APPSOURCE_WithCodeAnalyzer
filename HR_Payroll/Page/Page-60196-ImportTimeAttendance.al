page 60196 "Import Time Attendance"
{
    DelayedInsert = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Time Attendance - Details";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Import Time Attendance List';
    SourceTableView = SORTING("Employee ID") ORDER(Ascending) WHERE(Confirmed = FILTER(false));

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
                field("Employee Full Name"; Rec."Employee Full Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Date; Rec."Check -In Date")
                {
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
                field("Day Type"; Rec."Day Type")
                {
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
                    ApplicationArea = All;
                }
                field("Gate Out"; Rec."Gate Out")
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
            action("Make Header")
            {
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    TimeAttendance: Record "Time Attendance";
                begin
                    TimeAttendance.Reset();
                    TimeAttendance.SetRange("Employee ID", Rec."Employee ID");
                    TimeAttendance.SetRange(Date, Rec."Check -In Date");
                    TimeAttendance.SetRange(Confirmed, true);
                    if TimeAttendance.FindFirst() then
                        Error('Time Attendance details are already confirmed for the selected employees date range.');
                    DeleteUnconfirm;
                    Rec.CheckSameDayCheckin;
                    UpdateTimeAttendance;
                end;
            }
            action("Import Attendance")
            {
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                var

                    ImportTimeDtailsXmlport: XmlPort "Import Time Details";
                begin
                    TimeAttendanceDetails.SETRANGE(Confirmed, false);
                    if TimeAttendanceDetails.FINDSET then
                        TimeAttendanceDetails.DELETEALL;
                    COMMIT;
                    ImportTimeDtailsXmlport.Run();
                end;
            }
            action("Export Attendance Details")
            {
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                RunObject = XMLport "Export Attendance Details Temp";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EditableFun;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        TimeAttendance.SETRANGE("Employee ID", Rec."Employee ID");
        TimeAttendance.SETRANGE(Date, Rec."Check -In Date");
        TimeAttendance.SETRANGE(Confirmed, true);
        if TimeAttendance.FINDFIRST then
            ERROR(Text50001);
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
        OvertimeHrs: Decimal;
        EmployeeWorkDate_GCC: Record EmployeeWorkDate_GCC;

    local procedure UpdateTimeAttendance()
    begin
        TimeAttendanceDetails1.Reset();
        TimeAttendanceDetails1.SETRANGE(Confirmed, FALSE);
        IF TimeAttendanceDetails1.FINDSET THEN BEGIN
            REPEAT

                TimeAttendance.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                TimeAttendance.SETRANGE(Confirmed, FALSE);
                TimeAttendance.SETRANGE(Date, TimeAttendanceDetails1."Check -In Date");

                IF NOT TimeAttendance.FINDFIRST THEN BEGIN
                    TimeAttendance."Employee ID" := TimeAttendanceDetails1."Employee ID";
                    TimeAttendance.Name := TimeAttendanceDetails1."Employee Full Name";
                    TimeAttendance.Date := TimeAttendanceDetails1."Check -In Date";

                    EmployeeWorkDate_GCC.RESET;
                    EmployeeWorkDate_GCC.SETRANGE("Employee Code", TimeAttendanceDetails1."Employee ID");
                    EmployeeWorkDate_GCC.SETRANGE("Trans Date", TimeAttendanceDetails1."Check -In Date");
                    IF EmployeeWorkDate_GCC.FINDFIRST THEN
                        TimeAttendance."Day Type" := EmployeeWorkDate_GCC."Calculation Type";

                    TimeAttendanceDetails.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                    TimeAttendanceDetails.SETRANGE("Check -In Date", TimeAttendanceDetails1."Check -In Date");
                    IF TimeAttendanceDetails.FINDFIRST THEN;

                    TimeAttendance."Start Time" := TimeAttendanceDetails."Check -In Time";
                    TimeAttendance."Normal Hrs" := TimeAttendanceDetails."Normal Hrs";

                    TimeAttendanceDetails.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                    TimeAttendanceDetails.SETRANGE("Check -In Date", TimeAttendanceDetails1."Check -In Date");
                    IF TimeAttendanceDetails.FINDLAST THEN;

                    TimeAttendance."End Time" := TimeAttendanceDetails."Check -Out Time";

                    TotalHrs := 0;
                    WorkingHrs := 0;
                    HrsWorked := 0;
                    OvertimeHrs := 0;

                    TimeAttendanceDetails.SETRANGE("Employee ID", TimeAttendanceDetails1."Employee ID");
                    TimeAttendanceDetails.SETRANGE("Check -In Date", TimeAttendanceDetails1."Check -In Date");
                    TimeAttendanceDetails.SETFILTER(Confirmed, '%1', FALSE);
                    IF TimeAttendanceDetails.FINDSET THEN
                        REPEAT
                            TotalHrs := TotalHrs + TimeAttendanceDetails."Total Working Hrs";
                            WorkingHrs := WorkingHrs + TimeAttendanceDetails."Working Hrs";
                            OvertimeHrs := OvertimeHrs + TimeAttendanceDetails."Overtime Hrs";
                            TimeAttendanceDetails.RENAME(TimeAttendanceDetails."Employee ID", TimeAttendanceDetails."Check -In Date", TimeAttendanceDetails."Check -In Time", TRUE);
                        UNTIL TimeAttendanceDetails.NEXT = 0;


                    TimeAttendance."Total Hours" := TotalHrs;
                    TimeAttendance."Worked Hours" := WorkingHrs;
                    TimeAttendance."Absent Hours" := TimeAttendance."Normal Hrs" - TimeAttendance."Worked Hours";
                    TimeAttendance."Overtime Hrs" := OvertimeHrs;

                    IF TimeAttendanceDetails1."Day Type" <> TimeAttendanceDetails1."Day Type"::"Working Day" THEN BEGIN
                        TimeAttendance."Overtime Hrs" := OvertimeHrs + WorkingHrs;
                        TimeAttendance."Absent Hours" := 0;
                        TimeAttendance."Worked Hours" := 0;
                    END;
                    TimeAttendance.Confirmed := FALSE;
                    TimeAttendance.INSERT;
                END;
            UNTIL TimeAttendanceDetails1.NEXT = 0;
        END;
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

    local procedure DeleteUnconfirm()
    begin
        TimeAttendance.SETRANGE("Employee ID", Rec."Employee ID");
        TimeAttendance.SETRANGE(Date, Rec."Check -In Date");
        TimeAttendance.SETRANGE(Confirmed, FALSE);
        IF TimeAttendance.FINDFIRST THEN BEGIN
            TimeAttendanceDetails.SETRANGE("Employee ID", Rec."Employee ID");
            TimeAttendanceDetails.SETRANGE("Check -In Date", Rec."Check -In Date");
            TimeAttendanceDetails.SETRANGE(Confirmed, TRUE);
            IF TimeAttendanceDetails.FINDSET THEN
                TimeAttendanceDetails.DELETEALL;
            TimeAttendance.DELETEALL;
        END;
    end;

    local procedure UpdateConfirm()
    begin
        TimeAttendanceDetails.SETRANGE("Employee ID", Rec."Employee ID");
        TimeAttendanceDetails.SETRANGE("Check -In Date", Rec."Check -In Date");
        TimeAttendanceDetails.SETFILTER(Confirmed, '%1', false);
        if TimeAttendanceDetails.FINDSET then
            repeat
                TimeAttendanceDetails.Confirmed := true;
                TimeAttendanceDetails.MODIFY;
            until TimeAttendanceDetails.NEXT = 0;
    end;
}