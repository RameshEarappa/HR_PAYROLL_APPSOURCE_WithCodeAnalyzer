table 60049 "Cancel Leave Request"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Leave Request ID"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Personnel Number"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Leave Type"; Code[20])
        {
            TableRelation = "HCM Leave Types Wrkr"."Leave Type Id" WHERE(Worker = FIELD("Personnel Number"),
                                                                          "Earning Code Group" = FIELD("Earning Code Group"));
            DataClassification = CustomerContent;
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
        }
        field(9; "Leave Start Day Type"; Option)
        {
            OptionCaption = 'Full Day,First Half,Second Half';
            OptionMembers = "Full Day","First Half","Second Half";
            DataClassification = CustomerContent;
        }
        field(10; "End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Leave End Day Type"; Option)
        {
            OptionCaption = 'Full Day,First Half';
            OptionMembers = "Full Day","First Half";
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
        field(51; RecId; RecordId)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Submission Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Workflow Status"; Option)
        {
            OptionCaption = 'Not Submitted,Submitted,Approved,Cancelled,Rejected,Open,Pending For Approval';
            OptionMembers = "Not Submitted",Submitted,Approved,Cancelled,Rejected,Open,"Pending For Approval";
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
        field(22; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Created Date Time"; DateTime)
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
        field(28; "Earning Code Group"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Cancel Remarks"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(31; "Cancel Leave Posted"; Boolean)
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
    end;

    trigger OnInsert()
    begin

        RecID := RecordId;
        "Created By" := USERID;
        "Created Date Time" := CURRENTDATETIME;
        "Workflow Status" := "Workflow Status"::Open;
    end;

    var
        Employee: Record Employee;
        LeaveType: Record "HCM Leave Types";
        EmployeeWorkDate_GCC: Record EmployeeWorkDate_GCC;

    procedure PostLeaveCancel(var CancelLeave: Record "Cancel Leave Request")
    var
        AccrualCompCalc: Codeunit "Accrual Component Calculate";
        LeaveRequestHeaderRecL: Record "Leave Request Header";
    begin
        Employee.GET("Personnel Number");
        UpdateEmployeeWorkDate;
        AccrualCompCalc.ValidateAccrualLeaves("Personnel Number",
                                               "Leave Type",
                                               "Start Date",
                                               "End Date",
                                               "Earning Code Group",
                                               LeaveType."Accrual ID",
                                               "Leave Days");

        AccrualCompCalc.OnAfterValidateAccrualLeaves("Personnel Number",
                                                      "Start Date",
                                                      "Leave Type",
                                                      "Earning Code Group");
        "Leave Cancelled" := true;
        MODIFY;
        LeaveRequestHeaderRecL.Reset();
        LeaveRequestHeaderRecL.SetRange("Leave Request ID", Rec."Leave Request ID");
        if LeaveRequestHeaderRecL.FindFirst() then begin
            LeaveRequestHeaderRecL."Leave Cancelled" := true;
            LeaveRequestHeaderRecL.Modify();
        end;
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

    procedure Reopen(Rec: Record "Cancel Leave Request")
    begin
        if Rec.FindSet() then begin
            repeat
                if "Workflow Status" = "Workflow Status"::Open then
                    exit;
                "Workflow Status" := "Workflow Status"::Open;
            until Rec.Next() = 0;
        end;
    end;
}