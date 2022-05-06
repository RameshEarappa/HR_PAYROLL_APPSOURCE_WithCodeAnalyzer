page 60194 "Employee Prof. Exp Card"
{
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Employee Prof. Exp.";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Emp No."; Rec."Emp No.")
                {
                    ApplicationArea = All;
                }
                field("Emp FullName"; Rec."Emp FullName")
                {
                    ApplicationArea = All;
                }
                field(Employer; Rec.Employer)
                {
                    ApplicationArea = All;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                }
            }
            group("Communication Details")
            {
                field("Internet Address"; Rec."Internet Address")
                {
                    ApplicationArea = All;
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
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
}