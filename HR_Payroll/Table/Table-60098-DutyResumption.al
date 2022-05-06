table 60098 "Duty Resumption"
{
    Caption = 'Duty Resumption';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Leave Request ID"; Code[20])
        {
            Caption = 'Leave Request ID';
            DataClassification = CustomerContent;
        }
        field(2; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(3; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(4; "Leave Type"; Code[20])
        {
            Caption = 'Leave Type';
            DataClassification = CustomerContent;
        }
        field(5; "Personnel Number"; Code[20])
        {
            Caption = 'Personnel Number';
            DataClassification = CustomerContent;
        }
        field(6; "Workflow Status"; Option)
        {
            Caption = 'Workflow Status';
            OptionCaption = 'Open,Approved,Send for Approval,Rejected';
            OptionMembers = Open,Released,"Pending Approval",Rejected;
            DataClassification = CustomerContent;
        }
        field(7; "Resumption Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD("Workflow Status", "Workflow Status"::Open);
                if "Resumption Date" <> 0D then begin
                    if ("Resumption Date" < "Start Date") then
                        ERROR(Text001);
                end;
            end;
        }
        field(8; "Resumption Type"; Option)
        {
            Caption = 'Resumption Type';
            OptionCaption = ' ,On Time Resumption,Late Resumption,Early Resumption';
            OptionMembers = " ","On Time Resumption","Late Resumption","Early Resumption";
            DataClassification = CustomerContent;
        }
        field(51; RecID; RecordId)
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
    }

    trigger OnDelete()
    begin
        TESTFIELD("Workflow Status", "Workflow Status"::Open);
        if not CONFIRM('Do you want to delete the record?') then
            exit;
    end;

    trigger OnModify()
    begin
        if "Workflow Status" = "Workflow Status"::Released then begin
            if "Resumption Date" <= "End Date" then
                EarlyResume;

            if "Resumption Date" = "End Date" + 1 then
                OnTimeResume;

            if "Resumption Date" >= "End Date" + 2 then begin
                LeaveExtLines;
                COMMIT;
                PostLeaveReq;
            end;
        end;
    end;

    trigger OnInsert()
    begin
        RecID := RecordId;
    end;

    var
        Text001: Label 'Date is Invalid';
        LeaveReqHeader: Record "Leave Request Header";
        T_DutyResmue: Record "Duty Resumption";
        EmpWorkDate: Record EmployeeWorkDate_GCC;
        LeaveType: Record "HCM Leave Types ErnGrp";
        Employee: Record Employee;
        LeaveReqLines: Record "Leave Extension";
        AdvancePayrollSetup: Record "Advance Payroll Setup";
        LeaveReqHeader1: Record "Leave Request Header";
        NoSeriesMngmnt: Codeunit NoSeriesManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        [InDataSet]
        ExtensionLineVisible: Boolean;

    procedure LeaveExtLines()
    var
        L_LeaveExtLines: Record "Leave Extension";
        L_LeaveReqHeader: Record "Leave Request Header";
    begin
        if "Workflow Status" = "Workflow Status"::Released then begin
            AdvancePayrollSetup.GET;
            LeaveReqLines.RESET;
            LeaveReqLines.SETRANGE("Leave Request ID", "Leave Request ID");
            LeaveReqLines.SETRANGE("Personnel Number", "Personnel Number");
            if LeaveReqLines.FINDSET then begin
                repeat
                    LeaveReqHeader.INIT;
                    LeaveReqHeader."Leave Request ID" := NoSeriesMngmnt.GetNextNo(AdvancePayrollSetup."Leave Request Nos.", TODAY, true);
                    LeaveReqHeader.VALIDATE("Personnel Number", "Personnel Number");
                    LeaveReqHeader.VALIDATE("Leave Type", LeaveReqLines."Leave Type");
                    LeaveReqHeader.VALIDATE("Start Date", LeaveReqLines."Start Date");
                    LeaveReqHeader.VALIDATE("End Date", LeaveReqLines."End Date");
                    LeaveReqHeader."Submission Date" := TODAY;
                    LeaveReqHeader."Created By" := USERID;
                    LeaveReqHeader."Created Date" := TODAY;
                    LeaveReqHeader."Created Date Time" := CURRENTDATETIME;
                    LeaveReqHeader."Resumption Date" := "Resumption Date";
                    LeaveReqHeader."Resumption Type" := LeaveReqHeader."Resumption Type"::"Late Resumption";
                    LeaveReqHeader."Duty Resumption Request" := true;
                    LeaveReqHeader."Duty Resumption ID" := LeaveReqLines."Leave Request ID";
                    LeaveReqHeader."Workflow Status" := LeaveReqHeader."Workflow Status"::Released;
                    LeaveReqHeader.INSERT;
                until LeaveReqLines.NEXT = 0;
                COMMIT;
            end;
        end;
    end;

    procedure EarlyResume()
    begin
        if "Workflow Status" = "Workflow Status"::Released then begin
            CLEAR(EmpWorkDate);
            CLEAR(LeaveType);
            CLEAR(LeaveReqHeader);
            if "Resumption Date" <= "End Date" then begin
                EmpWorkDate.RESET;
                EmpWorkDate.SETCURRENTKEY("Employee Code", "Trans Date");
                EmpWorkDate.SETRANGE("Employee Code", "Personnel Number");
                EmpWorkDate.SETRANGE("Trans Date", "Resumption Date", "End Date");
                if EmpWorkDate.FINDSET then begin
                    repeat
                        LeaveType.SETRANGE("Earning Code Group", EmpWorkDate."Employee Earning Group");
                        LeaveType.SETRANGE("Is System Defined", true);
                        if LeaveType.FINDFIRST then begin
                            EmpWorkDate.VALIDATE("First Half Leave Type", LeaveType."Short Name");
                            EmpWorkDate.VALIDATE("Second Half Leave Type", LeaveType."Short Name");
                            EmpWorkDate.MODIFY
                        end;
                    until EmpWorkDate.NEXT = 0;

                    LeaveReqHeader.SETCURRENTKEY("Leave Request ID");
                    LeaveReqHeader.SETRANGE("Leave Request ID", "Leave Request ID");
                    if LeaveReqHeader.FINDFIRST then begin
                        LeaveReqHeader.VALIDATE("Resumption Date", "Resumption Date");
                        LeaveReqHeader.VALIDATE("Resumption Type", LeaveReqHeader."Resumption Type"::"Early Resumption");
                        LeaveReqHeader.MODIFY;
                    end;
                end;
            end;
        end;
    end;

    procedure OnTimeResume()
    begin
        if "Workflow Status" = "Workflow Status"::Released then begin
            CLEAR(LeaveReqHeader);
            if "Resumption Date" = "End Date" + 1 then begin
                LeaveReqHeader.SETCURRENTKEY("Leave Request ID");
                LeaveReqHeader.SETRANGE("Leave Request ID", "Leave Request ID");
                if LeaveReqHeader.FINDFIRST then begin
                    VALIDATE("Resumption Type", "Resumption Type"::"On Time Resumption");
                    LeaveReqHeader.VALIDATE("Resumption Date", "Resumption Date");
                    LeaveReqHeader.VALIDATE("Resumption Type", LeaveReqHeader."Resumption Type"::"On Time Resumption");
                    LeaveReqHeader.MODIFY;
                end;
            end;
        end;
    end;

    procedure PostLeaveReq(): Boolean
    var
        L_LeaveReqHead: Record "Leave Request Header";
    begin
        LeaveReqLines.RESET;
        LeaveReqLines.SETRANGE("Leave Request ID", "Leave Request ID");
        LeaveReqLines.SETRANGE("Personnel Number", "Personnel Number");
        if LeaveReqLines.FINDSET then
            repeat
                LeaveReqHeader1.RESET;
                LeaveReqHeader1.SETRANGE("Duty Resumption ID", LeaveReqLines."Leave Request ID");
                LeaveReqHeader1.SETRANGE("Personnel Number", LeaveReqLines."Personnel Number");
                LeaveReqHeader1.SETRANGE("Leave Type", LeaveReqLines."Leave Type");
                LeaveReqHeader1.SETRANGE("Start Date", LeaveReqLines."Start Date");
                LeaveReqHeader1.SETRANGE("End Date", LeaveReqLines."End Date");
                LeaveReqHeader1.SETRANGE("Resumption Type", LeaveReqHeader1."Resumption Type"::"Late Resumption");
                LeaveReqHeader1.SETRANGE("Duty Resumption Request", true);
                if LeaveReqHeader1.FINDFIRST then begin
                    REPEAT
                        LeaveReqHeader1.TESTFIELD("Workflow Status", LeaveReqHeader1."Workflow Status"::Released);
                        LeaveReqHeader1.TESTFIELD(Posted, false);
                        if LeaveReqHeader.GET(LeaveReqHeader1."Leave Request ID") then
                            LeaveReqHeader1.PostLeave(LeaveReqHeader);
                    UNTIL LeaveReqHeader1.NEXT = 0;
                end;
            until LeaveReqLines.NEXT = 0;
    end;
}