page 60272 "Evaluation R/Q Manual Enter"
{
    PageType = List;
    SourceTable = "Evaluation Rating/Quest Master";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Serial No."; Rec."Serial No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Evaluation Factor Type"; Rec."Evaluation Factor Type")
                {
                    ApplicationArea = All;
                }
                field("Rating Factor"; Rec."Rating Factor")
                {
                    ApplicationArea = All;
                }
                field("Rating Factor Description"; Rec."Rating Factor Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}