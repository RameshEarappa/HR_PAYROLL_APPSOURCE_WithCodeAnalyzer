page 60103 "Payroll Job Tasks Subpage"
{
    AutoSplitKey = true;
    Caption = 'Tasks';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Payroll Job Task Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Task"; Rec."Job Task")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}