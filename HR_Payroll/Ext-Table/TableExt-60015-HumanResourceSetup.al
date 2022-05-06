tableextension 60015 HumanResourceSetup extends "Human Resources Setup"
{
    fields
    {
        field(60000; "Dependent Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60001; "Employee Creation Request Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60002; "Employee Identification Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60003; "Document Request ID"; Code[20])
        {
            Caption = 'Document Request ID';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60004; "Document format ID"; Code[20])
        {
            Caption = 'Document format ID';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60005; "Overtime Benefit Claim No"; Code[20])
        {
            Caption = 'Overtime Benefit Claim No';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60006; "Overtime Request ID No."; Code[20])
        {
            Caption = 'Overtime Request ID No.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60007; "OT Expense Journal Template"; Code[20])
        {
            Caption = 'OT Expense Journal Template';
            TableRelation = "Gen. Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(60008; "OT Expense Journal Batch"; Code[20])
        {
            Caption = 'OT Expense Journal Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("OT Expense Journal Template"));
            DataClassification = CustomerContent;
        }
        field(60009; "OT Expense Debit Account"; Code[20])
        {
            Caption = 'OT Expense Debit Account';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(60010; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60011; "Education Allowance Debit"; Code[20])
        {
            Caption = 'Education Allowance Debit';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(60012; "Education Allowance Credit"; Code[20])
        {
            Caption = 'Education Allowance Credit';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(60013; "Edu. Allow. Payroll Component"; Code[20])
        {
            Caption = 'Edu. Allow. Payroll Component';
            DataClassification = CustomerContent;
        }
        field(60014; "Edu. Book Allowance Debit"; Code[20])
        {
            Caption = 'Edu. Book Allowance Debit';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(60015; "Edu. Book Allowance Credit"; Code[20])
        {
            Caption = 'Edu. Book Allowance Credit';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(60016; "Edu Book Payroll Component"; Code[20])
        {
            Caption = 'Edu Book Payroll Component';
            DataClassification = CustomerContent;
        }
        field(60017; "Special Need Allowance Debit"; Code[20])
        {
            Caption = 'Special Need Allowance Debit';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(60018; "Special Need Allowance Credit"; Code[20])
        {
            Caption = 'Special Need Allowance Credit';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(60019; "Special Need Payroll Component"; Code[20])
        {
            Caption = 'Special Need Payroll Component';
            DataClassification = CustomerContent;
        }
        field(60020; "Edu. Claim Journal Template"; Code[20])
        {
            Caption = 'Edu. Claim Journal Template';
            TableRelation = "Gen. Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(60021; "Edu. Claim Journal Batch"; Code[20])
        {
            Caption = 'Edu. Claim Journal Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Edu. Claim Journal Template"));
            DataClassification = CustomerContent;
        }
        field(60022; "Sector ID"; Code[20])
        {
            Caption = 'Sector ID';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60023; "Employee Payout Scheme ID"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60024; "Short Leave Request Id"; Code[20])
        {
            Caption = 'Short Leave Request Id';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60025; "Permissible Short Leave Hrs"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60026; "User Registration"; Code[20])
        {
            Caption = 'User Registration';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60027; "Time Attande-Reception"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60028; "Employee Dimension Code"; Code[20])
        {
            TableRelation = Dimension.Code;
            DataClassification = CustomerContent;
        }
        field(60029; "Driving License Request ID"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60030; "Car Registration ID"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(60031; "Dependent Request"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }
}
