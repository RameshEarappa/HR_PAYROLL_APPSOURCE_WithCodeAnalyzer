page 70203 "Employee Contacts ESS"
{
    AutoSplitKey = true;
    Caption = 'Contacts';
    PageType = ListPart;
    SourceTable = "Employee Contacts Line";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Contact Number & Address"; Rec."Contact Number & Address")
                {
                    ApplicationArea = All;
                }

                field(Primary; Rec.Primary)
                {
                    ApplicationArea = All;
                }
                field("Emergency Contact"; Rec."Emergency Contact")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}