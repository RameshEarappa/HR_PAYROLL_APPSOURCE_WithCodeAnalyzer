page 61018 "Master Data Setup"
{
    PageType = List;
    SourceTable = "Master Data Setup";
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Page ID"; Rec."Page ID")
                {
                    ApplicationArea = all;
                }
                field("Page Name"; Rec."Page Name")
                {
                    ApplicationArea = all;
                }
                field("Process Identification Master"; Rec."Process Identification Master")
                {
                    ApplicationArea = all;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}