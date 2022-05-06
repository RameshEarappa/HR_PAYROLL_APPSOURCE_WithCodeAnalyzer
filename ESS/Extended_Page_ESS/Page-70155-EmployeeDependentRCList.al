page 70155 "Employee Dependent RC List"
{
    CardPageID = "Employee Dependent Card1";
    PageType = List;
    SourceTable = "Employee Dependents Master";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Dependent First Name"; Rec."Dependent First Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Dependent Middle Name"; Rec."Dependent Middle Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Dependent Last Name"; Rec."Dependent Last Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Dependent Name in Arabic"; Rec."Dependent Name in Arabic")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Name in Passport in English"; Rec."Name in Passport in English")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Child with Special needs"; Rec."Child with Special needs")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Child Educational Level"; Rec."Child Educational Level")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Is Emergency Contact"; Rec."Is Emergency Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Full Time Student"; Rec."Full Time Student")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Dependent Contact No."; Rec."Dependent Contact No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Dependent Contact Type"; Rec."Dependent Contact Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
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
                    Visible = false;
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
                Image = SendApprovalRequest;
                Visible = false;
                action(SendApprovalRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
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
                        Rec.TESTFIELD("Dependent First Name");
                        Rec.TESTFIELD(Relationship);
                        Rec.TESTFIELD(Gender);
                        Rec.TESTFIELD(Nationality);
                        Rec.TESTFIELD("Date of Birth");
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';
                    Visible = false;
                }
                action(Reopen)
                {
                    ApplicationArea = All;
                    Caption = 'Re&open';
                    Enabled = Rec."WorkFlow Status" <> Rec."WorkFlow Status"::Open;
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
                        if Rec."Workflow Status" = Rec."Workflow Status"::"Pending Approval" then
                            ERROR('WorkFlow status should be Approved for reopen');

                        Rec."Workflow Status" := Rec."Workflow Status"::Open;
                    end;
                }
                action("Dependent Identification")
                {
                    Image = ContactPerson;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Dependent Identification";
                    RunPageLink = "Document Type" = FILTER(Dependent),
                                  "Dependent No" = FIELD("No.");
                }
            }

        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlVisibility;
        if RecEmployee.GET(Rec."Employee ID") then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee ID", RecEmployee."No.");
            Rec.FILTERGROUP(0);
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
        if RecEmployee.GET(Rec."Employee ID") then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee ID", RecEmployee."No.");
            Rec.FILTERGROUP(0);
        end;
    end;

    trigger OnOpenPage()
    begin
        SetControlVisibility;
        if RecEmployee.GET(Rec."Employee ID") then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee ID", RecEmployee."No.");
            Rec.FILTERGROUP(0);
        end;
    end;

    trigger OnInit()
    begin
        PageUserFilter();
    end;


    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        RecEmployee: Record Employee;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
    end;

    procedure PageUserFilter()
    var
        Rcodeunit: Codeunit "ESS RC Page";
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Employee ID", Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;
}