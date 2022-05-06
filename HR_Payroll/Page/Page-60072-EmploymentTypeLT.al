page 60072 "Employment Type LT"
{
    PageType = List;
    SourceTable = "Employment Type";
    Caption = 'Employment Type';
    SourceTableView = SORTING("Employment Type ID", "Employment Type")
                      ORDER(Ascending);
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employment Type ID"; Rec."Employment Type ID")
                {
                    ApplicationArea = All;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    Caption = 'Employment Type';
                    ApplicationArea = All;
                }
            }
        }
    }
}