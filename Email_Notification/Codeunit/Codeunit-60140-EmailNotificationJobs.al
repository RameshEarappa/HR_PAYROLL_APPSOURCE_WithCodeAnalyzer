codeunit 60140 "Email Notification Jobs"
{
    trigger OnRun()
    begin
        EmailNotificationEntries.Reset();
        EmailNotificationEntries.SetRange("Email Sent", false);
        if EmailNotificationEntries.FindSet() then begin
            repeat
                if NOT EmailConfirmationCUG.Run(EmailNotificationEntries) then begin
                    Commit();
                    EmailNotificationEntries.status := "Email Notification Sent Status"::Error;
                    EmailNotificationEntries.Error := CopyStr(Format(GetLastErrorText), 1, 250);
                end else begin
                    EmailNotificationEntries."Sent status" := EmailNotificationEntries."Sent status"::Success;
                    EmailNotificationEntries."Email Sent" := true;
                end;
                EmailNotificationEntries.Modify();
            until EmailNotificationEntries.Next() = 0;
        end;

    end;

    var
        EmailConfirmationCUG: Codeunit "Email_Confirmation";
        EmailNotificationEntries: Record "Email Notification Entries";
        EmailNotificationEntries2: Record "Email Notification Entries";
}