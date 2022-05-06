page 60211 "Marital Status"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Marital Status";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Marital Status Code"; Rec."Marital Status Code")
                {
                    ApplicationArea = All;
                }
                field("Marital Status Description"; Rec."Marital Status Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}