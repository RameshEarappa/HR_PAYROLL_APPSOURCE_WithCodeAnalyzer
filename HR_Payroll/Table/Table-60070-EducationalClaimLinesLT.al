table 60070 "Educational Claim Lines LT"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Claim ID"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(21; "Allowance Type"; Option)
        {
            OptionCaption = 'Educational Allowance,Educational Book Allowance,Special Need Allowance';
            OptionMembers = "Educational Allowance","Educational Book Allowance","Special Need Allowance";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Allowance Type" <> xRec."Allowance Type" then begin
                    CLEAR("Dependent ID");
                    CLEAR("Dependent Name");
                    CLEAR("Fee Description");
                    CLEAR("Level of Education");
                    CLEAR("Institution Name");
                    CLEAR(Grade);
                    CLEAR("Period End Date");
                    CLEAR("Period Start Date");
                    CLEAR("Eligible Amount");
                    CLEAR("Utilized Amount");
                    CLEAR("Balance Amount");
                    CLEAR("Current Claim Amount");
                end;
            end;
        }
        field(22; "Dependent ID"; Code[20])
        {
            TableRelation = IF ("Allowance Type" = CONST("Educational Book Allowance")) "Employee Dependents Master" WHERE("Employee ID" = FIELD("Employee No."),
                                                                                                                          "Child with Special needs" = CONST(false),
                                                                                                                          "Full Time Student" = CONST(true),
                                                                                                                          Relationship = CONST(Child),
                                                                                                                          Status = CONST(Active))
            ELSE
            IF ("Allowance Type" = CONST("Educational Allowance")) "Employee Dependents Master" WHERE("Employee ID" = FIELD("Employee No."),
                                                                                                                                                                                                                        "Child with Special needs" = CONST(false),
                                                                                                                                                                                                                        "Full Time Student" = CONST(true),
                                                                                                                                                                                                                        Relationship = CONST(Child),
                                                                                                                                                                                                                        Status = CONST(Active))
            ELSE
            IF ("Allowance Type" = CONST("Special Need Allowance")) "Employee Dependents Master" WHERE("Employee ID" = FIELD("Employee No."),
                                                                                                                                                                                                                                                                                                                       "Child with Special needs" = CONST(true),
                                                                                                                                                                                                                                                                                                                       "Full Time Student" = CONST(true),
                                                                                                                                                                                                                                                                                                                       Relationship = CONST(Child),
                                                                                                                                                                                                                                                                                                                       Status = CONST(Active));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (xRec."Dependent ID" <> "Dependent ID") or ("Dependent ID" = '') then begin
                    CLEAR("Dependent Name");
                    CLEAR("Fee Description");
                    CLEAR("Level of Education");
                    CLEAR("Institution Name");
                    CLEAR(Grade);
                    CLEAR("Period End Date");
                    CLEAR("Period Start Date");
                    CLEAR("Eligible Amount");
                    CLEAR("Utilized Amount");
                    CLEAR("Balance Amount");
                    CLEAR("Current Claim Amount");
                end;


                EducationalClaimHeaderLTRecG.RESET;
                EducationalClaimHeaderLTRecG.GET("Claim ID", "Employee No.");
                "Claim Date" := EducationalClaimHeaderLTRecG."Claim Date";

                EmpDependentListRecG.RESET;
                if EmpDependentListRecG.GET("Dependent ID", "Employee No.") then begin
                    "Dependent Name" := EmpDependentListRecG."Dependent First Name";
                    "Level of Education" := EmpDependentListRecG."Child Educational Level";
                    "Utilized Amount" := GetUtilityAmount();

                end;
                CheckDependenceAlreadyExist_LT();
                EducationalBookAllowanceEligibleAmount_LT();

                if ("Eligible Amount" - GetUtilityAmount()) > 0 then
                    "Balance Amount" := "Eligible Amount" - GetUtilityAmount()
                else
                    "Balance Amount" := 0;

                DependMasterRec.RESET;
                DependMasterRec.SETRANGE("No.", "Dependent ID");
                if DependMasterRec.FINDFIRST then;

                if "Allowance Type" = "Allowance Type"::"Educational Allowance" then begin
                    EducationalClaimHeaderLTRecG.RESET;
                    EducationalClaimHeaderLTRecG.GET("Claim ID", "Employee No.");

                    EduAlloRec.RESET;
                    EduAlloRec.SETRANGE("Earnings Code Group", EducationalClaimHeaderLTRecG."Earning Code Group");
                    if EduAlloRec.FINDFIRST then begin
                        DepAge := (TODAY - DependMasterRec."Date of Birth");
                        EVALUATE(DepAge, FORMAT(ROUND(DepAge / 365.27)));

                        if DepAge < EduAlloRec."Edu. Allow. Min Age" then
                            ERROR(AgeLimErr, EduAlloRec."Edu. Allow. Min Age", EduAlloRec."Edu. Allow. Max Age")
                        else
                            if DepAge > EduAlloRec."Edu. Allow. Max Age" then
                                ERROR(AgeLimErr, EduAlloRec."Edu. Allow. Min Age", EduAlloRec."Edu. Allow. Max Age");
                    end;
                end;
                if EducationalClaimHeaderLT2RecG.GET("Claim ID", "Employee No.") then
                    "Academic year" := EducationalClaimHeaderLT2RecG."Academic year";
            end;
        }
        field(23; "Dependent Name"; Text[90])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(24; "Claim Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Fee Description"; Text[90])
        {
            DataClassification = CustomerContent;
        }
        field(26; "Level of Education"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Elemantary School, Secondary Level, University Level';
            OptionMembers = " ","Elemantary School","Secondary Level","University Level";
            DataClassification = CustomerContent;
        }
        field(27; "Institution Name"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(28; Grade; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(29; "Period Start Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                EducationalClaimHeaderLTRecG.RESET;
                EducationalClaimHeaderLTRecG.GET("Claim ID", "Employee No.");
                AcademicPeriodRecG.RESET;
                AcademicPeriodRecG.SETRANGE(Closed, false);
                if AcademicPeriodRecG.FINDFIRST then
                    if ("Period Start Date" < AcademicPeriodRecG."Start Date") or ("Period Start Date" > AcademicPeriodRecG."End Date") then
                        ERROR('Academic Start date should be between to %1  from %2', FORMAT(AcademicPeriodRecG."Start Date", 0, '<Month,2>/<Day,2>/<Year4>'), FORMAT(AcademicPeriodRecG."End Date", 0, '<Month,2>/<Day,2>/<Year4>'));
            end;
        }
        field(30; "Period End Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                EducationalClaimHeaderLTRecG.RESET;
                EducationalClaimHeaderLTRecG.GET("Claim ID", "Employee No.");
                AcademicPeriodRecG.RESET;
                AcademicPeriodRecG.SETRANGE(Closed, false);
                if AcademicPeriodRecG.FINDFIRST then
                    if ("Period End Date" > AcademicPeriodRecG."End Date") or ("Period End Date" <= "Period Start Date") then
                        ERROR('Academic Start date should be between to %1  from %2', FORMAT(AcademicPeriodRecG."Start Date", 0, '<Month,2>/<Day,2>/<Year4>'), FORMAT(AcademicPeriodRecG."End Date", 0, '<Month,2>/<Day,2>/<Year4>'));
            end;
        }
        field(31; "Eligible Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Utilized Amount"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(33; "Balance Amount"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(34; "Current Claim Amount"; Decimal)
        {
            Caption = 'Current Claim Amount (USD)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Balance Amount" <> 0 then
                    if "Current Claim Amount" > "Balance Amount" then
                        ERROR('Claim amount exceeds the eligible / balance amount %1', "Balance Amount");

                if "Eligible Amount" = "Utilized Amount" then
                    if "Current Claim Amount" > "Balance Amount" then begin
                        FindDubplicateClaim;
                    end;

                if "Current Claim Amount" > "Eligible Amount" then
                    ERROR('Claim amount exceeds the eligible / balance amount %1', "Eligible Amount");

                if (Rec."Current Claim Amount" <> xRec."Current Claim Amount") and ("Current Claim Amount" <> 0) then begin
                    "Selected Claim Amount" := 0;
                    "Selected Currency" := '';
                end;
            end;
        }
        field(35; "Academic year"; Code[20])
        {
            TableRelation = "Academic Period LT" WHERE(Closed = CONST(false));
            DataClassification = CustomerContent;
        }
        field(36; "Selected Currency"; Code[20])
        {
            Caption = 'Claim Currency';
            Description = 'LT_Claim';
            TableRelation = Currency;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Selected Currency" <> '' then begin
                    if ("Current Claim Amount" <> 0) then begin
                        GeneralLedgerSetup.GET;
                        GeneralLedgerSetup.TESTFIELD("LCY Code");
                        EducationalClaimHeader.GET(Rec."Claim ID", Rec."Employee No.");
                        EarningCodeGroups.RESET;
                        EarningCodeGroups.SETRANGE("Earning Code Group", EducationalClaimHeader."Earning Code Group");
                        EarningCodeGroups.FINDFIRST;
                        Currency.GET("Selected Currency");
                        CurrencyExchangeRate.GetLastestExchangeRate(Currency.Code, ExchangeRateDate, ExchangeRateAmt);
                        if "Selected Currency" <> EarningCodeGroups.Currency then
                            "Current Claim Amount" := "Selected Claim Amount" * ExchangeRateAmt
                        else
                            "Current Claim Amount" := "Selected Claim Amount";

                        if "Current Claim Amount" > "Eligible Amount" then
                            ERROR('Claim amount exceeds the eligible / balance amount %1', "Eligible Amount");

                        if "Balance Amount" <> 0 then
                            if "Current Claim Amount" > "Balance Amount" then
                                ERROR('Claim amount exceeds the eligible / balance amount %1', "Balance Amount");
                    end;
                end;
            end;
        }
        field(37; "Selected Claim Amount"; Decimal)
        {
            Caption = 'Claim Amount';
            Description = 'LT_Claim';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Selected Claim Amount" <> 0 then begin
                    TESTFIELD("Selected Currency");
                    GeneralLedgerSetup.GET;
                    GeneralLedgerSetup.TESTFIELD("LCY Code");
                    EducationalClaimHeader.GET(Rec."Claim ID", Rec."Employee No.");
                    EarningCodeGroups.RESET;
                    EarningCodeGroups.SETRANGE("Earning Code Group", EducationalClaimHeader."Earning Code Group");
                    EarningCodeGroups.FINDFIRST;
                    Currency.GET("Selected Currency");
                    CurrencyExchangeRate.GetLastestExchangeRate(Currency.Code, ExchangeRateDate, ExchangeRateAmt);
                    if "Selected Currency" <> EarningCodeGroups.Currency then
                        "Current Claim Amount" := "Selected Claim Amount" * ExchangeRateAmt
                    else
                        "Current Claim Amount" := "Selected Claim Amount";

                    if "Current Claim Amount" > "Eligible Amount" then
                        ERROR('Claim amount exceeds the eligible / balance amount %1', "Eligible Amount");

                    if "Balance Amount" <> 0 then
                        if "Current Claim Amount" > "Balance Amount" then
                            ERROR('Claim amount exceeds the eligible / balance amount %1', "Balance Amount");
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Claim ID", "Employee No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Dependent ID")
        {
        }
    }

    trigger OnDelete()
    var
        EducationalClaimHeaderLT: Record "Educational Claim Header LT";
    begin
        EducationalClaimHeaderLT.RESET;
        EducationalClaimHeaderLT.GET("Claim ID", "Employee No.");
        if EducationalClaimHeaderLT."Approval Status" <> EducationalClaimHeaderLT."Approval Status"::Open then
            ERROR('Approval Status Should be Open to delete Educational Claim.');
    end;

    trigger OnInsert()
    begin
        EducationalClaimHeaderLTRecG.RESET;
        EducationalClaimHeaderLTRecG.GET("Claim ID", "Employee No.");
        if (EducationalClaimHeaderLTRecG."Approval Status" <> EducationalClaimHeaderLTRecG."Approval Status"::Open) then
            ERROR('Approval Status must be Open.')
        else
            if EducationalClaimHeaderLTRecG.Posted then
                ERROR('Posted must be Unchecked');
    end;

    var
        EmpDependentListRecG: Record "Employee Dependents Master";
        EducationalClaimHeaderLTRecG: Record "Educational Claim Header LT";
        EducationalClaimLinesLTRecG: Record "Educational Claim Lines LT";
        EducationalAllowanceLTRecG: Record "Educational Allowance LT";
        AcademicPeriodRecG: Record "Academic Period LT";
        DepAgeG: Integer;
        TotalUtilityAmountG: Decimal;
        EduAlloRec: Record "Educational Allowance LT";
        DependMasterRec: Record "Employee Dependents Master";
        DepAge: Decimal;
        DepAgedec: Decimal;
        AgeLimErr: Label 'Mismatch in age criteria. Age limit is between %1 to %2';
        EduAllowance_CountG: Integer;
        BookAllowance_CountG: Integer;
        FalseConditionValG: Integer;
        EducationalClaimHeaderLT2RecG: Record "Educational Claim Header LT";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        GeneralLedgerSetup: Record "General Ledger Setup";
        EarningCodeGroups: Record "Earning Code Groups";
        EducationalClaimHeader: Record "Educational Claim Header LT";
        ExchangeRateAmt: Decimal;
        ExchangeRateDate: Date;

    local procedure GetMaxDependentCount_LT()
    var
        EarningCodeGroupsRec: Record "Earning Code Groups";
        EmpRecL: Record Employee;
        EducationalAllowanceLT: Record "Educational Allowance LT";
        CountofChil: Integer;
        REC2: Record "Educational Claim Lines LT";
        DepID: Code[20];
        NoKid: Integer;
    begin
        EducationalClaimHeaderLTRecG.RESET;
        EducationalClaimHeaderLTRecG.GET("Claim ID", "Employee No.");
        EmpRecL.GET("Employee No.");
        EducationalAllowanceLT.RESET;
        EducationalAllowanceLT.SETRANGE("Earnings Code Group", EmpRecL."Earning Code Group");
        EducationalAllowanceLT.SETRANGE("Grade Category", EmpRecL."Grade Category");
        if EducationalAllowanceLT.FINDFIRST then
            CountofChil := EducationalAllowanceLT."Count of children eligible";

        REC2.RESET;
        REC2.SETRANGE("Claim ID", "Claim ID");
        REC2.SETCURRENTKEY("Dependent ID");
        if REC2.FINDSET then begin
            repeat
                if (DepID <> REC2."Dependent ID") then
                    NoKid += 1;
                DepID := REC2."Dependent ID";
            until REC2.NEXT = 0;
        end;

        if NoKid > CountofChil then
            ERROR('You have only %1 Dependent of Allowance.', CountofChil);
    end;

    local procedure CheckDependenceAlreadyExist_LT()
    begin
        EducationalClaimLinesLTRecG.RESET;
        EducationalClaimLinesLTRecG.SETRANGE("Claim ID", "Claim ID");
        EducationalClaimLinesLTRecG.SETRANGE("Employee No.", "Employee No.");
        EducationalClaimLinesLTRecG.SETRANGE("Dependent ID", "Dependent ID");
        EducationalClaimLinesLTRecG.SETRANGE("Allowance Type", "Allowance Type");
        if EducationalClaimLinesLTRecG.FINDFIRST then
            ERROR('Dependent ID %1 Already Exists', "Dependent ID");
    end;

    local procedure CheckDependentAgeLimit_LT()
    begin
        CLEAR(DepAgeG);
        EducationalClaimHeaderLTRecG.RESET;
        EducationalClaimHeaderLTRecG.GET("Claim ID", "Employee No.");
        EducationalAllowanceLTRecG.RESET;
        EducationalAllowanceLTRecG.SETRANGE("Grade Category", EducationalClaimHeaderLTRecG."Grade Category");
        EducationalAllowanceLTRecG.SETRANGE("Earnings Code Group", EducationalClaimHeaderLTRecG."Earning Code Group");
        if EducationalAllowanceLTRecG.FINDFIRST then begin
            EmpDependentListRecG.RESET;
            if EmpDependentListRecG.GET("Dependent ID", "Employee No.") then begin
                DepAgeG := TODAY - EmpDependentListRecG."Date of Birth";
                if (DepAgeG < EducationalAllowanceLTRecG."Edu. Allow. Min Age") and (DepAgeG > EducationalAllowanceLTRecG."Edu. Allow. Max Age") then
                    ERROR('Age Limit is not matcing');
            end;
        end;
    end;

    local procedure EducationalBookAllowanceEligibleAmount_LT()
    begin
        EducationalAllowanceLTRecG.RESET;
        EducationalAllowanceLTRecG.SETRANGE("Grade Category", EducationalClaimHeaderLTRecG."Grade Category");
        EducationalAllowanceLTRecG.SETRANGE("Earnings Code Group", EducationalClaimHeaderLTRecG."Earning Code Group");
        if EducationalAllowanceLTRecG.FINDFIRST then begin
            EmpDependentListRecG.RESET;
            if EmpDependentListRecG.GET("Dependent ID", "Employee No.") then begin
                if "Allowance Type" = "Allowance Type"::"Educational Book Allowance" then
                    if "Level of Education" = "Level of Education"::"Elemantary School" then
                        "Eligible Amount" := EducationalAllowanceLTRecG."Book Allow. Elemantary School"
                    else
                        if "Level of Education" = "Level of Education"::"Secondary Level" then
                            "Eligible Amount" := EducationalAllowanceLTRecG."Book Allow. Secondary Level"
                        else
                            if "Level of Education" = "Level of Education"::"University Level" then
                                "Eligible Amount" := EducationalAllowanceLTRecG."Book Allow. University Level";
                if ("Allowance Type" = "Allowance Type"::"Special Need Allowance") and (EmpDependentListRecG."Child with Special needs") then
                    "Eligible Amount" := EducationalAllowanceLTRecG."Special Eligible Amount"
                else
                    if "Allowance Type" = "Allowance Type"::"Educational Allowance" then
                        "Eligible Amount" := EducationalAllowanceLTRecG."Edu. Allow. Eligible Amount";
            end;
        end;
    end;

    procedure GetUtilityAmount(): Decimal
    var
        EducationalClaimLinesRecL: Record "Educational Claim Lines LT";
        EducationalClaimHeaderRecL: Record "Educational Claim Header LT";
    begin
        CLEAR(TotalUtilityAmountG);
        EducationalClaimHeaderLTRecG.RESET;
        EducationalClaimHeaderLTRecG.GET("Claim ID", "Employee No.");

        EducationalClaimHeaderRecL.RESET;
        EducationalClaimHeaderRecL.SETRANGE("Employee No.", "Employee No.");
        EducationalClaimHeaderRecL.SETRANGE("Grade Category", EducationalClaimHeaderLTRecG."Grade Category");
        EducationalClaimHeaderRecL.SETRANGE("Earning Code Group", EducationalClaimHeaderLTRecG."Earning Code Group");
        EducationalClaimHeaderRecL.SETRANGE("Academic year", EducationalClaimHeaderLTRecG."Academic year");
        if EducationalClaimHeaderRecL.FINDSET then begin
            repeat
                EducationalClaimLinesRecL.RESET;
                EducationalClaimLinesRecL.SETRANGE("Claim ID", EducationalClaimHeaderRecL."Claim ID");
                EducationalClaimLinesRecL.SETRANGE("Employee No.", EducationalClaimHeaderRecL."Employee No.");
                EducationalClaimLinesRecL.SETRANGE("Allowance Type", "Allowance Type");
                EducationalClaimLinesRecL.SETRANGE("Dependent ID", "Dependent ID");
                EducationalClaimLinesRecL.SETRANGE("Level of Education", "Level of Education");
                if EducationalClaimLinesRecL.FINDFIRST then
                    TotalUtilityAmountG += EducationalClaimLinesRecL."Current Claim Amount";

            until EducationalClaimHeaderRecL.NEXT = 0;
        end;
        exit(TotalUtilityAmountG);
    end;

    procedure FindDubplicateClaim()
    var
        EducationalClaimHeaderLT: Record "Educational Claim Header LT";
        EducationalClaimLinesLT: Record "Educational Claim Lines LT";
        EducationalClaimHeaderLT2: Record "Educational Claim Header LT";
        LineDocpeCodeL: Code[250];
        Ln: Integer;
        LineDocpeTxtL: Text;
    begin
        EducationalClaimHeaderLT.RESET;
        EducationalClaimHeaderLT.SETCURRENTKEY("Employee No.", "Claim ID");
        EducationalClaimHeaderLT.SETRANGE("Approval Status", EducationalClaimHeaderLT."Approval Status"::Open);
        EducationalClaimHeaderLT.SETRANGE("Employee No.", "Employee No.");
        if EducationalClaimHeaderLT.FINDSET then begin
            repeat
                EducationalClaimLinesLT.RESET;
                EducationalClaimLinesLT.SETRANGE("Claim ID", EducationalClaimHeaderLT."Claim ID");
                EducationalClaimLinesLT.SETRANGE("Employee No.", EducationalClaimHeaderLT."Employee No.");
                EducationalClaimLinesLT.SETRANGE("Allowance Type", "Allowance Type");
                EducationalClaimLinesLT.SETRANGE("Dependent ID", "Dependent ID");
                if EducationalClaimLinesLT.FINDSET then
                    repeat
                        LineDocpeCodeL += EducationalClaimLinesLT."Claim ID" + '|';
                    until EducationalClaimLinesLT.NEXT = 0;
            until EducationalClaimHeaderLT.NEXT = 0;
        end;
        Ln := STRLEN(LineDocpeCodeL);
        if Ln > 0 then
            LineDocpeTxtL := DELSTR(LineDocpeCodeL, Ln, Ln);

        EducationalClaimHeaderLT2.RESET;
        EducationalClaimHeaderLT2.SETCURRENTKEY("Claim ID");
        EducationalClaimHeaderLT2.SETFILTER("Claim ID", LineDocpeTxtL);
        if EducationalClaimHeaderLT2.FINDSET then begin
            ERROR('Your Balance Amount is Zero. Other Claims are available to approve.');
        end;
    end;

    procedure CheckDependentCountForEducationalAllowance2l_LT()
    var
        EducationalAllowanceLTRecL: Record "Educational Allowance LT";
        EmployeeEarningCodeGroupsRecL: Record "Employee Earning Code Groups";
        EducationalClaimHeaderLT: Record "Educational Claim Header LT";
        EducationalClaimLinesLT: Record "Educational Claim Lines LT";
        EducationalClaimHeaderLT2: Record "Educational Claim Header LT";
    begin
        EducationalClaimHeaderLT.RESET;
        EducationalClaimHeaderLT.SETRANGE("Claim ID", "Claim ID");
        EducationalClaimHeaderLT.SETRANGE("Employee No.", "Employee No.");
        if EducationalClaimHeaderLT.FINDFIRST then begin
            EducationalClaimHeaderLT2.RESET;
            EducationalClaimHeaderLT2.SETRANGE("Employee No.", EducationalClaimHeaderLT."Employee No.");
            EducationalClaimHeaderLT2.SETRANGE("Academic year", EducationalClaimHeaderLT."Academic year");
            if EducationalClaimHeaderLT2.FINDSET then begin
                repeat
                    EducationalClaimLinesLT.RESET;
                    EducationalClaimLinesLT.SETRANGE("Claim ID", EducationalClaimHeaderLT2."Claim ID");
                    EducationalClaimLinesLT.SETRANGE("Employee No.", EducationalClaimHeaderLT2."Employee No.");
                    EducationalClaimLinesLT.SETRANGE("Allowance Type", EducationalClaimLinesLT."Allowance Type"::"Educational Allowance");
                    if EducationalClaimLinesLT.FINDSET then begin
                        repeat
                            EduAllowance_CountG += 1;
                        until EducationalClaimLinesLT.NEXT = 0;
                    end else begin
                        FalseConditionValG += 1;
                        MESSAGE('inside %1', FalseConditionValG);
                    end;
                until EducationalClaimHeaderLT2.NEXT = 0;
            end;
        end;
        MESSAGE('EduAllowance_CountG %1  Uniq_CountG %2 ', EduAllowance_CountG, FalseConditionValG);
        if FalseConditionValG > GetAllowanceMaxCount2_LT then
            ERROR('Cross Maximum limit of depented allowance');
    end;

    procedure GetAllowanceMaxCount2_LT(): Integer
    var
        EducationalAllowanceLTRecL: Record "Educational Allowance LT";
        EmployeeEarningCodeGroupsRecL: Record "Employee Earning Code Groups";
        EducationalClaimHeaderLT: Record "Educational Claim Header LT";
        EducationalClaimLinesLT: Record "Educational Claim Lines LT";
    begin
        EducationalClaimHeaderLT.RESET;
        EducationalClaimHeaderLT.SETRANGE("Claim ID", "Claim ID");
        EducationalClaimHeaderLT.SETRANGE("Employee No.", "Employee No.");
        if EducationalClaimHeaderLT.FINDFIRST then begin
            EmployeeEarningCodeGroupsRecL.RESET;
            EmployeeEarningCodeGroupsRecL.SETRANGE("Employee Code", EducationalClaimHeaderLT."Employee No.");
            EmployeeEarningCodeGroupsRecL.SETFILTER("Valid To", '%1', 0D);
            if EmployeeEarningCodeGroupsRecL.FINDFIRST then begin
                EducationalAllowanceLTRecL.RESET;
                EducationalAllowanceLTRecL.SETRANGE("Grade Category", EmployeeEarningCodeGroupsRecL."Grade Category");
                EducationalAllowanceLTRecL.SETRANGE("Earnings Code Group", EmployeeEarningCodeGroupsRecL."Earning Code Group");
                if EducationalAllowanceLTRecL.FINDFIRST then
                    exit(EducationalAllowanceLTRecL."Count of children eligible");
            end;
        end;
    end;

    procedure CheckDependentCountForBooklAllowance2l_LT()
    var
        EducationalAllowanceLTRecL: Record "Educational Allowance LT";
        EmployeeEarningCodeGroupsRecL: Record "Employee Earning Code Groups";
        EducationalClaimHeaderLT: Record "Educational Claim Header LT";
        EducationalClaimLinesLT: Record "Educational Claim Lines LT";
        EducationalClaimHeaderLT2: Record "Educational Claim Header LT";
    begin
        EducationalClaimHeaderLT.RESET;
        EducationalClaimHeaderLT.SETRANGE("Claim ID", "Claim ID");
        EducationalClaimHeaderLT.SETRANGE("Employee No.", "Employee No.");
        if EducationalClaimHeaderLT.FINDFIRST then begin
            EducationalClaimHeaderLT2.RESET;
            EducationalClaimHeaderLT2.SETRANGE("Employee No.", EducationalClaimHeaderLT."Employee No.");
            EducationalClaimHeaderLT2.SETRANGE("Academic year", EducationalClaimHeaderLT."Academic year");
            if EducationalClaimHeaderLT2.FINDSET then begin
                repeat
                    EducationalClaimLinesLT.RESET;
                    EducationalClaimLinesLT.SETRANGE("Claim ID", EducationalClaimHeaderLT2."Claim ID");
                    EducationalClaimLinesLT.SETRANGE("Employee No.", EducationalClaimHeaderLT2."Employee No.");
                    EducationalClaimLinesLT.SETRANGE("Dependent ID", "Dependent ID");
                    EducationalClaimLinesLT.SETRANGE("Allowance Type", EducationalClaimLinesLT."Allowance Type"::"Educational Book Allowance");
                    if EducationalClaimLinesLT.FINDSET then
                        repeat
                            BookAllowance_CountG += 1;
                        until EducationalClaimLinesLT.NEXT = 0;
                until EducationalClaimHeaderLT2.NEXT = 0;
            end;
        end;
    end;
}