page 60045 "HCM Loan Table GCC Wrkrs"
{
    CardPageID = "HCM Loan Table GCC Wrkr";
    Editable = false;
    PageType = List;
    SourceTable = "HCM Loan Table GCC Wrkr";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Worker; Rec.Worker)
                {
                    ApplicationArea = All;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec."Loan Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."Loan Description")
                {
                    ApplicationArea = All;
                }
                field("Local Description"; Rec."Arabic Name")
                {
                    ApplicationArea = All;
                }
                field("Calculation Basis"; Rec."Calculation Basis")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        EditableFunction;
                    end;
                }
                field("Earning Code for Principal"; Rec."Earning Code for Principal")
                {
                    ApplicationArea = All;
                }
                field("Earning Code for Interest"; Rec."Earning Code for Interest")
                {
                    ApplicationArea = All;
                }
                field("No. of times Earning Code"; Rec."No. of times Earning Code")
                {
                    ApplicationArea = All;
                    Enabled = EarningCodeEditable;
                }
                field("Min Amount"; Rec."Min Loan Amount")
                {
                    ApplicationArea = All;
                    Editable = MinEditable;
                }
                field("Max Amount"; Rec."Max Loan Amount")
                {
                    ApplicationArea = All;
                    Editable = MinEditable;
                }
                field("Interest %"; Rec."Interest Percentage")
                {
                    ApplicationArea = All;
                }
                field("Allow Multiple Loans"; Rec."Allow Multiple Loans")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("Number of Installment"; Rec."Number of Installment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EditableFunction;
    end;

    trigger OnOpenPage()
    begin
        EditableFunction;
    end;

    var
        MinEditable: Boolean;
        MultipleEditable: Boolean;
        EarningCodeEditable: Boolean;

    local procedure EditableFunction()
    begin
        if Rec."Calculation Basis" = Rec."Calculation Basis"::"Min/Max Amount" then begin
            EarningCodeEditable := false;
            MinEditable := true;
        end;

        if Rec."Calculation Basis" = Rec."Calculation Basis"::"Multiple Earning Code" then begin
            EarningCodeEditable := true;
            MinEditable := false;
        end
    end;
}