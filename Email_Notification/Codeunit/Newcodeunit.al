codeunit 60019 SendEmailAuto
{
    procedure SendEmailAuto_Test()
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Recipients: List of [Text];
        Subject: Text;
        Body: Text;
    begin
        Recipients.Add('ramesh.earappa@intwo.cloud');
        Recipients.Add('Mishra.Avinash@intwo.cloud');

        Subject := 'Email Subject';
        Body := 'full bosy massage';
        EmailMessage.Create(Recipients, Subject, Body, true);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Notification) then
            Message('Success')
        else
            Message('Unsuccessful');
    end;
}