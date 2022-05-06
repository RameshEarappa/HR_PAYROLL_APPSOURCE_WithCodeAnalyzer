page 60186 "My Profile FactBox"
{
    Caption = 'Employee Details';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            field("First Name"; Rec."First Name")
            {
                ApplicationArea = All;
            }
            field("Middle Name"; Rec."Middle Name")
            {
                ApplicationArea = All;
            }
            field("Last Name"; Rec."Last Name")
            {
                ApplicationArea = All;
            }
            field(Position; Rec.Position)
            {
                ApplicationArea = All;
            }
            field(Department; Rec.Department)
            {
                ApplicationArea = All;
            }
            field("Joining Date"; Rec."Joining Date")
            {
                ApplicationArea = All;
            }
            field("Service Year"; ServiceYearTxt)
            {
                ApplicationArea = All;
            }
            field("Grade Category"; Rec."Grade Category")
            {
                ApplicationArea = All;
            }
            field("Earning Code Group"; Rec."Earning Code Group")
            {
                ApplicationArea = All;
            }
            field("Retirement Age"; RetirementAge)
            {
                ApplicationArea = All;
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        CLEAR(ServiceYear);
        CLEAR(ServiceYearTxt);
        if Rec."Joining Date" <> 0D then begin
            ServiceYear := -(Rec."Joining Date" - TODAY);
            if ServiceYear <> 0 then
                ServiceYearTxt := FORMAT(ROUND((ServiceYear / 365.27), 0.1));
        end;

        PayrollPosition.RESET;
        PayrollPosition.SETRANGE(Worker, Rec.Position);
        if PayrollPosition.FINDFIRST then
            Rec.Position := PayrollPosition.Description;
    end;

    var
        ServiceYear: Integer;
        ServiceYearTxt: Text;
        RetAge: Text;
        PayrollPosition: Record "Payroll Position";
        Position: Text;
        RetirementAge: Text;
}