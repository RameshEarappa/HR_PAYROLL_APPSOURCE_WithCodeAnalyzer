page 60008 "Employee Identification List"
{
    CardPageID = "Employee Identification Card";
    UsageCategory = Lists;
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Identification Master";
    SourceTableView = SORTING("Employee No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST(Employee));
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

    trigger OnAfterGetCurrRecord()
    begin
        if RecEmployee.GET(Rec."Employee No.") then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee No.", RecEmployee."No.");
            Rec.FILTERGROUP(0);
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if RecEmployee.GET(Rec."Employee No.") then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee No.", RecEmployee."No.");
            Rec.FILTERGROUP(0);
        end;
    end;

    trigger OnOpenPage()
    begin
        if RecEmployee.GET(Rec."Employee No.") then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee No.", RecEmployee."No.");
            Rec.FILTERGROUP(0);
        end;
    end;

    var
        RecEmployee: Record Employee;
}