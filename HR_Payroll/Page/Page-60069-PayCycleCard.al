page 60069 "Pay Cycle Card"
{
    PageType = Document;
    SourceTable = "Pay Cycles";
    UsageCategory = Documents;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    Editable = PayCodeBoolG;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Pay Cycle Frequency"; Rec."Pay Cycle Frequency")
                {
                    ApplicationArea = All;
                }
            }
            part(Control6; "Pay Periods Subpage")
            {
                ApplicationArea = all;
                SubPageLink = "Pay Cycle" = FIELD("Pay Cycle");
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Pay Cycle" = '' then
            PayCodeBoolG := true
        else
            PayCodeBoolG := false;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Pay Cycle" = '' then
            PayCodeBoolG := true
        else
            PayCodeBoolG := false;
    end;

    var
        PayCodeBoolG: Boolean;
}