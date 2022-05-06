table 60028 "Work Time Template"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Work Time ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Template Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Monday Calculation Type"; Option)
        {
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(4; "Tuesday Calculation Type"; Option)
        {
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(5; "Wednesday Calculation Type"; Option)
        {
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(6; "Thursday Calculation Type"; Option)
        {
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(7; "Friday Calculation Type"; Option)
        {
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(8; "Saturday Calculation Type"; Option)
        {
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(9; "Sunday Calculation Type"; Option)
        {
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(10; "Monday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                     Weekday = CONST(Monday)));
            FieldClass = FlowField;
        }
        field(11; "Tuesday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                     Weekday = CONST(Tuesday)));
            FieldClass = FlowField;
        }
        field(12; "Wednesday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                     Weekday = CONST(Wednesday)));
            FieldClass = FlowField;
        }
        field(13; "Thursday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                     Weekday = CONST(Thursday)));
            FieldClass = FlowField;
        }
        field(14; "Friday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                     Weekday = CONST(Friday)));
            FieldClass = FlowField;
        }
        field(15; "Saturday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                     Weekday = CONST(Saturday)));
            FieldClass = FlowField;
        }
        field(16; "Sunday No. Of Hours"; Decimal)
        {
            CalcFormula = Sum("Work Time Line"."No. Of Hours" WHERE("Work Time ID" = FIELD("Work Time ID"),
                                                                     Weekday = CONST(Sunday)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Work Time ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        WorkTimeLine.RESET;
        WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time ID");
        WorkTimeLine.DELETEALL;
    end;

    var
        WorkTimeLine: Record "Work Time Line";
}