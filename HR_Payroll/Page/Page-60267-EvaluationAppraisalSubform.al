page 60267 "Evaluation Appraisal Subform"
{
    Caption = 'Evaluation Appraisal';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = "Evaluation Appraisal Line";
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec.IndentationColumn;
                IndentationControls = "Performance Appraisal Type";
                ShowAsTree = true;

                field("Appraisal Type"; TypeTextG)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    ApplicationArea = All;
                }
                field("Performance Appraisal Type"; Rec."Performance Appraisal Type")
                {
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Performance ID"; Rec."Performance ID")
                {
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Rating Factors"; Rec."Rating Factors")
                {
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    ToolTip = 'ToolTips';
                    ApplicationArea = All;
                }
                field("Rating Factor Description"; Rec."Rating Factor Description")
                {
                    MultiLine = true;
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(IndentationColumn; Rec.IndentationColumn)
                {
                    Editable = IntendentEditBoolG;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Maximum Rating"; Rec."Maximum Rating")
                {
                    HideValue = Rec.IndentationColumn = 1;
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    ApplicationArea = All;
                }
                field("Evaluation Rating"; Rec."Evaluation Rating")
                {
                    Editable = true;
                    HideValue = Rec.IndentationColumn = 1;
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Each Type"; Rec."Each Type")
                {
                    Caption = 'Factor Total Rating';
                    HideValue = Rec.IndentationColumn = 2;
                    Style = Strong;
                    StyleExpr = IntendentStyleBoolG;
                    ApplicationArea = All;
                }
            }
            group(Control13)
            {
                field("Total Score"; SummaryTotalIntG)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUe;
                    ApplicationArea = All;
                }
                field("Performance Rating"; PerformanceRating)
                {
                    Enabled = false;
                    Style = Strong;
                    StyleExpr = TRUe;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.IndentationColumn = 1 then begin
            TypeTextG := Rec."Performance Appraisal Type";
            IntendentEditBoolG := false;
            IntendentStyleBoolG := true;
        end
        else begin
            TypeTextG := '';
            IntendentEditBoolG := true;
            IntendentStyleBoolG := false;
        end;
        ShowTotalSummary();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ShowTotalSummary();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ShowTotalSummary();
    end;

    trigger OnOpenPage()
    begin
        Rec.SETCURRENTKEY("Performance Appraisal Type");
        IntendentStyleBoolG := false;
        IntendentEditBoolG := false;
    end;

    var
        TypeTextG: Code[150];
        IntendentStyleBoolG: Boolean;
        IntendentEditBoolG: Boolean;
        EvaluationFactorTypeMasterRecG: Record "Evaluation Factor Type Master";
        e: Text;
        Text001: Label 'There is not Content.';
        SummaryTotalIntG: Decimal;
        EvaluationAppraisalHeaderRecG: Record "Evaluation Appraisal Header";
        PerformanceRating: Code[150];
        EvaluationRatingScaleMasterRecG: Record "Evaluation Rating Scale Master";

    procedure ShowErrorMessage()
    var
        e: Text;
    begin
        if e = '' then
            e := Text001;
        MESSAGE(e);
    end;

    local procedure ShowTotalSummary()
    begin
        CLEAR(SummaryTotalIntG);
        EvaluationAppraisalHeaderRecG.RESET;
        EvaluationAppraisalHeaderRecG.SETRANGE("Performance ID", Rec."Performance ID");
        EvaluationAppraisalHeaderRecG.SETRANGE("Employee Code", Rec."Employee Code");
        if EvaluationAppraisalHeaderRecG.FINDFIRST then begin
            EvaluationAppraisalHeaderRecG.CALCFIELDS("Total Sum");
            SummaryTotalIntG := EvaluationAppraisalHeaderRecG."Total Sum";
        end;

        CLEAR(PerformanceRating);
        EvaluationRatingScaleMasterRecG.RESET;
        if EvaluationRatingScaleMasterRecG.FINDSET then
            repeat
                if (SummaryTotalIntG >= EvaluationRatingScaleMasterRecG.Minumum) and (SummaryTotalIntG <= EvaluationRatingScaleMasterRecG.Maximum) then
                    PerformanceRating := EvaluationRatingScaleMasterRecG.Description
            until EvaluationRatingScaleMasterRecG.NEXT = 0;
    end;
}