page 60111 "Payroll Job Position Card"
{
    Caption = 'Position Card';
    PageType = Card;
    SourceTable = "Payroll Position";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Position ID"; Rec."Position ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Job; Rec.Job)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Position Description"; Rec.Description)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Job Description"; Rec."Job Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(Department; Rec.Department)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Sub Department"; Rec."Sub Department")
                {
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Position Type"; Rec."Position Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Full Time Equivalent"; Rec."Full Time Equivalent")
                {
                    ApplicationArea = All;
                }
                field("Available for Assignment"; Rec."Available for Assignment")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Final authority"; Rec."Final authority")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."Final authority" then begin
                            CLEAR(Rec."Reports to Position");
                            CLEAR(Rec.Worker);
                            CLEAR(Rec."Worker Name");

                            CLEAR(Rec."Second Reports to Position");
                            CLEAR(Rec."Second Worker");
                            CLEAR(Rec."Second Worker Name");
                            FinalAuthBool_G := false;
                            CurrPage.UPDATE(true);
                        end else
                            FinalAuthBool_G := true;
                    end;
                }
            }
            group(" Position Summary")
            {
                grid(Control27)
                {
                    group(Control26)
                    {
                        Caption = '';
                        field("Position Summarry"; PositionSummarry)
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            Width = 1000;

                            trigger OnValidate()
                            begin
                                Rec.SetPositionSummary(PositionSummarry);
                            end;
                        }
                    }
                }
            }
            part("Payroll Duration"; "Payroll Position Duration")
            {
                SubPageLink = "Positin ID" = FIELD("Position ID");
                ApplicationArea = All;
            }
            part("Worker Assignment"; "Payroll Job Pos. Worker Assign")
            {
                Editable = false;
                ShowFilter = true;
                SubPageLink = "Position ID" = FIELD("Position ID");
                ApplicationArea = All;
            }
            group("Reports to ")
            {
                label("First Reports to")
                {
                    Caption = 'First Reports to';
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Reports to Position"; Rec."Reports to Position")
                {
                    Editable = FinalAuthBool_G;
                    ApplicationArea = All;
                }
                field(Worker; Rec.Worker)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Worker Name"; Rec."Worker Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                label("Second Reports to")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Second Reports to Position"; Rec."Second Reports to Position")
                {
                    Editable = FinalAuthBool_G;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Second Worker"; Rec."Second Worker")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Second Worker Name"; Rec."Second Worker Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(Payroll)
            {
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Paid By"; Rec."Paid By")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Control21; "Payroll Pos. Dur. Factbox")
            {
                Provider = "Payroll Duration";
                SubPageLink = "Positin ID" = FIELD("Positin ID");
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

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Final authority" then
            FinalAuthBool_G := false
        else
            FinalAuthBool_G := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Union Agreement Needed" then
            EditLabourUnion := true
        else
            EditLabourUnion := false;
        PositionSummarry := Rec.GetPositionSummary;

        Rec.UpdateOpenPositions;
        Rec.CheckPositionActive;

        if Rec."Final authority" then
            FinalAuthBool_G := false
        else
            FinalAuthBool_G := true;
    end;

    trigger OnClosePage()
    begin
        MandatoryFields;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        PayrollJobPosWorkerAssign.RESET;
        PayrollJobPosWorkerAssign.SETRANGE("Position ID", Rec."Position ID");
        if PayrollJobPosWorkerAssign.FINDFIRST then
            ERROR('Worker Already assign , you cannot delete this document.');
    end;

    trigger OnOpenPage()
    begin
        if Rec."Final authority" then
            FinalAuthBool_G := false
        else
            FinalAuthBool_G := true;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        MandatoryFields;
    end;

    var
        EditLabourUnion: Boolean;
        PositionSummarry: Text;
        PayrollPosition: Record "Payroll Position";
        PayrollPositionRec_G: Record "Payroll Position";
        PayrollJobPosWorkerAssign: Record "Payroll Job Pos. Worker Assign";
        FinalAuthBool_G: Boolean;

    local procedure MandatoryFields()
    begin
        PayrollPositionRec_G.RESET;
        PayrollPositionRec_G.SETRANGE("Position ID", Rec."Position ID");
        if PayrollPositionRec_G.FINDFIRST then begin
            Rec.TESTFIELD(Job);
            Rec.TESTFIELD(Description);
            Rec.TESTFIELD("Available for Assignment");
            Rec.TESTFIELD(Department);
            Rec.TESTFIELD("Pay Cycle");
            Rec.TestField("Position Type");
            Rec.TestField(Title);
        end;
    end;
}