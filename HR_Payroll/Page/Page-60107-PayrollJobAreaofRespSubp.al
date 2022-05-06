page 60107 "Payroll Job Area of Resp. Subp"
{
    AutoSplitKey = true;
    Caption = 'Area of Responsibility';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Payroll Job Area of Resp. Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Area of Responsibility"; Rec."Area of Responsibility")
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