table 60125 "Evaluation Factor Type Master"
{
    DrillDownPageID = "Evaluation Factor Type Master";
    LookupPageID = "Evaluation Factor Type Master";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Defination of Skill"; Text[250])
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
    }

    trigger OnDelete()
    begin
        UserSetupRecG.RESET;
        UserSetupRecG.SETRANGE("User ID", USERID);
        if UserSetupRecG.FINDFIRST then
            if not UserSetupRecG."HR Manager" then
                ERROR(Text0001);

        EvaluationRatingQuestMasterRecG.RESET;
        EvaluationRatingQuestMasterRecG.SETRANGE("Evaluation Factor Type", Code);
        if EvaluationRatingQuestMasterRecG.FINDFIRST then
            ERROR(Text0002);
    end;

    trigger OnModify()
    begin
        UserSetupRecG.RESET;
        UserSetupRecG.SETRANGE("User ID", USERID);
        if UserSetupRecG.FINDFIRST then
            if not UserSetupRecG."HR Manager" then
                ERROR(Text0003);

        EvaluationRatingQuestMasterRecG.RESET;
        EvaluationRatingQuestMasterRecG.SETRANGE("Evaluation Factor Type", Code);
        if EvaluationRatingQuestMasterRecG.FINDFIRST then
            ERROR(Text0002);
    end;

    var
        UserSetupRecG: Record "User Setup";
        EvaluationRatingQuestMasterRecG: Record "Evaluation Rating/Quest Master";
        Text0001: Label 'You don''t have permission to delete Records.';
        Text0002: Label 'Evaluation Type already using.';
        Text0003: Label 'You don''t have permission to modify  Records.';
}