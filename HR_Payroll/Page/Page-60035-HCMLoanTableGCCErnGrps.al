page 60035 "HCM Loan Table GCC ErnGrps"
{
    CardPageID = "HCM Loan Table GCC ErnGrp";
    PageType = List;
    SourceTable = "HCM Loan Table GCC ErnGrp";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Code"; Rec."Loan Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."Loan Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Local Description"; Rec."Arabic Name")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Caption = 'Active';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Earning Code Selection")
            {
                ApplicationArea = All;
                Enabled = EarningCodeEditable;
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    MultipleEarningCodes.SETRANGE("Loan Code", Rec."Loan Code");
                    if PAGE.RUNMODAL(0, MultipleEarningCodes) = ACTION::LookupOK then begin
                    end;
                end;
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
        EarningCodeEditable: Boolean;
        MultipleEarningCodes: Record "Multiple Earning Codes";

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