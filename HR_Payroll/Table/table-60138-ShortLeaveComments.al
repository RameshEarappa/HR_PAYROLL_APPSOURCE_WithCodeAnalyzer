table 60138 "Short Leave Comments"
{
    Caption = 'Out of Office Comment';
    LookupPageID = ShortLeaveComment1;
    DataClassification = CustomerContent;

    fields
    {
        field(11; "Short Leave Request Id"; Code[20])
        {
            Caption = 'Short Leave Request Id';
            DataClassification = CustomerContent;
        }
        field(12; "Line Manager Comment"; BLOB)
        {
            Caption = 'Line Manager Comment';
            DataClassification = CustomerContent;
        }
        field(13; "HOD Comment"; BLOB)
        {
            Caption = 'HOD Comment';
            DataClassification = CustomerContent;
        }
        field(14; "Personal Section Commentts"; BLOB)
        {
            Caption = 'Personal Section Commentts';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Short Leave Request Id")
        {
            Clustered = true;
        }
    }
    procedure SetMGR(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR("Line Manager Comment");
        if NewWorkDescription = '' then
            exit;
        "Line Manager Comment".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetMGR(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS("Line Manager Comment");
        if not "Line Manager Comment".HASVALUE then
            exit('');

        CALCFIELDS("Line Manager Comment");
        "Line Manager Comment".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SetHod(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR("HOD Comment");
        if NewWorkDescription = '' then
            exit;
        "HOD Comment".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetHOD(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS("HOD Comment");
        if not "HOD Comment".HASVALUE then
            exit('');
        CALCFIELDS("HOD Comment");
        "HOD Comment".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SetSelf(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR("Personal Section Commentts");
        if NewWorkDescription = '' then
            exit;
        "Personal Section Commentts".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetSelf(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS("Personal Section Commentts");
        if not "Personal Section Commentts".HASVALUE then
            exit('');

        CALCFIELDS("Personal Section Commentts");
        "Personal Section Commentts".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;
}