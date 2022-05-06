page 60214 "Employee Bank Account"
{
    Caption = 'Employee Bank Account';
    PageType = Card;
    SourceTable = "Employee Bank Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee Id"; Rec."Employee Id")
                {
                    Visible = false;
                    ApplicationArea = ALL;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = ALL;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = ALL;
                }
                field("Bank Name in Arabic"; Rec."Bank Name in Arabic")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
            }
            group("Bank Account details")
            {
                Caption = 'Bank Account details';
                field("Routing Number Type"; Rec."Routing Number Type")
                {
                    ApplicationArea = ALL;
                }
                field("Routing Number"; Rec."Routing Number")
                {
                    ApplicationArea = ALL;
                }
                field("Bank Acccount Number"; Rec."Bank Acccount Number")
                {
                    ApplicationArea = ALL;
                }
                field("SWIFT code"; Rec."SWIFT code")
                {
                    ApplicationArea = ALL;
                }
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = ALL;
                    ShowMandatory = true;
                }
                field("Account Holder"; Rec."Account Holder")
                {
                    ApplicationArea = ALL;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = ALL;
                }
                field("Branch Number"; Rec."Branch Number")
                {
                    ApplicationArea = ALL;
                }
                field("MOL Id"; Rec."MOL Id")
                {
                    ApplicationArea = ALL;
                }
            }
            group("Address Details")
            {
                Caption = 'Address Details';
                field(Address; AddressText)
                {
                    ApplicationArea = ALL;
                    Caption = 'Address';
                    MultiLine = true;

                    trigger OnValidate();
                    begin
                        Rec.SetAddress(AddressText);
                    end;
                }
            }
            group("Contact Information ")
            {
                Caption = 'Contact Information';
                field("Name of Person"; Rec."Name of Person")
                {
                    ApplicationArea = ALL;
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = ALL;
                }
                field(Extension; Rec.Extension)
                {
                    ApplicationArea = ALL;
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ApplicationArea = ALL;
                }
                field(Fax; Rec.Fax)
                {
                    ApplicationArea = ALL;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = ALL;
                }
                field("Internet Address"; Rec."Internet Address")
                {
                    ApplicationArea = ALL;
                }
                field("Telex Number"; Rec."Telex Number")
                {
                    ApplicationArea = ALL;
                }
                field(Primary; Rec.Primary)
                {
                    ApplicationArea = ALL;
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

    trigger OnAfterGetCurrRecord();
    begin
        AddressText := Rec.GetAddress;
    end;

    trigger OnAfterGetRecord();
    begin
        AddressText := Rec.GetAddress;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
            EmployeeBankAccountRec_G.RESET;
            EmployeeBankAccountRec_G.SETRANGE("Employee Id", Rec."Employee Id");
            if EmployeeBankAccountRec_G.FINDFIRST then begin
                if (EmployeeBankAccountRec_G."Bank Code" <> '') or (EmployeeBankAccountRec_G."Bank Acccount Number" <> '') then begin
                    EmployeeBankAccountRec_G.TESTFIELD("Bank Acccount Number");
                    EmployeeBankAccountRec_G.TESTFIELD(IBAN);
                end;
            end;
        end;
    end;

    var
        Test: Text;
        PositionSummarry: Text;
        AddressText: Text[1024];
        EmployeeBankAccountRec_G: Record "Employee Bank Account";
}