page 60183 "Loan Adjustment  Lines"
{
    PageType = ListPart;
    SourceTable = "Loan Adjustment Lines";
    SourceTableView = SORTING("Entry No.", "Loan Adjustment ID") ORDER(Ascending);
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan Request ID"; Rec."Loan Request ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Loan; Rec.Loan)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Loan Description"; Rec."Loan Description")
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
                field("Installament Date"; Rec."Installament Date")
                {
                    Caption = 'Installment Date';
                    ApplicationArea = All;
                }
                field("Principal Installment Amount"; Rec."Principal Installment Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Installment Amount"; Rec."Interest Installment Amount")
                {
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
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
            action("Create new loan line")
            {
                Image = CreateYear;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    LoanAdjustmentLines.RESET;
                    LoanAdjustmentLines.SETRANGE("Loan Adjustment ID", Rec."Loan Adjustment ID");
                    LoanAdjustmentLines.SETRANGE("Loan Request ID", Rec."Loan Request ID");
                    LoanAdjustmentLines.SETRANGE(Loan, Rec.Loan);
                    LoanAdjustmentLines.SETRANGE("Employee ID", Rec."Employee ID");
                    if LoanAdjustmentLines.FINDLAST then begin
                        LoanAdjustmentLines.INIT;
                        LoanAdjustmentLines."Entry No." := LoanAdjustmentLines."Entry No." + 1;
                        LoanAdjustmentLines."Loan Adjustment ID" := Rec."Loan Adjustment ID";
                        LoanAdjustmentLines."Loan Request ID" := Rec."Loan Request ID";
                        LoanAdjustmentLines.Loan := Rec.Loan;
                        LoanAdjustmentLines."Loan Description" := Rec."Loan Description";
                        LoanAdjustmentLines."Employee ID" := Rec."Employee ID";
                        LoanAdjustmentLines."Employee Name" := Rec."Employee Name";
                        LoanAdjustmentLines."Installament Date" := 0D;
                        LoanAdjustmentLines."Principal Installment Amount" := 0;
                        LoanAdjustmentLines."Interest Installment Amount" := 0;
                        LoanAdjustmentLines.Currency := Rec.Currency;
                        LoanAdjustmentLines.Status := LoanAdjustmentLines.Status::Unrecovered;
                        LoanAdjustmentLines."New Line" := true;
                        if LoanAdjustmentLines.INSERT(true) then
                            MESSAGE(Text001);
                    end;
                end;
            }
        }
    }

    var
        LoanAdjustmentLines: Record "Loan Adjustment Lines";
        Text001: Label 'New Loan Adjustment Line has been created !';
}