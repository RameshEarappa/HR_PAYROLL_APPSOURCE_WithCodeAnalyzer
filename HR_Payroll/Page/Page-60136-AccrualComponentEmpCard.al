page 60136 "Accrual Component Emp. Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Accrual Components Employee";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("Accrual ID"; Rec."Accrual ID")
            {
                ApplicationArea = All;
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
                field("Worker ID"; Rec."Worker ID")
                {
                    ApplicationArea = All;
                }
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
            part(Control13; "Interim Accruals Workers Subpg")
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Accrual ID" = FIELD("Accrual ID"),
                              "Worker ID" = FIELD("Worker ID");
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group(Asset)
            {
                Caption = 'Create Accrual';
                Image = Employee;
            }
            action("Create Accrual Interim Line")
            {
                Image = Database;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                RunObject = codeunit "Create Accrual Interim Line";
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