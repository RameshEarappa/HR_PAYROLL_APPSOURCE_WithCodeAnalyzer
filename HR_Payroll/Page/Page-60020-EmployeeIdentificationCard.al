page 60020 "Employee Identification Card"
{
    PageType = Card;
    SourceTable = "Identification Master";

    SourceTableView = SORTING("Employee No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST(Employee));
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        if Rec."No." <> xRec."No." then begin
                            HrSetup.GET;
                            Rec."No. Series" := '';
                        end;
                    end;
                }
                field("Identification Type"; Rec."Identification Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        NoValidate := Rec."No.";

                        EditDocumentType;
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
                    Editable = EditDocType;
                    ShowMandatory = true;

                }
                field("Visa Type"; Rec."Visa Type")
                {
                    ApplicationArea = All;
                    Editable = VisaTypeBoolG;
                    Visible = false;
                }
                field("Identification No."; Rec."Identification No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        NoValidate := Rec."No.";
                    end;
                }
                field("Issuing Authority"; Rec."Issuing Authority")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Issuing Authority Description"; Rec."Issuing Authority Description")
                {
                    ApplicationArea = All;
                    Editable = false;

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

    trigger OnInit()
    begin
        EditDocumentType;
    end;

    trigger OnOpenPage()
    begin
        EditDocumentType;
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
        ID_Master: Record "Identification Master";
        HrSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoValidate: Text;
        IdDocTypeRec: Record "Identification Doc Type Master";
        [InDataSet]
        EditDocType: Boolean;
        VisaTypeBoolG: Boolean;

    local procedure EditDocumentType()
    begin
        if IdDocTypeRec.GET(Rec."Identification Type") then begin
            if IdDocTypeRec."Maintain Document Type" = true then
                EditDocType := true
            else begin
                EditDocType := false;
                CLEAR(Rec."ID Document Type");
            end;
        end;
    end;
}