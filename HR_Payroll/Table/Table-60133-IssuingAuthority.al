table 60133 "Issuing Authority"
{
    LookupPageId = "Issuing Authority List";
    DrillDownPageId = "Issuing Authority List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[150])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    trigger
    OnDelete()
    var
        IdentificationMasterRecL: Record "Identification Master";
    begin
        IdentificationMasterRecL.Reset();
        IdentificationMasterRecL.SetRange("Issuing Authority", Code);
        if IdentificationMasterRecL.FindFirst() then
            Error('Issuing Authority already attached to a position, cannot be deleted. ');
    end;
}