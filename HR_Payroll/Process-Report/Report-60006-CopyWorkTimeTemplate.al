report 60006 "Copy Work Time Template"
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
                    field("From Work Time ID"; FromWorkTimeID)
                    {
                        TableRelation = "Work Time Template";
                        ApplicationArea = all;
                    }
                    field("To Work From ID"; ToWorkTimeID)
                    {
                        TableRelation = "Work Time Template";
                        ApplicationArea = all;
                    }
                }
            }
        }

        trigger OnClosePage();
        begin
            if FromWorkTimeID = ToWorkTimeID then
                ERROR('From and To Work Time IDs cannot be same');

            if (FromWorkTimeID = '') or (ToWorkTimeID = '') then
                ERROR('From or To Work time ID cannot be blank');
        end;
    }

    trigger OnPreReport();
    var
        i: Integer;
    begin
        FromWorkTimeTemplate.Reset();
        if FromWorkTimeTemplate.GET(FromWorkTimeID) then begin
            repeat
                ToWorkTimeTemplate.GET(ToWorkTimeID);
                ToWorkTimeTemplate."Monday Calculation Type" := FromWorkTimeTemplate."Monday Calculation Type";
                ToWorkTimeTemplate."Tuesday Calculation Type" := FromWorkTimeTemplate."Tuesday Calculation Type";
                ToWorkTimeTemplate."Wednesday Calculation Type" := FromWorkTimeTemplate."Wednesday Calculation Type";
                ToWorkTimeTemplate."Thursday Calculation Type" := FromWorkTimeTemplate."Thursday Calculation Type";
                ToWorkTimeTemplate."Friday Calculation Type" := FromWorkTimeTemplate."Friday Calculation Type";
                ToWorkTimeTemplate."Saturday Calculation Type" := FromWorkTimeTemplate."Saturday Calculation Type";
                ToWorkTimeTemplate."Sunday Calculation Type" := FromWorkTimeTemplate."Sunday Calculation Type";
                ToWorkTimeTemplate.MODIFY;
                ToWorkTimeLine.RESET;
                ToWorkTimeLine.SETRANGE("Work Time ID", ToWorkTimeID);
                ToWorkTimeLine.DELETEALL;
                FromWorkTimeLine.RESET;
                FromWorkTimeLine.SETRANGE("Work Time ID", FromWorkTimeTemplate."Work Time ID");
                if FromWorkTimeLine.FINDFIRST then
                    repeat
                        ToWorkTimeLine.INIT;
                        ToWorkTimeLine.COPY(FromWorkTimeLine);
                        ToWorkTimeLine."Work Time ID" := ToWorkTimeID;
                        ToWorkTimeLine.INSERT;
                    until FromWorkTimeLine.NEXT = 0;
            until FromWorkTimeTemplate.Next() = 0;
        end;
    end;

    var
        FromWorkTimeID: Code[20];
        ToWorkTimeID: Code[20];
        FromWorkTimeTemplate: Record "Work Time Template";
        FromWorkTimeLine: Record "Work Time Line";
        FromWorkTimeLine2: Record "Work Time Line";
        ToWorkTimeLine: Record "Work Time Line";
        ToWorkTimeTemplate: Record "Work Time Template";

    procedure SetValues(l_FromWorkTimeID: Code[20]; l_ToWorktimeID: Code[20]);
    begin
        FromWorkTimeID := l_FromWorkTimeID;
        ToWorkTimeID := l_ToWorktimeID;
    end;
}