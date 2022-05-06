table 60126 "Evaluation Rating/Quest Master"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Serial No."; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Rating Factor"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Evaluation Factor Type"; Code[20])
        {
            TableRelation = "Evaluation Factor Type Master";
            DataClassification = CustomerContent;
        }
        field(4; "Inserted Bool"; Boolean)
        {
            Caption = 'Select';
            DataClassification = CustomerContent;
        }
        field(5; "Rating Factor Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Serial No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        UserSetupRecG.RESET;
        UserSetupRecG.SETRANGE("User ID", USERID);
        if UserSetupRecG.FINDFIRST then;
        if not UserSetupRecG."HR Manager" then
            ERROR(Text001);

        EvaluationRQSubMasterRecG.RESET;
        EvaluationRQSubMasterRecG.SETCURRENTKEY("Rating Factor", "Performance Appraisal Type");
        EvaluationRQSubMasterRecG.SETRANGE("Rating Factor", "Rating Factor");
        EvaluationRQSubMasterRecG.SETRANGE("Performance Appraisal Type", "Evaluation Factor Type");
        if EvaluationRQSubMasterRecG.FINDFIRST then
            ERROR(Text002);
    end;

    trigger OnInsert()
    begin
        EvaluationRatingQuestMasterRecG.RESET;
        if EvaluationRatingQuestMasterRecG.FINDLAST then
            "Serial No." := EvaluationRatingQuestMasterRecG."Serial No." + 10000;
    end;

    trigger OnModify()
    begin
        UserSetupRecG.RESET;
        UserSetupRecG.SETRANGE("User ID", USERID);
        if UserSetupRecG.FINDFIRST then;
        if not UserSetupRecG."HR Manager" then
            ERROR(Text003);

        EvaluationRQSubMasterRecG.RESET;
        EvaluationRQSubMasterRecG.SETCURRENTKEY("Rating Factor", "Performance Appraisal Type");
        EvaluationRQSubMasterRecG.SETRANGE("Rating Factor", "Rating Factor");
        EvaluationRQSubMasterRecG.SETRANGE("Performance Appraisal Type", "Evaluation Factor Type");
        if EvaluationRQSubMasterRecG.FINDFIRST then
            ERROR(Text004);
    end;

    var
        EvaluationRatingQuestMasterRecG: Record "Evaluation Rating/Quest Master";
        EvaluationRQSubMasterRecG: Record "Evaluation RQ Sub Master";
        UserSetupRecG: Record "User Setup";
        Text001: Label 'You don''t have permission to delete Records.';
        Text002: Label 'You cannot delete records, it''s using in Setups.';
        Text003: Label 'You don''t have permission to Modify Records.';
        Text004: Label 'You cannot modify records, it''s using in Setups.';
}