page 60092 "Payroll Job Skills Subpage"
{
    AutoSplitKey = true;
    Caption = 'Skills';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Payroll Job Skill Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Skill; Rec.Skill)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                }
                field(Importance; Rec.Importance)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}