page 60139 "Seperation List"
{
    PageType = List;
    SourceTable = "Seperation Master";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Seperation Code"; Rec."Seperation Code")
                {
                    ApplicationArea = All;
                }
                field("Seperation Reason"; Rec."Seperation Reason")
                {
                    ApplicationArea = All;
                }
                field("Sepration Reason Code"; Rec."Sepration Reason Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}