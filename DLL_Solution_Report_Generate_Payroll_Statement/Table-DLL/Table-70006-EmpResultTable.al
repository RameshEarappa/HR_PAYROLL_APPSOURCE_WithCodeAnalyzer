table 70006 "Emp. Result Table"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; FormulaType; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; BaseCode; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; FormulaID1; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; Result1; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(6; FormulaID2; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; Result2; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(8; FormulaID3; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(9; Result3; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Error Log"; Blob)
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

    // #==========START======================== ParamList__KeyValue Blob =================================
    procedure SET_ErrorLog(ErrorLogP: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR("Error Log");
        if ErrorLogP = '' then
            exit;
        "Error Log".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(ErrorLogP);
        Modify;
    end;

    procedure GET_ErrorLogP(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS("Error Log");
        if not "Error Log".HASVALUE then
            exit('');

        CALCFIELDS("Error Log");
        "Error Log".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SET_ErrorLog_Code(ErrorLogP: Text; EntryNoP: Integer)
    var
        OutStream: OutStream;
        CurrentTable: Record "Emp. Result Table";
    begin
        CLEAR("Error Log");
        if ErrorLogP = '' then
            exit;
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNoP);
        if CurrentTable.FindFirst() then begin
            CurrentTable."Error Log".CreateOutStream(OutStream, TEXTENCODING::UTF8);
            OutStream.WriteText(ErrorLogP);
            CurrentTable.Modify;
        end;
    end;

    procedure GET_ErrorLog_Code(EntryNo: Integer): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        CurrentTable: Record "Emp. Result Table";
    begin
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNo);
        if CurrentTable.FindFirst() then begin
            CurrentTable.CALCFIELDS("Error Log");
            if not CurrentTable."Error Log".HASVALUE then
                exit('');

            CurrentTable.CALCFIELDS("Error Log");
            CurrentTable."Error Log".CreateInStream(InStream, TEXTENCODING::UTF8);
            exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
        end;
    end;
    // #==========STOP======================== ParamList__KeyValue Blob =================================
}