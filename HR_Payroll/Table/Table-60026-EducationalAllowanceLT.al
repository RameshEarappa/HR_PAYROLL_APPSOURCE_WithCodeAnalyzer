table 60026 "Educational Allowance LT"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Grade Category"; Code[50])
        {
            TableRelation = "Payroll Grade Category";
            DataClassification = CustomerContent;
        }
        field(2; "Earnings Code Group"; Code[20])
        {
            TableRelation = "Earning Code Groups";
            DataClassification = CustomerContent;
        }
        field(21; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Edu. Allow. Eligible Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Edu. Allow. Min Age"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Edu. Allow. Max Age"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Count of children eligible"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Education Type - Full time"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Book Allow. Elemantary School"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Book Allow. Secondary Level"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(29; "Book Allow. University Level"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Special Applicable"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Special Eligible Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Grade Category", "Earnings Code Group")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    begin
        ERROR('You cannot delete any records for Education Allowance');
    end;
}