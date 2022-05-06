page 60073 "Academic Period List"
{
    CardPageID = "Academic Period";
    DelayedInsert = false;
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = "Academic Period LT";
    SourceTableView = SORTING("Academic Period", "Start Date", "End Date") ORDER(Ascending);
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
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