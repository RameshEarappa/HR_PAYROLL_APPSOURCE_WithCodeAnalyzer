table 60137 "Short Leave Line"
{
    Caption = 'Out of Office Line';
    DataClassification = CustomerContent;
    fields
    {
        field(11; "Short Leave Request Id"; Code[20])
        {
            Caption = 'Short Leave Request Id';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF "Short Leave Request Id" <> '' THEN BEGIN

                    HeadRec.RESET;
                    HeadRec.SETRANGE("Short Leave Request Id", "Short Leave Request Id");
                    IF HeadRec.FINDFIRST THEN BEGIN
                        "Employee Id" := HeadRec."Employee Id";
                        "Employee Name" := HeadRec."Employee Name";
                    END;
                END;
            end;
        }
        field(12; "Employee Id"; Code[20])
        {
            Caption = 'Employee Id';
            DataClassification = CustomerContent;
        }
        field(13; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(14; "Leave Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Short Leave';
            OptionMembers = "Short Leave";
            DataClassification = CustomerContent;
        }
        field(15; "Requesht Date"; Date)
        {
            Caption = 'Requested Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                WorkCalendarRec.SETRANGE("Trans Date", "Requesht Date");
                IF WorkCalendarRec.FINDFIRST THEN BEGIN
                    IF WorkCalendarRec."Calculation Type" = WorkCalendarRec."Calculation Type"::"Public Holiday" THEN
                        "Day Type" := "Day Type"::"Public Holiday"
                    ELSE
                        IF WorkCalendarRec."Calculation Type" = WorkCalendarRec."Calculation Type"::"Weekly Off" THEN
                            "Day Type" := "Day Type"::"Weekly Off"
                        ELSE
                            IF WorkCalendarRec."Calculation Type" = WorkCalendarRec."Calculation Type"::"Working Day" THEN
                                "Day Type" := "Day Type"::"Working Day"
                END;

                IF "Day Type" = "Day Type"::"Weekly Off" THEN
                    ERROR('Short Leaves can be applied only Working Days.');
            end;
        }
        field(16; "Req. Start Time"; Time)
        {
            Caption = 'Req. Start Time';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CLEAR("Req. End Time");
                IF "Req. End Time" <> 0T THEN BEGIN
                    ShortLeaveLine.RESET;
                    ShortLeaveLine.SETRANGE("Requesht Date", Rec."Requesht Date");
                    ShortLeaveLine.SETFILTER("Req. Start Time", '>=%1', Rec."Req. Start Time");
                    ShortLeaveLine.SETFILTER("Req. End Time", '<=%1', Rec."Req. End Time");
                    IF ShortLeaveLine.FINDFIRST THEN
                        ERROR('Request Time Overlaps');
                END;
                FromTime;
            end;
        }
        field(17; "Req. End Time"; Time)
        {
            Caption = 'Req. End Time';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CLEAR(TimeConvertion);
                IF "Req. End Time" <> 0T THEN BEGIN
                    IF "Req. End Time" < "Req. Start Time" THEN
                        ERROR('End Time Should be greater that start time');
                END;

                IF "Req. End Time" <> 0T THEN BEGIN
                    TimeConvertion := ("Req. End Time" - "Req. Start Time");
                    "No Hours Requested" := TimeConvertion / 3600000;
                END ELSE
                    "No Hours Requested" := 0;

                IF "Req. End Time" <> 0T THEN BEGIN
                    ShortLeaveLine.RESET;
                    ShortLeaveLine.SETRANGE("Short Leave Request Id", "Short Leave Request Id");
                    ShortLeaveLine.SETRANGE("Employee Id", "Employee Id");
                    ShortLeaveLine.SETRANGE("Requesht Date", Rec."Requesht Date");
                    ShortLeaveLine.SETFILTER("Req. Start Time", '>=%1', Rec."Req. Start Time");
                    ShortLeaveLine.SETFILTER("Req. End Time", '<=%1', Rec."Req. End Time");
                    IF ShortLeaveLine.FINDFIRST THEN
                        ERROR('Request Time Overlaps');
                END;
                ToTime;
            end;
        }
        field(18; "No Hours Requested"; Decimal)
        {
            Caption = 'No Hours Requested';
            DataClassification = CustomerContent;
        }
        field(19; Reason; Text[30])
        {
            Caption = 'Reason';
            DataClassification = CustomerContent;
        }
        field(20; "Day Type"; Option)
        {
            Caption = 'Day Type';
            Editable = false;
            OptionCaption = ',Working Day,Weekly Off,Public Holiday';
            OptionMembers = ,"Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Short Leave Request Id", "Employee Id")
        {
            Clustered = true;
            SumIndexFields = "No Hours Requested";
        }
        key(Key2; "Employee Id", "Requesht Date")
        {
            SumIndexFields = "No Hours Requested";
        }
    }

    trigger OnDelete()
    begin
        HeadRec.RESET;
        HeadRec.SETRANGE("Short Leave Request Id", "Short Leave Request Id");
        IF HeadRec.FINDFIRST THEN
            HeadRec.TESTFIELD(Posted, FALSE);
        HeadRec.RESET;
        HeadRec.SETRANGE("Short Leave Request Id", "Short Leave Request Id");
        IF HeadRec.FINDFIRST THEN
            if HeadRec."WorkFlow Status" <> HeadRec."WorkFlow Status"::Open then
                Error('Workflow Status shoulb  be  Open.');
    end;

    trigger OnModify()
    begin
        HeadRec.RESET;
        HeadRec.SETRANGE("Short Leave Request Id", "Short Leave Request Id");
        IF HeadRec.FINDFIRST THEN
            if HeadRec."WorkFlow Status" <> HeadRec."WorkFlow Status"::Open then
                Error('Workflow Status shoulb  be  Open.');
    end;

    var
        HeadRec: Record "Short Leave Header";
        TimeConvertion: Decimal;
        ShortLeaveLine: Record "Short Leave Line";
        WorkCalendarRec: Record "Work Calendar Date";
        Wdc_FT: Time;
        Wdc_TT: Time;
        EmployeeWorkCalendar: Record "EmployeeWorkDate_GCC";
        EmpEarningCdGP: Record "Employee Earning Code Groups";
        WorkCalendarLineRec: Record "Work Calendar Date Line";

    local procedure FromTime()
    begin
        CLEAR(Wdc_FT);
        CLEAR(Wdc_TT);
        EmpEarningCdGP.RESET;
        EmpEarningCdGP.SETRANGE("Employee Code", "Employee Id");
        EmpEarningCdGP.SETRANGE("Valid To", 0D);
        IF EmpEarningCdGP.FINDFIRST THEN;

        IF "Day Type" = "Day Type"::"Working Day" THEN BEGIN
            EmployeeWorkCalendar.RESET;
            EmployeeWorkCalendar.SETRANGE("Employee Code", "Employee Id");
            EmployeeWorkCalendar.SETRANGE("Trans Date", "Requesht Date");
            IF EmployeeWorkCalendar.FINDFIRST THEN BEGIN
                WorkCalendarLineRec.RESET;
                WorkCalendarLineRec.SETRANGE("Calendar ID", EmpEarningCdGP.Calander);
                WorkCalendarLineRec.SETRANGE("Trans Date", "Requesht Date");
                IF WorkCalendarLineRec.FINDFIRST THEN
                    Wdc_FT := WorkCalendarLineRec."From Time";
            END;
            EmployeeWorkCalendar.RESET;
            EmployeeWorkCalendar.SETRANGE("Employee Code", "Employee Id");
            EmployeeWorkCalendar.SETRANGE("Trans Date", "Requesht Date");
            IF EmployeeWorkCalendar.FINDFIRST THEN BEGIN
                WorkCalendarLineRec.RESET;
                WorkCalendarLineRec.SETRANGE("Calendar ID", EmpEarningCdGP.Calander);
                WorkCalendarLineRec.SETRANGE("Trans Date", "Requesht Date");
                IF WorkCalendarLineRec.FINDLAST THEN
                    Wdc_TT := WorkCalendarLineRec."To Time";
            END;

            IF ("Req. Start Time" < Wdc_FT) OR ("Req. Start Time" > Wdc_TT) THEN
                ERROR('Short Leave Request can be availed between %1 and %2', FORMAT(Wdc_FT), FORMAT(Wdc_TT));
        END;
    end;

    local procedure ToTime()
    begin
        CLEAR(Wdc_FT);
        CLEAR(Wdc_TT);

        EmpEarningCdGP.RESET;
        EmpEarningCdGP.SETRANGE("Employee Code", "Employee Id");
        EmpEarningCdGP.SETRANGE("Valid To", 0D);
        IF EmpEarningCdGP.FINDFIRST THEN;

        IF "Day Type" = "Day Type"::"Working Day" THEN BEGIN
            EmployeeWorkCalendar.RESET;
            EmployeeWorkCalendar.SETRANGE("Employee Code", "Employee Id");
            EmployeeWorkCalendar.SETRANGE("Trans Date", "Requesht Date");
            IF EmployeeWorkCalendar.FINDFIRST THEN BEGIN
                WorkCalendarLineRec.RESET;
                WorkCalendarLineRec.SETRANGE("Calendar ID", EmpEarningCdGP.Calander);
                WorkCalendarLineRec.SETRANGE("Trans Date", "Requesht Date");
                IF WorkCalendarLineRec.FINDFIRST THEN
                    Wdc_FT := WorkCalendarLineRec."From Time";
            END;

            EmployeeWorkCalendar.RESET;
            EmployeeWorkCalendar.SETRANGE("Employee Code", "Employee Id");
            EmployeeWorkCalendar.SETRANGE("Trans Date", "Requesht Date");
            IF EmployeeWorkCalendar.FINDFIRST THEN BEGIN
                WorkCalendarLineRec.RESET;
                WorkCalendarLineRec.SETRANGE("Calendar ID", EmpEarningCdGP.Calander);
                WorkCalendarLineRec.SETRANGE("Trans Date", "Requesht Date");
                IF WorkCalendarLineRec.FINDLAST THEN
                    Wdc_TT := WorkCalendarLineRec."To Time";
            END;

            IF NOT (("Req. End Time" >= Wdc_FT) AND ("Req. End Time" <= Wdc_TT)) THEN
                ERROR('Short Leave Request can be availed between %1 and %2', FORMAT(Wdc_FT), FORMAT(Wdc_TT));
        END;
    end;
}