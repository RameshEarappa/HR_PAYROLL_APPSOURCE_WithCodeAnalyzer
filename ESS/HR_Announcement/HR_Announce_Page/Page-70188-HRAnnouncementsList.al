page 70188 "HR Announcements List"
{
    Caption = 'HR Announcements List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HR Announcements";
    CardPageId = "HR Announcements Card";
    Editable = false;
    DataCaptionFields = "Annountment Header";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; Rec."Created Time")
                {
                    ApplicationArea = All;
                }
                field("Annountment Header"; Rec."Annountment Header")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Publish to ESS"; Rec."Publish to ESS")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}