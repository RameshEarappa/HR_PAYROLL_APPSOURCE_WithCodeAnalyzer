page 60017 "Payroll Formulas"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Payroll Formula";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Formula Key"; Rec."Formula Key")
                {
                    ApplicationArea = All;
                }
                field("Formula description"; Rec."Formula description")
                {
                    ApplicationArea = All;
                }
                field("Formula Key Type"; Rec."Formula Key Type")
                {
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}