table 60069 "Payroll Position Duration"
{
    DrillDownPageID = "Payroll Position Duration";
    LookupPageID = "Payroll Position Duration";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Positin ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Activation; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Retirement <> 0D) and (Activation < Retirement) then
                    ERROR('Activation Date should be less than Retirement Date');

                CheckPositionActive;
            end;
        }
        field(3; Retirement; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Activation <> 0D) and (Retirement < Activation) then
                    ERROR('Retirement Date should be greater than Activation Date');
                CheckPositionActive;
            end;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Positin ID", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if PayrollPosition.GET("Positin ID") then begin
            if (Activation <> 0D) and (Activation < PayrollPosition."Available for Assignment") then
                ERROR('Activation Date should be after Available for Assignment Date %1', PayrollPosition."Available for Assignment");

            if (Retirement <> 0D) and (Retirement < PayrollPosition."Available for Assignment") then
                ERROR('Retirement Date should be after Available for Assignment Date %1', PayrollPosition."Available for Assignment");
        end;

        PayrollPositionDuration.RESET;
        PayrollPositionDuration.SETRANGE("Positin ID", Rec."Positin ID");
        PayrollPositionDuration.SETFILTER(Activation, '<=%1', Rec.Activation);
        PayrollPositionDuration.SETFILTER(Retirement, '>=%1', Rec.Activation);
        if PayrollPositionDuration.FINDFIRST then
            ERROR('Payroll Duration Overlaps with another record');
        CheckPositionActive;
    end;

    trigger OnModify()
    begin
        if PayrollPosition.GET("Positin ID") then begin
            if (Activation <> 0D) and (Activation < PayrollPosition."Available for Assignment") then
                ERROR('Activation Date should be after Available for Assignment Date %1', PayrollPosition."Available for Assignment");

            if (Retirement <> 0D) and (Retirement < PayrollPosition."Available for Assignment") then
                ERROR('Retirement Date should be after Available for Assignment Date %1', PayrollPosition."Available for Assignment");
        end;
        CheckPositionActive;
    end;

    var
        PayrollPosition: Record "Payroll Position";
        PayrollPositionDuration: Record "Payroll Position Duration";
        PayrollPos: Record "Payroll Position";
        PayrollWorkerAssign: Record "Payroll Job Pos. Worker Assign";

    local procedure CheckPositionActive()
    begin
        if PayrollPos.GET(Rec."Positin ID") then begin
            if (Retirement = 0D) and (Activation <= WORKDATE) then
                PayrollPos."Inactive Position" := false
            else
                PayrollPos."Inactive Position" := true;

            if (Retirement <> 0D) and (Retirement < WORKDATE) then
                PayrollPos."Inactive Position" := true
            else
                PayrollPos."Inactive Position" := false;
            if PayrollPos."Inactive Position" then begin
                if PayrollPos."Open Position" then
                    PayrollPos."Open Position" := false;
            end
            else begin
                PayrollWorkerAssign.RESET;
                PayrollWorkerAssign.SETRANGE("Position ID", Rec."Positin ID");
                PayrollWorkerAssign.SETFILTER(Worker, '<>%1', '');
                if PayrollWorkerAssign.FINDFIRST then
                    PayrollPos."Open Position" := false
                else
                    PayrollPos."Open Position" := true;
            end;
            if (PayrollPos."Available for Assignment" <> 0D) and (Activation <> 0D) then
                if Activation < PayrollPos."Available for Assignment" then
                    ERROR('Available for assignment cannot be before activation date');
            PayrollPos.MODIFY;
        end;
    end;
}