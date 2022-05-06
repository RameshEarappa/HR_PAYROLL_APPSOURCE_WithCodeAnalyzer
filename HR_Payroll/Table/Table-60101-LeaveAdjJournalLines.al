table 60101 "Leave Adj Journal Lines"
{
    Caption = 'Benefit Adjmt. Journal Lines';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Journal No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Employee Code" <> '' then begin
                    Employee.RESET;
                    Employee.GET("Employee Code");
                    "Employee Name" := Employee."First Name";
                end
                else
                    "Employee Name" := '';


                if "Employee Code" <> '' then begin
                    LeaveAdjJournal.GET("Journal No.");
                    EmplErngCodegrp.RESET;
                    EmplErngCodegrp.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                    EmplErngCodegrp.SETRANGE("Employee Code", "Employee Code");
                    EmplErngCodegrp.SETFILTER("Valid From", '<=%1', LeaveAdjJournal."Pay Period End");
                    EmplErngCodegrp.SETFILTER("Valid To", '>%1|%2', LeaveAdjJournal."Pay Period End", 0D);
                    if EmplErngCodegrp.FINDFIRST then
                        "Earning Code Group" := EmplErngCodegrp."Earning Code Group"
                    else
                        ERROR('There is no active Employee inthis period');
                end;
            end;
        }
        field(40; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50; "Earning Code"; Code[20])
        {
            TableRelation = "Payroll Earning Code Wrkr"."Earning Code" WHERE(Worker = FIELD("Employee Code"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Earning Code" <> '' then begin
                    PayrllErngCode.RESET;
                    PayrllErngCode.SETRANGE("Earning Code", "Earning Code");
                    if PayrllErngCode.FINDFIRST then
                        "Earning Code Description" := PayrllErngCode.Description;
                end
                else
                    "Earning Code Description" := '';
            end;
        }
        field(60; "Earning Code Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Voucher Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(80; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(90; "Financial Dimension"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(100; Benefit; Code[20])
        {
            TableRelation = "HCM Benefit Wrkr"."Benefit Id" WHERE(Worker = FIELD("Employee Code"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                HCMBenefitWrkr: Record "HCM Benefit Wrkr";
            begin
                if Benefit <> '' then begin
                    HCMBenefitWrkr.RESET;
                    HCMBenefitWrkr.SETRANGE(Worker, "Employee Code");
                    HCMBenefitWrkr.SETRANGE("Benefit Id", Benefit);
                    if HCMBenefitWrkr.FINDFIRST then
                        "Benefit Description" := HCMBenefitWrkr.Description;
                end
                else begin
                    "Benefit Description" := '';
                end;
            end;
        }
        field(110; "Benefit Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(111; "Calculation Units"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(112; "Leave Type ID"; Code[20])
        {
            TableRelation = "HCM Leave Types Wrkr"."Leave Type Id" WHERE(Worker = FIELD("Employee Code"),
                                                                          "Earning Code Group" = FIELD("Earning Code Group"),
                                                                          "IsSystem Defined" = CONST(false),
                                                                          "Accrual ID" = FILTER(<> ''));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                LeaveType.RESET;
                LeaveType.SETRANGE(Worker, "Employee Code");
                LeaveType.SETRANGE("Leave Type Id", "Leave Type ID");
                LeaveType.SETRANGE("Earning Code Group", "Earning Code Group");
                if LeaveType.FINDFIRST then begin
                    "Accrual ID" := LeaveType."Accrual ID";
                end;
            end;
        }
        field(113; "Accrual ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(114; "Earning Code Group"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(1; "Leave Request ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Journal No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        LeaveAdjJournalheaderRecL: Record "Leave Adj Journal header";
    begin
        LeaveAdjJournalheaderRecL.RESET;
        LeaveAdjJournalheaderRecL.SETRANGE("Journal No.", "Journal No.");
        if LeaveAdjJournalheaderRecL.FINDFIRST then begin
            if LeaveAdjJournalheaderRecL.Posted then
                if LeaveAdjJournalheaderRecL.Posted then
                    Error('Journal already posted, you cannot delete.');
        end;
    end;

    var
        Employee: Record Employee;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PayrllErngCode: Record "Payroll Earning Code";
        EmplErngCodegrp: Record "Employee Earning Code Groups";
        LeaveAdjJournal: Record "Leave Adj Journal header";
        LeaveType: Record "HCM Leave Types Wrkr";
}