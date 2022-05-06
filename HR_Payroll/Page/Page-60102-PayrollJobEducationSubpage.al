page 60102 "Payroll Job Education Subpage"
{
    AutoSplitKey = true;
    Caption = 'Education';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Payroll Job Education Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Education; Rec.Education)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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