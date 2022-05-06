codeunit 60008 "Payroll Statement JV"
{
    trigger OnRun();
    begin
        if StatementID <> '' then begin
            AdvPayrollSetup.GET;
            GenJournalBatch.RESET;
            GenJournalBatch.SETRANGE("Journal Template Name", AdvPayrollSetup."Journal Template Name");
            GenJournalBatch.SETRANGE(Name, AdvPayrollSetup."Journal Batch Name");
            if GenJournalBatch.FINDFIRST then
                DocNo := NoSeriesManagement.GetNextNo(GenJournalBatch."No. Series", TODAY, true);
            IF AdvPayrollSetup."Positng Type" = AdvPayrollSetup."Positng Type"::Individual THEN BEGIN
                PayrollStatementEmployee.RESET;
                PayrollStatementEmployee.SETRANGE("Payroll Statement ID", StatementID);
                if PayrollStatementEmployee.FINDSET then begin
                    repeat
                        Employee.RESET;
                        Employee.SETRANGE("No.", PayrollStatementEmployee.Worker);
                        if Employee.FINDFIRST then begin
                            PayrollStatementJV.SETTABLEVIEW(Employee);
                            PayrollStatementJV.SetValues(DocNo, PayrollStatementEmployee."Payroll Statement ID");
                            PayrollStatementJV.RUN;
                        end;
                    until PayrollStatementEmployee.NEXT = 0;
                end;
            END
            ELSE BEGIN
                AdvPayrollSetup.TestField("Consolidated Dimension");
                AdvPayrollSetup.TestField("Journal Template Name");
                AdvPayrollSetup.TestField("Journal Batch Name");
                GenJournalBatch.GET(AdvPayrollSetup."Journal Template Name", AdvPayrollSetup."Journal Batch Name");
                CLEAR(BenefitCode);
                BenefitCode.RESET;
                BenefitCode.SETRANGE("Fin Accrual Required", TRUE);
                IF BenefitCode.FINDFIRST THEN
                    REPEAT
                        PayrollDepartment.RESET;
                        IF PayrollDepartment.FINDFIRST THEN
                            REPEAT
                                CLEAR(BenefitAmount);
                                Employee.RESET;
                                Employee.CalcFields("Department Value");
                                Employee.SETRANGE(Employee."Department Value", PayrollDepartment."Department ID");
                                IF Employee.FINDFIRST THEN BEGIN
                                    REPEAT
                                        P_StatementLinesREc.RESET;
                                        P_StatementLinesREc.SETRANGE("Payroll Statement ID", StatementID);
                                        P_StatementLinesREc.SETRANGE(Worker, Employee."No.");
                                        P_StatementLinesREc.SETRANGE("Earning Code Type", P_StatementLinesREc."Earning Code Type"::Benefit);
                                        P_StatementLinesREc.SETRANGE("Benefit Code", BenefitCode."Benefit Id");
                                        P_StatementLinesREc.SETFILTER("Benefit Amount", '<>%1', 0);
                                        IF P_StatementLinesREc.FINDFIRST THEN BEGIN
                                            BenefitAmount += P_StatementLinesREc."Benefit Amount";
                                        END;
                                    UNTIL Employee.NEXT = 0;
                                END;
                                IF BenefitAmount <> 0 THEN
                                    ConsolidatedPayJournals(BenefitAmount, BenefitCode."Main Account No.", BenefitCode."Offset Account No.", DocNo, PayrollDepartment."Department Value");
                            UNTIL PayrollDepartment.NEXT = 0;
                    UNTIL BenefitCode.NEXT = 0;

                CLEAR(P_EarningCode);
                P_EarningCode.RESET;
                P_EarningCode.SETRANGE("Fin Accrual Required", TRUE);
                IF P_EarningCode.FINDFIRST THEN
                    REPEAT
                        PayrollDepartment.RESET;
                        IF PayrollDepartment.FINDFIRST THEN
                            REPEAT
                                CLEAR(EarningCodeAmount);
                                Employee.RESET;
                                Employee.CalcFields("Department Value");
                                Employee.SETRANGE(Employee."Department Value", PayrollDepartment."Department ID");
                                IF Employee.FINDFIRST THEN BEGIN
                                    REPEAT
                                        P_StatementLinesREc.RESET;
                                        P_StatementLinesREc.SETRANGE("Payroll Statement ID", StatementID);
                                        P_StatementLinesREc.SETRANGE(Worker, Employee."No.");
                                        P_StatementLinesREc.SETRANGE("Payroll Earning Code", P_EarningCode."Earning Code");
                                        P_StatementLinesREc.SETFILTER("Earning Code Amount", '<>%1', 0);
                                        IF P_StatementLinesREc.FINDFIRST THEN BEGIN
                                            EarningCodeAmount += P_StatementLinesREc."Earning Code Amount";
                                        END;
                                    UNTIL Employee.NEXT = 0;
                                END;
                                IF EarningCodeAmount <> 0 THEN
                                    ConsolidatedPayJournals(EarningCodeAmount, P_EarningCode."Main Account No.", P_EarningCode."Offset Account No.", DocNo, PayrollDepartment."Department Value");
                            UNTIL PayrollDepartment.NEXT = 0;
                    UNTIL P_EarningCode.NEXT = 0;
            END;
        END;
        MESSAGE('Journal Created SuccessFully ');
    END;

    PROCEDURE ConsolidatedPayJournals(JournalAmount: Decimal; MainAccount: Code[20]; OffsetAccount: Code[20]; DocNo: Code[20]; DeptCode: Code[20])
    var
        PayrollDepartment: Record "Payroll Department";
        PayrollStatement: Record "Payroll Statement";
    BEGIN
        AdvPayrollSetup.GET;
        GenJournalBatch.GET(AdvPayrollSetup."Journal Template Name", AdvPayrollSetup."Journal Batch Name");
        GenJournalLineRec2.RESET;
        GenJournalLineRec2.SETRANGE("Journal Template Name", AdvPayrollSetup."Journal Template Name");
        GenJournalLineRec2.SETRANGE("Journal Batch Name", AdvPayrollSetup."Journal Batch Name");
        IF GenJournalLineRec2.FINDLAST THEN;
        GenJournalLineRec.INIT;
        GenJournalLineRec.VALIDATE("Journal Template Name", AdvPayrollSetup."Journal Template Name");
        GenJournalLineRec.VALIDATE("Journal Batch Name", AdvPayrollSetup."Journal Batch Name");
        GenJournalLineRec.VALIDATE("Line No.", (GenJournalLineRec2."Line No." + 10000));
        GenJournalLineRec.VALIDATE("Posting No. Series", GenJournalBatch."Posting No. Series");
        GenJournalLineRec.INSERT(TRUE);
        IF GenJournalTemplate.GET(AdvPayrollSetup."Journal Template Name") THEN
            GenJournalLineRec.VALIDATE("Source Code", GenJournalTemplate."Source Code");
        GenJournalLineRec.VALIDATE("Document Type", GenJournalLineRec."Document Type"::" ");
        GenJournalLineRec."Document No." := DocNo;
        GenJournalLineRec."Posting Date" := TODAY;
        GenJournalLineRec.VALIDATE("Account Type", GenJournalLineRec."Account Type"::"G/L Account");
        GenJournalLineRec.VALIDATE("Account No.", MainAccount);
        GenJournalLineRec.VALIDATE(Amount, JournalAmount);
        GenJournalLineRec.VALIDATE("Bal. Account Type", GenJournalLineRec."Bal. Account Type"::"G/L Account");
        GenJournalLineRec.VALIDATE("Bal. Account No.", OffsetAccount);
        GenJournalLineRec.VALIDATE("Shortcut Dimension 1 Code", DeptCode);
        PayrollStatement.GET(P_StatementLinesREc."Payroll Statement ID");
        GenJournalLineRec.Description := PayrollStatement."Payroll Statement Description";
        GenJournalLineRec.MODIFY;
    END;

    var
        StatementID: Code[20];
        PayrollStatementEmployee: Record "Payroll Statement Employee";
        PayrollStatementJV: Report "Payroll Statement JV";
        P_StatementLinesREc: Record "Payroll Statement Lines";
        Employee: Record Employee;
        AdvPayrollSetup: Record "Advance Payroll Setup";
        GenJournalBatch: Record "Gen. Journal Batch";
        DocNo: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GenJournalLineRec: Record "Gen. Journal Line";
        GenJournalLineRec2: Record "Gen. Journal Line";
        UpdateDimensions: Codeunit "Update Dimensions";
        PayrollDepartment: Record "Payroll Department";
        GenJournalTemplate: Record "Gen. Journal Template";
        P_EarningCode: Record "Payroll Earning Code";
        BenefitCode: Record "HCM Benefit";
        BenefitAmount: Decimal;
        EarningCodeAmount: Decimal;

    procedure SetValue(l_StatementID: Code[20]);
    begin
        StatementID := l_StatementID;
    end;
}