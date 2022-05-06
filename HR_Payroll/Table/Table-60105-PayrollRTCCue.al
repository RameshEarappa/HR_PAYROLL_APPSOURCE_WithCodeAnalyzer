table 60105 "Payroll RTC Cue"
{
    Caption = 'Employee Details';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Requests to Approve"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Approver ID" = FIELD(User_ID_Srch),
                                                        Status = FILTER(Created)));
            FieldClass = FlowField;
        }
        field(3; "Driving Licence Request"; Integer)
        {
            FieldClass = FlowField;
        }
        field(4; "Car Registration Request"; Integer)
        {
            FieldClass = FlowField;
        }
        field(5; "Company directory"; Integer)
        {
            CalcFormula = Count(Employee WHERE("First Name" = FILTER(<> '')));
            FieldClass = FlowField;
        }
        field(6; "Visa Request"; Integer)
        {
            FieldClass = FlowField;
        }
        field(7; "IQAMA Request"; Integer)
        {
            FieldClass = FlowField;
        }
        field(8; "OT Requset"; Integer)
        {
            FieldClass = FlowField;
        }
        field(9; "Benefit Climb"; Integer)
        {
            FieldClass = FlowField;
        }
        field(10; "Education Claim"; Integer)
        {
            FieldClass = FlowField;
        }
        field(11; "Leave Request"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Dependent Request"; Integer)
        {
            CalcFormula = Count("Employee Dependents New" WHERE(User_ID = FIELD(User_ID_Srch)));
            FieldClass = FlowField;
        }
        field(50; User_ID_Srch; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51; "Airport Access Authoriz Req."; Integer)
        {
            FieldClass = FlowField;
        }
        field(52; "Short Leave Request"; Integer)
        {
            FieldClass = FlowField;
        }
        field(53; "Per Diem Claim"; Integer)
        {
            FieldClass = FlowField;
        }
        field(54; "Expense Request"; Integer)
        {
            FieldClass = FlowField;
        }
        field(55; "Medical Expense Claim"; Integer)
        {
            FieldClass = FlowField;
        }
        field(56; "Ticketing Request"; Integer)
        {
            CalcFormula = Count("Loan Adjustment Header" WHERE("Employee Name" = FIELD(User_ID_Srch)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}

