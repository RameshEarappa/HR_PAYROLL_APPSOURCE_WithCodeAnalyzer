table 60095 "Payroll Error Log"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Payroll Statement ID"; Code[20])
        {
            TableRelation = "Payroll Statement";
            DataClassification = CustomerContent;
        }
        field(3; "HCM Worker"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(4; Error; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Payroll Statement ID")
        {
        }
    }
}