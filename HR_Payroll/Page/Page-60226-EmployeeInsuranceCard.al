page 60226 "Employee Insurance Card"
{
    DelayedInsert = true;
    DeleteAllowed = true;
    Editable = true;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Employee Insurance";
    SourceTableView = SORTING("Employee Id");

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee Id"; Rec."Employee Id")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetVisiblity;
                    end;
                }
                field("Person Insured"; Rec."Person Insured")
                {
                    ApplicationArea = All;
                    Enabled = PersonInsureBoolG;
                }
                field("Person Insured Name"; Rec."Person Insured Name")
                {
                    ApplicationArea = All;
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Insurance Service Provider"; Rec."Insurance Service Provider")
                {
                    ApplicationArea = All;
                }
                field("Insurance Category"; Rec."Insurance Category")
                {
                    ApplicationArea = All;
                }
                field("Insurance Card No"; Rec."Insurance Card No")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
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

    trigger OnOpenPage()
    begin
        SetVisiblity();
    end;

    trigger OnAfterGetRecord()
    begin
        SetVisiblity();
    end;

    var
        PersonInsureBoolG: Boolean;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
            if (Rec.Type <> Rec.Type::"''") and (Rec."Person Insured" <> '') then begin
                Rec.TESTFIELD("Insurance Card No");
                Rec.TESTFIELD("Insurance Service Provider");
                Rec.TESTFIELD("Expiry Date");
                Rec.TESTFIELD("Issue Date");
            end;
        end;
    end;

    procedure SetVisiblity()
    begin
        if Rec.Type = Rec.Type::Dependents then
            PersonInsureBoolG := true
        else
            PersonInsureBoolG := false;
    end;
}