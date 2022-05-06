page 60038 "HCM Benefit ErnGrp Card"
{
    PageType = Card;
    SourceTable = "HCM Benefit ErnGrp";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Benefit Id"; Rec."Benefit Id")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Arabic Name"; Rec."Arabic Name")
                {
                    ApplicationArea = All;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = All;
                    Editable = ShortBoolG;
                }
            }
            group("Advance Setup")
            {
                field("Benefit Type"; Rec."Benefit Type")
                {
                    ApplicationArea = All;
                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                }
                field("Fin Accrual Required"; Rec."Fin Accrual Required")
                {
                    ApplicationArea = All;
                }
                field("Max Units"; Rec."Max Units")
                {
                    ApplicationArea = All;
                }
                field("Benefit Accrual Frequency"; Rec."Benefit Accrual Frequency")
                {
                    ApplicationArea = All;
                }
                field("Allow Encashment"; Rec."Allow Encashment")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("Adjust in Salary Grade Change"; Rec."Adjust in Salary Grade Change")
                {
                    ApplicationArea = All;
                }
                field("Calculate in Final Period of F&F"; Rec."Calculate in Final Period ofFF")
                {
                    ApplicationArea = All;
                }
            }
            group(Formula)
            {
                grid(Control25)
                {
                    group(Control24)
                    {
                        field("Unit Calc Formula"; UnitCalcFormula)
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Width = 500;

                            trigger OnValidate()
                            begin
                                Rec.SetFormulaForUnitCalc(UnitCalcFormula);
                            end;
                        }
                        field("Amount Calc Formula"; AmountCalcFormula)
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Width = 500;

                            trigger OnValidate()
                            begin
                                Rec.SetFormulaForAmountCalc(AmountCalcFormula);
                            end;
                        }
                        field("Encashment Formula"; EncashmentFormula)
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Width = 500;

                            trigger OnValidate()
                            begin
                                Rec.SetFormulaForEncashmentFormula(EncashmentFormula);
                            end;
                        }
                    }
                }
            }
            group("Accounting Setup")
            {
                group("Main Account")
                {
                    field("Main Account Type"; Rec."Main Account Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Main Account No."; Rec."Main Account No.")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Offset Account")
                {
                    field("Offset Account Type"; Rec."Offset Account Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Offset Account No."; Rec."Offset Account No.")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }


    trigger OnOpenPage()
    begin
        CheckBools;
    end;

    trigger OnAfterGetRecord()
    begin
        CheckBools;
        UnitCalcFormula := Rec.GetFormulaForUnitCalc;
        AmountCalcFormula := Rec.GetFormulaForAmountCalc;
        EncashmentFormula := Rec.GetFormulaForEncashmentFormula;
    end;

    var
        UnitCalcFormula: Text;
        AmountCalcFormula: Text;
        EncashmentFormula: Text;
        ShortBoolG: Boolean;

    procedure CheckBools()
    var
    begin
        if Rec."Short Name" = '' then
            ShortBoolG := true
        else
            ShortBoolG := false;
    end;
}