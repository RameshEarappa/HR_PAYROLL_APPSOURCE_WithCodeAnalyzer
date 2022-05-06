page 60000 "Payroll Earning Codes"
{
    CardPageID = "Payroll Earning Code";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll Earning Code";
    UsageCategory = Documents;
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
                field("Arabic name"; Rec."Arabic name")
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
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Formula For Atttendance"; Rec."Formula For Atttendance")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(RefRecId; Rec.RefRecId)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(RefTableId; Rec.RefTableId)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Formula For Days"; Rec."Formula For Days")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(WPSType; Rec.WPSType)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = All;
                }
                field("Final Settlement Component"; Rec."Final Settlement Component")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

