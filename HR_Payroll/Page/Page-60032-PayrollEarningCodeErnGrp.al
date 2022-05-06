page 60032 "Payroll Earning Code ErnGrp"
{
    PageType = Card;
    SourceTable = "Payroll Earning Code ErnGrp";
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
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    Editable = EarningCodeBoolG;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = All;
                    Editable = ShortNameBoolG;
                }
                field("Unit Of Measure"; Rec."Unit Of Measure")
                {
                    ApplicationArea = All;
                    Editable = EditUnitofMeasure;

                    trigger OnValidate()
                    begin
                        if Rec."Unit Of Measure" = Rec."Unit Of Measure"::" " then
                            EditUnitofMeasure := true
                        else
                            EditUnitofMeasure := false;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Arabic name"; Rec."Arabic name")
                {
                    ApplicationArea = All;
                }
            }
            group("Adavanced Setup")
            {
                field("Pay Component Type"; Rec."Pay Component Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetFormulaEditable;
                    end;
                }
                field("Final Settlement Component"; Rec."Final Settlement Component")
                {
                    ApplicationArea = All;
                }
                field("Cost of Living Rate"; Rec."Cost of Living Rate")
                {
                    ApplicationArea = All;
                    Editable = EditCostofLiving;
                }
                field("Earning Code Type"; Rec."Earning Code Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetFormulaEditable
                    end;
                }
                field("Earning Code Calc Subtype"; Rec."Earning Code Calc Subtype")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetFormulaEditable;
                    end;
                }
                field("Earning Code Calc Class"; Rec."Earning Code Calc Class")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetFormulaEditable
                    end;
                }
                field("Minimum Value"; Rec."Minimum Value")
                {
                    ApplicationArea = All;
                }
                field("Maximum Value"; Rec."Maximum Value")
                {
                    ApplicationArea = All;
                }
                field("WPS Type"; Rec.WPSType)
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("FF Adjustment Required"; Rec."FF Adjustment Required")
                {
                    ApplicationArea = All;
                }
                field(IsSysComponent; Rec.IsSysComponent)
                {
                    ApplicationArea = All;
                }
                field("Fin Accrual Required"; Rec."Fin Accrual Required")
                {
                    ApplicationArea = All;
                }
                field("Calc Accrual"; Rec."Calc Accrual")
                {
                    ApplicationArea = All;
                }
                field("Calc. Payroll Adj."; Rec."Calc. Payroll Adj.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Leave Encashment Enable"; Rec."Leave Encashment Enable")
                {
                    ApplicationArea = All;
                }
            }
            group("Pay Component")
            {
                Editable = EditFormula;
                grid(Control39)
                {
                    group(Control38)
                    {
                        field("Formula For Package"; Rec."Formula For Package")
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Visible = false;
                            Width = 500;
                        }
                        field("Formula For Attendance"; FormulaForAttendance)
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Width = 500;

                            trigger OnValidate()
                            begin
                                Rec.SetFormulaForAttendance(FormulaForAttendance);
                            end;
                        }
                        field("Formula For Days"; Rec."Formula For Days")
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Width = 500;
                        }
                        field("Package Calc Type"; Rec."Package Calc Type")
                        {
                            ApplicationArea = All;

                            trigger OnValidate()
                            begin
                                if Rec."Package Calc Type" = Rec."Package Calc Type"::Amount then begin
                                    EditPackageCalcAmount := true;
                                    EditPackageCalcPerc := false;
                                    Rec."Package Percentage" := 0;
                                end
                                else begin
                                    EditPackageCalcAmount := false;
                                    EditPackageCalcPerc := true;
                                    Rec."Package Amount" := 0;
                                end;
                            end;
                        }
                    }
                }
                field("Package Amount"; Rec."Package Amount")
                {
                    ApplicationArea = All;
                    Editable = EditPackageCalcAmount;
                }
                field("Package Percentage"; Rec."Package Percentage")
                {
                    ApplicationArea = All;
                    Editable = EditPackageCalcPerc;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
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

    trigger OnAfterGetRecord()
    begin
        SetFormulaEditable;
        FormulaForAttendance := Rec.GetFormulaForAttendance;

        if rec."Short Name" = '' then
            ShortNameBoolG := true
        else
            ShortNameBoolG := false;

        if Rec."Earning Code" = '' then
            EarningCodeBoolG := true
        else
            EarningCodeBoolG := false;
    end;

    trigger OnOpenPage()
    begin
        SetFormulaEditable;

        if rec."Short Name" = '' then
            ShortNameBoolG := true
        else
            ShortNameBoolG := false;

        if Rec."Earning Code" = '' then
            EarningCodeBoolG := true
        else
            EarningCodeBoolG := false;
    end;

    var
        [InDataSet]
        EditFormula: Boolean;
        [InDataSet]
        EditUnitofMeasure: Boolean;
        [InDataSet]
        EditEarningCodeType: Boolean;
        [InDataSet]
        EditEarningCalcClass: Boolean;
        [InDataSet]
        EditCostofLiving: Boolean;
        [InDataSet]
        EditPackageCalcAmount: Boolean;
        [InDataSet]
        EditPackageCalcPerc: Boolean;
        FormulaForAttendance: Text;
        ShortNameBoolG: Boolean;
        EarningCodeBoolG: Boolean;

    procedure SetFormulaEditable()
    begin
        if Rec."Earning Code Calc Subtype" = Rec."Earning Code Calc Subtype"::Fixed then
            EditFormula := true
        else
            EditFormula := false;

        if Rec."Unit Of Measure" = Rec."Unit Of Measure"::" " then
            EditUnitofMeasure := true
        else
            EditUnitofMeasure := false;

        if Rec."Pay Component Type" = Rec."Pay Component Type"::"Cost of Living" then
            EditCostofLiving := true
        else
            EditCostofLiving := false;
    end;

    procedure ValidateMandotoryFields()
    begin
        if Rec."Earning Code" <> '' then begin
            Rec.TESTFIELD("Short Name");
            Rec.TESTFIELD(Description);
        end;
        if Rec."Unit Of Measure" = Rec."Unit Of Measure"::" " then
            ERROR('Please select Unit of Measure before closing the page');

        if Rec."Earning Code Calc Class" = Rec."Earning Code Calc Class"::" " then
            ERROR('Please select Earning Code Calculation Class closing the page');

        if Rec."Earning Code Calc Subtype" = Rec."Earning Code Calc Subtype"::" " then
            ERROR('Please select Earning Code Calculation subtype closing the page');

        if Rec."Earning Code Type" = Rec."Earning Code Type"::" " then
            ERROR('Please select Earning code type before closing the page');
    end;
}