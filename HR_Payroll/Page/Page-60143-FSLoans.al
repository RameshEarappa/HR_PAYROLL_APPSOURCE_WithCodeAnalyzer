page 60143 "FS Loans"
{
    PageType = ListPart;
    SourceTable = "FS Loans";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Request ID"; Rec."Loan Request ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Loan; Rec.Loan)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Installment Date"; Rec."Installment Date")
                {
                    ApplicationArea = All;
                }
                field("Installement Amount"; Rec."EMI Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Amount be Recovered"; Rec."Installment Amount")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
}