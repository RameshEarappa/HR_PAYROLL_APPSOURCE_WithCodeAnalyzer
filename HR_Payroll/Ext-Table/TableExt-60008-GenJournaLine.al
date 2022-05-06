tableextension 60008 GenJournaLine extends "Gen. Journal Line"
{
    fields
    {
        modify(Amount)
        {
            trigger OnAfterValidate()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                IF ("Account Type" = "Account Type"::"Fixed Asset") AND ("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") THEN BEGIN
                    TESTFIELD("FA Quantity");
                    IF "FA Quantity" <> 0 THEN BEGIN
                        "FA Unit Amount" := Amount / "FA Quantity";
                        GLSetup.GET;
                        "FA Unit Amount" := ROUND("FA Unit Amount", GLSetup."Unit-Amount Rounding Precision");
                    END;
                END;
            end;
        }
        field(60055; "FA Quantity"; Integer)
        {
            Caption = 'FA Quantity';
            Description = 'ALFA';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") then
                    Error('FA Posting type shoulb be Acquisition Cost');

                UpdateAmount;
            end;
        }
        field(60051; "FA Unit Amount"; Decimal)
        {
            Caption = 'FA Unit Amount';
            Description = 'ALFA';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") then
                    Error('FA Posting type shoulb be Acquisition Cost');
                UpdateAmount();
            end;
        }
        field(60052; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Gen. Journal Line"."Amount (LCY)" WHERE("Document No." = FIELD("Document No."),
                                                                        "Amount (LCY)" = FILTER(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60053; "Total Amount LCY"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60054; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
    }

    local procedure UpdateAmount()
    begin
        IF "Account Type" = "Account Type"::"Fixed Asset" THEN BEGIN
            Amount := ROUND("FA Quantity" * "FA Unit Amount");
            VALIDATE(Amount);
        END;
    end;
}