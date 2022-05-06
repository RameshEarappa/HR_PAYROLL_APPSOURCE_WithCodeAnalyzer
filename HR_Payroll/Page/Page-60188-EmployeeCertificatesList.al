page 60188 "Employee Certificates List"
{
    CardPageID = "Employee Certificate Card";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll Job Certificate Line";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
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
        area(creation)
        {
            action(NEW)
            {
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ApplicationArea = all;
                Image = New;
                trigger OnAction()
                begin
                    CLEAR(LineNoG);
                    LineNoG := GetNewLineNumber(Rec."Emp ID");
                    PayrollJobCertificateLineRecG.INIT;
                    PayrollJobCertificateLineRecG.VALIDATE("Emp ID", Rec."Emp ID");
                    PayrollJobCertificateLineRecG.VALIDATE("Line  No.", LineNoG);
                    PayrollJobCertificateLineRecG.INSERT(true);
                    COMMIT;
                    PAGE.RUNMODAL(60191, PayrollJobCertificateLineRecG);
                end;
            }
        }
    }

    var
        PayrollJobCertificateLineRecG: Record "Payroll Job Certificate Line";
        LineNoG: Integer;

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