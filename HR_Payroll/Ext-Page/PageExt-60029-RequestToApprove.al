pageextension 60029 "Ext Request To Approve" extends "Requests to Approve"
{
    actions
    {
        addafter(Delegate)
        {
            action("Send Notification")
            {
                ApplicationArea = All;
                Image = SendMail;
                Promoted = true;
            }
        }
        modify(Approve)
        {
            trigger OnBeforeAction()
            var
                LeaveRequestHeaderRecL: Record "Leave Request Header";
                CancelLeaveRequestRecL: Record "Cancel Leave Request";
                LoanRequestRecL: Record "Loan Request";
                CurrRec: Record "Approval Entry";
            begin
                CurrPage.SetSelectionFilter(CurrRec);
                if CurrRec.FindFirst() then;
                LeaveRequestHeaderRecL.Reset();
                LeaveRequestHeaderRecL.SetRange(RecId, CurrRec."Record ID to Approve");
                if LeaveRequestHeaderRecL.FindFirst() then
                    Error('Please Open document and Approve.');
                CancelLeaveRequestRecL.Reset();
                CancelLeaveRequestRecL.SetRange(RecId, CurrRec."Record ID to Approve");
                if CancelLeaveRequestRecL.FindFirst() then begin
                    Error('Please Open document and Approve.');
                end;
            end;

            trigger OnAfterAction()
            var
                LeaveRequestHeaderRecL: Record "Leave Request Header";
                CancelLeaveRequestRecL: Record "Cancel Leave Request";
                FullNFinalRecL: Record "Full and Final Calculation";
                PayrollStatementRecL: Record "Payroll Statement";
                LoanRequestRecL: Record "Loan Request";
                CurrRec: Record "Approval Entry";

            begin
                CurrPage.SetSelectionFilter(CurrRec);
                if CurrRec.FindFirst() then;
                CancelLeaveRequestRecL.Reset();
                CancelLeaveRequestRecL.SetRange(RecId, CurrRec."Record ID to Approve");
                if CancelLeaveRequestRecL.FindFirst() then begin
                    CancelLeaveRequestRecL.PostLeaveCancel(CancelLeaveRequestRecL);
                end;
                LoanRequestRecL.Reset();
                LoanRequestRecL.SetRange(RecID, CurrRec."Record ID to Approve");
                if LoanRequestRecL.FindFirst() then begin
                    if Rec."Sequence No." = GetMaxApprovalSequanceNo(CurrRec) then begin
                        DMENotificationSetupRecG.Reset();
                        DMENotificationSetupRecG.SetRange("Process ID", CurrRec."Table ID");
                        if DMENotificationSetupRecG.FindFirst() then;
                        if DMENotificationSetupRecG."HR Manager" then begin
                            UserSetupRecG.Reset();
                            UserSetupRecG.SetRange("HR Manager", true);
                            if UserSetupRecG.FindSet() then begin
                                repeat
                                    InsertLoanRequestNotificationTemplate(LoanRequestRecL, CurrRec, UserSetupRecG."User ID");
                                until UserSetupRecG.Next() = 0;
                            end;
                        end;
                        if DMENotificationSetupRecG.Finances then begin
                            UserSetupRecG.Reset();
                            UserSetupRecG.SetRange(Finances, true);
                            if UserSetupRecG.FindSet() then begin
                                repeat
                                    InsertLoanRequestNotificationTemplate(LoanRequestRecL, CurrRec, UserSetupRecG."User ID");
                                until UserSetupRecG.Next() = 0;
                            end;
                        end;
                    end;
                end;
                FullNFinalRecL.Reset();
                FullNFinalRecL.SetRange(RecID, CurrRec."Record ID to Approve");
                if FullNFinalRecL.FindFirst() then begin

                    if Rec."Sequence No." = GetMaxApprovalSequanceNo(CurrRec) then begin
                        DMENotificationSetupRecG.Reset();
                        DMENotificationSetupRecG.SetRange("Process ID", CurrRec."Table ID");
                        if DMENotificationSetupRecG.FindFirst() then;
                        if DMENotificationSetupRecG."HR Manager" then begin
                            UserSetupRecG.Reset();
                            UserSetupRecG.SetRange("HR Manager", true);
                            if UserSetupRecG.FindSet() then begin
                                repeat
                                    InsertFullNFinalNotificationTemplate(FullNFinalRecL, CurrRec, UserSetupRecG."User ID");
                                until UserSetupRecG.Next() = 0;
                            end;
                        end;
                        if DMENotificationSetupRecG.Finances then begin
                            UserSetupRecG.Reset();
                            UserSetupRecG.SetRange(Finances, true);
                            if UserSetupRecG.FindSet() then begin
                                repeat
                                    InsertFullNFinalNotificationTemplate(FullNFinalRecL, CurrRec, UserSetupRecG."User ID");
                                until UserSetupRecG.Next() = 0;
                            end;
                        end;
                    end;
                end;
                PayrollStatementRecL.Reset();
                PayrollStatementRecL.SetRange(RecID, CurrRec."Record ID to Approve");
                if PayrollStatementRecL.FindFirst() then begin

                    if Rec."Sequence No." = GetMaxApprovalSequanceNo(CurrRec) then begin
                        DMENotificationSetupRecG.Reset();
                        DMENotificationSetupRecG.SetRange("Process ID", CurrRec."Table ID");
                        if DMENotificationSetupRecG.FindFirst() then;
                        if DMENotificationSetupRecG."HR Manager" then begin
                            UserSetupRecG.Reset();
                            UserSetupRecG.SetRange("HR Manager", true);
                            if UserSetupRecG.FindSet() then begin
                                repeat
                                    InsertPayrollStatementNotificationTemplate(PayrollStatementRecL, CurrRec, UserSetupRecG."User ID");
                                until UserSetupRecG.Next() = 0;
                            end;
                        end;
                        if DMENotificationSetupRecG.Finances then begin
                            UserSetupRecG.Reset();
                            UserSetupRecG.SetRange(Finances, true);
                            if UserSetupRecG.FindSet() then begin
                                repeat
                                    InsertPayrollStatementNotificationTemplate(PayrollStatementRecL, CurrRec, UserSetupRecG."User ID");
                                until UserSetupRecG.Next() = 0;
                            end;
                        end;
                    end;
                end;
            end;
        }
    }
    var
        DMENotificationSetupRecG: Record "DME Notification Setup";
        SendEmailJobCUG: Codeunit "Email Notification Jobs";
        UserSetupRecG: Record "User Setup";

    procedure GetMaxApprovalSequanceNo(ApprovalEntryRecP: Record "Approval Entry"): Integer
    var
        ApprovalEntryRecL: Record "Approval Entry";
    begin
        ApprovalEntryRecL.Reset();
        ApprovalEntryRecL.SetCurrentKey("Entry No.");
        ApprovalEntryRecL.SetRange("Record ID to Approve", ApprovalEntryRecP."Record ID to Approve");
        ApprovalEntryRecL.SetRange("Date-Time Sent for Approval", ApprovalEntryRecP."Date-Time Sent for Approval");
        ApprovalEntryRecL.Ascending(true);
        if ApprovalEntryRecL.FindLast() then
            exit(ApprovalEntryRecL."Sequence No.");
    end;

    procedure InsertLoanRequestNotificationTemplate(LoanRequestRecP: Record "Loan Request"; CurrRecP: Record "Approval Entry"; ReceiverUserIDP: code[50])
    var
        EmailNotificationEntriesRecL: Record "Email Notification Entries";
        Email_ConfirmationCUL: Codeunit Email_Confirmation;
        LoanTypeRecL: Record "HCM Loan Table GCC Wrkr";
        HeaderTxt: Text;
        BodyTxt: Text;
        FooterTxt: Text;
    begin
        Clear(EmailNotificationEntriesRecL);
        Clear(HeaderTxt);
        Clear(BodyTxt);
        Clear(FooterTxt);
        LoanTypeRecL.Reset();
        LoanTypeRecL.SetRange("Loan Code", LoanRequestRecP."Loan Type");
        if LoanTypeRecL.FindFirst() then;

        HeaderTxt := 'Dear ' + GetFromName(ReceiverUserIDP) + ',';

        BodyTxt := 'Loan Request Document No ' + LoanRequestRecP."Loan Request ID" + ' has been approved. Please proceed for further actions';

        FooterTxt := '<B><U>Loan Request Details </B></U> </BR>' +
                     'Employee ID : ' + LoanRequestRecP."Employee ID" + '</BR>' +
                     'Loan Type   : ' + Format(LoanRequestRecP."Loan Type") + ' - ' + LoanTypeRecL."Loan Description" + '</BR></BR>' +
                     'Regards,</BR> ERP';

        EmailNotificationEntriesRecL.InsertRecords(CurrRecP."Table ID",
                                                    CurrRecP."Document No.",
                                                    CurrRecP."Sender ID",
                                                    ReceiverUserIDP,
                                                    CurrRecP."Record ID to Approve",
                                                    CurrRecP.Status,
                                                    HeaderTxt,
                                                    BodyTxt,
                                                    FooterTxt,
                                                    'Loan Request ' + LoanRequestRecP."Loan Request ID" + ' has been approved')
    end;

    procedure GetFromName(UserID: Text): Text
    var
        UserSetupRecL: Record "User Setup";
        EmployeeRecL: Record Employee;
    begin
        clear(UserSetupRecL);
        if UserSetupRecL.Get(UserID) then begin
            Clear(EmployeeRecL);
            if EmployeeRecL.get(UserSetupRecL."Employee Id") then
                exit(EmployeeRecL.FullName());
        end;
    end;

    procedure GetFromAddress(UserID: Text): Text
    var
        UserSetupRecL: Record "User Setup";
    begin
        clear(UserSetupRecL);
        if UserSetupRecL.Get(UserID) then begin
            exit(UserSetupRecL."E-Mail");
        end;
    end;

    procedure InsertFullNFinalNotificationTemplate(FullNFinalRecL: Record "Full and Final Calculation"; CurrRecP: Record "Approval Entry"; ReceiverUserIDP: code[50])
    var
        EmailNotificationEntriesRecL: Record "Email Notification Entries";
        Email_ConfirmationCUL: Codeunit Email_Confirmation;
        HeaderTxt: Text;
        BodyTxt: Text;
        FooterTxt: Text;
        Subject: Text;
    begin
        Clear(EmailNotificationEntriesRecL);
        Clear(HeaderTxt);
        Clear(BodyTxt);
        Clear(FooterTxt);
        Clear(Subject);

        Subject := 'Final Settlement ' + FullNFinalRecL."Journal ID" + ' has been approved';

        HeaderTxt := 'Dear ' + GetFromName(ReceiverUserIDP) + ',';

        BodyTxt := 'Final Settlement Document No ' + FullNFinalRecL."Journal ID" + ' has been approved. Please proceed for further actions.';

        FooterTxt := '<B><U> Final Settlement Details </B></U> </BR>' +
                     'Employee ID : ' + FullNFinalRecL."Employee No." + '</BR>' +
                     'Regards,</BR> ERP';

        EmailNotificationEntriesRecL.InsertRecords(CurrRecP."Table ID",
                                                    CurrRecP."Document No.",
                                                    CurrRecP."Sender ID",
                                                    ReceiverUserIDP,
                                                    CurrRecP."Record ID to Approve",
                                                    CurrRecP.Status,
                                                    HeaderTxt,
                                                    BodyTxt,
                                                    FooterTxt,
                                                    Subject);
    end;

    procedure InsertPayrollStatementNotificationTemplate(PayrollStmnt: Record "Payroll Statement"; CurrRecP: Record "Approval Entry"; ReceiverUserIDP: code[50])
    var
        EmailNotificationEntriesRecL: Record "Email Notification Entries";
        Email_ConfirmationCUL: Codeunit Email_Confirmation;
        HeaderTxt: Text;
        BodyTxt: Text;
        FooterTxt: Text;
        Subject: Text;
    begin
        Clear(EmailNotificationEntriesRecL);
        Clear(HeaderTxt);
        Clear(BodyTxt);
        Clear(FooterTxt);
        Clear(Subject);

        Subject := 'Payroll Statement ' + PayrollStmnt."Payroll Statement ID" + ' has been approved';

        HeaderTxt := 'Dear ' + GetFromName(ReceiverUserIDP) + ',';

        BodyTxt := 'Payroll Statement Document No ' + PayrollStmnt."Payroll Statement ID" + ' for  ' +
                    FORMAT(PayrollStmnt."Pay Period Start Date", 0, '<Month Text>') + '-' + Format(DATE2DMY(PayrollStmnt."Pay Period Start Date", 3)) +
                    ' has been approved. Please proceed for further actions.';

        FooterTxt := '</BR> Regards,</BR> ERP';

        EmailNotificationEntriesRecL.InsertRecords(CurrRecP."Table ID",
                                                    CurrRecP."Document No.",
                                                    CurrRecP."Sender ID",
                                                    ReceiverUserIDP,
                                                    CurrRecP."Record ID to Approve",
                                                    CurrRecP.Status,
                                                    HeaderTxt,
                                                    BodyTxt,
                                                    FooterTxt,
                                                    Subject);
    end;

}