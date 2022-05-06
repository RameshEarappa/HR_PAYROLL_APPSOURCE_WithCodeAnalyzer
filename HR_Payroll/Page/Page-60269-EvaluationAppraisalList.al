page 60269 "Evaluation Appraisal List"
{
    CardPageID = "Evaluation Appraisal Card";
    Caption = 'Evaluation Appraisal List';
    PageType = List;
    SourceTable = "Evaluation Appraisal Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Performance ID"; Rec."Performance ID")
                {
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}