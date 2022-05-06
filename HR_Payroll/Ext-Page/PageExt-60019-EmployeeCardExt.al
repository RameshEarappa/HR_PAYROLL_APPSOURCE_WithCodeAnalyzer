pageextension 60019 EmployeeCardExt extends "Employee Card"
{
    layout
    {
        addlast(General)
        {
            field("Professional Title in Arabic"; Rec."Professional Title in Arabic")
            {
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
                ShowMandatory = true;
                ApplicationArea = All;
            }

            field("Joining Date"; Rec."Joining Date")
            {
                Editable = EditAssignPosition;
                ShowMandatory = true;
                ApplicationArea = All;

            }
            field("Joining Date - Hijiri"; Rec."D.O.J Hijiri")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("Probation Months"; Rec."Probation Months")
            {
                ApplicationArea = All;
            }
            field("Probation Period"; Rec."Probation Period")
            {
                ApplicationArea = All;
            }
            field(Department; Department())
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Department Value"; Rec."Department Value")
            {
                ApplicationArea = All;
                Visible = FALSE;
            }
            field("Sub Department"; SubDepartment())
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
            field(Sponcer; Rec.Sponcer)
            {
                ApplicationArea = All;
                Caption = 'Sponser';
            }
            field("Vendor Account"; Rec."Vendor Account")
            {
                ApplicationArea = All;
            }
        }
        addafter(General)
        {
            part("Address Part "; "Employee Address ListPart")
            {
                Caption = 'Address';
                ApplicationArea = All;
                SubPageLink = "Employee ID" = FIELD("No."), "Table Type Option" = FILTER("Employee Address Line");
            }
            part(Contacts; "Employee Contacts SubPage")
            {
                Caption = 'Contacts';
                ApplicationArea = All;
                SubPageLink = "Employee ID" = FIELD("No."), "Table Type Option" = FILTER("Employee Contacts Line");
            }
        }

        addlast(Administration)
        {
            field("Employment Start Date"; Rec."Employment Date")
            {
                Caption = 'Employment Start Date';
                Importance = Promoted;
                ToolTip = 'Specifies the date when the employee began to work for the company.';
                Visible = false;
                ApplicationArea = All;
            }
            field("Employment End Date"; Rec."Employment End Date")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Employment Type"; Rec."Employment Type")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field("Seperation Reason"; Rec."Seperation Reason")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Unsatisfactory Grade"; Rec."Unsatisfactory Grade")
            {
                Editable = false;
                ApplicationArea = All;
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
                Editable = false;
                ApplicationArea = All;
            }
            field("Old Employee ID"; Rec."Old Employee ID")
            {
                ApplicationArea = All;
            }
            field(Type; Rec.Type)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Remarks; Rec.Remarks)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Employee notice period in Days"; Rec."Employee notice period in Days")
            {

                ApplicationArea = All;
            }
            field("Revoke Termination Date"; Rec."Revoke Termination Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addlast(Personal)
        {
            field("Birth Date - Hijiri"; Rec."B.O.D Hijiri")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Age As Of Date"; Rec."Age As Of Date")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field(Religion; Rec."Employee Religion")
            {
                ShowMandatory = true;
                Caption = 'Religion';
                ApplicationArea = All;
            }
            field(Nationality; Rec.Nationality)
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field("Nationality In Arabic"; Rec."Nationality In Arabic")
            {
                ApplicationArea = All;
            }
            field("Blood Group"; Rec."Blood Group")
            {
                ApplicationArea = All;
            }
        }
        addafter(Personal)
        {
            group("Employee Grade Details")
            {
                Caption = 'Employee Grade Details';
                field("Grade Category"; Rec."Grade Category")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Increment step"; Rec."Increment step")
                {
                    ApplicationArea = All;
                    Visible = false;
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
            group(Contract_)
            {
                Visible = false;
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
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
        modify("Address & Contact")
        {
            Visible = false;
        }
        modify("Job Title")
        {
            Editable = false;
        }
        modify("Employment Date")
        {
            ShowMandatory = true;
        }
        modify(Gender)
        {
            ShowMandatory = true;
        }
        modify("Birth Date")
        {
            ShowMandatory = true;
        }
        modify("No.")
        {
            Editable = false;
        }
        modify("Social Security No.")
        {
            Visible = false;
        }
        modify("Union Code")
        {
            Visible = false;
        }
        modify("Union Membership No.")
        {
            Visible = false;
        }
    }

    actions
    {
        addafter("E&mployee")
        {
            group(processing)
            {
                Description = 'Advance Payroll';
                group("Other Actions")
                {
                    Caption = 'Other Actions';
                    Image = LotInfo;
                    action("Accrual Components")
                    {
                        Caption = 'Accrual Components';
                        Image = Agreement;
                        ApplicationArea = All;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Accrual Components Workers-2";
                        RunPageLink = "Worker ID" = FIELD("No.");
                    }
                    action(Contract)
                    {
                        Caption = 'Employee Contracts';
                        Image = Certificate;
                        Visible = false;
                        ApplicationArea = All;
                        Promoted = true;
                        PromotedIsBig = true;
                        PromotedCategory = Process;
                    }
                    action("Asset Assignment Register")
                    {
                        Caption = 'Asset Register';
                        Gesture = LeftSwipe;
                        Image = FixedAssets;
                        ApplicationArea = All;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Asset Assignment Register_List";
                        RunPageLink = "Issue to/Return by" = FIELD("No."), Posted = FILTER(true);
                    }
                    action("Employee Termination")
                    {
                        Caption = 'Employee Separation';
                        Image = Absence;
                        ApplicationArea = All;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;

                        trigger OnAction()
                        begin
                            CLEAR(EmployeeTermination);
                            EmployeeTermination.SetValues(Rec."No.");
                            EmployeeTermination.RUNMODAL;
                            CurrPage.UPDATE;
                        end;
                    }
                    action("Employee Education")
                    {
                        Image = EmployeeAgreement;
                        ApplicationArea = All;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Employee Education List";
                        RunPageLink = "Emp ID" = FIELD("No.");
                    }
                    action("Employee Skills")
                    {
                        Image = Skills;
                        Promoted = true;
                        ApplicationArea = All;
                        PromotedCategory = Process;
                        RunObject = Page "Employee Skills List";
                        RunPageLink = "Emp ID" = FIELD("No.");
                    }
                    action("Employee Certificate")
                    {
                        Image = Certificate;
                        ApplicationArea = All;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Employee Certificates List";
                        RunPageLink = "Emp ID" = FIELD("No.");
                    }
                    action("Employee Professional Exp.")
                    {
                        Image = EmployeeAgreement;
                        ApplicationArea = All;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Employee Prof. Exp. List";
                        RunPageLink = "Emp No." = FIELD("No.");
                        ToolTip = 'Employee Professional Exprience of Last Employer';
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
                }
                group("Home Actions")
                {
                    Caption = 'Home Actions';
                    action("Earning Code Group")
                    {
                        Image = PaymentJournal;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        ApplicationArea = All;
                        RunObject = Page "Employee Earning Code Groups";
                        RunPageLink = "Earning Code Group" = FIELD("Earning Code Group"), "Employee Code" = field("No.");
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
                            IF EmployeeEarningCodeGroup.FINDFIRST THEN;
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
                            IF EmployeeEarningCodeGroup.FINDFIRST THEN;
                            HCMLeaveTypesWrkr.RESET;
                            HCMLeaveTypesWrkr.FILTERGROUP(2);
                            HCMLeaveTypesWrkr.SETRANGE(Worker, Rec."No.");
                            HCMLeaveTypesWrkr.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                            HCMLeaveTypesWrkr.FILTERGROUP(0);
                            if HCMLeaveTypesWrkr.FindSet() then begin
                                PAGE.RUNMODAL(60039, HCMLeaveTypesWrkr);
                            end;
                        end;
                    }
                    action(Benefit)
                    {
                        Caption = 'Benefits';
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
                            IF EmployeeEarningCodeGroup.FINDFIRST THEN;
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
                            IF EmployeeEarningCodeGroup.FINDFIRST THEN;

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
                        Scope = Repeater;
                    }
                    action("Employee Dependents")
                    {
                        Caption = 'Dependents';
                        Image = Relatives;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        ApplicationArea = All;
                        RunObject = Page "Employee Dependent List";
                        RunPageLink = "Employee ID" = FIELD("No.");


                    }
                    action("Employee Identification")
                    {
                        Caption = 'Identifications';
                        Image = ContactPerson;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        ApplicationArea = All;
                        RunObject = Page "Employee Identification_MS-1";
                        RunPageLink = "Employee No." = FIELD("No."), "No." = FILTER(<> '');
                    }
                    action("Employee Bank Details")
                    {
                        Caption = 'Bank Details';
                        Image = Bank;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        ApplicationArea = All;
                        RunObject = Page "Employee Bank Account List";
                        RunPageLink = "Employee Id" = FIELD("No.");
                    }
                    Action(Test_Short_Leave)
                    {
                        Caption = 'SL_lEAVE';
                        Image = Holiday;
                        Promoted = true;
                        PromotedOnly = true;
                        Visible = false;
                        RunObject = Page "Short Leave Request List";
                        ApplicationArea = ALL;

                    }
                    action(Insurance)
                    {
                        Caption = 'Insurance';
                        Image = TotalValueInsured;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        ApplicationArea = All;
                        RunObject = Page "Employee Insurance List";
                        RunPageLink = "Employee Id" = FIELD("No.");
                    }
                    action("Employee Delegation")
                    {
                        Caption = 'Delegate Workflow';
                        Image = ChangeCustomer;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        ApplicationArea = All;
                        Visible = true;
                        RunObject = Page "Employee Delegation List";
                        RunPageLink = "Employee Code" = FIELD("No.");
                    }
                    action("Contract List")
                    {
                        Caption = 'Employee Contracts List';
                        Image = ListPage;
                        ApplicationArea = All;
                        Visible = false;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        EmplErngCodegrp.RESET;
        EmplErngCodegrp.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
        EmplErngCodegrp.SETRANGE("Employee Code", Rec."No.");
        EmplErngCodegrp.SETFILTER("Valid From", '<=%1', WORKDATE);
        EmplErngCodegrp.SETFILTER("Valid To", '>=%1|%2', WORKDATE, 0D);
        IF EmplErngCodegrp.FINDFIRST THEN BEGIN
            Rec."Earning Code Group" := EmplErngCodegrp."Earning Code Group";
            Rec.MODIFY;
            COMMIT;
        END;
        CLEAR(Rec."Age As Of Date");
        CLEAR(Age);
        IF Rec."Birth Date" <> 0D THEN BEGIN
            Age := -(Rec."Birth Date" - TODAY);
            IF Age <> 0 THEN
                Rec."Age As Of Date" := FORMAT(ROUND((Age / 365.27), 0.1));
        END;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CLEAR(EditAssignPosition);
        PayrollJobPosWorkerAssign.RESET;
        PayrollJobPosWorkerAssign.SETRANGE(Worker, Rec."No.");
        PayrollJobPosWorkerAssign.SETRANGE("Position Assigned", TRUE);
        IF PayrollJobPosWorkerAssign.FINDFIRST THEN
            EditAssignPosition := FALSE
        ELSE
            EditAssignPosition := TRUE;
    end;

    local procedure CheckMand()
    begin
        Rec.TESTFIELD("Marital Status");
        IF Rec.Gender = Rec.Gender::" " THEN
            ERROR('Please select Gender');
        Rec.TESTFIELD("Birth Date");
        Rec.TESTFIELD("Employee Religion");
        Rec.TestField("Joining Date");
        Rec.TestField("Employee Religion");
        Rec.TestField(Nationality);
        Rec.TestField("Employment Type");
    end;

    trigger OnClosePage()
    begin
        CheckMand();
    end;

    var
        EmplErngCodegrp: Record "Employee Earning Code Groups";
        PayrollEarningCodeWrkr: Record "Payroll Earning Code Wrkr";
        HCMLeaveTypesWrkr: Record "HCM Leave Types Wrkr";
        HCMBenefitWrkr: Record "HCM Benefit Wrkr";
        HCMLoanTableGCCWrkr: Record "HCM Loan Table GCC Wrkr";
        EmpDepMasterRec: Record "Employee Dependents Master";
        EmployeeRec2: Record Employee;
        EmployeeDependentPage: Page "HCM Benefit Wrkr";
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        AssetAssigntReg: Record "Asset Assignment Register";
        Age: Decimal;
        EmployeeTermination: Report "Employee Termination";
        DelegateWFLTRec_G: Record "Delegate - WFLT";
        UserSetupRec_G: Record "User Setup";
        PayrollJobPosWorkerAssign: Record "Payroll Job Pos. Worker Assign";
        EditAssignPosition: Boolean;

    procedure Department(): Text
    var
        DepartmentRecL: Record "Payroll Department";
    begin
        DepartmentRecL.Reset();
        DepartmentRecL.SetRange("Department ID", Rec.Department);
        if DepartmentRecL.FindFirst() then
            exit(DepartmentRecL.Description);
    end;

    procedure SubDepartment(): Text
    var
        DepartmentRecL: Record "Sub Department";
    begin
        DepartmentRecL.Reset();
        DepartmentRecL.SetRange("Department ID", Rec.Department);
        DepartmentRecL.SetRange("Sub Department ID", Rec."Sub Department");
        if DepartmentRecL.FindFirst() then
            exit(DepartmentRecL.Description);
    end;
}