page 60140 "Work Time Template Card Ramadn"
{
    PageType = Document;
    SourceTable = "Work Time Template - Ramadn";
    SourceTableView = SORTING("Work Time ID") ORDER(Ascending);
    UsageCategory = Documents;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Work Time ID"; Rec."Work Time ID")
                {
                    ApplicationArea = All;
                }
                field("Template Name"; Rec."Template Name")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Control28)
            {
                part(Sunday; "Work Time SunSubform-Ramadn1")
                {
                    Caption = 'Sunday';
                    ApplicationArea = All;
                }
                field("Sunday Calculation Type"; Rec."Sunday Calculation Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Sunday No. Of Hours"; Rec."Sunday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(Control29)
            {
                field("Monday Calculation Type"; Rec."Monday Calculation Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Monday No. Of Hours"; Rec."Monday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(Control30)
            {
                field("Tuesday Calculation Type"; Rec."Tuesday Calculation Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Tuesday No. Of Hours"; Rec."Tuesday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(Control31)
            {
                field("Wednesday Calculation Type"; Rec."Wednesday Calculation Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Wednesday No. Of Hours"; Rec."Wednesday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(Control32)
            {
                field("Thursday Calculation Type"; Rec."Thursday Calculation Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Thursday No. Of Hours"; Rec."Thursday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(Control33)
            {
                field("Friday Calculation Type"; Rec."Friday Calculation Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Friday No. Of Hours"; Rec."Friday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(Control34)
            {
                field("Saturday Calculation Type"; Rec."Saturday Calculation Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Saturday No. Of Hours"; Rec."Saturday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        WorkTimeTemplate: Record "Work Time Template";
}