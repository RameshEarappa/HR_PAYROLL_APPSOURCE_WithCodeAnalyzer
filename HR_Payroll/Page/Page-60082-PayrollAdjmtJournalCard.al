page 60082 "Payroll Adjmt. Journal Card"
{
    DataCaptionFields = "Journal No.", Description;
    PageType = Document;
    SourceTable = "Payroll Adjmt. Journal header";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Journal No."; Rec."Journal No.")
                {
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
                }
                field("Defaualt Employee"; Rec."Defaualt Employee")
                {
                    ApplicationArea = All;
                }
                field("Default Earning Code"; Rec."Default Earning Code")
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
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field("Posted DateTime"; Rec."Posted DateTime")
                {
                    ApplicationArea = All;
                }
                field("Financial Dimension"; Rec."Financial Dimension")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}