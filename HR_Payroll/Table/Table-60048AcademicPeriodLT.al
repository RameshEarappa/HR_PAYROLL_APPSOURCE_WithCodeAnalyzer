table 60048 "Academic Period LT"
{
    LookupPageId = "Academic Period List";
    DrillDownPageId = "Academic Period List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Academic Period"; Code[20])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                AcademicPerRecG.RESET;
                if AcademicPerRecG.FINDLAST then
                    "Start Date" := AcademicPerRecG."End Date" + 1;
            end;
        }
        field(11; "Start Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "End Date" <> 0D then
                    if ("Start Date" >= "End Date") then
                        ERROR('Start Date should not greater than End Date.');
                ValidateDate;
            end;
        }
        field(12; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "End Date" <= "Start Date" then
                    ERROR('End Date always greater than Start Date.');

                ValidateDate;
            end;
        }
        field(13; Closed; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Academic Period", "Start Date", "End Date")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        CLEAR(EdClHeader);
        EdClHeader.SETRANGE("Academic year", "Academic Period");
        if EdClHeader.FINDFIRST then
            ERROR(Text001, "Academic Period");
    end;

    var
        AcademicPerRecG: Record "Academic Period LT";
        EdClHeader: Record "Educational Claim Header LT";
        Text001: Label 'Academic Year %1 is being used in Educational Claim. Delete the Educational Claim first.';

    local procedure CheckStartingDateByUser()
    var
        AcademicPeriodLT: Record "Academic Period LT";
    begin
        AcademicPeriodLT.RESET;
        AcademicPeriodLT.SETCURRENTKEY("Academic Period", "Start Date", "End Date");
        AcademicPeriodLT.SETASCENDING("Start Date", true);
        if AcademicPeriodLT.FINDFIRST then begin
            MESSAGE('SD %1', AcademicPeriodLT."Start Date");
            if "Start Date" <= AcademicPeriodLT."Start Date" then begin
                MESSAGE('SD %1', AcademicPeriodLT."Start Date");
                ERROR('Date is overlaping');
            end;
        end;

        AcademicPeriodLT.RESET;
        AcademicPeriodLT.SETCURRENTKEY("Academic Period", "Start Date", "End Date");
        AcademicPeriodLT.SETASCENDING("Start Date", true);
        if AcademicPeriodLT.FINDLAST then begin
            MESSAGE('ED %1', AcademicPeriodLT."End Date");
            if "Start Date" <= AcademicPeriodLT."End Date" then begin
                MESSAGE('ED %1', AcademicPeriodLT."End Date");
                ERROR('Date is overlaping');
            end;
        end;
    end;

    local procedure CheckEndingDateByUser()
    var
        AcademicPeriodLT: Record "Academic Period LT";
    begin
        AcademicPeriodLT.RESET;
        AcademicPeriodLT.SETCURRENTKEY("Academic Period", "Start Date", "End Date");
        AcademicPeriodLT.SETASCENDING("End Date", true);
        if AcademicPeriodLT.FINDLAST then
            if ("End Date" <= AcademicPeriodLT."End Date") then
                ERROR('Date is overlaping');
    end;

    procedure ValidateDate()
    begin
        if "Start Date" <> 0D then begin
            AcademicPerRecG.RESET;
            AcademicPerRecG.SETFILTER("Start Date", '<=%1', "Start Date");
            AcademicPerRecG.SETFILTER("End Date", '>=%1', "Start Date");
            if AcademicPerRecG.FINDFIRST then
                ERROR('Date Overlaps with Academic year %1', AcademicPerRecG."Academic Period");
        end;

        if "End Date" <> 0D then begin
            AcademicPerRecG.RESET;
            AcademicPerRecG.SETFILTER("Start Date", '<=%1', "End Date");
            AcademicPerRecG.SETFILTER("End Date", '>=%1', "End Date");
            if AcademicPerRecG.FINDFIRST then
                ERROR('Date Overlaps with Academic year %1', AcademicPerRecG."Academic Period");
        end;

        if ("Start Date" <> 0D) and ("End Date" <> 0D) then begin
            AcademicPerRecG.RESET;
            AcademicPerRecG.SETFILTER("Start Date", '>=%1', "Start Date");
            AcademicPerRecG.SETFILTER("End Date", '<=%1', "End Date");
            if AcademicPerRecG.FINDFIRST then
                ERROR('Start Date and End Date is not Valid');
        end;
    end;
}