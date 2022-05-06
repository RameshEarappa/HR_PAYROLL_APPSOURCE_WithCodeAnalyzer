table 60012 "HCM Benefit ErnGrp"
{
    DrillDownPageID = "HCM Benefit ErnGrp";
    LookupPageID = "HCM Benefit ErnGrp";
    DataClassification = CustomerContent;
    fields
    {
        field(10; "Benefit Id"; Code[20])
        {
            TableRelation = "HCM Benefit";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                HCMBenefit: Record "HCM Benefit";
                Instr: InStream;
                OutStr: OutStream;
            begin
                if "Benefit Id" = '' then
                    exit;

                HCMBenefit.RESET;
                HCMBenefit.GET("Benefit Id");
                HCMBenefit.CALCFIELDS("Unit Calc Formula");
                HCMBenefit.CALCFIELDS("Amount Calc Formula");
                HCMBenefit.CALCFIELDS("Encashment Formula");
                Rec.TRANSFERFIELDS(HCMBenefit);
            end;
        }
        field(11; "Earning Code Group"; Code[20])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
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
        key(Key1; "Earning Code Group", "Benefit Id")
        {
            Clustered = true;
        }
        key(Key2; "Benefit Id")
        {
        }
    }

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