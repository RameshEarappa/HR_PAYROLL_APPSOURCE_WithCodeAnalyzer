page 60098 "Payroll Job Certificates"
{
    Caption = 'Payroll Job Certificates';
    PageType = List;
    SourceTable = "Payroll Job Certificate";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Certificate Type"; Rec."Certificate Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}