page 60150 "Full and Final Calculation"
{
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Worker; Worker)
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Employee: Record Employee;
                        Employee2: Record Employee;
                    begin
                        Employee.RESET;
                        Employee.FILTERGROUP(2);
                        Employee.SETFILTER("Termination Date", '<>%1', 0D);
                        Employee.FILTERGROUP(0);
                        if PAGE.RUNMODAL(5201, Employee) = ACTION::LookupOK then begin
                            Worker := Employee."No.";
                            WorkerName := Employee."First Name" + ' ' + Employee."Last Name";
                            ServiceDays := Employee."Termination Date" - Employee."Employment Date";
                            JoinDate := Employee."Joining Date";
                            TerminationDate := Employee."Employment End Date";
                            EmployeeEarningCodeGroups.RESET;
                            EmployeeEarningCodeGroups.SETRANGE("Employee Code", Employee."No.");
                            EmployeeEarningCodeGroups.SETFILTER("Valid From", '<=%1', WORKDATE);
                            EmployeeEarningCodeGroups.SETFILTER("Valid To", '>=%1|%2', WORKDATE, 0D);
                            if EmployeeEarningCodeGroups.FINDFIRST then begin
                                Currency := EmployeeEarningCodeGroups.Currency;
                            end;
                        end;
                    end;
                }
                field("Worker Name"; WorkerName)
                {
                    ApplicationArea = All;
                }
                field("Service Days"; ServiceDays)
                {
                    ApplicationArea = All;
                }
                field("Joining Date"; JoinDate)
                {
                    ApplicationArea = All;
                }
                field("Termination Date"; TerminationDate)
                {
                    ApplicationArea = All;
                }
                field("Pay Cycle"; PayCycle)
                {
                    ApplicationArea = All;
                    TableRelation = "Pay Cycles";
                }
                field(Currency; Currency)
                {
                    ApplicationArea = All;
                }
                field(Calculated; Calculated)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup15)
            {
                action(Calculate)
                {
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        RecEmployee: Record Employee;
                    begin
                        if not CONFIRM('Do you want to calculate the Full and Final Settlement ?', true) then
                            exit;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FSEarningCodes.DELETEALL;
        FSBenefits.DELETEALL;
        FSLoans.DELETEALL;
    end;

    var
        Worker: Code[20];
        WorkerName: Text;
        ServiceDays: Decimal;
        JoinDate: Date;
        TerminationDate: Date;
        Currency: Code[20];
        Calculated: Boolean;
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
        PayCycle: Code[20];
        FSEarningCodes: Record "FS - Earning Code";
        FSBenefits: Record "FS Benefits";
        FSLoans: Record "FS Loans";
}