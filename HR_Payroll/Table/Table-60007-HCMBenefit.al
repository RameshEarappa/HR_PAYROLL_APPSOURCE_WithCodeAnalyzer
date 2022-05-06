table 60007 "HCM Benefit"
{
    DrillDownPageID = "HCM Benefits";
    LookupPageID = "HCM Benefits";
    DataClassification = CustomerContent;
    fields
    {
        field(10; "Benefit Id"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Benefit Id" <> xRec."Benefit Id" then begin
                    AdvancePayrollSetup.GET;
                    NoSeriesMngmnt.TestManual(AdvancePayrollSetup."Benefit No. Series");
                    AdvancePayrollSetup."Benefit No. Series" := '';
                end;
            end;
        }
        field(25; "Fin Accrual Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(35; "Max Units"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Benefit Accrual Frequency"; Option)
        {
            OptionCaption = 'None,Monthly,Yearly';
            OptionMembers = "None",Monthly,Yearly;
            DataClassification = CustomerContent;
        }
        field(45; "Unit Calc Formula"; BLOB)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Amount Calc Formula"; BLOB)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Allow Encashment"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(65; "Encashment Formula"; BLOB)
        {
            DataClassification = CustomerContent;
        }
        field(75; "Payroll Earning Code"; Code[20])
        {
            TableRelation = "Payroll Earning Code";
            DataClassification = CustomerContent;
        }
        field(90; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(150; Active; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(160; "Adjust in Salary Grade Change"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(175; "Calculate in Final Period ofFF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(185; "Benefit Type"; Option)
        {
            OptionCaption = 'Other,Ticket,Leave,Allowance';
            OptionMembers = Other,Ticket,Leave,Allowance;
            DataClassification = CustomerContent;
        }
        field(190; "Arabic Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(195; "Short Name"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (xRec."Short Name" <> '') and (xRec."Short Name" <> "Short Name") then begin
                    DeleteBenefitFormulas(xRec."Short Name", 2);
                end;
                if "Short Name" <> '' then
                    InsertBenefitFormulas("Short Name");
            end;
        }
        field(201; "Earning Code"; Code[20])
        {
            TableRelation = "Payroll Earning Code" WHERE(Active = CONST(true));
            DataClassification = CustomerContent;
        }
        field(202; "Benefit Entitlement Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(203; "Main Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            DataClassification = CustomerContent;
        }
        field(204; "Main Account No."; Code[20])
        {
            TableRelation = IF ("Main Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF ("Main Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Main Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Main Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Main Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Main Account Type" = CONST("IC Partner")) "IC Partner";
            DataClassification = CustomerContent;
        }
        field(205; "Offset Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            DataClassification = CustomerContent;
        }
        field(206; "Offset Account No."; Code[20])
        {
            TableRelation = IF ("Offset Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                 Blocked = CONST(false))
            ELSE
            IF ("Offset Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Offset Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Offset Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Offset Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Offset Account Type" = CONST("IC Partner")) "IC Partner";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Benefit Id")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PayrollBenefitEarningGroup.RESET;
        PayrollBenefitEarningGroup.SETRANGE("Benefit Id", "Benefit Id");
        if PayrollBenefitEarningGroup.FINDFIRST then
            ERROR('You Cannot delete this Earning code. Earning code groups are created for this Earning code.');
    end;

    trigger OnInsert()
    begin
        if "Benefit Id" = '' then begin
            AdvancePayrollSetup.GET;
            AdvancePayrollSetup.TESTFIELD("Benefit No. Series");
            "Benefit Id" := NoSeriesMngmnt.GetNextNo(AdvancePayrollSetup."Benefit No. Series", TODAY, true);
        end;
    end;

    var
        PayrollFormula: Record "Payroll Formula";
        AdvancePayrollSetup: Record "Advance Payroll Setup";
        NoSeriesMngmnt: Codeunit NoSeriesManagement;
        PayrollBenefitEarningGroup: Record "HCM Benefit ErnGrp";

    procedure InsertBenefitFormulas(ShortName: Code[20])
    begin
        FixedFormula('BA_' + ShortName, 'Benefit amount calculation formula value for', 2, ShortName);
        FixedFormula('BEA_' + ShortName, 'Benefit encashment formula value for ', 2, ShortName);
        FixedFormula('BE_' + ShortName, 'Benefit maximum units allowed for', 2, ShortName);
        FixedFormula('BA_OB_' + ShortName, 'Benefit opening balance amount for', 2, ShortName);
        FixedFormula('BU_OB_' + ShortName, 'Benefit opening balance units for ', 2, ShortName);
        FixedFormula('BE_' + ShortName + '_ServiceDays', 'Benefit entitlement service days for ', 2, ShortName);
        FixedFormula('BU_' + ShortName, 'Benefit units calculation formula value for', 2, ShortName);
        FixedFormula('BLTA_' + ShortName + '_Adults', 'Total number of adults eligible for LTA', 2, ShortName);
        FixedFormula('BLTA_' + ShortName + '_Infants', 'Total number of infants eligible for LTA', 2, ShortName);
        FixedFormula('BLTA_' + ShortName + '_Children', 'Total number of children eligible for LTA', 2, ShortName);
        FixedFormula('BU_ADJ_' + ShortName, 'Sum of all posted and non included benefit units in same pay period', 2, ShortName);
        FixedFormula('BU_ADJ_OB_' + ShortName, 'Sum of all posted and non included benefit units in previous pay period', 2, ShortName);
        FixedFormula('BA_ADJ_' + ShortName, 'Sum of all posted and non included benefit amounts in same pay period', 2, ShortName);
        FixedFormula('BA_ADJ_OB_' + ShortName, 'Sum of all posted and non included benefit amounts in previous pay period', 2, ShortName);
    end;

    procedure FixedFormula(FormulaKey: Code[100]; FormulaDescription: Text[250]; FormulaKeyType: Option Parameter,"Pay Component",Benefit,"Leave Type",Custom; ShortName: Code[20])
    begin
        if FormulaKey <> '' then begin
            if not PayrollFormula.GET(FormulaKey) then begin
                PayrollFormula.INIT;
                PayrollFormula."Formula Key" := FormulaKey;
                PayrollFormula."Formula description" := FormulaDescription;
                PayrollFormula."Formula Key Type" := FormulaKeyType;
                PayrollFormula."Short Name" := ShortName;
                PayrollFormula.INSERT;
            end;
        end;
    end;

    procedure DeleteBenefitFormulas(ShortName: Code[20]; FormulaKeyType: Option Parameter,"Pay Component",Benefit,"Leave Type",Custom)
    begin
        PayrollFormula.RESET;
        PayrollFormula.SETCURRENTKEY("Short Name");
        PayrollFormula.SETRANGE("Short Name", ShortName);
        PayrollFormula.SETRANGE("Formula Key Type", FormulaKeyType);
        PayrollFormula.DELETEALL;
    end;

    procedure SetFormulaForUnitCalc(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR("Unit Calc Formula");
        if NewWorkDescription = '' then
            exit;
        "Unit Calc Formula".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetFormulaForUnitCalc(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS("Unit Calc Formula");
        if not "Unit Calc Formula".HASVALUE then
            exit('');
        CALCFIELDS("Unit Calc Formula");
        "Unit Calc Formula".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SetFormulaForAmountCalc(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR("Amount Calc Formula");
        if NewWorkDescription = '' then
            exit;
        "Amount Calc Formula".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetFormulaForAmountCalc(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS("Amount Calc Formula");
        if not "Amount Calc Formula".HASVALUE then
            exit('');
        CALCFIELDS("Amount Calc Formula");
        "Amount Calc Formula".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    procedure SetFormulaForEncashmentFormula(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        CLEAR("Encashment Formula");
        if NewWorkDescription = '' then
            exit;
        "Encashment Formula".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetFormulaForEncashmentFormula(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS("Encashment Formula");
        if not "Encashment Formula".HASVALUE then
            exit('');
        CALCFIELDS("Encashment Formula");
        "Encashment Formula".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;
}