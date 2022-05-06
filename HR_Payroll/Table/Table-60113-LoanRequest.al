table 60113 "Loan Request"
{
    DataCaptionFields = "Loan Request ID", "Loan Type", "Loan Description", "Created Date";
    DrillDownPageID = "Loan Requests";
    LookupPageID = "Loan Requests";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Loan Request ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee ID"; Code[50])
        {
            TableRelation = Employee where(Status = filter(Active));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EmployeeRecL: Record Employee;
                PossAssgnRecL: Record "Payroll Job Pos. Worker Assign";
                PayrollPosiRecL: Record "Payroll Position";
            begin
                EmployeeRecL.Reset();
                if EmployeeRecL.Get("Employee ID") then begin

                    "Employee ID" := EmployeeRecL."No.";
                    "Employee Name" := EmployeeRecL.FullName();

                    PossAssgnRecL.Reset();
                    PossAssgnRecL.SetRange(Worker, EmployeeRecL."No.");
                    PossAssgnRecL.SetRange("Is Primary Position", true);
                    if PossAssgnRecL.FindFirst() then begin
                        PayrollPosiRecL.Reset();
                        PayrollPosiRecL.SetRange("Position ID", PossAssgnRecL."Position ID");
                        if PayrollPosiRecL.FindFirst() then begin
                            PayPeriods.Reset();
                            PayPeriods.SetRange("Pay Cycle", PayrollPosiRecL."Pay Cycle");
                            PayPeriods.SetRange("Period Start Date", "Repayment Start Date");
                            if PayPeriods.FindFirst() then begin
                                "Pay Period" := FORMAT(PayPeriods.Year) + ' ' + FORMAT(PayPeriods.Month);
                                "Pay Year" := PayPeriods.Year;
                                "Pay Month" := PayPeriods.Month;
                                "Pay Cycle" := PayPeriods."Pay Cycle";
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(4; "Employee Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Loan Type"; Code[50])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                EmployeeRecL: Record Employee;
                PossAssgnRecL: Record "Payroll Job Pos. Worker Assign";
                PayrollPosiRecL: Record "Payroll Position";
            begin
                "Number of Installments" := 0;
                "Request Amount" := 0;
                EmployeeEarningCodeGroup.RESET;
                EmployeeEarningCodeGroup.SETRANGE("Employee Code", Rec."Employee ID");
                EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', WORKDATE);
                EmployeeEarningCodeGroup.SETFILTER("Valid To", '>%1|%2', WORKDATE, 0D);
                if EmployeeEarningCodeGroup.FINDFIRST then;

                HCMLoanTableGCCWrkr.RESET;
                HCMLoanTableGCCWrkr.FILTERGROUP(2);
                HCMLoanTableGCCWrkr.SETRANGE(Worker, "Employee ID");
                HCMLoanTableGCCWrkr.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                HCMLoanTableGCCWrkr.SETRANGE(Active, true);
                HCMLoanTableGCCWrkr.FILTERGROUP(0);
                if PAGE.RUNMODAL(0, HCMLoanTableGCCWrkr) = ACTION::LookupOK then begin
                    "Loan Type" := HCMLoanTableGCCWrkr."Loan Code";
                    "Loan Description" := HCMLoanTableGCCWrkr."Loan Description";
                    "Interest Rate" := HCMLoanTableGCCWrkr."Interest Percentage";
                    "Number of Installments" := HCMLoanTableGCCWrkr."Number of Installment";
                    NumOfInst := HCMLoanTableGCCWrkr."Number of Installment";
                end;
                GetRequestAmnt;
                CheckMaxLoanRequest;

                HCMLoanTableGCCWrkr.SETRANGE(Worker, "Employee ID");
                HCMLoanTableGCCWrkr.SETRANGE("Loan Code", "Loan Type");
                if HCMLoanTableGCCWrkr.FINDFIRST then begin
                    if HCMLoanTableGCCWrkr."Allow Multiple Loans" = true then
                        exit
                    else begin
                        LoanInstallmentGeneration.SETRANGE(Loan, "Loan Type");
                        LoanInstallmentGeneration.SETRANGE("Employee ID", "Employee ID");
                        LoanInstallmentGeneration.SETFILTER(Status, '%1', LoanInstallmentGeneration.Status::Unrecovered);
                        if LoanInstallmentGeneration.FINDFIRST then
                            ERROR(Text50006, LoanInstallmentGeneration."Loan Request ID");
                    end
                end;

                EmployeeRecL.Reset();
                if EmployeeRecL.Get("Employee ID") then begin
                    PossAssgnRecL.Reset();
                    PossAssgnRecL.SetRange(Worker, EmployeeRecL."No.");
                    PossAssgnRecL.SetRange("Is Primary Position", true);
                    if PossAssgnRecL.FindFirst() then begin
                        PayrollPosiRecL.Reset();
                        PayrollPosiRecL.SetRange("Position ID", PossAssgnRecL."Position ID");
                        if PayrollPosiRecL.FindFirst() then begin
                            PayPeriods.Reset();
                            PayPeriods.SetRange("Pay Cycle", PayrollPosiRecL."Pay Cycle");
                            PayPeriods.SetRange("Period Start Date", "Repayment Start Date");
                            if PayPeriods.FindFirst() then begin
                                "Pay Period" := FORMAT(PayPeriods.Year) + ' ' + FORMAT(PayPeriods.Month);
                                "Pay Year" := PayPeriods.Year;
                                "Pay Month" := PayPeriods.Month;
                                "Pay Cycle" := PayPeriods."Pay Cycle";
                            end;
                        end;
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                "Number of Installments" := 0;
                "Request Amount" := 0;
            end;
        }
        field(6; "Loan Description"; Code[50])
        {
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(7; "Request Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                RequestDateValidation;
            end;
        }
        field(8; "Request Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateRequestAmnt;
            end;
        }
        field(9; "Interest Rate"; Decimal)
        {
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(10; "Number of Installments"; Integer)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                HCMLoanTableGCCWrkrL: Record "HCM Loan Table GCC Wrkr";
            begin
                Clear(HCMLoanTableGCCWrkrL);
                HCMLoanTableGCCWrkrL.SetRange("Loan Code", Rec."Loan Type");
                if HCMLoanTableGCCWrkrL.FindFirst() then
                    NumOfInst := HCMLoanTableGCCWrkrL."Number of Installment";
                if Rec."Number of Installments" > NumOfInst then
                    Error('Maximum no. of installments should not exceed %1', NumOfInst);
            end;
        }
        field(11; "Repayment Start Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                RepaymentStartDtValdation;
            end;
        }
        field(12; "Created By"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Created Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Installment Created"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Posting Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Payroll,Finance';
            OptionMembers = " ",Payroll,Finance;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                UserSetupRecL: Record "User Setup";
            begin
                if "WorkFlow Status" <> "WorkFlow Status"::Released then
                    Error('Workflow Status should be Open');
                UserSetupRecL.Reset();
                UserSetupRecL.SetRange("User ID", UserId);
                UserSetupRecL.SetRange("HR Manager", true);
                if NOT UserSetupRecL.FindFirst() then
                    Error('Only HR will modify');
            end;
        }
        field(16; "Pay Period"; Code[50])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                EmployeeRecL: Record Employee;
                PossAssgnRecL: Record "Payroll Job Pos. Worker Assign";
                PayrollPosiRecL: Record "Payroll Position";
                UserSetupRecL: Record "User Setup";
            begin
                if "WorkFlow Status" <> "WorkFlow Status"::Released then
                    Error('Workflow Status should be Open');

                UserSetupRecL.Reset();
                UserSetupRecL.SetRange("User ID", UserId);
                UserSetupRecL.SetRange("HR Manager", true);
                if NOT UserSetupRecL.FindFirst() then
                    Error('Only HR will modify');

                EmployeeRecL.Reset();
                if EmployeeRecL.Get("Employee ID") then begin
                    PossAssgnRecL.Reset();
                    PossAssgnRecL.SetRange(Worker, EmployeeRecL."No.");
                    PossAssgnRecL.SetRange("Is Primary Position", true);
                    if PossAssgnRecL.FindFirst() then begin
                        PayrollPosiRecL.Reset();
                        PayrollPosiRecL.SetRange("Position ID", PossAssgnRecL."Position ID");
                        if PayrollPosiRecL.FindFirst() then begin
                            PayPeriods.Reset();
                            PayPeriods.SetRange("Pay Cycle", PayrollPosiRecL."Pay Cycle");
                            if PAGE.RUNMODAL(0, PayPeriods) = ACTION::LookupOK then begin
                                "Pay Period" := FORMAT(PayPeriods.Year) + ' ' + FORMAT(PayPeriods.Month);
                                "Pay Year" := PayPeriods.Year;
                                "Pay Month" := PayPeriods.Month;
                                "Pay Cycle" := PayPeriods."Pay Cycle";
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(17; "WorkFlow Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Send for Approval,Rejected';
            OptionMembers = Open,Released,"Pending For Approval",Rejected;
            DataClassification = CustomerContent;
        }
        field(18; "Created Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Total Installment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Pay Year"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Pay Month"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Pay Cycle"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Journal Created"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Journal Document No."; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(25; RecID; RecordId)
        {
            DataClassification = CustomerContent;

        }
        field(26; "User_ID_Rec"; Code[250])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Loan Request ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Loan Request ID", "Loan Type", "Loan Description", "Created Date")
        {
        }
    }

    trigger OnDelete()
    begin
        if "WorkFlow Status" <> "WorkFlow Status"::Open then
            ERROR(Text50007, "Loan Request ID");
    end;

    trigger OnInsert()
    begin
        Initialise;
        RecID := Rec.RecordId;
        User_ID_Rec := UserId;
    end;

    trigger OnModify()
    begin
        RecID := Rec.RecordId;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Employee: Record Employee;
        PackageAmount: Decimal;
        FinalValidAmnt: Decimal;
        NumOfInst: Decimal;
        Text50001: Label 'Requested Amount %1  is greater than the Eligible Amount %2 on Request Amount Validation !';
        Text50002: Label 'Request Amount %1 should lie between Min Amount %2 and Max Amount %3  defined in the Loan Type Setup !';
        Text50003: Label 'Loan Request cannot be deleted since Workflow status is not open !';
        PayrollStatement: Record "Payroll Statement";
        PayrollStatementEmployee: Record "Payroll Statement Employee";
        Text50004: Label 'Payroll Statement exists for this Date %1, Select different date !';
        Text50005: Label 'Repayment Start Date %1 cannot be less than Request Date %2';
        HCMLoanTableGCCWrkr: Record "HCM Loan Table GCC Wrkr";
        PayPeriods: Record "Pay Periods";
        LoanRequest: Record "Loan Request";
        LoanInstallmentGeneration: Record "Loan Installment Generation";
        Text50006: Label 'Loan is not recovered fully for Loan Request %1 ';
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        Text50007: Label 'Cannot delete Loan Request %1';
        Text50008: Label 'Workflow Status has been changed to Open';
        AdvancePayrollSetup: Record "Advance Payroll Setup";

    local procedure Initialise()
    begin
        "Created By" := USERID;
        "Created Time" := TIME;
        "Request Date" := WORKDATE;
        "Entry No." := 0;
        "Repayment Start Date" := CALCDATE('<CM+1D>');
        "Posting Type" := "Posting Type"::Finance;
        AdvancePayrollSetup.GET;
        "Loan Request ID" := NoSeriesManagement.GetNextNo(AdvancePayrollSetup."Loan Request ID", WORKDATE, true);
        "WorkFlow Status" := "WorkFlow Status"::Open;
    end;

    local procedure ValidateRequestAmnt()
    var
        MultipleEarningCodes: Record "Multiple Earning Codes";
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
    begin
        HCMLoanTableGCCWrkr.SETRANGE(Worker, "Employee ID");
        HCMLoanTableGCCWrkr.SETRANGE("Loan Code", "Loan Type");
        if HCMLoanTableGCCWrkr.FINDFIRST then begin

            if HCMLoanTableGCCWrkr."Calculation Basis" = HCMLoanTableGCCWrkr."Calculation Basis"::"Multiple Earning Code" then begin
                MultipleEarningCodes.SETRANGE("Loan Code", "Loan Type");
                if MultipleEarningCodes.FINDSET then
                    repeat
                        PayrollEarningCodeWrkr.SETRANGE(Worker, "Employee ID");
                        PayrollEarningCodeWrkr.SETRANGE("Earning Code", MultipleEarningCodes."Earning Code");
                        if PayrollEarningCodeWrkr.FINDFIRST then begin
                            PackageAmount := PackageAmount + ((MultipleEarningCodes.Percentage) * (PayrollEarningCodeWrkr."Package Amount")) / 100;
                        end;

                    until MultipleEarningCodes.NEXT = 0;
                FinalValidAmnt := PackageAmount * HCMLoanTableGCCWrkr."No. of times Earning Code";

                if "Request Amount" > FinalValidAmnt then
                    ERROR(Text50001, "Request Amount", FinalValidAmnt);
            end;

            if HCMLoanTableGCCWrkr."Calculation Basis" = HCMLoanTableGCCWrkr."Calculation Basis"::"Min/Max Amount" then begin
                if ("Request Amount" > HCMLoanTableGCCWrkr."Max Loan Amount") or ("Request Amount" < HCMLoanTableGCCWrkr."Min Loan Amount") then
                    ERROR(Text50002, "Request Amount", HCMLoanTableGCCWrkr."Min Loan Amount", HCMLoanTableGCCWrkr."Max Loan Amount");
            end;
        end;
    end;

    procedure Reopen(var Rec: Record "Loan Request")
    begin
        if "WorkFlow Status" = "WorkFlow Status"::Open then
            exit;

        "WorkFlow Status" := "WorkFlow Status"::Open;
        MODIFY;
        MESSAGE(Text50008);
    end;

    local procedure DeletValidation()
    begin
        if "WorkFlow Status" <> "WorkFlow Status"::Open then
            ERROR(Text50003);
    end;

    local procedure RequestDateValidation()
    begin
        PayrollStatement.SETFILTER("Pay Period Start Date", '<%1', "Request Date");
        PayrollStatement.SETFILTER("Pay Period End Date", '>%1', "Request Date");
        if PayrollStatement.FINDFIRST then begin
            PayrollStatementEmployee.SETRANGE("Payroll Statement ID", PayrollStatement."Payroll Statement ID");
            PayrollStatementEmployee.SETRANGE(Worker, "Employee ID");
            if PayrollStatementEmployee.FINDFIRST then
                ERROR(Text50004, "Request Date");
        end;
    end;

    local procedure RepaymentStartDtValdation()
    begin
        if "Repayment Start Date" < "Request Date" then
            ERROR(Text50005, "Repayment Start Date", "Request Date");

        PayrollStatement.SETFILTER("Pay Period Start Date", '<%1', "Repayment Start Date");
        PayrollStatement.SETFILTER("Pay Period End Date", '>%1', "Repayment Start Date");
        if PayrollStatement.FINDFIRST then begin
            PayrollStatementEmployee.SETRANGE("Payroll Statement ID", PayrollStatement."Payroll Statement ID");
            PayrollStatementEmployee.SETRANGE(Worker, "Employee ID");
            if PayrollStatementEmployee.FINDFIRST then
                ERROR(Text50004, "Repayment Start Date");
        end;
    end;

    local procedure GetRequestAmnt()
    var
        MultipleEarningCodes: Record "Multiple Earning Codes";
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
    begin
        CLEAR(FinalValidAmnt);
        CLEAR(PackageAmount);

        HCMLoanTableGCCWrkr.SETRANGE(Worker, "Employee ID");
        HCMLoanTableGCCWrkr.SETRANGE("Loan Code", "Loan Type");
        if HCMLoanTableGCCWrkr.FINDFIRST then begin
            if HCMLoanTableGCCWrkr."Calculation Basis" = HCMLoanTableGCCWrkr."Calculation Basis"::"Multiple Earning Code" then begin
                MultipleEarningCodes.SETRANGE("Loan Code", "Loan Type");
                if MultipleEarningCodes.FINDSET then
                    repeat
                        PayrollEarningCodeWrkr.SETRANGE(Worker, "Employee ID");
                        PayrollEarningCodeWrkr.SETRANGE("Earning Code", MultipleEarningCodes."Earning Code");
                        if PayrollEarningCodeWrkr.FINDFIRST then begin
                            PackageAmount := PackageAmount + ((MultipleEarningCodes.Percentage) * (PayrollEarningCodeWrkr."Package Amount")) / 100;
                        end;
                    until MultipleEarningCodes.NEXT = 0;
                FinalValidAmnt := PackageAmount * HCMLoanTableGCCWrkr."No. of times Earning Code";
                VALIDATE("Request Amount", FinalValidAmnt);
                MODIFY;
            end;
        end;
    end;

    procedure CheckMaxLoanRequest()
    var
        HCMLoanTableGCCWrkrRecL: Record "HCM Loan Table GCC Wrkr";
        LoanRequestRecL: Record "Loan Request";
        LastDate: Date;
        FirstDate: Date;
    begin
        LastDate := CALCDATE('CY', "Request Date");
        FirstDate := CALCDATE('-CY', "Request Date");

        HCMLoanTableGCCWrkrRecL.Reset();
        HCMLoanTableGCCWrkrRecL.SetRange(Active, true);
        HCMLoanTableGCCWrkrRecL.SetRange(Worker, "Employee ID");
        HCMLoanTableGCCWrkrRecL.SetRange("Loan Code", "Loan Type");
        if HCMLoanTableGCCWrkrRecL.FindFirst() then;

        LoanRequestRecL.Reset();
        LoanRequestRecL.SetRange("Employee ID", "Employee ID");
        LoanRequestRecL.SetRange("Loan Type", "Loan Type");
        LoanRequestRecL.SetFilter("Request Date", '%1..%2', FirstDate, LastDate);
        if LoanRequestRecL.FindSet() then;

        if LoanRequestRecL.Count > HCMLoanTableGCCWrkrRecL."No. of Loans in a Year" then
            Error('%1 cannot be raised more than %2 times in a year.', LoanRequestRecL."Loan Type", HCMLoanTableGCCWrkrRecL."No. of Loans in a Year");
    end;
}