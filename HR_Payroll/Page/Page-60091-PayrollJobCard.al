page 60091 "Payroll Job Card"
{
    PageType = Document;
    SourceTable = "Payroll Jobs";
    UsageCategory = Documents;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(Job; Rec.Job)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Job Description"; Rec."Job Description")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Grade Category"; Rec."Grade Category")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("Full Time Equivalent"; Rec."Full Time Equivalent")
                {
                    ApplicationArea = All;
                }
                field("Maximum Positions"; Rec."Maximum Positions")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if Rec."Maximum Positions" then begin
                            Rec.Unlimited := false;
                            VisibleMaxPositions := true;
                        end
                        else begin
                            Rec.Unlimited := true;
                            VisibleMaxPositions := false;
                        end;
                    end;
                }
                field(Unlimited; Rec.Unlimited)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec.Unlimited then begin
                            Rec."Maximum Positions" := false;
                            VisibleMaxPositions := false;
                            Clear(Rec."Max. No Of Positions");
                        end
                        else begin
                            Rec."Maximum Positions" := true;
                            VisibleMaxPositions := true;
                        end;
                    end;
                }
                field("Max. No Of Positions"; Rec."Max. No Of Positions")
                {
                    ApplicationArea = All;
                    Editable = VisibleMaxPositions;
                }
                field("Job Type"; Rec."Job Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group("Description.")
            {
                Caption = 'Description';
                grid(Control26)
                {
                    group(Control29)
                    {
                        Caption = '';
                        field(Description; Rec.Description)
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Width = 1000;
                        }
                    }
                }
            }
            group("Job Classification")
            {
                Visible = false;
                field("Job Function"; Rec."Job Function")
                {
                    ApplicationArea = All;
                }
            }
            part(Skills; "Payroll Job Skills Subpage")
            {
                SubPageLink = "Job ID" = FIELD(Job);
                ApplicationArea = All;
            }
            part(Certificate; "Payroll Job Certificate Subpag")
            {
                SubPageLink = "Job ID" = FIELD(Job);
                ApplicationArea = All;
            }
            part(Tests; "Payroll Job Tests Subpage")
            {
                SubPageLink = "Job ID" = FIELD(Job);
                ApplicationArea = All;
            }
            part(Education; "Payroll Job Education Subpage")
            {
                SubPageLink = "Job ID" = FIELD(Job);
                ApplicationArea = All;
            }
            part(Screenings; "Payroll Job Screening Subpage")
            {
                SubPageLink = "Job ID" = FIELD(Job);
                ApplicationArea = All;
            }
            part("Job Tasks"; "Payroll Job Tasks Subpage")
            {
                SubPageLink = "Job ID" = FIELD(Job);
                ApplicationArea = All;
            }
            part("Area Of Responsibility"; "Payroll Job Area of Resp. Subp")
            {
                SubPageLink = "Job ID" = FIELD(Job);
                ApplicationArea = All;
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

    trigger OnAfterGetRecord()
    begin
        if Rec."Maximum Positions" then
            VisibleMaxPositions := true
        else
            VisibleMaxPositions := false;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        PayrollPosition.RESET;
        PayrollPosition.SETRANGE(Job, Rec.Job);
        if PayrollPosition.FINDFIRST then
            ERROR(Erro001);
    end;

    trigger OnOpenPage()
    begin
        if Rec."Maximum Positions" then
            VisibleMaxPositions := true
        else
            VisibleMaxPositions := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec.Job <> '' then begin
            Rec.TESTFIELD("Job Description");
            Rec.TESTFIELD("Grade Category");
            Rec.TESTFIELD("Earning Code Group");
        end;
    end;

    var
        VisibleMaxPositions: Boolean;
        PayrollJobs: Record "Payroll Jobs";
        PayrollPosition: Record "Payroll Position";
        Erro001: Label 'Position has already been created for the selected job. Cannot be deleted.';
}