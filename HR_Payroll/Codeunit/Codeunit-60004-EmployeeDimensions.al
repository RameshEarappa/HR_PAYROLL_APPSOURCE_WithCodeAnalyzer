Codeunit 60004 "Employee Dimensions"
{
    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterInsertEvent', '', false, false)]
    procedure InsertDimension(var Rec: Record Employee; RunTrigger: Boolean);
    var
        HRSetup: Record "Human Resources Setup";
        Dimension: Record Dimension;
        DimValue: Record "Dimension Value";
        DefDim: Record "Default Dimension";
    begin
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnBeforeModifyEvent', '', false, false)]
    procedure ModifyDimesnion(var Rec: Record Employee; var xRec: Record Employee; RunTrigger: Boolean);
    var
        HRSetup: Record "Human Resources Setup";
        Dimension: Record Dimension;
        DimValue: Record "Dimension Value";
        DefDim: Record "Default Dimension";
    begin
        if Rec."Global Dimension 1 Code" = '' then begin
            CLEAR(Dimension);
            CLEAR(HRSetup);
            HRSetup.GET;
            Dimension.SETRANGE(Code, HRSetup."Employee Dimension Code");
            Dimension.FINDFIRST;

            CLEAR(DimValue);
            DimValue.SETRANGE("Dimension Code", HRSetup."Employee Dimension Code");
            DimValue.SETRANGE(Code, Rec."No.");
            if not DimValue.FINDFIRST then begin
                DimValue.INIT;
                DimValue.VALIDATE("Dimension Code", HRSetup."Employee Dimension Code");
                DimValue.VALIDATE(Code, Rec."No.");
                DimValue.VALIDATE(Name, Rec."First Name");
                DimValue.VALIDATE("Global Dimension No.", 1);
                DimValue.VALIDATE("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                DimValue.INSERT(true);
            end else begin
                DimValue.VALIDATE(Name, Rec."First Name");
                DimValue.VALIDATE("Global Dimension No.", 1);
                DimValue.VALIDATE("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                DimValue.MODIFY(true);
            end;
            Rec."Global Dimension 1 Code" := Rec."No.";
            CLEAR(DefDim);
            DefDim.SETCURRENTKEY("Table ID", "No.", "Dimension Code");
            DefDim.SETRANGE("Table ID", DATABASE::Employee);
            DefDim.SETRANGE("No.", Rec."No.");
            DefDim.SETRANGE("Dimension Code", Rec."No.");
            if not DefDim.FINDFIRST then begin
                DefDim.INIT;
                DefDim."Table ID" := DATABASE::Employee;
                DefDim."No." := Rec."No.";
                DefDim."Dimension Code" := HRSetup."Employee Dimension Code";
                DefDim."Dimension Value Code" := Rec."No.";
                DefDim."Value Posting" := DefDim."Value Posting"::"Same Code";
                DefDim."Table Caption" := Rec.TABLECAPTION;
                DefDim.INSERT;
            end;
        end;
    end;
}