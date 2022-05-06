page 60268 "Evaluation Setup"
{
    DelayedInsert = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Evaluation Setup";
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater("Weightage Factor")
            {
                field("Grade Category"; Rec."Grade Category")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    Caption = 'Performance Appraisal Type';
                    ApplicationArea = All;
                }
                field("Performance Appraisal Type"; Rec."Performance Appraisal Type")
                {
                    Caption = 'Appraisal Weightage';
                    ApplicationArea = All;
                }
                field(Weightage; Rec.Weightage)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;

                        Rec.CALCFIELDS("Group Total Weightage");
                        if Rec."Group Total Weightage" > 100 then
                            ERROR(Test0001);
                    end;
                }
                field("Group Total Weightage"; Rec."Group Total Weightage")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETCURRENTKEY("Group Total Weightage");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Grade Category" <> '' then begin
            Rec.CALCFIELDS("Group Total Weightage");
            Rec.TESTFIELD("Group Total Weightage", 100);
        end;
    end;

    var
        Test0001: Label 'Maximum 100 Allow only.';
}