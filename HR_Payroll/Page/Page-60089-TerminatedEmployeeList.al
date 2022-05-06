page 60089 "Terminated Employee List"
{
    Caption = 'Past Employee List';
    CardPageID = "Terminated Employee Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Employee;
    SourceTableView = WHERE(Status = FILTER(Terminated | Inactive));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies a number for the employee.';
                    ApplicationArea = All;
                }
                field(FullName; Rec.FullName)
                {
                    Caption = 'Full Name';
                    ToolTip = 'Specifies the full name of the employee.';
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the employee''s first name.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the employee''s middle name.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the employee''s last name.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Initials; Rec.Initials)
                {
                    ToolTip = 'Specifies the employee''s initials.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the employee''s job title.';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the postal code of the address.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region code.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Extension; Rec.Extension)
                {
                    ToolTip = 'Specifies the employee''s telephone extension.';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the employee''s telephone number.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the employee''s mobile telephone number.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the employee''s email address.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    ToolTip = 'Specifies a statistics group code to assign to the employee for statistical purposes.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies a resource number for the employee, if the employee is a resource in Resources Planning.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies a search name for the employee.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies if a comment has been entered for this entry.';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
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
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    ApplicationArea = All;
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Employee),
                                  "No." = FIELD("No.");
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(5200),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ApplicationArea = All;
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension = R;
                        Caption = 'Dimensions-&Multiple';
                        ApplicationArea = All;
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            Employee: Record Employee;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(Employee);
                            DefaultDimMultiple.SetMultiEmployee(Employee);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action(AlternativeAddresses)
                {
                    Caption = '&Alternative Addresses';
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    ApplicationArea = All;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                }
                action("&Relatives")
                {
                    Caption = '&Relatives';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Mi&sc. Article Information")
                {
                    Caption = 'Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Co&nfidential Information")
                {
                    Caption = 'Co&nfidential Information';
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Q&ualifications")
                {
                    Caption = 'Q&ualifications';
                    Image = Certificate;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("A&bsences")
                {
                    Caption = 'A&bsences';
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                separator(Separator51)
                {
                }
                action("Absences by Ca&tegories")
                {
                    Caption = 'Absences by Ca&tegories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No."),
                                  "Employee No. Filter" = FIELD("No.");
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Misc. Articles &Overview")
                {
                    Caption = 'Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = Page "Misc. Articles Overview";
                    Visible = false;
                    ApplicationArea = All;
                }
                action("Con&fidential Info. Overview")
                {
                    Caption = 'Con&fidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            action("Absence Registration")
            {
                Caption = 'Absence Registration';
                Image = Absence;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Absence Registration";
                Visible = false;
                ApplicationArea = All;
            }
            action("Earning Code Group")
            {
                Image = PaymentJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action("Earning Code")
            {
                Caption = 'Earning Codes';
                Image = Production;
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
                Caption = 'Leaves';
                Image = Holiday;
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
                    HCMLeaveTypesWrkr.RESET;
                    HCMLeaveTypesWrkr.FILTERGROUP(2);
                    HCMLeaveTypesWrkr.SETRANGE(Worker, Rec."No.");
                    HCMLeaveTypesWrkr.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    HCMLeaveTypesWrkr.FILTERGROUP(0);
                    PAGE.RUNMODAL(60039, HCMLeaveTypesWrkr);
                end;
            }
            action(Benefits)
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
                PromotedIsBig = true;
                ApplicationArea = All;

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
            action("Employee Position Assignment")
            {
                Caption = 'Position Assignment';
                Image = Position;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                RunObject = Page "Employee Position Assignments";
                RunPageLink = Worker = FIELD("No.");
            }
            action("Employee Work Date")
            {
                Caption = 'Work Calendar';
                Image = Workdays;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                RunObject = Page "Employee Work Dates";
                RunPageLink = "Employee Code" = FIELD("No.");
                RunPageMode = View;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
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
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
        HCMLeaveTypesWrkr: Record "HCM Leave Types Wrkr";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        HCMLoanTableGCCWrkr: Record "HCM Loan Table GCC Wrkr";
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        Age: Decimal;
}