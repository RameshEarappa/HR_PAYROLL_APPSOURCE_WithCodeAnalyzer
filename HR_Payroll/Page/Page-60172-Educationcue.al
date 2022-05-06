page 60172 Education_cue
{
    Caption = 'Requests to Approve';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Payroll RTC Cue";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(" ")
            {
                field("Education Claim"; Rec."Education Claim")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        OCRServiceMgt: Codeunit "OCR Service Mgt.";
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        Rec.RESET;
        if not Rec.GET then begin
            Rec.INIT;
            Rec.INSERT;
        end;
        Rec.User_ID_Srch := USERID;
        Rec.MODIFY;
    end;

    var
        ActivitiesMgt: Codeunit "Activities Mgt.";
        O365GettingStartedMgt: Codeunit "O365 Getting Started Mgt.";
        HasCamera: Boolean;
        ShowCamera: Boolean;
        ShowDocumentsPendingDocExchService: Boolean;
        ShowStartActivities: Boolean;
        ShowIncomingDocuments: Boolean;
        ShowPaymentsActivities: Boolean;
        ShowPurchasesActivities: Boolean;
        ShowSalesActivities: Boolean;
        ShowAwaitingIncomingDoc: Boolean;
        TileGettingStartedVisible: Boolean;
        ReplayGettingStartedVisible: Boolean;
}

