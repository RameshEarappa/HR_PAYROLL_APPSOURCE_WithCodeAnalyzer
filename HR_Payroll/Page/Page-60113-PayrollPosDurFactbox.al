page 60113 "Payroll Pos. Dur. Factbox"
{
    Caption = 'Position Duration Factbox';
    PageType = CardPart;
    SourceTable = "Payroll Position Duration";

    layout
    {
        area(content)
        {
            field(Activation; Rec.Activation)
            {
                ApplicationArea = All;
            }
            field(Retirement; Rec.Retirement)
            {
                ApplicationArea = All;
            }
        }
    }
}