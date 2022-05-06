report 60039 "CopyWorkTime Templat- Ramadn"
{
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {

                    Caption = 'Options';
                    field("From Week Day"; FromWeekDay)
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field("To Weekday"; ToWeekDay)
                    {
                        ApplicationArea = all;
                    }
                    field("Copy To All Days"; CopyToAllWeekDay)
                    {
                        ApplicationArea = all;
                        trigger OnValidate();
                        begin
                            if CopyToAllWeekDay then
                                ToWeekDay := ToWeekDay::" "
                            else begin
                                if FromWeekDay <> 7 then
                                    ToWeekDay := FromWeekDay + 1
                                else
                                    if FromWeekDay = 7 then
                                        ToWeekDay := 1;
                            end;
                        end;
                    }
                }
            }
        }

        trigger OnClosePage();
        begin
            if not CopyToAllWeekDay then
                if ToWeekDay = ToWeekDay::" " then
                    ERROR('To Weekday should not be blank');
        end;
    }

    trigger OnPreReport();
    var
        i: Integer;
    begin
        if not CopyToAllWeekDay then begin
            WorkTimeLine4.RESET;
            WorkTimeLine4.SETRANGE("Work Time ID", WorkTimeTemplate."Work Time ID");
            WorkTimeLine4.SETRANGE(Weekday, ToWeekDay);
            WorkTimeLine4.DELETEALL;
            WorkTimeLine.RESET;
            WorkTimeLine.SETRANGE("Work Time ID", WorkTimeTemplate."Work Time ID");
            WorkTimeLine.SETRANGE(Weekday, FromWeekDay);
            if WorkTimeLine.FINDFIRST then
                repeat
                    WorkTimeLine3.RESET;
                    WorkTimeLine3.SETRANGE("Work Time ID", WorkTimeTemplate."Work Time ID");
                    if WorkTimeLine3.FINDLAST then;
                    WorkTimeLine2.INIT;
                    WorkTimeLine2.COPY(WorkTimeLine);
                    WorkTimeLine2.VALIDATE("To Time", WorkTimeLine."To Time");
                    WorkTimeLine2."Line No." := WorkTimeLine3."Line No." + 10000;
                    WorkTimeLine2.Weekday := ToWeekDay;
                    WorkTimeLine2.INSERT;
                until WorkTimeLine.NEXT = 0;
        end
        else begin
            WorkTimeLine4.RESET;
            WorkTimeLine4.SETRANGE("Work Time ID", WorkTimeTemplate."Work Time ID");
            WorkTimeLine4.SETFILTER(Weekday, '<>%1', FromWeekDay);
            WorkTimeLine4.DELETEALL;
            for i := 1 to 7 do begin

                WorkTimeLine.RESET;
                WorkTimeLine.SETRANGE("Work Time ID", WorkTimeTemplate."Work Time ID");
                WorkTimeLine.SETRANGE(Weekday, FromWeekDay);
                if WorkTimeLine.FINDFIRST then
                    repeat
                        WorkTimeLine3.RESET;
                        WorkTimeLine3.SETRANGE("Work Time ID", WorkTimeTemplate."Work Time ID");
                        if WorkTimeLine3.FINDLAST then;
                        if i <> FromWeekDay then begin
                            WorkTimeLine2.INIT;
                            WorkTimeLine2.COPY(WorkTimeLine);
                            WorkTimeLine2.VALIDATE("To Time", WorkTimeLine."To Time");
                            WorkTimeLine2."Line No." := WorkTimeLine3."Line No." + 10000;
                            WorkTimeLine2.Weekday := i;
                            WorkTimeLine2.INSERT;
                        end;
                    until WorkTimeLine.NEXT = 0;
            end;
        end;
    end;

    var
        FromWeekDay: Option " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        ToWeekDay: Option " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        CopyToAllWeekDay: Boolean;
        WorkTimeTemplate: Record "Work Time Template - Ramadn";
        WorkTimeLine: Record "Work Time Line - Ramadn";
        WorkTimeLine2: Record "Work Time Line - Ramadn";
        WorkTimeLine3: Record "Work Time Line - Ramadn";
        WorkTimeLine4: Record "Work Time Line - Ramadn";

    procedure SetFromWeekday(l_FromWeekday: Option " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday; l_WorkTimeTemplate: Record "Work Time Template - Ramadn");
    begin
        FromWeekDay := l_FromWeekday;
        WorkTimeTemplate := l_WorkTimeTemplate;
        if FromWeekDay <> 7 then
            ToWeekDay := FromWeekDay + 1
        else
            if FromWeekDay = 7 then
                ToWeekDay := 1;
    end;
}