table 60093 "FS Loans"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Loan Request ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; Loan; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "EMI Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Interest Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Installment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; Currency; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Earning Code Group"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(10; "EmployeeEarning Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Journal ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Payroll Period RecID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Installment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Journal ID", "Employee No.", Loan, "Payroll Period RecID", "EmployeeEarning Code")
        {
            Clustered = true;
        }
    }

    var
        Employee: Record Employee;
}