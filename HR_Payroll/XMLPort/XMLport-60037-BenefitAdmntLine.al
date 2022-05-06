xmlport 60037 "Benefit Admnt Line Xmlport"
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
                textelement(BenefitCode)
                {
                    XmlName = 'b';
                }
                textelement(Amount)
                {
                    XmlName = 'c';
                }
                textelement(CalculationUnits)
                {
                    XmlName = 'd';
                }
                trigger OnAfterInsertRecord();
                var
                begin
                    InitialiazeVar;
                    Evaluate(EMPCODEG, empid);
                    Evaluate(BENEFITCODEG, BenefitCode);
                    Evaluate(AMOUNTSG, Amount);
                    Evaluate(CALCUNITG, CalculationUnits);
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

