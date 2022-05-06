page 60178 "Loan Types"
{
    Caption = 'Loan Type';
    CardPageID = "Loan Type Setup";
    Editable = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Loan Type Setup";
    SourceTableView = SORTING("Loan Code")
                      ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Code"; Rec."Loan Code")
                {
                    ApplicationArea = All;
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                }
                field("Arabic Name"; Rec."Arabic Name")
                {
                    Caption = 'Local Description';
                    ApplicationArea = All;
                }
                field("Calculation Basis"; Rec."Calculation Basis")
                {
                    ApplicationArea = All;
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
                }
                field("Min Loan Amount"; Rec."Min Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Max Loan Amount"; Rec."Max Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Percentage"; Rec."Interest Percentage")
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
            }
        }
    }
}