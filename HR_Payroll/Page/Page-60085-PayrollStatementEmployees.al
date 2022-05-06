page 60085 "Payroll Statement Employees"
{
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Payroll Statement";
    layout
    {
        area(content)
        {
            group(Control4)
            {
                Caption = 'Payroll Statement';
                field("Payroll Statement ID"; Rec."Payroll Statement ID")
                {
                    ApplicationArea = All;
                }
            }
            part(Employees; "Payroll Statement Emp. List")
            {
                SubPageLink = "Payroll Statement ID" = FIELD("Payroll Statement ID"),
                              "Payroll Pay Cycle" = FIELD("Pay Cycle"),
                              "Payroll Pay Period" = FIELD("Pay Period");
                ApplicationArea = All;
            }
            part("Payroll Statement Lines"; "Payroll Statement Lines")
            {
                Provider = Employees;
                ShowFilter = true;
                SubPageLink = "Payroll Statement ID" = FIELD("Payroll Statement ID"),
                              Worker = FIELD(Worker);
                ApplicationArea = All;
            }
            part("Payroll Statement Transactions"; "Payroll Statemnt Emp Stmt.")
            {
                Provider = Employees;
                SubPageLink = "Payroll Statement ID" = FIELD("Payroll Statement ID"),
                              Worker = FIELD(Worker);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Delete Lines")
            {
                Caption = 'Delete Lines';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if not CONFIRM('Do you want to delete all the records ?', true) then
                        exit;

                    PayrollStatement.RESET;
                    PayrollStatement.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
                    if PayrollStatement.FINDFIRST then begin
                        if not ((PayrollStatement.Status = PayrollStatement.Status::Open) or (PayrollStatement.Status = PayrollStatement.Status::Draft)) then
                            ERROR('Payroll statement Status Should be Open or Draft');

                        if PayrollStatement."Workflow Status" = PayrollStatement."Workflow Status"::Approved then
                            ERROR('Cannot delete records, Payroll statement Approval status is approved');
                    end;
                    PayrollStatementEmployee.RESET;
                    PayrollStatementEmployee.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
                    PayrollStatementEmployee.DELETEALL;

                    PayrollStatementTransLines.RESET;
                    PayrollStatementTransLines.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
                    PayrollStatementTransLines.DELETEALL;

                    PayrollStatementLines.RESET;
                    PayrollStatementLines.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
                    PayrollStatementLines.DELETEALL;

                    PayrollErrorLog.RESET;
                    PayrollErrorLog.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
                    PayrollErrorLog.DELETEALL;

                    PayrollStatement.RESET;
                    PayrollStatement.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
                    if PayrollStatement.FINDFIRST then begin
                        PayrollStatement.Status := PayrollStatement.Status::Open;
                        PayrollStatement.MODIFY;
                    end;
                end;
            }
        }
    }

    var
        PayrollStatementLines: Record "Payroll Statement Lines";
        PayrollStatementTransLines: Record "Payroll Statement Emp Trans.";
        PayrollStatementEmployee: Record "Payroll Statement Employee";
        PayrollStatement: Record "Payroll Statement";
        PayrollErrorLog: Record "Payroll Error Log";
}