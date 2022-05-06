page 60042 "Payroll Earning Code Wrkr"
{
    PageType = Card;
    SourceTable = "Payroll Earning Code Wrkr";
    UsageCategory = Documents;
    ApplicationArea = All;
    DelayedInsert = true;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(Worker; Rec.Worker)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    Editable = BlankBool1G;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = All;
                    Editable = BlankBool2G;
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
                    ApplicationArea = all;
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
                }
                field("Leave Encashment Enable"; Rec."Leave Encashment Enable")
                {
                    ApplicationArea = All;
                }
            }
            group("Pay Component")
            {
                grid(Control36)
                {
                    group(Control35)
                    {
                        field("Formula For Package"; Rec."Formula For Package")
                        {
                            ApplicationArea = All;
                            Editable = EditFormula;
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
                            Editable = EditFormula;
                            MultiLine = true;
                            Width = 500;
                        }
                        field("Package Calc Type"; Rec."Package Calc Type")
                        {
                            ApplicationArea = All;

                            trigger OnValidate()
                            begin

                                IF Rec."Package Calc Type" = Rec."Package Calc Type"::Amount THEN BEGIN
                                    EditPackageCalcAmount := TRUE;
                                    EditPackageCalcPerc := FALSE;
                                    Rec."Package Percentage" := 0;
                                END
                                ELSE BEGIN
                                    EditPackageCalcAmount := FALSE;
                                    EditPackageCalcPerc := TRUE;
                                    Rec."Package Amount" := 0;
                                END;
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
    var
        EarningCGRecL: Record "Employee Earning Code Groups";
    begin
        SetFormulaEditable;
        FormulaForAttendance := Rec.GetFormulaForAttendance;
    end;


    trigger OnOpenPage()
    var
        EarningCGRecL: Record "Employee Earning Code Groups";
    begin
        SetFormulaEditable;
    end;

    var
        EditFormula: Boolean;
        EditUnitofMeasure: Boolean;
        EditCostofLiving: Boolean;
        EditPackageCalcAmount: Boolean;
        EditPackageCalcPerc: Boolean;
        FormulaForAttendance: Text;
        EarningCodeGroup: Record "Earning Code Groups";
        BlankBool1G: Boolean;
        BlankBool2G: Boolean;

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


        EarningCodeGroup.RESET;
        EarningCodeGroup.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if EarningCodeGroup.FINDFIRST then begin
            if EarningCodeGroup."Edit Service Package" then
                EditPackageCalcAmount := true
            else
                EditPackageCalcAmount := false;
        end;
        if Rec."Short Name" = '' then
            BlankBool2G := true
        else
            BlankBool2G := false;

        if Rec."Earning Code" = '' then
            BlankBool1G := true
        else
            BlankBool1G := false;
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