page 60090 "Payroll Jobs"
{
    CardPageID = "Payroll Job Card";
    PageType = List;
    SourceTable = "Payroll Jobs";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Job; Rec.Job)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Job Description"; Rec."Job Description")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("Full Time Equivalent"; Rec."Full Time Equivalent")
                {
                    ApplicationArea = All;
                }
                field("Job Function"; Rec."Job Function")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Grade Category"; Rec."Grade Category")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
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

    trigger OnDeleteRecord(): Boolean
    begin
        PayrollPosition.RESET;
        PayrollPosition.SETRANGE(Job, Rec.Job);
        if PayrollPosition.FINDFIRST then
            ERROR(Erro001);
    end;

    var
        PayrollPosition: Record "Payroll Position";
        Erro001: Label 'Position has already been created for the selected job. Cannot be deleted"';
}