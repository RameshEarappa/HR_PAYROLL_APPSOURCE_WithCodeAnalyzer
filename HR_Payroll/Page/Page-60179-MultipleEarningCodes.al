page 60179 "Multiple Earning Codes"
{
    PageType = List;
    SourceTable = "Multiple Earning Codes";
    SourceTableView = SORTING("Loan Code", "Earning Code")
                      ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Code"; Rec."Loan Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}