page 60206 "Dependent Req Address"
{
    AutoSplitKey = true;
    Caption = 'Dependent Address';
    PageType = ListPart;
    SourceTable = "Dependent New Address Line";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request No"; Rec.No2)
                {
                    ApplicationArea = All;
                }
                field("Name or Description"; Rec."Name or Description")
                {
                    Caption = 'Name or Description';
                    ApplicationArea = All;
                }
                field(Street; Rec.Street)
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                }
                field(Primary; Rec.Primary)
                {
                    ApplicationArea = All;
                }
                field(Private; Rec.Private)
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}