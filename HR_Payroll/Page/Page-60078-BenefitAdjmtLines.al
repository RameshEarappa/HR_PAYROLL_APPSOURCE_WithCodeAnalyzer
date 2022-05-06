page 60078 "Benefit Adjmt. Lines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Benefit Adjmt. Journal Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                    ApplicationArea = All;
                    Visible = false;
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
                field(Benefit; Rec.Benefit)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Benefit Description"; Rec."Benefit Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Calculation Units"; Rec."Calculation Units")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Financial Dimension"; Rec."Financial Dimension")
                {
                    Visible = false;
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
                    BenefitLineImportXmlport: XmlPort "Benefit Admnt Line Xmlport";
                    BenefitHeaderRecL: Record "Benefit Adjmt. Journal header";
                begin
                    BenefitHeaderRecL.Reset();
                    BenefitHeaderRecL.SetRange("Journal No.", Rec."Journal No.");
                    if BenefitHeaderRecL.FindFirst() then
                        if BenefitHeaderRecL.Posted then
                            Error('Journal already confirmed.');

                    Clear(BenefitLineImportXmlport);
                    BenefitLineImportXmlport.SetJournNo(Rec."Journal No.");
                    BenefitLineImportXmlport.Run();
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
                RunObject = xmlport "Benefit Admnt Line Export";
            }
        }
    }

    var
        PayperiodCodeandLineNo: Code[40];
}