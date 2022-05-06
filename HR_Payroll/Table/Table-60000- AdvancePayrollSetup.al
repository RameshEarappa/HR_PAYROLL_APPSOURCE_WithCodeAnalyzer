table 60000 "Advance Payroll Setup"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Primart Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Job Nos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(10; "Position No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(11; "Earning Code Update No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(15; "Payroll Adj Journal No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(16; "Benefit Adj journal No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(17; "Payroll Statement No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(18; "Position No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(19; "Benefit No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(20; "Enable Alternate Calendar"; Boolean)
        {
            Caption = 'Alternate Calendar';
            DataClassification = CustomerContent;
        }
        field(21; "Employee Default Leave Type"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Enable Benefit Adj. Jnl WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Enable Payroll Adj. Jnl WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Enable Loan Request WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Enable Benefit claim req. WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Enable Leave Req. WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Enable Overtime Approval WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Enable Payroll Statement WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(29; "Enable Leave Resumption WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Enable Salary Advance WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Enable Full and Final Jnl WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Enable Document Req. WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Enable Payout Scheme WF"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(34; "Maintain Employment History"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(35; "Maintain Benefit History"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(36; "Maintain Loan History"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(37; "Maintain Leave History"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(38; "Maintain Earning History"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(39; "Leave Request Post"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Leave Resumption Post"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(41; "Post Leave Cancellation"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(42; "Post Salary Adv. on approval"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(43; "Salary Change Show Error"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(44; "Policy Change Show Error"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(45; Nationality; Text[50])
        {
            TableRelation = "Country/Region".Name;
            DataClassification = CustomerContent;
        }
        field(46; "Accrual Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(47; "Payroll Job Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(48; "Leave Request Nos."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(49; "OT Setup ID"; Code[20])
        {
            Caption = 'Over Time Setup Id';
            DataClassification = CustomerContent;
        }
        field(50; "Educational Claim Nos."; Code[20])
        {
            Description = 'Educational Allowance Module';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(51; "Journal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(52; "Journal Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
            DataClassification = CustomerContent;
        }
        field(53; "FS Journal ID"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(54; "Leave Adj No Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(55; "Loan Type"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(56; "Delegation No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(100; "Accrual Effective Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(101; "Work Visa Request No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(110; "Loan Request ID"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(111; "IQAMA Request No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(112; "Loan Adj. No Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(113; "Mission Order No. Series"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(114; "Par diem Eligiblity No. Series"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(115; "Par diem Journal Template Name"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(116; "Par diem Journal Batch Name"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Par diem Journal Template Name"));
            DataClassification = CustomerContent;
        }
        field(117; "Par diem Debit Account"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(118; "Par diem Credit Account"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(119; "Mo Expense Request No. Series"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(120; "MOEXPREQ Journal Template Name"; Code[20])
        {
            Caption = 'MO Expence Request Journal Templae Name';
            Description = 'PHASE - 2';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(121; "MOEXPREQ Journal Batch Name"; Code[20])
        {
            Caption = 'MO Expense Request Journal Batch Name';
            Description = 'PHASE - 2';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("MOEXPREQ Journal Template Name"));
            DataClassification = CustomerContent;
        }
        field(122; "MOEXPREQ Debit Account"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(123; "MOEXPREQ Credit Account"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(124; "Airport Access No. Series"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(125; "Leave Period Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(126; "Leave Period End Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TESTFIELD("Leave Period Start Date");
                if "Leave Period Start Date" > "Leave Period End Date" then
                    ERROR('Leave Period End Date cannot be Leave Period Date');
            end;
        }
        field(127; "Ticketing Tool No. Series"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(128; "Default Marital Status Spouse"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(129; "Medical Expenses Doc No."; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(130; "Medical Expenses Gen. Template"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(131; "Medical Expenses Gen. Batch"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Medical Expenses Gen. Template"));
            DataClassification = CustomerContent;
        }
        field(132; "Medical Expenses Debit Account"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(133; "Medical Expense Credit Account"; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                 Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
        field(134; "Medical Expenses Claim Comp."; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "Payroll Earning Code";
            DataClassification = CustomerContent;
        }
        field(135; "Performance Appraisal Ser. No."; Code[20])
        {
            Description = 'PHASE - 2';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(136; "Accrual Per day Formula"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(137; "Probation Months"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(138; "Azure Dll URL"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(139; "FnF Journal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(140; "FnF Journal Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
            DataClassification = CustomerContent;
        }
        field(141; "Leave Encashment Dr A/C Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            DataClassification = CustomerContent;
        }
        field(142; "Leave Encashment Debit A/C"; Code[20])
        {
            TableRelation = IF ("Leave Encashment Dr A/C Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF ("Leave Encashment Dr A/C Type" = CONST(Customer)) Customer
            ELSE
            IF ("Leave Encashment Dr A/C Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Leave Encashment Dr A/C Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Leave Encashment Dr A/C Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Leave Encashment Dr A/C Type" = CONST("IC Partner")) "IC Partner";
            DataClassification = CustomerContent;
        }

        field(143; "Leave Encashment Cr A/C Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
            DataClassification = CustomerContent;
        }
        field(144; "Leave Encashment Credit A/C"; Code[20])
        {
            TableRelation = IF ("Leave Encashment Cr A/C Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF ("Leave Encashment Cr A/C Type" = CONST(Customer)) Customer
            ELSE
            IF ("Leave Encashment Cr A/C Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Leave Encashment Cr A/C Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Leave Encashment Cr A/C Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Leave Encashment Cr A/C Type" = CONST("IC Partner")) "IC Partner";
            DataClassification = CustomerContent;
        }

        field(145; "Auto Post Leave Request"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(146; "Auto Post Cancel Leave Request"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(147; "Auto Post Resumpt. Leave Req."; Boolean)
        {
            Caption = 'Auto Post Resumption Leave Request';
            DataClassification = CustomerContent;
        }
        field(60150; "Positng Type"; Option)
        {
            OptionMembers = Individual,Consolidated;
            DataClassification = CustomerContent;
        }
        field(60151; "Consolidated Dimension"; Code[20])
        {
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        }
        field(60152; "F and F Vendor Posting"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primart Key")
        {
            Clustered = true;
        }
    }
}

