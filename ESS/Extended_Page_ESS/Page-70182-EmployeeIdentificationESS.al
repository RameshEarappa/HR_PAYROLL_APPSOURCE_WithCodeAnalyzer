page 70182 "Employee Identification ESS"
{
    PageType = ListPart;
    SourceTable = "Identification Master";
    SourceTableView = SORTING("Employee No.") ORDER(Ascending) WHERE("Document Type" = CONST(Employee), "Active Document" = filter(true));
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
}