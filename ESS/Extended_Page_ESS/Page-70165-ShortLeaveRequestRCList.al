page 70165 "Short Leave Request RC List"
{
    Caption = 'Out of Office List ESS';
    PageType = List;
    SourceTable = "Short Leave Header";
    Editable = false;
    CardPageId = "Out of Office Card";
    ApplicationArea = all;
    InsertAllowed = false;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Short Leave Request Id"; Rec."Short Leave Request Id")
                {
                    ApplicationArea = all;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = all;
                }
                field("Employee Id"; Rec."Employee Id")
                {
                    ApplicationArea = all;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = all;
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(New)
            {
                Caption = 'New';
                Image = New;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    EssCUL: Codeunit "ESS RC Page";
                    Rec2: Record "Short Leave Header";
                BEGIN
                    Rec2.Reset();
                    Rec2.Init();
                    if Rec2."Short Leave Request Id" = '' then begin
                        Rec2.Validate("Employee Id", EssCUL.GetEmployeeID(Database.UserId));
                        Rec2.Validate(User_ID, Database.UserId);
                        Rec2.Insert(true);
                        Page.Run(page::"Out of Office Card", Rec2);
                    end;
                END;
            }
        }
        area(navigation)
        {
            group(Approval)
            {
                Caption = 'Approval';
                Enabled = false;
                Visible = false;
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = false;

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
                    Visible = false;

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
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Enabled = false;
                Image = SendApprovalRequest;
                Visible = false;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = SendForBoolG;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TESTFIELD("Pay Month");
                        Rec.TESTFIELD("Pay Period");

                        IF (Rec."Request Date" > Rec."Pay Period Start") THEN
                            ERROR(ReqDateErr, Rec."Pay Period");

                        IF (Rec."Request Date" < Rec."Pay Period End") THEN
                            ERROR(ReqDateErr, Rec."Pay Period");

                        LineRec.RESET;
                        LineRec.SETRANGE("Short Leave Request Id", Rec."Short Leave Request Id");
                        IF LineRec.FINDFIRST THEN;

                        LineRec.TESTFIELD("Req. End Time");
                        LineRec.TESTFIELD(Reason);

                        IF (Rec."Request Date" > Rec."Pay Period Start") THEN
                            ERROR(ReqDateErr, Rec."Request Date");

                        IF (Rec."Request Date" < Rec."Pay Period End") THEN
                            ERROR(ReqDateErr, Rec."Request Date");

                        Rec.TESTFIELD("Request Date");
                        Rec.TESTFIELD("Pay Period");
                        Rec.TESTFIELD("Employee Id");
                        Rec.TESTFIELD(Posted, FALSE);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CancelApprovalRequestBoolG;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';
                    Visible = false;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = WFReopenBoolG;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                    Visible = false;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        Rec.TESTFIELD(Posted, FALSE);
                        IF Rec."WorkFlow Status" = Rec."WorkFlow Status"::"Pending For Approval" THEN
                            ERROR('WorkFlow status should be Approved for reopen');

                        IF Rec."WorkFlow Status" = Rec."WorkFlow Status"::"Pending For Approval" THEN
                            Rec."WorkFlow Status" := Rec."WorkFlow Status"::Open;
                    end;
                }
            }

            action("File Download")
            {
                Image = Aging;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecordLinkRecL: Record "Record Link";
                begin
                    RecordLinkRecL.RESET;
                    RecordLinkRecL.SETRANGE("Record ID", Rec.RECORDID);
                    IF RecordLinkRecL.FINDSET THEN;
                end;
            }
        }
    }

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ReqDateErr: Label 'The requested date should fall in pay period %1';
        LineRec: Record "Short Leave Line";
        CancelApprovalRequestBoolG: Boolean;
        SendForBoolG: Boolean;
        WFReopenBoolG: Boolean;

    trigger OnInit()
    begin
        PageUserFilter();
        SetControlVisibility();
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility();
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility();
    end;

    procedure PageUserFilter()
    var
        Rcodeunit: Codeunit "ESS RC Page";
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Employee Id", Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;

    local procedure SetControlVisibility()
    begin

        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::"Pending For Approval" then
            CancelApprovalRequestBoolG := true
        else
            CancelApprovalRequestBoolG := false;

        if Rec."WorkFlow Status" = Rec."WorkFlow Status"::Open then
            SendForBoolG := true
        else
            SendForBoolG := false;

        if Rec."WorkFlow Status" <> Rec."WorkFlow Status"::Open then
            WFReopenBoolG := true
        else
            WFReopenBoolG := false;
    end;
}