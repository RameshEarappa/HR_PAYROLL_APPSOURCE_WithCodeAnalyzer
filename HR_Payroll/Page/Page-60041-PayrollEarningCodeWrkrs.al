page 60041 "Payroll Earng Code Wrkrs List"
{
    CardPageID = "Payroll Earning Code Wrkr";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll Earning Code Wrkr";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Pay Component Type"; Rec."Pay Component Type")
                {
                    ApplicationArea = All;
                }
                field("Fin Accrual Required"; Rec."Fin Accrual Required")
                {
                    ApplicationArea = All;
                }
                field("FF Adjustment Required"; Rec."FF Adjustment Required")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Calc Subtype"; Rec."Earning Code Calc Subtype")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Calc Class"; Rec."Earning Code Calc Class")
                {
                    ApplicationArea = All;
                }
                field("Rounding Method"; Rec."Rounding Method")
                {
                    ApplicationArea = All;
                }
                field("Decimal Rounding"; Rec."Decimal Rounding")
                {
                    ApplicationArea = All;
                }
                field("Package Amount"; Rec."Package Amount")
                {
                    ApplicationArea = All;
                }
                field("Minimum Value"; Rec."Minimum Value")
                {
                    ApplicationArea = All;
                }
                field("Maximum Value"; Rec."Maximum Value")
                {
                    ApplicationArea = All;
                }
                field(IsSysComponent; Rec.IsSysComponent)
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("Formula For Package"; Rec."Formula For Package")
                {
                    ApplicationArea = All;
                }
                field("Formula For Atttendance"; Rec."Formula For Atttendance")
                {
                    ApplicationArea = All;
                }
                field("Formula For Days"; Rec."Formula For Days")
                {
                    ApplicationArea = All;
                }
                field(WPSType; Rec.WPSType)
                {
                    ApplicationArea = All;
                }
                field("Arabic name"; Rec."Arabic name")
                {
                    ApplicationArea = All;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = All;
                }
                field("Final Settlement Component"; Rec."Final Settlement Component")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}