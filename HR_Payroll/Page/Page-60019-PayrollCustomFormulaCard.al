page 60019 "Payroll Custom Formula Card"
{
    PageType = Card;
    SourceTable = "Payroll Formula";
    SourceTableView = WHERE("Formula Key Type" = CONST(Custom));
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Formula Key"; Rec."Formula Key")
                {
                    ApplicationArea = All;
                }
                field("Formula description"; Rec."Formula description")
                {
                    ApplicationArea = All;
                }
                field("Formula Key Type"; Rec."Formula Key Type")
                {
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Formula Key" <> '' then
            if Rec."Formula Key Type" = Rec."Formula Key Type"::Parameter then
                ERROR('You Cannot Create Parameter Formula Key Type Manually');
    end;
}