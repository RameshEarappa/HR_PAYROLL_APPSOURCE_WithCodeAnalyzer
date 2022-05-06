page 60230 "Sector Card"
{
    Caption = 'Sector Card';
    PageType = Card;
    SourceTable = Sector;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Sector ID"; Rec."Sector ID")
                {
                    ApplicationArea = All;
                }
                field("Sector Name"; Rec."Sector Name")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("First Class Adult Ticket Fare"; Rec."First Class Adult Ticket Fare")
                {
                    ApplicationArea = All;
                }
                field("First Class Infant Ticket Fare"; Rec."First Class Infant Ticket Fare")
                {
                    ApplicationArea = All;
                }
                field("First Class Child Ticket Fare"; Rec."First Class Child Ticket Fare")
                {
                    ApplicationArea = All;
                }
                field("Business Adult Ticket Fare"; Rec."Business Adult Ticket Fare")
                {
                    ApplicationArea = All;
                }
                field("Business Infant Ticket Fare"; Rec."Business Infant Ticket Fare")
                {
                    ApplicationArea = All;
                }
                field("Business Child Ticket Fare"; Rec."Business Child Ticket Fare")
                {
                    ApplicationArea = All;
                }
                field("Economy Adult Ticket Fare"; Rec."Economy Adult Ticket Fare")
                {
                    ApplicationArea = All;
                }
                field("Economy Infant Ticket Fare"; Rec."Economy Infant Ticket Fare")
                {
                    ApplicationArea = All;
                }
                field("Economy Child Ticket Fare"; Rec."Economy Child Ticket Fare")
                {
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                action(Activate)
                {
                    Promoted = true;
                    ApplicationArea = All;
                }
            }
        }
    }
}