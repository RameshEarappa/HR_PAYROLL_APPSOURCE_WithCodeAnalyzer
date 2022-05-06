table 60088 "Payroll Pos. Worker Assn. Arch"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Position ID"; Code[20])
        {
            TableRelation = "Payroll Position";
            DataClassification = CustomerContent;
        }
        field(2; Worker; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(3; "Assignment Start"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if ("Assignment Start" > "Assignment End") and ("Assignment End" <> 0D) then
                    ERROR('End date cannnot be less than Start date');
            end;
        }
        field(4; "Assignment End"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Assignment Start" = 0D then
                    ERROR('Select Start date');

                VALIDATE("Assignment Start");
            end;
        }
        field(5; "Reason Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Is Primary Position"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Position Assigned"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Effective Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Effective End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Position ID", Worker, "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        if Rec."Position Assigned" then
            ERROR('You cannot delet the records as it is assigned');
    end;

    trigger OnInsert()
    begin
        TESTFIELD("Assignment Start");
        PayrollWorkerAssign.RESET;
        PayrollWorkerAssign.SETRANGE("Position ID", "Position ID");
        PayrollWorkerAssign.SETRANGE(PayrollWorkerAssign."Assignment End", 0D);
        if PayrollWorkerAssign.FINDFIRST then
            ERROR('The duration that you specified overlaps with another record of position. Adjust the dates which you entered');

        PayrollWorkerAssign.RESET;
        PayrollWorkerAssign.SETRANGE("Position ID", "Position ID");
        PayrollWorkerAssign.SETFILTER(PayrollWorkerAssign."Assignment Start", '<=%1', "Assignment Start");
        PayrollWorkerAssign.SETFILTER(PayrollWorkerAssign."Assignment End", '>=%1', "Assignment Start");
        if PayrollWorkerAssign.FINDFIRST then
            ERROR('The duration that you specified overlaps with another record of position. Adjust the dates which you entered');

        if PayrollPosition.GET("Position ID") then
            PayrollPosition."Open Position" := false;
    end;

    var
        PayrollWorkerAssign: Record "Payroll Job Pos. Worker Assign";
        EmpError: Label 'Please select an employee first.';
        PayrollPosition: Record "Payroll Position";
}