codeunit 70001 "Advance Workflow"
{
    Permissions = tabledata 454 = rimd;
    procedure LeaveRequest_SwapApprovalUser_Advance_LT(DocRecodsID: RecordID)
    var
        ApprovalEntrtyTranscationRecL: Record "Approval Entrty Transcation";
        xApprovalEntrtyTranscationRecL: Record "Approval Entrty Transcation";
        ApprovalEntryRecL: Record "Approval Entry";
        LeaveRequestHeaderRecL: Record "Leave Request Header";
    begin
        ApprovalEntrtyTranscationRecL.RESET;
        ApprovalEntrtyTranscationRecL.SETCURRENTKEY("Sequence No.");
        ApprovalEntrtyTranscationRecL.SETRANGE("Document RecordsID", DocRecodsID);
        IF ApprovalEntrtyTranscationRecL.FINDSET THEN
            REPEAT
                if ApprovalEntrtyTranscationRecL."Employee ID - Sender" = ApprovalEntrtyTranscationRecL."Reporting ID - Approver" then
                    if ApprovalEntrtyTranscationRecL.Count > 1 then
                        ApprovalEntrtyTranscationRecL.Delete()
            until ApprovalEntrtyTranscationRecL.Next() = 0;

        ApprovalEntrtyTranscationRecL.RESET;
        ApprovalEntrtyTranscationRecL.SETCURRENTKEY("Sequence No.");
        ApprovalEntrtyTranscationRecL.SETRANGE("Document RecordsID", DocRecodsID);
        IF ApprovalEntrtyTranscationRecL.FINDSET THEN BEGIN
            REPEAT
                ApprovalEntryRecL.RESET;
                ApprovalEntryRecL.SETRANGE("Record ID to Approve", ApprovalEntrtyTranscationRecL."Document RecordsID");
                ApprovalEntryRecL.SETFILTER(Status, '%1|%2', ApprovalEntryRecL.Status::Open, ApprovalEntryRecL.Status::Created);
                ApprovalEntryRecL.SETRANGE("Advance Date", Today);
                ApprovalEntryRecL.SETRANGE("Sequence No.", ApprovalEntrtyTranscationRecL."Sequence No.");
                IF ApprovalEntryRecL.FINDFIRST THEN BEGIN
                    ApprovalEntryRecL."Sender ID" := ApprovalEntrtyTranscationRecL."Employee ID - Sender";
                    if ApprovalEntrtyTranscationRecL."Delegate ID" = '' then
                        ApprovalEntryRecL."Approver ID" := ApprovalEntrtyTranscationRecL."Reporting ID - Approver"
                    else
                        ApprovalEntryRecL."Approver ID" := ApprovalEntrtyTranscationRecL."Delegate ID";

                    // Start When pre Record has Delegate
                    if xApprovalEntrtyTranscationRecL."Delegate ID" <> '' then
                        ApprovalEntryRecL."Sender ID" := xApprovalEntrtyTranscationRecL."Delegate ID";
                    // Stop When pre Record has Delegate

                    // Start  when single user is sender and approver
                    if ApprovalEntryRecL."Sender ID" = ApprovalEntryRecL."Approver ID" then begin
                        ApprovalEntryRecL.Validate(Status, ApprovalEntryRecL.Status::Approved);
                        LeaveRequestHeaderRecL.Reset();
                        LeaveRequestHeaderRecL.SetRange(RecId, DocRecodsID);
                        if LeaveRequestHeaderRecL.FindFirst() then begin
                            LeaveRequestHeaderRecL.Validate("Workflow Status", LeaveRequestHeaderRecL."Workflow Status"::Released);
                            LeaveRequestHeaderRecL.Modify();
                            Message('Leave Request has been Approved.');
                        end;
                    End;
                    // Stop  when single user is sender and approver
                    ApprovalEntryRecL.MODIFY;
                    xApprovalEntrtyTranscationRecL := ApprovalEntrtyTranscationRecL;
                END;
            UNTIL ApprovalEntrtyTranscationRecL.NEXT = 0;
        END;
    end;

    // ### ===================================Delete Extra Line in Approval Entry Table ========================
    procedure DeleteExtraLine_ApprovalEntry_LT(DocRecodsID: RecordID)
    var
        ApprovalEntrtyTranscationRecL: Record "Approval Entrty Transcation";
        ApprovalEntryRecL: Record "Approval Entry";
    begin
        ApprovalEntryRecL.RESET;
        ApprovalEntryRecL.SetCurrentKey("Sequence No.");
        ApprovalEntryRecL.SETRANGE("Record ID to Approve", DocRecodsID);
        ApprovalEntryRecL.SETFILTER(Status, '%1|%2', ApprovalEntryRecL.Status::Open, ApprovalEntryRecL.Status::Created);
        ApprovalEntryRecL.SETRANGE("Advance Date", Today);
        IF ApprovalEntryRecL.FindSet() THEN BEGIN
            repeat
                ApprovalEntrtyTranscationRecL.RESET;
                ApprovalEntrtyTranscationRecL.SETRANGE("Document RecordsID", DocRecodsID);
                ApprovalEntrtyTranscationRecL.SetRange("Sequence No.", ApprovalEntryRecL."Sequence No.");
                IF NOT ApprovalEntrtyTranscationRecL.FindFirst() THEN begin
                    ApprovalEntryRecL.Delete(true);
                end;
            until ApprovalEntryRecL.Next() = 0;
        END;
    end;
}