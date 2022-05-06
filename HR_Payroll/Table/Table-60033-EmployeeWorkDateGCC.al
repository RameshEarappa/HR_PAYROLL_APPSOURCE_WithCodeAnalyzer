table 60033 EmployeeWorkDate_GCC
{
    DataClassification = CustomerContent;
    fields
    {
        field(10; "Employee Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Trans Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Day Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Month Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(40; "Week No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Alternate Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Stop Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(70; "Calander id"; Code[20])
        {
            TableRelation = "Work Calendar Header";
            DataClassification = CustomerContent;
        }
        field(80; "Calculation Type"; Option)
        {
            OptionCaption = 'Working Day,Weekly Off,Public Holiday';
            OptionMembers = "Working Day","Weekly Off","Public Holiday";
            DataClassification = CustomerContent;
        }
        field(90; "Employee Earning Group"; Code[20])
        {
            TableRelation = "Earning Code Groups";
            DataClassification = CustomerContent;
        }
        field(95; "First Half Leave Type"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(100; "Second Half Leave Type"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(110; "Payroll Statement id"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(120; "Temporary Payroll Hold"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(130; "Original Calander id"; Code[20])
        {
            TableRelation = "Work Calendar Header";
            DataClassification = CustomerContent;
        }
        field(131; Remarks; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Trans Date")
        {
            Clustered = true;
        }
        key(Key2; "Employee Code", "First Half Leave Type", "Trans Date")
        {
        }
        key(Key3; "Employee Code", "Second Half Leave Type", "Trans Date")
        {
        }
        key(Key4; "Employee Code", "First Half Leave Type", "Calculation Type", "Trans Date")
        {
        }
        key(Key5; "Employee Code", "Second Half Leave Type", "Calculation Type", "Trans Date")
        {
        }
    }
}