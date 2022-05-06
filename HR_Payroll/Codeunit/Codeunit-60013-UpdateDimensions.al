codeunit 60013 "Update Dimensions"
{
    var
        GLSetupShortcutDimCode: array[8] of Code[20];
        GLSetup: Record "General Ledger Setup";
        HRSetup: Record "Human Resources Setup";

    procedure ValidateShortCutDimension(var GenJournalLine: Record "Gen. Journal Line"; EmpCode: Code[20]);
    var
        Employee: Record Employee;
        PayrollDepartment: Record "Payroll Department";
    begin
        if GenJournalLine.FindSet() then begin
            repeat
                Employee.GET(EmpCode);
                PayrollDepartment.GET(Employee.Department);
                GLSetup.GET;
                if PayrollDepartment."Shortcut Dimension 1 Code" = GLSetup."Shortcut Dimension 1 Code" then
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PayrollDepartment."Department Value")
                else
                    if PayrollDepartment."Shortcut Dimension 1 Code" = GLSetup."Shortcut Dimension 2 Code" then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PayrollDepartment."Department Value");

                HRSetup.GET;
                if HRSetup."Employee Dimension Code" = GLSetup."Shortcut Dimension 1 Code" then
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Employee."No.")
                else
                    if HRSetup."Employee Dimension Code" = GLSetup."Shortcut Dimension 2 Code" then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Employee."No.")
        until GenJournalLine.Next() = 0;
        end;
    end;
}