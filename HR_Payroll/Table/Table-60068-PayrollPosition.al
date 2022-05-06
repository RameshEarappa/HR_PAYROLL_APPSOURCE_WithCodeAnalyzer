table 60068 "Payroll Position"
{
    DrillDownPageID = "Payroll Job Postions";
    LookupPageID = "Payroll Job Postions";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Position ID"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Position ID" <> xRec."Position ID" then begin
                    AdvancePayrollSetup.GET;
                    NoSeriesMngmnt.TestManual(AdvancePayrollSetup."Position No. Series");
                    AdvancePayrollSetup."Position No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Job; Code[20])
        {
            TableRelation = "Payroll Jobs";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if PayrollJobs.GET(Job) then
                    "Job Description" := PayrollJobs."Job Description"
                else
                    "Job Description" := '';

                CheckJobPosition_LT(Job);
            end;
        }
        field(4; Department; Code[20])
        {
            TableRelation = "Payroll Department";
            DataClassification = CustomerContent;
        }
        field(5; Title; Code[20])
        {
            TableRelation = "Payroll Job Title";
            DataClassification = CustomerContent;
        }
        field(6; "Position Type"; Option)
        {
            Description = 'PHASE 2 changes';
            OptionCaption = ' ,Full-Time,Part-Time';
            OptionMembers = " ","Full-Time","Part-Time";
            DataClassification = CustomerContent;
        }
        field(7; "Full Time Equivalent"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Full Time Equivalent" < 1 then
                    ERROR('Full time equivalent min value is 1');
            end;
        }
        field(8; "Compensation Region"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Available for Assignment"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Pay Cycle"; Code[20])
        {
            TableRelation = "Pay Cycles";
            DataClassification = CustomerContent;
        }
        field(11; "Work Cycle"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Paid By"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Organizational Officer"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Annual Regular Hours"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Pay Period Overtime Hours"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Generate Salary"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Generate Earning from Schedule"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(18; Schedule; Code[20])
        {
            TableRelation = "Work Calendar Header";
            DataClassification = CustomerContent;
        }
        field(19; "General Liability Insurance"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Default Earning Code"; Code[20])
        {
            TableRelation = "Payroll Earning Code";
            DataClassification = CustomerContent;
        }
        field(21; "Union Agreement Needed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Union Agreement"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Labour Union"; Code[20])
        {
            TableRelation = "Employee Contacts Line";
            DataClassification = CustomerContent;
        }
        field(24; "Agreement Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(25; "Legal Entity"; Text[100])
        {
            TableRelation = Company;
            DataClassification = CustomerContent;
        }
        field(26; "Valid From"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Valid To"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Reports to Position"; Code[20])
        {
            Caption = '1st Reporting';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                emp: Record Employee;
            begin
                ReportsToPosition.RESET;
                ReportsToPosition.FILTERGROUP(2);
                ReportsToPosition.SETFILTER("Position ID", '<>%1', "Position ID");
                ReportsToPosition.FILTERGROUP(0);
                if PAGE.RUNMODAL(0, ReportsToPosition) = ACTION::LookupOK then begin
                    "Reports to Position" := ReportsToPosition."Position ID";
                end;
                PosWorkerAssignment.RESET;
                PosWorkerAssignment.SETRANGE("Position ID", "Reports to Position");
                PosWorkerAssignment.SETFILTER("Assignment Start", '<=%1', WORKDATE);
                PosWorkerAssignment.SETFILTER("Assignment End", '>=%1|%2', WORKDATE, 0D);
                if PosWorkerAssignment.FINDFIRST then
                    Worker := PosWorkerAssignment.Worker;
                VALIDATE(Worker, PosWorkerAssignment.Worker);

                CLEAR(PosWorkerAssignment2);
                PosWorkerAssignment2.SETRANGE(PosWorkerAssignment2."Position ID", "Position ID");
                PosWorkerAssignment2.SETFILTER("Assignment Start", '<=%1', WORKDATE);
                PosWorkerAssignment2.SETFILTER("Assignment End", '>=%1|%2', WORKDATE, 0D);
                if PosWorkerAssignment2.FINDFIRST then begin
                    CLEAR(emp);
                    emp.SETRANGE("No.", PosWorkerAssignment2.Worker);
                    if emp.FINDFIRST then begin
                        emp."Line manager" := "Worker Name";
                        emp.MODIFY(true);
                    end;
                end;
            end;

            trigger OnValidate()
            var
                emp: Record Employee;
            begin
                PosWorkerAssignment.RESET;
                PosWorkerAssignment.SETRANGE("Position ID", "Reports to Position");
                PosWorkerAssignment.SETFILTER("Assignment Start", '<=%1', WORKDATE);
                PosWorkerAssignment.SETFILTER("Assignment End", '>=%1|%2', WORKDATE, 0D);
                if PosWorkerAssignment.FINDFIRST then begin
                    VALIDATE(Worker, PosWorkerAssignment.Worker);
                end;

                CLEAR(PosWorkerAssignment2);
                PosWorkerAssignment2.SETRANGE(PosWorkerAssignment2."Position ID", "Position ID");
                PosWorkerAssignment2.SETFILTER("Assignment Start", '<=%1', WORKDATE);
                PosWorkerAssignment2.SETFILTER("Assignment End", '>=%1|%2', WORKDATE, 0D);
                if PosWorkerAssignment2.FINDFIRST then begin
                    CLEAR(emp);
                    emp.SETRANGE("No.", PosWorkerAssignment2.Worker);
                    if emp.FINDFIRST then begin
                        emp."Line manager" := "Worker Name";
                        emp.MODIFY(true);
                    end;
                end;
            end;
        }
        field(29; "Earning Code Group"; Code[20])
        {
            TableRelation = "Earning Code Groups";
            DataClassification = CustomerContent;
        }
        field(30; Worker; Code[20])
        {
            Caption = 'Employee No.';
            Editable = false;
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Employee.GET(Worker) then
                    "Worker Name" := Employee."First Name" + ' ' + Employee."Last Name"
                else
                    "Worker Name" := '';
            end;
        }
        field(31; "Job Description"; Text[100])
        {
            Caption = 'Job Name';
            DataClassification = CustomerContent;
        }
        field(32; Effective; Date)
        {
            DataClassification = CustomerContent;
        }
        field(33; Expiration; Date)
        {
            DataClassification = CustomerContent;
        }
        field(34; "Second Reporting"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(35; "Open Position"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(36; "Inactive Position"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(37; "Worker Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(38; "Position Summary"; BLOB)
        {
            DataClassification = CustomerContent;
        }
        field(39; "Sub Department"; Code[20])
        {
            TableRelation = "Sub Department" WHERE("Department ID" = FIELD(Department));
            DataClassification = CustomerContent;
        }
        field(40; "Second Reports to Position"; Code[20])
        {
            Caption = '2nd Reporting';
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                ReportsToPosition.RESET;
                ReportsToPosition.FILTERGROUP(2);
                ReportsToPosition.SETFILTER("Position ID", '<>%1', "Position ID");
                ReportsToPosition.FILTERGROUP(0);
                if PAGE.RUNMODAL(0, ReportsToPosition) = ACTION::LookupOK then begin
                    "Second Reports to Position" := ReportsToPosition."Position ID";
                end;
                PosWorkerAssignment.RESET;
                PosWorkerAssignment.SETRANGE("Position ID", "Second Reports to Position");
                PosWorkerAssignment.SETFILTER("Assignment Start", '<=%1', WORKDATE);
                PosWorkerAssignment.SETFILTER("Assignment End", '>=%1|%2', WORKDATE, 0D);
                if PosWorkerAssignment.FINDFIRST then
                    "Second Worker" := PosWorkerAssignment.Worker;
                VALIDATE("Second Worker", PosWorkerAssignment.Worker);
            end;

            trigger OnValidate()
            begin
                PosWorkerAssignment.RESET;
                PosWorkerAssignment.SETRANGE("Position ID", "Second Reports to Position");
                PosWorkerAssignment.SETFILTER("Assignment Start", '<=%1', WORKDATE);
                PosWorkerAssignment.SETFILTER("Assignment End", '>=%1|%2', WORKDATE, 0D);
                if PosWorkerAssignment.FINDFIRST then begin
                    VALIDATE("Second Worker", PosWorkerAssignment.Worker);
                end;
            end;
        }
        field(41; "Second Worker"; Code[20])
        {
            Caption = 'Employee No.';
            Editable = false;
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Employee.GET("Second Worker") then
                    "Second Worker Name" := Employee."First Name" + ' ' + Employee."Last Name"
                else
                    "Second Worker Name" := '';
            end;
        }
        field(42; "Second Worker Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(43; "Final authority"; Boolean)
        {
            Description = '#WFLevtech';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Position ID")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
        key(Key3; "Available for Assignment")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Position ID", Description, "Available for Assignment")
        {
        }
    }

    trigger OnDelete()
    begin
        PosWorkerAssignment.RESET;
        PosWorkerAssignment.SETRANGE("Position ID", "Position ID");
        if PosWorkerAssignment.FINDFIRST then
            ERROR(Error001);

        EmployeeEarningCodeGroupsRec.RESET;
        EmployeeEarningCodeGroupsRec.SETRANGE(Position, "Position ID");
        if EmployeeEarningCodeGroupsRec.FINDFIRST then
            ERROR(Error001);
    end;

    trigger OnInsert()
    begin
        if "Position ID" = '' then begin
            AdvancePayrollSetup.GET;
            AdvancePayrollSetup.TESTFIELD("Position No. Series");
            "Position ID" := NoSeriesMngmnt.GetNextNo(AdvancePayrollSetup."Position No. Series", TODAY, true);
        end;
        "Full Time Equivalent" := 1;
        "Open Position" := true;
    end;

    var
        PayrollJobs: Record "Payroll Jobs";
        AdvancePayrollSetup: Record "Advance Payroll Setup";
        NoSeriesMngmnt: Codeunit NoSeriesManagement;
        ReportsToPosition: Record "Payroll Position";
        PosWorkerAssignment: Record "Payroll Job Pos. Worker Assign";
        Employee: Record Employee;
        PayrollPosition: Record "Payroll Position";
        PayrollPosDuration: Record "Payroll Position Duration";
        PayrollJobsRec_G: Record "Payroll Jobs";
        PayrollPositionRec_G: Record "Payroll Position";
        CountPosition_G: Integer;
        Error001: Label 'Position has already been created for the selected job. Cannot be deleted.';
        EmployeeEarningCodeGroupsRec: Record "Employee Earning Code Groups";
        PosWorkerAssignment2: Record "Payroll Job Pos. Worker Assign";

    procedure SetPositionSummary(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR("Position Summary");
        if NewWorkDescription = '' then
            exit;
        "Position Summary".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetPositionSummary(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS("Position Summary");
        if not "Position Summary".HASVALUE then
            exit('');
        CALCFIELDS("Position Summary");
        "Position Summary".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure UpdateOpenPositions()
    var
        PayrollWorkerAssign: Record "Payroll Job Pos. Worker Assign";
    begin
        PayrollWorkerAssign.RESET;
        PayrollWorkerAssign.SETRANGE("Position ID", Rec."Position ID");
        PayrollWorkerAssign.SETFILTER(Worker, '<>%1', '');
        if PayrollWorkerAssign.FINDFIRST then begin
            "Open Position" := false;
        end
        else begin
            "Open Position" := true;
        end;
    end;

    procedure CheckPositionActive()
    begin
        PayrollPosDuration.RESET;
        PayrollPosDuration.SETRANGE("Positin ID", Rec."Position ID");
        PayrollPosDuration.SETFILTER(Activation, '<=%', WORKDATE);
        PayrollPosDuration.SETFILTER(Retirement, '>=%1|%2', WORKDATE, 0D);
        if PayrollPosDuration.FINDFIRST then begin
            "Inactive Position" := false;
        end else begin
            "Inactive Position" := true;
        end;
    end;

    local procedure CheckJobPosition_LT(JobNo: Code[30])
    begin
        PayrollJobsRec_G.RESET;
        PayrollJobsRec_G.SETRANGE(Job, JobNo);
        if PayrollJobsRec_G.FINDFIRST then
            if PayrollJobsRec_G."Maximum Positions" then begin
                PayrollPositionRec_G.RESET;
                PayrollPositionRec_G.SETRANGE(Job, PayrollJobsRec_G.Job);
                if PayrollPositionRec_G.FINDSET then
                    repeat
                        CountPosition_G += 1;
                    until PayrollPositionRec_G.NEXT = 0;

                if CountPosition_G >= PayrollJobsRec_G."Max. No Of Positions" then
                    ERROR('Job %1 has reach maximum number of Count is %2', JobNo, PayrollJobsRec_G."Max. No Of Positions");
            end;
    end;
}