table 60065 "Payroll Job Screening Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Job ID"; Code[20])
        {
            TableRelation = "Payroll Jobs";
            DataClassification = CustomerContent;
        }
        field(2; "Line  No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Screening Type"; Code[20])
        {
            TableRelation = "Payroll Job Screening";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if PayrollJobScreening.GET("Screening Type") then
                    Description := PayrollJobScreening.Description
                else
                    Description := '';
            end;
        }
        field(4; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Job ID", "Line  No.")
        {
            Clustered = true;
        }
    }

    var
        PayrollJobScreening: Record "Payroll Job Screening";
}