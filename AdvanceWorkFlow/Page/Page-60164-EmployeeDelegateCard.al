page 60164 "Employee Delegate - Card"
{
    Caption = 'Employee Delegation';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Delegate - WFLT";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Delegate To"; Rec."Delegate To")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        DelegateWFLTRec_G.RESET;
        DelegateWFLTRec_G.SETRANGE("Employee Code", Rec."Employee Code");
        DelegateWFLTRec_G.SETRANGE("Employee ID", Rec."Employee ID");
        if DelegateWFLTRec_G.FINDFIRST then
            if DelegateWFLTRec_G."Delegate To" <> '' then begin
                DelegateWFLTRec_G.TESTFIELD("From Date");
                DelegateWFLTRec_G.TESTFIELD("To Date");
            end;
    end;

    var
        DelegateWFLTRec_G: Record "Delegate - WFLT";
}

