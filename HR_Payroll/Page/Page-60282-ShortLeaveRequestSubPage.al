page 60282 "Short Leave Request SubPage"
{
    Caption = 'Out of Office Line';
    PageType = ListPart;
    SourceTable = "Short Leave Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Id"; Rec."Employee Id")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = all;
                    Enabled = false;
                    ShowMandatory = true;
                }
                field("Requesht Date"; Rec."Requesht Date")
                {
                    ApplicationArea = all;
                    Editable = VisibBool;
                    ShowMandatory = true;
                }
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                    Style = Strong;
                }
                field("Req. Start Time"; Rec."Req. Start Time")
                {
                    ApplicationArea = all;
                    Editable = VisibBool;
                    ShowMandatory = true;
                }
                field("Req. End Time"; Rec."Req. End Time")
                {
                    ApplicationArea = all;
                    Editable = VisibBool;
                    ShowMandatory = true;
                }
                field("No Hours Requested"; Rec."No Hours Requested")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = all;
                    Editable = VisibBool;
                }
            }
        }
    }



    trigger OnAfterGetCurrRecord()
    begin
        ControleVisib;
    end;

    trigger OnAfterGetRecord()
    begin
        ControleVisib;
    end;

    var
        [InDataSet]
        VisibBool: Boolean;
        HeadRec: Record "Short Leave Header";

    local procedure ControleVisib()
    begin
        HeadRec.RESET;
        HeadRec.SETRANGE("Short Leave Request Id", Rec."Short Leave Request Id");
        IF HeadRec.FINDFIRST THEN
            IF HeadRec.Posted = TRUE THEN
                VisibBool := FALSE
            ELSE
                VisibBool := TRUE;
    end;
}