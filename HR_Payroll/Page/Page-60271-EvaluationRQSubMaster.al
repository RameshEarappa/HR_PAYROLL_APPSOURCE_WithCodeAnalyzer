page 60271 "Evaluation RQ Sub Master"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Evaluation RQ Sub Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Serial No."; Rec."Serial No.")
                {
                    Caption = 'Line No.';
                    Style = Unfavorable;
                    StyleExpr = AlertBooleanG;
                    ApplicationArea = All;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = AlertBooleanG;
                    ApplicationArea = All;
                }
                field("Performance Appraisal Type"; Rec."Performance Appraisal Type")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = AlertBooleanG;
                    ApplicationArea = All;
                }
                field("Rating Factor"; Rec."Rating Factor")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = AlertBooleanG;
                    ApplicationArea = All;
                }
                field("Rating Factor Description"; Rec."Rating Factor Description")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = AlertBooleanG;
                    ApplicationArea = All;
                }
                field("Maximum Rating Factor"; Rec."Setup Sum")
                {
                    Style = Strong;
                    StyleExpr = True;
                    Visible = true;
                    ApplicationArea = All;
                }
                field(Weightage; Rec.Weightage)
                {
                    Style = Unfavorable;
                    StyleExpr = AlertBooleanG;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                        Rec.CALCFIELDS("Current Type Sum");
                        Rec.CALCFIELDS("Setup Sum");

                        if Rec."Current Type Sum" > Rec."Setup Sum" then
                            ERROR(Text0001, Rec."Setup Sum");
                        CurrPage.UPDATE(true);
                    end;
                }
                field("Current Type Sum"; Rec."Current Type Sum")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Upload Evaluation Questionaire")
            {
                Image = Questionaire;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    EvaluationRatingQuestMasterRecG.RESET;
                    EvaluationRatingQuestMasterRecG.MODIFYALL("Inserted Bool", false);
                    COMMIT;
                    EvaluationRatingQuestMasterRecG.RESET;
                    PAGE.RUNMODAL(60265, EvaluationRatingQuestMasterRecG);
                    EvaluationRatingQuestMasterRecG.RESET;
                    EvaluationRatingQuestMasterRecG.SETCURRENTKEY("Evaluation Factor Type");
                    EvaluationRatingQuestMasterRecG.SETRANGE("Inserted Bool", true);
                    if EvaluationRatingQuestMasterRecG.FINDSET then
                        repeat
                            EvaluationRQSubMasterRecG.INIT;
                            EvaluationRQSubMasterRecG."Serial No." := EvaluationRatingQuestMasterRecG."Serial No.";
                            EvaluationRQSubMasterRecG."Rating Factor" := EvaluationRatingQuestMasterRecG."Rating Factor";
                            EvaluationRQSubMasterRecG."Performance Appraisal Type" := EvaluationRatingQuestMasterRecG."Evaluation Factor Type";
                            EvaluationRQSubMasterRecG."Earning Code Group" := EvaluationMasterSingleCUG.GetEarningCodeGroup;
                            EvaluationRQSubMasterRecG."Rating Factor Description" := EvaluationRatingQuestMasterRecG."Rating Factor Description";

                            if not EvaluationRQSubMasterRecG.INSERT then
                                EvaluationRQSubMasterRecG.MODIFY;

                        until EvaluationRatingQuestMasterRecG.NEXT = 0;
                    EvaluationRatingQuestMasterRecG.RESET;
                    EvaluationRatingQuestMasterRecG.MODIFYALL("Inserted Bool", false);
                    COMMIT;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETCURRENTKEY("Performance Appraisal Type");
        AlertBooleanG := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        EvaluationRQSubMasterRec1G.RESET;
        EvaluationRQSubMasterRec1G.SETCURRENTKEY("Performance Appraisal Type");
        EvaluationRQSubMasterRec1G.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if EvaluationRQSubMasterRec1G.FINDSET then begin
            repeat
                EvaluationRQSubMasterRec1G.CALCFIELDS("Setup Sum", "Current Type Sum");
                if EvaluationRQSubMasterRec1G.Weightage <= 0 then
                    ERROR(Text0004, EvaluationRQSubMasterRec1G."Performance Appraisal Type", EvaluationRQSubMasterRec1G."Performance Appraisal Type");

                if EvaluationRQSubMasterRec1G."Current Type Sum" <> EvaluationRQSubMasterRec1G."Setup Sum" then begin
                    ERROR(Text0002, EvaluationRQSubMasterRec1G."Performance Appraisal Type", EvaluationRQSubMasterRec1G."Setup Sum");
                end
            until EvaluationRQSubMasterRec1G.NEXT = 0;
        end;
    end;

    var
        EvaluationRQSubMasterRecG: Record "Evaluation RQ Sub Master";
        EvaluationRatingQuestMasterRecG: Record "Evaluation Rating/Quest Master";
        EvaluationMasterSingleCUG: Codeunit "Evaluation Master Single CU";
        Text0001: Label 'Weightage is not greater than %1 , As per Setup define.';
        EvaluationSetupRecG: Record "Evaluation Setup";
        EvaluationRQSubMasterRec1G: Record "Evaluation RQ Sub Master";
        Text0002: Label 'Weightage for %1 must be equal to Maximum Rating factor "  %2 ".';
        Text0003: Label 'There is no Description.';
        Text0004: Label 'Weightage for %1 cannot be Zero , Delete %2  if no weightage is Required.';
        AlertBooleanG: Boolean;

    procedure ShowErrorMessage()
    var
        e: Text;
    begin
        e := Rec."Rating Factor Description";
        if e = '' then
            e := Text0003;
        MESSAGE(e);
    end;
}