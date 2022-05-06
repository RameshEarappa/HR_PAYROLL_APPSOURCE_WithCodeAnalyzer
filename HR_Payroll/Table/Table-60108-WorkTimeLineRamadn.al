table 60108 "Work Time Line - Ramadn"
{
    Caption = 'Work Time Line - Ramadn';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Work Time ID"; Code[20])
        {
            Caption = 'Work Time ID';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; Weekday; Option)
        {
            Caption = 'Weekday';
            OptionCaption = ' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            DataClassification = CustomerContent;
        }
        field(4; "From Time"; Time)
        {
            Caption = 'From Time';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "To Time" <> 0T then begin
                    if "From Time" >= "To Time" then
                        ERROR('Invalid From time ');

                    if "From Time" <> xRec."From Time" then begin
                        WorkTimeLine.RESET;
                        WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
                        WorkTimeLine.SETRANGE(Weekday, Weekday);
                        WorkTimeLine.SETFILTER("Line No.", '<>%1', "Line No.");
                        if WorkTimeLine.FINDFIRST then begin
                            if WorkTimeLine."From Time" >= "From Time" then
                                ERROR('Work time line exists, Select Valid From Time');
                        end;
                    end;
                end;

                if "To Time" <> 0T then
                    if "From Time" > "To Time" then
                        Duration := "From Time" - "To Time"
                    else
                        Duration := "To Time" - "From Time";

                if Duration <> 0 then
                    "No. Of Hours" := (((Duration / 1000) / 60) / 60);
            end;
        }
        field(5; "To Time"; Time)
        {
            Caption = 'To Time';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TESTFIELD("From Time");
                TESTFIELD("To Time");


                if "From Time" = "To Time" then
                    ERROR('From time and to time cannot be same ');

                if "To Time" <> xRec."To Time" then begin
                    WorkTimeLine.RESET;
                    WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
                    WorkTimeLine.SETRANGE(Weekday, Weekday);
                    WorkTimeLine.SETFILTER("Line No.", '<>%1', "Line No.");
                    if WorkTimeLine.FINDFIRST then begin
                        if WorkTimeLine."To Time" <= "To Time" then
                            ERROR('Work time line exists, Select Valid To Time');
                        WorkTimeLine."From Time" := "To Time";
                        WorkTimeLine.MODIFY;
                    end;
                end;

                if "To Time" <> 000000T then
                    if "From Time" > "To Time" then
                        Duration := "From Time" - "To Time"
                    else
                        Duration := "To Time" - "From Time";

                if Duration <> 0 then
                    "No. Of Hours" := (((Duration / 1000) / 60) / 60);
            end;
        }
        field(6; "Shift Split"; Option)
        {
            Caption = 'Shift Split';
            OptionCaption = ' ,First Half,Second Half';
            OptionMembers = " ","First Half","Second Half";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                WorkTimeLine.RESET;
                WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
                WorkTimeLine.SETRANGE(Weekday, Rec.Weekday);
                WorkTimeLine.SETRANGE("Shift Split", "Shift Split");
                if WorkTimeLine.FINDSET then
                    ERROR('Invalid Shift Split');
            end;
        }
        field(7; "No. Of Hours"; Decimal)
        {
            Caption = 'No. Of Hours';
            DataClassification = CustomerContent;
        }
        field(8; Duration; Duration)
        {
            Caption = 'Duration';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Work Time ID", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        WorkTimeLine.RESET;
        WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
        WorkTimeLine.SETRANGE(Weekday, Rec.Weekday);
        if WorkTimeLine.FINDSET then
            if WorkTimeLine.COUNT = 2 then
                ERROR('First and Second shift split exists');

        WorkTimeLine.RESET;
        WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
        WorkTimeLine.SETRANGE(Weekday, Rec.Weekday);
        if WorkTimeLine.FINDFIRST then
            repeat
                if (WorkTimeLine."From Time" < "From Time") and (WorkTimeLine."To Time" > "From Time") then
                    ERROR('Work Time already exist for from time %1', "From Time");

                if (WorkTimeLine."From Time" > "To Time") and (WorkTimeLine."To Time" < "To Time") then
                    ERROR('Work Time already exist for To time %1', "To Time");
            until WorkTimeLine.NEXT = 0;

        WorkTimeLine.RESET;
        WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
        WorkTimeLine.SETRANGE(Weekday, Rec.Weekday);
        if WorkTimeLine.FINDLAST then begin
            if WorkTimeLine."To Time" <> "From Time" then
                ERROR('From time should be %1', WorkTimeLine."To Time");
        end;

        WorkTimeLine.RESET;
        WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
        WorkTimeLine.SETRANGE(Weekday, Rec.Weekday);
        WorkTimeLine.SETRANGE("From Time", "From Time");
        WorkTimeLine.SETRANGE("To Time", "To Time");
        if WorkTimeLine.FINDFIRST then
            ERROR('Worktime lines already exist');

        WorkTimeLine.RESET;
        WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
        WorkTimeLine.SETRANGE(Weekday, Rec.Weekday);
        WorkTimeLine.SETRANGE("Shift Split", Rec."Shift Split");
        if WorkTimeLine.FINDFIRST then
            ERROR('Invalid Shift Split');
    end;

    trigger OnModify()
    begin
        WorkTimeLine.RESET;
        WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
        WorkTimeLine.SETRANGE(Weekday, Rec.Weekday);
        if WorkTimeLine.FINDSET then
            if WorkTimeLine.COUNT > 2 then
                ERROR('First and Second shift split exists');

        if Rec."Shift Split" = Rec."Shift Split"::" " then
            ERROR('Select Shift Split ');
    end;

    var
        WorkTimeLine: Record "Work Time Line - Ramadn";
}