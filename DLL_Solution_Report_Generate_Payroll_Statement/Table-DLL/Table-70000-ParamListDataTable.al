table 70000 "ParamList Data Table"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; ParamList__KeyId; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; ParamList__KeyValue; blob)
        {
            DataClassification = CustomerContent;
        }
        field(4; ParamList__DataType; Text[250])
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
    procedure SET_ParamList__KeyValue(ParamList__KeyValueP: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR(ParamList__KeyValue);
        if ParamList__KeyValueP = '' then
            exit;
        ParamList__KeyValue.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(ParamList__KeyValueP);
        Modify;
    end;

    procedure GET_ParamList__KeyValueP(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS(ParamList__KeyValue);
        if not ParamList__KeyValue.HASVALUE then
            exit('');

        CALCFIELDS(ParamList__KeyValue);
        ParamList__KeyValue.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SET_ParamList__KeyValue_Code(ParamList__KeyValueP: Text; EntryNoP: Integer)
    var
        OutStream: OutStream;
        CurrentTable: Record "ParamList Data Table";
    begin
        CLEAR(ParamList__KeyValue);
        if ParamList__KeyValueP = '' then
            exit;
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNoP);
        if CurrentTable.FindFirst() then begin
            CurrentTable.ParamList__KeyValue.CreateOutStream(OutStream, TEXTENCODING::UTF8);
            OutStream.WriteText(ParamList__KeyValueP);
            CurrentTable.Modify;
        end;
    end;

    procedure GET_ParamList__KeyValueP_Code(EntryNo: Integer): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        CurrentTable: Record "ParamList Data Table";
    begin
        CurrentTable.Reset();
        CurrentTable.SetRange("Entry No.", EntryNo);
        if CurrentTable.FindFirst() then begin
            CurrentTable.CALCFIELDS(ParamList__KeyValue);
            if not CurrentTable.ParamList__KeyValue.HASVALUE then
                exit('');

            CurrentTable.CALCFIELDS(ParamList__KeyValue);
            CurrentTable.ParamList__KeyValue.CreateInStream(InStream, TEXTENCODING::UTF8);
            exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
        end;
    end;
    // #==========STOP======================== ParamList__KeyValue Blob =================================
}