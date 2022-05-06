table 60111 "DME Activities Cue"
{
    Caption = 'Employee Details';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[50])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Requests to Approve"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Approver ID" = FIELD(User_ID_Srch),
                                                        Status = FILTER(Created | Open)));
            FieldClass = FlowField;
        }
        field(3; "Leave Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Leave Request Header" where(User_ID = field(User_ID_Srch), "Personnel Number" = field("Employee ID")));
        }
        field(4; "Short Leave Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Short Leave Header" where(User_ID = field(User_ID_Srch), "Employee Id" = field("Employee ID")));
        }
        field(5; "Loan Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Loan Request" where(User_ID_Rec = field(User_ID_Srch), "Employee ID" = field("Employee ID")));
        }
        field(6; "Documents Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Document Request" where(User_ID_Rec = field(User_ID_Srch), "Employee ID" = field("Employee ID")));
        }
        field(50; User_ID_Srch; Code[250])
        {
            DataClassification = CustomerContent;
        }
        field(51; "Employee ID"; Code[20])
        {
            DataClassification = CustomerContent;
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