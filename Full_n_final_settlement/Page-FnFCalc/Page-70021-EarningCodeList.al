page 70021 "Emp. Earning Code List FnFCalc"
{
    PageType = List;
    SourceTable = "Emp. Earning Code List FnFCalc";
    UsageCategory = Lists;
    ApplicationArea = All;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Caption = 'FnF Calc Emp. Earning Code List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(EECList__Paycomponentcode; Rec.EECList__Paycomponentcode)
                {
                    ApplicationArea = All;
                }
                field(EECList__UnitFormulaTxt; EECList__UnitFormulaTxt)
                {
                    Caption = 'Formula Value';
                    ApplicationArea = All;
                }
                field(EECList__FormulaforattendanceTxt; EECList__FormulaforattendanceTxt)
                {
                    ApplicationArea = All;
                }
                field(EECList__FormulafordaysTxt; EECList__FormulafordaysTxt)
                {
                    ApplicationArea = All;
                }
                field(EECList__Paycomponenttype; Rec.EECList__Paycomponenttype)
                {
                    ApplicationArea = All;
                }
                field(EECList__Pay_Comp_UnitFormula; Rec.EECList__Pay_Comp_UnitFormula)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                }
            }
        }
    }
    var
        EECList__FormulafordaysTxt: Text;
        EECList__FormulaforattendanceTxt: Text;
        EECList__UnitFormulaTxt: Text;

    trigger
    OnAfterGetRecord()
    var
    begin
        EECList__FormulafordaysTxt := Rec.GETEECList__Formulafordays();

        EECList__FormulaforattendanceTxt := Rec.GETEECList__Formulaforattendance();

        EECList__UnitFormulaTxt := Rec.GETFormulaEECList__UnitFormula();
    end;
}