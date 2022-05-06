page 60129 "Accrual Component Card"
{
    Caption = 'Accrual Component List';
    PageType = Card;
    SourceTable = "Accrual Components";

    layout
    {
        area(content)
        {
            field("Accrual ID"; Rec."Accrual ID")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    Rec.TESTFIELD("Accrual ID");
                    if (xRec.Description <> '') and (xRec.Description <> Rec.Description) then
                        ERROR('You Cannot modify Accrual description');
                end;
            }
            group("Accrual Details")
            {
                field("Accrual Interval Basis Date"; Rec."Accrual Interval Basis Date")
                {
                    ApplicationArea = All;
                }
                field("Months Ahead Calculate"; Rec."Months Ahead Calculate")
                {
                    ApplicationArea = All;
                }
                field("Consumption Split by Month"; Rec."Consumption Split by Month")
                {
                    ApplicationArea = All;
                }
                field("Accrual Basis Date"; Rec."Accrual Basis Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Interval Month Start"; Rec."Interval Month Start")
                {
                    ApplicationArea = All;
                }
                field("Accrual Units Per Month"; Rec."Accrual Units Per Month")
                {
                    ApplicationArea = All;
                }
                field("Opening Additional Accural"; Rec."Opening Additional Accural")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Roll Over Period Monthly"; Rec."Roll Over Period")
                {
                    ApplicationArea = All;
                }
                field("Max Carry Forward"; Rec."Max Carry Forward")
                {
                    ApplicationArea = All;
                }
                field("CarryForward Lapse After Month"; Rec."CarryForward Lapse After Month")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Repeat After Months"; Rec."Repeat After Months")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Avail Allow Till"; Rec."Avail Allow Till")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Allow Negative"; Rec."Allow Negative")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        MandatoryFields;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        MandatoryFields;
    end;

    var
        AccrualDateVisiible: Boolean;

    local procedure MandatoryFields()
    begin
        if Rec."Accrual ID" <> '' then begin
            Rec.TESTFIELD("Accrual Interval Basis Date");
        end;
    end;
}