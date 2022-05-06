table 60080 "Payroll Religion"
{
    DrillDownPageID = "Payroll Religions";
    LookupPageID = "Payroll Religions";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Religion ID"; Code[20])
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
        key(Key1; "Religion ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        EmployeeRec_G.RESET;
        EmployeeRec_G.SETRANGE("Employee Religion", "Religion ID");
        if EmployeeRec_G.FINDFIRST then
            ERROR('Religion cannot be deleted while dependent employee exist. Cannot delete.');

        LeaveTypesRec.RESET;
        LeaveTypesRec.SETRANGE("Religion ID", "Religion ID");
        if LeaveTypesRec.FINDFIRST then
            ERROR('Religion cannot be deleted');
    end;

    var
        EmployeeRec_G: Record Employee;
        LeaveTypesRec: Record "HCM Leave Types";
}