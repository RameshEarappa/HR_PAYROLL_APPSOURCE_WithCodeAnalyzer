page 70163 "Employee Insurance RC List"
{
    CardPageID = "Employee Insurance Card";
    Editable = false;
    PageType = List;
    SourceTable = "Employee Insurance";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Id"; Rec."Employee Id")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Person Insured"; Rec."Person Insured")
                {
                    ApplicationArea = All;
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field("Insurance Service Provider"; Rec."Insurance Service Provider")
                {
                    ApplicationArea = All;
                }
                field("Insurance Card No"; Rec."Insurance Card No")
                {
                    ApplicationArea = All;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        if Rec."Employee Id" <> '' then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee Id", Rec."Employee Id");
            Rec.FILTERGROUP(0);
        end;
    end;

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