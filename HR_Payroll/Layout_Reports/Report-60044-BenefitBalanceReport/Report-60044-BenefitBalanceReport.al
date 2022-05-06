report 60044 "Benefit Balance Report"
{
    DefaultLayout = RDLC;
    // RDLCLayout = 'Benefit Balance Report.rdlc';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("HCM Benefit Wrkr"; "HCM Benefit Wrkr")
        {
            column(BenefitID; "HCM Benefit Wrkr"."Benefit Id")
            {
            }
            column(Worker; "HCM Benefit Wrkr".Worker)
            {
            }
            column(Description; "HCM Benefit Wrkr".Description)
            {
            }
            dataitem(Employee; Employee)
            {
                column(EmployeeNo; Employee."No.")
                {
                }
                column(Name; Employee."First Name")
                {
                }
                column(Department; Employee.Department)
                {
                }
            }
        }
    }
}