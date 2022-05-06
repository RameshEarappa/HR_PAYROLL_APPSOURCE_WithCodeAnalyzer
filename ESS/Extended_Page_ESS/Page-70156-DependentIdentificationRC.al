page 70156 "Dependent Identification RC"
{
    CardPageID = "Dependent Identification Card1";
    PageType = List;
    SourceTable = "Identification Master";
    SourceTableView = SORTING("Employee No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST(Dependent));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Dependent No"; Rec."Dependent No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Identification Type"; Rec."Identification Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Identification No."; Rec."Identification No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Issuing Authority"; Rec."Issuing Authority")
                {
                    ApplicationArea = All;
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
                field("Issue Date (Hijiri)"; Rec."Issue Date (Hijiri)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Expiry Date (Hijiri)"; Rec."Expiry Date (Hijiri)")
                {
                    ApplicationArea = All;
                    Visible = false;
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