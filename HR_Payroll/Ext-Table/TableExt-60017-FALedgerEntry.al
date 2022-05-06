tableextension 60017 FALedgerEntry extends "FA Ledger Entry"
{
    fields
    {
        field(70000; "FA Quantity"; Integer)
        {
            Caption = 'FA Quantity';
            Description = 'ALFA';
            DataClassification = CustomerContent;
        }
        field(70001; "FA Unit Amount"; Decimal)
        {
            Caption = 'FA Unit Amount';
            Description = 'ALFA';
            DataClassification = CustomerContent;
        }
    }
}