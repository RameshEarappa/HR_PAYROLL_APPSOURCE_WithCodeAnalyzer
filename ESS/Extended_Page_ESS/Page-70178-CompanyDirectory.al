page 70178 "Employee Directory DME"
{
    Caption = 'Company Directory';
    PageType = List;
    SourceTable = Employee;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(ShowData)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec.FullName)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field(Phone; GetEmployeePhone(Rec."No."))
                {
                    ApplicationArea = All;
                }
                field(Email; GetEmployeeEmail(Rec."No."))
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure GetEmployeePhone(EmpCode_P: Code[20]): Text
    var
        EmployeeContactLineL: Record "Employee Contacts Line";
    begin
        EmployeeContactLineL.Reset();
        EmployeeContactLineL.SetRange("Table Type Option", EmployeeContactLineL."Table Type Option"::"Employee Contacts Line");
        EmployeeContactLineL.SetRange("Employee ID", EmpCode_P);
        EmployeeContactLineL.SetRange(Primary, true);
        if EmployeeContactLineL.FindFirst() then begin
            if EmployeeContactLineL.Type = EmployeeContactLineL.Type::Phone then
                exit(EmployeeContactLineL."Contact Number & Address");
        end;
    end;

    procedure GetEmployeeEmail(EmpCode_P: Code[20]): Text
    var
        EmployeeContactLineL: Record "Employee Contacts Line";
    begin
        EmployeeContactLineL.Reset();
        EmployeeContactLineL.SetRange("Table Type Option", EmployeeContactLineL."Table Type Option"::"Employee Contacts Line");
        EmployeeContactLineL.SetRange("Employee ID", EmpCode_P);
        EmployeeContactLineL.SetRange(Primary, true);
        if EmployeeContactLineL.FindFirst() then begin
            if EmployeeContactLineL.Type = EmployeeContactLineL.Type::Email then
                exit(EmployeeContactLineL."Contact Number & Address");
        end;
    end;
}