codeunit 60123 "Documents Expiry Notify"
{
    trigger
    OnRun()
    begin
        Employee_Dependent_Identification_Expiry_Notify();
        Employee_Identification_Expiry_Notify();

    end;

    var
        EmailMessage: Codeunit "Email Message";
        UserSetupRec_G: Record "User Setup";
        EmpployeeDepenIdentRecL: Record "Identification Master";
        NewBody: Text;
        Email: Codeunit Email;

    procedure Employee_Dependent_Identification_Expiry_Notify();
    var
        RecipientsEmailList: List of [Text];
        UserSetupListOfHrRecG: Record "User Setup";
        UserSetupListOfHrRec2G: Record "User Setup";
        RemainingDate: Integer;
        IdenTypeRecL: Record "Identification Doc Type Master";
        EmployeeRecL: Record Employee;
    begin

        UserSetupListOfHrRecG.Reset();
        UserSetupListOfHrRecG.SetRange("HR Manager", true);
        if UserSetupListOfHrRecG.FindSet() then
            repeat
                if UserSetupListOfHrRecG."E-Mail" <> '' then
                    RecipientsEmailList.Add(UserSetupListOfHrRecG."E-Mail");
            until UserSetupListOfHrRecG.Next() = 0;

        UserSetupListOfHrRec2G.Reset();
        UserSetupListOfHrRec2G.SetRange("HR Manager", true);
        if UserSetupListOfHrRec2G.FindFirst() then;

        EmpployeeDepenIdentRecL.Reset();
        EmpployeeDepenIdentRecL.SetRange("Document Type", EmpployeeDepenIdentRecL."Document Type"::Dependent);
        if EmpployeeDepenIdentRecL.FindSet() then begin
            repeat
                EmployeeRecL.Reset();
                if EmployeeRecL.Get(EmpployeeDepenIdentRecL."Master-Record ID") then;

                IdenTypeRecL.Reset();
                IdenTypeRecL.SetRange(Code, EmpployeeDepenIdentRecL."Identification Type");
                if IdenTypeRecL.FindFirst() then;

                Clear(RemainingDate);
                RemainingDate := EmpployeeDepenIdentRecL."Expiry Date" - Today;
                if RemainingDate <= IdenTypeRecL."Documents Expiry Notification" then begin
                    EmailMessage.Create(RecipientsEmailList, 'Dependent ' + EmpployeeDepenIdentRecL."Identification Type" + ' Expiry Notification.', '', true);
                    NewBody := 'Dear HR Manager' + '<BR><BR>' + EmployeeRecL.FullName()
                    + '(' + EmployeeRecL."No." + ')’s dependent(' + EmpployeeDepenIdentRecL."Dependent No" + ') <B>'
                    + EmpployeeDepenIdentRecL."Identification Type" + '-' + EmpployeeDepenIdentRecL."Identification No."
                    + '</B> is set to expire on <B>' + Format(EmpployeeDepenIdentRecL."Expiry Date") + '</B>. </B>. '
                    + 'Please initiate the required actions.' + '<BR><BR>' + 'Regards,<BR> ERP Admin.<BR><BR>';
                    Email.Send(EmailMessage);
                end;
            until EmpployeeDepenIdentRecL.Next() = 0;
        end;
    end;

    procedure Employee_Identification_Expiry_Notify();
    var
        RecipientsEmailList: List of [Text];
        UserSetupListOfHrRecG: Record "User Setup";
        UserSetupListOfHrRec2G: Record "User Setup";
        RemainingDate: Integer;
        IdenTypeRecL: Record "Identification Doc Type Master";
        EmployeeRecL: Record Employee;
    begin

        UserSetupListOfHrRecG.Reset();
        UserSetupListOfHrRecG.SetRange("HR Manager", true);
        if UserSetupListOfHrRecG.FindSet() then
            repeat
                if UserSetupListOfHrRecG."E-Mail" <> '' then
                    RecipientsEmailList.Add(UserSetupListOfHrRecG."E-Mail");
            until UserSetupListOfHrRecG.Next() = 0;

        UserSetupListOfHrRec2G.Reset();
        UserSetupListOfHrRec2G.SetRange("HR Manager", true);
        if UserSetupListOfHrRec2G.FindFirst() then;

        EmpployeeDepenIdentRecL.Reset();
        EmpployeeDepenIdentRecL.SetRange("Document Type", EmpployeeDepenIdentRecL."Document Type"::Employee);
        if EmpployeeDepenIdentRecL.FindSet() then begin
            repeat
                EmployeeRecL.Reset();
                if EmployeeRecL.Get(EmpployeeDepenIdentRecL."Employee No.") then;

                IdenTypeRecL.Reset();
                IdenTypeRecL.SetRange(Code, EmpployeeDepenIdentRecL."Identification Type");
                if IdenTypeRecL.FindFirst() then;

                Clear(RemainingDate);
                RemainingDate := EmpployeeDepenIdentRecL."Expiry Date" - Today;
                if RemainingDate <= IdenTypeRecL."Documents Expiry Notification" then begin
                    EmailMessage.Create(RecipientsEmailList, 'Dependent ' + EmpployeeDepenIdentRecL."Identification Type" + ' Expiry Notification.', '', true);
                    NewBody := 'Dear HR Manager' + '<BR><BR>' + EmployeeRecL.FullName()
                    + '(' + EmployeeRecL."No." + ')’s dependent(' + EmpployeeDepenIdentRecL."Dependent No" + ') <B>'
                    + EmpployeeDepenIdentRecL."Identification Type" + '-' + EmpployeeDepenIdentRecL."Identification No."
                    + '</B> is set to expire on <B>' + Format(EmpployeeDepenIdentRecL."Expiry Date") + '</B>. </B>. '
                    + 'Please initiate the required actions.' + '<BR><BR>' + 'Regards,<BR> ERP Admin.<BR><BR>';
                    Email.Send(EmailMessage);
                end;
            until EmpployeeDepenIdentRecL.Next() = 0;
        end;
    end;
}