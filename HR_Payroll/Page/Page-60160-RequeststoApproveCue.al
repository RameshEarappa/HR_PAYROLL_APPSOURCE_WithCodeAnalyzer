// page 60160 "RequeststoApprove Cue"
// {
//     Caption = 'Requests to Approve';
//     PageType = CardPart;
//     RefreshOnActivate = true;
//     ShowFilter = false;
//     SourceTable = "Summary Payroll Cue";

//     layout
//     {
//         area(content)
//         {
//             cuegroup(" ")
//             {
//                 field("Requests to Approve"; "Requests to Approve")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     DrillDownPageID = "Requests to Approve";
//                 }
//                 field("Company directory"; "Company directory")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     //commented By Avinash  DrillDownPageID = "Emp Contact RTC";
//                 }
//             }
//         }
//     }

//     actions
//     {
//     }

//     trigger OnAfterGetRecord()
//     var
//         DocExchServiceSetup: Record "Doc. Exch. Service Setup";
//     begin
//     end;

//     trigger OnOpenPage()
//     var
//         OCRServiceMgt: Codeunit "OCR Service Mgt.";
//         RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
//     begin
//         RESET;
//         if not GET then begin
//             INIT;
//             INSERT;
//         end;


//         /*SETFILTER("Due Date Filter",'>=%1',WORKDATE);
//         SETFILTER("Overdue Date Filter",'<%1',WORKDATE);
//         SETFILTER("Due Next Week Filter",'%1..%2',CALCDATE('<1D>',WORKDATE),CALCDATE('<1W>',WORKDATE));
//         SETRANGE("User ID Filter",USERID);
//         */
//         User_ID_Srch := USERID;
//         MODIFY;

//     end;

//     var
//         ActivitiesMgt: Codeunit "Activities Mgt.";
//         //commented By Avinash   CueSetup: Codeunit "Cue Setup";
//         O365GettingStartedMgt: Codeunit "O365 Getting Started Mgt.";
//         //commented By Avinash   [RunOnClient]
//         //commented By Avinash  [WithEvents]
//         //commented By Avinash  CameraProvider: DotNet CameraProvider;
//         //commented By Avinash [RunOnClient]
//         //commented By Avinash  [WithEvents]
//         //commented By Avinash   UserTours: DotNet UserTours;
//         //commented By Avinash  [RunOnClient]
//         //commented By Avinash   [WithEvents]
//         //commented By Avinash  PageNotifier: DotNet PageNotifier;
//         HasCamera: Boolean;
//         ShowCamera: Boolean;
//         ShowDocumentsPendingDocExchService: Boolean;
//         ShowStartActivities: Boolean;
//         ShowIncomingDocuments: Boolean;
//         ShowPaymentsActivities: Boolean;
//         ShowPurchasesActivities: Boolean;
//         ShowSalesActivities: Boolean;
//         ShowAwaitingIncomingDoc: Boolean;
//         TileGettingStartedVisible: Boolean;
//         ReplayGettingStartedVisible: Boolean;

//     //commented By Avinash   trigger CameraProvider::PictureAvailable(PictureName: Text; PictureFilePath: Text)
//     //commented By Avinash  var
//     //commented By Avinash     IncomingDocument: Record "Incoming Document";
//     //commented By Avinash begin
//     //commented By Avinash      /*IncomingDocument.CreateIncomingDocumentFromServerFile(PictureName,PictureFilePath);
//     //commented By Avinash   */

//     //commented By Avinash end;

//     //commented By Avinash    trigger UserTours::ShowTourWizard(hasTourCompleted: Boolean)
//     //commented By Avinash    begin
//     //O365GettingStartedMgt.LaunchWizard(FALSE,hasTourCompleted);
//     //commented By Avinash   end;

//     //commented By Avinash   trigger UserTours::IsTourInProgressResultReady(isInProgress: Boolean)
//     //commented By Avinash   begin
//     //commented By Avinash   end;

//     //commented By Avinash   trigger PageNotifier::PageReady()
//     //commented By Avinash   var
//     //commented By Avinash   O365GettingStarted: Record "O365 Getting Started";
//     //commented By Avinash   PermissionManager: Codeunit "Permission Manager";
//     //commented By Avinash   WizardHasBeenShownToUser: Boolean;
//     //commented By Avinash   begin
//     /*IF NOT (CURRENTCLIENTTYPE IN [CLIENTTYPE::Tablet,CLIENTTYPE::Phone]) THEN
//       EXIT;

//     IF NOT PermissionManager.SoftwareAsAService THEN
//       EXIT;

//     WizardHasBeenShownToUser := O365GettingStarted.GET(USERID,CURRENTCLIENTTYPE);
//     IF NOT WizardHasBeenShownToUser THEN
//       PAGE.RUNMODAL(PAGE::"O365 Getting Started Device");
//       */

//     //commented By Avinash  end;
// }

