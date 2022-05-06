table 60050 "Payroll Job Skill Master"
{
    DrillDownPageID = "Payroll Job Skills";
    LookupPageID = "Payroll Job Skills";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Skill ID"; Code[20])
        {
            Caption = 'Skill';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Skill Type"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; Rating; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Skill ID")
        {
            Clustered = true;
        }
    }
}
