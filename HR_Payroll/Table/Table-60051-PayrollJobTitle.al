table 60051 "Payroll Job Title"
{
    DrillDownPageID = "Payroll Job Title";
    LookupPageID = "Payroll Job Title";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Job Title"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Job Title")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        PayrollPositionRecL: Record "Payroll Position";
    begin
        PayrollPositionRecL.Reset();
        PayrollPositionRecL.SetRange(Title, "Job Title");
        if PayrollPositionRecL.FindFirst() then
            Error('Job title already attached to a position, cannot be deleted.');
    end;
}