page 60088 "Payroll Statement Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Payroll Statement Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payroll Statement ID"; Rec."Payroll Statement ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Worker; Rec.Worker)
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Payroll Statment Employee"; Rec."Payroll Statment Employee")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payroll Pay Cycle"; Rec."Payroll Pay Cycle")
                {
                    ApplicationArea = All;
                }
                field("Payroll Pay Period"; Rec."Payroll Pay Period")
                {
                    ApplicationArea = All;
                }
                field("Payroll Year"; Rec."Payroll Year")
                {
                    ApplicationArea = All;
                }
                field("Payroll Month"; Rec."Payroll Month")
                {
                    ApplicationArea = All;
                }
                field(Voucher; Rec.Voucher)
                {
                    ApplicationArea = All;
                }
                field("Payroll Earning Code"; Rec."Payroll Earning Code")
                {
                    ApplicationArea = All;
                }
                field("Payroll Earning Code Desc"; Rec."Payroll Earning Code Desc")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Type"; Rec."Earning Code Type")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Calc Sub Type"; Rec."Earning Code Calc Sub Type")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Calc Class"; Rec."Earning Code Calc Class")
                {
                    ApplicationArea = All;
                }
                field("Earniing Code Short Name"; Rec."Earniing Code Short Name")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Arabic Name"; Rec."Earning Code Arabic Name")
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
                field("Benefit Short Name"; Rec."Benefit Short Name")
                {
                    ApplicationArea = All;
                }
                field("Benenfit Arabic Name"; Rec."Benenfit Arabic Name")
                {
                    ApplicationArea = All;
                }
                field("Calculation Units"; Rec."Calculation Units")
                {
                    ApplicationArea = All;
                }
                field("Per Unit Amount"; Rec."Per Unit Amount")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Amount"; Rec."Earning Code Amount")
                {
                    ApplicationArea = All;
                }
                field("Benefit Amount"; Rec."Benefit Amount")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Calculation Basis Type"; Rec."Calculation Basis Type")
                {
                    ApplicationArea = All;
                }
                field("Fin Accural Required"; Rec."Fin Accural Required")
                {
                    ApplicationArea = All;
                }
                field("Default Dimension"; Rec."Default Dimension")
                {
                    ApplicationArea = All;
                }
                field("Payroll Transaction Type"; Rec."Payroll Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Benefit Encashment Amount"; Rec."Benefit Encashment Amount")
                {
                    ApplicationArea = All;
                }
                field(Pension; Rec.Pension)
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
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}