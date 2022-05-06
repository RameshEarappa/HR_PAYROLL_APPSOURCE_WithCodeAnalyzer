page 70180 "Employee Dependent List DME"
{
    PageType = ListPart;
    SourceTable = "Employee Dependents Master";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Dependent Name"; Rec."Dependent First Name" + ' ' + Rec."Dependent Middle Name" + ' ' + Rec."Dependent Last Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Dependent Contact No."; Rec."Dependent Contact No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}