page 60152 "Full and Final Journal Card"
{
    PageType = Card;
    SourceTable = "Full and Final Calculation";
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Journal ID"; Rec."Journal ID")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Service Days"; Rec."Service Days")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Joining Date"; Rec."Joining Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Calculated; Rec.Calculated)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part("Payroll Calculations"; "FS Earning Codes")
            {
                Caption = 'Payroll Calculations';
                Editable = false;
                SubPageLink = "Journal ID" = FIELD("Journal ID"), "Employee No." = FIELD("Employee No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
            part("Employee Benefits"; "FS Benefits")
            {
                Caption = 'Employee Benefits';
                SubPageLink = "Journal ID" = FIELD("Journal ID"), "Employee No." = FIELD("Employee No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
            part("Leave Encashments"; "Leave Encashments")
            {
                SubPageLink = "Journal ID" = FIELD("Journal ID"), "Employee No." = FIELD("Employee No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
            part("Recovery of Advances"; "FS Loans")
            {
                Caption = 'Recovery of Advances';
                SubPageLink = "Journal ID" = FIELD("Journal ID"), "Employee No." = FIELD("Employee No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
            group(Summarry)
            {
                Editable = false;
                field("Payroll Amount"; Rec."Payroll Amount")
                {
                    ApplicationArea = All;
                }
                field("Leave Encashment"; Rec."Leave Encashment")
                {
                    ApplicationArea = All;
                }
                field("Indemnity/Gratuity Amount"; Rec."Indemnity/Gratuity Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Indemnity/Gratuity Amount 2"; IndemnityGratuityAmount_New)
                {
                    Caption = 'Gratuity Amount';
                    ApplicationArea = All;
                }
                field("Loan Recovery"; Rec."Loan Recovery")
                {
                    ApplicationArea = All;
                }
                field("Payroll Summarry"; Rec."Payroll Amount" + Rec."Leave Encashment" + Rec."Indemnity/Gratuity Amount" + Rec."Loan Recovery")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Full & Final Calculation")
            {
                Caption = 'Full and Final Settlement Calculation';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecEmployee: Record Employee;
                begin
                    if not CONFIRM('Do you want to calculate the Full and Final Settlement ?', true) then
                        exit;

                    FSEarningCodes.RESET;
                    FSEarningCodes.SETRANGE("Journal ID", Rec."Journal ID");
                    FSEarningCodes.DELETEALL;

                    FSBenefits.RESET;
                    FSBenefits.SETRANGE("Journal ID", Rec."Journal ID");
                    FSBenefits.DELETEALL;

                    FSLoans.RESET;
                    FSLoans.SETRANGE("Journal ID", Rec."Journal ID");
                    FSLoans.DELETEALL;

                    CLEAR(FandFCalc);
                    RecEmployee.RESET;
                    RecEmployee.SETRANGE("No.", Rec."Employee No.");
                    RecEmployee.FINDFIRST;
                    FandFCalc.SetValues(Rec."Pay Cycle", Rec."Pay Period Start Date", Rec."Pay Period End Date", Rec);
                    FandFCalc.SETTABLEVIEW(RecEmployee);
                    FandFCalc.RUNMODAL;
                end;
            }
            action("Submit For Approval")
            {
                Caption = 'Submit For Approval';
                Enabled = NOT OpenApprovalEntriesExist;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    WfCode: Codeunit InitCodeunit_Final_Sett;
                begin
                    CurrPage.SETSELECTIONFILTER(FullandFinalCalculation);
                    if FullandFinalCalculation.FINDFIRST then begin

                        if WfCode.IsF_And_F_Enabled(rec) then begin
                            if not CONFIRM('Do you want to Submit the Full and Final settlement ?') then
                                exit;
                            WfCode.OnSendF_And_F_Approval(rec);
                        end;
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Enabled = CanCancelApprovalForRecord;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    WfCode: Codeunit InitCodeunit_Final_Sett;
                begin
                    WfCode.OnCancelF_And_F_Approval(rec);
                end;
            }
            action(Approvals)
            {
                AccessByPermission = TableData "Approval Entry" = R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Promoted = true;
                PromotedCategory = Category4;
                Image = Approvals;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Full and Final Calculation");
                    ApprovalEntry.SETRANGE("Record ID to Approve", Rec.RecordId);
                    ApprovalEntry.SETRANGE("Related to Change", FALSE);
                    PAGE.RUN(70010, ApprovalEntry);
                end;
            }
            action(Comments)
            {
                ApplicationArea = Suite;
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'View or add comments.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    RecRef: RecordRef;
                    ApprovalEntry: Record "Approval Entry";
                    RecID: RecordID;
                begin
                    RecRef.GET(Rec.RECORDID);
                    RecID := RecRef.RECORDID;
                    CLEAR(ApprovalsMgmt);
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", RecID.TABLENO);
                    ApprovalEntry.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    ApprovalEntry.SETRANGE("Related to Change", false);
                    if ApprovalEntry.FINDFIRST then
                        ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef, ApprovalEntry."Workflow Step Instance ID");
                end;
            }
            action(Reopen)
            {
                Enabled = ReopenBoolG;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Rec."Workflow Status" = Rec."Workflow Status"::"Pending Approval" then
                        ERROR(Text001);
                end;
            }
            action("Attachment")
            {
                ApplicationArea = All;
                Image = Attachments;
                Promoted = true;
                Caption = 'Attachment';
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                trigger
                OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GETTABLE(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RUNMODAL;
                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action("Posting")
                {
                    ApplicationArea = All;
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        FnFPostingCUL: Codeunit "FnF Posting";
                        FnFHeaderRec: Record "Full and Final Calculation";
                        FnFEarningCodeRecL: Record "FS - Earning Code";
                        DocNo: Code[30];
                    begin
                        Clear(DocNo);
                        Clear(FnFPostingCUL);
                        CurrPage.SetSelectionFilter(FnFHeaderRec);
                        if FnFHeaderRec.FindFirst() then begin
                            FnFEarningCodeRecL.Reset();
                            FnFEarningCodeRecL.SetRange("Journal ID", FnFHeaderRec."Journal ID");
                            FnFEarningCodeRecL.SetRange("Employee No.", FnFHeaderRec."Employee No.");
                            if FnFEarningCodeRecL.FindSet() then;
                            DocNo := FnFPostingCUL.CreateGeneralJournalLine(FnFEarningCodeRecL."Journal ID", FnFEarningCodeRecL."Employee No.");
                            Message('General Created %1', DocNo);
                        end;
                    end;
                }
            }
        }
    }

    trigger
    OnOpenPage()
    var
        CurrRecTbl: Record "FS - Earning Code";
        FsBenifTbl: Record "FS Benefits";
    begin
        if Rec."Workflow Status" <> Rec."Workflow Status"::Open then
            ReopenBoolG := true
        else
            ReopenBoolG := false;

        CurrRecTbl.SetRange("Journal ID", Rec."Journal ID");
        CurrRecTbl.SetRange("Final Settlement Component", true);
        CurrRecTbl.SetFilter("Benefit Code", '<>%1', '');
        CurrRecTbl.SetRange("Employee No.", Rec."Employee No.");
        if CurrRecTbl.FindFirst() then begin
            FsBenifTbl.Reset();
            FsBenifTbl.SetRange("Journal ID", Rec."Journal ID");
            FsBenifTbl.SetRange("Employee No.", Rec."Employee No.");
            FsBenifTbl.SetRange("Benefit Code", CurrRecTbl."Benefit Code");
            if FsBenifTbl.FindFirst() then begin
                Clear(IndemnityGratuityAmount_New);
                IndemnityGratuityAmount_New := FsBenifTbl."Benefit Amount";
            end;
        end;
    end;

    trigger OnAfterGetRecord()

    begin
        Rec.CALCFIELDS("Payroll Amount", "Leave Encashment", "Indemnity/Gratuity Amount", "Loan Recovery");
        if Rec."Workflow Status" <> Rec."Workflow Status"::Open then
            ReopenBoolG := true
        else
            ReopenBoolG := false;
    end;

    var
        FandFCalc: Report "Generate Full and Final Calc";
        FSEarningCodes: Record "FS - Earning Code";
        FSBenefits: Record "FS Benefits";
        FSLoans: Record "FS Loans";
        FullandFinalCalculation: Record "Full and Final Calculation";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ReopenBoolG: Boolean;
        Text001: Label 'The approval process must be cancelled or completed to reopen this document.';
        IndemnityGratuityAmount_New: Decimal;
}