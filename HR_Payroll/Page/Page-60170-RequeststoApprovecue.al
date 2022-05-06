page 60170 RequeststoApprove_cue
{
    Caption = 'Requests to Approve';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Payroll RTC Cue";

    layout
    {
        area(content)
        {
            cuegroup(" ")
            {
                field("Requests to Approve"; Rec."Requests to Approve")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Requests to Approve";
                }
                field("Company directory"; Rec."Company directory")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Directory RTC";
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        DocExchServiceSetup: Record "Doc. Exch. Service Setup";
    begin
    end;

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