page 60203 "Leave Request Card_RC"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Leave Request Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = (Rec."Workflow Status" <> Rec."Workflow Status"::Released) AND (Rec."Workflow Status" <> Rec."Workflow Status"::Rejected);
                field("Leave Request ID"; Rec."Leave Request ID")
                {
                    ApplicationArea = All;
                }
                field("Personnel Number"; Rec."Personnel Number")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = All;
                }
                field("Short Name"; Rec."Short Name")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Start Day Type"; Rec."Leave Start Day Type")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Leave End Day Type"; Rec."Leave End Day Type")
                {
                    ApplicationArea = All;
                }
                field("Alternative Start Date"; Rec."Alternative Start Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Leave Days"; Rec."Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Leave Remarks"; Rec."Leave Remarks")
                {
                    ApplicationArea = All;
                }
                field("Alternative End Date"; Rec."Alternative End Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(LTA; Rec.LTA)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Cover Resource"; Rec."Cover Resource")
                {
                    ApplicationArea = All;
                }
                field("Submission Date"; Rec."Submission Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Cancelled"; Rec."Leave Cancelled")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Planner ID"; Rec."Leave Planner ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                group("Resumption Details")
                {
                    Caption = 'Resumption Details';
                    field("Resumption Date"; Rec."Resumption Date")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Resumption Type"; Rec."Resumption Type")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Duty Resumption Request"; Rec."Duty Resumption Request")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Net Leave Days"; Rec."Net Leave Days")
                    {
                        Editable = false;
                        Visible = false;
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Submit For Approval")
            {
                Caption = 'Submit For Approval';
                Enabled = (NOT OpenApprovalEntriesExist) AND (Rec."Workflow Status" = Rec."Workflow Status"::Open);
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CancelAndDeleteApprovalEntryTrans_LT(Rec."Leave Request ID");
                    Rec.TESTFIELD(Posted, false);
                    if not CONFIRM('Do you want to Submit the leave request?') then
                        exit;

                    if Rec."Leave Days" = 0 then
                        ERROR('Leave days cannot be zero');
                    Rec.SubmitLeave(Rec);
                    LeaveRequestHeader.RESET;
                    Rec.TESTFIELD(Posted, false);
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Enabled = CanCancelApprovalForRecord;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                    if LeaveRequestHeader.FINDFIRST then begin
                        if LeaveRequestHeader."Workflow Status" = LeaveRequestHeader."Workflow Status"::Released then
                            ERROR('You cannot cancel approved leaves');

                        CancelAndDeleteApprovalEntryTrans_LT(Rec."Leave Request ID");
                    end;
                end;
            }
            action(Reopen)
            {
                Enabled = (Rec."Workflow Status" <> Rec."Workflow Status"::Open) AND (NOT Rec.Posted);
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec."Workflow Status" = Rec."Workflow Status"::"Pending For Approval" then
                        ERROR(Text001);

                    if Rec."Workflow Status" = Rec."Workflow Status"::Rejected then
                        ERROR('You Cannot reopen Cancelled Leave request');
                    Rec.TESTFIELD(Posted, false);
                    Rec.Reopen(Rec);
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Enabled = EnableLeavePost;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not CONFIRM('Do you want to post the leave request?') then
                        exit;

                    CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                    if LeaveRequestHeader.FINDFIRST then begin
                        if LeaveRequestHeader."Leave Days" = 0 then
                            ERROR('Leave days cannot be zero');
                        LeaveRequestHeader.TESTFIELD("Workflow Status", Rec."Workflow Status"::Released);
                        if LeaveRequestHeader.Posted then
                            ERROR('Leave request is already posted');
                        if not (LeaveRequestHeader."Workflow Status" = LeaveRequestHeader."Workflow Status"::Released) then
                            ERROR('Workflow Status must be Approved, Current value is %1', LeaveRequestHeader."Workflow Status");
                        Rec.PostLeave(LeaveRequestHeader);
                    end;
                end;
            }
            action("Check Postion")
            {
                Caption = 'Check Postion';
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;
            }
            group(Resumption)
            {
                Caption = 'Resumption';
                action("Duty Resumption")
                {
                    Caption = 'Duty Resumption';
                    Enabled = DutyResumeEdit;
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Posted, true);
                        CreateDutyResumptionEntry;
                    end;
                }
                action("Late Resumption")
                {
                    Caption = 'Late Resumption';
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                    ApplicationArea = All;
                }
                action("On Time Resumption")
                {
                    Caption = 'On Time Resumption';
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        if not CONFIRM('Do you want to Update On Time Resumption?') then
                            exit;

                        CurrPage.SETSELECTIONFILTER(LeaveRequestHeader);
                        Rec.UpdateOntimeResumption;
                    end;
                }
                action("Cancel Leave Request")
                {
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CancelLeaveRequest: Record "Cancel Leave Request";
                    begin
                        CancelLeaveRequest.RESET;
                        CancelLeaveRequest.SETRANGE("Leave Request ID", Rec."Leave Request ID");
                        if not CancelLeaveRequest.FINDFIRST then begin
                            if not CONFIRM('Do you want to Cancel the Leave Request ?', true) then
                                exit;
                            CancelLeaveRequest.INIT;
                            CancelLeaveRequest.TRANSFERFIELDS(Rec);
                            CancelLeaveRequest."Workflow Status" := CancelLeaveRequest."Workflow Status"::Open;
                            CancelLeaveRequest."Created Date" := WORKDATE;
                            CancelLeaveRequest."Created By" := USERID;
                            CancelLeaveRequest."Created Date Time" := CURRENTDATETIME;
                            CancelLeaveRequest."Submission Date" := 0D;
                            CancelLeaveRequest.INSERT;
                            COMMIT;
                        end;
                        PAGE.RUNMODAL(60065, CancelLeaveRequest);
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility;
    end;

    var
        DutyResume: Record "Duty Resumption";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        P_DutyResume: Page "Duty Resumption";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        Text001: Label 'The approval process must be cancelled or completed to reopen this document.';
        LeaveRequestHeader: Record "Leave Request Header";
        EnableLeavePost: Boolean;
        EditLeaveRequest: Boolean;
        [InDataSet]
        DutyResumeEdit: Boolean;
        i: Integer;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        if Rec.Posted then
            EnableLeavePost := false
        else
            EnableLeavePost := true;

        if Rec."Leave Request ID" <> '' then begin
            if (Rec."Workflow Status" = Rec."Workflow Status"::Open) then
                EditLeaveRequest := true
            else
                EditLeaveRequest := false;
        end;

        if Rec."Duty Resumption Request" then
            DutyResumeEdit := false
        else
            DutyResumeEdit := true;
    end;

    procedure CreateDutyResumptionEntry()
    var
        Text00001: Label 'Duty Resumption Entries already exist';
    begin
        DutyResume.RESET;
        if not DutyResume.GET(Rec."Leave Request ID") then begin
            DutyResume.INIT;
            DutyResume.VALIDATE("Leave Request ID", Rec."Leave Request ID");
            DutyResume.VALIDATE("Personnel Number", Rec."Personnel Number");
            DutyResume.VALIDATE("Start Date", Rec."Start Date");
            DutyResume.VALIDATE("End Date", Rec."End Date");
            DutyResume.VALIDATE("Leave Type", Rec."Leave Type");
            DutyResume.INSERT;
        end;
        CLEAR(P_DutyResume);
        CLEAR(DutyResume);
        DutyResume.SETRANGE("Leave Request ID", Rec."Leave Request ID");
        if DutyResume.FINDFIRST then begin
            Rec.FILTERGROUP(2);
            P_DutyResume.SETTABLEVIEW(DutyResume);
            P_DutyResume.RUN;
            Rec.FILTERGROUP(0);
        end;
    end;

    procedure GetEmployeePostionEmployeeID_LT(EmployeeID: Code[30]): Code[50]
    var
        PayrollJobPosWorkerAssignRec_L: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRec_L: Record "Payroll Position";
    begin
        PayrollJobPosWorkerAssignRec_L.RESET;
        PayrollJobPosWorkerAssignRec_L.SETRANGE(Worker, EmployeeID);
        PayrollJobPosWorkerAssignRec_L.SETRANGE("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRec_L.FINDFIRST then begin
            PayrollPositionRec_L.RESET;
            PayrollPositionRec_L.SETRANGE("Position ID", PayrollJobPosWorkerAssignRec_L."Position ID");
            if PayrollPositionRec_L.FINDFIRST then
                exit(PayrollPositionRec_L.Worker);
        end;
    end;

    procedure InsertApprovalEntryTrans_LT(TransID: Code[30]; SenderID: Code[50]; ReportingID: Code[50]; DelegateID: Code[50]; SequenceID: Integer)
    var
        ApprovalEntrtyTranscationRec_L: Record "Approval Entrty Transcation";
    begin
        ApprovalEntrtyTranscationRec_L.RESET;
        ApprovalEntrtyTranscationRec_L.INIT;
        ApprovalEntrtyTranscationRec_L."Trans ID" := TransID;
        ApprovalEntrtyTranscationRec_L."Advance Payrolll Type" := ApprovalEntrtyTranscationRec_L."Advance Payrolll Type"::Leaves;
        ApprovalEntrtyTranscationRec_L."Employee ID - Sender" := SenderID;
        ApprovalEntrtyTranscationRec_L."Reporting ID - Approver" := ReportingID;
        ApprovalEntrtyTranscationRec_L."Delegate ID" := DelegateID;
        ApprovalEntrtyTranscationRec_L."Sequence No." := SequenceID;
        ApprovalEntrtyTranscationRec_L.INSERT;
    end;

    procedure LoopOfSeq_LT(EmpID: Code[50]; TransID: Code[30])
    var
        ApprovalLevelSetupRec_L: Record "Approval Level Setup";
        UserSetupRec_L: Record "User Setup";
        UserSetupRec2_L: Record "User Setup";
        OneEmpID: Code[50];
        TwoEmpID: Code[50];
        ThreeEmpID: Code[50];
        PreEmpID: Code[50];
        SenderID_L: Code[50];
        ReportingID_L: Code[50];
        CountForLoop_L: Integer;
        Delegate_L: Code[80];
        SeqNo_L: Integer;
    begin
        CLEAR(SenderID_L);
        CLEAR(ReportingID_L);
        CLEAR(OneEmpID);
        CLEAR(TwoEmpID);
        CLEAR(ThreeEmpID);
        CLEAR(Delegate_L);

        ApprovalLevelSetupRec_L.RESET;
        ApprovalLevelSetupRec_L.SETRANGE("Advance Payrolll Type", ApprovalLevelSetupRec_L."Advance Payrolll Type"::Leaves);
        if ApprovalLevelSetupRec_L.FINDFIRST then begin
            SenderID_L := EmpID;
            CountForLoop_L := ApprovalLevelSetupRec_L.Level;
            SeqNo_L := 0;
            for i := 1 to CountForLoop_L do begin
                ReportingID_L := GetEmployeePostionEmployeeID_LT(SenderID_L);

                if GetEmployeePostionEmployeeID_FinalPosituion_LT(SenderID_L) then begin
                    if (ReportingID_L = '') then begin//(i = 1) AND
                        ReportingID_L := SenderID_L;
                    end;
                    i := ApprovalLevelSetupRec_L.Level + 1;
                end;
                SeqNo_L += 1;

                if ReportingID_L = '' then
                    ERROR('Next level Approval Position Not Define');

                UserSetupRec_L.RESET;
                UserSetupRec_L.SETRANGE("Employee Id", SenderID_L);
                if not UserSetupRec_L.FINDFIRST then
                    ERROR('Employee Id  %1 must have a value in User Setup', SenderID_L);
                UserSetupRec_L.TESTFIELD("User ID");

                UserSetupRec2_L.RESET;
                UserSetupRec2_L.SETRANGE("Employee Id", ReportingID_L);
                if not UserSetupRec2_L.FINDFIRST then
                    ERROR('Employee Id  %1 must have a value in User Setup', ReportingID_L);
                UserSetupRec2_L.TESTFIELD("User ID");

                Delegate_L := CheckDelegateForEmployee_LT(ReportingID_L);

                if i <= ApprovalLevelSetupRec_L.Level then
                    InsertApprovalEntryTrans_LT(TransID,
                                                 UserSetupRec_L."User ID",
                                                 UserSetupRec2_L."User ID",
                                                 Delegate_L,
                                                 SeqNo_L);

                if (GetEmployeePostionEmployeeID_FinalPosituion_LT(SenderID_L)) and (i > ApprovalLevelSetupRec_L.Level) then
                    InsertApprovalEntryTrans_LT(TransID,
                                                  UserSetupRec_L."User ID",
                                                  UserSetupRec2_L."User ID",
                                                  Delegate_L,
                                                  SeqNo_L);

                OneEmpID := SenderID_L;
                SenderID_L := ReportingID_L;
            end;
        end;
    end;

    procedure CancelAndDeleteApprovalEntryTrans_LT(DocNo_P: Code[50])
    var
        ApprovalEntrtyTranscation: Record "Approval Entrty Transcation";
    begin
        ApprovalEntrtyTranscation.RESET;
        ApprovalEntrtyTranscation.SETRANGE("Trans ID", DocNo_P);
        if ApprovalEntrtyTranscation.FINDSET then
            ApprovalEntrtyTranscation.DELETEALL;
    end;

    procedure CheckDelegateForEmployee_LT(EmployeeCode_P: Code[30]): Code[80]
    var
        DelegateWFLTRec_L: Record "Delegate - WFLT";
    begin
        DelegateWFLTRec_L.RESET;
        DelegateWFLTRec_L.SETCURRENTKEY("Employee Code");
        DelegateWFLTRec_L.SETRANGE("Employee Code", EmployeeCode_P);
        if DelegateWFLTRec_L.FINDLAST then
            if (WORKDATE >= DelegateWFLTRec_L."From Date") or (WORKDATE <= DelegateWFLTRec_L."To Date") then
                exit(DelegateWFLTRec_L."Delegate ID");
    end;

    procedure GetEmployeePostionEmployeeID_FinalPosituion_LT(EmployeeID: Code[30]): Boolean
    var
        PayrollJobPosWorkerAssignRec_L: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRec_L: Record "Payroll Position";
    begin
        PayrollJobPosWorkerAssignRec_L.RESET;
        PayrollJobPosWorkerAssignRec_L.SETRANGE(Worker, EmployeeID);
        PayrollJobPosWorkerAssignRec_L.SETRANGE("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRec_L.FINDFIRST then begin
            PayrollPositionRec_L.RESET;
            PayrollPositionRec_L.SETRANGE("Position ID", PayrollJobPosWorkerAssignRec_L."Position ID");
            if PayrollPositionRec_L.FINDFIRST then
                if PayrollPositionRec_L."Final authority" then
                    exit(true)
                else
                    exit(false);
        end;
    end;
}