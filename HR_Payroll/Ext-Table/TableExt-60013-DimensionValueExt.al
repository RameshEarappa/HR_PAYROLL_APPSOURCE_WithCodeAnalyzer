
tableextension 60013 DimensionValueExt extends "Dimension Value"
{
    fields
    {
        field(60000; Balance; Decimal)
        {
            FieldClass = FlowField;
            Description = 'ALFA';
            Editable = false;
        }
        field(60001; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'ALFA';
            FieldClass = FlowFilter;
        }
        field(60002; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            Description = 'ALFA';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(60003; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            Description = 'ALFA';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(60004; "GL No. Filter"; Code[20])
        {
            Caption = 'GL No. Filter';
            Description = 'ALFA';
            FieldClass = FlowFilter;
            TableRelation = "G/L Account";
        }
        field(60005; "Report Name1"; Text[50])
        {
            Caption = 'Report Name1';
            Description = 'ALFA';
            DataClassification = CustomerContent;
        }
        field(60006; "Report Name2"; Text[50])
        {
            Caption = 'Report Name2';
            Description = 'ALFA';
            DataClassification = CustomerContent;
        }
        field(60007; "Report Name3"; Text[50])
        {
            Caption = 'Report Name3';
            Description = 'ALFA';
            DataClassification = CustomerContent;
        }
        field(60008; "Report Name4"; Text[50])
        {
            Caption = 'Report Name4';
            Description = 'ALFA';
            DataClassification = CustomerContent;
        }
        field(60009; BalanceMember; Decimal)
        {
            FieldClass = FlowField;
            Description = 'ALFA';
            Editable = false;

        }
        field(60010; BalanceOffice; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Global Dimension 2 Code" = FIELD(Code),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "G/L Account No." = FIELD("GL No. Filter")));
            Description = 'ALFA';
            Editable = false;

        }
        field(60011; BalanceMember2; Decimal)
        {
            Description = 'ALFA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60012; "Doc. Date Filter"; Date)
        {
            Caption = 'Doc. Date Filter';
            Description = 'ALFA';
            FieldClass = FlowFilter;
        }
        field(60013; "Budgeted Amount Member"; Decimal)
        {
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("Budget Dimension 4 Code" = FIELD(Code),
                                                               "G/L Account No." = FIELD("GL No. Filter"),
                                                               Date = FIELD("Date Filter")));
            Caption = 'Budgeted Amount Member';
        }
    }
}