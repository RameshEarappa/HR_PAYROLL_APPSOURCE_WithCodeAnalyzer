page 60037 "HCM Benefit ErnGrp"
{
    CardPageID = "HCM Benefit ErnGrp Card";
    PageType = List;
    SourceTable = "HCM Benefit ErnGrp";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Benefit Id"; Rec."Benefit Id")
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
                field("Unit Calc Formula"; Rec."Unit Calc Formula")
                {
                    ApplicationArea = All;
                }
                field("Amount Calc Formula"; Rec."Amount Calc Formula")
                {
                    ApplicationArea = All;
                }
                field("Allow Encashment"; Rec."Allow Encashment")
                {
                    ApplicationArea = All;
                }
                field("Encashment Formula"; Rec."Encashment Formula")
                {
                    ApplicationArea = All;
                }
                field("Payroll Earning Code"; Rec."Payroll Earning Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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
                field("Calculate in Final Period ofFF"; Rec."Calculate in Final Period ofFF")
                {
                    ApplicationArea = All;
                }
                field("Benefit Type"; Rec."Benefit Type")
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
                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                }
                field("Benefit Entitlement Days"; Rec."Benefit Entitlement Days")
                {
                    ApplicationArea = All;
                }
                field("Main Account Type"; Rec."Main Account Type")
                {
                    ApplicationArea = All;
                }
                field("Main Account No."; Rec."Main Account No.")
                {
                    ApplicationArea = All;
                }
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