report 60004 "Primary Position Assignment"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord();
            var
                LeaveTypes: Record "HCM Leave Types";
                PayrollJobPosWorkerAssign: Record "Payroll Job Pos. Worker Assign";
            begin
                EmployeeWorkDateRec.RESET;
                EmployeeWorkDateRec.SETCURRENTKEY("Employee Code", "Trans Date");
                EmployeeWorkDateRec.SETRANGE("Employee Code", EmpCode);
                if AssgnEndDate = 0D then
                    EmployeeWorkDateRec.SETFILTER("Trans Date", '%1..', EffectiveStartDate)
                else
                    EmployeeWorkDateRec.SETRANGE("Trans Date", EffectiveStartDate, EffectiveEndDate);
                EmployeeWorkDateRec.DELETEALL;

                // *****Insert Employee Earning Code grp

                CLEAR(Counter);
                Window.OPEN(
                        'Processing Data' +
                        '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                EmployeeEarningCodeGroup.RESET;
                EmployeeEarningCodeGroup.SETCURRENTKEY("Valid From");
                EmployeeEarningCodeGroup.SETRANGE("Employee Code", EmpCode);
                EmployeeEarningCodeGroup.SETRANGE(Type, EmployeeEarningCodeGroup.Type::Original);
                EmployeeEarningCodeGroup.SETRANGE("Valid To", 0D);
                if not EmployeeEarningCodeGroup.FINDFIRST then begin
                    EmployeeEarngCodeGrp.INIT;
                    EmployeeEarngCodeGrp.TRANSFERFIELDS(EarningCodeGroups);
                    EmployeeEarngCodeGrp."Employee Code" := EmpCode;
                    EmployeeEarngCodeGrp."Valid From" := EffectiveStartDate;
                    EmployeeEarngCodeGrp."Valid To" := EffectiveEndDate;
                    EmployeeEarngCodeGrp.Type := EmployeeEarngCodeGrp.Type::Original;
                    EmployeeEarngCodeGrp."Employee Pos. Assgn. Line No." := LineNo;
                    EmployeeEarngCodeGrp.Position := PositionCode;
                    EmployeeEarngCodeGrp.INSERT;
                    PositionWorkerAssignment2.RESET;
                    PositionWorkerAssignment2.SETRANGE(Worker, EmpCode);
                    PositionWorkerAssignment2.SETRANGE("Line No.", LineNo);
                    if PositionWorkerAssignment2.FINDFIRST then begin
                        PositionWorkerAssignment2."Position Assigned" := true;
                        PositionWorkerAssignment2."Is Primary Position" := true;
                        PositionWorkerAssignment2."Effective Start Date" := EffectiveStartDate;
                        PositionWorkerAssignment2."Effective End Date" := EffectiveEndDate;
                        PositionWorkerAssignment2.MODIFY;
                        PositionWorkerAssignmentArchive2.RESET;
                        PositionWorkerAssignmentArchive2.SETRANGE("Position ID", PositionCode);
                        PositionWorkerAssignmentArchive2.SETRANGE(Worker, EmpCode);
                        if PositionWorkerAssignmentArchive2.FINDLAST then;
                        PositionWorkerAssignmentArchive.INIT;
                        PositionWorkerAssignmentArchive.TRANSFERFIELDS(PositionWorkerAssignment2);
                        PositionWorkerAssignmentArchive."Line No." := PositionWorkerAssignmentArchive2."Line No." + 10000;
                        PositionWorkerAssignmentArchive.INSERT;
                    end;

                    Counter += 1;
                    Window.UPDATE(1, ROUND(Counter / TotalRecords * 10000, 1));
                end
                else begin
                    PositionEndDate := EffectiveStartDate - 1;
                    EmployeeEarningCodeGroup."Valid To" := EffectiveStartDate - 1;
                    EmployeeEarningCodeGroup.MODIFY;

                    PositionWorkerAssignment2.RESET;
                    PositionWorkerAssignment2.SETRANGE(Worker, EmpCode);
                    PositionWorkerAssignment2.SETRANGE("Line No.", EmployeeEarningCodeGroup."Employee Pos. Assgn. Line No.");
                    if PositionWorkerAssignment2.FINDFIRST then begin
                        PositionWorkerAssignment2."Position Assigned" := true;
                        PositionWorkerAssignment2."Is Primary Position" := false;
                        PositionWorkerAssignment2."Effective Start Date" := EmployeeEarningCodeGroup."Valid From";
                        PositionWorkerAssignment2."Effective End Date" := EffectiveStartDate - 1;
                        PositionWorkerAssignment2."Emp. Earning Code Group" := EmployeeEarningCodeGroup."Earning Code Group";
                        PositionWorkerAssignment2.MODIFY;
                    end;

                    PositionWorkerAssignment3.RESET;
                    PositionWorkerAssignment3.SETRANGE(Worker, EmpCode);
                    PositionWorkerAssignment3.SETRANGE("Line No.", LineNo);
                    if PositionWorkerAssignment3.FINDFIRST then begin
                        PositionWorkerAssignment3."Position Assigned" := false;
                        PositionWorkerAssignment3."Is Primary Position" := true;
                        PositionWorkerAssignment3."Effective Start Date" := EffectiveStartDate;
                        PositionWorkerAssignment3."Effective End Date" := EffectiveEndDate;
                        PositionWorkerAssignment3.MODIFY;
                        PositionWorkerAssignmentArchive2.RESET;
                        PositionWorkerAssignmentArchive2.SETRANGE(Worker, EmpCode);
                        PositionWorkerAssignmentArchive2.SETRANGE("Position ID", PositionCode);
                        if PositionWorkerAssignmentArchive2.FINDLAST then;
                        PositionWorkerAssignmentArchive.INIT;
                        PositionWorkerAssignmentArchive.TRANSFERFIELDS(PositionWorkerAssignment3);
                        PositionWorkerAssignmentArchive."Line No." := PositionWorkerAssignmentArchive2."Line No." + 10000;
                        PositionWorkerAssignmentArchive.INSERT;
                    end;

                    EmployeeEarngCodeGrp.INIT;
                    EmployeeEarngCodeGrp.TRANSFERFIELDS(EarningCodeGroups);
                    EmployeeEarngCodeGrp."Employee Code" := EmpCode;
                    EmployeeEarngCodeGrp."Valid From" := EffectiveStartDate;
                    EmployeeEarngCodeGrp."Valid To" := EffectiveEndDate;
                    EmployeeEarngCodeGrp.Type := EmployeeEarngCodeGrp.Type::Original;
                    EmployeeEarngCodeGrp."Employee Pos. Assgn. Line No." := LineNo;
                    EmployeeEarngCodeGrp.Position := PositionCode;
                    EmployeeEarngCodeGrp.INSERT;
                    Counter += 1;
                    Window.UPDATE(1, ROUND(Counter / TotalRecords * 10000, 1));
                end;


                // *****Insert Benefit,Leave, Loan,Earning Code
                InsertEarningGroupData(EarningCodeGroups."Earning Code Group", PositionEndDate, EarningCodeGroups."Grade Category");

                // *****InsertWork Calander
                WorkCalendarDate.RESET;
                WorkCalendarDate.SETRANGE("Calendar ID", EarningCodeGroups.Calendar);
                if EffectiveEndDate = 0D then
                    WorkCalendarDate.SETFILTER("Trans Date", '%1..', EffectiveStartDate)
                else
                    WorkCalendarDate.SETRANGE("Trans Date", EffectiveStartDate, EffectiveEndDate);
                if WorkCalendarDate.FINDSET then begin
                    TotalRecords += WorkCalendarDate.COUNT;
                    repeat
                        Counter += 1;
                        EmployeeWorkDateRec.RESET;
                        EmployeeWorkDateRec.INIT;
                        EmployeeWorkDateRec."Employee Code" := EmpCode;
                        EmployeeWorkDateRec."Trans Date" := WorkCalendarDate."Trans Date";
                        EmployeeWorkDateRec."Day Name" := WorkCalendarDate.Name;

                        Date_Rec.RESET;
                        Date_Rec.SETRANGE("Period Type", Date_Rec."Period Type"::Month);
                        Date_Rec.SETFILTER("Period Start", '<=%1', WorkCalendarDate."Trans Date");
                        Date_Rec.SETFILTER("Period End", '>=%1', WorkCalendarDate."Trans Date");
                        Date_Rec.FINDFIRST;
                        EmployeeWorkDateRec."Month Name" := Date_Rec."Period Name";

                        Date_Rec.RESET;
                        Date_Rec.SETRANGE("Period Type", Date_Rec."Period Type"::Week);
                        Date_Rec.SETFILTER("Period Start", '<=%1', WorkCalendarDate."Trans Date");
                        Date_Rec.SETFILTER("Period End", '>=%1', WorkCalendarDate."Trans Date");
                        Date_Rec.FINDFIRST;
                        EmployeeWorkDateRec."Week No." := Date_Rec."Period No.";

                        EmployeeWorkDateRec."Calander id" := WorkCalendarDate."Calendar ID";
                        EmployeeWorkDateRec."Original Calander id" := WorkCalendarDate."Calendar ID";
                        EmployeeWorkDateRec."Employee Earning Group" := EarningCodeGroups."Earning Code Group";
                        EmployeeWorkDateRec."Calculation Type" := WorkCalendarDate."Calculation Type";
                        LeaveTypes.RESET;
                        LeaveTypes.SETRANGE("Is System Defined", true);
                        if LeaveTypes.FINDFIRST then begin
                            if LeaveTypes.COUNT > 1 then
                                ERROR('There should be only one System Defined Leave Type ID.');
                            EmployeeWorkDateRec."First Half Leave Type" := LeaveTypes."Leave Type Id";
                            EmployeeWorkDateRec."Second Half Leave Type" := LeaveTypes."Leave Type Id";
                        end
                        else begin
                            ERROR('There is no Is System Defined Leave Type ID. Please define one');
                        end;
                        EmployeeWorkDateRec.INSERT;
                        Window.UPDATE(1, ROUND(Counter / TotalRecords * 10000, 1));
                    until WorkCalendarDate.NEXT = 0;


                end
                else
                    ERROR(CalnotDefined);



                PositionWorkerAssignment.RESET;
                PositionWorkerAssignment.SETRANGE(Worker, EmpCode);
                PositionWorkerAssignment.SETRANGE("Line No.", LineNo);
                if PositionWorkerAssignment.FINDFIRST then begin
                    PositionWorkerAssignment."Position Assigned" := true;
                    PositionWorkerAssignment."Is Primary Position" := true;
                    PositionWorkerAssignment."Effective Start Date" := EffectiveStartDate;
                    PositionWorkerAssignment."Effective End Date" := EffectiveEndDate;
                    PositionWorkerAssignment.MODIFY;
                    Counter += 1;
                    Window.UPDATE(1, ROUND(Counter / TotalRecords * 10000, 1));
                end;

                PayrollJobPosWorkerAssign.RESET;
                PayrollJobPosWorkerAssign.SETRANGE(Worker, EmpCode);
                if PayrollJobPosWorkerAssign.FINDFIRST then
                    repeat
                        if (PayrollJobPosWorkerAssign."Effective Start Date" <= WORKDATE) and (
                            (PayrollJobPosWorkerAssign."Effective End Date" >= WORKDATE) or (PayrollJobPosWorkerAssign."Effective End Date" = 0D)) then
                            PayrollJobPosWorkerAssign."Is Primary Position" := true
                        else
                            PayrollJobPosWorkerAssign."Is Primary Position" := false;
                        PayrollJobPosWorkerAssign.MODIFY;
                    until PayrollJobPosWorkerAssign.NEXT = 0;
            end;

            trigger OnPostDataItem();
            begin
                Window.CLOSE;
            end;

            trigger OnPreDataItem();
            begin
                TotalRecords := 50;
                PayrollPosition.GET(PositionCode);

                PayrollJobDetails.GET(PayrollPosition.Job);

                PayrollJobDetails.TESTFIELD("Earning Code Group");

                EarningCodeGroups.GET(PayrollJobDetails."Earning Code Group", PayrollJobDetails."Grade Category");
                EarningCodeGroups.TESTFIELD(Calendar);

                Employee.GET(EmpCode);
                if EffectiveStartDate <> 0D then
                    if (Employee."Joining Date" > EffectiveStartDate) then
                        ERROR('Start Date and End Date should not be before Employee Joining Date %1', Employee."Joining Date");

                if EffectiveEndDate <> 0D then
                    if (Employee."Joining Date" > EffectiveEndDate) then
                        ERROR('Start Date and End Date should not be before Employee Joining Date %1', Employee."Joining Date");


                PositionWorkerAssignment2.RESET;
                PositionWorkerAssignment2.SETRANGE("Position ID", PositionCode);
                PositionWorkerAssignment2.SETFILTER(Worker, '<>%1', Employee."No.");
                if PositionWorkerAssignment2.FINDFIRST then
                    ERROR('Position is assigned as Primary Position for the employee %1', PositionWorkerAssignment2.Worker);

                PositionWorkerAssignment2.RESET;
                PositionWorkerAssignment2.SETRANGE(Worker, Employee."No.");
                PositionWorkerAssignment2.SETFILTER("Effective Start Date", '>=%1', EffectiveStartDate);
                if PositionWorkerAssignment2.FINDFIRST then
                    ERROR('Position effective dates overlaps for the employee %1', Employee."No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(General)
                {
                    field("Employee Code"; EmpCode)
                    {
                        Editable = false;
                        ApplicationArea = all;
                    }
                    group(Assignment)
                    {
                        field("Start Date"; AssgnStartDate)
                        {
                            Editable = false;
                            ApplicationArea = all;
                        }
                        field("End Date"; AssgnEndDate)
                        {
                            Editable = false;
                            ApplicationArea = all;
                        }
                    }
                    field(Position; PositionCode)
                    {
                        Editable = false;
                        ApplicationArea = all;
                    }
                    field("Effective Start Date"; EffectiveStartDate)
                    {
                        ApplicationArea = all;
                    }
                    field("Effective End Date"; EffectiveEndDate)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        if EffectiveStartDate = 0D then
            ERROR(StartDateError);
    end;

    var
        EmpCode: Code[20];
        AssgnStartDate: Date;
        AssgnEndDate: Date;
        PositionCode: Code[20];
        StartDateError: Label '"Effective Start Date can not be blank. "';
        PositionWorkerAssignment: Record "Payroll Job Pos. Worker Assign";
        PayrollPosition: Record "Payroll Position";
        PayrollJobDetails: Record "Payroll Jobs";
        EarningCodeGroups: Record "Earning Code Groups";
        WorkCalendarDate: Record "Work Calendar Date";
        EmployeeWorkDateRec: Record EmployeeWorkDate_GCC;
        Date_Rec: Record Date;
        CalnotDefined: Label '"Work Calendar is not defined for given date "';
        EmployeeEarngCodeGrp: Record "Employee Earning Code Groups";
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        PositionEndDate: Date;
        Window: Dialog;
        Employee: Record Employee;
        Counter: Integer;
        TotalRecords: Integer;
        AccrualComponent: Record "Accrual Components";
        EffectiveStartDate: Date;
        EffectiveEndDate: Date;
        LineNo: Integer;
        PositionWorkerAssignment2: Record "Payroll Job Pos. Worker Assign";
        PositionWorkerAssignment3: Record "Payroll Job Pos. Worker Assign";
        PositionWorkerAssignmentArchive: Record "Payroll Pos. Worker Assn. Arch";
        PositionWorkerAssignmentArchive2: Record "Payroll Pos. Worker Assn. Arch";
        gEmployeeEarningCodeGroup: Code[20];

    procedure SetEmpPosDetails(Emp_p: Code[20]; PosStartDate: Date; PosEndDate: Date; Position: Code[20]; PosEffStartDate: Date; PosEffEndDate: Date; l_LineNo: Integer; l_EarningCodeGroup: Code[20]);
    begin
        EmpCode := Emp_p;
        AssgnStartDate := PosStartDate;
        AssgnEndDate := PosEndDate;
        PositionCode := Position;
        EffectiveStartDate := PosEffStartDate;
        EffectiveEndDate := PosEffEndDate;
        LineNo := l_LineNo;
        gEmployeeEarningCodeGroup := l_EarningCodeGroup;
    end;

    local procedure DeleteEarningGroupsData(ErngGrp_p: Code[20]);
    var
        EarningCodeGroups: Record "Earning Code Groups";
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
        HCMLeaveTypesWrkr: Record "HCM Leave Types Wrkr";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        HCMLoanTableGCCWrkr: Record "HCM Loan Table GCC Wrkr";
    begin
    end;

    local procedure InsertEarningGroupData(EarningGrp_p: Code[20]; l_PositionEndingDate: Date; l_GradeCategory: Code[50]);
    var
        EarningCodeGroups: Record "Earning Code Groups";
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
        HCMLeaveTypesWrkr: Record "HCM Leave Types Wrkr";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        HCMLoanTableGCCWrkr: Record "HCM Loan Table GCC Wrkr";
        PayrollEarningCodeErnGrp: Record "Payroll Earning Code ErnGrp";
        HCMLeaveTypesErnGrp: Record "HCM Leave Types ErnGrp";
        HCMLoanTableGCCErnGrp: Record "HCM Loan Table GCC ErnGrp";
        HCMBenefitErnGrp: Record "HCM Benefit ErnGrp";
        AccrualComponentCalculate: Codeunit "Accrual Component Calculate";
    begin
        EarningCodeGroups.GET(EarningGrp_p, l_GradeCategory);

        PayrollEarningCodeErnGrp.RESET;
        PayrollEarningCodeErnGrp.SETRANGE(PayrollEarningCodeErnGrp."Earning Code Group", EarningGrp_p);
        if PayrollEarningCodeErnGrp.FINDSET then
            repeat
                Counter += 1;
                Window.UPDATE(1, ROUND(Counter / TotalRecords * 10000, 1));
                PayrollEarningCodeWrkr.RESET;
                PayrollEarningCodeWrkr.SETRANGE(Worker, EmpCode);
                PayrollEarningCodeWrkr.SETRANGE("Earning Code Group", EarningGrp_p);
                PayrollEarningCodeWrkr.SETRANGE("Earning Code", PayrollEarningCodeErnGrp."Earning Code");
                if not PayrollEarningCodeWrkr.FINDFIRST then begin
                    PayrollEarningCodeWrkr.INIT;
                    PayrollEarningCodeErnGrp.CALCFIELDS("Formula For Atttendance");
                    PayrollEarningCodeWrkr.TRANSFERFIELDS(PayrollEarningCodeErnGrp);
                    PayrollEarningCodeWrkr.Worker := EmpCode;
                    PayrollEarningCodeWrkr."Earning Code Group" := EarningGrp_p;
                    PayrollEarningCodeWrkr."Package Calc Type" := PayrollEarningCodeWrkr."Package Calc Type"::Amount;
                    PayrollEarningCodeWrkr."Package Amount" := 0;
                    PayrollEarningCodeWrkr.INSERT;
                end
                else begin
                    PayrollEarningCodeErnGrp.CALCFIELDS("Formula For Atttendance");
                    PayrollEarningCodeWrkr.TRANSFERFIELDS(PayrollEarningCodeErnGrp);
                    PayrollEarningCodeWrkr."Earning Code Group" := EarningGrp_p;
                    PayrollEarningCodeWrkr.Worker := EmpCode;
                    PayrollEarningCodeWrkr."Package Calc Type" := PayrollEarningCodeWrkr."Package Calc Type"::Amount;
                    PayrollEarningCodeWrkr."Package Amount" := 0;
                    PayrollEarningCodeWrkr.MODIFY;
                end;
            until PayrollEarningCodeErnGrp.NEXT = 0;

        HCMLeaveTypesWrkr.RESET;
        HCMLeaveTypesWrkr.SETRANGE(Worker, EmpCode);
        HCMLeaveTypesWrkr.SETRANGE("Earning Code Group", EarningGrp_p);
        HCMLeaveTypesWrkr.DELETEALL;

        HCMLeaveTypesErnGrp.RESET;
        HCMLeaveTypesErnGrp.SETRANGE(HCMLeaveTypesErnGrp."Earning Code Group", EarningGrp_p);
        HCMLeaveTypesErnGrp.SETRANGE(Active, true);
        if HCMLeaveTypesErnGrp.FINDSET then
            repeat
                Counter += 1;
                Window.UPDATE(1, ROUND(Counter / TotalRecords * 10000, 1));
                HCMLeaveTypesWrkr.RESET;
                HCMLeaveTypesWrkr.SETRANGE(Worker, EmpCode);
                HCMLeaveTypesWrkr.SETRANGE("Leave Type Id", HCMLeaveTypesErnGrp."Leave Type Id");
                HCMLeaveTypesWrkr.SETRANGE("Earning Code Group", EarningGrp_p);
                if not HCMLeaveTypesWrkr.FINDFIRST then begin
                    HCMLeaveTypesWrkr.INIT;
                    HCMLeaveTypesWrkr.TRANSFERFIELDS(HCMLeaveTypesErnGrp);
                    HCMLeaveTypesWrkr.Worker := EmpCode;
                    HCMLeaveTypesWrkr."Earning Code Group" := EarningGrp_p;
                    HCMLeaveTypesWrkr.INSERT;
                    if HCMLeaveTypesErnGrp."Accrual ID" <> '' then
                        AccrualComponentCalculate.CalculateAccruals(EmpCode, EarningGrp_p, HCMLeaveTypesErnGrp."Accrual ID", HCMLeaveTypesErnGrp."Leave Type Id", EffectiveStartDate, EffectiveEndDate);
                end;
            until HCMLeaveTypesErnGrp.NEXT = 0;

        HCMLoanTableGCCErnGrp.RESET;
        HCMLoanTableGCCErnGrp.SETRANGE("Earning Code Group", EarningGrp_p);
        if HCMLoanTableGCCErnGrp.FINDSET then
            repeat
                Counter += 1;
                Window.UPDATE(1, ROUND(Counter / TotalRecords * 10000, 1));
                HCMLoanTableGCCWrkr.RESET;
                HCMLoanTableGCCWrkr.SETRANGE("Earning Code Group", EarningGrp_p);
                HCMLoanTableGCCWrkr.SETRANGE("Loan Code", HCMLoanTableGCCErnGrp."Loan Code");
                HCMLoanTableGCCWrkr.SETRANGE(Worker, EmpCode);
                if not HCMLoanTableGCCWrkr.FINDFIRST then begin
                    HCMLoanTableGCCWrkr.INIT;
                    HCMLoanTableGCCWrkr.TRANSFERFIELDS(HCMLoanTableGCCErnGrp);
                    HCMLoanTableGCCWrkr."Earning Code Group" := EarningGrp_p;
                    HCMLoanTableGCCWrkr.Worker := EmpCode;
                    HCMLoanTableGCCWrkr.INSERT;
                end
                else begin
                    HCMLoanTableGCCWrkr.RENAME(HCMLoanTableGCCErnGrp."Loan Code", EarningGrp_p, EmpCode);
                    HCMLoanTableGCCWrkr."Loan Description" := HCMLoanTableGCCErnGrp."Loan Description";
                    HCMLoanTableGCCWrkr.MODIFY;
                end;
            until HCMLoanTableGCCErnGrp.NEXT = 0;

        HCMBenefitErnGrp.RESET;
        HCMBenefitErnGrp.SETRANGE(HCMBenefitErnGrp."Earning Code Group", EarningGrp_p);
        if HCMBenefitErnGrp.FINDSET then
            repeat
                Counter += 1;
                Window.UPDATE(1, ROUND(Counter / TotalRecords * 10000, 1));
                HCMBenefitWrkr.RESET;
                HCMBenefitWrkr.SETRANGE(Worker, EmpCode);
                HCMBenefitWrkr.SETRANGE("Benefit Id", HCMBenefitErnGrp."Benefit Id");
                HCMBenefitWrkr.SETRANGE("Earning Code Group", HCMBenefitErnGrp."Earning Code Group");
                if not HCMBenefitWrkr.FINDFIRST then begin
                    HCMBenefitWrkr.INIT;
                    HCMBenefitErnGrp.CALCFIELDS("Unit Calc Formula");
                    HCMBenefitErnGrp.CALCFIELDS("Amount Calc Formula");
                    HCMBenefitErnGrp.CALCFIELDS("Encashment Formula");
                    HCMBenefitWrkr.TRANSFERFIELDS(HCMBenefitErnGrp);
                    HCMBenefitWrkr.Worker := EmpCode;
                    HCMBenefitWrkr."Earning Code Group" := EarningGrp_p;
                    HCMBenefitWrkr.INSERT;
                end
                else begin
                    HCMBenefitErnGrp.CALCFIELDS("Unit Calc Formula");
                    HCMBenefitErnGrp.CALCFIELDS("Amount Calc Formula");
                    HCMBenefitErnGrp.CALCFIELDS("Encashment Formula");
                    HCMBenefitWrkr.TRANSFERFIELDS(HCMBenefitErnGrp);
                    HCMBenefitWrkr.Worker := EmpCode;
                    HCMBenefitWrkr."Earning Code Group" := EarningGrp_p;
                    HCMBenefitWrkr.MODIFY;
                end;
            until HCMBenefitErnGrp.NEXT = 0;
    end;
}