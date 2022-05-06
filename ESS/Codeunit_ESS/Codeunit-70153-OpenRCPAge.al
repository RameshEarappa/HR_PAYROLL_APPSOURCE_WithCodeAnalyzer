codeunit 70153 "Rc Open"
{
    trigger OnRun()
    var
        PageID: Integer;
    begin
        UserSetupRecG.Reset();
        UserSetupRecG.SetRange("User ID", Database.UserId);
        if UserSetupRecG.FindFirst() then begin
            Page.RunModal(UserSetupRecG."Profile ID");
        end;
    end;

    var
        UserSetupRecG: Record "User Setup";
}