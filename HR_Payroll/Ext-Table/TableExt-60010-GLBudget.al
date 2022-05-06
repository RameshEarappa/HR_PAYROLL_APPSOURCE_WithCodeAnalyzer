tableextension 60010 GLBudget extends "G/L Budget Entry"
{
    fields
    {
        field(60000; "Employee Code"; Code[20])
        {
            Description = 'ALFA';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('EMPLOYEE'));
            DataClassification = CustomerContent;
        }
        field(60001; "Member State Code"; Code[20])
        {
            Description = 'ALFA';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('MEMBER STATES'));
            DataClassification = CustomerContent;
        }
    }
}