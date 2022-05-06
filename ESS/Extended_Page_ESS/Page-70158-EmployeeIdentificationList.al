page 70158 "Empl. Identification RC List"
{
    CardPageID = "Employee Identification Card";
    PageType = List;
    SourceTable = "Identification Master";

    SourceTableView = SORTING("Employee No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST(Employee));

    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Identification Type"; Rec."Identification Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Identification No."; Rec."Identification No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Issuing Country"; Rec."Issuing Country")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Expiry Date"; Rec."Expiry Date")
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
        Rec.SetRange("Employee No.", Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;
}