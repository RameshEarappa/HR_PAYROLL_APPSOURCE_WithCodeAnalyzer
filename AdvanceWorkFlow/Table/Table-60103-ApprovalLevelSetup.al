table 60103 "Approval Level Setup"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Advance Payrolll Type"; Option)
        {
            OptionCaption = ',Loan,Leaves,Benifit,Asset Issue,Employee Contracts,Asset Return,Duty Resumption,Pre Approval Overtime Request,Overtime Benefit Claim,Cancel Leave Requests';
            OptionMembers = ,Loan,Leaves,Benifit,"Asset Issue","Employee Contracts","Asset Return","Duty Resumption","Pre Approval Overtime Request","Overtime Benefit Claim","Cancel Leave Requests";
            DataClassification = CustomerContent;
        }
        field(2; Level; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Finance User ID"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(4; "Direct Approve By Finance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Finance User ID 2"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Advance Payrolll Type")
        {
            Clustered = true;
        }
    }
}