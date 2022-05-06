page 60163 "Records Link Page"
{
    PageType = List;
    SourceTable = "Record Link";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Link ID"; Rec."Link ID")
                {
                    ApplicationArea = All;
                }
                field("Record ID"; Rec."Record ID")
                {
                    ApplicationArea = All;
                }
                field("Records ID"; FORMAT(Rec."Record ID", 0, 1))
                {
                    ApplicationArea = All;
                }
                field(URL1; Rec.URL1)
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
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
                field(Notify; Rec.Notify)
                {
                    ApplicationArea = All;
                }
                field("To User ID"; Rec."To User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}