page 60273 "Factor Rating Scale"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Evaluation Rating Scale Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Evaluation Rate"; Rec.Code)
                {
                    Style = Strong;
                    StyleExpr = True;
                    ApplicationArea = All;
                }
                field(Minumum; Rec.Minumum)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field(Maximum; Rec.Maximum)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETCURRENTKEY(Minumum);
    end;
}