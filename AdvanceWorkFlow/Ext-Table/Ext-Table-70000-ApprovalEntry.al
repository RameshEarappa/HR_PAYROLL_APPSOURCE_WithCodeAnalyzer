tableextension 70000 "Ext Approval Entry" extends "Approval Entry"
{
    fields
    {
        field(70000; "Advance Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    trigger OnBeforeInsert()
    begin
        validate("Advance Date", Today);
    end;

    trigger OnBeforeModify()
    begin
        validate("Advance Date", Today);
    end;
}