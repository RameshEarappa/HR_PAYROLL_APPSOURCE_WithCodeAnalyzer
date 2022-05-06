table 60129 "Evaluation Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Grade Category"; Code[50])
        {
            TableRelation = "Payroll Grade Category";
            DataClassification = CustomerContent;
        }
        field(2; "Earning Code Group"; Code[20])
        {
            TableRelation = "Earning Code Groups"."Earning Code Group" WHERE("Grade Category" = FIELD("Grade Category"));
            DataClassification = CustomerContent;
        }
        field(3; "Performance Appraisal Type"; Code[20])
        {
            TableRelation = "Evaluation Factor Type Master";
            DataClassification = CustomerContent;
        }
        field(4; Weightage; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Group Total Weightage"; Decimal)
        {
            CalcFormula = Sum("Evaluation Setup".Weightage WHERE("Grade Category" = FIELD("Grade Category"),
                                                                  "Earning Code Group" = FIELD("Earning Code Group")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Grade Category", "Earning Code Group", "Performance Appraisal Type")
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
            ERROR(Test0002);

        EvaluationRQSubMasterRecG.RESET;
        EvaluationRQSubMasterRecG.SETCURRENTKEY("Performance Appraisal Type", "Earning Code Group");
        EvaluationRQSubMasterRecG.SETRANGE("Performance Appraisal Type", "Performance Appraisal Type");
        EvaluationRQSubMasterRecG.SETRANGE("Earning Code Group", "Earning Code Group");
        if EvaluationRQSubMasterRecG.FINDFIRST then
            ERROR(Test0003);
    end;

    trigger OnModify()
    begin
        UserSetupRecG.RESET;
        UserSetupRecG.SETRANGE("User ID", USERID);
        if UserSetupRecG.FINDFIRST then;
        if not UserSetupRecG."HR Manager" then
            ERROR(Test0002);

        EvaluationRQSubMasterRecG.RESET;
        EvaluationRQSubMasterRecG.SETCURRENTKEY("Performance Appraisal Type", "Earning Code Group");
        EvaluationRQSubMasterRecG.SETRANGE("Performance Appraisal Type", "Performance Appraisal Type");
        EvaluationRQSubMasterRecG.SETRANGE("Earning Code Group", "Earning Code Group");
        if EvaluationRQSubMasterRecG.FINDFIRST then
            ERROR(Test0003);
    end;

    var
        UserSetupRecG: Record "User Setup";
        Test0002: Label 'You don''t have valid permission.';
        EvaluationRQSubMasterRecG: Record "Evaluation RQ Sub Master";
        Test0003: Label 'Records already used by Setup.';
}