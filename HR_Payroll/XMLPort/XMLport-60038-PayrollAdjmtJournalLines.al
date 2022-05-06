xmlport 60038 "Payroll Adjmt. Journal Lines"
{
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'UploadBenefitAdjJournalLine';
                SourceTableView = SORTING(Number) WHERE(Number = FILTER(1));
                textelement(empid)
                {
                    XmlName = 'a';
                }
                textelement(EarningCodeTxt)
                {
                    XmlName = 'b';
                }
                textelement(VoucherDescription)
                {
                    XmlName = 'c';
                }
                textelement(Amount)
                {
                    XmlName = 'd';
                }

                trigger OnAfterInsertRecord();
                var
                begin
                    InitialiazeVar;
                    Evaluate(EMPCODEG, empid);
                    Evaluate(EARNINGCODEG, EarningCodeTxt);
                    Evaluate(AMOUNTSG, Amount);
                    Evaluate(VOUCHERDESC, VoucherDescription);
                    InsertLines;
                end;

                trigger OnBeforeInsertRecord();
                begin
                    if firstline then begin
                        firstline := false;
                        currXMLport.SKIP;
                    end;
                end;
            }
        }
    }

    procedure UpdateLinesNo(): Integer
    var
        PayrollAdjmtJournalLinesRecL: Record "Payroll Adjmt. Journal Lines";
    begin
        PayrollAdjmtJournalLinesRecL.Reset();
        PayrollAdjmtJournalLinesRecL.SetRange("Journal No.", JournalNoG);
        if PayrollAdjmtJournalLinesRecL.FindLast() then;

        exit(PayrollAdjmtJournalLinesRecL."Line No." + 10000);
    end;

    procedure SetJournNo(Jno: Code[20])
    begin
        Clear(JournalNoG);
        JournalNoG := Jno;
    end;


    trigger OnPostXmlPort();
    begin
        MESSAGE('Entries uploaded successfully');
    end;

    trigger OnPreXmlPort();
    begin
        firstline := true;
    end;

    var
        JournalNoG: Code[20];
        firstline: Boolean;
        Cnt: Integer;
        EMPCODEG: Code[50];
        EARNINGCODEG: Code[20];
        AMOUNTSG: Decimal;
        VOUCHERDESC: Text;


    procedure InitialiazeVar()
    begin
        Clear(EMPCODEG);
        Clear(EARNINGCODEG);
        Clear(AMOUNTSG);
        Clear(VOUCHERDESC);
    end;


    procedure InsertLines()
    var
        PayrollAdjmtJournalLinesRecL: Record "Payroll Adjmt. Journal Lines";
    begin
        PayrollAdjmtJournalLinesRecL.Init();
        PayrollAdjmtJournalLinesRecL."Journal No." := JournalNoG;
        PayrollAdjmtJournalLinesRecL."Line No." := UpdateLinesNo();
        PayrollAdjmtJournalLinesRecL.Validate("Employee Code", EMPCODEG);
        PayrollAdjmtJournalLinesRecL.Validate("Earning Code", EARNINGCODEG);
        PayrollAdjmtJournalLinesRecL.Validate(Amount, AMOUNTSG);
        PayrollAdjmtJournalLinesRecL.Validate("Voucher Description", VOUCHERDESC);
        PayrollAdjmtJournalLinesRecL.Insert(true);
    end;
}