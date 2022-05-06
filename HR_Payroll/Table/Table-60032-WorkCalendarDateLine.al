table 60032 "Work Calendar Date Line"
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
        field(3; "From Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(4; "To Time"; Time)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Hours := "To Time" - "From Time";
                Hours := Hours / 3600000;
            end;
        }
        field(5; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; Hours; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Shift Split"; Option)
        {
            OptionCaption = ' ,First Half,Second Half';
            OptionMembers = " ","First Half","Second Half";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Calendar ID", "Trans Date", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Hours;
        }
    }
}