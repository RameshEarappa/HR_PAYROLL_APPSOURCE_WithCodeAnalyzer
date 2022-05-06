table 60039 "Pay Periods"
{
    DrillDownPageID = "Pay Periods List";
    LookupPageID = "Pay Periods List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Pay Cycle"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Period Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Period End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; Year; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; Month; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(8; Status; Option)
        {
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
            DataClassification = CustomerContent;
        }
        field(104; "Enable Payroll Statements"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Pay Cycle", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Pay Cycle", "Period Start Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Pay Cycle", "Period Start Date", "Period End Date")
        {
        }
    }
}