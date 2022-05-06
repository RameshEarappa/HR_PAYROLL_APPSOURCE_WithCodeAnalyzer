page 60227 "Dependent Contacts SubPage"
{
    AutoSplitKey = true;
    Caption = '"Dependent Contacts "';
    PageType = ListPart;
    SourceTable = "Employee Contacts Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field("Contact Number & Address"; Rec."Contact Number & Address")
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field(Extension; Rec.Extension)
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field(Primary; Rec.Primary)
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        Editing;
    end;

    trigger OnAfterGetRecord();
    begin
        Editing;
    end;

    trigger OnInit();
    begin
        Editing;
    end;

    var
        [InDataSet]
        EditBool: Boolean;

    local procedure Editing();
    begin
        EditBool := true;
    end;
}