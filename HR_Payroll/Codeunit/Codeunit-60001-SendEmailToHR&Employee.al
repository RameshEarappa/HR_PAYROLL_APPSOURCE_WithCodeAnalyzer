codeunit 60001 "Send Email To HR & Employee"
{
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        NewBody: Text;
        UserSetupRec_G: Record "User Setup";
        EmpployeeDepenIdentRecL: Record "Identification Master";

    procedure Employee_Document_request_Card_Notify(DocumentReqRecP: Record "Document Request");
    var
        RecipientsEmailList: List of [Text];
        UserSetupListOfHrRecG: Record "User Setup";
        UserSetupListOfHrRec2G: Record "User Setup";
        RemainingDate: Integer;
        IdenTypeRecL: Record "Identification Doc Type Master";
        EmployeeRecL: Record Employee;

    begin
        UserSetupListOfHrRecG.Reset();
        UserSetupListOfHrRecG.SetRange("Employee Id", DocumentReqRecP."Employee ID");
        if UserSetupListOfHrRecG.FindFirst() then
            UserSetupListOfHrRecG.TestField("E-Mail");
        RecipientsEmailList.Add(UserSetupListOfHrRecG."E-Mail");

        EmployeeRecL.Reset();
        if EmployeeRecL.Get(DocumentReqRecP."Employee ID") then;
        EmailMessage.Create(RecipientsEmailList, 'Document ' + Format(DocumentReqRecP."Document format ID") + ' is ready for Collection.', '', true);
        NewBody := 'Dear ' + EmployeeRecL.FullName() + '<BR><BR>' + 'The requested document  <B>' + Format(DocumentReqRecP."Document format ID") +
         '</B> is ready for collection from HR.' + '<BR><BR>' + 'Regards,<BR> HR Team.<BR><BR>';
        Email.Send(EmailMessage);
    end;
}