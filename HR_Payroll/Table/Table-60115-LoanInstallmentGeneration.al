table 60115 "Loan Installment Generation"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Loan Request ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; Loan; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Loan Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Employee ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Employee Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Installament Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Principal Installment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Interest Installment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; Currency; Code[50])
        {
            TableRelation = Currency.Code;
            DataClassification = CustomerContent;
        }
        field(11; Status; Option)
        {
            OptionCaption = ',Unrecovered,Recovered,Adjusted';
            OptionMembers = ,Unrecovered,Recovered,Adjusted;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee ID", "Installament Date", Loan)
        {
        }
    }
}