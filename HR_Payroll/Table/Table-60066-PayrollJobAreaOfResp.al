table 60066 "Payroll Job Area Of Resp."
{
    DrillDownPageID = "Payroll Job Area of Resp.";
    LookupPageID = "Payroll Job Area of Resp.";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Area of Responsibility"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Notes; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Area of Responsibility")
        {
            Clustered = true;
        }
    }
}