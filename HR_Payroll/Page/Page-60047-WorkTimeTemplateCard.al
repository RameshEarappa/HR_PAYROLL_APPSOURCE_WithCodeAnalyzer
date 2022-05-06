page 60047 "Work Time Template Card"
{
    PageType = Document;
    SourceTable = "Work Time Template";
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
            }
            group("SUNDAY1")
            {
                Caption = 'SUNDAY';
                part(Sunday; "Work Time Line Sunday Subform")
                {
                    Caption = 'Sunday';
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Sunday));
                    UpdatePropagation = Both;
                    ApplicationArea = All;
                }
                field("Sunday Calculation Type"; Rec."Sunday Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Sunday No. Of Hours"; Rec."Sunday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("MONDAY1")
            {
                Caption = 'MONDAY';
                part(Monday; "Work Time Line Monday Subform")
                {
                    Caption = 'Monday';
                    ApplicationArea = All;
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Monday));
                    UpdatePropagation = Both;
                }
                field("Monday Calculation Type"; Rec."Monday Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Monday No. Of Hours"; Rec."Monday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("TUESDAY1")
            {
                caption = 'TUESDAY';
                part(Tuesday; "Work Time Line Tuesday Subform")
                {
                    Caption = 'Tuesday';
                    ApplicationArea = All;
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Tuesday));
                    UpdatePropagation = Both;
                }
                field("Tuesday Calculation Type"; Rec."Tuesday Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Tuesday No. Of Hours"; Rec."Tuesday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("WEDNESDAY1")
            {
                Caption = 'WEDNESDAY';
                part(Wednesday; "Work Time Line Wed day Subform")
                {
                    Caption = 'Wednesday';
                    ApplicationArea = All;
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Wednesday));
                    UpdatePropagation = Both;
                }
                field("Wednesday Calculation Type"; Rec."Wednesday Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Wednesday No. Of Hours"; Rec."Wednesday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("THURDAY1")
            {
                Caption = 'THURSDAY';
                part(Thursday; "Work Time Line Thu day Subform")
                {
                    Caption = 'Thursday';
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Thursday));
                    UpdatePropagation = Both;
                    ApplicationArea = All;
                }
                field("Thursday Calculation Type"; Rec."Thursday Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Thursday No. Of Hours"; Rec."Thursday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("FRIDAY1")
            {
                Caption = 'FRIDAY';
                part(Friday; "Work Time Line Friday Subform")
                {
                    Caption = 'Friday';
                    ApplicationArea = All;
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Friday));
                    UpdatePropagation = Both;
                }
                field("Friday Calculation Type"; Rec."Friday Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Friday No. Of Hours"; Rec."Friday No. Of Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group("SATURDAY1")
            {
                Caption = 'SATURDAY';
                part(Saturday; "Work Time Line Sat day Subform")
                {
                    Caption = 'Saturday';
                    ApplicationArea = All;
                    SubPageLink = "Work Time ID" = FIELD("Work Time ID");
                    SubPageView = WHERE(Weekday = FILTER(Saturday));
                    UpdatePropagation = Both;
                }
                field("Saturday Calculation Type"; Rec."Saturday Calculation Type")
                {
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

    actions
    {
        area(processing)
        {
            action("Copy Template")
            {
                Caption = 'Copy Template';
                Image = Copy;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    WorkTimeTemplate: Record "Work Time Template";
                    CopyWorkTimeTemplate: Report "Copy Work Time Template";
                begin
                    CLEAR(CopyWorkTimeTemplate);
                    WorkTimeTemplate.RESET;
                    WorkTimeTemplate.SETFILTER("Work Time ID", '<>%1', Rec."Work Time ID");
                    if WorkTimeTemplate.FINDLAST then;
                    CopyWorkTimeTemplate.SetValues(Rec."Work Time ID", WorkTimeTemplate."Work Time ID");
                    CopyWorkTimeTemplate.RUNMODAL;
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    var
        WorkTimeTemplate: Record "Work Time Template";
}