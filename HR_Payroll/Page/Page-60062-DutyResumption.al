page 60062 "Duty Resumption"
{
    PageType = Card;
    SourceTable = "Duty Resumption";
    UsageCategory = Administration;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Leave Request ID"; Rec."Leave Request ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Resumption Date"; Rec."Resumption Date")
                {
                    ApplicationArea = All;
                    Editable = ResumeDateEditable;

                    trigger OnValidate()
                    begin
                        LeaveReqLines.RESET;
                        LeaveReqLines.SETRANGE("Leave Request ID", Rec."Leave Request ID");
                        if LeaveReqLines.FINDSET then
                            LeaveReqLines.DELETEALL;

                        if Rec."Resumption Date" = 0D then begin
                            ExtensionLineVisible := false;
                        end;

                        if Rec."Resumption Date" >= Rec."End Date" + 2 then begin
                            ExtensionLineVisible := true;
                            LeaveReqLines.INIT;
                            LeaveReqLines.VALIDATE("Leave Request ID", Rec."Leave Request ID");
                            LeaveReqLines."Line No" += LeaveReqLines."Line No" + 1000;
                            LeaveReqLines.VALIDATE("Personnel Number", Rec."Personnel Number");
                            LeaveReqLines.VALIDATE("Start Date", Rec."End Date" + 1);
                            LeaveReqLines.VALIDATE("End Date", Rec."Resumption Date" - 1);
                            LeaveReqLines."Created By" := USERID;
                            LeaveReqLines."Created Date Time" := CURRENTDATETIME;
                            LeaveReqLines."Created Date" := TODAY;
                            LeaveReqLines."Submission Date" := TODAY;
                            LeaveReqLines."Workflow Status" := LeaveReqLines."Workflow Status"::Open;
                            LeaveReqLines.INSERT(true);
                        end else
                            ExtensionLineVisible := false;
                    end;
                }
                field("Personnel Number"; Rec."Personnel Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part("Leave Extension"; "Leave Extension Lines")
            {
                Caption = 'Leave Extension';
                ApplicationArea = All;
                SubPageLink = "Leave Request ID" = FIELD("Leave Request ID"), "Personnel Number" = field("Personnel Number");
                SubPageView = SORTING("Leave Request ID", "Line No") ORDER(Ascending);
                Visible = ExtensionLineVisible;
            }
        }
        area(factboxes)
        {
            systempart(Control11; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control12; Links)
            {
                ApplicationArea = All;
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
                Enabled = NOT OpenApprovalEntriesExist;
                Image = SendApprovalRequest;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                Var
                    WfCode: Codeunit InitCodeunit_Duty_Resumption;
                    AdvanceWorkflowCUL: Codeunit "Advance Workflow";
                begin
                    CancelAndDeleteApprovalEntryTrans_LT(Rec.RecordId);
                    Rec.TESTFIELD("Workflow Status", Rec."Workflow Status"::Open);
                    Rec.TESTFIELD("Resumption Date");
                    LeaveReqLines.RESET;
                    LeaveReqLines.SETRANGE("Leave Request ID", Rec."Leave Request ID");
                    if LeaveReqLines.FINDSET then
                        repeat
                            LeaveReqLines.TESTFIELD("Leave Type");
                            LeaveReqLines.SubmitLeave(LeaveReqLines);
                        until LeaveReqLines.NEXT = 0;

                    CurrPage.SETSELECTIONFILTER(T_DutyResmue);
                    if T_DutyResmue.FINDSET then;
                    if WfCode.IsDuty_Resumption_Enabled(Rec) then begin
                        LoopOfSeq_LT(Rec."Personnel Number", Rec."Leave Request ID");
                        WfCode.OnSendDuty_Resumption_Approval(rec);
                        AdvanceWorkflowCUL.DeleteExtraLine_ApprovalEntry_LT(Rec.RecordId);
                        AdvanceWorkflowCUL.LeaveRequest_SwapApprovalUser_Advance_LT(Rec.RecordId);
                        AdvanceWorkflowCUL.DeleteExtraLine_ApprovalEntry_LT(Rec.RecordId);

                        //Creating Manual Notfication because of Customization of Advanced WF
                        CreateManulNotificationWF(Rec);
                        //Stop Creating Manual Notfication
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Enabled = CanCancelApprovalForRecord;
                Image = CancelApprovalRequest;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    WfCode: Codeunit InitCodeunit_Duty_Resumption;
                begin
                    WfCode.OnCancelDuty_Resumption_Approval(Rec);
                    CancelAndDeleteApprovalEntryTrans_LT(Rec.RecordId);
                end;
            }
            action(Approvals)
            {
                AccessByPermission = TableData "Approval Entry" = R;
                ApplicationArea = Suite;

                Caption = 'Approvals';
                Image = Approvals;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Duty Resumption");
                    ApprovalEntry.SETRANGE("Record ID to Approve", Rec.RecordId);
                    ApprovalEntry.SETRANGE("Related to Change", FALSE);
                    PAGE.RUN(70010, ApprovalEntry);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Workflow Status" = Rec."Workflow Status"::Released then
            ResumeDateEditable := false
        else
            ResumeDateEditable := true;

        if Rec."Resumption Date" <> 0D then begin
            if Rec."Resumption Date" >= Rec."End Date" + 2 then
                ExtensionLineVisible := true
            else
                ExtensionLineVisible := false;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
    end;

    trigger OnInit()
    begin
        ExtensionLineVisible := false;
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility;
    end;

    var
        T_DutyResmue: Record "Duty Resumption";
        EmpWorkDate: Record EmployeeWorkDate_GCC;
        LeaveType: Record "HCM Leave Types ErnGrp";
        Employee: Record Employee;
        LeaveReqLines: Record "Leave Extension";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        [InDataSet]
        ExtensionLineVisible: Boolean;
        [InDataSet]
        ResumeDateEditable: Boolean;
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        CanCancelApprovalForRecord: Boolean;
        LineExtEditable: Boolean;
        i: Integer;

    local procedure SetControlVisibility()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
    end;

    local procedure "#########################-Start Customize Workflow-##################################"()
    begin
    end;

    procedure InsertApprovalEntryTrans_LT(TransID: Code[30]; SenderID: Code[50]; ReportingID: Code[50]; DelegateID: Code[50]; SequenceID: Integer)
    var
        ApprovalEntrtyTranscationRec_L: Record "Approval Entrty Transcation";
    begin
        ApprovalEntrtyTranscationRec_L.RESET;
        ApprovalEntrtyTranscationRec_L.INIT;
        ApprovalEntrtyTranscationRec_L."Trans ID" := TransID;
        ApprovalEntrtyTranscationRec_L."Advance Payrolll Type" := ApprovalEntrtyTranscationRec_L."Advance Payrolll Type"::"Duty Resumption";
        ApprovalEntrtyTranscationRec_L."Employee ID - Sender" := SenderID;
        ApprovalEntrtyTranscationRec_L."Reporting ID - Approver" := ReportingID;
        ApprovalEntrtyTranscationRec_L."Delegate ID" := DelegateID;
        ApprovalEntrtyTranscationRec_L."Sequence No." := SequenceID;
        ApprovalEntrtyTranscationRec_L."Document RecordsID" := Rec.RecordId;
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
        ApprovalLevelSetupRec_L.SETRANGE("Advance Payrolll Type", ApprovalLevelSetupRec_L."Advance Payrolll Type"::"Duty Resumption");
        if ApprovalLevelSetupRec_L.FINDFIRST then begin
            SenderID_L := EmpID;
            CountForLoop_L := ApprovalLevelSetupRec_L.Level;
            SeqNo_L := 0;
            for i := 1 to CountForLoop_L do begin
                ReportingID_L := GetEmployeePostionEmployeeID_LT(SenderID_L);

                if GetEmployeePostionEmployeeID_FinalPosituion_LT(SenderID_L) then begin
                    if (ReportingID_L = '') then begin
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

    //Creating Manual Notfication because of Customization of Advanced WF
    local procedure GetEntryAprovalEntryTableDR(DutyResumptionL: Record "Duty Resumption"): Integer;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        Clear(ApprovalEntry);
        ApprovalEntry.SetCurrentKey("Entry No.");
        ApprovalEntry.SetRange("Document No.", DutyResumptionL."Leave Request ID");
        ApprovalEntry.SetRange("Record ID to Approve", DutyResumptionL.RecordId);
        ApprovalEntry.SetRange("Table ID", Database::"Duty Resumption");
        ApprovalEntry.SetAscending("Entry No.", true);
        if ApprovalEntry.FindFirst() then
            exit(ApprovalEntry."Entry No.");
    end;

    local procedure CreateManulNotificationWF(SDutyResumptionL: Record "Duty Resumption")
    var
        NotificationEntry: Record "Notification Entry";
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Get(GetEntryAprovalEntryTableDR(SDutyResumptionL));
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