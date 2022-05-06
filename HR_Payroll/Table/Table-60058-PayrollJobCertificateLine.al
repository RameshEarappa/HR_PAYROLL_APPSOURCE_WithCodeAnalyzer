table 60058 "Payroll Job Certificate Line"
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
        field(3; "Certficate Type"; Code[20])
        {
            TableRelation = "Payroll Job Certificate";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if PayrollJobCertificate.GET("Certficate Type") then
                    Description := PayrollJobCertificate.Description
                else
                    Description := '';
            end;
        }
        field(4; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; Importance; Option)
        {
            OptionCaption = 'None,1-Least,2,3,4,5,6-Most';
            OptionMembers = "None","1-Least","2","3","4","5","6-Most";
            DataClassification = CustomerContent;
        }
        field(6; "Emp ID"; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                EmployeeRecG.RESET;
                if EmployeeRecG.GET("Emp ID") then
                    "Emp Full Name" := EmployeeRecG.FullName;
            end;
        }
        field(7; "Emp Full Name"; Text[150])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Job ID", "Emp ID", "Line  No.")
        {
            Clustered = true;
        }
    }

    var
        PayrollJobCertificate: Record "Payroll Job Certificate";
        EmployeeRecG: Record Employee;
}