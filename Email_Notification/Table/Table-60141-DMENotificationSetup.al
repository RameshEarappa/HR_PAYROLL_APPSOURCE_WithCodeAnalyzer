table 60141 "DME Notification Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(5; "Process ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Table Metadata";
            trigger OnValidate()
            var
                PageMetaDataRecL: Record "Table Metadata";
            begin
                Clear(PageMetaDataRecL);
                PageMetaDataRecL.Reset();
                if PageMetaDataRecL.Get("Process ID") then begin
                    "Process Name" := PageMetaDataRecL.Name;
                    "Process Caption" := PageMetaDataRecL.Caption;
                end;
            end;
        }
        field(6; "Process Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "HR Manager"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(8; Finances; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Process Caption"; Text[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Process ID")
        {
            Clustered = true;
        }
    }
}