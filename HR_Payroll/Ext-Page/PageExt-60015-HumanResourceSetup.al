pageextension 60015 HumanResourceSetup extends "Human Resources Setup"
{
    layout
    {
        addlast(Numbering)
        {
            field("Dependent Nos."; Rec."Dependent Nos.")
            {
                ApplicationArea = All;

            }
            field("Dependent Request"; Rec."Dependent Request")
            {
                ApplicationArea = All;
            }
            field("Employee Creation Request Nos."; Rec."Employee Creation Request Nos.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Employee Identification Nos."; Rec."Employee Identification Nos.")
            {
                ApplicationArea = All;
            }
            field("Document Request ID"; Rec."Document Request ID")
            {
                ApplicationArea = All;
            }
            field("Document format ID"; Rec."Document format ID")
            {
                ApplicationArea = All;
            }
            field("Overtime Request ID No."; Rec."Overtime Request ID No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Overtime Benefit Claim No"; Rec."Overtime Benefit Claim No")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Sector ID"; Rec."Sector ID")
            {
                ApplicationArea = All;
            }
            field("Employee Payout Scheme ID"; Rec."Employee Payout Scheme ID")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Short Leave Request Id"; Rec."Short Leave Request Id")
            {
                ApplicationArea = All;
            }
            field("User Registration>"; Rec."User Registration")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Time Attande-Reception"; Rec."Time Attande-Reception")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(Registration; '')
            {
                Caption = 'Registration';
                Style = Strong;
                StyleExpr = TRUE;
                Visible = false;
                ApplicationArea = All;
            }
            field("Driving License Request ID"; Rec."Driving License Request ID")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Car Registration ID"; Rec."Car Registration ID")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }

        addafter(Numbering)
        {
            group(Journal)
            {
                Visible = false;
                Caption = 'Journal';
                field("OT Expense Journal Template"; Rec."OT Expense Journal Template")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("OT Expense Journal Batch"; Rec."OT Expense Journal Batch")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("OT Expense Debit Account"; Rec."OT Expense Debit Account")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group("Education Claim Journal")
            {
                Caption = 'Education & other alowance ';
                Visible = false;
                field("Education Allowance Debit"; Rec."Education Allowance Debit")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Education Allowance Credit"; Rec."Education Allowance Credit")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Edu. Allow. Payroll Component"; Rec."Edu. Allow. Payroll Component")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Edu. Book Allowance Debit"; Rec."Edu. Book Allowance Debit")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Edu. Book Allowance Credit"; Rec."Edu. Book Allowance Credit")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Edu Book Payroll Component"; Rec."Edu Book Payroll Component")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Special Need Allowance Debit"; Rec."Special Need Allowance Debit")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Special Need Allowance Credit"; Rec."Special Need Allowance Credit")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Special Need Payroll Component"; Rec."Special Need Payroll Component")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Edu. Claim Journal Template"; Rec."Edu. Claim Journal Template")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Edu. Claim Journal Batch"; Rec."Edu. Claim Journal Batch")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(General)
            {
                field("Employee Dimension Code"; Rec."Employee Dimension Code")
                {
                    LookupPageID = "Dimension List";
                    ApplicationArea = All;
                }
                field("Permissible Short Leave Hrs"; Rec."Permissible Short Leave Hrs")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}