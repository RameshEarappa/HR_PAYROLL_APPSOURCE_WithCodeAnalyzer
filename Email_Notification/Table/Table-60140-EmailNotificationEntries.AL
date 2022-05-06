table 60140 "Email Notification Entries"
{
    DataClassification = CustomerContent;
    fields
    {
        field(5; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(6; "Table No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Document No"; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Email Sent"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; "status"; Enum "Email Notification Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(10; SenderUserID; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(11; ReceiverUserID; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(12; Error; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Sent status"; Enum "Email Notification Sent Status")
        {
            Caption = 'Sent Status';
            DataClassification = CustomerContent;
        }
        field(14; RecordIDs; RecordId)
        {
            DataClassification = CustomerContent;
        }
        field(15; HeaderTxt; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(16; BodyTxt; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(17; FooterTxt; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(18; Subject; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(19; HtmlFormatted; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No") { Clustered = true; }
    }

    var
        myInt: Integer;

    procedure InsertRecords(TableNoInt: Integer;
                            DocumentNoCode: Code[30];
                            SenderUserID: Code[50];
                            ReceiverUserID: Code[50];
                            RecordIDs: RecordId;
                            status: Enum "Approval Status";
                            HeaderTxt: Text;
                            BodyTxt: Text;
                            FooterTxt: Text;
                            Subject: Text
                            ): Boolean
    var
        EmailNotiEntriesRecL: Record "Email Notification Entries";

    begin
        EmailNotiEntriesRecL.Init();
        EmailNotiEntriesRecL."Entry No" := 0;
        EmailNotiEntriesRecL."Document No" := DocumentNoCode;
        EmailNotiEntriesRecL."Table No" := TableNoInt;
        EmailNotiEntriesRecL.SenderUserID := SenderUserID;
        EmailNotiEntriesRecL.ReceiverUserID := ReceiverUserID;
        EmailNotiEntriesRecL.RecordIDs := RecordIDs;
        EmailNotiEntriesRecL.status := status;
        EmailNotiEntriesRecL."Email Sent" := false;
        EmailNotiEntriesRecL."Sent status" := EmailNotiEntriesRecL."Sent status"::Open;
        EmailNotiEntriesRecL.HeaderTxt := HeaderTxt;
        EmailNotiEntriesRecL.BodyTxt := BodyTxt;
        EmailNotiEntriesRecL.FooterTxt := FooterTxt;
        EmailNotiEntriesRecL.Subject := Subject;
        exit(EmailNotiEntriesRecL.Insert());
    end;
}