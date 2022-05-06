report 60013 "Employee Termination"
{
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(Worker; Worker)
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field("Worker Name"; WorkerName)
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Notice Period Start"; NoticePeriodStartDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Notice Period End"; NoticePeriodEndDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Termination Reason"; TerminationReason)
                    {
                        ShowMandatory = true;
                        TableRelation = "Seperation Master";
                        ApplicationArea = All;
                    }
                    field("Unsatisfactory Grade"; NoofYearswithUnsatisfactoryGrade)
                    {
                        Caption = 'No of Years with Unsatisfactory Grade';
                        Visible = false;
                        ApplicationArea = All;
                    }
                    field("Termination Date"; TerminationDate)
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if (TerminationDate < NoticePeriodStartDate) or (TerminationDate < NoticePeriodEndDate) then
                                ERROR('Seperation Date cannot be before Notice period Dates');
                        end;
                    }
                    field("Hold Payment"; HoldPayment)
                    {
                        ApplicationArea = All;
                        trigger OnValidate();
                        begin
                            if HoldPayment = HoldPayment::"Hold Payroll" then
                                EditHoldPayrollFrom := true
                            else
                                EditHoldPayrollFrom := false;
                        end;
                    }
                    field("Pay Cycle"; PayCycleID)
                    {
                        Editable = EditHoldPayrollFrom;
                        ApplicationArea = All;
                        TableRelation = "Pay Cycles";
                    }
                    field("Hold Payment From"; HoldPayrollFrom)
                    {
                        Editable = EditHoldPayrollFrom;
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if PayCycleID = '' then
                                ERROR('Please select Pay Cycle');
                            PayPeriods.FILTERGROUP(2);
                            PayPeriods.RESET;
                            PayPeriods.SETRANGE("Pay Cycle", PayCycleID);
                            PayPeriods.FILTERGROUP(0);

                            if PAGE.RUNMODAL(60071, PayPeriods) = ACTION::LookupOK then begin
                                HoldPayrollFrom := PayPeriods."Pay Cycle" + ':' + FORMAT(PayPeriods."Period Start Date") + ' ' + FORMAT(NORMALDATE(PayPeriods."Period End Date"));
                                PayPeriodRecID := PayPeriods."Line No.";
                            end;
                        end;

                        trigger OnValidate();
                        begin
                            if PayPeriodRecID = 0 then
                                ERROR('Select Valid Payperiods');
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage();
        begin
            if HoldPayment = HoldPayment::"Hold Payroll" then
                EditHoldPayrollFrom := true
            else
                EditHoldPayrollFrom := false;
        end;

        trigger OnQueryClosePage(CloseAction: Action): Boolean;
        begin
            if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
                if TerminationDate = 0D then
                    ERROR('Please select Termination Date');
                if (NoticePeriodStartDate = 0D) or (NoticePeriodEndDate = 0D) then
                    ERROR('Please select Notice Period Date');
                if TerminationReason = '' then
                    ERROR('Please select Termination Reason');
                if HoldPayment = HoldPayment::"Hold Payroll" then
                    if HoldPayrollFrom = '' then
                        ERROR('Select Hold Payment Period');
            end;
        end;
    }

    trigger OnPostReport();
    begin
        RecEmployee.RESET;
        RecEmployee.SETRANGE("No.", EmpCode);
        if RecEmployee.FINDFIRST then begin
            SeperationMaster.RESET;
            SeperationMaster.SETRANGE("Seperation Code", TerminationReason);
            SeperationMaster.FINDFIRST;
            LeaveTypes.RESET;
            LeaveTypes.SETRANGE("Termination Leave", true);
            LeaveTypes.FINDFIRST;

            EmployeeWorkDateRec.RESET;
            EmployeeWorkDateRec.SETRANGE("Employee Code", RecEmployee."No.");
            EmployeeWorkDateRec.SETRANGE("Trans Date", TerminationDate + 1, 99991231D);
            if EmployeeWorkDateRec.FINDFIRST then
                repeat
                    EmployeeWorkDateRec."First Half Leave Type" := LeaveTypes."Leave Type Id";
                    EmployeeWorkDateRec."Second Half Leave Type" := LeaveTypes."Leave Type Id";
                    EmployeeWorkDateRec.MODIFY;
                until EmployeeWorkDateRec.NEXT = 0;
            RecEmployee."Seperation Reason" := TerminationReason;
            RecEmployee."Seperation Reason Code" := SeperationMaster."Sepration Reason Code";
            RecEmployee."Employment End Date" := TerminationDate;
            RecEmployee."Termination Date" := TerminationDate;
            RecEmployee."Unsatisfactory Grade" := NoofYearswithUnsatisfactoryGrade;
            if HoldPayment = HoldPayment::"Hold Payroll" then begin
                PayPeriods.RESET;
                PayPeriods.SETRANGE("Pay Cycle", PayCycleID);
                PayPeriods.SETRANGE("Line No.", PayPeriodRecID);
                PayPeriods.FINDFIRST;
                RecEmployee."Hold Payment from Date" := PayPeriods."Period Start Date";
            end;
            RecEmployee.Status := RecEmployee.Status::Terminated;
            RecEmployee.MODIFY;
        end;
    end;

    trigger OnPreReport();
    var
        NoticePeriodStartDate: Date;
        NoticePeriodEndDate: Date;
        Worker: Code[20];
        WorkerName: Text;
        TerminationReason: Code[20];
        TerminationDate: Date;
        HoldPayment: Option "None","Hold Payment";
        HoldPayrollFrom: Text;
        PayPeriodStartDate: Date;
        PayPeriodEndDate: Date;
        PayPeriodRecID: Integer;
    begin
    end;

    var
        EmpCode: Code[20];
        RecEmployee: Record Employee;
        Worker: Code[20];
        WorkerName: Text;
        NoticePeriodStartDate: Date;
        NoticePeriodEndDate: Date;
        TerminationReason: Code[20];
        TerminationDate: Date;
        HoldPayment: Option "None","Hold Payroll";
        HoldPayrollFrom: Text;
        PayPeriodStartDate: Date;
        PayPeriodEndDate: Date;
        PayPeriodRecID: Integer;
        [InDataSet]
        EditHoldPayrollFrom: Boolean;
        PayCycle: Record "Pay Cycles";
        PayPeriods: Record "Pay Periods";
        PayCycleID: Code[20];
        NoofYearswithUnsatisfactoryGrade: Integer;
        SeperationMaster: Record "Seperation Master";
        LeaveTypes: Record "HCM Leave Types";
        EmployeeWorkDateRec: Record EmployeeWorkDate_GCC;

    procedure SetValues(l_EmpCode: Code[20]);
    begin
        EmpCode := l_EmpCode;
        Worker := l_EmpCode;
        RecEmployee.GET(l_EmpCode);
        WorkerName := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
    end;
}