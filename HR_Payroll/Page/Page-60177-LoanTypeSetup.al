page 60177 "Loan Type Setup"
{
    Caption = 'Loan Setup';
    PageType = Card;
    SourceTable = "Loan Type Setup";
    SourceTableView = SORTING("Loan Code")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec."Loan Code")
                {
                    Editable = false;
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
                    Enabled = EarningCodeEditable;
                    ApplicationArea = All;
                }
                field("Min Amount"; Rec."Min Loan Amount")
                {
                    Editable = MinEditable;
                    ApplicationArea = All;
                }
                field("Max Amount"; Rec."Max Loan Amount")
                {
                    Editable = MinEditable;
                    ApplicationArea = All;
                }
                field("Interest %"; Rec."Interest Percentage")
                {
                    ApplicationArea = All;
                }
                field("Payout Earning Code"; Rec."Payout Earning Code")
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
                field("Loan Type Template"; Rec."Loan Type Template")
                {
                    Caption = 'Loan Type Template';
                    ApplicationArea = All;
                }
                field("Loan Type Journal Batch"; Rec."Loan Type Journal Batch")
                {
                    Caption = 'Loan Type Journal Batch';
                    ApplicationArea = All;
                }
                field("Number of Installments"; Rec."Number of Installments")
                {
                    ApplicationArea = All;
                }
                field("No. of Loans in a Year"; Rec."No. of Loans in a Year")
                {
                    ApplicationArea = All;
                }
                field("Vendor Posting"; Rec."Vendor Posting") { ApplicationArea = All; }
            }
            group("Accounting Setup")
            {
                group("Main Account")
                {
                    field("Main Account Type"; Rec."Main Account Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Main Account No."; Rec."Main Account No.")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Offset Account")
                {
                    field("Offset Account Type"; Rec."Offset Account Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Offset Account No."; Rec."Offset Account No.")
                    {
                        ApplicationArea = All;
                    }
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
                Enabled = EarningCodeEditable;
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    MultipleEarningCodes.SETRANGE("Loan Code", Rec."Loan Code");

                    if PAGE.RUNMODAL(0, MultipleEarningCodes) = ACTION::LookupOK then begin
                    end
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
        MultipleEarningCodes: Record "Multiple Earning Codes";
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