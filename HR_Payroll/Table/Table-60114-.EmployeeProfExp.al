table 60114 "Employee Prof. Exp."
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Emp No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                EmployeeRecG.RESET;
                if EmployeeRecG.GET("Emp No.") then
                    "Emp FullName" := EmployeeRecG.FullName;
            end;
        }
        field(2; "Line No."; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; "Emp FullName"; Text[150])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; Employer; Code[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; Position; Code[110])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Internet Address"; Code[120])
        {
            DataClassification = CustomerContent;
        }
        field(7; Telephone; Code[15])
        {
            DataClassification = CustomerContent;
        }
        field(8; Location; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Emp No.", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        EmployeeRecG: Record Employee;
}