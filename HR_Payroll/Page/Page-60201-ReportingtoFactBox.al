page 60201 "Reporting to FactBox"
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
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
            }
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
            field("Joining Date"; Rec."Joining Date")
            {
                ApplicationArea = All;
            }
            field("Service Year"; ServiceYearTxt)
            {
                ApplicationArea = All;
            }
            field("Earning Code Group"; Rec."Earning Code Group")
            {
                ApplicationArea = All;
            }
            field("Grade Category"; Rec."Grade Category")
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
    end;

    var
        ServiceYear: Integer;
        ServiceYearTxt: Text;
}