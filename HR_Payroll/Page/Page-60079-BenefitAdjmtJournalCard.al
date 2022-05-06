page 60079 "Benefit Adjmt. Journal Card"
{
    PageType = Card;
    SourceTable = "Benefit Adjmt. Journal header";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Journal No."; Rec."Journal No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    ApplicationArea = All;
                }
                field("Pay Period Start"; Rec."Pay Period Start")
                {
                    ApplicationArea = All;
                }
                field("Pay Period End"; Rec."Pay Period End")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Defaualt Employee"; Rec."Defaualt Employee")
                {
                    ApplicationArea = All;
                }
                field("Default Benefit"; Rec."Default Benefit")
                {
                    ApplicationArea = All;
                }
                field("Create By"; Rec."Create By")
                {
                    ApplicationArea = All;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                }
                field("Work Flow Status"; Rec."Work Flow Status")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}