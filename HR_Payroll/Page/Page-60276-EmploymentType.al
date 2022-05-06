page 60276 "Employment Type"
{
    PageType = List;
    SourceTable = "Employment Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employment Type ID"; Rec."Employment Type ID")
                {
                    ApplicationArea = all;
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    Caption = 'Employment Type';
                    ApplicationArea = all;
                }
            }
        }
    }
}