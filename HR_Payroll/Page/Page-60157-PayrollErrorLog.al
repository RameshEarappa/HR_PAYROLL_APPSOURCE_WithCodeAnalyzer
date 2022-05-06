page 60157 "Payroll Error Log"
{
    Editable = false;
    PageType = List;
    SourceTable = "Payroll Error Log";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payroll Statement ID"; Rec."Payroll Statement ID")
                {
                    ApplicationArea = All;
                }
                field("HCM Worker"; Rec."HCM Worker")
                {
                    ApplicationArea = All;
                }
                field(Error; Rec.Error)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}