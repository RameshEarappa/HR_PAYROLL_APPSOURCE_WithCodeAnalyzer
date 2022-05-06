page 60083 "Payroll Adjmt. Journal Lines"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Payroll Adjmt. Journal Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
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
                field("Earning Code"; Rec."Earning Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Earning Code Description"; Rec."Earning Code Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Voucher Description"; Rec."Voucher Description")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Financial Dimension"; Rec."Financial Dimension")
                {
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
                    PayrollAdjmtJournalLinesXmlport: XmlPort "Payroll Adjmt. Journal Lines";
                    PayrollAdjmtJournalheaderRecL: Record "Payroll Adjmt. Journal header";
                begin
                    PayrollAdjmtJournalheaderRecL.Reset();
                    PayrollAdjmtJournalheaderRecL.SetRange("Journal No.", Rec."Journal No.");
                    if PayrollAdjmtJournalheaderRecL.FindFirst() then
                        if PayrollAdjmtJournalheaderRecL.Posted then
                            Error('Journal already confirmed.');

                    Clear(PayrollAdjmtJournalLinesXmlport);
                    PayrollAdjmtJournalLinesXmlport.SetJournNo(Rec."Journal No.");
                    PayrollAdjmtJournalLinesXmlport.Run();

                end;
            }
            action("Export Lines")
            {
                Caption = 'Export Lines';
                ApplicationArea = All;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger
               OnAction()
                var
                    PayrollAdjmtJournalLinesXmlport: XmlPort "Payroll Adjmt. Journal Lne Exp";
                    check: XmlPort "Export Contact";
                begin
                    Clear(PayrollAdjmtJournalLinesXmlport);
                    PayrollAdjmtJournalLinesXmlport.SetJournNo(Rec."Journal No.");
                    PayrollAdjmtJournalLinesXmlport.Run();

                end;
            }
        }
    }
}