table 70100 "Employee Accural Amount"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
            Editable = false;
        }
        field(21; "Employee Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "Accued Units"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; "Accrued Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(24; "Sum of Earning Code"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(25; "Accured per day Amounts"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(26; "Updated By"; Code[150])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(27; "Updated Date/Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(28; "Procced"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(29; "Calc. Formula"; Code[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Employee No.")
        {
            Clustered = true;
        }
    }
}