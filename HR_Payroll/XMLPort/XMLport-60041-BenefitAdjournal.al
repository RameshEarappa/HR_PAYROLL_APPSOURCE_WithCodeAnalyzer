xmlport 60041 "Benefit Admnt Line Export"
{
    Direction = Export;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    FileName = 'Benefit Admnt Line.CSV';

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
                textelement(BenefitCode)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BenefitCode := 'Benefit Code';
                    end;
                }
                textelement(Amount)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Amount := 'Amount';
                    end;
                }
                textelement(CalculationUnits)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CalculationUnits := 'Calculation Units';
                    end;
                }
            }
        }
    }

    procedure UpdateLinesNo(): Integer
    var
        BenefitAdjmtJournalLinesRecL: Record "Benefit Adjmt. Journal Lines";
    begin
        BenefitAdjmtJournalLinesRecL.Reset();
        BenefitAdjmtJournalLinesRecL.SetRange("Journal No.", JournalNoG);
        if BenefitAdjmtJournalLinesRecL.FindLast() then;

        exit(BenefitAdjmtJournalLinesRecL."Line No." + 10000);
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
        BENEFITCODEG: Code[50];
        AMOUNTSG: Decimal;
        CALCUNITG: Decimal;

    procedure InitialiazeVar()
    begin
        Clear(EMPCODEG);
        Clear(BENEFITCODEG);
        Clear(AMOUNTSG);
        Clear(CALCUNITG);
    end;

    procedure InsertLines()
    var
        BenAdjJrnlLinesRecL: Record "Benefit Adjmt. Journal Lines";
    begin
        BenAdjJrnlLinesRecL.Init();
        BenAdjJrnlLinesRecL."Journal No." := JournalNoG;
        BenAdjJrnlLinesRecL."Line No." := UpdateLinesNo();
        BenAdjJrnlLinesRecL.Validate("Employee Code", EMPCODEG);
        BenAdjJrnlLinesRecL.Validate(Benefit, BENEFITCODEG);
        BenAdjJrnlLinesRecL.Validate(Amount, AMOUNTSG);
        BenAdjJrnlLinesRecL.Validate("Calculation Units", CALCUNITG);
        BenAdjJrnlLinesRecL.Insert(true);
    end;
}