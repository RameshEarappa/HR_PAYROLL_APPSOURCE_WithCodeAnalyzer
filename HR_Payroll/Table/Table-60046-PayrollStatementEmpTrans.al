table 60046 "Payroll Statement Emp Trans."
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Payroll Statment Employee"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Payroll Statement ID"; Code[20])
        {
            TableRelation = "Payroll Statement";
            DataClassification = CustomerContent;
        }
        field(4; "Payroll Pay Cycle"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Payroll Pay Period"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Payroll Year"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Payroll Month"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(8; Worker; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(9; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(10; "From Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(11; "To Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; Voucher; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Payroll Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Payroll Earning Code Desc"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Earning Code Type"; Option)
        {
            OptionCaption = 'Pay Component,Benefit,Loan,Leave,Other';
            OptionMembers = "Pay Component",Benefit,Loan,Leave,Other;
            DataClassification = CustomerContent;
        }
        field(16; "Earning Code Calc Sub Type"; Option)
        {
            OptionCaption = 'Fixed,Variable';
            OptionMembers = "Fixed",Variable;
            DataClassification = CustomerContent;
        }
        field(17; "Earning Code Calc Class"; Option)
        {
            OptionCaption = 'Payroll,Non Payroll';
            OptionMembers = Payroll,"Non Payroll";
            DataClassification = CustomerContent;
        }
        field(18; "Earniing Code Short Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(19; "Earning Code Arabic Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Benefit Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Benefit Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Benefit Short Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Benenfit Arabic Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(24; "Calculation Units"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Per Unit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Earning Code Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Benefit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(28; Remarks; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(29; "Calculation Basis Type"; Option)
        {
            OptionCaption = 'Days,Hours,Months';
            OptionMembers = Days,Hours,Months;
            DataClassification = CustomerContent;
        }
        field(30; "Fin Accural Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Default Dimension"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(32; "Payroll Component Type"; Option)
        {
            OptionCaption = 'Pay Component,Benefit,Pay Adjustment,Benefit Adjustment,Loan,Other Adjustment';
            OptionMembers = "Pay Component",Benefit,"Pay Adjustment","Benefit Adjustment",Loan,"Other Adjustment";
            DataClassification = CustomerContent;
        }
        field(33; RefRecID; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(34; "Payroll Transaction Type"; Option)
        {
            OptionCaption = 'Normal,Arrears,Final Settlement Current Payroll, Final Settlement Accrued,Benefit Claims';
            OptionMembers = Normal,Arrears,"Final Settlement Current Payroll"," Final Settlement Accrued","Benefit Claims";
            DataClassification = CustomerContent;
        }
        field(35; "Benefit Encashment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(36; Pension; Option)
        {
            OptionCaption = 'None,Employee Contribution,Employer Contribution';
            OptionMembers = "None","Employee Contribution","Employer Contribution";
            DataClassification = CustomerContent;
        }
        field(37; "Suspend Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(38; "Temporary Payroll Hold"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(39; "Currency Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(100; "Payroll Period RecID"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Payroll Statement ID", "Payroll Statment Employee", "Line No.")
        {
            Clustered = true;
        }
    }
}