page 60058 "Work Cal Date Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Work Calendar Date Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Calendar ID"; Rec."Calendar ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Trans Date"; Rec."Trans Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("From Time"; Rec."From Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("To Time"; Rec."To Time")
                {
                    ApplicationArea = All;
                }
                field(Hours; Rec.Hours)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}