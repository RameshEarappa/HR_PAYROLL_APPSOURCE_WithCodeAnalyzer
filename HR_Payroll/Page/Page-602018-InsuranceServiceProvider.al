page 60218 "Insurance Servicec Prov. List"
{
    PageType = List;
    SourceTable = "Insurance Service Provider";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Insurance Provider Code"; Rec."Insurance Provider Code")
                {
                    ApplicationArea = All;
                }
                field("Insurance Service Provider"; Rec."Insurance Service Provider")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = All;
                }
                field(Website; Rec.Website)
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("Insurance Type"; Rec."Insurance Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}