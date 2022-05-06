table 60009 "Payroll Earning Code ErnGrp"
{
    Caption = 'Payroll Earning Code';
    DrillDownPageID = "Payroll Earning Code ErnGrps";
    LookupPageID = "Payroll Earning Code ErnGrps";
    DataClassification = CustomerContent;

    fields
    {
        field(5; "Earning Code Group"; Code[20])
        {
            TableRelation = "Earning Code Groups";
            DataClassification = CustomerContent;
        }
        field(10; "Earning Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll Earning Code" WHERE(Active = CONST(true));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PayrollEarningCode: Record "Payroll Earning Code";
            begin
                if "Earning Code" = '' then
                    PayrollEarningCode.RESET;
                PayrollEarningCode.GET("Earning Code");

                PayrollEarningCode.CALCFIELDS("Formula For Atttendance");
                Rec.TRANSFERFIELDS(PayrollEarningCode);
            end;
        }
        field(20; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Pay Component Type"; Option)
        {
            OptionCaption = ' ,Other,Basic,HRA,Cost of Living';
            OptionMembers = " ",Other,Basic,HRA,"Cost of Living";
            DataClassification = CustomerContent;
        }
        field(40; "Fin Accrual Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(45; "FF Adjustment Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Earning Code Calc Subtype"; Option)
        {
            OptionCaption = ' ,Fixed,Variable';
            OptionMembers = " ","Fixed",Variable;
            DataClassification = CustomerContent;
        }
        field(55; "Earning Code Calc Class"; Option)
        {
            OptionCaption = ' ,Payroll,NonPayroll';
            OptionMembers = " ",Payroll,NonPayroll;
            DataClassification = CustomerContent;
        }
        field(60; "Rounding Method"; Option)
        {
            OptionCaption = 'Normal,Downward,RoundUp';
            OptionMembers = Normal,Downward,RoundUp;
            DataClassification = CustomerContent;
        }
        field(65; "Decimal Rounding"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(70; "Minimum Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(75; "Maximum Value"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(80; IsSysComponent; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(85; Active; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(90; "Formula For Package"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(95; "Formula For Atttendance"; BLOB)
        {
            DataClassification = CustomerContent;
        }
        field(105; RefTableId; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(110; "Formula For Days"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(120; WPSType; Option)
        {
            OptionCaption = 'FixedIncome,VairableIncome';
            OptionMembers = FixedIncome,VairableIncome;
            DataClassification = CustomerContent;
        }
        field(130; "Arabic name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(140; "Short Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(141; "Unit Of Measure"; Option)
        {
            OptionCaption = ' ,Hours,Pieces,Each';
            OptionMembers = " ",Hours,Pieces,Each;
            DataClassification = CustomerContent;
        }
        field(142; "Earning Code Type"; Option)
        {
            OptionCaption = ' ,Pay Component,Benefit,Loan,Leave,Other';
            OptionMembers = " ","Pay Component",Benefit,Loan,Leave,Other;
            DataClassification = CustomerContent;
        }
        field(143; Type; Option)
        {
            OptionCaption = 'Monthly,Annual';
            OptionMembers = Monthly,Annual;
            DataClassification = CustomerContent;
        }
        field(144; "Package Amount"; Decimal)
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
        field(207; "Cost of Living Rate"; Decimal)
        {
            DecimalPlaces = 2 : 3;
            DataClassification = CustomerContent;
        }
        field(250; "Package Calc Type"; Option)
        {
            OptionCaption = 'Amount,Percentage';
            OptionMembers = Amount,Percentage;
            DataClassification = CustomerContent;
        }
        field(251; "Package Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(252; "Calc Accrual"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(253; "Calc. Payroll Adj."; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60055; "Final Settlement Component"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(60057; "Leave Encashment Enable"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Earning Code Group", "Earning Code")
        {
        }
        key(Key2; "Earning Code")
        {
            Clustered = true;
        }
    }

    procedure SetFormulaForAttendance(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin

        CLEAR("Formula For Atttendance");
        if NewWorkDescription = '' then
            exit;
        "Formula For Atttendance".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;


    procedure GetFormulaForAttendance(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CALCFIELDS("Formula For Atttendance");
        if not "Formula For Atttendance".HASVALUE then
            exit('');

        CALCFIELDS("Formula For Atttendance");
        "Formula For Atttendance".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;
}