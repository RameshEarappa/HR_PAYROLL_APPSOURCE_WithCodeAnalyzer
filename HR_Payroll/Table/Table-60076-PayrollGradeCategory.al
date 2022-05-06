table 60076 "Payroll Grade Category"
{
    DrillDownPageID = "Payroll Grade Categories";
    LookupPageID = "Payroll Grade Categories";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Grade Category ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Grade Category Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Grade Category ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        EarningCodeGroupsRecL: Record "Earning Code Groups";
    begin
        EarningCodeGroupsRecL.RESET;
        EarningCodeGroupsRecL.SETRANGE("Grade Category", "Grade Category ID");
        if EarningCodeGroupsRecL.FINDFIRST then
            ERROR('Earning Category Created for %1 Grade Category . Cannot be deleted.', "Grade Category ID");
    end;
}