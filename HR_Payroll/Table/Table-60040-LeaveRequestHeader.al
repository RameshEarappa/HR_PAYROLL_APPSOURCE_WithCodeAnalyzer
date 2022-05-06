table 60040 "Leave Request Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Leave Request ID"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ("Leave Request ID" <> xRec."Leave Request ID") then begin
                    AdvancePayrollSetup.GET;
                    NoSeriesMngmnt.TestManual(AdvancePayrollSetup."Leave Request Nos.");
                    AdvancePayrollSetup."Leave Request Nos." := '';
                end;
            end;
        }
        field(2; "Personnel Number"; Code[20])
        {
            TableRelation = Employee where(Status = filter(Active));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                LeaveRequestHeaderRecL: Record "Leave Request Header";
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
                        Validate("Earning Code Group", EmplErngCodegrp."Earning Code Group")
                    else
                        ERROR('There is no active Employee inthis period');
                end;

                UserSetupRec.SETRANGE("Employee Id", "Personnel Number");
                if UserSetupRec.FINDFIRST then
                    User_ID := UserSetupRec."User ID";
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Leave Type"; Code[20])
        {
            TableRelation = "HCM Leave Types Wrkr"."Leave Type Id" WHERE(Worker = field("Personnel Number"), "IsSystem Defined" = CONST(false), "Earning Code Group" = field("Earning Code Group"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EmployeeInterimAccuralsRecL: Record "Employee Interim Accurals";
                HCMLeaveTypeRecL: Record "HCM Leave Types";
                HCMLeaveTypeWrkL: Record "HCM Leave Types Wrkr";
                RecAccrualCompEmp: Record "Accrual Components Employee";
                RecEmpInterAccLines: Record "Employee Interim Accurals";
                RecLeaveRequest: Record "Leave Request Header";
                AccrualComponentsEmployeeL: Record "Accrual Components Employee";
            begin
                if "Leave Type" <> '' then begin
                    Employee.GET("Personnel Number");
                    LeaveRequestHeader.RESET;
                    LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
                    LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
                    LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "Start Date");
                    LeaveRequestHeader.SETFILTER("End Date", '>=%1', "End Date");
                    LeaveRequestHeader.SETRANGE("Leave Cancelled", false);
                    LeaveRequestHeader.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader."Workflow Status"::Rejected);
                    if LeaveRequestHeader.FINDFIRST then begin
                        ERROR('Leave Period Overlaps with other leave request');
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

                LeaveRequestHeader.RESET;
                LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
                LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
                LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "End Date");
                LeaveRequestHeader.SETFILTER("End Date", '>=%1', "End Date");
                LeaveRequestHeader.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader."Workflow Status"::Rejected);
                if LeaveRequestHeader.FINDFIRST then begin
                    ERROR('Leave Period Overlaps with other leave request');
                end;

                HCMLeaveTypeRecL.Reset();
                HCMLeaveTypeRecL.SetFilter("Accrual ID", '<>%1', '');
                if HCMLeaveTypeRecL.FindFirst() then begin
                    EmployeeInterimAccuralsRecL.Reset();
                    EmployeeInterimAccuralsRecL.SetRange("Worker ID", "Personnel Number");
                    EmployeeInterimAccuralsRecL.SetRange("Monthly Accrual Amount", 0);
                    if EmployeeInterimAccuralsRecL.FindSet() then begin
                        repeat
                        until EmployeeInterimAccuralsRecL.Next() = 0;
                    end;
                end;
                CalculateLeaveBalance();
            end;
        }
        field(5; "Short Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Start Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EmployeeWorkCalcRecL: Record EmployeeWorkDate_GCC;
                LeaveTypeRecL: Record "HCM Leave Types";
            begin
                CheckStartEndDateYearBothSame;
                LeaveTypeRecL.Reset();
                LeaveTypeRecL.SetRange("Is System Defined", true);
                if LeaveTypeRecL.FindFirst() then begin
                    EmployeeWorkCalcRecL.Reset();
                    EmployeeWorkCalcRecL.SetRange("Employee Code", "Personnel Number");
                    EmployeeWorkCalcRecL.SetRange("Trans Date", "Start Date");
                    EmployeeWorkCalcRecL.SetRange("First Half Leave Type", LeaveTypeRecL."Short Name");
                    EmployeeWorkCalcRecL.SetRange("Second Half Leave Type", LeaveTypeRecL."Short Name");
                    if NOT EmployeeWorkCalcRecL.FindFirst() then
                        error('Leave already Applied for a day.');
                end;

                Validate("Consumed Leaves", ConsumeBalance());

                IF "Start Date" <> 0D THEN BEGIN
                    IF "End Date" <> 0D THEN
                        IF "Start Date" > "End Date" THEN
                            ERROR('Start Date Should not be after End Date ');

                    Employee.GET("Personnel Number");
                    Employee.TESTFIELD("Joining Date");
                    IF Employee."Joining Date" > Rec."Start Date" THEN
                        ERROR('You cannot apply leaves before joining date %1', Employee."Joining Date");


                    IF "End Date" <> 0D THEN
                        ValidateEndDate;
                END;

                LeaveRequestHeader.RESET;
                LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
                LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "Start Date");
                LeaveRequestHeader.SETFILTER("End Date", '>=%1', "Start Date");
                LeaveRequestHeader.SETRANGE("Leave Cancelled", FALSE);
                LeaveRequestHeader.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader."Workflow Status"::Rejected);
                LeaveRequestHeader.SETFILTER("Resumption Type", '%1|%2|%3', LeaveRequestHeader."Resumption Type"::"Late Resumption", LeaveRequestHeader."Resumption Type"::"On Time Resumption",
                                             LeaveRequestHeader."Resumption Type"::" ");
                IF LeaveRequestHeader.FINDFIRST THEN BEGIN
                    ERROR('Leave Period Overlaps with other leave request');
                END;
                CalCulateLeaveBalance();
            end;
        }
        field(8; "Alternative Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Leave Start Day Type"; Option)
        {
            OptionCaption = 'Full Day,First Half,Second Half';
            OptionMembers = "Full Day","First Half","Second Half";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateEndDate;
            end;
        }
        field(10; "End Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EmployeeWorkCalcRecL: Record EmployeeWorkDate_GCC;
                LeaveTypeRecL: Record "HCM Leave Types";
            begin
                CheckStartEndDateYearBothSame;
                LeaveTypeRecL.Reset();
                LeaveTypeRecL.SetRange("Is System Defined", true);
                if LeaveTypeRecL.FindFirst() then begin
                    EmployeeWorkCalcRecL.Reset();
                    EmployeeWorkCalcRecL.SetRange("Employee Code", "Personnel Number");
                    EmployeeWorkCalcRecL.SetRange("Trans Date", "Start Date");
                    EmployeeWorkCalcRecL.SetRange("First Half Leave Type", LeaveTypeRecL."Short Name");
                    EmployeeWorkCalcRecL.SetRange("Second Half Leave Type", LeaveTypeRecL."Short Name");
                    if NOT EmployeeWorkCalcRecL.FindFirst() then
                        error('Leave already Applied for a day.');
                end;

                ValidateEndDate;
                CalCulateLeaveBalance();
            end;
        }
        field(11; "Alternative End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Leave End Day Type"; Option)
        {
            OptionCaption = 'Full Day,First Half';
            OptionMembers = "Full Day","First Half";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateEndDate;
            end;
        }
        field(13; LTA; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Leave Days"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; "Leave Remarks"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(16; "Cover Resource"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Employee.RESET;
                if Employee.GET("Cover Resource") then
                    "Cover Resource" := Employee."No.";
            end;
        }
        field(17; "Submission Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Workflow Status"; Option)
        {
            OptionCaption = 'Open,Approved,Send for Approval,Rejected';
            OptionMembers = Open,Released,"Pending For Approval",Rejected;
            DataClassification = CustomerContent;
        }
        field(19; Posted; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Leave Cancelled"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Leave Planner ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Resumption Type"; Option)
        {
            OptionCaption = ' ,On Time Resumption,Late Resumption,Early Resumption';
            OptionMembers = " ","On Time Resumption","Late Resumption","Early Resumption";
            DataClassification = CustomerContent;
        }
        field(25; "Resumption Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Net Leave Days"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Created Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Earning Code Group"; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(29; "Duty Resumption Request"; Boolean)
        {
            Caption = 'Is Resumption Request';
            Description = 'Duty Resumption';
            DataClassification = CustomerContent;
        }
        field(30; "Cancel Remarks"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50; "Duty Resumption ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51; RecId; RecordId)
        {
            DataClassification = CustomerContent;
        }
        field(60; User_ID; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Entitlement Days"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Leave Balance", "Entitlement Days" - "Consumed Leaves");
            end;
        }
        field(71; "Consumed Leaves"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Leave Balance", "Entitlement Days" - "Consumed Leaves");
            end;
        }
        field(72; "Leave Balance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(73; "Dependent ID"; Code[20])
        {
            TableRelation = "Employee Dependents Master" where(Relationship = filter(Child), "Employee ID" = field("Personnel Number"));
            DataClassification = CustomerContent;
            trigger
            OnValidate()
            var
                EmpDepeMasterRecL: Record "Employee Dependents Master";
                ChildCurrentAge: Integer;
                HCMLeaveTypeRecL: Record "HCM Leave Types";
            begin
                EmpDepeMasterRecL.Reset();
                if EmpDepeMasterRecL.Get("Dependent ID", "Personnel Number") then begin
                    "Dependent Name" := EmpDepeMasterRecL."Dependent First Name" + ' ' + EmpDepeMasterRecL."Dependent Middle Name" + ' ' + EmpDepeMasterRecL."Dependent Last Name";
                    ChildCurrentAge := Today - EmpDepeMasterRecL."Date of Birth";

                    HCMLeaveTypeRecL.Reset();
                    HCMLeaveTypeRecL.SetRange("Leave Type Id", "Leave Type");
                    if HCMLeaveTypeRecL.FindFirst() then begin
                        if HCMLeaveTypeRecL."Is Paternity Leave" then begin
                            HCMLeaveTypeRecL.TestField("Child Age Limit in Months");
                            if ChildCurrentAge > (HCMLeaveTypeRecL."Child Age Limit in Months" * 30) then
                                Error('Dependent Age must be less than  %1 months', HCMLeaveTypeRecL."Child Age Limit in Months");
                        end;
                        if HCMLeaveTypeRecL."Adoption leave" then begin
                            HCMLeaveTypeRecL.TestField("Adoption Child Age Months");
                            if ChildCurrentAge > (HCMLeaveTypeRecL."Adoption Child Age Months" * 30) then
                                Error('Dependent Age must be less than  %1 months', HCMLeaveTypeRecL."Adoption Child Age Months");
                        end;
                    end;
                end;
            end;
        }
        field(74; "Dependent Name"; Text[150])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(502; "Compensatory Leave Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Leave Request ID")
        {
            Clustered = true;
        }
        key(Key2; "Personnel Number", "Leave Request ID", "Leave Type", "Start Date", "Leave Cancelled", "Workflow Status")
        {
            SumIndexFields = "Leave Days";
        }
    }



    trigger OnDelete()
    begin
        TESTFIELD("Workflow Status", "Workflow Status"::Open);
    end;

    trigger OnInsert()
    begin

        AdvancePayrollSetup.GET;
        AdvancePayrollSetup.TESTFIELD("Leave Request Nos.");
        if "Leave Request ID" = '' then begin
            "Leave Request ID" := NoSeriesMngmnt.GetNextNo(AdvancePayrollSetup."Leave Request Nos.", TODAY, true);
            "Created By" := USERID;
            "Created Date Time" := CURRENTDATETIME;
            "Workflow Status" := "Workflow Status"::Open;
            "Submission Date" := Today;
        end;
        RecId := RecordId;
    end;

    var
        Employee: Record Employee;
        LeaveType: Record "HCM Leave Types Wrkr";
        EmployeeWorkDate_GCC: Record EmployeeWorkDate_GCC;
        WorkCalendarDate: Record "Work Calendar Date";
        EmployeeEarngCodeGrp: Record "Employee Earning Code Groups";
        PublicHolidays: Integer;
        WeeklyOffDays: Integer;
        BenefitAdjustJournalHeader: Record "Benefit Adjmt. Journal header";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        AdvancePayrollSetup: Record "Advance Payroll Setup";
        NoSeriesMngmnt: Codeunit NoSeriesManagement;
        EmplErngCodegrp: Record "Employee Earning Code Groups";
        LeaveRequestHeader: Record "Leave Request Header";
        EmployeeInterimAccruals: Record "Employee Interim Accurals";
        AccountingPeriod: Record "Accounting Period";
        HCMLeavetype: Record "HCM Leave Types";
        UserSetupRec: Record "User Setup";


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

        EmployeeWorkDate_GCC.RESET;
        EmployeeWorkDate_GCC.SETRANGE("Employee Code", "Personnel Number");
        EmployeeWorkDate_GCC.SETRANGE("Trans Date", "Start Date", "End Date");
        if not EmployeeWorkDate_GCC.FINDFIRST then
            ERROR('There is not Employee workdate calendar for this leave request days');

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "Start Date");
        LeaveRequestHeader.SETFILTER("End Date", '>=%1', "Start Date");
        LeaveRequestHeader.SETRANGE("Leave Cancelled", false);
        LeaveRequestHeader.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader."Workflow Status"::Rejected);
        if LeaveRequestHeader.FINDFIRST then begin
            ERROR('Leave Period Overlaps with other leave request');
        end;

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "Start Date");
        LeaveRequestHeader.SETFILTER("End Date", '>=%1', "End Date");
        LeaveRequestHeader.SETRANGE("Leave Cancelled", false);
        LeaveRequestHeader.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader."Workflow Status"::Rejected);
        if LeaveRequestHeader.FINDFIRST then begin
            ERROR('Leave Period Overlaps with other leave request');
        end;

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETFILTER("Start Date", '>=%1', "Start Date");
        LeaveRequestHeader.SETFILTER("End Date", '<=%1', "End Date");
        LeaveRequestHeader.SETRANGE("Leave Cancelled", false);
        LeaveRequestHeader.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader."Workflow Status"::Rejected);
        if LeaveRequestHeader.FINDFIRST then begin
            ERROR('Leave Period Overlaps with other leave request');
        end;

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETFILTER("Start Date", '<=%1', "End Date");
        LeaveRequestHeader.SETFILTER("End Date", '>=%1', "End Date");
        LeaveRequestHeader.SETRANGE("Leave Cancelled", false);
        LeaveRequestHeader.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader."Workflow Status"::Rejected);
        if LeaveRequestHeader.FINDFIRST then
            ERROR('Leave Period Overlaps with other leave request');

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETRANGE("Start Date", "Start Date");
        LeaveRequestHeader.SETRANGE("Leave Cancelled", false);
        LeaveRequestHeader.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader."Workflow Status"::Rejected);
        if LeaveRequestHeader.FINDFIRST then
            ERROR('Leave Period Overlaps with other leave request');

        LeaveRequestHeader.RESET;
        LeaveRequestHeader.SETRANGE("Personnel Number", "Personnel Number");
        LeaveRequestHeader.SETFILTER("Leave Request ID", '<>%1', "Leave Request ID");
        LeaveRequestHeader.SETRANGE("End Date", "End Date");
        LeaveRequestHeader.SETRANGE("Leave Cancelled", false);
        LeaveRequestHeader.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader."Workflow Status"::Rejected);
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
                //
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


    procedure SubmitLeave(var LeaveRequestHeader: Record "Leave Request Header")
    var
        PayJobPosWorker: Record "Payroll Job Pos. Worker Assign";
        PayPosition: Record "Payroll Position";
        PayCycle: Record "Pay Cycles";
        PayPeriods: Record "Pay Periods";
        EmployeeInterimAccrualLines: Record "Employee Interim Accurals";
        RecordLink: Record "Record Link";
        l_LeaveType: Record "HCM Leave Types Wrkr";
        TotalLeaveDays: Decimal;
        DocumentAttachmentRecL: Record "Document Attachment";
        LeaveDateStartYear: Date;
        LeaveDateEndYear: Date;
        AccCompEmployeeRecL: Record "Accrual Components Employee";
        EmployeeInterimAccuralsRecL: Record "Employee Interim Accurals";
        LastYearStartDate: date;
        LeaveRequestHeader2: Record "Leave Request Header"; //21.10.2020
    begin
        TESTFIELD("Leave Type");
        TESTFIELD("Workflow Status", "Workflow Status"::Open);

        Employee.GET("Personnel Number");

        l_LeaveType.RESET;
        l_LeaveType.SETRANGE(l_LeaveType.Worker, Rec."Personnel Number");
        l_LeaveType.SETRANGE("Leave Type Id", Rec."Leave Type");
        l_LeaveType.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if l_LeaveType.FINDFIRST then begin
            l_LeaveType.TESTFIELD(Active);

            HCMLeavetype.GET(l_LeaveType."Leave Type Id");

            if HCMLeavetype."Cover Resource Mandatory" then
                LeaveRequestHeader.TESTFIELD("Cover Resource");

            if l_LeaveType."Accrual ID" = '' then begin
                if not l_LeaveType."Allow Negative" then begin
                    CLEAR(LeaveDateStartYear);
                    CLEAR(LeaveDateEndYear);
                    LeaveDateStartYear := CALCDATE('-CY', "Start Date");
                    LeaveDateEndYear := CALCDATE('CY', "Start Date");
                    AccountingPeriod.RESET;
                    AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
                    AccountingPeriod.SETFILTER("Starting Date", '>=%1', "Start Date");
                    IF AccountingPeriod.FINDLAST THEN BEGIN
                        TotalLeaveDays := 0;
                        LeaveRequestHeader2.RESET;
                        LeaveRequestHeader2.SETCURRENTKEY("Personnel Number", "Leave Request ID", "Leave Type", "Start Date", "Leave Cancelled", "Workflow Status");
                        LeaveRequestHeader2.SETRANGE("Personnel Number", "Personnel Number");
                        LeaveRequestHeader2.SETRANGE("Leave Type", "Leave Type");
                        LeaveRequestHeader2.SETRANGE("Start Date", LeaveDateStartYear, LeaveDateEndYear);
                        LeaveRequestHeader2.SETRANGE("Leave Cancelled", FALSE);
                        LeaveRequestHeader2.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader2."Workflow Status"::Rejected);
                        IF LeaveRequestHeader2.FINDFIRST THEN
                            REPEAT
                                TotalLeaveDays += LeaveRequestHeader2."Leave Days";
                            UNTIL LeaveRequestHeader2.NEXT = 0;
                        IF TotalLeaveDays > l_LeaveType."Entitlement Days" THEN
                            ERROR('You Cannot apply leaves more than entitlement days in current period');
                    end;
                end;
            end;
            if l_LeaveType."Accrual ID" <> '' then begin
                CLEAR(LeaveDateStartYear);
                CLEAR(LeaveDateEndYear);

                LeaveDateStartYear := CALCDATE('-CM', "Start Date");
                LeaveDateEndYear := CALCDATE('CM', "Start Date");

                AccCompEmployeeRecL.Reset();
                AccCompEmployeeRecL.SetRange("Worker ID", "Personnel Number");
                AccCompEmployeeRecL.SetRange("Accrual ID", l_LeaveType."Accrual ID");
                if AccCompEmployeeRecL.FindFirst() then begin
                    if NOT AccCompEmployeeRecL."Allow Negative" then begin
                        EmployeeInterimAccuralsRecL.Reset();
                        EmployeeInterimAccuralsRecL.SetRange("Accrual ID", AccCompEmployeeRecL."Accrual ID");
                        EmployeeInterimAccuralsRecL.SetRange("Start Date", LeaveDateStartYear, LeaveDateEndYear);
                        if EmployeeInterimAccuralsRecL.FindFirst() then begin
                            TotalLeaveDays := 0;
                            LeaveRequestHeader2.RESET;
                            LeaveRequestHeader2.SETCURRENTKEY("Personnel Number", "Leave Request ID", "Leave Type", "Start Date", "Leave Cancelled", "Workflow Status");
                            LeaveRequestHeader2.SETRANGE("Personnel Number", "Personnel Number");
                            LeaveRequestHeader2.SETRANGE("Leave Type", "Leave Type");
                            LeaveRequestHeader2.SETRANGE("Start Date", LeaveDateStartYear, LeaveDateEndYear);
                            LeaveRequestHeader2.SETRANGE("Leave Cancelled", FALSE);
                            LeaveRequestHeader2.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader2."Workflow Status"::Rejected);
                            IF LeaveRequestHeader2.FINDFIRST THEN
                                REPEAT
                                    TotalLeaveDays += LeaveRequestHeader2."Leave Days";
                                UNTIL LeaveRequestHeader2.NEXT = 0;
                            if TotalLeaveDays > EmployeeInterimAccuralsRecL."Closing Balance" then
                                Error('Cannot Apply more than total Leaves Days.');
                        end;
                    end else begin
                        CLEAR(LeaveDateStartYear);
                        CLEAR(LeaveDateEndYear);
                        LeaveDateStartYear := CALCDATE('-CY', "Start Date");
                        LeaveDateEndYear := CALCDATE('CY', "Start Date");
                        LastYearStartDate := CALCDATE('-CM', LeaveDateEndYear);

                        EmployeeInterimAccuralsRecL.Reset();
                        EmployeeInterimAccuralsRecL.SETRANGE("Worker ID", AccCompEmployeeRecL."Worker ID");
                        EmployeeInterimAccuralsRecL.SetRange("Accrual ID", AccCompEmployeeRecL."Accrual ID");
                        EmployeeInterimAccuralsRecL.SetRange("Start Date", LastYearStartDate, LeaveDateEndYear);
                        if EmployeeInterimAccuralsRecL.FindFirst() then begin
                            TotalLeaveDays := 0;
                            LeaveRequestHeader2.RESET;
                            LeaveRequestHeader2.SETCURRENTKEY("Personnel Number", "Leave Request ID", "Leave Type", "Start Date", "Leave Cancelled", "Workflow Status");
                            LeaveRequestHeader2.SETRANGE("Personnel Number", "Personnel Number");
                            LeaveRequestHeader2.SETRANGE("Leave Type", "Leave Type");
                            LeaveRequestHeader2.SETRANGE("Start Date", LeaveDateStartYear, LeaveDateEndYear);
                            LeaveRequestHeader2.SETRANGE("Leave Cancelled", FALSE);
                            LeaveRequestHeader2.SETFILTER("Workflow Status", '<>%1', LeaveRequestHeader2."Workflow Status"::Rejected);
                            IF LeaveRequestHeader2.FINDFIRST THEN
                                REPEAT
                                    TotalLeaveDays += LeaveRequestHeader2."Leave Days";
                                UNTIL LeaveRequestHeader2.NEXT = 0;
                            if TotalLeaveDays > EmployeeInterimAccuralsRecL."Closing Balance" then
                                Error('Total leave days limit exceeds, your leave balance is %1', EmployeeInterimAccuralsRecL."Closing Balance");
                        end;
                    end;
                end;

                IF l_LeaveType."Accrual ID" <> '' THEN BEGIN
                    EmployeeInterimAccruals.RESET;
                    EmployeeInterimAccruals.SETRANGE("Worker ID", Rec."Personnel Number");
                    EmployeeInterimAccruals.SETRANGE("Start Date", CALCDATE('-CM', Rec."Start Date"));
                    IF NOT EmployeeInterimAccruals.FINDFIRST THEN
                        ERROR('There is no Employee Interim Accruals defined for this employee');
                END;
                Employee.GET("Personnel Number");
                Employee.TESTFIELD("Joining Date");

                l_LeaveType.TESTFIELD(Active, TRUE);
                IF Employee."Termination Date" <> 0D THEN BEGIN
                    IF (Employee."Termination Date" < "Start Date") OR (Employee."Termination Date" <= "End Date") THEN
                        ERROR('You Cannot apply leave after employees termination');
                END;

                IF Employee."Joining Date" > Rec."Start Date" THEN
                    ERROR('You cannot apply leaves before joining date %1', Employee."Joining Date");

                IF l_LeaveType."Leave Avail Basis" = l_LeaveType."Leave Avail Basis"::"Probation End Date" THEN
                    IF Rec."Start Date" < Employee."Probation Period" THEN
                        ERROR('You cannot apply leave before probation period ends');

                IF l_LeaveType."Leave Avail Basis" = l_LeaveType."Leave Avail Basis"::"Confirmation Date" THEN
                    IF Rec."Start Date" < Employee."Employment Date" THEN
                        ERROR('You cannot apply leave before Confirmation Date');

                IF l_LeaveType."Leave Avail Basis" = l_LeaveType."Leave Avail Basis"::"Joining Date" THEN
                    IF Rec."Start Date" < Employee."Joining Date" THEN
                        ERROR('You cannot apply leave before Joining Date');

                IF l_LeaveType."Probation Entitlement Days" <> 0 THEN
                    IF Rec."Start Date" < Employee."Probation Period" THEN
                        IF "Leave Days" < l_LeaveType."Probation Entitlement Days" THEN
                            ERROR('YOu cannot apply more than %1 days in Probation period', l_LeaveType."Probation Entitlement Days");

                IF l_LeaveType."Accrual ID" <> '' THEN BEGIN
                    EmployeeInterimAccruals.SETRANGE("Worker ID", Rec."Personnel Number");
                    EmployeeInterimAccruals.SETRANGE("Start Date", CALCDATE('-CM', Rec."Start Date"));
                    IF NOT EmployeeInterimAccruals.FINDFIRST THEN
                        ERROR('There is no Employee Interim Accruals defined for this employee');
                END;
                Employee.GET(Rec."Personnel Number");
                "Submission Date" := TODAY;

                PayJobPosWorker.RESET;
                PayJobPosWorker.SETRANGE(Worker, "Personnel Number");
                PayJobPosWorker.SETFILTER("Effective Start Date", '<=%1', TODAY);
                PayJobPosWorker.SETFILTER("Effective End Date", '>=%1|%2', TODAY, 0D);
                IF PayJobPosWorker.FINDFIRST THEN BEGIN
                    PayPosition.GET(PayJobPosWorker."Position ID");
                    PayPosition.TESTFIELD("Pay Cycle");
                    PayCycle.GET(PayPosition."Pay Cycle");
                    PayPeriods.RESET;
                    PayPeriods.SETRANGE("Pay Cycle", PayCycle."Pay Cycle");
                    PayPeriods.SETFILTER("Period Start Date", '<=%', "Start Date");
                    PayPeriods.SETFILTER("Period End Date", '>=%1|%2', "End Date");
                    PayPeriods.SETRANGE(Status, PayPeriods.Status::Closed);
                    IF PayPeriods.FINDFIRST THEN
                        ERROR('Pay period is closed for the selected leave request dates');
                END
                ELSE BEGIN
                    ERROR('There is no active position assigned for the employee %1 as of date', "Personnel Number");
                END;

                Employee.TESTFIELD("Joining Date");
                TESTFIELD("Submission Date");
                l_LeaveType.TESTFIELD(Active, TRUE);
                IF Employee."Termination Date" <> 0D THEN BEGIN
                    IF (Employee."Termination Date" < "Start Date") OR (Employee."Termination Date" <= "End Date") THEN
                        ERROR('You Cannot apply leave after employees termination');
                END;

                IF Employee."Joining Date" > Rec."Start Date" THEN
                    ERROR('You cannot apply leaves before joining date %1', Employee."Joining Date");

                IF l_LeaveType.Active THEN BEGIN
                    IF l_LeaveType."Max Times" <> 0 THEN
                        ValidateMaxTime(Employee, l_LeaveType);

                    IF l_LeaveType."Min Service Days" <> 0 THEN
                        ValidateMinServiceDays(Employee, l_LeaveType);

                    IF l_LeaveType."Min Days Before Req" <> 0 THEN
                        ValidateMinDaysBeforeReq(Employee, l_LeaveType);

                    IF l_LeaveType."Max Occurance" <> 0 THEN
                        ValidateMaxOccurance(Employee, l_LeaveType);
                    IF l_LeaveType."Max Days Avail" <> 0 THEN
                        IF Rec."Leave Days" > l_LeaveType."Max Days Avail" THEN
                            ERROR('You cannot apply more than %1 Leaves', l_LeaveType."Max Days Avail");

                    IF l_LeaveType."Min Days Avail" <> 0 THEN
                        IF Rec."Leave Days" < l_LeaveType."Min Days Avail" THEN
                            ERROR('You cannot apply less than %1 Leaves', l_LeaveType."Min Days Avail");

                    IF l_LeaveType."Min Days Between 2 leave Req." <> 0 THEN
                        ValidateDaysBetweenLeaveReq(Employee, l_LeaveType);
                END
                ELSE BEGIN
                    ERROR('Selected leave type is inactive');
                END;
                "Submission Date" := WORKDATE;
                MODIFY;
            END;
        end;
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
        l_LeaveRequestHeader: Record "Leave Request Header";
    begin
        if (Rec."Start Date" - l_Employee."Joining Date") < l_LeaveType."Min Service Days" then
            ERROR('You can apply %1 leave type only after  %2 days of service', l_LeaveType."Leave Type Id", l_LeaveType."Min Service Days");
    end;

    procedure ValidateMinDaysBeforeReq(l_Employee: Record Employee; l_LeaveType: Record "HCM Leave Types Wrkr")
    var
        l_LeaveRequestHeader: Record "Leave Request Header";
    begin
        if (Rec."Start Date" - Rec."Submission Date") < l_LeaveType."Min Days Before Req" then
            ERROR('You can apply leave after %1 ', CALCDATE('+' + FORMAT(l_LeaveType."Min Days Before Req") + 'D', Rec."Submission Date"));
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

    procedure PostLeave(var LeaveRequestHeader: Record "Leave Request Header")
    var
        AccrualCompCalc: Codeunit "Accrual Component Calculate";
        AdvaceSetup: Record "Advance Payroll Setup";
    begin
        AdvaceSetup.Reset();
        AdvaceSetup.Get();
        LeaveRequestHeader.TESTFIELD("Leave Type");
        if NOT AdvaceSetup."Auto Post Leave Request" then
            LeaveRequestHeader.TESTFIELD("Workflow Status", LeaveRequestHeader."Workflow Status"::Released); //21.10.2020

        Employee.GET("Personnel Number");

        LeaveType.RESET;
        LeaveType.SETRANGE(LeaveType.Worker, LeaveRequestHeader."Personnel Number");
        LeaveType.SETRANGE("Leave Type Id", LeaveRequestHeader."Leave Type");
        LeaveType.SETRANGE("Earning Code Group", LeaveRequestHeader."Earning Code Group");
        if LeaveType.FINDFIRST then;


        if not (LeaveType.Gender = LeaveType.Gender::" ") then
            if LeaveType.Gender <> Employee.Gender then
                ERROR('This leave is for Gender %1', LeaveType.Gender);

        if LeaveType."Marital Status" <> '' then
            if LeaveType."Marital Status" <> Employee."Marital Status" then
                ERROR('This leave is only for employees with Marital Status %1', LeaveType."Marital Status");

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
                    Error('You cannot apply more than 1% days of %2', LeaveType."Max Days Avail", LeaveType."Leave Type");

            if LeaveType."Min Days Avail" <> 0 then
                if Rec."Leave Days" < LeaveType."Min Days Avail" then
                    Error('You cannot apply less than 1% days of %2', LeaveType."Min Days Avail", LeaveType."Leave Type");

            if LeaveType."Min Days Between 2 leave Req." <> 0 then
                ValidateDaysBetweenLeaveReq(Employee, LeaveType);

        end
        else begin
            ERROR('Selected leave type is inactive');
        end;
        CreateEmployeeWorkDate_GCC(LeaveType);
        AccrualCompCalc.ValidateAccrualLeaves(LeaveRequestHeader."Personnel Number",
                                              LeaveRequestHeader."Leave Type",
                                              LeaveRequestHeader."Start Date",
                                              LeaveRequestHeader."End Date",
                                              LeaveRequestHeader."Earning Code Group",
                                              LeaveType."Accrual ID",
                                              LeaveRequestHeader."Leave Days");

        AccrualCompCalc.OnAfterValidateAccrualLeaves(LeaveRequestHeader."Personnel Number",
                                                     LeaveRequestHeader."Start Date",
                                                     LeaveRequestHeader."Leave Type",
                                                     LeaveRequestHeader."Earning Code Group");
        LeaveRequestHeader.Posted := true;
        LeaveRequestHeader.MODIFY;
    end;

    procedure CreateNegativeBenefitJournal(LeaveType: Record "HCM Leave Types Wrkr"; NetLeaveDays: Decimal)
    begin
        LeaveType.Reset();

        if LeaveType.FindSet() then begin
            repeat
                BenefitAdjustJournalHeader.INIT;
                BenefitAdjustJournalHeader.VALIDATE(Description, 'Leave Request ' + LeaveType."Leave Type Id");
                BenefitAdjustJournalHeader.VALIDATE("Default Benefit", LeaveType."Benefit Id");
                BenefitAdjustJournalHeader.VALIDATE("Defaualt Employee", LeaveType.Worker);
                if BenefitAdjustJournalHeader.INSERT(true) then
                    CreateBenefitAgjustmentJnlLines(BenefitAdjustJournalHeader);
            until LeaveType.Next() = 0;
        end;
    end;

    procedure CreateEmployeeWorkDate_GCC(var LeaveType: Record "HCM Leave Types Wrkr")
    begin
        LeaveType.TESTFIELD(Worker);
        EmployeeWorkDate_GCC.RESET;
        EmployeeWorkDate_GCC.SETRANGE("Employee Code", "Personnel Number");
        EmployeeWorkDate_GCC.SETRANGE("Trans Date", "Start Date", "End Date");
        if (LeaveType."Exc Public Holidays") and (LeaveType."Exc Week Offs") then
            EmployeeWorkDate_GCC.SETRANGE("Calculation Type", EmployeeWorkDate_GCC."Calculation Type"::"Working Day")
        else
            if (LeaveType."Exc Public Holidays") and (not LeaveType."Exc Week Offs") then
                EmployeeWorkDate_GCC.SETRANGE("Calculation Type", EmployeeWorkDate_GCC."Calculation Type"::"Working Day",
                                                                 EmployeeWorkDate_GCC."Calculation Type"::"Weekly Off")
            else
                if (not LeaveType."Exc Public Holidays") and (LeaveType."Exc Week Offs") then
                    EmployeeWorkDate_GCC.SETRANGE("Calculation Type", EmployeeWorkDate_GCC."Calculation Type"::"Working Day",
                                                                     EmployeeWorkDate_GCC."Calculation Type"::"Public Holiday");
        if EmployeeWorkDate_GCC.FINDFIRST then
            repeat
                if "Start Date" = EmployeeWorkDate_GCC."Trans Date" then begin
                    if "Leave Start Day Type" = "Leave Start Day Type"::"First Half" then
                        EmployeeWorkDate_GCC."First Half Leave Type" := LeaveType."Leave Type Id"
                    else
                        if "Leave Start Day Type" = "Leave Start Day Type"::"Second Half" then
                            EmployeeWorkDate_GCC."Second Half Leave Type" := LeaveType."Leave Type Id"
                        else
                            if "Leave Start Day Type" = "Leave Start Day Type"::"Full Day" then begin
                                EmployeeWorkDate_GCC."First Half Leave Type" := LeaveType."Leave Type Id";
                                EmployeeWorkDate_GCC."Second Half Leave Type" := LeaveType."Leave Type Id";
                            end;
                end;

                if "End Date" = EmployeeWorkDate_GCC."Trans Date" then begin
                    if "Leave End Day Type" = "Leave End Day Type"::"First Half" then
                        EmployeeWorkDate_GCC."First Half Leave Type" := LeaveType."Leave Type Id"
                    else
                        if "Leave End Day Type" = "Leave End Day Type"::"Full Day" then begin
                            EmployeeWorkDate_GCC."First Half Leave Type" := LeaveType."Leave Type Id";
                            EmployeeWorkDate_GCC."Second Half Leave Type" := LeaveType."Leave Type Id";
                        end;
                end;

                if ("Start Date" <> EmployeeWorkDate_GCC."Trans Date") AND ("End Date" <> EmployeeWorkDate_GCC."Trans Date") then begin //21.10.2020
                    EmployeeWorkDate_GCC."First Half Leave Type" := LeaveType."Leave Type Id";
                    EmployeeWorkDate_GCC."Second Half Leave Type" := LeaveType."Leave Type Id";
                end;
                EmployeeWorkDate_GCC.MODIFY;
            until EmployeeWorkDate_GCC.NEXT = 0;
    end;

    procedure Reopen(var Rec: Record "Leave Request Header")
    begin
        if Rec.FindSet() then begin
            repeat
                if "Workflow Status" = "Workflow Status"::Open then
                    exit;
                "Workflow Status" := "Workflow Status"::Open;
                Rec.MODIFY;
            until Rec.Next() = 0;
        end;
    end;

    procedure UpdateLeaveAccrual()
    var
        AccrualComponentEmployee: Record "Accrual Components Employee";
        EmployeeInterimAccruals: Record "Employee Interim Accurals";
        NoOfLeaveDaysFirstMonth: Decimal;
        NoOfLeaveDaysSecondMonth: Decimal;
        Period: Record Date;
        InterimLedgerEntryNo: Integer;
    begin
        LeaveType.RESET;
        LeaveType.SETRANGE(LeaveType.Worker, Rec."Personnel Number");
        LeaveType.SETRANGE("Leave Type Id", Rec."Leave Type");
        LeaveType.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if LeaveType.FINDFIRST then;
    end;

    local procedure CreateBenefitAgjustmentJnlLines(BenefitAdjJnlHeader: Record "Benefit Adjmt. Journal header")
    var
        BenefitAdjustmentLines: Record "Benefit Adjmt. Journal Lines";
        LineNo: Integer;
    begin
        if BenefitAdjJnlHeader.FindFirst() then begin
            repeat
                LineNo += 10000;
                BenefitAdjustmentLines.INIT;
                BenefitAdjustmentLines."Journal No." := BenefitAdjJnlHeader."Journal No.";
                BenefitAdjustmentLines."Line No." := LineNo;
                BenefitAdjustmentLines.INSERT;
                BenefitAdjustmentLines."Employee Code" := BenefitAdjJnlHeader."Defaualt Employee";
                BenefitAdjustmentLines.Amount := "Leave Days" * -1;
                BenefitAdjustmentLines.MODIFY;
            until BenefitAdjJnlHeader.Next() = 0;
        end;
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

    procedure UpdateOntimeResumption()
    begin
        if "End Date" >= WORKDATE then
            ERROR('You Cannot update Ontime resumption before your leave end date');

        "Resumption Type" := "Resumption Type"::"On Time Resumption";

        EmployeeWorkDate_GCC.RESET;
        EmployeeWorkDate_GCC.SETRANGE("Employee Code", "Personnel Number");
        EmployeeWorkDate_GCC.SETFILTER("Trans Date", '>%1', "End Date");
        EmployeeWorkDate_GCC.SETRANGE("Calculation Type", EmployeeWorkDate_GCC."Calculation Type"::"Working Day");
        if EmployeeWorkDate_GCC.FINDFIRST then begin
            "Resumption Date" := EmployeeWorkDate_GCC."Trans Date";
            "Net Leave Days" := "Leave Days";
        end;
    end;

    procedure PostLeaveCancel(var LeaveRequestHeader: Record "Leave Request Header")
    var
    begin
        Employee.GET("Personnel Number");
        LeaveType.RESET;
        LeaveType.SETRANGE(LeaveType.Worker, Rec."Personnel Number");
        LeaveType.SETRANGE("Leave Type Id", Rec."Leave Type");
        LeaveType.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        if LeaveType.FINDFIRST then;
        LeaveType.TESTFIELD(Active);
        "Workflow Status" := "Workflow Status"::Rejected;
        UpdateEmployeeWorkDate;
        Posted := true;
        MODIFY;
    end;

    procedure UpdateEmployeeWorkDate()
    var
        Leave: Record "HCM Leave Types";
    begin
        TESTFIELD("Personnel Number");
        Leave.RESET;
        Leave.SETRANGE("Is System Defined", true);
        if Leave.FINDFIRST then begin
            EmployeeWorkDate_GCC.RESET;
            EmployeeWorkDate_GCC.SETRANGE("Employee Code", "Personnel Number");
            EmployeeWorkDate_GCC.SETRANGE("Trans Date", "Start Date", "End Date");
            if EmployeeWorkDate_GCC.FINDFIRST then
                repeat
                    if "Start Date" = EmployeeWorkDate_GCC."Trans Date" then begin
                        if "Leave Start Day Type" = "Leave Start Day Type"::"First Half" then
                            EmployeeWorkDate_GCC."First Half Leave Type" := Leave."Leave Type Id"
                        else
                            if "Leave Start Day Type" = "Leave Start Day Type"::"Second Half" then
                                EmployeeWorkDate_GCC."Second Half Leave Type" := Leave."Leave Type Id"
                            else
                                if "Leave Start Day Type" = "Leave Start Day Type"::"Full Day" then begin
                                    EmployeeWorkDate_GCC."First Half Leave Type" := Leave."Leave Type Id";
                                    EmployeeWorkDate_GCC."Second Half Leave Type" := Leave."Leave Type Id";
                                end;
                    end;

                    if "End Date" = EmployeeWorkDate_GCC."Trans Date" then begin
                        if "Leave End Day Type" = "Leave End Day Type"::"First Half" then
                            EmployeeWorkDate_GCC."First Half Leave Type" := Leave."Leave Type Id"
                        else
                            if "Leave End Day Type" = "Leave End Day Type"::"Full Day" then begin
                                EmployeeWorkDate_GCC."First Half Leave Type" := Leave."Leave Type Id";
                                EmployeeWorkDate_GCC."Second Half Leave Type" := Leave."Leave Type Id";
                            end;
                    end;

                    if ("Start Date" <> EmployeeWorkDate_GCC."Trans Date") or ("End Date" <> EmployeeWorkDate_GCC."Trans Date") then begin
                        EmployeeWorkDate_GCC."First Half Leave Type" := Leave."Leave Type Id";
                        EmployeeWorkDate_GCC."Second Half Leave Type" := Leave."Leave Type Id";
                    end;
                    EmployeeWorkDate_GCC.MODIFY;
                until EmployeeWorkDate_GCC.NEXT = 0;
        end;
    end;


    procedure CalCulateLeaveBalance()
    var
        HCMLeaveTypeRecL: Record "HCM Leave Types";
        RecAccrualCompEmp: Record "Accrual Components Employee";
        RecEmpInterAccLines: Record "Employee Interim Accurals";
        RecLeaveRequest: Record "Leave Request Header";
        EmployeeInterimAccuralsL: Record "Employee Interim Accurals";
        HCMLeaveTypeWrkRecL: Record "HCM Leave Types Wrkr";
        HCMLeaveTypeWrkRecL1: Record "HCM Leave Types Wrkr";
        YearL: Integer;
        TotalAMTL: Decimal;
    begin
        HCMLeaveTypeWrkRecL.Reset();
        HCMLeaveTypeWrkRecL.SetRange(Worker, Rec."Personnel Number");
        HCMLeaveTypeWrkRecL.SetRange("Leave Type Id", Rec."Leave Type");
        HCMLeaveTypeWrkRecL.SetRange(Accrued, true);
        if HCMLeaveTypeWrkRecL.FindFirst() then begin
            if HCMLeaveTypeWrkRecL."Accrual ID" = '' then begin
                Validate("Entitlement Days", HCMLeaveTypeWrkRecL."Entitlement Days");
            end else begin
                EmployeeInterimAccuralsL.Reset();
                Clear(YearL);
                YearL := Date2DMY(WorkDate(), 3);
                EmployeeInterimAccuralsL.SetRange("Accrual ID", HCMLeaveTypeWrkRecL."Accrual ID");
                EmployeeInterimAccuralsL.SetFilter("Start Date", '>=%1', DMY2Date(01, 01, YearL));
                EmployeeInterimAccuralsL.SetFilter("End Date", '<=%1', DMY2Date(31, 01, YearL + 1));
                EmployeeInterimAccuralsL.SetRange("Worker ID", Rec."Personnel Number");
                EmployeeInterimAccuralsL.CalcSums("Monthly Accrual Units", "Adjustment Units");
                TotalAMTL := EmployeeInterimAccuralsL."Monthly Accrual Units" + EmployeeInterimAccuralsL."Adjustment Units";
                EmployeeInterimAccuralsL.SetRange("Carryforward Month", true);
                EmployeeInterimAccuralsL.CalcSums("Opening Balance Unit", "Carryforward Deduction");
                TotalAMTL += EmployeeInterimAccuralsL."Opening Balance Unit" + EmployeeInterimAccuralsL."Carryforward Deduction";
                Validate("Entitlement Days", TotalAMTL);
            end;
        end else begin
            HCMLeaveTypeWrkRecL1.Reset();
            HCMLeaveTypeWrkRecL1.SetRange(Worker, Rec."Personnel Number");
            HCMLeaveTypeWrkRecL1.SetRange("Leave Type Id", Rec."Leave Type");
            HCMLeaveTypeWrkRecL1.SetRange(Accrued, false);
            if HCMLeaveTypeWrkRecL1.FindFirst() then
                Validate("Entitlement Days", HCMLeaveTypeWrkRecL1."Entitlement Days");
        end;

        Clear(RecLeaveRequest);
        RecLeaveRequest.SetRange("Personnel Number", Rec."Personnel Number");
        RecLeaveRequest.SetRange(Posted, True);
        RecLeaveRequest.SetRange("Leave Cancelled", false);
        RecLeaveRequest.SetFilter("Start Date", '>%1', CALCDATE('<-CY>', WorkDate()));
        RecLeaveRequest.SetFilter("End Date", '>%1', CALCDATE('<CY>', WorkDate()));
        if RecLeaveRequest.FindSet() then begin
            RecLeaveRequest.CalcSums("Leave Days");
            Validate("Consumed Leaves", RecLeaveRequest."Leave Days");
        end;
    end;

    procedure ConsumeBalance(): Decimal
    var
        EmployeeWorkDate_GCCRecL: Record EmployeeWorkDate_GCC;
        LastDate: Date;
        FirstDate: Date;
        CountFirstHalf: Decimal;
        CountSecondHalf: Decimal;

    begin
        Clear(CountFirstHalf);
        Clear(CountSecondHalf);
        CountFirstHalf := 0;
        CountSecondHalf := 0;

        LastDate := CALCDATE('CY', "Start Date");
        FirstDate := CALCDATE('-CY', "Start Date");
        EmployeeWorkDate_GCCRecL.Reset();
        EmployeeWorkDate_GCCRecL.SetRange("Employee Code", "Personnel Number");
        EmployeeWorkDate_GCCRecL.SetRange("First Half Leave Type", "Leave Type");
        EmployeeWorkDate_GCCRecL.SetFilter("Trans Date", '%1..%2', FirstDate, LastDate);
        if EmployeeWorkDate_GCCRecL.FindSet() then
            CountFirstHalf := EmployeeWorkDate_GCCRecL.Count;

        EmployeeWorkDate_GCCRecL.Reset();
        EmployeeWorkDate_GCCRecL.SetRange("Employee Code", "Personnel Number");
        EmployeeWorkDate_GCCRecL.SetRange("Second Half Leave Type", "Leave Type");
        EmployeeWorkDate_GCCRecL.SetFilter("Trans Date", '%1..%2', FirstDate, LastDate);
        if EmployeeWorkDate_GCCRecL.FindSet() then
            CountSecondHalf := EmployeeWorkDate_GCCRecL.Count;
        exit(((CountFirstHalf + CountSecondHalf) * 0.5));

    end;

    procedure CheckStartEndDateYearBothSame()
    var
        StartDateYearL: Integer;
        EndDateYearL: Integer;
    begin
        if "Start Date" <> 0D then
            StartDateYearL := DATE2DMY("Start Date", 3);

        if "End Date" <> 0D then
            EndDateYearL := DATE2DMY("End Date", 3);

        if "End Date" <> 0D then
            if StartDateYearL <> EndDateYearL then
                Error('Leaves cannot be applied for different years.');


        if ("Start Date" <> 0D) AND ("End Date" <> 0D) then
            if StartDateYearL <> EndDateYearL then
                Error('Leaves cannot be applied for different years.');
    end;
}