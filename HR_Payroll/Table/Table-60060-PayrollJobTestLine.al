table 60060 "Payroll Job Test Line"
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
        field(3; "Test Type"; Code[20])
        {
            TableRelation = "Payroll Job Test Type";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if PayrollJobTest.GET("Test Type") then
                    Description := PayrollJobTest.Description
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
        PayrollJobTest: Record "Payroll Job Test Type";
}