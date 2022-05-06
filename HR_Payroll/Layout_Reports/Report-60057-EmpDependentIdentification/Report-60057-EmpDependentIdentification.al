report 60057 "Emp Dependent Identification"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'HR_Payroll\Layout_Reports\Report-60057-EmpDependentIdentification\EmpDependentIdentification.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Identification Master"; "Identification Master")
        {
            DataItemTableView = WHERE("Document Type" = FILTER(Dependent));
            RequestFilterFields = "No.", "Identification Type", "Issuing Country", "Expiry Date", "Issuing Authority";
            column(EmployeeNo_IdentificationMaster; EmployeeRecG."No.")
            {
            }
            column(Emp_FullName; EmployeeRecG.FullName)
            {
            }
            column(No_IdentificationMaster; "Identification Master"."No.")
            {
            }
            column(DependentNo_IdentificationMaster; "Identification Master"."Dependent No")
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
            column(DependentFullName; EmployeeDependentsMasterRecG."Dependent First Name" + ' ' + EmployeeDependentsMasterRecG."Dependent Middle Name" + ' ' + EmployeeDependentsMasterRecG."Dependent Last Name")
            {
            }
            column(Logo; CompanyInformationG.Picture)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if (EmployeeNoG <> '') and (DependentCodeG <> '') then begin
                    IdentificationDocTypeMasterRecG.RESET;
                    if IdentificationDocTypeMasterRecG.GET("Identification Master"."Identification Type") then;

                    IssuingAuthorityRecG.RESET;
                    if IssuingAuthorityRecG.GET("Identification Master"."Issuing Authority") then;

                    EmployeeDependentsMasterRecG.RESET;
                    EmployeeDependentsMasterRecG.SETRANGE("No.", "Identification Master"."Dependent No");
                    if EmployeeDependentsMasterRecG.FINDFIRST then begin
                        EmployeeRecG.RESET;
                        if EmployeeRecG.GET(EmployeeDependentsMasterRecG."Employee ID") then;
                    end;
                end
                else
                    if (EmployeeNoG = '') and (DependentCodeG = '') then begin
                        IdentificationDocTypeMasterRecG.RESET;
                        if IdentificationDocTypeMasterRecG.GET("Identification Master"."Identification Type") then;

                        IssuingAuthorityRecG.RESET;
                        if IssuingAuthorityRecG.GET("Identification Master"."Issuing Authority") then;

                        EmployeeDependentsMasterRecG.RESET;
                        EmployeeDependentsMasterRecG.SETRANGE("No.", "Identification Master"."Dependent No");
                        if EmployeeDependentsMasterRecG.FINDFIRST then begin
                            EmployeeRecG.RESET;
                            if EmployeeRecG.GET(EmployeeDependentsMasterRecG."Employee ID") then;
                        end;
                    end
                    else
                        if (EmployeeNoG <> '') and (DependentCodeG = '') then begin
                            IdentificationDocTypeMasterRecG.RESET;
                            if IdentificationDocTypeMasterRecG.GET("Identification Master"."Identification Type") then;

                            IssuingAuthorityRecG.RESET;
                            if IssuingAuthorityRecG.GET("Identification Master"."Issuing Authority") then;

                            EmployeeDependentsMasterRecG.RESET;
                            EmployeeDependentsMasterRecG.SETRANGE("No.", "Identification Master"."Dependent No");
                            EmployeeDependentsMasterRecG.SETRANGE("Employee ID", EmployeeNoG);
                            if EmployeeDependentsMasterRecG.FINDFIRST then begin
                                EmployeeRecG.RESET;
                                if EmployeeRecG.GET(EmployeeDependentsMasterRecG."Employee ID") then;
                            end else
                                CurrReport.SKIP;
                        end;
            end;

            trigger OnPreDataItem();
            begin
                if (EmployeeNoG <> '') and (DependentCodeG <> '') then
                    "Identification Master".SETRANGE("Identification Master"."Dependent No", DependentCodeG);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field("Employee Code"; EmployeeNoG)
                {
                    TableRelation = Employee;
                    ApplicationArea = All;
                }
                field("Dependent Code"; DependentCodeG)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        EmployeeDependentsMasterRec2G.RESET;
                        EmployeeDependentsMasterRec2G.SETRANGE("Employee ID", EmployeeNoG);
                        if EmployeeDependentsMasterRec2G.FINDSET then begin
                            EmployeeDependentListPageG.SETRECORD(EmployeeDependentsMasterRec2G);
                            EmployeeDependentListPageG.SETTABLEVIEW(EmployeeDependentsMasterRec2G);
                            EmployeeDependentListPageG.LOOKUPMODE(true);
                            if EmployeeDependentListPageG.RUNMODAL = ACTION::LookupOK then begin
                                EmployeeDependentListPageG.GETRECORD(EmployeeDependentsMasterRec2G);
                                DependentCodeG := EmployeeDependentsMasterRec2G."No.";
                            end;
                        end;
                    end;
                }
            }
        }
    }

    labels
    {
        ReportHeaderLBL = 'Employee Dependent Identitifation Report'; EmployeeIDLbl = 'Employee ID'; EmployeeNameLbl = 'Employee Name'; IdentificationTypeLbl = 'Identification Type'; IdentificationNumberLbl = 'Identification No.'; DocumentTypeLbl = 'Document Type'; IssueDateLbl = 'Issue Date'; ExpiryDateLbl = 'Expiry Date'; IssuingAuthorityLbl = 'Issuing Authority';
    }

    trigger OnInitReport();
    begin
        if CompanyInformationG.GET() then
            CompanyInformationG.CALCFIELDS(Picture);
    end;

    var
        EmployeeRecG: Record Employee;
        IdentificationDocTypeMasterRecG: Record "Identification Doc Type Master";
        IssuingAuthorityRecG: Record "Issuing Authority";
        EmployeeDependentsMasterRecG: Record "Employee Dependents Master";
        EmployeeNoG: Code[20];
        DependentCodeG: Code[20];
        CompanyInformationG: Record "Company Information";
        EmployeeDependentsMasterRec2G: Record "Employee Dependents Master";
        EmployeeDependentListPageG: Page "Employee Dependent List";
}