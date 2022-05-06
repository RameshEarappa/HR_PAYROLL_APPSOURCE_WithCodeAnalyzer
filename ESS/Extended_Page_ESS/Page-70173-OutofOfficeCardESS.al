page 70173 "Out of Office Card"
{
    Caption = 'Out of Office Request Card';
    PageType = Card;
    SourceTable = "Short Leave Header";
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = GenBoolG;
                field("Short Leave Request Id"; Rec."Short Leave Request Id")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Employee Id"; Rec."Employee Id")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Enabled = false;
                    ShowMandatory = true;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Line Manager"; Rec."Line Manager")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Pay Month"; Rec."Pay Month")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Permissible Short Leave Hrs"; Rec."Permissible Short Leave Hrs")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Monthly Cummulative Hrs"; Rec."Monthly Cummulative Hrs")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Balance of Short Leave Hours"; Rec."Balance of Short Leave Hours")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Total Acc. short leave hours"; Rec."Total Acc. short leave hours")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = all;
                    Enabled = false;
                }
                field("WorkFlow Status"; Rec."WorkFlow Status")
                {
                    ApplicationArea = all;
                    Enabled = false;
                }
            }
            part("Short Leave Request SubPage"; "Short Leave Request SubPage")
            {
                Caption = 'Out of Office';
                Editable = GenBoolG;
                SubPageLink = "Short Leave Request Id" = FIELD("Short Leave Request Id");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Comments1)
            {
                Caption = 'Comments';
                Image = Employee;
            }
            action(Comments)
            {
                Caption = 'Comments';
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "ShortLeaveComment1";
                RunPageLink = "Short Leave Request Id" = FIELD("Short Leave Request Id");
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ShortLeaveCommRec.RESET;
                    IF NOT ShortLeaveCommRec.GET(Rec."Short Leave Request Id") THEN BEGIN
                        ShortLeaveCommRec.INIT;
                        ShortLeaveCommRec."Short Leave Request Id" := Rec."Short Leave Request Id";
                        ShortLeaveCommRec.INSERT;
                    END
                end;
            }
            action(POST)
            {
                Image = PostBatch;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ShortLeaveLineRecL: Record "Short Leave Line";
                begin
                    Rec.TESTFIELD(Posted, FALSE);
                    Rec.TESTFIELD("Short Leave Request Id");
                    Rec.TESTFIELD("Employee Id");
                    Rec.TESTFIELD("Pay Period");

                    ShortLeaveLineRecL.RESET;
                    ShortLeaveLineRecL.SETRANGE("Short Leave Request Id", Rec."Short Leave Request Id");
                    ShortLeaveLineRecL.SETRANGE("Employee Id", Rec."Employee Id");
                    IF ShortLeaveLineRecL.FINDSET THEN BEGIN
                        REPEAT
                            ShortLeaveLineRecL.TESTFIELD("Req. Start Time");
                            ShortLeaveLineRecL.TESTFIELD("Req. End Time");
                        UNTIL ShortLeaveLineRecL.NEXT = 0;
                    END;
                    Rec.Posted := TRUE;
                    CurrPage.UPDATE(TRUE);
                end;
            }


            action(Approvals)
            {
                AccessByPermission = TableData "Approval Entry" = R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Promoted = true;
                PromotedCategory = Process;
                Image = Approvals;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Short Leave Header");
                    ApprovalEntry.SETRANGE("Record ID to Approve", Rec.RecordId);
                    ApprovalEntry.SETRANGE("Related to Change", FALSE);
                    PAGE.RUN(70010, ApprovalEntry);
                end;
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = VisibBool;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';
                    trigger OnAction()
                    var
                        ReqDateErr: Label 'The requested date should fall in pay period %1';
                        LineRec: Record "Short Leave Line";
                        Short_LeaveApprovalsMgmt: Codeunit InitCodeunit_Short_Leave_Req;
                        ShortLeaveLineRecL: Record "Short Leave Line";
                        AdvanceWorkflowCUL: Codeunit "Advance Workflow";
                    begin
                        Rec.TESTFIELD("Pay Month");
                        ShortLeaveLineRecL.Reset();
                        ShortLeaveLineRecL.SetRange("Short Leave Request Id", Rec."Short Leave Request Id");
                        ShortLeaveLineRecL.SetRange("Employee Id", Rec."Employee Id");
                        if ShortLeaveLineRecL.FindFirst() then begin
                        end;
                        LineRec.RESET;
                        LineRec.SETRANGE("Short Leave Request Id", Rec."Short Leave Request Id");
                        IF LineRec.FINDFIRST THEN;
                        LineRec.TESTFIELD("Req. End Time");
                        LineRec.TESTFIELD(Reason);
                        Rec.TESTFIELD("Request Date");
                        Rec.TESTFIELD("Employee Id");
                        Rec.TESTFIELD(Posted, FALSE);
                        IF Short_LeaveApprovalsMgmt.Is_ShortLeaveReq_ApprovalWorkflowEnabled(Rec) THEN begin
                            LoopOfSeq_LT(Rec."Employee Id", Rec."Short Leave Request Id");
                            Short_LeaveApprovalsMgmt.OnSend_ShortLeaveReq_Approval(Rec);
                            AdvanceWorkflowCUL.DeleteExtraLine_ApprovalEntry_LT(Rec.RecordId);
                            AdvanceWorkflowCUL.LeaveRequest_SwapApprovalUser_Advance_LT(Rec.RecordId);
                            AdvanceWorkflowCUL.DeleteExtraLine_ApprovalEntry_LT(Rec.RecordId);
                            CancelAndDeleteApprovalEntryTrans_LT(Rec.RecordId);

                            //Creating Manual Notfication because of Customization of Advanced WF
                            CreateManulNotificationSLH(Rec);
                            //Stop Creating Manual Notfication
                        end;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CancelBoolG;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';
                    trigger OnAction()
                    var
                        Short_LeaveApprovalsMgmt: Codeunit InitCodeunit_Short_Leave_Req;
                    begin
                        Short_LeaveApprovalsMgmt.OnCancel_ShortLeaveReq_Approval(Rec);
                        CancelAndDeleteApprovalEntryTrans_LT(Rec.RecordId);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = VisibBool;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                    trigger OnAction()
                    var
                    begin
                        Rec.TESTFIELD(Posted, FALSE);
                        IF Rec."WorkFlow Status" = Rec."WorkFlow Status"::"Pending For Approval" THEN
                            ERROR('WorkFlow status should be Approved for reopen');
                        Rec."WorkFlow Status" := Rec."WorkFlow Status"::Open;
                    end;
                }
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        SetControlVisibility;
        Visib();
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
        Visib();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        RecHRSetup: Record "Human Resources Setup";
        ShortLeaveLine: Record "Short Leave Line";
    begin
        Rec."Request Date" := WORKDATE;
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility;
        EditBool := FALSE;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF Rec."Short Leave Request Id" <> '' THEN
            Rec.TESTFIELD("Employee Id");
    end;

    var
        ShortLeaveCommRec: Record "Short Leave Comments";
        EditBool: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        VisibBool: Boolean;
        GenBoolG: Boolean;
        ReqDateErr: Label 'The requested date should fall in pay period %1';
        LineRec: Record "Short Leave Line";
        i: Integer;
        CancelBoolG: Boolean;


    local procedure SetControlVisibility()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        if NOT Rec.Posted then
            GenBoolG := true
        else
            GenBoolG := false;

        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::"Pending For Approval" then
            CancelBoolG := true
        else
            CancelBoolG := false;
    end;

    local procedure Visib()
    begin
        IF Rec."WorkFlow Status" <> Rec."WorkFlow Status"::Open THEN
            VisibBool := FALSE
        ELSE
            VisibBool := TRUE;
    end;



    //******************************************Advance Workflow*********************
    //[Scope('Internal')]
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

    //[Scope('Internal')]
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
        ApprovalEntrtyTranscationRec_L."Document RecordsID" := Rec.RecordId;
        ApprovalEntrtyTranscationRec_L.INSERT;
    end;

    //[Scope('Internal')]
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
        IsFinalPos: Boolean;
    begin
        CLEAR(SenderID_L);
        CLEAR(ReportingID_L);
        CLEAR(OneEmpID);
        CLEAR(TwoEmpID);
        CLEAR(ThreeEmpID);
        CLEAR(Delegate_L);
        IsFinalPos := false;

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
                        IsFinalPos := true;
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


                if i <= ApprovalLevelSetupRec_L.Level then begin
                    InsertApprovalEntryTrans_LT(TransID,
                                                 UserSetupRec_L."User ID",
                                                 UserSetupRec2_L."User ID",
                                                 Delegate_L,
                                                 SeqNo_L);

                end else
                    if (GetEmployeePostionEmployeeID_FinalPosituion_LT(SenderID_L)) and (i > ApprovalLevelSetupRec_L.Level) then begin
                        InsertApprovalEntryTrans_LT(TransID,
                                                      UserSetupRec_L."User ID",
                                                      UserSetupRec2_L."User ID",
                                                      Delegate_L,
                                                      SeqNo_L);
                        IsFinalPos := true;
                    end;

                OneEmpID := SenderID_L;
                SenderID_L := ReportingID_L;
            end;
            if not IsFinalPos then
                IF ApprovalLevelSetupRec_L."Direct Approve By Finance" THEN BEGIN
                    IF ApprovalLevelSetupRec_L."Finance User ID" <> '' THEN BEGIN
                        CLEAR(Delegate_L);
                        IF CheckDelegateForEmployee_LT2(ApprovalLevelSetupRec_L."Finance User ID", 2) <> '' THEN
                            Delegate_L := CheckDelegateForEmployee_LT2(ApprovalLevelSetupRec_L."Finance User ID", 2)
                        ELSE
                            CLEAR(Delegate_L);

                        InsertApprovalEntryTrans_LT(TransID, UserSetupRec2_L."User ID", ApprovalLevelSetupRec_L."Finance User ID", Delegate_L, (SeqNo_L + 1));

                    END ELSE
                        IF ApprovalLevelSetupRec_L."Finance User ID 2" <> '' THEN BEGIN
                            CLEAR(Delegate_L);
                            IF CheckDelegateForEmployee_LT2(ApprovalLevelSetupRec_L."Finance User ID 2", 2) <> '' THEN
                                Delegate_L := CheckDelegateForEmployee_LT2(ApprovalLevelSetupRec_L."Finance User ID 2", 2)
                            ELSE
                                CLEAR(Delegate_L);

                            InsertApprovalEntryTrans_LT(TransID, UserSetupRec2_L."User ID", ApprovalLevelSetupRec_L."Finance User ID 2", Delegate_L, (SeqNo_L + 2));
                        END;
                END;
        end;
    end;

    procedure CheckDelegateForEmployee_LT2(checkDelegateInfo_P: Code[150]; IsEmployeeOrUser: Integer): Code[80]
    var
        DelegateWFLTRec_L: Record "Delegate - WFLT";
        UserSetupRecL: Record "User Setup";
    begin
        IF IsEmployeeOrUser = 1 THEN BEGIN
            DelegateWFLTRec_L.RESET;
            DelegateWFLTRec_L.SETRANGE("Employee Code", checkDelegateInfo_P);
            IF DelegateWFLTRec_L.FINDFIRST THEN BEGIN
                IF DelegateWFLTRec_L."Delegate ID" <> '' THEN
                    IF (DelegateWFLTRec_L."From Date" >= TODAY) AND (DelegateWFLTRec_L."To Date" <= TODAY) THEN
                        EXIT(DelegateWFLTRec_L."Delegate ID");
            END;
        END ELSE
            IF IsEmployeeOrUser = 2 THEN BEGIN
                UserSetupRecL.RESET;
                UserSetupRecL.SETRANGE("User ID", checkDelegateInfo_P);
                IF UserSetupRecL.FINDFIRST THEN
                    UserSetupRecL.TESTFIELD("Employee Id");

                DelegateWFLTRec_L.RESET;
                DelegateWFLTRec_L.SETRANGE("Employee Code", UserSetupRecL."Employee Id");
                IF DelegateWFLTRec_L.FINDFIRST THEN BEGIN
                    IF DelegateWFLTRec_L."Delegate ID" <> '' THEN BEGIN
                        IF (DelegateWFLTRec_L."From Date" <= TODAY) AND (DelegateWFLTRec_L."To Date" >= TODAY) THEN BEGIN
                            EXIT(DelegateWFLTRec_L."Delegate ID");
                        END
                    END;
                END;
            END;
    end;
    //[Scope('Internal')]
    procedure CancelAndDeleteApprovalEntryTrans_LT(DocNo_P: RecordId)
    var
        ApprovalEntrtyTranscation: Record "Approval Entrty Transcation";
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntrtyTranscation.RESET;
        ApprovalEntrtyTranscation.SETRANGE("Document RecordsID", DocNo_P);
        if ApprovalEntrtyTranscation.FINDSET then begin
            ApprovalEntrtyTranscation.DELETEALL;
        end;
    end;

    //[Scope('Internal')]
    procedure CheckDelegateForEmployee_LT(EmployeeCode_P: Code[30]): Code[80]
    var
        DelegateWFLTRec_L: Record "Delegate - WFLT";
    begin
        DelegateWFLTRec_L.RESET;
        DelegateWFLTRec_L.SETCURRENTKEY("Employee Code");
        DelegateWFLTRec_L.SETRANGE("Employee Code", EmployeeCode_P);
        if DelegateWFLTRec_L.FINDLAST then
            IF (DelegateWFLTRec_L."From Date" <= TODAY) AND (DelegateWFLTRec_L."To Date" >= TODAY) THEN begin
                EXIT(DelegateWFLTRec_L."Delegate ID");
            end;
    end;

    //[Scope('Internal')]
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

    //Creating Manual Notfication because of Customization of Advanced WF
    local procedure GetEntryAprovalEntryTableSLR(ShortLeaveHeader: Record "Short Leave Header"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", ShortLeaveHeader."Short Leave Request Id");
        ApprovalEntry.SetRange("Record ID to Approve", ShortLeaveHeader.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Short Leave Header");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;


    local procedure CreateManulNotificationSLH(ShortLeaveHeader: Record "Short Leave Header")
    var
        NotificationEntry: Record "Notification Entry";
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Get(GetEntryAprovalEntryTableSLR(ShortLeaveHeader));
        NotificationEntry.CreateNotificationEntry(
        NotificationEntry.Type::Approval,
        ApprovalEntry."Approver ID",
        ApprovalEntry,
        Page::"Approval Entries",
        GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Requests to Approve", ApprovalEntry, false),
                            ApprovalEntry."Sender ID");
    end;
    //Stop Creating Manual Notfication
}