table 60067 "Payroll Job Area of Resp. Line"
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
        field(3; "Area of Responsibility"; Code[20])
        {
            TableRelation = "Payroll Job Area Of Resp.";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if PayrollJobAreaOfResp.GET("Area of Responsibility") then begin
                    Description := PayrollJobAreaOfResp.Description;
                    Notes := PayrollJobAreaOfResp.Notes;
                end
                else begin
                    Description := '';
                    Notes := '';
                end;
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
        PayrollJobAreaOfResp: Record "Payroll Job Area Of Resp.";
}