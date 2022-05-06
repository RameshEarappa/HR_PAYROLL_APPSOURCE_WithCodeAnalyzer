page 70166 "Loan Requests RC List ESS"
{
    CardPageID = "Loan Request Ess";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Loan Request";
    SourceTableView = SORTING("Entry No.") ORDER(Ascending);

    UsageCategory = Lists;
    ApplicationArea = All;

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
                field("Loan Type"; Rec."Loan Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field("Request Amount"; Rec."Request Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Number of Installments"; Rec."Number of Installments")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; Rec."Created Time")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Installment Created"; Rec."Installment Created")
                {
                    ApplicationArea = All;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("WorkFlow Status"; Rec."WorkFlow Status")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(New)
            {
                Caption = 'New';
                Image = New;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    EssCUL: Codeunit "ESS RC Page";
                    Rec2: Record "Loan Request";
                BEGIN
                    Rec2.Reset();
                    Rec2.Init();
                    if Rec2."Loan Request ID" = '' then begin
                        Rec2.Validate("Employee Id", EssCUL.GetEmployeeID(Database.UserId));
                        Rec2.Validate(User_ID_Rec, Database.UserId);
                        Rec2.Insert(true);
                        Page.Run(page::"Loan Request Ess", Rec2);
                    end;
                END;
            }
        }
    }

    trigger OnInit()
    begin
        PageUserFilter();
    end;

    procedure PageUserFilter()
    var
        Rcodeunit: Codeunit "ESS RC Page";
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Employee ID", Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;
}