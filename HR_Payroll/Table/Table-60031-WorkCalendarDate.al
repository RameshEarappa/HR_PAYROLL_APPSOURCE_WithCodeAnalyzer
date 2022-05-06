table 60031 "Work Calendar Date"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Calendar ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Trans Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Alternative Calendar ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Calculation Type"; Option)
        {
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Has Changed" := true;
            end;
        }
        field(6; Remarks; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Has Changed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Calendar ID", "Trans Date")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        WorkCalendarDateLine.RESET;
        WorkCalendarDateLine.SETRANGE(WorkCalendarDateLine."Calendar ID", "Calendar ID");
        WorkCalendarDateLine.DELETEALL;
    end;

    var
        WorkCalendarDateLine: Record "Work Calendar Date Line";
}