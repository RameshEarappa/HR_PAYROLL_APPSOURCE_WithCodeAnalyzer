table 60030 "Work Calendar Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Calendar ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Alternative Calendar"; Code[20])
        {
            TableRelation = "Work Calendar Header";
            DataClassification = CustomerContent;
        }
        field(4; "From Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "To Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Work Time Template"; Code[20])
        {
            TableRelation = "Work Time Template";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Calendar ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        WorkCalendarDateLine.RESET;
        WorkCalendarDateLine.SETRANGE("Calendar ID", Rec."Calendar ID");
        WorkCalendarDateLine.DELETEALL;

        WorkCalendarDate.RESET;
        WorkCalendarDate.SETRANGE("Calendar ID", Rec."Calendar ID");
        WorkCalendarDate.DELETEALL
    end;

    var
        PeriodStartDate: Date;
        WorkCalendarDate: Record "Work Calendar Date";
        WorkCalendarDateLine: Record "Work Calendar Date Line";

    //[Scope('Internal')]
    procedure CalculateDate()
    var
        WorkTimeTemplate: Record "Work Time Template";
        Period: Record Date;
        WorkTimeLine: Record "Work Time Line";
        WorkCalendarDate: Record "Work Calendar Date";
        WorkCalendarDateLine: Record "Work Calendar Date Line";
        LineNo: Integer;
        WorkCalendarDate2: Record "Work Calendar Date";
    begin
        TESTFIELD("From Date");
        TESTFIELD("To Date");
        TESTFIELD("Work Time Template");

        WorkTimeTemplate.GET(Rec."Work Time Template");

        WorkCalendarDate2.RESET;
        WorkCalendarDate2.SETRANGE("Calendar ID", Rec."Calendar ID");
        if WorkCalendarDate2.FINDLAST then;

        WorkCalendarDate.RESET;
        WorkCalendarDate.SETRANGE("Calendar ID", Rec."Calendar ID");
        if WorkCalendarDate.FINDFIRST then
            if WorkCalendarDate."Trans Date" > "From Date" then
                ERROR('Calendar exists from %1 to %2 date. From date must be %3', WorkCalendarDate."Trans Date", WorkCalendarDate2."Trans Date", WorkCalendarDate2."Trans Date" + 1);

        WorkCalendarDate.RESET;
        WorkCalendarDate.SETRANGE("Calendar ID", Rec."Calendar ID");
        WorkCalendarDate.SETRANGE("Trans Date", "To Date");
        if WorkCalendarDate.FINDFIRST then
            ERROR('Work Calendar date lines exist for %1 To Date', "To Date");


        WorkCalendarDate.RESET;
        WorkCalendarDate.SETRANGE("Calendar ID", Rec."Calendar ID");
        if WorkCalendarDate.FINDLAST then
            if WorkCalendarDate."Trans Date" >= "To Date" then
                ERROR('Work Calendar date lines exist for %1 To Date', "To Date");

        CLEAR(PeriodStartDate);
        WorkCalendarDate.RESET;
        WorkCalendarDate.SETRANGE("Calendar ID", Rec."Calendar ID");
        if WorkCalendarDate.FINDLAST then
            PeriodStartDate := WorkCalendarDate."Trans Date" + 1
        else
            PeriodStartDate := "From Date";

        Period.RESET;
        Period.SETCURRENTKEY("Period Type", "Period Start");
        Period.SETRANGE("Period Type", Period."Period Type"::Date);
        Period.SETRANGE("Period Start", PeriodStartDate, "To Date");
        if Period.FINDSET then begin
            repeat
                WorkTimeLine.RESET;
                WorkTimeLine.SETRANGE("Work Time ID", Rec."Work Time Template");
                WorkTimeLine.SETRANGE(Weekday, Period."Period No.");
                if WorkTimeLine.FINDFIRST then begin
                    WorkCalendarDate.INIT;
                    WorkCalendarDate."Calendar ID" := Rec."Calendar ID";
                    WorkCalendarDate."Trans Date" := Period."Period Start";
                    WorkCalendarDate.Name := Period."Period Name";
                    case Period."Period No." of
                        1:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Monday Calculation Type";
                        2:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Tuesday Calculation Type";
                        3:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Wednesday Calculation Type";
                        4:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Thursday Calculation Type";
                        5:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Friday Calculation Type";
                        6:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Saturday Calculation Type";
                        7:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Sunday Calculation Type";
                    end;

                    WorkCalendarDate.INSERT;
                    CLEAR(LineNo);
                    repeat
                        LineNo += 10000;
                        WorkCalendarDateLine.INIT;
                        WorkCalendarDateLine."Calendar ID" := Rec."Calendar ID";
                        WorkCalendarDateLine."Trans Date" := Period."Period Start";
                        WorkCalendarDateLine."Line No." := LineNo;
                        WorkCalendarDateLine."From Time" := WorkTimeLine."From Time";
                        WorkCalendarDateLine."To Time" := WorkTimeLine."To Time";
                        WorkCalendarDateLine.Hours := WorkTimeLine."No. Of Hours";
                        WorkCalendarDateLine."Shift Split" := WorkTimeLine."Shift Split";
                        WorkCalendarDateLine.INSERT;
                    until WorkTimeLine.NEXT = 0;
                end
                else begin
                    WorkCalendarDate.INIT;
                    WorkCalendarDate."Calendar ID" := Rec."Calendar ID";
                    WorkCalendarDate."Trans Date" := Period."Period Start";
                    WorkCalendarDate.Name := Period."Period Name";
                    case Period."Period No." of
                        1:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Monday Calculation Type";
                        2:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Tuesday Calculation Type";
                        3:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Wednesday Calculation Type";
                        4:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Thursday Calculation Type";
                        5:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Friday Calculation Type";
                        6:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Saturday Calculation Type";
                        7:
                            WorkCalendarDate."Calculation Type" := WorkTimeTemplate."Sunday Calculation Type";
                    end;
                    WorkCalendarDate.INSERT;
                end;
            until Period.NEXT = 0;
        end;

    end;

    procedure UpdateCalculationType()
    var
        EmployeeWorkDate_GCC: Record EmployeeWorkDate_GCC;
        WorkCalendarDate: Record "Work Calendar Date";
        EmpLeaveReqHeader: Record "Leave Request Header";
        SysemGUID: Guid;
    begin
        WorkCalendarDate.RESET;
        WorkCalendarDate.SETRANGE("Calendar ID", Rec."Calendar ID");
        WorkCalendarDate.SETRANGE("Has Changed", true);
        if WorkCalendarDate.FINDSET then begin
            repeat
                EmployeeWorkDate_GCC.RESET;
                EmployeeWorkDate_GCC.SETRANGE("Trans Date", WorkCalendarDate."Trans Date");
                if EmployeeWorkDate_GCC.FINDFIRST then
                    repeat
                        EmployeeWorkDate_GCC."Calculation Type" := WorkCalendarDate."Calculation Type";
                        EmployeeWorkDate_GCC.Remarks := WorkCalendarDate.Remarks;
                        EmployeeWorkDate_GCC.MODIFY;
                        IF EmployeeWorkDate_GCC."Calculation Type" <> EmployeeWorkDate_GCC."Calculation Type"::"Working Day" THEN BEGIN
                            EmpLeaveReqHeader.RESET;
                            EmpLeaveReqHeader.SETRANGE("Personnel Number", EmployeeWorkDate_GCC."Employee Code");
                            EmpLeaveReqHeader.SETFILTER("Start Date", '>=%1', EmployeeWorkDate_GCC."Trans Date");
                            EmpLeaveReqHeader.SETFILTER("End Date", '<=%1', EmployeeWorkDate_GCC."Trans Date");
                            EmpLeaveReqHeader.SETRANGE(Posted, TRUE);
                            IF EmpLeaveReqHeader.FINDFIRST THEN BEGIN
                                SysemGUID := CreateGuid();
                                CreateLeaveAdjJournal(EmployeeWorkDate_GCC."Employee Code", EmployeeWorkDate_GCC."Trans Date", EmpLeaveReqHeader, SysemGUID);
                            END;
                        END;
                    until EmployeeWorkDate_GCC.NEXT = 0;
                WorkCalendarDate."Has Changed" := false;
                WorkCalendarDate.MODIFY;
            until WorkCalendarDate.NEXT = 0;
            PostLeaveAdjJournal();
        end;
    end;

    PROCEDURE CreateLeaveAdjJournal(VAR EMPID: Code[20]; LeaveDate: Date; var LeaveRequest: Record "Leave Request Header"; VAR SystemID: Guid)
    VAR
        NoSeriesManagement: Codeunit NoSeriesManagement;
        AdvPayrollSetup: Record "Advance Payroll Setup";
        LeaveAdjJournalHeader: Record "Leave Adj Journal header";
        LeaveAdjJournalLine: Record "Leave Adj Journal Lines";
        LeaveAdjJournalHeader2: Record "Leave Adj Journal header";
        Employee: Record Employee;
        PayrollPosition: Record "Payroll Position";
        EmpPositionAssignment: Record "Payroll Job Pos. Worker Assign";
        LeaveAdjJournalLine2: Record "Leave Adj Journal Lines";
        EmployeeLeaveType: Record "HCM Leave Types Wrkr";
    BEGIN
        EmployeeLeaveType.RESET;
        EmployeeLeaveType.SETRANGE(Worker, EMPID);
        EmployeeLeaveType.SETRANGE("Leave Type Id", LeaveRequest."Leave Type");
        IF EmployeeLeaveType.FindFirst() THEN;
        AdvPayrollSetup.GET;
        Employee.GET(EMPID);
        EmpPositionAssignment.RESET;
        EmpPositionAssignment.SETRANGE(Worker, EMPID);
        EmpPositionAssignment.SETRANGE("Emp. Earning Code Group", Employee."Earning Code Group");
        EmpPositionAssignment.SETRANGE("Is Primary Position", TRUE);
        IF PayrollPosition.GET(EmpPositionAssignment."Position ID") THEN BEGIN
            LeaveAdjJournalHeader2.RESET;
            LeaveAdjJournalHeader2.SETRANGE("Pay Cycle", PayrollPosition."Pay Cycle");
            LeaveAdjJournalHeader2.SETRANGE("Pay Period Start", CALCDATE('-CM', LeaveDate), CALCDATE('CM', LeaveDate));
            IF NOT LeaveAdjJournalHeader2.FINDFIRST THEN BEGIN
                LeaveAdjJournalHeader.INIT;
                LeaveAdjJournalHeader."Journal No." := NoSeriesManagement.GetNextNo(AdvPayrollSetup."Leave Adj No Series", 0D, TRUE);
                LeaveAdjJournalHeader.Description := 'Leave Adj Journal - ' + PayrollPosition."Pay Cycle";
                LeaveAdjJournalHeader.VALIDATE("Pay Cycle", PayrollPosition."Pay Cycle");
                LeaveAdjJournalHeader.VALIDATE("Pay Period Start", CALCDATE('-CM', LeaveDate));
                LeaveAdjJournalHeader.VALIDATE("Pay Period End", CALCDATE('CM', LeaveDate));
                LeaveAdjJournalHeader.VALIDATE("Create By", USERID);
                LeaveAdjJournalHeader.VALIDATE("Created DateTime", CURRENTDATETIME);
                IF LeaveAdjJournalHeader.INSERT THEN BEGIN
                    LeaveAdjJournalLine2.RESET;
                    LeaveAdjJournalLine2.SETRANGE("Journal No.", LeaveAdjJournalHeader."Journal No.");
                    IF LeaveAdjJournalLine.FindLast() THEN;
                    LeaveAdjJournalLine.INIT;
                    LeaveAdjJournalLine.VALIDATE("Journal No.", LeaveAdjJournalHeader."Journal No.");
                    LeaveAdjJournalLine.VALIDATE("Line No.", LeaveAdjJournalLine2."Line No." + 10000);
                    LeaveAdjJournalLine."Voucher Description" := LeaveAdjJournalHeader.Description;
                    LeaveAdjJournalLine.VALIDATE("Employee Code", EMPID);
                    LeaveAdjJournalLine.VALIDATE("Leave Type ID", LeaveRequest."Leave Type");
                    LeaveAdjJournalLine.VALIDATE("Accrual ID", EmployeeLeaveType."Accrual ID");
                    LeaveAdjJournalLine.VALIDATE("Calculation Units", 1);
                    LeaveAdjJournalLine.SystemId := SystemId;
                    LeaveAdjJournalLine."Leave Request ID" := LeaveRequest."Leave Request ID";
                    LeaveAdjJournalLine.INSERT;
                END;
            END
            ELSE BEGIN
                LeaveAdjJournalLine2.RESET;
                LeaveAdjJournalLine2.SETRANGE("Journal No.", LeaveAdjJournalHeader2."Journal No.");
                IF LeaveAdjJournalLine.FindLast() THEN;
                LeaveAdjJournalLine.INIT;
                LeaveAdjJournalLine.VALIDATE("Journal No.", LeaveAdjJournalHeader2."Journal No.");
                LeaveAdjJournalLine.VALIDATE("Line No.", LeaveAdjJournalLine2."Line No." + 10000);
                LeaveAdjJournalLine."Voucher Description" := LeaveAdjJournalHeader2.Description;
                LeaveAdjJournalLine.VALIDATE("Employee Code", EMPID);
                LeaveAdjJournalLine.VALIDATE("Leave Type ID", LeaveRequest."Leave Type");
                LeaveAdjJournalLine.VALIDATE("Accrual ID", EmployeeLeaveType."Accrual ID");
                LeaveAdjJournalLine.VALIDATE("Calculation Units", 1);
                LeaveAdjJournalLine.SystemId := SystemId;
                LeaveAdjJournalLine."Leave Request ID" := LeaveRequest."Leave Request ID";
                LeaveAdjJournalLine.INSERT;
            END;
        END;
    END;

    PROCEDURE PostLeaveAdjJournal()
    VAR
        SystemID: Guid;
        LeaveAdjJournalHeader: Record "Leave Adj Journal header";
        LeaveAdjJournalLine: Record "Leave Adj Journal Lines";
        AccrualCompCalc: Codeunit "Accrual Component Calculate";
    BEGIN
        LeaveAdjJournalHeader.RESET;
        LeaveAdjJournalHeader.SETRANGE(Posted, FALSE);
        IF LeaveAdjJournalHeader.FINDFIRST THEN BEGIN
            REPEAT
                LeaveAdjJournalLine.RESET;
                LeaveAdjJournalLine.SETRANGE("Journal No.", LeaveAdjJournalHeader."Journal No.");
                LeaveAdjJournalLine.SETFILTER(SystemId, '<>%1', SystemID);
                IF LeaveAdjJournalLine.FINDFIRST THEN
                    REPEAT
                        if LeaveAdjJournalHeader."Is Opening" then
                            AccrualCompCalc.ValidateOpeningBalanceLeaves(LeaveAdjJournalLine."Employee Code", LeaveAdjJournalLine."Leave Type ID", NORMALDATE(LeaveAdjJournalHeader."Pay Period Start"),
                                                                            NORMALDATE(LeaveAdjJournalHeader."Pay Period End"), LeaveAdjJournalLine."Earning Code Group",
                                                                            LeaveAdjJournalLine."Accrual ID", LeaveAdjJournalLine."Calculation Units")
                        else
                            AccrualCompCalc.ValidateAdjustmentLeaves(LeaveAdjJournalLine."Employee Code", LeaveAdjJournalLine."Leave Type ID", NORMALDATE(LeaveAdjJournalHeader."Pay Period Start"),
                                                                            NORMALDATE(LeaveAdjJournalHeader."Pay Period End"), LeaveAdjJournalLine."Earning Code Group",
                                                                            LeaveAdjJournalLine."Accrual ID", LeaveAdjJournalLine."Calculation Units");
                        AccrualCompCalc.OnAfterValidateAccrualLeaves(LeaveAdjJournalLine."Employee Code", NORMALDATE(LeaveAdjJournalHeader."Pay Period Start"), LeaveAdjJournalLine."Leave Type ID", LeaveAdjJournalLine."Earning Code Group");
                    UNTIL LeaveAdjJournalLine.NEXT = 0;
                LeaveAdjJournalHeader.Posted := true;
                LeaveAdjJournalHeader."Posted By" := USERID;
                LeaveAdjJournalHeader."Posted Date" := WORKDATE;
                LeaveAdjJournalHeader."Posted DateTime" := CURRENTDATETIME;
                LeaveAdjJournalHeader.MODIFY;
            UNTIL LeaveAdjJournalHeader.NEXT = 0;
        END;
    END;
}