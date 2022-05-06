page 60192 "Employee Education Card"
{
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Payroll Job Education Line";
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
                field("Education Level"; Rec."Education Level")
                {
                    ApplicationArea = All;
                }
                field(Education; Rec.Education)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Grade Pass"; Rec."Grade Pass")
                {
                    ApplicationArea = All;
                }
                field("Passing Year"; Rec."Passing Year")
                {
                    ApplicationArea = All;
                }
                field(Importance; Rec.Importance)
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