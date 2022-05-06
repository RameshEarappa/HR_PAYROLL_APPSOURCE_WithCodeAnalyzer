table 60134 "Time Attendance - Details"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Employee ID"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Employee ID" <> '' then
                    if Employee.GET("Employee ID") then
                        "Employee Full Name" := Employee."First Name" + '' + Employee."Last Name";
            end;
        }
        field(2; "Employee Full Name"; Text[150])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; "Check -In Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                EmployeeWorkDate_GCC.RESET;
                EmployeeWorkDate_GCC.SETRANGE("Employee Code", Rec."Employee ID");
                EmployeeWorkDate_GCC.SETRANGE("Trans Date", "Check -In Date");
                if EmployeeWorkDate_GCC.FINDFIRST then
                    VALIDATE("Day Type", EmployeeWorkDate_GCC."Calculation Type");
            end;
        }
        field(4; "Check -In Time"; Time)
        {
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TESTFIELD("Employee ID");
                TESTFIELD("Check -In Date");
                CheckSameDayCheckin;
                if "Check -In Time" = 0T then begin
                    "Check -Out Time" := 0T;
                    "Normal Hrs" := 0;
                    "Overtime Hrs" := 0;
                    "Absent Hrs" := 0;
                end;
            end;
        }
        field(5; "Check -Out Time"; Time)
        {
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                NormalHs := 0;
                if "Check -Out Time" <> xRec."Check -Out Time" then begin
                    "Normal Hrs" := 0;
                    "Absent Hrs" := 0;
                    "Overtime Hrs" := 0;
                end;
                CLEAR(TotHrs);
                StartTime := FORMAT("Check -In Time", 8, '<Hours24,2>:<Minutes,2>:<Seconds,2>');
                EndTime := FORMAT("Check -Out Time", 8, '<Hours24,2>:<Minutes,2>:<Seconds,2>');
                if EndTime < StartTime then
                    ERROR(Text50007, "Check -Out Time", "Check -In Time");

                "Total Working Hrs" := (((("Check -Out Time" - "Check -In Time") / 1000) / 60) / 60);

                EmpErnCodGpRec.RESET;
                EmpErnCodGpRec.SETRANGE("Employee Code", "Employee ID");
                EmpErnCodGpRec.SETRANGE("Valid To", 0D);
                if EmpErnCodGpRec.FINDFIRST then begin
                    WorkCalendarLineRec.RESET;
                    WorkCalendarLineRec.SETRANGE("Calendar ID", EmpErnCodGpRec.Calander);
                    WorkCalendarLineRec.SETRANGE("Trans Date", "Check -In Date");
                    if WorkCalendarLineRec.FINDSET then begin
                        repeat
                            TotHrs += WorkCalendarLineRec.Hours;
                        until WorkCalendarLineRec.NEXT = 0;
                    end;
                end;
                "Normal Hrs" := TotHrs;
                CalcOvertimeHours;
            end;
        }
        field(6; "Total Working Hrs"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7; "Gate In"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Gate Out"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(19; "Normal Hrs"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Overtime Hrs"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Absent Hrs"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Working Hrs"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Day Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(24; Confirmed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(25; Madeheader; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Employee ID", "Check -In Date", "Check -In Time", Confirmed)
        {
            Clustered = true;
        }
    }

    var
        Employee: Record Employee;
        Text50002: Label 'Employee ID %1 have already punched out at %2 %3';
        Text50007: Label 'End Time %1 is less than Start Time %2';
        Text50008: Label 'There is already an entry exists for the same day.';
        StartTime: Text;
        EndTime: Text;
        WorkCalendarDateLine: Record "Work Calendar Date Line";
        WorkCalendarDateLine1: Record "Work Calendar Date Line";
        OvertimeDuration: Duration;
        StandardDuration: Duration;
        WorkingDuration: Duration;
        WorkCalendar: Record "Work Calendar Header";
        NormalHs: Decimal;
        EmpErnCodGpRec: Record "Employee Earning Code Groups";
        WorkCalendarLineRec: Record "Work Calendar Date Line";
        TotHrs: Decimal;
        TimeAttendanceDetails: Record "Time Attendance - Details";
        EmployeeWorkDate_GCC: Record EmployeeWorkDate_GCC;

    procedure CheckSameDayCheckin()
    var
        TimeAttendance: Record "Time Attendance";
    begin
        TimeAttendanceDetails.RESET;
        TimeAttendanceDetails.SETRANGE("Employee ID", "Employee ID");
        TimeAttendanceDetails.SETRANGE("Check -In Date", "Check -In Date");
        TimeAttendanceDetails.SETASCENDING("Check -In Time", TRUE);
        IF TimeAttendanceDetails.FIND('-') THEN
            REPEAT
                IF TimeAttendanceDetails."Check -In Time" < "Check -In Time" THEN BEGIN
                    IF TimeAttendanceDetails."Check -Out Time" > "Check -In Time" THEN
                        ERROR(Text50002, TimeAttendanceDetails."Employee ID", TimeAttendanceDetails."Check -In Date", TimeAttendanceDetails."Check -Out Time");
                END;
            UNTIL TimeAttendance.NEXT = 0;
    end;

    local procedure CalcForSameDayCheckIn()
    var
        TimeAttendance: Record "Time Attendance";
    begin
        TimeAttendanceDetails.RESET;
        TimeAttendanceDetails.SETRANGE("Employee ID", "Employee ID");
        TimeAttendanceDetails.SETRANGE("Check -In Date", "Check -In Date");
        TimeAttendanceDetails.SETASCENDING("Check -In Time", true);
        if TimeAttendanceDetails.FINDFIRST then
            ERROR(Text50008);
    end;

    procedure CalcOvertimeHours()
    begin
        CLEAR(WorkingDuration);
        CLEAR(OvertimeDuration);
        CLEAR(StandardDuration);
        EmployeeWorkDate_GCC.SETRANGE("Employee Code", "Employee ID");
        EmployeeWorkDate_GCC.SETRANGE("Trans Date", "Check -In Date");
        if EmployeeWorkDate_GCC.FINDFIRST then
            WorkCalendarDateLine.SETRANGE("Calendar ID", EmployeeWorkDate_GCC."Calander id");
        WorkCalendarDateLine.SETRANGE("Trans Date", EmployeeWorkDate_GCC."Trans Date");
        if WorkCalendarDateLine.FINDFIRST then;

        WorkCalendarDateLine1.SETRANGE("Calendar ID", EmployeeWorkDate_GCC."Calander id");
        WorkCalendarDateLine1.SETRANGE("Trans Date", EmployeeWorkDate_GCC."Trans Date");
        if WorkCalendarDateLine1.FINDLAST then;

        StandardDuration := WorkCalendarDateLine1."To Time" - WorkCalendarDateLine."From Time";

        if (("Check -In Time" >= WorkCalendarDateLine."From Time") and ("Check -In Time" < WorkCalendarDateLine1."To Time")) then
            if (("Check -Out Time" <= WorkCalendarDateLine1."To Time")) then begin
                WorkingDuration := "Check -Out Time" - "Check -In Time";
                "Working Hrs" := ((WorkingDuration / 1000) / 60) / 60;
                "Absent Hrs" := 0;
                "Overtime Hrs" := 0
            end
            else
                if "Check -Out Time" >= WorkCalendarDateLine1."To Time" then begin
                    WorkingDuration := WorkCalendarDateLine1."To Time" - "Check -In Time";
                    OvertimeDuration := "Check -Out Time" - WorkCalendarDateLine1."To Time";
                    "Working Hrs" := ((WorkingDuration / 1000) / 60) / 60;
                    "Absent Hrs" := 0;
                    "Overtime Hrs" := ((OvertimeDuration / 1000) / 60) / 60;
                end;

        if (("Check -In Time" <= WorkCalendarDateLine."From Time")) then
            if (("Check -Out Time" <= WorkCalendarDateLine1."To Time")) then begin
                WorkingDuration := "Check -Out Time" - WorkCalendarDateLine."From Time";
                "Working Hrs" := ((WorkingDuration / 1000) / 60) / 60;
                "Absent Hrs" := 0;
                "Overtime Hrs" := 0
            end
            else
                if "Check -Out Time" >= WorkCalendarDateLine1."To Time" then begin
                    WorkingDuration := WorkCalendarDateLine1."To Time" - WorkCalendarDateLine."From Time";
                    OvertimeDuration := "Check -Out Time" - WorkCalendarDateLine1."To Time";
                    "Working Hrs" := ((WorkingDuration / 1000) / 60) / 60;
                    "Absent Hrs" := 0;
                    "Overtime Hrs" := ((OvertimeDuration / 1000) / 60) / 60;
                end;

        if (("Check -In Time" >= WorkCalendarDateLine."From Time")) then
            if (("Check -Out Time" <= WorkCalendarDateLine1."To Time")) then begin
                WorkingDuration := "Check -Out Time" - "Check -In Time";
                "Working Hrs" := ((WorkingDuration / 1000) / 60) / 60;
                "Absent Hrs" := 0;
                "Overtime Hrs" := 0
            end
            else
                if "Check -Out Time" >= WorkCalendarDateLine1."To Time" then begin
                    WorkingDuration := WorkCalendarDateLine1."To Time" - "Check -In Time";
                    OvertimeDuration := "Check -Out Time" - WorkCalendarDateLine1."To Time";
                    "Working Hrs" := ((WorkingDuration / 1000) / 60) / 60;
                    "Absent Hrs" := 0;
                    "Overtime Hrs" := ((OvertimeDuration / 1000) / 60) / 60;
                end;

        if (("Check -In Time" >= WorkCalendarDateLine1."To Time")) then
            if "Check -Out Time" >= WorkCalendarDateLine1."To Time" then begin
                OvertimeDuration := "Check -Out Time" - "Check -In Time";
                "Working Hrs" := 0;
                "Absent Hrs" := 0;
                "Overtime Hrs" := ((OvertimeDuration / 1000) / 60) / 60;
            end;

        if WorkingDuration > 0 then
            "Working Hrs" := ((WorkingDuration / 1000) / 60) / 60
        else
            "Working Hrs" := 0;
    end;
}