page 60105 "Payroll Job Screening Subpage"
{
    AutoSplitKey = true;
    Caption = 'Screening';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Payroll Job Screening Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Screening Type"; Rec."Screening Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}