page 60004 "Posted Asset Return"
{
    Caption = 'Posted Asset Return';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Documents;
    ApplicationArea = All;
    SourceTable = "Asset Assignment Register";
    SourceTableView = SORTING("Issue Document No.", "Posted Issue Document No", "Return Document No.", "Posted Return Document No")
                      ORDER(Ascending)
                      WHERE(Posted = FILTER(true),
                            "Transaction Type" = FILTER(Return));
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
                field("Return Document No."; Rec."Return Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posted Issue Document No"; Rec."Posted Issue Document No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Asset Owner"; Rec."Asset Owner")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("FA No"; Rec."FA No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("FA Description"; Rec."FA Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}