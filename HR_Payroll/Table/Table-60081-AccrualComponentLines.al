table 60081 "Accrual Component Lines"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Accrual ID"; Code[20])
        {
            TableRelation = "Accrual Components";
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Interval Month Start"; Integer)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Interval Month Start" <> 0 then begin
                    AccrualComponents.GET("Accrual ID");
                    if AccrualComponents."Months Ahead Calculate" < "Interval Month Start" then
                        ERROR('You cannot enter intervals more than %1', AccrualComponents."Months Ahead Calculate");
                end;
            end;
        }
        field(4; "Interval Month End"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Accrual Units Per Month"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Opening Additional Accural"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Max Carry Forward"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "CarryForward Lapse After Month"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Repeat After Months"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Avail Allow Till"; Option)
        {
            OptionCaption = 'Accrual Till Date,End of Period';
            OptionMembers = "Accrual Till Date","End of Period";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Accrual ID", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        AccrualComponents: Record "Accrual Components";
}