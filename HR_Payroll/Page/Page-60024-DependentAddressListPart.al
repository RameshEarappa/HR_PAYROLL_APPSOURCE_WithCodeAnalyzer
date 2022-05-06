page 60024 "Dependent Address ListPart1"
{
    AutoSplitKey = true;
    Caption = 'Dependent Address ';
    PageType = ListPart;
    SourceTable = "Employee Address Line";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Name or Description"; Rec."Name or Description")
                {
                    ApplicationArea = All;

                    Editable = EditBool;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;

                    Editable = EditBool;
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;

                    Editable = EditBool;
                    Visible = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;

                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;

                }
                field(Street; Rec.Street)
                {
                    ApplicationArea = All;

                    Editable = EditBool;
                }
                field(Primary; Rec.Primary)
                {
                    ApplicationArea = All;

                    Editable = EditBool;

                    trigger OnValidate()
                    begin
                        if Rec.Primary = true then
                            PriValidation;
                        CurrPage.UPDATE(true);
                    end;
                }
                field(Private; Rec.Private)
                {
                    ApplicationArea = All;

                    Editable = EditBool;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;

                    Editable = EditBool;
                }
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        Editing;
    end;

    trigger OnAfterGetRecord()
    begin
        Editing;
    end;

    trigger OnInit()
    begin
        Editing;
    end;

    var
        [InDataSet]
        EditBool: Boolean;

    local procedure Editing()
    begin
        EditBool := true;
    end;

    local procedure PriValidation()
    var
        Rec2: Record "Employee Address Line";
    begin
        Rec2.RESET;
        Rec2.SETRANGE("Dependent ID", Rec."Dependent ID");
        Rec2.SETRANGE(Primary, true);
        if Rec2.FINDFIRST then begin
            if CONFIRM(' A Address type has already marked as Primary. Do you want to change the primary? \Click Yes to Continue, No to Cancel.', true) then begin
                Rec.Primary := true;
                Rec2.Primary := false;
                Rec2.MODIFY;
            end else
                Rec.Primary := false;
        end;
    end;
}