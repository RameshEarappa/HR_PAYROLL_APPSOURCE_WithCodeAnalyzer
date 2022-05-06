page 60181 "Reporting Employee Card"
{
    Caption = 'Employee Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies a number for the employee.';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Caption = 'Professional Title';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s job title.';
                    ApplicationArea = All;
                }
                field("Professional Title in Arabic"; Rec."Professional Title in Arabic")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s first name.';
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Caption = 'Middle Name';
                    ToolTip = 'Specifies the employee''s middle name.';
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the employee''s last name.';
                    ApplicationArea = All;
                }
                field(Initials; Rec.Initials)
                {
                    Caption = 'Personal Title';
                    ToolTip = 'Specifies the employee''s initials.';
                    ApplicationArea = All;
                }
                field("Personal   Title in Arabic"; Rec."Personal   Title in Arabic")
                {
                    Caption = 'Personal  Title in Arabic';
                    ApplicationArea = All;
                }
                field("Employee Name in Arabic"; Rec."Employee Name in Arabic")
                {
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the last day this entry was modified.';
                    ApplicationArea = All;
                }
                field("Joining Date"; Rec."Joining Date")
                {
                    Enabled = false;
                    ApplicationArea = All;
                }
                field("Joining Date - Hijiri"; Rec."D.O.J Hijiri")
                {
                    ApplicationArea = All;
                }
                field("Probation Period"; Rec."Probation Period")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Sub Department"; Rec."Sub Department")
                {
                    Caption = 'Sub Department';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Line manager"; Rec."Line manager")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(HOD; Rec.HOD)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("Employee Grade Details")
            {
                Caption = 'Employee Grade Details';
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Grade Category"; Rec."Grade Category")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Unsatisfactory Grade"; Rec."Unsatisfactory Grade")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Employee Details"; "Reporting to FactBox")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                Visible = false;
                action(Leaves)
                {
                    Image = Holiday;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "Leave Requests_RC";
                    RunPageLink = "Personnel Number" = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Overtime Request")
                {
                    Image = CalculateCrossDock;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "Loan Adjustments";
                    RunPageLink = "Employee Name" = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Overtime  Benefit Claim")
                {
                    Image = CalculateCrossDock;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "Loan Types";
                    RunPageLink = "Arabic Name" = FIELD("No.");
                    ApplicationArea = All;
                }
            }
            group("Employee Competencies")
            {
                Caption = 'Employee Competencies';
                action(Education)
                {
                    Image = Certificate;
                    RunObject = Page "Employee Education List";
                    RunPageLink = "Emp ID" = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Experience)
                {
                    Image = Accounts;
                    RunObject = Page "Employee Education List";
                    RunPageLink = "Emp ID" = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Skills)
                {
                    Image = Skills;
                    RunObject = Page "Employee Skills List";
                    RunPageLink = "Emp ID" = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Certificates)
                {
                    Image = Certificate;
                    RunObject = Page "Employee Certificates List";
                    RunPageLink = "Emp ID" = FIELD("No.");
                    ApplicationArea = All;
                }
                action(Attendance)
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;
                }
                action("Mission Orders")
                {
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        MissionOrderLine: Record "DME Activities Cue";
                        MissionOrderHeader: Record "Asset Assignment Register";
                        MissionOrderLists: Page "DME Activities Cue";
                    begin
                        MissionOrderLine.RESET;
                        if MissionOrderLine.FINDFIRST then
                            repeat
                                MissionOrderHeader.GET(MissionOrderLine."Primary Key");
                                MissionOrderHeader.MARK(true);
                            until MissionOrderLine.NEXT = 0;
                        MissionOrderHeader.MARKEDONLY(true);
                        MissionOrderLists.SETTABLEVIEW(MissionOrderHeader);
                        MissionOrderLists.RUNMODAL;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EmplErngCodegrp.RESET;
        EmplErngCodegrp.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
        EmplErngCodegrp.SETRANGE("Employee Code", Rec."No.");
        EmplErngCodegrp.SETFILTER("Valid From", '<=%1', WORKDATE);
        EmplErngCodegrp.SETFILTER("Valid To", '>=%1|%2', WORKDATE, 0D);
        if EmplErngCodegrp.FINDFIRST then
            Rec."Earning Code Group" := EmplErngCodegrp."Earning Code Group";

        CLEAR(Rec."Age As Of Date");
        CLEAR(Age);
        if Rec."Birth Date" <> 0D then begin
            Age := -(Rec."Birth Date" - TODAY);
            if Age <> 0 then
                Rec."Age As Of Date" := FORMAT(ROUND((Age / 365.27), 0.1));
        end;
    end;

    trigger OnAfterGetRecord()
    begin

        CLEAR(Rec."Age As Of Date");
        CLEAR(Age);
        if Rec."Birth Date" <> 0D then begin
            Age := -(Rec."Birth Date" - TODAY);
            if Age <> 0 then
                Rec."Age As Of Date" := FORMAT(ROUND((Age / 365.27), 0.1));
        end;
    end;

    trigger OnInit()
    begin
        UserSetupRec.RESET;
        UserSetupRec.SETRANGE("User ID", USERID);
        if UserSetupRec.FINDFIRST then begin
            EmpRec.RESET;
            EmpRec.SETRANGE("No.", UserSetupRec."Employee Id");
            if EmpRec.FINDSET then;
        end;
        if Rec.FINDSET then begin
            repeat
                Rec.MARK(true);
            until Rec.NEXT = 0;
        end;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        Rec.MARK(true)
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
            if Rec."First Name" <> '' then
                CheckMand;
        end;
    end;

    var
        EmplErngCodegrp: Record "Employee Earning Code Groups";
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
        HCMLeaveTypesWrkr: Record "HCM Leave Types Wrkr";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        HCMLoanTableGCCWrkr: Record "HCM Loan Table GCC Wrkr";
        EmployeeRec2: Record Employee;
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        Age: Decimal;
        DelegateWFLTRec_G: Record "Delegate - WFLT";
        UserSetupRec_G: Record "User Setup";
        UserEmployee: Text;
        UserSetupRec: Record "User Setup";
        EmpRec: Record Employee;
        EmpRec2: Record Employee;

    local procedure CheckMand()
    begin
        Rec.TESTFIELD("Marital Status");
        if Rec.Gender = Rec.Gender::" " then
            ERROR('Please select Gender');
        Rec.TESTFIELD("Birth Date");
        Rec.TESTFIELD(Region);
    end;
}