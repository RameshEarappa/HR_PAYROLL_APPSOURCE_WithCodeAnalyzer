page 60026 "Employee Dependent List MS1"
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
                }
                field("Dependent Contact Type"; Rec."Dependent Contact Type")
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
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = Rec."WorkFlow Status" <> Rec."WorkFlow Status"::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        if Rec."Workflow Status" = Rec."Workflow Status"::"Pending Approval" then
                            ERROR('WorkFlow status should be Approved for reopen');

                        Rec."Workflow Status" := Rec."Workflow Status"::Open;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetControlVisibility;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        RecEmployee: Record Employee;
        HrSetup: Record "Human Resources Setup";
        NoseriesMgt: Codeunit NoSeriesManagement;
        RecEmpIdent: Record "Identification Master";

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
    end;
}