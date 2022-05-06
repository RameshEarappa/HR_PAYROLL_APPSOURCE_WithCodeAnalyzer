page 60119 "Worker Position assign Factbox"
{
    Caption = 'Position assign Factbox';
    PageType = CardPart;
    SourceTable = "Payroll Job Pos. Worker Assign";
    layout
    {
        area(content)
        {
            field(Worker; Rec.Worker)
            {
                ApplicationArea = All;
            }
            field("Assignment Start"; Rec."Assignment Start")
            {
                ApplicationArea = All;
            }
            field("Assignment End"; Rec."Assignment End")
            {
                ApplicationArea = All;
            }
        }
    }
}