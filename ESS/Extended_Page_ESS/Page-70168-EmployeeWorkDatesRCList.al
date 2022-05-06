page 70168 "Employee Work Dates RC List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = EmployeeWorkDate_GCC;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Trans Date"; Rec."Trans Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Day Name"; Rec."Day Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Month Name"; Rec."Month Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Week No."; Rec."Week No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Alternate Date"; Rec."Alternate Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Stop Payroll"; Rec."Stop Payroll")
                {
                    ApplicationArea = All;
                }
                field("Calander id"; Rec."Calander id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Employee Earning Group"; Rec."Employee Earning Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("First Half Leave Type"; Rec."First Half Leave Type")
                {
                    ApplicationArea = All;
                }
                field("Second Half Leave Type"; Rec."Second Half Leave Type")
                {
                    ApplicationArea = All;
                }
                field("Payroll Statement id"; Rec."Payroll Statement id")
                {
                    ApplicationArea = All;
                }
                field("Temporary Payroll Hold"; Rec."Temporary Payroll Hold")
                {
                    ApplicationArea = All;
                }
                field("Original Calander id"; Rec."Original Calander id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    trigger OnInit()
    begin
        PageUserFilter();
    end;

    procedure PageUserFilter()
    var
        Rcodeunit: Codeunit "ESS RC Page";
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Employee Code", Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;
}