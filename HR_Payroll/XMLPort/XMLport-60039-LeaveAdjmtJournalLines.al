xmlport 60039 "Leave Adjmt. Journal Lines"
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
                XmlName = 'UploadLeaveAdjJournalLine';
                SourceTableView = SORTING(Number) WHERE(Number = FILTER(1));
                textelement(empidTxt)
                {
                    XmlName = 'a';
                }
                textelement(LeaveTypeIDTxt)
                {
                    XmlName = 'b';
                }
                textelement(CalculationUnitsTxt)
                {
                    XmlName = 'c';
                }
                textelement(VoucherDescriptionTxt)
                {
                    XmlName = 'd';
                }
                trigger OnAfterInsertRecord();
                var
                begin
                    InitialiazeVar;
                    Evaluate(EMPCODEG, empidTxt);
                    Evaluate(LEAVTYPE, LeaveTypeIDTxt);
                    Evaluate(CALCUNIT, CalculationUnitsTxt);
                    Evaluate(VOUCHERDESC, VoucherDescriptionTxt);
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
        LeaveAdjmtJournalLinesRecL: Record "Leave Adj Journal Lines";
    begin
        LeaveAdjmtJournalLinesRecL.Reset();
        LeaveAdjmtJournalLinesRecL.SetRange("Journal No.", JournalNoG);
        if LeaveAdjmtJournalLinesRecL.FindLast() then;

        exit(LeaveAdjmtJournalLinesRecL."Line No." + 10000);
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
        LEAVTYPE: Code[20];
        CALCUNIT: Decimal;
        VOUCHERDESC: Text;

    procedure InitialiazeVar()
    begin
        Clear(EMPCODEG);
        Clear(LEAVTYPE);
        Clear(CALCUNIT);
        Clear(VOUCHERDESC);
    end;

    procedure InsertLines()
    var
        LeaveAdjmtJournalLinesRecL: Record "Leave Adj Journal Lines";
    begin
        LeaveAdjmtJournalLinesRecL.Init();
        LeaveAdjmtJournalLinesRecL."Journal No." := JournalNoG;
        LeaveAdjmtJournalLinesRecL."Line No." := UpdateLinesNo();
        LeaveAdjmtJournalLinesRecL.Validate("Employee Code", EMPCODEG);
        LeaveAdjmtJournalLinesRecL.Validate("Leave Type ID", LEAVTYPE);
        LeaveAdjmtJournalLinesRecL.Validate("Calculation Units", CALCUNIT);
        LeaveAdjmtJournalLinesRecL.Validate("Voucher Description", VOUCHERDESC);
        LeaveAdjmtJournalLinesRecL.Insert(true);
    end;
}