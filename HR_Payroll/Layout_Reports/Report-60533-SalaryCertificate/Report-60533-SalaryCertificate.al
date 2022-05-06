report 60533 "Salary Certificate"
{

    DefaultLayout = RDLC;
    RDLCLayout = 'HR_Payroll\Layout_Reports\Report-60533-SalaryCertificate\salarycertificate.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Document Request"; "Document Request")
        {
            RequestFilterFields = "Document Request ID";

            column(Document_Date; FORMAT("Document Date", 0, '<Day,2>-<Month Text>-<Year4>')) { }
            column(Addressee; Addressee) { }
            column(Employee_ID; "Employee ID") { }
            column(Employee_Name; EmployeeRecG.FullName()) { }
            column(PassportNumber; GetPassportNumber_LT(EmployeeRecG."No.")) { }
            column(EmployeeRecG_Nationality; EmployeeRecG.Nationality) { }
            column(EmployeeDOJ; FORMAT(EmployeeRecG."Joining Date", 0, '<Day,2>-<Month Text>-<Year4>')) { }
            column(DesignationCodeG; DesignationCodeG) { }
            column(CompanyName; CompanyInformationRecG.Name) { }
            column(CompanyLogo; CompanyInformationRecG.Picture) { }
            column(CurrencyCodeCdG; CurrencyCodeCdG) { }
            column(HRManager; GetActiveHRManagerDetails()) { }
            column(MonthlyGrossSalaryDecG; MonthlyGrossSalaryDecG) { }

            trigger OnPreDataItem()
            begin
                Clear(CompanyInformationRecG);
                Clear(MonthlyGrossSalaryDecG);
                Clear(CurrencyCodeCdG);
                CompanyInformationRecG.Get;
                CompanyInformationRecG.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            var
            begin
                Clear(EmployeeRecG);
                if EmployeeRecG.get("Employee ID") then;

                Clear(DesignationCodeG);
                DesignationCodeG := GetEmployeeDesignation(EmployeeRecG."No.");
                MonthlyGrossSalary(EmployeeRecG."No.", MonthlyGrossSalaryDecG, CurrencyCodeCdG);
            end;
        }
    }
    var
        EmployeeRecG: Record Employee;
        CompanyInformationRecG: Record "Company Information";
        DesignationCodeG: Code[150];
        MonthlyGrossSalaryDecG: Decimal;
        CurrencyCodeCdG: Code[20];

    procedure GetEmployeeDesignation(EmployeeNo: Code[20]): Code[150]
    var
        PayrollJobPosWorkerAssignRecG: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRecG: Record "Payroll Position";
    begin
        PayrollJobPosWorkerAssignRecG.Reset();
        PayrollJobPosWorkerAssignRecG.SetRange(Worker, EmployeeNo);
        PayrollJobPosWorkerAssignRecG.SetRange("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRecG.FindFirst() then begin
            PayrollPositionRecG.Reset();
            PayrollPositionRecG.SetRange("Position ID", PayrollJobPosWorkerAssignRecG."Position ID");
            if PayrollPositionRecG.FindFirst() then
                exit(PayrollPositionRecG.Description);
        end;
    end;

    procedure MonthlyGrossSalary(EmployeeNo: Code[20]; var PackageAmount: Decimal; var CurrencyCode: Code[20])
    var
        EmployeeEarningCodeGroupsRecL: Record "Employee Earning Code Groups";
        PayrollEarningCodeWrkrRecG: Record "Payroll Earning Code Wrkr";
        PackgeAmountDecL: Decimal;
    begin
        Clear(PackgeAmountDecL);
        EmployeeEarningCodeGroupsRecL.Reset();
        EmployeeEarningCodeGroupsRecL.SetRange("Employee Code", EmployeeNo);
        EmployeeEarningCodeGroupsRecL.SetFilter("Valid To", '%1', 0D);
        if EmployeeEarningCodeGroupsRecL.FindFirst() then begin
            PayrollEarningCodeWrkrRecG.Reset();
            PayrollEarningCodeWrkrRecG.SetRange("Earning Code Group", EmployeeEarningCodeGroupsRecL."Earning Code Group");
            PayrollEarningCodeWrkrRecG.SetRange(Worker, EmployeeEarningCodeGroupsRecL."Employee Code");
            if PayrollEarningCodeWrkrRecG.FindSet() then
                repeat
                    if PayrollEarningCodeWrkrRecG."Package Amount" > 0 then
                        PackgeAmountDecL += PayrollEarningCodeWrkrRecG."Package Amount";
                until PayrollEarningCodeWrkrRecG.Next() = 0;
        end;
        PackageAmount := PackgeAmountDecL;
        CurrencyCode := EmployeeEarningCodeGroupsRecL.Currency;
    end;

    procedure GetActiveHRManagerDetails(): Text
    var
        UserSetupRecG: Record "User Setup";
        EmployeeRecL: Record Employee;
    begin
        UserSetupRecG.Reset();
        UserSetupRecG.SetRange("HR Manager", true);
        if UserSetupRecG.FindFirst() then begin
            EmployeeRecL.Reset();
            EmployeeRecL.SetRange("No.", UserSetupRecG."Employee Id");
            if EmployeeRecL.FindFirst() then
                exit(EmployeeRecL.FullName());
        end;
    end;

    procedure GetPassportNumber_LT(Employee_Code: Code[20]): text
    var
        IdentificationRec: Record "Identification Master";
    begin
        IdentificationRec.Reset();
        IdentificationRec.SetRange("Document Type", IdentificationRec."Document Type"::Employee);
        IdentificationRec.SetRange("Employee No.", Employee_Code);
        IdentificationRec.SetFilter("Identification Type", '%1', '*Passport');
        if IdentificationRec.FindFirst() then
            exit(IdentificationRec."Identification No.");
    end;
}