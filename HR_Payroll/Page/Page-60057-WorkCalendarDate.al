page 60057 "Work Calendar Date"
{
    PageType = ListPart;
    SourceTable = "Work Calendar Date";

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
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Alternative Calendar ID"; Rec."Alternative Calendar ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Has Changed"; Rec."Has Changed")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}