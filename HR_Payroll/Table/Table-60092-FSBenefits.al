table 60092 "FS Benefits"
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
        field(3; "Benefit Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Benefit Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Ben. Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Ben. Earning Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Transaction Type"; Option)
        {
            OptionCaption = 'Normal,Arrears,FS Current Payroll,FS Accrued,Benefit Claims';
            OptionMembers = Normal,Arrears,"FS Current Payroll","FS Accrued","Benefit Claims";
            DataClassification = CustomerContent;
        }
        field(8; "Calculation Unit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Benefit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Payable Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; Currency; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Suspend Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Earning Code Group"; Code[20])
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
    }

    keys
    {
        key(Key1; "Journal ID", "Employee No.", "Benefit Code", "Payroll Period RecID")
        {
            Clustered = true;
        }
    }

    var
        Employee: Record Employee;
}