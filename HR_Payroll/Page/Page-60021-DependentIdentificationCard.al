page 60021 "Dependent Identification Card1"
{
    PageType = Card;
    SourceTable = "Identification Master";
    SourceTableView = SORTING("Employee No.") ORDER(Ascending) WHERE("Document Type" = CONST(Dependent));
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                label("Please select Identification Type first.")
                {
                    ApplicationArea = All;
                    Caption = 'Please select Identification Type first.';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Dependent No"; Rec."Dependent No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Identification Type"; Rec."Identification Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        NoValidate := Rec."No.";
                        EditDocumentType;
                        CurrPage.UPDATE;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("ID Document Type"; Rec."ID Document Type")
                {
                    ApplicationArea = All;
                    Enabled = EditDocType;
                }
                field("Visa Type"; Rec."Visa Type")
                {
                    ApplicationArea = All;
                    Editable = VisaTypeBoolG;
                }
                field("Identification No."; Rec."Identification No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        NoValidate := Rec."No.";
                    end;
                }
                field("Issuing Authority"; Rec."Issuing Authority")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Issuing Authority Description"; Rec."Issuing Authority Description")
                {
                    ApplicationArea = All;
                    Caption = 'Issuing Authority';
                }
                field("Issuing Country"; Rec."Issuing Country")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        NoValidate := Rec."No.";
                    end;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        NoValidate := Rec."No.";
                    end;
                }
                field("Issue Date (Hijiri)"; Rec."Issue Date (Hijiri)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        NoValidate := Rec."No.";
                    end;
                }
                field("Expiry Date (Hijiri)"; Rec."Expiry Date (Hijiri)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Active Document"; Rec."Active Document")
                {
                    ApplicationArea = All;
                    Editable = true;
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


    trigger OnAfterGetCurrRecord()
    begin
        EditDocumentType;
    end;

    trigger OnAfterGetRecord()
    begin
        EditDocumentType;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        NoValidate := '';
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if NoValidate <> '' then begin
            Rec.TESTFIELD("Identification No.");
            Rec.TESTFIELD("Identification Type");
            Rec.TESTFIELD("Issuing Country");
        end
    end;

    var
        NoValidate: Code[30];
        IdDocTypeRec: Record "Identification Doc Type Master";
        [InDataSet]
        EditDocType: Boolean;
        VisaTypeBoolG: Boolean;

    local procedure EditDocumentType()
    begin
        if Rec."Identification Type" = '' then
            Rec.WarningMsg := 'Please select a Identification Type'
        else
            Rec.WarningMsg := '';

        IdDocTypeRec.GET(Rec."Identification Type");
        if IdDocTypeRec."Maintain Document Type" then
            EditDocType := true;
    end;
}