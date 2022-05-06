report 60054 "Employee Identification Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'HR_Payroll\Layout_Reports\Report-60054-EmployeeIdentificationReport\EmployeeIdentificationReport.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Identification Master"; "Identification Master")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Employee));
            RequestFilterFields = "No.", "Identification Type", "Issuing Country", "Expiry Date", "Issuing Authority";
            column(EmployeeNo_IdentificationMaster; "Identification Master"."Employee No.")
            {
            }
            column(Emp_FullName; EmployeeRecG.FullName)
            {
            }
            column(IdentificationType_IdentificationMaster; "Identification Master"."Identification Type")
            {
            }
            column(IdentificationNo_IdentificationMaster; "Identification Master"."Identification No.")
            {
            }
            column(IDDocumentType_IdentificationMaster; "Identification Master"."ID Document Type")
            {
            }
            column(IssuingAuthority_IdentificationMaster; "Identification Master"."Issuing Authority")
            {
            }
            column(VisaType_IdentificationMaster; "Identification Master"."Visa Type")
            {
            }
            column(IssueDate_IdentificationMaster; FORMAT("Identification Master"."Issue Date", 10, '<Month,2>/<Day,2>/<Year4>'))
            {
            }
            column(ExpiryDate_IdentificationMaster; FORMAT("Identification Master"."Expiry Date", 10, '<Month,2>/<Day,2>/<Year4>'))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(IdentificationType_Description; IdentificationDocTypeMasterRecG.Description)
            {
            }
            column(IssuingAuthority_Description; IssuingAuthorityRecG.Description)
            {
            }
            column(UserID; USERID)
            {
            }
            column(PrintDate; FORMAT(TODAY, 10, '<Month,2>/<Day,2>/<Year4>'))
            {
            }

            trigger OnAfterGetRecord();
            begin
                EmployeeRecG.RESET;
                if EmployeeRecG.GET("Identification Master"."Employee No.") then;

                IdentificationDocTypeMasterRecG.RESET;
                if IdentificationDocTypeMasterRecG.GET("Identification Master"."Identification Type") then;

                IssuingAuthorityRecG.RESET;
                if IssuingAuthorityRecG.GET("Identification Master"."Issuing Authority") then;
            end;
        }
    }

    labels
    {
        ReportHeaderLBL = 'Employee Identitifation Report'; EmployeeIDLbl = 'Employee ID'; EmployeeNameLbl = 'Employee Name'; IdentificationTypeLbl = 'Identification Type'; IdentificationNumberLbl = 'Identification Number'; DocumentTypeLbl = 'Document Type'; IssueDateLbl = 'Issue Date'; ExpiryDateLbl = 'Expiry Date'; IssuingAuthorityLbl = 'Issuing Authority';
    }

    var
        EmployeeRecG: Record Employee;
        IdentificationDocTypeMasterRecG: Record "Identification Doc Type Master";
        IssuingAuthorityRecG: Record "Issuing Authority";
}