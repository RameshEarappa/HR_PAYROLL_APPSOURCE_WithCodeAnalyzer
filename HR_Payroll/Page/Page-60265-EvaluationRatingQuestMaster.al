page 60265 "Evaluation Rating/Quest Master"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Evaluation Rating/Quest Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Serial No."; Rec."Serial No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Evaluation Factor Type"; Rec."Evaluation Factor Type")
                {
                    Editable = CheckEditiableBooleanG;
                    ApplicationArea = All;
                }
                field("Rating Factor"; Rec."Rating Factor")
                {
                    Editable = CheckEditiableBooleanG;
                    ApplicationArea = All;
                }
                field("Rating Factor Description"; Rec."Rating Factor Description")
                {
                    ApplicationArea = All;
                }
                field("Inserted Bool"; Rec."Inserted Bool")
                {
                    Visible = IfOpenWithEarningCodeBoolG;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Select All Question")
            {
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Select all Questions';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.MODIFYALL("Inserted Bool", true);
                    CurrPage.UPDATE;
                end;
            }
            action("De-Select All Question")
            {
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Un Check All question';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.MODIFYALL("Inserted Bool", false);
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETCURRENTKEY("Evaluation Factor Type");

        if EvaluationMasterSingleCUG.GetEarningCodeGroup <> '' then begin
            CheckEditiableBooleanG := false;
            IfOpenWithEarningCodeBoolG := true;
        end
        else begin
            CheckEditiableBooleanG := true;
            IfOpenWithEarningCodeBoolG := false;
        end;
    end;

    var
        CheckEditiableBooleanG: Boolean;
        EvaluationMasterSingleCUG: Codeunit "Evaluation Master Single CU";
        IfOpenWithEarningCodeBoolG: Boolean;
}