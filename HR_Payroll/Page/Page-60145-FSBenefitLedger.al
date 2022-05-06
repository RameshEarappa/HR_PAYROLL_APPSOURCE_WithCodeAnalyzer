page 60145 "FS Benefit Ledger"
{
    PageType = ListPart;
    SourceTable = "FS - Earning Code";
    SourceTableView = WHERE("Final Settlement Component" = CONST(true), "Earning Code Amount" = FILTER(<> 0));
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Earning Code"; Rec."Earning Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Earning Description"; Rec."Earning Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Earning Code Amount"; Rec."Earning Code Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}