table 60132 "Evaluation RQ Sub Master"
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
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; "Performance Appraisal Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Evaluation Factor Type Master";
            DataClassification = CustomerContent;
        }
        field(4; "Earning Code Group"; Code[150])
        {
            Editable = false;
            TableRelation = "Earning Code Groups";
            DataClassification = CustomerContent;
        }
        field(6; "Rating Factor Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; Weightage; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Current Type Sum"; Decimal)
        {
            CalcFormula = Sum("Evaluation RQ Sub Master".Weightage WHERE("Performance Appraisal Type" = FIELD("Performance Appraisal Type"),
                                                                          "Earning Code Group" = FIELD("Earning Code Group")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Setup Sum"; Decimal)
        {
            CalcFormula = Sum("Evaluation Setup".Weightage WHERE("Earning Code Group" = FIELD("Earning Code Group"),
                                                                  "Performance Appraisal Type" = FIELD("Performance Appraisal Type")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Serial No.", "Earning Code Group")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        EvaluationAppraisalHeaderRecG.RESET;
        EvaluationAppraisalHeaderRecG.SETCURRENTKEY("Earning Code Group");
        EvaluationAppraisalHeaderRecG.SETRANGE("Earning Code Group", "Earning Code Group");
        if EvaluationAppraisalHeaderRecG.FINDFIRST then
            ERROR(Text0001, EvaluationAppraisalHeaderRecG."Earning Code Group", EvaluationAppraisalHeaderRecG."Performance ID");
    end;

    trigger OnModify()
    begin
        EvaluationAppraisalHeaderRecG.RESET;
        EvaluationAppraisalHeaderRecG.SETCURRENTKEY("Earning Code Group");
        EvaluationAppraisalHeaderRecG.SETRANGE("Earning Code Group", "Earning Code Group");
        if EvaluationAppraisalHeaderRecG.FINDFIRST then
            ERROR(Text0002, EvaluationAppraisalHeaderRecG."Earning Code Group", EvaluationAppraisalHeaderRecG."Performance ID");
    end;

    var
        EvaluationAppraisalHeaderRecG: Record "Evaluation Appraisal Header";
        Text0001: Label 'Earning Code Group %1 used in Evaluation Process %2 , So you cannot delete.';
        Text0002: Label 'Earning Code Group %1 used in Evaluation Process %2 , So you cannot Modify.';
}