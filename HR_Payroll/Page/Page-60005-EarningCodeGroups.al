page 60005 "Earning Code Groups"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Earning Code Groups";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group1)
            {
                field("Grade Category"; Rec."Grade Category")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Calendar; Rec.Calendar)
                {
                    ApplicationArea = All;
                }
                field("Gross Salary"; Rec."Gross Salary")
                {
                    ApplicationArea = All;
                }
                field("Travel Class"; Rec."Travel Class")
                {
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                }
                field("Insurance Service Provider"; Rec."Insurance Service Provider")
                {
                    ApplicationArea = All;
                }
                field("Edit Service Package"; Rec."Edit Service Package")
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
            action("Earning Code")
            {
                ApplicationArea = All;
                Image = Production;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Payroll Earning Code ErnGrps";
                RunPageLink = "Earning Code Group" = FIELD("Earning Code Group");
            }
            action("Leave Type")
            {
                ApplicationArea = All;
                Image = Holiday;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HCM Leave Types ErnGrps";
                RunPageLink = "Earning Code Group" = FIELD("Earning Code Group");
            }
            action(Benefit)
            {
                ApplicationArea = All;
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HCM Benefit ErnGrp";
                RunPageLink = "Earning Code Group" = FIELD("Earning Code Group");
            }
            action(Loans)
            {
                ApplicationArea = All;
                Image = Loaner;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HCM Loan Table GCC ErnGrps";
                RunPageLink = "Earning Code Group" = FIELD("Earning Code Group");
            }
            action("Copy Earning Code Group")
            {
                ApplicationArea = All;
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CLEAR(CopyEarningCode);
                    CopyEarningCode.SetValues(Rec."Earning Code Group", Rec."Grade Category");
                    CopyEarningCode.RUNMODAL;
                end;
            }
            action("Educational Allowance")
            {
                ApplicationArea = All;
                Image = Allocations;
                Promoted = true;
                PromotedCategory = New;
                PromotedOnly = true;

                trigger OnAction()
                var
                    EducationalAllowanceRecL: Record "Educational Allowance LT";
                    EducationalAllowanceCardLT: Page "Educational Allowance Card";
                begin
                    EducationalAllowanceRecL.RESET;
                    EducationalAllowanceRecL.SETRANGE("Earnings Code Group", Rec."Earning Code Group");
                    EducationalAllowanceRecL.SETRANGE("Grade Category", Rec."Grade Category");
                    if EducationalAllowanceRecL.FINDFIRST then
                        PAGE.RUNMODAL(60066, EducationalAllowanceRecL)
                    else begin
                        EducationalAllowanceRecL.INIT;
                        EducationalAllowanceRecL.VALIDATE("Earnings Code Group", Rec."Earning Code Group");
                        EducationalAllowanceRecL.VALIDATE("Grade Category", Rec."Grade Category");
                        EducationalAllowanceRecL.INSERT;
                        COMMIT;
                        PAGE.RUNMODAL(60066, EducationalAllowanceRecL);
                    end;
                end;
            }
            action("Update Insurance")
            {
                ApplicationArea = All;
                Image = Bank;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(EarningCodeGroups);
                    if EarningCodeGroups.FINDSET then begin
                        repeat
                            EmployeeEarningCodeGroups.RESET;
                            EmployeeEarningCodeGroups.SETRANGE("Earning Code Group", EarningCodeGroups."Earning Code Group");
                            EmployeeEarningCodeGroups.SETRANGE("Valid To", 0D);
                            if EmployeeEarningCodeGroups.FINDSET then begin
                                repeat
                                    EmpRec.RESET;
                                    EmpRec.SETRANGE("No.", EmployeeEarningCodeGroups."Employee Code");
                                    EmpRec.SETRANGE("Earning Code Group", EmployeeEarningCodeGroups."Earning Code Group");
                                    if EmpRec.FINDFIRST then begin
                                        EmpInsuranceRec.RESET;
                                        EmpInsuranceRec.SETRANGE("Employee Id", EmpRec."No.");
                                        if EmpInsuranceRec.FINDSET then begin
                                            repeat
                                                EmpInsuranceRec."Insurance Service Provider" := EarningCodeGroups."Insurance Service Provider";
                                                EmpInsuranceRec.MODIFY;
                                            until EmpInsuranceRec.NEXT = 0;
                                        end;
                                    end;
                                until EmployeeEarningCodeGroups.NEXT = 0;
                            end;
                        until EarningCodeGroups.NEXT = 0;
                    end;
                    MESSAGE(InsuranceMsg);
                end;
            }
            action("Perdiem Eligliblity Category")
            {
                ApplicationArea = All;
                Image = Category;
                Promoted = true;
                PromotedCategory = New;
                PromotedOnly = true;
                Visible = false;
            }
            action("Evaluation Master")
            {
                ApplicationArea = All;
                Image = Questionaire;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Evaluation RQ Sub Master";
                RunPageLink = "Earning Code Group" = FIELD("Earning Code Group");

                trigger OnAction()
                var
                    EvaluationRQSubMasterRecL: Page "Evaluation RQ Sub Master";
                begin
                    EvaluationMasterSingleCUG.SetEarningCodeGroup(Rec."Earning Code Group");
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
            if Rec."Earning Code Group" <> '' then begin
                Rec.TESTFIELD(Calendar);
                Rec.TESTFIELD("Grade Category");
                Rec.TESTFIELD(Currency);
            end;
        end;
    end;

    var
        CopyEarningCode: Report "Copy Earning Code Group";
        EarnCodeGrpRec: Record "Earning Code Groups";
        EmpRec: Record Employee;
        EmpInsuranceRec: Record "Employee Insurance";
        InsuranceMsg: Label 'Updated Insurance Service Provider for all Employee';
        EmployeeInsurance: Record "Employee Insurance";
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
        EarningCodeGroups: Record "Earning Code Groups";
        EvaluationMasterSingleCUG: Codeunit "Evaluation Master Single CU";
}