table 60036 "Benefit Adjmt. Journal header"
{
    Caption = 'Benefit Adjmt. Journal header';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Journal No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                AdvPayrollSetup.GET;
                if "Journal No." = '' then
                    "Journal No." := NoSeriesManagement.GetNextNo(AdvPayrollSetup."Benefit Adj journal No. Series", TODAY, true);
            end;
        }
        field(20; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Pay Cycle"; Code[20])
        {
            TableRelation = "Pay Cycles"."Pay Cycle";
            DataClassification = CustomerContent;
        }
        field(40; "Pay Period Start"; Date)
        {
            TableRelation = "Pay Periods"."Period Start Date" WHERE("Pay Cycle" = FIELD("Pay Cycle"));
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                PayPeriods.FILTERGROUP(2);
                PayPeriods.RESET;
                PayPeriods.SETRANGE("Pay Cycle", Rec."Pay Cycle");
                PayPeriods.FILTERGROUP(0);

                if PAGE.RUNMODAL(60071, PayPeriods) = ACTION::LookupOK then begin
                    "Pay Period Start" := PayPeriods."Period Start Date";
                    "Pay Period End" := PayPeriods."Period End Date";
                end;
            end;
        }
        field(41; "Pay Period End"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Defaualt Employee"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(60; "Default Benefit"; Code[20])
        {
            TableRelation = "HCM Benefit Wrkr"."Benefit Id" WHERE(Worker = FIELD("Defaualt Employee"));
            DataClassification = CustomerContent;
        }
        field(70; "Create By"; Code[50])
        {
            TableRelation = User;
            DataClassification = CustomerContent;
        }
        field(80; "Created DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(90; "Work Flow Status"; Option)
        {
            OptionCaption = 'Created,Not Created';
            OptionMembers = Created,"Not Created";
            DataClassification = CustomerContent;
        }
        field(100; Posted; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(105; "Posted By"; Code[50])
        {
            TableRelation = User;
            DataClassification = CustomerContent;
        }
        field(110; "Posted DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(115; "Financial Dimension"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(116; "Posted Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Journal No.")
        {
            Clustered = true;
        }
        key(Key2; "Pay Period Start", "Pay Period End", Posted)
        {
        }
    }

    trigger OnDelete()
    begin
        BenefitAdjmtJournalLines.RESET;
        BenefitAdjmtJournalLines.SETRANGE("Journal No.", Rec."Journal No.");
        if BenefitAdjmtJournalLines.FINDFIRST then
            ERROR('Payroll Adj. Lines Exist');

        if Posted then
            ERROR('You cannot Delete confirmed journals');
    end;

    trigger OnInsert()
    begin
        AdvPayrollSetup.GET;
        if "Journal No." = '' then
            "Journal No." := NoSeriesManagement.GetNextNo(AdvPayrollSetup."Benefit Adj journal No. Series", TODAY, true);

        "Create By" := USERID;
        "Created DateTime" := CREATEDATETIME(TODAY, TIME);
    end;

    trigger OnModify()
    begin
        if Posted then
            ERROR('You cannot Modify confirmed journals');
    end;

    var
        PayPeriods: Record "Pay Periods";
        AdvPayrollSetup: Record "Advance Payroll Setup";
        PayrollSetupGet: Boolean;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        BenefitAdjmtJournalLines: Record "Benefit Adjmt. Journal Lines";

    local procedure GetPayrollSetup()
    begin
        if not PayrollSetupGet then begin
            AdvPayrollSetup.GET;
            AdvPayrollSetup.TESTFIELD("Payroll Adj Journal No. Series");
            PayrollSetupGet := true;
        end;
    end;
}