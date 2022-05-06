table 60063 "Payroll Job Task Line"
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
        field(3; "Job Task"; Code[20])
        {
            TableRelation = "Payroll Job Task";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if PayrollJobTask.GET("Job Task") then
                    Description := PayrollJobTask.Description
                else
                    Description := '';
            end;
        }
        field(4; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; Notes; Text[250])
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
        PayrollJobTask: Record "Payroll Job Task";
}