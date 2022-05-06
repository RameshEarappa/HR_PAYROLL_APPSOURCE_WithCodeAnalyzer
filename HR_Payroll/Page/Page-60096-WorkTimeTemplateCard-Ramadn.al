page 60301 "Work Time Template Card-Ramadn"
{
    PageType = Document;
    SourceTable = "Work Time Template - Ramadn";

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

            group("Control28")
            {
                Caption = 'Sunday';
                part(Sunday; "Work Time SunSubform-Ramadn")
                {
                    Caption = 'Sunday';
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Sunday));
                    UpdatePropagation = Both;
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
                Caption = 'Monday';
                part(Monday; "Work Time MonSubform -Ramadn")
                {
                    Caption = 'Monday';
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Monday));
                    UpdatePropagation = Both;
                    ApplicationArea = All;
                }
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
                Caption = 'Tuesday';
                part(Tuesday; "Work TimeTuesSubform-Ramadn")
                {
                    Caption = 'Tuesday';
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Tuesday));
                    UpdatePropagation = Both;
                    ApplicationArea = All;
                }
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
                Caption = 'Wednesday';
                part(Wednesday; "Work Time WedSubform-Ramadan")
                {
                    Caption = 'Wednesday';
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Wednesday));
                    UpdatePropagation = Both;
                    ApplicationArea = All;
                }
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
                Caption = 'Thursday';
                part(Thursday; "Work TimeThuSubform-Ramadan")
                {
                    Caption = 'Thursday';
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Thursday));
                    UpdatePropagation = Both;
                    ApplicationArea = All;
                }
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
                Caption = 'Friday';
                part(Friday; "Work TimeFriSubform-Ramadan")
                {
                    Caption = 'Friday';
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Friday));
                    UpdatePropagation = Both;
                    ApplicationArea = All;
                }
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
                Caption = 'Saturday';
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
                part(Saturday; "Work Time SatSubform-Ramadn")
                {
                    Caption = 'Saturday';
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Saturday));
                    UpdatePropagation = Both;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Work Calendar")
            {
                Caption = 'Update Work Calendar';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                var
                    WorkTimeTemplate: Record "Work Time Template";
                    CopyWorkTimeTemplate: Report "Copy Work Time Template";
                begin
                    Rec.UpdateCalTime;
                end;
            }
        }
    }

    var
        WorkTimeTemplate: Record "Work Time Template";
}