table 60112 "Loan Type Setup"
{
    DrillDownPageID = "Loan Type Setup";
    LookupPageID = "Loan Type Setup";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Loan Code"; Code[50])
        {
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(2; "Loan Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Arabic Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Earning Code for Principal"; Code[20])
        {
            TableRelation = "Payroll Earning Code"."Earning Code";
            DataClassification = CustomerContent;
        }
        field(5; "Earning Code for Interest"; Code[20])
        {
            TableRelation = "Payroll Earning Code"."Earning Code";
            DataClassification = CustomerContent;
        }
        field(6; "Earning Code Selection"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "No. of times Earning Code"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Min Loan Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Min Loan Amount" > "Max Loan Amount" then
                    ERROR(Text50003, "Min Loan Amount", "Max Loan Amount");
            end;
        }
        field(9; "Max Loan Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Max Loan Amount" < "Min Loan Amount" then
                    ERROR(Text50002, "Max Loan Amount", "Min Loan Amount");
            end;
        }
        field(10; "Interest Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Allow Multiple Loans"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(12; Active; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Calculation Basis"; Option)
        {
            OptionCaption = ',Multiple Earning Code,Min/Max Amount';
            OptionMembers = ,"Multiple Earning Code","Min/Max Amount";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Calculation Basis" = "Calculation Basis"::"Min/Max Amount" then begin
                    "No. of times Earning Code" := 0;
                    MultipleEarningCodes.SETRANGE("Loan Code", "Loan Code");
                    if MultipleEarningCodes.FINDSET then
                        repeat
                            MultipleEarningCodes.DELETE;
                        until MultipleEarningCodes.NEXT = 0;
                end;
                if "Calculation Basis" = "Calculation Basis"::"Multiple Earning Code" then begin
                    "Min Loan Amount" := 0;
                    "Max Loan Amount" := 0;
                end;
            end;
        }
        field(14; "Payout Earning Code"; Code[20])
        {
            TableRelation = "Payroll Earning Code"."Earning Code";
            DataClassification = CustomerContent;
        }
        field(15; "Main Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            DataClassification = CustomerContent;
        }
        field(16; "Main Account No."; Code[20])
        {
            TableRelation = IF ("Main Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false),
                                                                                               "Direct Posting" = CONST(true))
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
        field(17; "Offset Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            DataClassification = CustomerContent;
        }
        field(18; "Offset Account No."; Code[20])
        {
            TableRelation = IF ("Offset Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                 Blocked = CONST(false),
                                                                                                 "Direct Posting" = CONST(true))
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
        field(19; "Loan Type Template"; Code[20])
        {
            Caption = 'Loan Type Journal Template';
            Enabled = true;
            TableRelation = "Gen. Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(20; "Loan Type Journal Batch"; Code[20])
        {
            Caption = 'Loan Type Journal Batch';
            Enabled = true;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loan Type Template"));
            DataClassification = CustomerContent;
        }
        field(21; "Number of Installments"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(22; "No. of Loans in a Year"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Vendor Posting"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "Loan Code")
        {
            Clustered = true;
        }
        key(Key2; "Loan Description")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Loan Code", "Loan Description")
        {
        }
    }
    trigger OnDelete()
    begin
        existLoanRequest;
    end;

    trigger OnInsert()
    begin
        Initialise;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LoanRequest: Record "Loan Request";
        Text50001: Label 'Loan Type Setup cannot be deleted since Loan Request exists for this Loan Type %1';
        MultipleEarningCodes: Record "Multiple Earning Codes";
        Text50002: Label 'Maximum Loan Amount %1 cannot be less than Minimum Loan Amount %2 !';
        Text50003: Label 'Minimum Loan Amount %1 cannot be greater than Maximum Loan Amount %2 !';
        AdvancePayrollSetupRec_G: Record "Advance Payroll Setup";

    local procedure Initialise()
    begin
        AdvancePayrollSetupRec_G.RESET;
        AdvancePayrollSetupRec_G.GET;
        "Loan Code" := NoSeriesManagement.GetNextNo(AdvancePayrollSetupRec_G."Loan Type", WORKDATE, true);
    end;

    local procedure existLoanRequest()
    var
        RecHcmLoanGccErngrp: Record "HCM Loan Table GCC ErnGrp";
    begin
        LoanRequest.SETRANGE("Loan Type", "Loan Code");
        if LoanRequest.FINDFIRST then
            ERROR(Text50001, "Loan Code");
        Clear(RecHcmLoanGccErngrp);
        RecHcmLoanGccErngrp.SetRange("Loan Code", Rec."Loan Code");
        if RecHcmLoanGccErngrp.FindFirst() then
            Error('You cannot delete this Loan Code as it is assigned to Earning Group Code %1', RecHcmLoanGccErngrp."Earning Code Group");
    end;
}