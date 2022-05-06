page 70151 "Payroll Accountant RC"
{
    Caption = 'Advance Payroll Accountant';
    PageType = RoleCenter;
    actions
    {
        area(Sections)
        {
            group("Group2")
            {
                Caption = 'Setup';
                group(SetupSubGrp1)
                {
                    Caption = 'Calendars';
                }
                group(SetupSubGrp2)
                {
                    Caption = 'Formulae And Keywords';
                    action("Payroll Fixed Formulas")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Payroll Fixed Formulas';
                        RunObject = page "Payroll Fixed Formulas";
                    }
                    action("Payroll Custom Formulas")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Payroll Custom Formulas';
                        RunObject = page "Payroll Custom Formulas";
                    }
                }
                group(SetupSubGrp3)
                {
                    Caption = 'Pay Cycle And Pay Periods';
                    action("Pay Cycles")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Pay Cycles';
                        RunObject = page "Pay Cycles";
                    }
                }
                group(SetupSubGrp4)
                {
                    Caption = 'Earning Code And Benefit Components';
                    action("Earning Code Groups")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Earning Code Groups';
                        RunObject = page "Earning Code Groups";
                    }
                    action("Payroll Earning Codes")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Payroll Earning Codes';
                        RunObject = page "Payroll Earning Codes";
                    }
                    action("HCM Benefits")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'HCM Benefits';
                        RunObject = page "HCM Benefits";
                    }
                    action("Leave Types")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Leave Types';
                        RunObject = page "Leave Types";
                    }
                    action("Loan Types")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Loan Types';
                        RunObject = page "Loan Types";
                    }
                }
                group(SetupSubGrp5)
                {
                    Caption = 'Process Setup';

                    action("Accrual Component List")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Accrual Component List';
                        RunObject = page "Accrual Component List";
                    }
                }
                group(SetupSubGrp8)
                {
                    Caption = 'Parameter Setup';
                    action("Advance Payroll Setup")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Advance Payroll Setup';
                        RunObject = page "Advance Payroll Setup";
                    }
                    action("Human Resources Setup")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Human Resources Setup';
                        RunObject = page "Human Resources Setup";
                    }
                }
                group(SetupSubGrp9)
                {
                    Caption = 'Employee Request';
                    action("Leave Requests")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Leave Requests';
                        RunObject = page "Leave Requests";
                    }
                    action("Loan Requests")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Loan Requests';
                        RunObject = page "Loan Requests";
                    }
                    action("Short Leave Request List")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Out of Office Requesrt';
                        RunObject = page "Short Leave Request List";
                    }
                    action("Documents Request")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Documents Request';
                        RunObject = page "Document Request List";
                    }
                }
                group(SetupSubGrp10)
                {
                    Caption = 'Time Attendance';
                    action("Import Time Attendance")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Import Time Attendance';
                        RunObject = page "Import Time Attendance";
                    }
                    action("Time Attendances")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Time Attendances';
                        RunObject = page "Time Attendances";
                    }
                }
                group(SetupSubGrp11)
                {
                    Caption = 'Loan Process';
                    action("Loan Process")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Loan Process';
                        RunObject = page "Loan Requests";
                    }
                    action("Loan Adjustments")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Loan Adjustments';
                        RunObject = page "Loan Adjustments";
                    }
                }
                group(SetupSubGrp12)
                {
                    Caption = 'Final Settlement';

                    action("Full and Final Settlement")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Full and Final Settlement';
                        RunObject = page "Full and Final Settlement";
                    }
                }
                group(SetupSubGrp13)
                {
                    Caption = 'Adjustment Journal';
                    action("Payroll Adjmt. Journals")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Payroll Adjmt. Journals';
                        RunObject = page "Payroll Adjmt. Journals";
                    }
                    action("Benefit Adjmt. Journal")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Benefit Adjmt. Journal';
                        RunObject = page "Benefit Adjmt. Journal";
                    }
                    action("Leave Adjmt. Journal Header")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Leave Adjmt. Journal Header';
                        RunObject = page "Leave Adjmt. Journal Header";
                    }
                }

                group(SetupSubGrp15)
                {
                    Caption = 'Payroll Statement';
                    action("Payroll Statements")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Payroll Statements';
                        RunObject = page "Payroll Statements";
                    }
                }
            }
            group("Group3")
            {
                Caption = 'Reports';
                group(ReportGrp2)
                {
                    Caption = 'Payroll Reports';
                    action("Payslip")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Payslip';
                        RunObject = report "DME Payslip";
                    }
                    action("Loan Details Report")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Loan Details Report';
                    }
                    action("Payroll Variance Report")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Payroll Variance Report';
                        RunObject = report "Payroll Variance Report";
                    }
                    action("Payroll Statement Report")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Payroll Statement Report';
                        RunObject = report "Payroll Statement Report";
                    }
                    action("Benefit Balance")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Benefit Balance';
                        RunObject = report "Benefit Balance Report";
                    }
                    action("Salary Update File")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Salary Update File';
                        RunObject = page "Excel Report Filter";
                    }
                }
                group("Group5")
                {
                    Caption = 'Announcements';
                    action(Announcements)
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'HR Announcements';
                        RunObject = page "HR Announcements List";
                    }
                }
            }
        }
    }
}