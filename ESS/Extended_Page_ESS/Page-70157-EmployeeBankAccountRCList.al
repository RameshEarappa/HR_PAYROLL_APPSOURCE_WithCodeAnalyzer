page 70157 "Employee Bank Account RC List"
{
    Caption = 'Employee Bank Account';
    CardPageID = "Employee Bank Account";
    Editable = false;
    PageType = List;
    SourceTable = "Employee Bank Account";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = ALL;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = ALL;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = ALL;
                }
                field("Branch Number"; Rec."Branch Number")
                {
                    ApplicationArea = ALL;
                }
                field("Bank Acccount Number"; Rec."Bank Acccount Number")
                {
                    ApplicationArea = ALL;
                }
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = ALL;
                }
                field("Account Holder"; Rec."Account Holder")
                {
                    ApplicationArea = ALL;
                }
                field("MOL Id"; Rec."MOL Id")
                {
                    ApplicationArea = ALL;
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
        Rec.SetRange("Employee Id", Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;
}