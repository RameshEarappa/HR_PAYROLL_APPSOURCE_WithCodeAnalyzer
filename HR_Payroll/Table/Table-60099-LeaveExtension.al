table 60099 "Leave Extension"
{
    Caption = 'Leave Extension';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Leave Request ID"; Code[20])
        {
            Caption = 'Leave Request ID';
            DataClassification = CustomerContent;
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Personnel Number"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Employee.GET("Personnel Number") then
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Last Name"
                else
                    "Employee Name" := '';
                if "Personnel Number" <> '' then begin
                    EmplErngCodegrp.RESET;
                    EmplErngCodegrp.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                    EmplErngCodegrp.SETRANGE("Employee Code", "Personnel Number");
                    EmplErngCodegrp.SETFILTER("Valid From", '<=%1', WORKDATE);
                    EmplErngCodegrp.SETFILTER("Valid To", '>%1|%2', WORKDATE, 0D);
                    if EmplErngCodegrp.FINDFIRST then
                        "Earning Code Group" := EmplErngCodegrp."Earning Code Group"
                    else
                        ERROR('There is no active Employee inthis period');
                end;
            end;
        }
        field(6; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Leave Type"; Code[20])
        {
            TableRelation = "HCM Leave Types Wrkr"."Leave Type Id" WHERE(Worker = FIELD("Personnel Number"),
                                                                          "Earning Code Group" = FIELD("Earning Code Group"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckStatus;
                if "Leave Type" <> '' then begin
                    if ("Start Date" <> 0D) and ("End Date" <> 0D) then begin
                        Employee.GET("Personnel Number");
                        LeaveRequestHeader.RESET;
                        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
                        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
                        LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "Start Date");
                        LeaveRequestHeader.SETFILTER("End Date", '>=%1', "End Date");
                        if LeaveRequestHeader.FINDFIRST then begin
                            ERROR('Leave Period Overlaps with other leave request');
                        end;
                    end;
                    LeaveType.RESET;
                    LeaveType.SETRANGE(LeaveType.Worker, Rec."Personnel Number");
                    LeaveType.SETRANGE("Leave Type Id", Rec."Leave Type");
                    LeaveType.SETRANGE("Earning Code Group", Rec."Earning Code Group");
                    if LeaveType.FINDFIRST then begin
                        if (LeaveType."Religion ID" <> Employee."Employee Religion") and (LeaveType."Religion ID" <> '') then
                            ERROR('You cannot select Leave Type %1 current employee with religion %2', "Leave Type", Employee."Employee Religion");
                        "Short Name" := LeaveType."Short Name";
                        Description := LeaveType.Description;
                    end;
                end
                else begin
                    CLEAR("Short Name");
                    CLEAR(Description);
                end;
            end;
        }
        field(8; "Short Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckStatus;
                if "Start Date" <> 0D then begin
                    if "End Date" <> 0D then
                        if "Start Date" > "End Date" then
                            ERROR('Start Date Should not be after End Date ');

                    Employee.GET("Personnel Number");
                    Employee.TESTFIELD("Joining Date");
                    if Employee."Joining Date" > Rec."Start Date" then
                        ERROR('You cannot apply leaves before joining date %1', Employee."Joining Date");

                    if "End Date" <> 0D then
                        ValidateEndDate;
                end;

                LeaveRequestHeader.RESET;
                LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
                LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
                LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "Start Date");
                LeaveRequestHeader.SETFILTER("End Date", '>=%1', "Start Date");
                if LeaveRequestHeader.FINDFIRST then begin
                    ERROR('Leave Period Overlaps with other leave request');
                end;
            end;
        }
        field(11; "Alternative Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Leave Start Day Type"; Option)
        {
            OptionCaption = 'Full Day,First Half,Second Half';
            OptionMembers = "Full Day","First Half","Second Half";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckStatus;
                ValidateEndDate;
            end;
        }
        field(13; "End Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckStatus;
                ValidateEndDate;
            end;
        }
        field(14; "Alternative End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Leave End Day Type"; Option)
        {
            OptionCaption = 'Full Day,First Half';
            OptionMembers = "Full Day","First Half";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckStatus;
                ValidateEndDate;
            end;
        }
        field(16; LTA; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Leave Days"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(18; "Leave Remarks"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(19; "Cover Resource"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(20; "Submission Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(21; "Workflow Status"; Option)
        {
            Enabled = false;
            OptionCaption = 'Not Submitted,Submitted,Approved,Cancelled,Rejected,Open,Pending For Approval';
            OptionMembers = "Not Submitted",Submitted,Approved,Cancelled,Rejected,Open,"Pending For Approval";
            DataClassification = CustomerContent;
        }
        field(22; Posted; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Leave Cancelled"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Leave Planner ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(25; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(26; "Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Resumption Type"; Option)
        {
            OptionCaption = ' ,On Time Resumption,Late Resumption,Early Resumption';
            OptionMembers = " ","On Time Resumption","Late Resumption","Early Resumption";
            DataClassification = CustomerContent;
        }
        field(28; "Resumption Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(29; "Net Leave Days"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Created Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Earning Code Group"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Leave Request ID", "Line No")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        CheckStatus;
    end;

    trigger OnModify()
    begin
        CheckStatus;
        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Date Time" := CURRENTDATETIME;
    end;

    var
        Employee: Record Employee;
        LeaveType: Record "HCM Leave Types Wrkr";
        EmployeeWorkDate_GCC: Record EmployeeWorkDate_GCC;
        WorkCalendarDate: Record "Work Calendar Date";
        EmployeeEarngCodeGrp: Record "Employee Earning Code Groups";
        EmplErngCodegrp: Record "Employee Earning Code Groups";
        LeaveRequestHeader: Record "Leave Request Header";
        EmployeeInterimAccruals: Record "Employee Interim Accurals";
        BenefitAdjustJournalHeader: Record "Benefit Adjmt. Journal header";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        AdvancePayrollSetup: Record "Advance Payroll Setup";
        DutyResume: Record "Duty Resumption";
        PublicHolidays: Integer;
        WeeklyOffDays: Integer;
        NoSeriesMngmnt: Codeunit NoSeriesManagement;

    procedure ValidateEndDate()
    begin
        if "End Date" <> 0D then
            TESTFIELD("Start Date");

        if ("End Date" = "Start Date") and (("Leave Start Day Type" = "Leave Start Day Type"::"First Half") or
                                            ("Leave Start Day Type" = "Leave Start Day Type"::"Second Half")) then
            if "End Date" < "Start Date" then
                ERROR('End Date should not be before Start Date');

        if "End Date" < "Start Date" then
            ERROR('End Date should not be before Start Date');

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "Start Date");
        LeaveRequestHeader.SETFILTER("End Date", '>=%1', "Start Date");
        if LeaveRequestHeader.FINDFIRST then begin
            ERROR('Leave Period Overlaps with other leave request');
        end;

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "End Date");
        LeaveRequestHeader.SETFILTER("End Date", '>=%1', "End Date");
        if LeaveRequestHeader.FINDFIRST then
            ERROR('Leave Period Overlaps with other leave request');

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETRANGE("Start Date", "Start Date");
        if LeaveRequestHeader.FINDFIRST then
            ERROR('Leave Period Overlaps with other leave request');

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETRANGE("End Date", "End Date");
        if LeaveRequestHeader.FINDFIRST then
            ERROR('Leave Period Overlaps with other leave request');

        LeaveType.RESET;
        LeaveType.SETRANGE(LeaveType.Worker, Rec."Personnel Number");
        LeaveType.SETRANGE("Leave Type Id", Rec."Leave Type");
        LeaveType.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if LeaveType.FINDFIRST then begin
            if not LeaveType."Allow Half Day" then
                if (Rec."Leave Start Day Type" = Rec."Leave Start Day Type"::"First Half") or
                   (Rec."Leave Start Day Type" = Rec."Leave Start Day Type"::"Second Half") or
                   (Rec."Leave End Day Type" = Rec."Leave End Day Type"::"First Half") then
                    ERROR('You are not allowed to select half day leave');
        end;
        if xRec."Leave Start Day Type" <> Rec."Leave Start Day Type" then
            "End Date" := 0D;
        "Leave Days" := 0;
        if "End Date" <> 0D then begin
            case "Leave Start Day Type" of
                "Leave Start Day Type"::"Full Day":
                    begin
                        case "Leave End Day Type" of
                            "Leave End Day Type"::"Full Day":
                                begin
                                    "Leave Days" := ("End Date" - "Start Date") + 1;
                                end;
                            "Leave End Day Type"::"First Half":
                                begin
                                    if "End Date" = "Start Date" then
                                        ERROR('Select Correct Leave End Day Type');
                                    "Leave Days" := ("End Date" - "Start Date") + 0.5;
                                end;
                        end;
                    end;
                "Leave Start Day Type"::"First Half":
                    begin
                        TESTFIELD("Start Date", "End Date");
                        TESTFIELD("Leave End Day Type", "Leave End Day Type"::"First Half");
                        case "Leave End Day Type" of
                            "Leave End Day Type"::"Full Day":
                                begin
                                    if "End Date" = "Start Date" then
                                        ERROR('Select Correct Leave End Day Type');
                                    "Leave Days" := ("End Date" - "Start Date") + 0.5;
                                end;
                            "Leave End Day Type"::"First Half":
                                begin
                                    "Leave Days" := ("End Date" - "Start Date") + 0.5;
                                end;
                        end;
                    end;
                "Leave Start Day Type"::"Second Half":
                    begin
                        case "Leave End Day Type" of
                            "Leave End Day Type"::"Full Day":
                                begin
                                    if "End Date" = "Start Date" then
                                        "Leave Days" := 0.5
                                    else
                                        "Leave Days" := ("End Date" - "Start Date") + 0.5;
                                end;
                            "Leave End Day Type"::"First Half":
                                begin
                                    if "End Date" = "Start Date" then
                                        ERROR('Select Correct Leave End Day Type');
                                    "Leave Days" := 0.5 + (("End Date" - "Start Date") - 1) + 0.5;
                                end;
                        end;
                    end;
            end;
        end;

        Employee.GET("Personnel Number");
        LeaveType.RESET;
        LeaveType.SETRANGE(LeaveType.Worker, Rec."Personnel Number");
        LeaveType.SETRANGE("Leave Type Id", Rec."Leave Type");
        LeaveType.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if LeaveType.FINDFIRST then;
        if LeaveType."Exc Public Holidays" then begin
            EmployeeEarngCodeGrp.RESET;
            EmployeeEarngCodeGrp.SETCURRENTKEY("Valid From");
            EmployeeEarngCodeGrp.SETRANGE("Employee Code", "Personnel Number");
            if EmployeeEarngCodeGrp.FINDLAST then begin
                WorkCalendarDate.RESET;
                WorkCalendarDate.SETRANGE("Calendar ID", EmployeeEarngCodeGrp.Calander);
                WorkCalendarDate.SETRANGE("Trans Date", "Start Date", "End Date");
                WorkCalendarDate.SETRANGE("Calculation Type", WorkCalendarDate."Calculation Type"::"Public Holiday");
                if WorkCalendarDate.FINDFIRST then
                    PublicHolidays := WorkCalendarDate.COUNT;
            end;
        end;

        if LeaveType."Exc Week Offs" then begin
            EmployeeEarngCodeGrp.RESET;
            EmployeeEarngCodeGrp.SETCURRENTKEY("Valid From");
            EmployeeEarngCodeGrp.SETRANGE("Employee Code", "Personnel Number");
            if EmployeeEarngCodeGrp.FINDLAST then begin
                WorkCalendarDate.RESET;
                WorkCalendarDate.SETRANGE("Calendar ID", EmployeeEarngCodeGrp.Calander);
                WorkCalendarDate.SETRANGE("Trans Date", "Start Date", "End Date");
                WorkCalendarDate.SETRANGE("Calculation Type", WorkCalendarDate."Calculation Type"::"Weekly Off");
                if WorkCalendarDate.FINDFIRST then
                    WeeklyOffDays := WorkCalendarDate.COUNT;
            end;
        end;

        "Leave Days" := "Leave Days" - (PublicHolidays + WeeklyOffDays);
    end;

    procedure CheckStatus()
    begin
        if DutyResume.GET("Leave Request ID") then
            DutyResume.TESTFIELD("Workflow Status", DutyResume."Workflow Status"::Open);
    end;

    procedure SubmitLeave(var LeaveExtLine: Record "Leave Extension")
    var
        PayJobPosWorker: Record "Payroll Job Pos. Worker Assign";
        PayPosition: Record "Payroll Position";
        PayCycle: Record "Pay Cycles";
        PayPeriods: Record "Pay Periods";
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
    begin
        TESTFIELD("Leave Type");

        Employee.GET("Personnel Number");

        LeaveType.RESET;
        LeaveType.SETRANGE(LeaveType.Worker, Rec."Personnel Number");
        LeaveType.SETRANGE("Leave Type Id", Rec."Leave Type");
        LeaveType.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if LeaveType.FINDFIRST then;

        LeaveType.TESTFIELD(Active);

        if not (LeaveType.Gender = LeaveType.Gender::" ") then
            if LeaveType.Gender <> Employee.Gender then
                ERROR('This leave is for Gender %1', LeaveType.Gender);

        if LeaveType.Nationality <> '' then
            if LeaveType.Nationality <> Employee.Nationality then
                ERROR('This leave %1 is only for %2 Nationality', "Leave Type", LeaveType.Nationality);

        if LeaveType."Religion ID" <> '' then
            if LeaveType."Religion ID" <> Employee."Employee Religion" then
                ERROR('This leave %1 can be applied only by the religion %2', "Leave Type", LeaveType."Religion ID");

        if LeaveType."Accrual ID" <> '' then begin
            EmployeeInterimAccruals.RESET;
            EmployeeInterimAccruals.SETRANGE("Worker ID", Rec."Personnel Number");
            EmployeeInterimAccruals.SETRANGE("Start Date", CALCDATE('-CM', Rec."Start Date"));
            if not EmployeeInterimAccruals.FINDFIRST then
                ERROR('There is no Employee Interim Accruals defined for this employee');
        end;

        Employee.TESTFIELD("Joining Date");

        LeaveType.TESTFIELD(Active, true);
        if Employee."Termination Date" <> 0D then begin
            if (Employee."Termination Date" < "Start Date") or (Employee."Termination Date" <= "End Date") then
                ERROR('You Cannot apply leave after employees termination');
        end;

        if Employee."Joining Date" > Rec."Start Date" then
            ERROR('You cannot apply leaves before joining date %1', Employee."Joining Date");

        if LeaveType."Leave Avail Basis" = LeaveType."Leave Avail Basis"::"Probation End Date" then
            if Rec."Start Date" < Employee."Probation Period" then
                ERROR('You cannot apply leave before probation period ends');

        if LeaveType."Leave Avail Basis" = LeaveType."Leave Avail Basis"::"Confirmation Date" then
            if Rec."Start Date" < Employee."Employment Date" then
                ERROR('You cannot apply leave before Confirmation Date');

        if LeaveType."Leave Avail Basis" = LeaveType."Leave Avail Basis"::"Joining Date" then
            if Rec."Start Date" < Employee."Joining Date" then
                ERROR('You cannot apply leave before Joining Date');

        if LeaveType."Probation Entitlement Days" <> 0 then
            if Rec."Start Date" < Employee."Probation Period" then
                if "Leave Days" < LeaveType."Probation Entitlement Days" then
                    ERROR('YOu cannot apply more than %1 days in Probation period', LeaveType."Probation Entitlement Days");

        if LeaveType."Accrual ID" <> '' then begin
            EmployeeInterimAccruals.SETRANGE("Worker ID", Rec."Personnel Number");
            EmployeeInterimAccruals.SETRANGE("Start Date", CALCDATE('-CM', Rec."Start Date"));
            if not EmployeeInterimAccruals.FINDFIRST then
                ERROR('There is no Employee Interim Accruals defined for this employee');
        end;
        Employee.GET(Rec."Personnel Number");
        "Submission Date" := TODAY;

        PayJobPosWorker.RESET;
        PayJobPosWorker.SETRANGE(Worker, "Personnel Number");
        PayJobPosWorker.SETFILTER("Effective Start Date", '<=%1', TODAY);
        PayJobPosWorker.SETFILTER("Effective End Date", '>=%1|%2', TODAY, 0D);
        if PayJobPosWorker.FINDFIRST then begin
            PayPosition.GET(PayJobPosWorker."Position ID");
            PayPosition.TESTFIELD("Pay Cycle");
            PayCycle.GET(PayPosition."Pay Cycle");
            PayPeriods.RESET;
            PayPeriods.SETRANGE("Pay Cycle", PayCycle."Pay Cycle");
            PayPeriods.SETFILTER("Period Start Date", '<=%', "Start Date");
            PayPeriods.SETFILTER("Period End Date", '>=%1|%2', "End Date");
            PayPeriods.SETRANGE(Status, PayPeriods.Status::Closed);
            if PayPeriods.FINDFIRST then
                ERROR('Pay period is closed for the selected leave request dates');
        end
        else begin
            ERROR('There is no active position assigned for the employee %1 as of date', "Personnel Number");
        end;

        Employee.TESTFIELD("Joining Date");
        TESTFIELD("Submission Date");
        LeaveType.TESTFIELD(Active, true);
        if Employee."Termination Date" <> 0D then begin
            if (Employee."Termination Date" < "Start Date") or (Employee."Termination Date" <= "End Date") then
                ERROR('You Cannot apply leave after employees termination');
        end;

        if Employee."Joining Date" > Rec."Start Date" then
            ERROR('You cannot apply leaves before joining date %1', Employee."Joining Date");

        if LeaveType.Active then begin
            if LeaveType."Max Times" <> 0 then
                ValidateMaxTime(Employee, LeaveType);

            if LeaveType."Min Service Days" <> 0 then
                ValidateMinServiceDays(Employee, LeaveType);

            if LeaveType."Min Days Before Req" <> 0 then
                ValidateMinDaysBeforeReq(Employee, LeaveType);

            if LeaveType."Max Occurance" <> 0 then
                ValidateMaxOccurance(Employee, LeaveType);

            if LeaveType."Max Days Avail" <> 0 then
                if Rec."Leave Days" > LeaveType."Max Days Avail" then
                    ERROR('You cannot apply more than %1 Leaves', LeaveType."Max Days Avail");

            if LeaveType."Min Days Avail" <> 0 then
                if Rec."Leave Days" < LeaveType."Min Days Avail" then
                    ERROR('You cannot apply less than %1 Leaves', LeaveType."Min Days Avail");

            if LeaveType."Min Days Between 2 leave Req." <> 0 then
                ValidateDaysBetweenLeaveReq(Employee, LeaveType);
        end
        else begin
            ERROR('Selected leave type is inactive');
        end;

        EmployeeInterimAccrualLines.RESET;
        EmployeeInterimAccrualLines.SETRANGE("Accrual ID", LeaveType."Accrual ID");
        EmployeeInterimAccrualLines.SETRANGE("Worker ID", "Personnel Number");
        EmployeeInterimAccrualLines.SETRANGE("Start Date", CALCDATE('-CM', "Start Date"));
        EmployeeInterimAccrualLines.SETRANGE("End Date", CALCDATE('CM', "End Date"));
        if EmployeeInterimAccrualLines.FINDLAST then begin
            if not LeaveType."Allow Negative" then
                if EmployeeInterimAccrualLines."Closing Balance" < "Leave Days" then
                    ERROR('You donot have enough balance of leaves');
        end;
        "Submission Date" := WORKDATE;
        MODIFY;
    end;

    procedure ValidateMaxTime(l_Employee: Record Employee; l_LeaveType: Record "HCM Leave Types Wrkr")
    var
        l_LeaveRequestHeader: Record "Leave Request Header";
    begin
        l_LeaveRequestHeader.RESET;
        l_LeaveRequestHeader.SETRANGE("Personnel Number", l_Employee."No.");
        l_LeaveRequestHeader.SETRANGE("Leave Type", l_LeaveType."Leave Type Id");
        l_LeaveRequestHeader.SETRANGE("Workflow Status", l_LeaveRequestHeader."Workflow Status"::Released);
        if l_LeaveRequestHeader.FINDFIRST then
            if l_LeaveRequestHeader.COUNT > l_LeaveType."Max Times" then
                ERROR('You cannot apply %1 leave type more than %2 times', l_LeaveType."Leave Type Id", l_LeaveType."Max Times");
    end;

    procedure ValidateMinServiceDays(l_Employee: Record Employee; l_LeaveType: Record "HCM Leave Types Wrkr")
    var
    begin
        if (Rec."Start Date" - l_Employee."Joining Date") < l_LeaveType."Min Service Days" then
            ERROR('You can apply %1 leave type only after  %2 days of service', l_LeaveType."Leave Type Id", l_LeaveType."Min Service Days");
    end;

    procedure ValidateMinDaysBeforeReq(l_Employee: Record Employee; l_LeaveType: Record "HCM Leave Types Wrkr")
    var
    begin
        if (Rec."Start Date" - Rec."Submission Date") < l_LeaveType."Min Days Before Req" then
            ERROR('You can apply leave before %1 ', CALCDATE('-' + FORMAT(l_LeaveType."Min Days Before Req") + 'D', Rec."Start Date"));
    end;

    procedure ValidateMaxOccurance(l_Employee: Record Employee; l_LeaveType: Record "HCM Leave Types Wrkr")
    var
        l_LeaveRequestHeader: Record "Leave Request Header";
    begin
        l_LeaveRequestHeader.RESET;
        l_LeaveRequestHeader.SETRANGE("Leave Type", l_LeaveType."Leave Type Id");
        l_LeaveRequestHeader.SETRANGE("Workflow Status", l_LeaveRequestHeader."Workflow Status"::Released);
        if l_LeaveRequestHeader.FINDFIRST then
            if l_LeaveRequestHeader.COUNT > l_LeaveType."Max Occurance" then
                ERROR('You Cannot apply %1 leave type more than %2 times', l_LeaveType."Leave Type Id", l_LeaveType."Max Occurance");
    end;

    procedure ValidateDaysBetweenLeaveReq(l_Employee: Record Employee; l_LeaveType: Record "HCM Leave Types Wrkr")
    var
        l_LeaveRequestHeader: Record "Leave Request Header";
    begin
        l_LeaveRequestHeader.RESET;
        l_LeaveRequestHeader.SETRANGE("Personnel Number", l_Employee."No.");
        l_LeaveRequestHeader.SETRANGE("Leave Type", l_LeaveType."Leave Type Id");
        l_LeaveRequestHeader.SETRANGE("Workflow Status", l_LeaveRequestHeader."Workflow Status"::Released);
        if l_LeaveRequestHeader.FINDFIRST then
            if (l_LeaveRequestHeader."End Date" - Rec."Start Date") <= l_LeaveType."Min Days Between 2 leave Req." then
                ERROR('You can apply %1 leave type Only after  %2', l_LeaveType."Leave Type Id",
                 CALCDATE('+' + FORMAT(l_LeaveType."Min Days Between 2 leave Req.") + 'D', l_LeaveRequestHeader."End Date"));
    end;
}