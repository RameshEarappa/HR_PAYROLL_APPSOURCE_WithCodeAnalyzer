report 60058 "Employee Dependent Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'HR_Payroll\Layout_Reports\Report-60058-EmployeeDependentDetails\EmployeeDependentDetails.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Employee Dependents Master"; "Employee Dependents Master")
        {
            RequestFilterFields = "No.", "Employee ID", Status, "Child with Special needs", "Child Educational Level", "Is Emergency Contact";
            column(No_EmployeeDependentsMaster; "Employee Dependents Master"."No.")
            {
            }
            column(DependentFullName_EmployeeDependentsMaster; "Employee Dependents Master"."Dependent First Name" + ' ' + "Employee Dependents Master"."Dependent Middle Name" + '  ' + "Employee Dependents Master"."Dependent Last Name")
            {
            }
            column(Relationship_EmployeeDependentsMaster; "Employee Dependents Master".Relationship)
            {
            }
            column(Gender_EmployeeDependentsMaster; "Employee Dependents Master".Gender)
            {
            }
            column(Nationality_EmployeeDependentsMaster; "Employee Dependents Master".Nationality)
            {
            }
            column(DateofBirth_EmployeeDependentsMaster; FORMAT("Employee Dependents Master"."Date of Birth", 10, '<Month,2>/<Day,2>/<Year4>'))
            {
            }
            column(MaritalStatus_EmployeeDependentsMaster; "Employee Dependents Master"."Marital Status")
            {
            }
            column(ChildwithSpecialneeds_EmployeeDependentsMaster; "Employee Dependents Master"."Child with Special needs")
            {
            }
            column(ChildEducationalLevel_EmployeeDependentsMaster; "Employee Dependents Master"."Child Educational Level")
            {
            }
            column(IsEmergencyContact_EmployeeDependentsMaster; "Employee Dependents Master"."Is Emergency Contact")
            {
            }
            column(FullTimeStudent_EmployeeDependentsMaster; "Employee Dependents Master"."Full Time Student")
            {
            }
            column(Status_EmployeeDependentsMaster; "Employee Dependents Master".Status)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(UserID; USERID)
            {
            }
            column(PrintDate; FORMAT(TODAY, 10, '<Month,2>/<Day,2>/<Year4>'))
            {
            }
            column(Logo; CompanyInformationG.Picture)
            {
            }
            column(EmploFullName; EmployeeRecG.FullName)
            {
            }
            column(EmployeeID_EmployeeDependentsMaster; "Employee Dependents Master"."Employee ID")
            {
            }

            trigger OnAfterGetRecord();
            begin
                EmployeeRecG.RESET;
                if EmployeeRecG.GET("Employee Dependents Master"."Employee ID") then;
            end;
        }
    }

    labels
    {
        ReportHeader = 'Employee Dependent Details'; DependentNameLbl = 'Dependent Name'; RelationshipLbl = 'Relationship'; NationalityLbl = 'Nationality'; GenderLbl = 'Gender'; DateofBirthLbl = 'Date of Birth'; MaritalStatusLbl = 'Marital Status'; ChildwithSpecialneedsLbl = 'Child with Special needs'; ChildEducationalLevelLbl = 'Child Educational Level'; IsEmergencyContactLbl = 'Is Emergency Contact'; StatusLbl = 'Status'; EmployeeIDLbl = 'Employee ID'; EmployeeName = 'Employee Name';
    }

    trigger OnInitReport();
    begin
        if CompanyInformationG.GET() then
            CompanyInformationG.CALCFIELDS(Picture);
    end;

    var
        CompanyInformationG: Record "Company Information";
        EmployeeRecG: Record Employee;
}