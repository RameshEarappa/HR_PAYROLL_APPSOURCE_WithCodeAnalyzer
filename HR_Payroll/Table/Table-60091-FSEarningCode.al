table 60091 "FS - Earning Code"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Employee No." <> '' then begin
                    Employee.GET("Employee No.");
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Last Name";
                    EmployeeEarningCodeGroups.RESET;
                    EmployeeEarningCodeGroups.SETRANGE("Employee Code", Employee."No.");
                    EmployeeEarningCodeGroups.SETFILTER("Valid From", '<=%1', WORKDATE);
                    EmployeeEarningCodeGroups.SETFILTER("Valid To", '>=%1|%2', WORKDATE, 0D);
                    if EmployeeEarningCodeGroups.FINDFIRST then begin
                        "Earning Code Group" := EmployeeEarningCodeGroups."Earning Code Group";
                        Currency := EmployeeEarningCodeGroups.Currency;
                    end;
                end
                else begin
                    "Employee Name" := '';
                    Currency := '';
                    "Earning Code Group" := '';
                end;
            end;
        }
        field(2; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Earning Code"; Code[20])
        {
            TableRelation = "Payroll Earning Code";
            DataClassification = CustomerContent;
        }
        field(4; "Earning Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Pay Cycle"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Payroll Period"; Text[250])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                PayPeriods.FILTERGROUP(2);
                PayPeriods.RESET;
                PayPeriods.SETRANGE("Pay Cycle", Rec."Pay Cycle");
                PayPeriods.FILTERGROUP(0);

                if PAGE.RUNMODAL(60071, PayPeriods) = ACTION::LookupOK then begin
                    VALIDATE("Pay Period", PayPeriods."Pay Cycle");
                    VALIDATE("Payroll Period", PayPeriods."Pay Cycle" + ': ' + FORMAT(PayPeriods."Period Start Date") + '-' + FORMAT(PayPeriods."Period End Date"));
                    VALIDATE("Pay Period Start", PayPeriods."Period Start Date");
                    VALIDATE("Pay Period End", PayPeriods."Period End Date");
                    VALIDATE("Payroll Period RecID", PayPeriods."Line No.");
                end;
            end;

            trigger OnValidate()
            begin
                if "Payroll Period" = '' then begin
                    "Pay Period Start" := 0D;
                    "Pay Period End" := 0D;
                    "Payroll Period RecID" := 0;
                end;
            end;
        }
        field(7; "Payroll Period RecID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Pay Period Start"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Pay Period End"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Earning Code Calc Class"; Option)
        {
            Caption = 'Earning Code Calculation Class';
            OptionCaption = ' ,Payroll,NonPayroll';
            OptionMembers = " ",Payroll,NonPayroll;
            DataClassification = CustomerContent;
        }
        field(11; "Pay Period"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Calculation Units"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Earning Code Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Payable Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; Currency; Code[20])
        {
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(16; "Transaction Type"; Option)
        {
            OptionCaption = 'Normal,Arrears,FS Current Payroll,FS Accrued,Benefit Claims';
            OptionMembers = Normal,Arrears,"FS Current Payroll","FS Accrued","Benefit Claims";
            DataClassification = CustomerContent;
        }
        field(17; "Suspend Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Temporary Payroll Hold"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Earning Code Group"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Journal ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Benefit Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Benefit Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Ben. Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(24; "Ben. Earning Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(25; "Benefit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60055; "Final Settlement Component"; Boolean)
        {
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(Key1; "Journal ID", "Employee No.", "Earning Code", "Payroll Period RecID", "Benefit Code")
        {
            Clustered = true;
        }
        key(Key2; "Journal ID", "Benefit Code")
        {
            SumIndexFields = "Earning Code Amount", "Benefit Amount";
        }
        key(Key3; "Pay Period Start", "Pay Period End")
        {
            SumIndexFields = "Earning Code Amount", "Benefit Amount";
        }
    }

    var
        PayPeriods: Record "Pay Periods";
        Employee: Record Employee;
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
}