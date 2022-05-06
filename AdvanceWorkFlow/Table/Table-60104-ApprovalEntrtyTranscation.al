table 60104 "Approval Entrty Transcation"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Trans ID"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Advance Payrolll Type"; Option)
        {
            Editable = false;
            OptionCaption = ',Loan,Leaves,Benifit,Over Time,Employee Contracts,Asset Return,Duty Resumption,Pre Approval Overtime Request,Overtime Benefit Claim,Cancel Leave Requests';
            OptionMembers = ,Loan,Leaves,Benifit,"Asset Issue","Employee Contracts","Asset Return","Duty Resumption","Pre Approval Overtime Request","Overtime Benefit Claim","Cancel Leave Requests";
            DataClassification = CustomerContent;
        }
        field(3; "Employee ID - Sender"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(4; "Reporting ID - Approver"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(5; "Delegate ID"; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "Sequence No."; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7; "Document RecordsID"; RecordId)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Document RecordsID", "Advance Payrolll Type", "Employee ID - Sender")
        {
            Clustered = true;
        }
    }
}

