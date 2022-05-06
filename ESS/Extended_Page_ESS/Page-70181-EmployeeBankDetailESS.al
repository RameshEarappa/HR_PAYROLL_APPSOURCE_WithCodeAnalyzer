page 70181 "Employee Bank Account ESS"
{
    Caption = 'Employee Bank Account ESS';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Employee Bank Account";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = ALL;
                }
                field("Bank Acccount Number"; Rec."Bank Acccount Number")
                {
                    ApplicationArea = ALL;
                }
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}