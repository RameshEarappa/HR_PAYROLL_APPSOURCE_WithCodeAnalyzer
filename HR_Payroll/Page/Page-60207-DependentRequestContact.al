page 60207 "Dependent Request Contact"
{
    AutoSplitKey = true;
    Caption = 'Dependent Contact';
    PageType = ListPart;
    SourceTable = "Dependent New Contacts Line";
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
                field(Extension; Rec.Extension)
                {
                    ApplicationArea = All;
                }
                field(Primary; Rec.Primary)
                {
                    ApplicationArea = All;
                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}