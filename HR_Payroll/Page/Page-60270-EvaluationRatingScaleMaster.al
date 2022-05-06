page 60270 "Evaluation Rating Scale Master"
{
    AutoSplitKey = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Evaluation Rating Scale Master";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Minumum; Rec.Minumum)
                {
                    ApplicationArea = All;
                }
                field(Maximum; Rec.Maximum)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETCURRENTKEY(Minumum, Maximum);
    end;

    var
        Text0001: Label 'Rating Factor should not be overlap.';
        FirstRecords: Boolean;
        EvaluationRatingScaleMasterRecG: Record "Evaluation Rating Scale Master";
        EvaluationRatingScaleMasterRec2G: Record "Evaluation Rating Scale Master";
}