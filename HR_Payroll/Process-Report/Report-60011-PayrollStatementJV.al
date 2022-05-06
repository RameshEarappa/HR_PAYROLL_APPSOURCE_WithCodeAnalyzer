report 60011 "Payroll Statement JV"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem(Employee; Employee)
        {
            trigger OnAfterGetRecord();
            var
                GLSetup: Record "General Ledger Setup";
                HRSetup: Record "Human Resources Setup";
                UpdateDimensions: Codeunit "Update Dimensions";
            begin
                // Start
                GenJournalBatch.RESET;
                GenJournalBatch.SETRANGE("Journal Template Name", AdvPayrollSetup."Journal Template Name");
                GenJournalBatch.SETRANGE(Name, AdvPayrollSetup."Journal Batch Name");
                if GenJournalBatch.FINDFIRST then;
                // Stop

                AdvPayrollSetup.GET;
                P_StatementLinesREc.RESET;
                P_StatementLinesREc.SETRANGE("Payroll Statment Employee", Employee."No.");
                P_StatementLinesREc.SETRANGE("Payroll Statement ID", PayStatementID);
                if P_StatementLinesREc.FINDSET then begin
                    repeat
                        if (P_StatementLinesREc."Earning Code Type" = P_StatementLinesREc."Earning Code Type"::Benefit)
                           and (P_StatementLinesREc."Benefit Amount" <> 0) then begin
                            BenefitCode.GET(P_StatementLinesREc."Benefit Code");
                            if BenefitCode."Fin Accrual Required" then begin
                                GenJournalLineRec2.RESET;
                                GenJournalLineRec2.SETRANGE("Journal Template Name", AdvPayrollSetup."Journal Template Name");
                                GenJournalLineRec2.SETRANGE("Journal Batch Name", AdvPayrollSetup."Journal Batch Name");
                                if GenJournalLineRec2.FINDLAST then;
                                GenJournalLineRec.INIT;
                                GenJournalLineRec.VALIDATE("Journal Template Name", AdvPayrollSetup."Journal Template Name");
                                GenJournalLineRec.VALIDATE("Journal Batch Name", AdvPayrollSetup."Journal Batch Name");
                                GenJournalLineRec.VALIDATE("Line No.", (GenJournalLineRec2."Line No." + 10000));
                                GenJournalLineRec.VALIDATE("Posting No. Series", GenJournalBatch."Posting No. Series");
                                GenJournalLineRec.INSERT(true);

                                if GenJournalTemplate.GET(AdvPayrollSetup."Journal Template Name") then
                                    GenJournalLineRec.VALIDATE("Source Code", GenJournalTemplate."Source Code");
                                GenJournalLineRec.VALIDATE("Document Type", GenJournalLineRec."Document Type"::" ");
                                GenJournalLineRec."Document No." := DocNo;
                                GenJournalLineRec."Posting Date" := TODAY;
                                BenefitCode.TESTFIELD("Main Account No.");
                                BenefitCode.TESTFIELD("Offset Account No.");
                                GenJournalLineRec.VALIDATE("Account Type", GenJournalLineRec."Account Type"::"G/L Account");
                                GenJournalLineRec.VALIDATE("Account No.", BenefitCode."Main Account No.");
                                GenJournalLineRec.VALIDATE(Amount, P_StatementLinesREc."Benefit Amount");
                                GenJournalLineRec.VALIDATE("Bal. Account Type", GenJournalLineRec."Bal. Account Type"::"G/L Account");
                                GenJournalLineRec.VALIDATE("Bal. Account No.", BenefitCode."Offset Account No.");
                                _Employee.GET(P_StatementLinesREc.Worker);
                                if _Employee."Global Dimension 2 Code" <> '' then begin
                                    GenJournalLineRec.ValidateShortcutDimCode(2, _Employee."Global Dimension 2 Code");
                                    GenJournalLineRec.VALIDATE("Shortcut Dimension 2 Code", _Employee."Global Dimension 2 Code");
                                end;
                                UpdateDimensions.ValidateShortCutDimension(GenJournalLineRec, P_StatementLinesREc.Worker);
                                GenJournalLineRec.Description := 'Salaries & Allow. for OIC GS Staff (' + P_StatementLinesREc."Payroll Month" + '. ' + FORMAT(P_StatementLinesREc."Payroll Year") + ')';
                                GenJournalLineRec.Comment := 'STAFF MEMBERS PAYROLL (' + P_StatementLinesREc."Payroll Month" + '. ' + FORMAT(P_StatementLinesREc."Payroll Year") + ')';
                                GenJournalLineRec.MODIFY;
                            end;
                        end
                        else begin
                            if P_StatementLinesREc."Earning Code Amount" <> 0 then begin
                                P_EarningCode.GET(P_StatementLinesREc."Payroll Earning Code");
                                if P_EarningCode."Fin Accrual Required" then begin
                                    GenJournalLineRec2.RESET;
                                    GenJournalLineRec2.SETRANGE("Journal Template Name", AdvPayrollSetup."Journal Template Name");
                                    GenJournalLineRec2.SETRANGE("Journal Batch Name", AdvPayrollSetup."Journal Batch Name");
                                    if GenJournalLineRec2.FINDLAST then;
                                    GenJournalLineRec.INIT;
                                    GenJournalLineRec.VALIDATE("Journal Template Name", AdvPayrollSetup."Journal Template Name");
                                    GenJournalLineRec.VALIDATE("Journal Batch Name", AdvPayrollSetup."Journal Batch Name");
                                    GenJournalLineRec.VALIDATE("Line No.", (GenJournalLineRec2."Line No." + 10000));
                                    GenJournalLineRec.INSERT(true);

                                    if GenJournalTemplate.GET(AdvPayrollSetup."Journal Template Name") then
                                        GenJournalLineRec.VALIDATE("Source Code", GenJournalTemplate."Source Code");
                                    GenJournalLineRec.VALIDATE("Document Type", GenJournalLineRec."Document Type"::" ");
                                    GenJournalLineRec."Document No." := DocNo;
                                    GenJournalLineRec."Posting Date" := TODAY;
                                    P_EarningCode.TESTFIELD("Main Account No.");
                                    P_EarningCode.TESTFIELD("Offset Account No.");
                                    GenJournalLineRec.VALIDATE("Account Type", GenJournalLineRec."Account Type"::"G/L Account");
                                    GenJournalLineRec.VALIDATE("Account No.", P_EarningCode."Main Account No.");
                                    GenJournalLineRec.VALIDATE(Amount, P_StatementLinesREc."Earning Code Amount");
                                    GenJournalLineRec.VALIDATE("Bal. Account Type", GenJournalLineRec."Bal. Account Type"::"G/L Account");
                                    GenJournalLineRec.VALIDATE("Bal. Account No.", P_EarningCode."Offset Account No.");
                                    _Employee.GET(P_StatementLinesREc.Worker);
                                    if _Employee."Global Dimension 2 Code" <> '' then begin
                                        GenJournalLineRec.ValidateShortcutDimCode(2, _Employee."Global Dimension 2 Code");
                                        GenJournalLineRec.VALIDATE("Shortcut Dimension 2 Code", _Employee."Global Dimension 2 Code");
                                    end;
                                    UpdateDimensions.ValidateShortCutDimension(GenJournalLineRec, P_StatementLinesREc.Worker);
                                    GenJournalLineRec.Description := 'Salaries & Allow. for OIC GS Staff (' + P_StatementLinesREc."Payroll Month" + '. ' + FORMAT(P_StatementLinesREc."Payroll Year") + ')';
                                    GenJournalLineRec.Comment := 'STAFF MEMBERS PAYROLL (' + P_StatementLinesREc."Payroll Month" + '. ' + FORMAT(P_StatementLinesREc."Payroll Year") + ')';
                                    GenJournalLineRec.MODIFY;
                                end;
                            end;
                        end;
                    until P_StatementLinesREc.NEXT = 0;
                end;
            end;
        }
    }

    var
        AdvPayrollSetup: Record "Advance Payroll Setup";
        GenJournalLineRec2: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLineRec: Record "Gen. Journal Line";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        P_StatementLinesREc: Record "Payroll Statement Lines";
        P_EarningCode: Record "Payroll Earning Code";
        BenefitCode: Record "HCM Benefit";
        EarningCode: Code[20];
        DocNo: Code[20];
        PayStatementID: Code[20];
        _Employee: Record Employee;
        GenJournalTemplate: Record "Gen. Journal Template";

    procedure SetValues(l_DocNo: Code[20]; l_PayStatementID: Code[20]);
    begin
        DocNo := l_DocNo;
        PayStatementID := l_PayStatementID;
    end;
}