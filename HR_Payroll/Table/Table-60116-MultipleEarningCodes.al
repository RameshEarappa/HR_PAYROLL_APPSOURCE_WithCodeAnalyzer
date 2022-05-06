table 60116 "Multiple Earning Codes"
{
    DrillDownPageID = "Multiple Earning Codes";
    LookupPageID = "Multiple Earning Codes";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Loan Code"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Earning Code"; Code[50])
        {
            TableRelation = "Payroll Earning Code"."Earning Code";
            DataClassification = CustomerContent;
        }
        field(3; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Loan Code", "Earning Code")
        {
            Clustered = true;
        }
    }
}