page 60086 "Payroll Statement Emp. List"
{
    Caption = 'Payroll Employees';
    PageType = ListPart;
    SourceTable = "Payroll Statement Employee";

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
                field("Payroll Pay Cycle"; Rec."Payroll Pay Cycle")
                {
                    ApplicationArea = All;
                }
                field("Payroll Pay Period"; Rec."Payroll Pay Period")
                {
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
                field("Payroll Year"; Rec."Payroll Year")
                {
                    ApplicationArea = All;
                }
                field("Payroll Month"; Rec."Payroll Month")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Voucher; Rec.Voucher)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    ApplicationArea = All;
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    ApplicationArea = All;
                }
                field("Paid Status"; Rec."Paid Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}