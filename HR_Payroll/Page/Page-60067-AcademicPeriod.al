page 60067 "Academic Period"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Academic Period LT";
    SourceTableView = SORTING("Academic Period", "Start Date", "End Date") ORDER(Ascending);
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Academic Period"; Rec."Academic Period")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
            if Rec."Academic Period" <> '' then begin
                Rec.TESTFIELD("Start Date");
                Rec.TESTFIELD("End Date");
            end;
        end;
    end;
}