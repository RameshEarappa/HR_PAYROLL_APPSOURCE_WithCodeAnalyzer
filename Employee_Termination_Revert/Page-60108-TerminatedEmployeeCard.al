page 60108 "Terminated Employee Card1"
{
    Caption = 'Past Employee Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Employee;
    UsageCategory = Documents;
    ApplicationArea = All;

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

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.UPDATE;
                    end;
                }
                field(Status; Rec.Status)
                {
                    Enabled = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employment status of the employee.';
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
                    Caption = 'Initials';
                    ToolTip = 'Specifies the employee''s initials.';
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last day this entry was modified.';
                }
                field("Joining Date"; Rec."Joining Date")
                {
                    Editable = false;
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
                    ApplicationArea = All;
                    Editable = false;
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
            group("Address & Contact")
            {
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee''s address.';
                    Visible = false;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies another line of the address.';
                    Visible = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal code of the address.';
                    Visible = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the address.';
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region code.';
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s telephone number.';
                    Visible = false;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a search name for the employee.';
                    Visible = false;
                }
                field("Alt. Address Code"; Rec."Alt. Address Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for an alternate address.';
                    Visible = false;
                }
                field("Alt. Address Start Date"; Rec."Alt. Address Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date when the alternate address is valid.';
                    Visible = false;
                }
                field("Alt. Address End Date"; Rec."Alt. Address End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last day when the alternate address is valid.';
                    Visible = false;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                Visible = false;
                field(Extension; Rec.Extension)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s telephone extension.';
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s mobile telephone number.';
                }
                field(Pager; Rec.Pager)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee''s pager number.';
                }
                field("Phone No.2"; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee''s telephone number.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s email address.';
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee''s email address at the company.';
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                field("Employment Date"; Rec."Employment Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the employee began to work for the company.';
                    Visible = false;
                }
                field("Employment End Date"; Rec."Employment End Date")
                {
                    ApplicationArea = All;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ApplicationArea = All;
                }
                field("Inactive Date"; Rec."Inactive Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the employee became inactive, due to disability or maternity leave, for example.';
                }
                field("Cause of Inactivity Code"; Rec."Cause of Inactivity Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the cause of inactivity by the employee.';
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the employee was terminated, due to retirement or dismissal, for example.';
                }
                field("Seperation Reason"; Rec."Seperation Reason")
                {
                    ApplicationArea = All;
                }
                field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a termination code for the employee who has been terminated.';
                    Visible = false;
                }
                field("Emplymt. Contract Code"; Rec."Emplymt. Contract Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employment contract code for the employee.';
                    Visible = false;
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a statistics group code to assign to the employee for statistical purposes.';
                    Visible = false;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a resource number for the employee, if the employee is a resource in Resources Planning.';
                    Visible = false;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a salesperson or purchaser code for the employee, if the employee is a salesperson or purchaser in the company.';
                    Visible = false;
                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = All;
                }
                field("Work Location"; Rec."Work Location")
                {
                    ApplicationArea = All;
                }
                field("Position Name In Arabic"; Rec."Position Name In Arabic")
                {
                    ApplicationArea = All;
                }
                field("Job Title as per Iqama"; Rec."Job Title as per Iqama")
                {
                    ApplicationArea = All;
                }
                field("Sector ID"; Rec."Sector ID")
                {
                    ApplicationArea = All;
                }
                field("Sector Name"; Rec."Sector Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Personal)
            {
                Caption = 'Personal';
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s date of birth.';
                }
                field("Age As Of Date"; Rec."Age As Of Date")
                {
                    ApplicationArea = All;
                }
                field(Religion; Rec."Employee Religion")
                {
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee''s gender.';
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field("Nationality In Arabic"; Rec."Nationality In Arabic")
                {
                    ApplicationArea = All;
                }
                field("Social Security No."; Rec."Social Security No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Social Security number of the employee.';
                    Visible = false;
                }
                field("Union Code"; Rec."Union Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee''s labor union membership code.';
                    Visible = false;
                }
                field("Union Membership No."; Rec."Union Membership No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee''s labor union membership number.';
                    Visible = false;
                }
            }
            group(Control5)
            {
                field("Grade Category"; Rec."Grade Category")
                {
                    ApplicationArea = All;
                }
            }
            group(Identification)
            {
                Visible = false;
                field("Identification Type"; Rec."Identification Type")
                {
                    ApplicationArea = All;
                }
                field("Identification No."; Rec."Identification No.")
                {
                    ApplicationArea = All;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Issuing Country"; Rec."Issuing Country")
                {
                    ApplicationArea = All;
                }
            }
            group(Contracts)
            {
                Caption = 'Contract';
                field("Contract No"; Rec."Contract No")
                {
                    ApplicationArea = All;
                }
                field("Contract Version No."; Rec."Contract Version No.")
                {
                    ApplicationArea = All;
                }
                field("Registry Reference No."; Rec."Registry Reference No.")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Control3; "Employee Picture")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = true;
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

                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    ApplicationArea = All;
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Employee),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    ApplicationArea = All;
                    RunPageLink = "Table ID" = CONST(5200),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("Revoke Termination")
                {
                    Image = Undo;
                    ApplicationArea = All;
                    TRIGGER OnAction()
                    VAR
                        FandFJournal: Record "Full and Final Calculation";
                        RevertTermination: Report "Employee Termination Revert";
                    BEGIN
                        FandFJournal.RESET;
                        FandFJournal.SETRANGE("Employee No.", Rec."No.");
                        IF FandFJournal.FindFirst() THEN BEGIN
                            ERROR('Full and Final Settlement created for the selected employee, Please redo the process');
                        END;
                        CLEAR(RevertTermination);
                        RevertTermination.SetValues(Rec."No.");
                        RevertTermination.Run();
                    END;
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    ApplicationArea = All;
                    RunPageLink = "No." = FIELD("No.");
                }
                action(AlternativeAddresses)
                {
                    Caption = '&Alternative Addresses';
                    ApplicationArea = All;
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("&Relatives")
                {
                    Caption = '&Relatives';
                    ApplicationArea = All;
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Mi&sc. Article Information")
                {
                    Caption = 'Mi&sc. Article Information';
                    ApplicationArea = All;
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("&Confidential Information")
                {
                    Caption = '&Confidential Information';
                    ApplicationArea = All;
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Q&ualifications")
                {
                    Caption = 'Q&ualifications';
                    ApplicationArea = All;
                    Image = Certificate;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("A&bsences")
                {
                    Caption = 'A&bsences';
                    ApplicationArea = All;
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                separator(Separator23)
                {
                }
                action("Absences by Ca&tegories")
                {
                    Caption = 'Absences by Ca&tegories';
                    ApplicationArea = All;
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No."),
                                  "Employee No. Filter" = FIELD("No.");
                }
                action("Misc. Articles &Overview")
                {
                    Caption = 'Misc. Articles &Overview';
                    ApplicationArea = All;
                    Image = FiledOverview;
                }
                action("Co&nfidential Info. Overview")
                {
                    Caption = 'Co&nfidential Info. Overview';
                    ApplicationArea = All;
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                }
                separator(Separator61)
                {
                }
                action("Online Map")
                {
                    Caption = 'Online Map';
                    ApplicationArea = All;
                    Image = Map;

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
                action(Insurance)
                {
                    Caption = 'Insurance';
                    ApplicationArea = All;
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;
                }
                action("New Insurance")
                {
                    Caption = 'New Insurance';
                    ApplicationArea = All;
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                }
            }
        }
        area(processing)
        {
            Description = 'Advance Payroll';
            action("Earning Code")
            {
                Image = Production;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    EmployeeEarningCodeGroup.RESET;
                    EmployeeEarningCodeGroup.SETRANGE("Employee Code", Rec."No.");
                    EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', WORKDATE);
                    EmployeeEarningCodeGroup.SETFILTER("Valid To", '>%1|%2', WORKDATE, 0D);
                    if EmployeeEarningCodeGroup.FINDFIRST then;
                    PayrollEarningCodeWrkr.RESET;
                    PayrollEarningCodeWrkr.FILTERGROUP(2);
                    PayrollEarningCodeWrkr.SETRANGE(Worker, Rec."No.");
                    PayrollEarningCodeWrkr.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    PayrollEarningCodeWrkr.FILTERGROUP(0);
                    PAGE.RUNMODAL(60041, PayrollEarningCodeWrkr);
                end;
            }
            action("Leave Type")
            {
                Image = Holiday;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    EmployeeEarningCodeGroup.RESET;
                    EmployeeEarningCodeGroup.SETRANGE("Employee Code", Rec."No.");
                    EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', WORKDATE);
                    EmployeeEarningCodeGroup.SETFILTER("Valid To", '>%1|%2', WORKDATE, 0D);
                    if EmployeeEarningCodeGroup.FINDFIRST then;
                    HCMLeaveTypesWrkr.RESET;
                    HCMLeaveTypesWrkr.FILTERGROUP(2);
                    HCMLeaveTypesWrkr.SETRANGE(Worker, Rec."No.");
                    HCMLeaveTypesWrkr.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    HCMLeaveTypesWrkr.FILTERGROUP(0);
                    PAGE.RUNMODAL(60039, HCMLeaveTypesWrkr);
                end;
            }
            action(Benefit)
            {
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    EmployeeEarningCodeGroup.RESET;
                    EmployeeEarningCodeGroup.SETRANGE("Employee Code", Rec."No.");
                    EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', WORKDATE);
                    EmployeeEarningCodeGroup.SETFILTER("Valid To", '>%1|%2', WORKDATE, 0D);
                    if EmployeeEarningCodeGroup.FINDFIRST then;

                    HCMBenefitWrkr.RESET;
                    HCMBenefitWrkr.FILTERGROUP(2);
                    HCMBenefitWrkr.SETRANGE(Worker, Rec."No.");
                    HCMBenefitWrkr.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    HCMBenefitWrkr.FILTERGROUP(0);
                    PAGE.RUNMODAL(60043, HCMBenefitWrkr);
                end;
            }
            action(Loans)
            {
                Image = Loaner;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    EmployeeEarningCodeGroup.RESET;
                    EmployeeEarningCodeGroup.SETRANGE("Employee Code", Rec."No.");
                    EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', WORKDATE);
                    EmployeeEarningCodeGroup.SETFILTER("Valid To", '>%1|%2', WORKDATE, 0D);
                    if EmployeeEarningCodeGroup.FINDFIRST then;

                    HCMLoanTableGCCWrkr.RESET;
                    HCMLoanTableGCCWrkr.FILTERGROUP(2);
                    HCMLoanTableGCCWrkr.SETRANGE(Worker, Rec."No.");
                    HCMLoanTableGCCWrkr.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    HCMLoanTableGCCWrkr.FILTERGROUP(0);
                    PAGE.RUNMODAL(60045, HCMLoanTableGCCWrkr);
                end;
            }
            action("Earning Code Group")
            {
                Image = PaymentJournal;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedIsBig = true;
            }
            action("Accrual Components")
            {
                Caption = 'Accrual Components';
                Image = Agreement;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
            action("Employee Position Assignment")
            {
                Image = Position;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Employee Work Date")
            {
                Image = Workdays;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;
                Scope = Repeater;
            }
            action("Employee Dependents")
            {
                Image = Delegate;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
            }
            action("Employee Identification")
            {
                Image = Document;
                ApplicationArea = All;
            }
            action("Asset Assignment Register")
            {
                Image = FixedAssets;
                ApplicationArea = All;
            }
            action(Contract)
            {
                Caption = 'Employee Contracts';
                ApplicationArea = All;
                Image = Certificate;
            }
            action("Contract List")
            {
                Caption = 'Employee Contracts List';
                Image = ListPage;
                ApplicationArea = All;
                Visible = false;
            }
            action("Employee Bank Details")
            {
                Caption = 'Employee Bank Details';
                Image = BankAccount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Employee Payout Scheme")
            {
                Caption = 'Employee Payout Scheme';
                Image = Salutation;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Employee Termination")
            {
                Image = TerminationDescription;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CLEAR(EmployeeTermination);
                    EmployeeTermination.SetValues(Rec."No.");
                    EmployeeTermination.RUNMODAL;
                    CurrPage.UPDATE;
                end;
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

    var
        EmplErngCodegrp: Record "Employee Earning Code Groups";
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
        HCMLeaveTypesWrkr: Record "HCM Leave Types Wrkr";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        HCMLoanTableGCCWrkr: Record "HCM Loan Table GCC Wrkr";
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        Age: Decimal;
        EmployeeTermination: Report "Employee Termination";
}