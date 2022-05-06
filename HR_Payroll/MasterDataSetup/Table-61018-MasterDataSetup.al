table 61018 "Master Data Setup"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Page ID"; Integer)
        {
            TableRelation = "Page Metadata";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                PageMetadataRec_G.RESET;
                if PageMetadataRec_G.GET("Page ID") then
                    "Page Name" := PageMetadataRec_G.Name;
            end;
        }
        field(2; "Page Name"; Text[50])
        {
            Editable = false;
            TableRelation = "Page Metadata".Name WHERE(ID = FIELD("Page ID"));
            DataClassification = CustomerContent;
        }
        field(3; "Process Identification Master"; Code[20])
        {
            TableRelation = "Identification Doc Type Master";
            DataClassification = CustomerContent;
        }
        field(4; "Sequence No."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Page ID", "Sequence No.")
        {
        }
    }

    trigger OnDelete();
    begin
        ERROR('you cannot Delete, please contact to Admin for Delete.');
    end;

    var
        PageMetadataRec_G: Record "Page Metadata";
}