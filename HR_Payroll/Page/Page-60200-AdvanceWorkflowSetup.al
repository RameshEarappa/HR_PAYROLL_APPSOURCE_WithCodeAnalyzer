page 60200 "Advance Workflow Setup"
{
    PageType = List;
    SourceTable = "Approval Level Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Advance Payrolll Type"; Rec."Advance Payrolll Type")
                {
                    ApplicationArea = All;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                }
                field("Finance User ID"; Rec."Finance User ID")
                {
                    ApplicationArea = All;
                }
                field("Finance User ID 2"; Rec."Finance User ID 2")
                {
                    ApplicationArea = All;
                }
                field("Direct Approve By Finance"; Rec."Direct Approve By Finance")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}