table 70022 "Emp. Benefits List FnFCalc"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; EBList__Benefitcode; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; EBList__UnitFormula; Blob)
        {
            DataClassification = CustomerContent;
        }
        field(4; EBList__ValueFormula; blob)
        {
            DataClassification = CustomerContent;
        }
        field(5; EBList__EncashmentFormula; Blob)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    // #==========START======================== EBList__UnitFormula Blob =================================
    procedure SET_EBList__UnitFormula(EBList__UnitFormulaP: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR(EBList__UnitFormula);
        if EBList__UnitFormulaP = '' then
            exit;
        EBList__UnitFormula.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(EBList__UnitFormulaP);
        Modify;
    end;

    procedure GET_EBList__UnitFormula(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS(EBList__UnitFormula);
        if not EBList__UnitFormula.HASVALUE then
            exit('');

        CALCFIELDS(EBList__UnitFormula);
        EBList__UnitFormula.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SET_EBList__UnitFormula_Code(EBList__UnitFormulaP: Text; EntryNoP: Integer)
    var
        OutStream: OutStream;
        CurrentTable: Record "Emp. Benefits List FnFCalc";
    begin
        CLEAR(EBList__UnitFormula);
        if EBList__UnitFormulaP = '' then
            exit;
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNoP);
        if CurrentTable.FindFirst() then begin
            CurrentTable.EBList__UnitFormula.CreateOutStream(OutStream, TEXTENCODING::UTF8);
            OutStream.WriteText(EBList__UnitFormulaP);
            CurrentTable.Modify;
        end;
    end;

    procedure GET_EBList__UnitFormula_Code(EntryNo: Integer): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        CurrentTable: Record "Emp. Benefits List FnFCalc";
    begin
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNo);
        if CurrentTable.FindFirst() then begin
            CurrentTable.CALCFIELDS(EBList__UnitFormula);
            if not CurrentTable.EBList__UnitFormula.HASVALUE then
                exit('');

            CurrentTable.CALCFIELDS(EBList__UnitFormula);
            CurrentTable.EBList__UnitFormula.CreateInStream(InStream, TEXTENCODING::UTF8);
            exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
        end;
    end;
    // #==========STOP======================== EBList__UnitFormula Blob =================================

    // #==========START======================== EBList__EncashmentFormula Blob =================================
    procedure SET_EBList__EncashmentFormula(EBList__EncashmentFormulaP: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR(EBList__EncashmentFormula);
        if EBList__EncashmentFormulaP = '' then
            exit;
        EBList__EncashmentFormula.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(EBList__EncashmentFormulaP);
        Modify;
    end;

    procedure GET_EBList__EncashmentFormula(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS(EBList__EncashmentFormula);
        if not EBList__EncashmentFormula.HASVALUE then
            exit('');

        CALCFIELDS(EBList__EncashmentFormula);
        EBList__EncashmentFormula.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SET_EBList__EncashmentFormula_Code(EBList__EncashmentFormulaP: Text; EntryNoP: Integer)
    var
        OutStream: OutStream;
        CurrentTable: Record "Emp. Benefits List FnFCalc";
    begin
        CLEAR(EBList__EncashmentFormula);
        if EBList__EncashmentFormulaP = '' then
            exit;
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNoP);
        if CurrentTable.FindFirst() then begin
            CurrentTable.EBList__EncashmentFormula.CreateOutStream(OutStream, TEXTENCODING::UTF8);
            OutStream.WriteText(EBList__EncashmentFormulaP);
            CurrentTable.Modify;
        end;
    end;

    procedure GET_EBList__EncashmentFormula_Code(EntryNo: Integer): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        CurrentTable: Record "Emp. Benefits List FnFCalc";
    begin
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNo);
        if CurrentTable.FindFirst() then begin
            CurrentTable.CALCFIELDS(EBList__EncashmentFormula);
            if not CurrentTable.EBList__EncashmentFormula.HASVALUE then
                exit('');

            CurrentTable.CALCFIELDS(EBList__EncashmentFormula);
            CurrentTable.EBList__EncashmentFormula.CreateInStream(InStream, TEXTENCODING::UTF8);
            exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
        end;
    end;
    // #==========STOP======================== EBList__EncashmentFormula Blob ================================

    // #==========START======================== EBList__ValueFormula Blob =================================
    procedure SET_EBList__ValueFormula(EBList__ValueFormulaP: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR(EBList__ValueFormula);
        if EBList__ValueFormulaP = '' then
            exit;
        EBList__ValueFormula.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(EBList__ValueFormulaP);
        Modify;
    end;

    procedure GET_EBList__ValueFormula(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS(EBList__ValueFormula);
        if not EBList__ValueFormula.HASVALUE then
            exit('');

        CALCFIELDS(EBList__ValueFormula);
        EBList__ValueFormula.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SET_EBList__ValueFormula_Code(EBList__ValueFormulaP: Text; EntryNoP: Integer)
    var
        OutStream: OutStream;
        CurrentTable: Record "Emp. Benefits List FnFCalc";
    begin
        CLEAR(EBList__ValueFormula);
        if EBList__ValueFormulaP = '' then
            exit;
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNoP);
        if CurrentTable.FindFirst() then begin
            CurrentTable.EBList__ValueFormula.CreateOutStream(OutStream, TEXTENCODING::UTF8);
            OutStream.WriteText(EBList__ValueFormulaP);
            CurrentTable.Modify;
        end;
    end;

    procedure GET_EBList__ValueFormula_Code(EntryNo: Integer): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        CurrentTable: Record "Emp. Benefits List FnFCalc";
    begin
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNo);
        if CurrentTable.FindFirst() then begin
            CurrentTable.CALCFIELDS(EBList__ValueFormula);
            if not CurrentTable.EBList__ValueFormula.HASVALUE then
                exit('');

            CurrentTable.CALCFIELDS(EBList__ValueFormula);
            CurrentTable.EBList__ValueFormula.CreateInStream(InStream, TEXTENCODING::UTF8);
            exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
        end;
    end;
    // #==========STOP======================== EBList__ValueFormula Blob =================================
}