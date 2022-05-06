report 60532 "Leave Analysis BC"
{
    DefaultLayout = RDLC;
    //RDLCLayout = './Leave Analysis.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(CompLogo; CompanyInformation.Picture)
            {
            }
            column(CompName; CompanyInformation.Name)
            {
            }
            column(EmpNo; Employee."No.")
            {
            }
            column(EmpName; Employee."First Name")
            {
            }
            column(EmpDepartment; Employee.Department)
            {
            }
            column(EmployeeIDCaption; EmpIDCaption)
            {
            }
            column(EmpNameCaption; EmpNameCaption)
            {
            }
            column(EmpDepartCaption; EmpDepartmentCaption)
            {
            }
            column(RepNameCaption; ReportCaption)
            {
            }
            column(DateFilter; AsOfDate)
            {
            }
            dataitem(EmployeeWorkDate_GCC; EmployeeWorkDate_GCC)
            {
                DataItemLink = "Employee Code" = FIELD("No.");
                DataItemTableView = SORTING("Employee Code", "Trans Date");
                PrintOnlyIfDetail = false;
                column(EmpTransDate; EmployeeWorkDate_GCC."Trans Date")
                {
                }
                column(LeaveType; EmployeeWorkDate_GCC."First Half Leave Type")
                {
                }
                column(EmpCode; EmployeeWorkDate_GCC."Employee Code")
                {
                }
                column(OtherLeave; Other)
                {
                }
                column(IsSystemDefined; IsSystemDefined)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IsSystemDefined := false;
                    Other := false;
                    if HCMLeaveTypes.GET(EmployeeWorkDate_GCC."First Half Leave Type") then
                        if HCMLeaveTypes."Is System Defined" then
                            IsSystemDefined := true
                        else
                            Other := HCMLeaveTypes."Leave Classification" = HCMLeaveTypes."Leave Classification"::Other;
                end;

                trigger OnPreDataItem();
                begin
                    if AsOfDate <> 0D then begin
                        PeriodStartDate := CALCDATE('-CY', AsOfDate);
                        EmployeeWorkDate_GCC.SETFILTER("Trans Date", '%1..%2', PeriodStartDate, AsOfDate);
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("As Of Date"; AsOfDate)
                {
                    ApplicationArea = All;
                }
            }
        }
    }



    trigger OnPreReport();
    begin
        if CompanyInformation.GET then
            CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        AsOfDate: Date;
        CompanyInformation: Record "Company Information";
        EmpIDCaption: Label 'Employee ID';
        EmpNameCaption: Label 'Employee Name';
        EmpDepartmentCaption: Label 'Department';
        ReportCaption: Label 'Leave Analysis';
        HCMLeaveTypes: Record "HCM Leave Types";
        Other: Boolean;
        PeriodStartDate: Date;
        IsSystemDefined: Boolean;
}