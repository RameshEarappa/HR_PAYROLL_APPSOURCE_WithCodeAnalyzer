page 60101 "Payroll Job Education"
{
    PageType = List;
    SourceTable = "Payroll Job Education";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Education Code"; Rec."Education Code")
                {
                    ApplicationArea = All;
                }
                field("Education Level"; Rec."Education Level")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Education Stream"; Rec."Education Stream")
                {
                    ApplicationArea = All;
                    Caption = 'Specialization';
                }
            }
        }
    }
}