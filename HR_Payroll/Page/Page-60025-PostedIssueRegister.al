page 60025 "Posted Issue Register-1"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Asset Assignment Register";
    SourceTableView = WHERE("Transaction Type" = FILTER(Issue),
                            Posted = FILTER(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posted Issue Document No"; Rec."Posted Issue Document No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Issue Document No."; Rec."Issue Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("FA No"; Rec."FA No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Return Date"; Rec."Return Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Asset Custody Type"; Rec."Asset Custody Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
}