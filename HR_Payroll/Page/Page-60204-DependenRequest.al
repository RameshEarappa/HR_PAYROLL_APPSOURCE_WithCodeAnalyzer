page 60204 "Dependen Request"
{
    CardPageID = "Dependent New Card";
    Editable = false;
    PageType = List;
    SourceTable = "Employee Dependents New";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No2; Rec.No2)
                {
                    Caption = 'Request ID';
                    ApplicationArea = All;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Dependen Full Name"; Rec."Full Name")
                {
                    Caption = 'Dependent Name';
                    ApplicationArea = All;
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}