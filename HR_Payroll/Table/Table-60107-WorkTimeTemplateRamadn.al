table 60107 "Work Time Template - Ramadn"
{
    Caption = 'Work Time Template - Ramadn';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Work Time ID"; Code[100])
        {
            Caption = 'Work Time ID';
            DataClassification = CustomerContent;
        }
        field(2; "Template Name"; Text[100])
        {
            Caption = 'Template Name';
            DataClassification = CustomerContent;
        }
        field(3; "Monday Calculation Type"; Option)
        {
            Caption = 'Monday Calculation Type';
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(4; "Tuesday Calculation Type"; Option)
        {
            Caption = 'Tuesday Calculation Type';
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(5; "Wednesday Calculation Type"; Option)
        {
            Caption = 'Wednesday Calculation Type';
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(6; "Thursday Calculation Type"; Option)
        {
            Caption = 'Thursday Calculation Type';
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(7; "Friday Calculation Type"; Option)
        {
            Caption = 'Friday Calculation Type';
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(8; "Saturday Calculation Type"; Option)
        {
            Caption = 'Saturday Calculation Type';
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(9; "Sunday Calculation Type"; Option)
        {
            Caption = 'Sunday Calculation Type';
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(10; "Monday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line - Ramadn"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                              Weekday = CONST(Monday)));
            Caption = 'Monday No. Of Hours';
            FieldClass = FlowField;
        }
        field(11; "Tuesday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line - Ramadn"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                              Weekday = CONST(Tuesday)));
            Caption = 'Tuesday No. Of Hours';
            FieldClass = FlowField;
        }
        field(12; "Wednesday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line - Ramadn"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                              Weekday = CONST(Wednesday)));
            Caption = 'Wednesday No. Of Hours';
            FieldClass = FlowField;
        }
        field(13; "Thursday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line - Ramadn"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                              Weekday = CONST(Thursday)));
            Caption = 'Thursday No. Of Hours';
            FieldClass = FlowField;
        }
        field(14; "Friday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line - Ramadn"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                              Weekday = CONST(Friday)));
            Caption = 'Friday No. Of Hours';
            FieldClass = FlowField;
        }
        field(15; "Saturday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line - Ramadn"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                              Weekday = CONST(Saturday)));
            Caption = 'Saturday No. Of Hours';
            FieldClass = FlowField;
        }
        field(16; "Sunday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line - Ramadn"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                              Weekday = CONST(Sunday)));
            Caption = 'Sunday No. Of Hours';
            FieldClass = FlowField;
        }
        field(17; "From Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(18; "To Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "To Date" <> 0D then begin
                    if "To Date" > "From Date" then
                        MESSAGE(DateErr);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Work Time ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        WorkTimeLine.RESET;
        WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
        WorkTimeLine.DELETEALL;
    end;

    var
        WorkTimeLine: Record "Work Time Line";
        DateErr: Label 'To date cannot be greater than From date ';
        WeekDayTxt: Text;
        WeekDayOpt: Integer;

    procedure UpdateCalTime()
    var
        WorkCalDateLineRec: Record "Work Calendar Date Line";
        l_LineRec: Record "Work Time Line - Ramadn";
        Period: Record Date;
    begin
        Period.RESET;
        Period.SETCURRENTKEY("Period Type", "Period Start");
        Period.SETRANGE("Period Type", Period."Period Type"::Date);
        Period.SETRANGE("Period Start", "From Date", "To Date");
        if Period.FINDSET then begin
            repeat
                l_LineRec.RESET;
                l_LineRec.SETRANGE("Work Time ID", "Work Time ID");
                l_LineRec.SETRANGE(Weekday, Period."Period No.");
                if l_LineRec.FINDSET then
                    repeat
                        WorkCalDateLineRec.RESET;
                        WorkCalDateLineRec.SETCURRENTKEY("Calendar ID", "Trans Date", "Line No.");
                        WorkCalDateLineRec.SETRANGE("Calendar ID", "Work Time ID");
                        WorkCalDateLineRec.SETRANGE("Trans Date", Period."Period Start");
                        WorkCalDateLineRec.SETRANGE("Shift Split", l_LineRec."Shift Split");
                        if WorkCalDateLineRec.FINDFIRST then begin
                            WorkCalDateLineRec.VALIDATE("From Time", l_LineRec."From Time");
                            WorkCalDateLineRec.VALIDATE("To Time", l_LineRec."To Time");
                            WorkCalDateLineRec.Hours := l_LineRec."No. Of Hours";
                            WorkCalDateLineRec.MODIFY;
                        end
                        else
                            ERROR('There is not Work time Calendar defined for the date %1', Period."Period Start");
                    until l_LineRec.NEXT = 0;
            until Period.NEXT = 0;
        end;
        MESSAGE('Ramadan Calendar updated successfully');
    end;

    local procedure FindWeekday(): Integer
    begin
        CLEAR(WeekDayOpt);
        if WeekDayTxt = 'Monday' then
            WeekDayOpt := 1
        else
            if WeekDayTxt = 'Tuesday' then
                WeekDayOpt := 2
            else
                if WeekDayTxt = 'Wednesday' then
                    WeekDayOpt := 3
                else
                    if WeekDayTxt = 'Thursday' then
                        WeekDayOpt := 4
                    else
                        if WeekDayTxt = 'Friday' then
                            WeekDayOpt := 5
                        else
                            if WeekDayTxt = 'Saturday' then
                                WeekDayOpt := 6
                            else
                                if WeekDayTxt = 'Sunday' then
                                    WeekDayOpt := 7;
    end;
}