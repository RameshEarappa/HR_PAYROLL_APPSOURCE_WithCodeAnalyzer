page 70101 "Employee Accural Formula"
{
    PageType = ConfirmationDialog;
    UsageCategory = Documents;
    ApplicationArea = All;
    SourceTable = "Employee Accural Amount";
    layout
    {
        area(Content)
        {
            field(ReplaceCharaG; ReplaceCharaG)
            {
                Caption = 'Enter Replace Code';
                ApplicationArea = All;
            }
            field(UserFormulaG; UserFormulaG)
            {
                Caption = 'Sum of Earning Code  X ';
                ApplicationArea = All;
                trigger
                OnValidate()
                var
                    Pos: Integer;
                begin
                    Clear(Pos);
                    Pos := STRPOS(UserFormulaG, ReplaceCharaG);
                    if Pos <= 0 then
                        Error('%1  your code is not found in Formula Expression.', ReplaceCharaG);
                end;
            }
        }
    }

    trigger
    OnQueryClosePage(CloseAction: Action): Boolean
    var
        EmployeeAccuralAmountRecL: Record "Employee Accural Amount";
        NewFormulaTxtL: Text[250];
    begin
        if CloseAction = Action::Yes then begin

            if UserFormulaG <> '' then begin
                EmployeeAccuralAmountRecL.Reset();
                if EmployeeAccuralAmountRecL.FindSet() then begin
                    repeat
                        Clear(NewFormulaTxtL);
                        NewFormulaTxtL := ReplaceString(UserFormulaG, ReplaceCharaG, Format(EmployeeAccuralAmountRecL."Sum of Earning Code"));
                        EmployeeAccuralAmountRecL."Calc. Formula" := NewFormulaTxtL;
                        EmployeeAccuralAmountRecL.Modify();
                    until EmployeeAccuralAmountRecL.Next() = 0;
                end;
            end;

        end;
        if CloseAction = Action::No then
            Clear(UserFormulaG);
    end;

    trigger
    OnOpenPage()
    begin
        Clear(UserFormulaG);
        Clear(ReplaceCharaG);
    end;

    var
        UserFormulaG: Code[250];
        ReplaceCharaG: Code[2];
        LableG: Text[90];
        ExpressionFormulaCU: Codeunit "Expression Formula";

    procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]): Text[250]
    var
        NewReplaceWith: Text[250];
    begin
        NewReplaceWith := DelChr(ReplaceWith, ',');
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + NewReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        exit(String);
    end;
}