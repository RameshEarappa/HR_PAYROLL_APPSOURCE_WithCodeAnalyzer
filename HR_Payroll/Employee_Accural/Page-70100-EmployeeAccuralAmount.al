page 70100 "Employee Accural Amount"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Employee Accural Amount";
    Caption = 'Generate Employee Accrual';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;

                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;

                }
                field("Accued Units"; Rec."Accued Units")
                {
                    ApplicationArea = All;

                }
                field("Accrued Amount"; Rec."Accrued Amount")
                {
                    ApplicationArea = All;

                }
                field("Sum of Earning Code"; Rec."Sum of Earning Code")
                {
                    ApplicationArea = All;
                }
                field("Accured per day Amounts"; Rec."Accured per day Amounts")
                {
                    ApplicationArea = All;

                }
                field(Procced; Rec.Procced)
                {
                    ApplicationArea = All;
                }
                field("Calc. Formula"; Rec."Calc. Formula")
                {
                    ApplicationArea = All;
                }
                field("Updated By"; Rec."Updated By")
                {
                    ApplicationArea = All;
                }
                field("Updated Date/Time"; Rec."Updated Date/Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Generate Accural Amount")
            {
                ApplicationArea = All;
                Image = GeneralLedger;
                Promoted = true;
                trigger
                OnAction()
                var
                    EmployeeAccuralAmountRecL: Record "Employee Accural Amount";
                    EmployeeAccuralAmountRecL2: Record "Employee Accural Amount";
                    EmployeeAccuralAmountRecL3: Record "Employee Accural Amount";
                    EmployeeInterimAccuralsRecL: Record "Employee Interim Accurals";
                    NewFormulaTxtL: Text[250];
                    AdvancePayrollRecL: Record "Advance Payroll Setup";
                    FinalTextforExp: Text[250];
                    ExpressCU: Codeunit "Expression Formula";
                    AnsL: Text[250];
                begin
                    AdvancePayrollRecL.Reset();
                    AdvancePayrollRecL.Get();
                    AdvancePayrollRecL.TestField("Accrual Per day Formula");
                    EmployeeAccuralAmountRecL.Reset();
                    if EmployeeAccuralAmountRecL.FindSet() then begin
                        repeat
                            Clear(NewFormulaTxtL);
                            Clear(FinalTextforExp);

                            NewFormulaTxtL := DeleteDecimalComma(Format(EmployeeAccuralAmountRecL."Sum of Earning Code"));
                            FinalTextforExp := '((' + NewFormulaTxtL + '*' + AdvancePayrollRecL."Accrual Per day Formula";
                            EmployeeAccuralAmountRecL."Calc. Formula" := FinalTextforExp;
                            EmployeeAccuralAmountRecL.Modify();
                        until EmployeeAccuralAmountRecL.Next() = 0;
                    end;

                    EmployeeAccuralAmountRecL2.Reset();
                    if EmployeeAccuralAmountRecL2.FindSet() then begin
                        repeat

                            Clear(AnsL);
                            AnsL := (ExpressCU.Calc(EmployeeAccuralAmountRecL2."Calc. Formula", CurrentSeparator));
                            Evaluate(EmployeeAccuralAmountRecL2."Accured per day Amounts", AnsL);
                            EmployeeAccuralAmountRecL2.Modify();

                        until EmployeeAccuralAmountRecL2.Next() = 0;
                    end;

                    EmployeeAccuralAmountRecL3.Reset();
                    if EmployeeAccuralAmountRecL3.FindSet() then begin
                        repeat
                            EmployeeAccuralAmountRecL3."Accrued Amount" := EmployeeAccuralAmountRecL3."Accured per day Amounts" * EmployeeAccuralAmountRecL3."Accued Units";
                            EmployeeAccuralAmountRecL3.Modify();
                        until EmployeeAccuralAmountRecL3.Next() = 0;
                    end;
                    Commit();
                    EmployeeAccuralAmountRecL3.Reset();
                    if EmployeeAccuralAmountRecL3.FindSet() then begin
                        repeat
                            EmployeeAccuralAmountRecL3.TestField("Accrued Amount");
                            EmployeeInterimAccuralsRecL.Reset();
                            EmployeeInterimAccuralsRecL.SetRange("Worker ID", EmployeeAccuralAmountRecL3."Employee No.");
                            if EmployeeInterimAccuralsRecL.FindSet() then begin
                                repeat
                                    EmployeeInterimAccuralsRecL.Validate("Monthly Accrual Amount", EmployeeAccuralAmountRecL3."Accrued Amount");
                                    EmployeeInterimAccuralsRecL.Modify(true);
                                until EmployeeInterimAccuralsRecL.Next() = 0;
                            end;
                        until EmployeeAccuralAmountRecL3.Next() = 0;
                    end;
                    CurrPage.Update(true);
                end;
            }
            action("Load Employee")
            {
                ApplicationArea = All;
                Image = Setup;
                Promoted = true;
                trigger
                OnAction()
                var
                    EmployeeInterimAccuralsRecL: Record "Employee Interim Accurals";
                    EmployeeAccuralAmountRecL: Record "Employee Accural Amount";
                    PreEmployeeCode: Code[20];
                begin
                    EmployeeAccuralAmountRecL.Reset();
                    if EmployeeAccuralAmountRecL.IsEmpty then begin

                        EmployeeInterimAccuralsRecL.Reset();
                        EmployeeInterimAccuralsRecL.SetRange("Monthly Accrual Amount", 0);
                        EmployeeInterimAccuralsRecL.SetRange(Month, 1);
                        if EmployeeInterimAccuralsRecL.FindSet() then begin
                            repeat
                                if PreEmployeeCode <> EmployeeInterimAccuralsRecL."Worker ID" then begin
                                    EmployeeAccuralAmountRecL.Init();
                                    EmployeeAccuralAmountRecL."Employee No." := EmployeeInterimAccuralsRecL."Worker ID";
                                    EmployeeAccuralAmountRecL."Employee Name" := GetEmployeeNameByCode(EmployeeInterimAccuralsRecL."Worker ID");
                                    EmployeeAccuralAmountRecL."Accued Units" := EmployeeInterimAccuralsRecL."Monthly Accrual Units";
                                    EmployeeAccuralAmountRecL."Updated By" := UserId;
                                    EmployeeAccuralAmountRecL."Updated Date/Time" := CurrentDateTime;
                                    EmployeeAccuralAmountRecL."Sum of Earning Code" := GetEarningCodeSumByAccruals(EmployeeInterimAccuralsRecL."Worker ID");
                                    if NOT EmployeeAccuralAmountRecL.Insert() then
                                        EmployeeAccuralAmountRecL.Modify();

                                    PreEmployeeCode := EmployeeInterimAccuralsRecL."Worker ID";
                                end;
                            until EmployeeInterimAccuralsRecL.Next() = 0;
                        end;
                    end;
                    CurrPage.Update(true);
                end;
            }
        }
    }

    procedure GetEmployeeNameByCode(EmpCodde: Code[20]): Text
    var
        EmplRecG: Record Employee;
    begin
        EmplRecG.Reset();
        if EmplRecG.Get(EmpCodde) then
            exit(EmplRecG.FullName());
    end;

    procedure GetEarningCodeSumByAccruals(EmpCode: Code[20]): Decimal
    var
        PayrollJobPosWorkerAssignRecL: Record "Payroll Job Pos. Worker Assign";
        PayrollEarningCodeWrkrRecL: Record "Payroll Earning Code Wrkr";
        SumEmpEarningCodeAmount: Decimal;
    begin
        Clear(SumEmpEarningCodeAmount);
        PayrollJobPosWorkerAssignRecL.Reset();
        PayrollJobPosWorkerAssignRecL.SetRange("Is Primary Position", true);
        PayrollJobPosWorkerAssignRecL.SetRange(Worker, EmpCode);
        PayrollJobPosWorkerAssignRecL.SetRange("Effective End Date", 0D);
        if PayrollJobPosWorkerAssignRecL.FindFirst() then begin
            PayrollEarningCodeWrkrRecL.Reset();
            PayrollEarningCodeWrkrRecL.SetRange(Worker, PayrollJobPosWorkerAssignRecL.Worker);
            PayrollEarningCodeWrkrRecL.SetRange("Earning Code Group", PayrollJobPosWorkerAssignRecL."Emp. Earning Code Group");
            PayrollEarningCodeWrkrRecL.SetRange("Calc Accrual", true);
            if PayrollEarningCodeWrkrRecL.FindSet() then begin
                repeat
                    SumEmpEarningCodeAmount += PayrollEarningCodeWrkrRecL."Package Amount";
                until PayrollEarningCodeWrkrRecL.Next() = 0;
            end;
        end;
        exit(SumEmpEarningCodeAmount);
    end;

    procedure ReplaceString(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]): Text[250]
    var
        NewReplaceWith: Text[250];
    begin
        NewReplaceWith := DelChr(ReplaceWith, ',');
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + NewReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        exit(String);
    end;

    procedure DeleteDecimalComma(String: Text[250]): Text[250]
    var
        NewReplaceWith: Text[250];
    begin
        if String <> '' then
            NewReplaceWith := DelChr(String, '=', ',');
        exit(NewReplaceWith);
    end;

    procedure CurrentSeparator(): Char;
    begin
        EXIT(FORMAT(3 / 2) [2])
    end;
}