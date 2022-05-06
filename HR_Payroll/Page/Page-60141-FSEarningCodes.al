page 60141 "FS Earning Codes"
{
    PageType = ListPart;
    SourceTable = "FS - Earning Code";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                }
                field("Earning Description"; Rec."Earning Description")
                {
                    ApplicationArea = All;
                }
                field("Benefit Code"; Rec."Benefit Code")
                {
                    ApplicationArea = All;
                }
                field("Benefit Description"; Rec."Benefit Description")
                {
                    ApplicationArea = All;
                }
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    ApplicationArea = All;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                }
                field("Payroll Period RecID"; Rec."Payroll Period RecID")
                {
                    ApplicationArea = All;
                }
                field("Pay Period Start"; Rec."Pay Period Start")
                {
                    ApplicationArea = All;
                }
                field("Pay Period End"; Rec."Pay Period End")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Calc Class"; Rec."Earning Code Calc Class")
                {
                    ApplicationArea = All;
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = All;
                }
                field("Calculation Units"; Rec."Calculation Units")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Amount"; Rec."Earning Code Amount")
                {
                    ApplicationArea = All;
                }
                field("Payable Amount"; Rec."Payable Amount")
                {
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                }
                field("Benefit Amount"; Rec."Benefit Amount")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Suspend Payroll"; Rec."Suspend Payroll")
                {
                    ApplicationArea = All;
                }
                field("Temporary Payroll Hold"; Rec."Temporary Payroll Hold")
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