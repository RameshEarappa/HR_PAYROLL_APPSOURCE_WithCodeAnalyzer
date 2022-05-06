page 60012 "Advance Payroll Setup"
{
    Caption = 'Advance Payroll Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;
    PromotedActionCategories = 'New,Process,Report,Customer Groups,Payments';
    SourceTable = "Advance Payroll Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Enable Alternate Calendar"; Rec."Enable Alternate Calendar")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Employee Default Leave Type"; Rec."Employee Default Leave Type")
                {
                    ApplicationArea = All;
                }
                field("Enable Benefit Adj. Jnl WF"; Rec."Enable Benefit Adj. Jnl WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Payroll Adj. Jnl WF"; Rec."Enable Payroll Adj. Jnl WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Loan Request WF"; Rec."Enable Loan Request WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Benefit claim req. WF"; Rec."Enable Benefit claim req. WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Leave Req. WF"; Rec."Enable Leave Req. WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Overtime Approval WF"; Rec."Enable Overtime Approval WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Payroll Statement WF"; Rec."Enable Payroll Statement WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Leave Resumption WF"; Rec."Enable Leave Resumption WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Salary Advance WF"; Rec."Enable Salary Advance WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Full and Final Jnl WF"; Rec."Enable Full and Final Jnl WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Document Req. WF"; Rec."Enable Document Req. WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Enable Payout Scheme WF"; Rec."Enable Payout Scheme WF")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Maintain Employment History"; Rec."Maintain Employment History")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Maintain Benefit History"; Rec."Maintain Benefit History")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Maintain Loan History"; Rec."Maintain Loan History")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Maintain Leave History"; Rec."Maintain Leave History")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Maintain Earning History"; Rec."Maintain Earning History")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Leave Request Post"; Rec."Leave Request Post")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Leave Resumption Post"; Rec."Leave Resumption Post")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Post Leave Cancellation"; Rec."Post Leave Cancellation")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Post Salary Adv. on approval"; Rec."Post Salary Adv. on approval")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Salary Change Show Error"; Rec."Salary Change Show Error")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Policy Change Show Error"; Rec."Policy Change Show Error")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Accrual Effective Start Date"; Rec."Accrual Effective Start Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Period Start Date"; Rec."Leave Period Start Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Period End Date"; Rec."Leave Period End Date")
                {
                    ApplicationArea = All;
                }
                field("Default Marital Status Spouse"; Rec."Default Marital Status Spouse")
                {
                    ApplicationArea = All;
                    Caption = 'Default Marital Status for Spouse';
                }
            }
            group("Number Series")
            {
                Caption = 'Number Series';
                field("Job Nos"; Rec."Job Nos")
                {
                    ApplicationArea = All;
                    Caption = 'Job ID';
                    Visible = false;
                }
                field("Position No."; Rec."Position No.")
                {
                    ApplicationArea = All;
                    Caption = 'Position ID';
                    Visible = false;
                }
                field("Earning Code Update No. Series"; Rec."Earning Code Update No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'Earning Code Update ID';
                    Visible = false;
                }
                field("Payroll Adj Journal No. Series"; Rec."Payroll Adj Journal No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Adj Journal ID';
                }
                field("Benefit Adj journal No. Series"; Rec."Benefit Adj journal No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'Benefit Adj Journal ID';
                }
                field("Payroll Statement No. Series"; Rec."Payroll Statement No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Statement ID';
                }
                field("Position No. Series"; Rec."Position No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'Position No.';
                }
                field("Benefit No. Series"; Rec."Benefit No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'Benefit No.';
                }
                field("Accrual Nos."; Rec."Accrual Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Accrual ID';
                }
                field("Payroll Job Nos."; Rec."Payroll Job Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Job Nos ID';
                }
                field("Leave Request Nos."; Rec."Leave Request Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Leave Request ID';
                }
                field("OT Setup ID"; Rec."OT Setup ID")
                {
                    ApplicationArea = All;
                    Caption = 'Over Time Setup ID';
                    Visible = false;
                }
                field("Educational Claim Nos."; Rec."Educational Claim Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Educational Claim ID';
                    Visible = false;
                }
                field("FS Journal ID"; Rec."FS Journal ID")
                {
                    ApplicationArea = All;
                    Caption = 'FS Journal ID';
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ApplicationArea = All;
                    Caption = 'Loan Type';
                }
                field("Delegation No."; Rec."Delegation No.")
                {
                    ApplicationArea = All;
                }
                field("Work Visa Request No."; Rec."Work Visa Request No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Loan Request ID"; Rec."Loan Request ID")
                {
                    ApplicationArea = All;
                }
                field("IQAMA Request No."; Rec."IQAMA Request No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Leave Adj No Series"; Rec."Leave Adj No Series")
                {
                    ApplicationArea = All;
                }
                field("Loan Adj. No Series"; Rec."Loan Adj. No Series")
                {
                    ApplicationArea = All;
                }
                field("Mission Order No. Series"; Rec."Mission Order No. Series")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Par diem Eligiblity No. Series"; Rec."Par diem Eligiblity No. Series")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Mo Expense Request No. Series"; Rec."Mo Expense Request No. Series")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Airport Access No. Series"; Rec."Airport Access No. Series")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Ticketing Tool No. Series"; Rec."Ticketing Tool No. Series")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Medical Expenses Doc No."; Rec."Medical Expenses Doc No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Performance Appraisal Ser. No."; Rec."Performance Appraisal Ser. No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Probation Months"; Rec."Probation Months")
                {
                    ApplicationArea = All;
                }
            }
            group(Journal)
            {
                Caption = 'Payroll statement Journal';
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Positng Type"; Rec."Positng Type")
                {
                    Caption = 'Posting Type';
                    ApplicationArea = All;
                    trigger OnValidate()
                    BEGIN
                        IF Rec."Positng Type" = Rec."Positng Type"::Individual THEN
                            Rec."Consolidated Dimension" := '';
                    END;
                }
                field("Consolidated Dimension"; Rec."Consolidated Dimension")
                {
                    ApplicationArea = All;
                    TRIGGER OnValidate()
                    BEGIN
                        IF Rec."Consolidated Dimension" <> '' THEN
                            Rec.TestField(Rec."Positng Type", Rec."Positng Type"::Consolidated);
                    END;
                }
            }
            group("Per diem Journal")
            {
                Visible = false;
                field("Par diem Journal Template Name"; Rec."Par diem Journal Template Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Par diem Journal Batch Name"; Rec."Par diem Journal Batch Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Par diem Debit Account"; Rec."Par diem Debit Account")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Par diem Credit Account"; Rec."Par diem Credit Account")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group("MO Expense Request")
            {
                Visible = false;
                field("MO Expense REQ Journal Template Name"; Rec."MOEXPREQ Journal Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'MO Expense REQ Journal Template Name';
                    ToolTip = 'MO Expense REQ Journal Template Name';
                    Visible = false;
                }
                field("MO Exp Request Journal Batch Name"; Rec."MOEXPREQ Journal Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'MO Exp Request Journal Batch Name';
                    ToolTip = 'MO Exp Request Journal Batch Name';
                    Visible = false;
                }
                field("MO Expense Request Debit Account"; Rec."MOEXPREQ Debit Account")
                {
                    ApplicationArea = All;
                    Caption = 'MO Expense Request Debit Account';
                    ToolTip = 'MO Expense Request Debit Account';
                    Visible = false;
                }
                field("MO Expense Request Credit Account"; Rec."MOEXPREQ Credit Account")
                {
                    ApplicationArea = All;
                    Caption = 'MO Expense Request Credit Account';
                    ToolTip = 'MO Expense Request Credit Account';
                    Visible = false;
                }
            }
            group("Medical Expenses")
            {
                Visible = false;
                field("Medical Expenses Gen. Template"; Rec."Medical Expenses Gen. Template")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Medical Expenses Gen. Batch"; Rec."Medical Expenses Gen. Batch")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Medical Expenses Debit Account"; Rec."Medical Expenses Debit Account")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Medical Expense Credit Account"; Rec."Medical Expense Credit Account")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group("Accrual Formula for per day")
            {
                field("Accrual Per day Formula"; Rec."Accrual Per day Formula")
                {
                    ApplicationArea = All;
                }
            }
            group("Azure DLL Link")
            {
                field("Azure Dll URL"; Rec."Azure Dll URL")
                {
                    ApplicationArea = All;
                }

            }
            group("Full and Final Settlement Posting Setup")
            {
                field("FnF Journal Template Name"; Rec."FnF Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("FnF Journal Batch Name"; Rec."FnF Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Leave Encashment Cr A/C Type"; Rec."Leave Encashment Cr A/C Type")
                {
                    ApplicationArea = All;
                }
                field("Leave Encashment Credit A/C"; Rec."Leave Encashment Credit A/C")
                {
                    ApplicationArea = All;
                }
                field("Leave Encashment Dr A/C Type"; Rec."Leave Encashment Dr A/C Type")
                {
                    ApplicationArea = All;
                }
                field("Leave Encashment Debit A/C"; Rec."Leave Encashment Debit A/C")
                {
                    ApplicationArea = All;
                }
                field("F and F Vendor Posting"; Rec."F and F Vendor Posting")
                {
                    ApplicationArea = All;
                }
            }
            group("Auto Post")
            {
                field("Auto Post Leave Request"; Rec."Auto Post Leave Request")
                {
                    ApplicationArea = All;
                }
                field("Auto Post Resumpt. Leave Req."; Rec."Auto Post Resumpt. Leave Req.")
                {
                    ApplicationArea = All;
                }
                field("Auto Post Cancel Leave Request"; Rec."Auto Post Cancel Leave Request")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.RESET;
        if not Rec.GET then begin
            Rec.INIT;
            Rec.INSERT;
        end;
    end;
}