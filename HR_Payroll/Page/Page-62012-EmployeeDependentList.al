page 62012 "Employee Dependent List1"
{
    CardPageID = "Employee Dependent Card";
    PageType = List;
    SourceTable = "Employee Dependents Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Dependent First Name"; Rec."Dependent First Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Dependent Middle Name"; Rec."Dependent Middle Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Dependent Last Name"; Rec."Dependent Last Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Dependent Name in Arabic"; Rec."Dependent Name in Arabic")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Name in Passport in English"; Rec."Name in Passport in English")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Relationship; Rec.Relationship)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Nationality; Rec.Nationality)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Child with Special needs"; Rec."Child with Special needs")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Child Educational Level"; Rec."Child Educational Level")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Is Emergency Contact"; Rec."Is Emergency Contact")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Full Time Student"; Rec."Full Time Student")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Dependent Contact No."; Rec."Dependent Contact No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Dependent Contact Type"; Rec."Dependent Contact Type")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
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

                    trigger OnAction();
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

                    trigger OnAction();
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
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';
                    Visible = false;

                    trigger OnAction();
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
                    ApplicationArea = Suite;
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
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = Rec."WorkFlow Status" <> Rec."WorkFlow Status"::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                    Visible = false;
                }
            }
            group(ActionGroup21)
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action("Dependent Identification")
                {
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        SetControlVisibility;
        if RecEmployee.GET(Rec."Employee ID") then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee ID", RecEmployee."No.");
            Rec.FILTERGROUP(0);
        end;
    end;

    trigger OnAfterGetRecord();
    begin
        SetControlVisibility;
        if RecEmployee.GET(Rec."Employee ID") then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee ID", RecEmployee."No.");
            Rec.FILTERGROUP(0);
        end;
    end;

    trigger OnOpenPage();
    begin
        SetControlVisibility;
        if RecEmployee.GET(Rec."Employee ID") then begin
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Employee ID", RecEmployee."No.");
            Rec.FILTERGROUP(0);
        end;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        RecEmployee: Record Employee;
        HrSetup: Record "Human Resources Setup";
        NoseriesMgt: Codeunit NoSeriesManagement;
        RecEmpIdent: Record "Identification Master";
        DependentIdPage: Page "Dependent Identification";
        Id_MastertRec: Record "Identification Master";

    local procedure SetControlVisibility();
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
    end;
}