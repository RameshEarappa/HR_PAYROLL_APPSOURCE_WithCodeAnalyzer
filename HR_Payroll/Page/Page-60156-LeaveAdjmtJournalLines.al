page 60156 "Leave Adjmt. Journal Lines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Leave Adj Journal Lines";
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = EditLine;
                field("Journal No."; Rec."Journal No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Voucher Description"; Rec."Voucher Description")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Leave Type ID"; Rec."Leave Type ID")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Accrual ID"; Rec."Accrual ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Calculation Units"; Rec."Calculation Units")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Lines")
            {
                Caption = 'Imports Lines';
                ApplicationArea = All;
                Image = Line;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger
                OnAction()
                var
                    LeaveAdjmtJournalLinestXmlport: XmlPort "Leave Adjmt. Journal Lines";
                    LeaveHeaderRecL: Record "Leave Adj Journal header";
                begin
                    LeaveHeaderRecL.Reset();
                    LeaveHeaderRecL.SetRange("Journal No.", Rec."Journal No.");
                    if LeaveHeaderRecL.FindFirst() then
                        if LeaveHeaderRecL.Posted then
                            Error('Journal already confirmed.');

                    Clear(LeaveAdjmtJournalLinestXmlport);
                    LeaveAdjmtJournalLinestXmlport.SetJournNo(Rec."Journal No.");
                    LeaveAdjmtJournalLinestXmlport.Run();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LeaveAdjHeader.GET(Rec."Journal No.");
        if LeaveAdjHeader.Posted then
            EditLine := false
        else
            EditLine := true;
    end;

    trigger OnOpenPage()
    begin
        EditLine := true;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        LeaveAdjJournalLines: Record "Leave Adj Journal Lines";
    begin
        LeaveAdjJournalLines.RESET;
        CurrPage.SETSELECTIONFILTER(LeaveAdjJournalLines);
        if LeaveAdjJournalLines.FINDFIRST then begin
            if LeaveAdjJournalLines."Journal No." <> '' then begin
                Rec.TESTFIELD("Employee Code");
                Rec.TESTFIELD("Leave Type ID");
                Rec.TESTFIELD("Calculation Units");
            end;
        end;
    end;

    var
        PayperiodCodeandLineNo: Code[40];
        [InDataSet]
        EditLine: Boolean;
        LeaveAdjHeader: Record "Leave Adj Journal header";
}