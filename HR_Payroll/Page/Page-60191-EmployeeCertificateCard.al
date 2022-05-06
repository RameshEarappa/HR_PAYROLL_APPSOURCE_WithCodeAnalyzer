page 60191 "Employee Certificate Card"
{
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Payroll Job Certificate Line";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Emp ID"; Rec."Emp ID")
                {
                    ApplicationArea = All;
                }
                field("Emp Full Name"; Rec."Emp Full Name")
                {
                    ApplicationArea = All;
                }
                field("Certficate Type"; Rec."Certficate Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Importance; Rec.Importance)
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
            action("Attachment")
            {
                ApplicationArea = All;
                Image = Attachments;
                Promoted = true;
                Caption = 'Attachment';
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                trigger
                OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GETTABLE(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RUNMODAL;
                end;
            }
        }
    }
    local procedure GetNewLineNumber(EmplNo: Code[20]): Integer
    var
        PayrollJobCertificateLineRec_L: Record "Payroll Job Certificate Line";
    begin
        PayrollJobCertificateLineRec_L.RESET;
        PayrollJobCertificateLineRec_L.SETRANGE("Emp ID", EmplNo);
        if not PayrollJobCertificateLineRec_L.FINDLAST then
            exit(10000)
        else begin
            exit(PayrollJobCertificateLineRec_L."Line  No." + 10000);
        end;
    end;
}