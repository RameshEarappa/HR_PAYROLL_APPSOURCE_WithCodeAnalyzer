page 60162 "Loan Generation"
{
    Caption = 'Loan Generation';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Loan Installment Generation";

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
                    ApplicationArea = All;
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Installament Date"; Rec."Installament Date")
                {
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
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Recovery Status';
                    ApplicationArea = All;
                }
            }
        }
    }
}