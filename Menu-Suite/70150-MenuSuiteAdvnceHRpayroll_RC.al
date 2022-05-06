page 70150 "Advance Payroll & HR RC"
{
    Caption = 'Advance Payroll & Human Resource Manager';
    PageType = RoleCenter;
    actions
    {
        area(Sections)
        {
            group("Group")
            {
                Caption = 'Masters';
                group(MstSubGrp1)
                {
                    Caption = 'Jobs';
                    action("Human Resource Jobs")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Human Resource Jobs';
                        RunObject = page "Payroll Jobs";
                    }
                }

                group(MstSubGrp2)
                {
                    Caption = 'Positions';
                    action("All Positions")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'All Positions';
                        RunObject = page "Payroll Job Postions";
                    }
                    action("Open Positions")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Open Positions';
                        RunObject = page "Payroll Job Open Postions";
                    }
                    action("Inactive Positions")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Inactive Positions';
                        RunObject = page "Payroll Job Inactive Postions";
                    }
                }

                group(MstSubGrp3)
                {
                    Caption = 'Employees';
                    action("Employees")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Employees';
                        RunObject = page "Employee List";
                    }
                    action("Past Employees")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Past Employees';
                        RunObject = page "Terminated Employee List";
                    }
                    action("Copy Employee")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Copy Employee';
                        Visible = false;
                    }
                }
            }
            group("Group2")
            {
                Caption = 'Setup';

                group(SetupSubGrp1)
                {
                    Caption = 'Calendars';
                    action("Work Calendars")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Work Calendars';
                        RunObject = page "Work Calendars";
                    }
                    action("Work Time Templates")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Work Time Templates';
                        RunObject = page "Work Time Templates";
                    }

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

                group(SetupSubGrp6)
                {
                    Caption = 'Insurance Setup';
                    action("Insurance Setup")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Insurance Provider';
                    }
                    action("Insurance Category")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Insurance Category';
                        RunObject = page "Insurance Category";
                    }
                }
                group(SetupSubGrp7)
                {
                    Caption = 'Sub Masters';
                    action("Department")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Department';
                        RunObject = page "Payroll Department";
                    }
                    action("Sub Department")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Sub Department';
                        RunObject = page "Sub Department";
                    }
                    action("Region Master")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Region';
                        RunObject = page "Region Master";
                    }
                    action("Sector List")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Sector';
                        RunObject = page "Sector List";
                    }
                    action("Initials")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Initials';
                        RunObject = page "Initials";
                    }
                    action("Marital Status")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Marital Status';
                        RunObject = page "Marital Status";
                    }
                    action("Payroll Religions")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Religions';
                        RunObject = page "Payroll Religions";
                    }
                    action("Work Location")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Work Location';
                        RunObject = page "Work Location";
                    }
                    action("Employment Type LT")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Employment Type';
                        RunObject = page "Employment Type LT";
                    }
                    action("Idetification DocType List")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Identification Types';
                        RunObject = page "Idetification DocType List";
                    }
                    action("Payroll Job Tests")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Tests';
                        RunObject = page "Payroll Job Tests";
                    }
                    action("Payroll Job Area of Resp.")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Areas of Responsibility';
                        RunObject = page "Payroll Job Area of Resp.";
                    }
                    action("Payroll Job Tasks")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Job Tasks';
                        RunObject = page "Payroll Job Tasks";
                    }
                    action("Payroll Job Title")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Job Title';
                        RunObject = page "Payroll Job Title";
                    }
                    action("Issuing Authority List")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Issuing Authority';
                        RunObject = page "Issuing Authority List";
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
                    action("Advance Workflow Setup")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Advance Workflow Setup';
                        RunObject = page "Advance Workflow Setup";
                    }
                    action("Human Resources Setup")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Human Resources Setup';
                        RunObject = page "Human Resources Setup";
                    }
                }
            }

            group("Group3")
            {
                Caption = 'Periodic';
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
                        Caption = 'Out of Office Requests';
                        RunObject = page "Short Leave Request List";
                    }
                    action("Documents Request")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Document Requests';
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
                        Caption = 'Loan Request';
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
                        Caption = 'Payroll Adjmt. Journal';
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
                        Caption = 'Leave Adjmt. Journal';
                        RunObject = page "Leave Adjmt. Journal Header";
                    }
                }
                group(SetupSubGrp14)
                {
                    Caption = 'Employee Assets';
                    action("Asset Issue List")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Asset Issue';
                        RunObject = page "Asset Issue List";
                    }
                    action("Asset Return List")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Asset Return';
                        RunObject = page "Asset Return List";
                    }
                    action("Asset Assignment Register List")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Asset Assignment Register';
                        RunObject = page "Asset Assignment Register List";
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

            group("Group4")
            {
                Caption = 'Reports';
                group(ReportGrp1)
                {
                    Caption = 'HR Reports';
                    action("Birthdays Report")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Birthdays Report';
                        RunObject = report "Birthdays Report";
                    }
                    action("Leave Analysis")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Leave Analysis';
                        RunObject = report "Leave Analysis";
                    }
                    action("Leave Balance")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Leave Balance';
                        RunObject = report "Leave Balance";
                    }
                    action("Employee Identification Report")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Employee Identification Report';
                        RunObject = report "Employee Identification Report";
                    }
                    action("Employee Dependent Details")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Employee Dependent Details';
                        RunObject = report "Employee Dependent Details";
                    }
                    action("Emp Dependent Identification")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Emp Dependent Identification';
                        RunObject = report "Emp Dependent Identification";
                    }
                }
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
                        Visible = false;
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
                        Visible = false;
                        Caption = 'Benefit Balance';
                        RunObject = report "Benefit Balance Report";
                    }
                    action("Payroll JV Report")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Payroll JV Report';
                        RunObject = page "Payroll JV Report Filter";
                    }
                    action("Salary Transfer Report")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Salary Transfer Report';
                        RunObject = page "Excel Report Filter";
                    }
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
            group("Group89")
            {
                Caption = 'Approvals';
                action(WorkFlowApproval)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Pending Approval Request';
                    RunObject = page "Requests to Approve";
                }
            }
        }
    }
}