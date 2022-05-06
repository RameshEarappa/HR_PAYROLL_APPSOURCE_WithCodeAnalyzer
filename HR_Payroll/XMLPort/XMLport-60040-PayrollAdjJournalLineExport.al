xmlport 60040 "Payroll Adjmt. Journal Lne Exp"
{
    Direction = Export;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    FileName = 'Payroll Adjmt Journal Lines.CSV';
    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Caption';
                SourceTableView = WHERE(Number = CONST(1));
                textelement(EmpID)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EmpID := 'Employee ID';
                    end;
                }
                textelement(EarningCodeTxt)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EarningCodeTxt := 'Earning Code';
                    end;
                }
                textelement(VoucherDescription)
                {
                    trigger OnBeforePassVariable()
                    begin
                        VoucherDescription := 'Voucher Description';
                    end;
                }
                textelement(Amount)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Amount := 'Amount';
                    end;
                }
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