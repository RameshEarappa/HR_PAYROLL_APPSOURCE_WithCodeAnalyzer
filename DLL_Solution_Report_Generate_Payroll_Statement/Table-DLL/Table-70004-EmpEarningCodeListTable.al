table 70004 "Emp. Earning Code  List Table"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; EECList__Paycomponentcode; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; EECList__UnitFormula; Blob)
        {
            DataClassification = CustomerContent;
        }
        field(4; EECList__Formulaforattendance; Blob)
        {
            DataClassification = CustomerContent;
        }
        field(5; EECList__Formulafordays; Blob)
        {
            DataClassification = CustomerContent;
        }
        field(6; EECList__Paycomponenttype; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; EECList__Pay_Comp_UnitFormula; Decimal)
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

    // #==========START======================== EECList__UnitFormula Blob =================================    

    procedure SETFormulaEECList__UnitFormula(EECList__UnitFormulaP: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR(EECList__UnitFormula);
        if EECList__UnitFormulaP = '' then
            exit;
        EECList__UnitFormula.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(EECList__UnitFormulaP);
        Modify;
    end;

    procedure GETFormulaEECList__UnitFormula(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS(EECList__UnitFormula);
        if not EECList__UnitFormula.HASVALUE then
            exit('');

        CALCFIELDS(EECList__UnitFormula);
        EECList__UnitFormula.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SETFormulaEECList__UnitFormula_Code(EECList__UnitFormulaP: Text; EntryNoP: Integer)
    var
        OutStream: OutStream;
        CurrentTable: Record "Emp. Earning Code  List Table";
    begin
        // Message('Inside Funcation %1', EECList__UnitFormulaP);
        CLEAR(EECList__UnitFormula);
        if EECList__UnitFormulaP = '' then
            exit;
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNoP);
        if CurrentTable.FindFirst() then begin
            CurrentTable.EECList__UnitFormula.CreateOutStream(OutStream, TEXTENCODING::UTF16);
            OutStream.WriteText(EECList__UnitFormulaP);
            CurrentTable.Modify;
        end;
    end;

    procedure GET_FormulaEECList__UnitFormula_Code(EntryNo: Integer): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        CurrentTable: Record "Emp. Earning Code  List Table";
    begin
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNo);
        if CurrentTable.FindFirst() then begin
            CurrentTable.CALCFIELDS(EECList__UnitFormula);
            if not CurrentTable.EECList__UnitFormula.HASVALUE then
                exit('');

            CurrentTable.CALCFIELDS(EECList__UnitFormula);
            CurrentTable.EECList__UnitFormula.CreateInStream(InStream, TEXTENCODING::UTF8);
            exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
        end;
    end;
    // #==========STOP======================== EECList__UnitFormula Blob ==========================================

    // #==========START======================== EECList__Formulaforattendance Blob =================================
    procedure SETEECList__Formulaforattendance(EECList__FormulaforattendanceP: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR(EECList__UnitFormula);
        if EECList__FormulaforattendanceP = '' then
            exit;
        EECList__UnitFormula.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(EECList__FormulaforattendanceP);
        Modify;
    end;

    procedure GETEECList__Formulaforattendance(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS(EECList__Formulaforattendance);
        if not EECList__Formulaforattendance.HASVALUE then
            exit('');

        CALCFIELDS(EECList__Formulaforattendance);
        EECList__Formulaforattendance.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SETEECList__Formulaforattendance_Code(EECList__FormulaforattendanceP: Text; EntryNoP: Integer)
    var
        OutStream: OutStream;
        CurrentTable: Record "Emp. Earning Code  List Table";
    begin
        CLEAR(EECList__UnitFormula);
        if EECList__FormulaforattendanceP = '' then
            exit;
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNoP);
        if CurrentTable.FindFirst() then begin
            CurrentTable.EECList__Formulaforattendance.CreateOutStream(OutStream, TEXTENCODING::UTF8);
            OutStream.WriteText(EECList__FormulaforattendanceP);
            CurrentTable.Modify;
        end;
    end;

    procedure GET_EECList__Formulaforattendance_Code(EntryNo: Integer): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        CurrentTable: Record "Emp. Earning Code  List Table";
    begin
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNo);
        if CurrentTable.FindFirst() then begin
            CurrentTable.CALCFIELDS(EECList__Formulaforattendance);
            if not CurrentTable.EECList__Formulaforattendance.HASVALUE then
                exit('');

            CurrentTable.CALCFIELDS(EECList__Formulaforattendance);
            CurrentTable.EECList__Formulaforattendance.CreateInStream(InStream, TEXTENCODING::UTF8);
            exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
        end;
    end;
    // #==========STOP======================== EECList__Formulaforattendance Blob =================================

    // #==========START======================== EECList__Formulafordays Blob ======================================
    procedure SETEECList__Formulafordays(EECList__FormulafordaysP: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR(EECList__UnitFormula);
        if EECList__FormulafordaysP = '' then
            exit;
        EECList__UnitFormula.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(EECList__FormulafordaysP);
        Modify;
    end;

    procedure GETEECList__Formulafordays(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS(EECList__Formulafordays);
        if not EECList__Formulafordays.HASVALUE then
            exit('');

        CALCFIELDS(EECList__Formulafordays);
        EECList__Formulafordays.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SETEECList__Formulafordays_Code(EECList__FormulafordaysP: Text; EntryNoP: Integer)
    var
        OutStream: OutStream;
        CurrentTable: Record "Emp. Earning Code  List Table";
    begin
        CLEAR(EECList__Formulafordays);
        if EECList__FormulafordaysP = '' then
            exit;
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNoP);
        if CurrentTable.FindFirst() then begin
            CurrentTable.EECList__Formulafordays.CreateOutStream(OutStream, TEXTENCODING::UTF8);
            OutStream.WriteText(EECList__FormulafordaysP);
            CurrentTable.Modify;
        end;
    end;

    procedure GET_EECList__Formulafordays_Code(EntryNo: Integer): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        CurrentTable: Record "Emp. Earning Code  List Table";
    begin
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNo);
        if CurrentTable.FindFirst() then begin
            CurrentTable.CALCFIELDS(EECList__Formulafordays);
            if not CurrentTable.EECList__Formulafordays.HASVALUE then
                exit('');

            CurrentTable.CALCFIELDS(EECList__Formulafordays);
            CurrentTable.EECList__Formulafordays.CreateInStream(InStream, TEXTENCODING::UTF8);
            exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
        end;
    end;
    // #==========STOP======================== EECList__Formulafordays Blob =================================
}