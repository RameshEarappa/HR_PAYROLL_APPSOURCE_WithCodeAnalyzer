table 60073 "Payroll Skill Level"
{
    DrillDownPageID = "Payroll Skill Level";
    LookupPageID = "Payroll Skill Level";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Level ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Rating; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Level ID")
        {
            Clustered = true;
        }
    }
}

