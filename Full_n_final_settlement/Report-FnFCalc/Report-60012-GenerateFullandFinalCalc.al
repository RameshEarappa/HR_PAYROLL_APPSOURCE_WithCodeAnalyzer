report 60012 "Generate Full and Final Calc"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(Employee; Employee)
        {
            trigger OnAfterGetRecord();
            var
                EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
            begin
                SeperationStartDate := CALCDATE('-CM', Employee."Employment End Date");
                SeperationEndDate := CALCDATE('CM', Employee."Employment End Date");
                gPayPeriod.RESET;
                gPayPeriod.SETRANGE("Pay Cycle", PayCycle);
                gPayPeriod.SETRANGE("Period Start Date", PayStartDate, NORMALDATE(CALCDATE('CM', PayEndDate)));
                if gPayPeriod.FINDFIRST then
                    repeat
                        CalculateComponents(Employee, gPayPeriod."Period Start Date", NORMALDATE(gPayPeriod."Period End Date"), FandFJournal);
                    until gPayPeriod.NEXT = 0;
                CreateBenefitLedger(PayStartDate, PayEndDate, FandFJournal, Employee."No.");
                CreateLoanTransLines(PayStartDate, PayEndDate, FandFJournal, Employee."No.");
            end;
        }
    }

    var
        AdvancePayrollSetupG: Record "Advance Payroll Setup";
        ResultContainer: array[2] of Text;
        SeperationStartDate: Date;
        SeperationEndDate: Date;
        PayCycle: Code[20];
        TempDataTable: Record "Temp Datatable Data";
        PayStartDate: Date;
        PayEndDate: Date;
        FandFJournal: Record "Full and Final Calculation";
        gPayPeriod: Record "Pay Periods";
        EarningCodes: Record "Payroll Earning Code";
        EmployeeInterimAccruals: Record "Employee Interim Accurals";
        _PayrollStatementEmployee: Record "Payroll Statement Employee";
        _PayrollStatementLines: Record "Payroll Statement Lines";
        EarningCodesRecG: Record "Payroll Earning Code";

    procedure SetValues(l_PayCycle: Code[20]; l_StartDate: Date; l_EndDate: Date; l_FandFJournal: Record "Full and Final Calculation");
    begin
        PayCycle := l_PayCycle;
        PayStartDate := l_StartDate;
        PayEndDate := l_EndDate;
        FandFJournal := l_FandFJournal;
    end;

    Procedure STRREPLACE(String: Text; Old: Text; New: Text): Text;
    var
        stOrig: Text;
        stOld: Text;
        stNew: Text;
        i: Integer;
        len: Integer;
        len2: Integer;
        st: Text;
    begin
        Clear(stOrig);
        Clear(stNew);
        Clear(stOld);
        Clear(i);
        Clear(len);
        Clear(len2);
        Clear(st);

        stOrig := String;
        stNew := New;
        stOld := Old;

        IF stNew = stOld THEN
            EXIT(stOrig);

        i := 1;
        len := STRLEN(stOrig);
        len2 := STRLEN(stOld);
        if len > 0 then
            REPEAT
                IF COPYSTR(stOrig, i, 1) = COPYSTR(stOld, 1, 1) THEN BEGIN
                    IF COPYSTR(stOrig, i, len2) = stOld THEN BEGIN
                        st := st + stNew;
                        i := i + len2 - 1;
                    END
                    ELSE
                        st := st + COPYSTR(stOrig, i, 1);
                END
                ELSE
                    st := st + COPYSTR(stOrig, i, 1);
                i := i + 1;
            UNTIL i = len + 1;
        EXIT(st);
    end;

    procedure CalculateComponents(HcmWorkerRecId: Record Employee; FromDate: Date; ToDate: Date; l_FandFJournal: Record "Full and Final Calculation");
    var
        FSEarningCodes: Record "FS - Earning Code";
        FSBenefits: Record "FS Benefits";
        FSLoans: Record "FS Loans";
        EmployeeBenefits: Record "HCM Benefit Wrkr";
        EmployeeLoans: Record "HCM Loan Table GCC Wrkr";
        EmployeeEarningCodes: Record "Payroll Earning Code Wrkr";
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        RecEmployee: Record Employee;
        i: Integer;
        recPayCycle: Record "Pay Cycles";
        PayPeriod: Record "Pay Periods";
        Value: Variant;
        PayrollFormulaKeyWords: Record "Payroll Formula";
        PayrollParameterHelper: Integer;
        EmployeeLeaveTypes: Record "HCM Leave Types Wrkr";
        PayrollWorkerPositionEarningCode: Code[20];
        EmployeeEarning: Code[20];
        NoOfFirstHalfDays: Decimal;
        NoOfSecondHalfDays: Decimal;
        NoOfDays: Decimal;
        UnitFormula: Text;
        AmountCalcFormula: Text;
        EncashmentFormula: Text;
        EmployeeWorkDate: Record EmployeeWorkDate_GCC;
        openingBalanceBenefit: Decimal;
        BenefitAdjustJournalHeader: Record "Benefit Adjmt. Journal header";
        BenefitAdjustJournalLine: Record "Benefit Adjmt. Journal Lines";
        HCMEmployeeBenefits_GCC: Record "HCM Benefit Wrkr";

        FormulaForPackage: Text;
        FormulaForAttendance: Text;
        FormulaForDays: Text;

        LoanInstallmentGeneration: Record "Loan Installment Generation";
        LoanSetup: Record "Loan Type Setup";
        FSEarningCodes2: Record "FS - Earning Code";
        //############################## Solution of Dll & DotNet Variable ################################
        ParameterTableNavRecL: Record "ParamList Data Table FnFCalc";
        PayComponentNavRecL: Record "Emp. Earning Code List FnFCalc";
        BenefitNavRecL: Record "Emp. Benefits List FnFCalc";
        ResultNavRecL: Record "Emp. Result Table FnFCalc";

        DLLSolutionAPI_CU: Codeunit "FnF-BC Json Handling";

        ReturnJsonStringTxtL: Text;
        ReturnJsonResponse: Text;

        PayComponentRowCollectionRecL: Record "Emp. Result Table FnFCalc";
        BenefitRowCollectionRecL: Record "Emp. Result Table FnFCalc";
        //############################## Solution of Dll & DotNet Variable ################################
        openingBalanceBenefitAmountG: decimal;
        openingBalanceBenefitCUG: decimal;
        EarningCodeAmount_P: Decimal;

        CurrCount: Integer;
        HCMBenefitRecL: Record "HCM Benefit";
    begin
        AdvancePayrollSetupG.Reset();
        if AdvancePayrollSetupG.Get() then;
        l_FandFJournal.Reset();
        if l_FandFJournal.FindSet() then begin
            repeat
                TempDataTable.DELETEALL;

                ParameterTableNavRecL.Reset();
                if ParameterTableNavRecL.FindSet() then
                    ParameterTableNavRecL.DeleteAll();

                PayComponentNavRecL.Reset();
                if PayComponentNavRecL.FindSet() then
                    PayComponentNavRecL.DeleteAll();

                BenefitNavRecL.Reset();
                if BenefitNavRecL.FindSet() then
                    BenefitNavRecL.DeleteAll();

                ResultNavRecL.Reset();
                if ResultNavRecL.FindSet() then
                    ResultNavRecL.DeleteAll();

                RecEmployee.GET(HcmWorkerRecId."No.");
                PayrollFormulaKeyWords.RESET;
                PayrollFormulaKeyWords.SETRANGE("Formula Key Type", PayrollFormulaKeyWords."Formula Key Type"::Parameter);
                if PayrollFormulaKeyWords.FINDFIRST then
                    repeat
                        CLEAR(ResultContainer);
                        GetParameterKey(PayrollFormulaKeyWords."Formula Key", RecEmployee, FromDate, ToDate);
                        ParameterTableNavRecL.Reset();
                        ParameterTableNavRecL.Init();
                        ParameterTableNavRecL."Entry No." := 0;
                        ParameterTableNavRecL.Insert();
                        ParameterTableNavRecL.ParamList__KeyId := PayrollFormulaKeyWords."Formula Key";
                        if STRPOS(ResultContainer[1], ',') <> 0 then
                            ParameterTableNavRecL.SET_ParamList__KeyValue_Code((DELCHR(ResultContainer[1], '=', ',')), ParameterTableNavRecL."Entry No.")
                        else
                            ParameterTableNavRecL.SET_ParamList__KeyValue_Code(ResultContainer[1], ParameterTableNavRecL."Entry No.");

                        ParameterTableNavRecL.ParamList__DataType := ResultContainer[2];
                        ParameterTableNavRecL.Modify();
                        TempDataTable.INIT;
                        TempDataTable."Entry No." := 0;
                        TempDataTable."Parameter ID" := PayrollFormulaKeyWords."Formula Key";
                        TempDataTable."Parameter Value" := FORMAT(ResultContainer[1]);
                        TempDataTable."Parameter Datatype" := FORMAT(ResultContainer[2]);
                        TempDataTable.INSERT;
                    until PayrollFormulaKeyWords.NEXT = 0;

                PayrollFormulaKeyWords.RESET;
                PayrollFormulaKeyWords.SETRANGE("Formula Key Type", PayrollFormulaKeyWords."Formula Key Type"::Custom);
                if PayrollFormulaKeyWords.FINDFIRST then
                    repeat
                        ParameterTableNavRecL.Reset();
                        ParameterTableNavRecL.Init();
                        ParameterTableNavRecL."Entry No." := 0;
                        ParameterTableNavRecL.Insert();
                        ParameterTableNavRecL.ParamList__KeyId := PayrollFormulaKeyWords."Formula Key";
                        ParameterTableNavRecL.SET_ParamList__KeyValue_Code(PayrollFormulaKeyWords.Formula, ParameterTableNavRecL."Entry No.");
                        ParameterTableNavRecL.ParamList__DataType := '#FormulaDataType';
                        ParameterTableNavRecL.Modify();

                        TempDataTable.INIT;
                        TempDataTable."Entry No." := 0;
                        TempDataTable."Parameter ID" := PayrollFormulaKeyWords."Formula Key";
                        TempDataTable."Parameter Value" := PayrollFormulaKeyWords.Formula;
                        TempDataTable."Parameter Datatype" := '#FormulaDataType';
                        TempDataTable.INSERT;
                    until PayrollFormulaKeyWords.NEXT = 0;

                EmployeeEarningCodeGroup.RESET;
                EmployeeEarningCodeGroup.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                EmployeeEarningCodeGroup.SETRANGE("Employee Code", HcmWorkerRecId."No.");
                EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', ToDate);
                EmployeeEarningCodeGroup.SETFILTER("Valid To", '>=%1|%2', ToDate, 0D);
                if EmployeeEarningCodeGroup.FINDFIRST then begin
                    EmployeeLeaveTypes.RESET;
                    EmployeeLeaveTypes.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    EmployeeLeaveTypes.SETRANGE(Worker, HcmWorkerRecId."No.");
                    if EmployeeLeaveTypes.FINDSET then
                        repeat
                            PayrollFormulaKeyWords.RESET;
                            PayrollFormulaKeyWords.SETRANGE("Short Name", EmployeeLeaveTypes."Short Name");
                            PayrollFormulaKeyWords.SETRANGE("Formula Key Type", PayrollFormulaKeyWords."Formula Key Type"::"Leave Type");
                            if PayrollFormulaKeyWords.FINDFIRST then
                                repeat
                                    NoOfDays := 0;
                                    NoOfFirstHalfDays := 0;
                                    NoOfSecondHalfDays := 0;
                                    case
                                    PayrollFormulaKeyWords."Formula Key" of
                                        'AC_' + PayrollFormulaKeyWords."Short Name":
                                            begin
                                                if not ((EmployeeLeaveTypes."Exc Public Holidays") and (EmployeeLeaveTypes."Exc Week Offs")) then begin
                                                    EmployeeWorkDate.RESET;
                                                    EmployeeWorkDate.SETRANGE("Employee Code", RecEmployee."No.");
                                                    EmployeeWorkDate.SETRANGE("First Half Leave Type", EmployeeLeaveTypes."Short Name");
                                                    EmployeeWorkDate.SETRANGE("Trans Date", FromDate, ToDate);
                                                    if EmployeeWorkDate.FINDFIRST then
                                                        NoOfFirstHalfDays := EmployeeWorkDate.COUNT;

                                                    EmployeeWorkDate.RESET;
                                                    EmployeeWorkDate.SETRANGE("Employee Code", RecEmployee."No.");
                                                    EmployeeWorkDate.SETRANGE("Second Half Leave Type", EmployeeLeaveTypes."Short Name");
                                                    EmployeeWorkDate.SETRANGE("Trans Date", FromDate, ToDate);
                                                    if EmployeeWorkDate.FINDFIRST then
                                                        NoOfSecondHalfDays := EmployeeWorkDate.COUNT;
                                                end
                                                else
                                                    if (EmployeeLeaveTypes."Exc Public Holidays") and (EmployeeLeaveTypes."Exc Week Offs") then begin
                                                        EmployeeWorkDate.RESET;
                                                        EmployeeWorkDate.SETRANGE("Employee Code", RecEmployee."No.");
                                                        EmployeeWorkDate.SETRANGE("First Half Leave Type", EmployeeLeaveTypes."Short Name");
                                                        EmployeeWorkDate.SETRANGE("Trans Date", FromDate, ToDate);
                                                        EmployeeWorkDate.SETRANGE("Calculation Type", EmployeeWorkDate."Calculation Type"::"Working Day");
                                                        if EmployeeWorkDate.FINDFIRST then
                                                            NoOfFirstHalfDays := EmployeeWorkDate.COUNT;

                                                        EmployeeWorkDate.RESET;
                                                        EmployeeWorkDate.SETRANGE("Employee Code", RecEmployee."No.");
                                                        EmployeeWorkDate.SETRANGE("Second Half Leave Type", EmployeeLeaveTypes."Short Name");
                                                        EmployeeWorkDate.SETRANGE("Trans Date", FromDate, ToDate);
                                                        EmployeeWorkDate.SETRANGE("Calculation Type", EmployeeWorkDate."Calculation Type"::"Working Day");
                                                        if EmployeeWorkDate.FINDFIRST then
                                                            NoOfSecondHalfDays := EmployeeWorkDate.COUNT;
                                                    end
                                            end;
                                        'AC_' + PayrollFormulaKeyWords."Short Name" + '_ESD':
                                            begin
                                                NoOfDays := EmployeeLeaveTypes."Entitlement Days";
                                            end;
                                        'AC_' + PayrollFormulaKeyWords."Short Name" + '_TD':
                                            begin
                                                if not ((EmployeeLeaveTypes."Exc Public Holidays") and (EmployeeLeaveTypes."Exc Week Offs")) then begin
                                                    EmployeeWorkDate.RESET;
                                                    EmployeeWorkDate.SETRANGE("Employee Code", RecEmployee."No.");
                                                    EmployeeWorkDate.SETRANGE("First Half Leave Type", EmployeeLeaveTypes."Short Name");
                                                    EmployeeWorkDate.SETRANGE("Trans Date", RecEmployee."Joining Date", ToDate);
                                                    if EmployeeWorkDate.FINDFIRST then
                                                        NoOfFirstHalfDays := EmployeeWorkDate.COUNT;

                                                    EmployeeWorkDate.RESET;
                                                    EmployeeWorkDate.SETRANGE("Employee Code", RecEmployee."No.");
                                                    EmployeeWorkDate.SETRANGE("Second Half Leave Type", EmployeeLeaveTypes."Short Name");
                                                    EmployeeWorkDate.SETRANGE("Trans Date", RecEmployee."Joining Date", ToDate);
                                                    if EmployeeWorkDate.FINDFIRST then
                                                        NoOfSecondHalfDays := EmployeeWorkDate.COUNT;
                                                end
                                                else
                                                    if (EmployeeLeaveTypes."Exc Public Holidays") and (EmployeeLeaveTypes."Exc Week Offs") then begin
                                                        EmployeeWorkDate.RESET;
                                                        EmployeeWorkDate.SETRANGE("Employee Code", RecEmployee."No.");
                                                        EmployeeWorkDate.SETRANGE("First Half Leave Type", EmployeeLeaveTypes."Short Name");
                                                        EmployeeWorkDate.SETRANGE("Trans Date", RecEmployee."Joining Date", ToDate);
                                                        EmployeeWorkDate.SETRANGE("Calculation Type", EmployeeWorkDate."Calculation Type"::"Working Day");
                                                        if EmployeeWorkDate.FINDFIRST then
                                                            NoOfFirstHalfDays := EmployeeWorkDate.COUNT;

                                                        EmployeeWorkDate.RESET;
                                                        EmployeeWorkDate.SETRANGE("Employee Code", RecEmployee."No.");
                                                        EmployeeWorkDate.SETRANGE("Second Half Leave Type", EmployeeLeaveTypes."Short Name");
                                                        EmployeeWorkDate.SETRANGE("Trans Date", RecEmployee."Joining Date", ToDate);
                                                        EmployeeWorkDate.SETRANGE("Calculation Type", EmployeeWorkDate."Calculation Type"::"Working Day");
                                                        if EmployeeWorkDate.FINDFIRST then
                                                            NoOfSecondHalfDays := EmployeeWorkDate.COUNT;
                                                    end
                                            end;
                                        'AC_' + PayrollFormulaKeyWords."Short Name" + '_TDFY':
                                            begin
                                            end;
                                        'AC_' + PayrollFormulaKeyWords."Short Name" + '_TDY':
                                            begin
                                            end;
                                        'AC_' + PayrollFormulaKeyWords."Short Name" + '_EJYC':
                                            begin
                                            end;
                                    end;
                                    if NoOfDays = 0 then
                                        NoOfDays := (NoOfFirstHalfDays + NoOfSecondHalfDays) / 2;
                                    //Insert Parameter Row for Employee Leaves

                                    ParameterTableNavRecL.Reset();
                                    ParameterTableNavRecL.Init();
                                    ParameterTableNavRecL."Entry No." := 0;
                                    ParameterTableNavRecL.Insert();
                                    ParameterTableNavRecL.ParamList__KeyId := PayrollFormulaKeyWords."Formula Key";
                                    if STRPOS(FORMAT(NoOfDays), ',') <> 0 then
                                        ParameterTableNavRecL.SET_ParamList__KeyValue_Code(DELCHR(FORMAT(NoOfDays), '=', ','), ParameterTableNavRecL."Entry No.")
                                    else
                                        ParameterTableNavRecL.SET_ParamList__KeyValue_Code(Format(NoOfDays), ParameterTableNavRecL."Entry No.");


                                    ParameterTableNavRecL.ParamList__DataType := '#FormulaDataType';
                                    ParameterTableNavRecL.Modify();

                                    //Insert Parameter Row for Employee Leaves
                                    //Temp Data
                                    TempDataTable.INIT;
                                    TempDataTable."Entry No." := 0;
                                    TempDataTable."Parameter ID" := PayrollFormulaKeyWords."Formula Key";
                                    TempDataTable."Parameter Value" := FORMAT(NoOfDays);
                                    TempDataTable."Parameter Datatype" := '#NumericDataType';
                                    TempDataTable.INSERT;
                                //Temp Data
                                until PayrollFormulaKeyWords.NEXT = 0;
                        until EmployeeLeaveTypes.NEXT = 0;

                    EmployeeBenefits.RESET;
                    EmployeeBenefits.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    EmployeeBenefits.SETRANGE(Worker, RecEmployee."No.");
                    EmployeeBenefits.SETRANGE(Active, true);
                    if EmployeeBenefits.FINDSET then
                        repeat
                            PayrollFormulaKeyWords.RESET;
                            PayrollFormulaKeyWords.SETRANGE("Short Name", EmployeeBenefits."Short Name");
                            PayrollFormulaKeyWords.SETRANGE("Formula Key Type", PayrollFormulaKeyWords."Formula Key Type"::Benefit);
                            if PayrollFormulaKeyWords.FINDFIRST then
                                repeat
                                    CLEAR(ResultContainer);
                                    CLEAR(openingBalanceBenefit);
                                    case
                                        PayrollFormulaKeyWords."Formula Key" of
                                        'BA_ADJ_' + PayrollFormulaKeyWords."Short Name":    //Sum of all posted and non included benefit amounts in same pay period
                                            begin
                                                BenefitAdjustJournalHeader.RESET;
                                                BenefitAdjustJournalHeader.SETFILTER("Pay Period Start", '>=%1', FromDate);
                                                BenefitAdjustJournalHeader.SETFILTER("Pay Period End", '<=%1', ToDate);
                                                BenefitAdjustJournalHeader.SETRANGE(Posted, true);
                                                if BenefitAdjustJournalHeader.FINDFIRST then
                                                    repeat
                                                        BenefitAdjustJournalLine.RESET;
                                                        BenefitAdjustJournalLine.SETRANGE("Journal No.", BenefitAdjustJournalHeader."Journal No.");
                                                        BenefitAdjustJournalLine.SETRANGE("Employee Code", RecEmployee."No.");
                                                        BenefitAdjustJournalLine.SETRANGE(Benefit, EmployeeBenefits."Benefit Id");
                                                        if BenefitAdjustJournalLine.FINDSET then
                                                            repeat
                                                                openingBalanceBenefit += BenefitAdjustJournalLine.Amount;
                                                            until BenefitAdjustJournalLine.NEXT = 0;
                                                    until BenefitAdjustJournalHeader.NEXT = 0;
                                                ResultContainer[1] := FORMAT(openingBalanceBenefit, 0, 1);
                                                ResultContainer[2] := '#NumericDataType';

                                            end;
                                        'BA_ADJ_OB_' + PayrollFormulaKeyWords."Short Name":               //Sum of all posted and non included benefit amounts Prev pay period
                                            begin
                                                BenefitAdjustJournalHeader.RESET;
                                                BenefitAdjustJournalHeader.SETFILTER("Pay Period Start", '<%1', FromDate);
                                                BenefitAdjustJournalHeader.SETRANGE(Posted, true);
                                                if BenefitAdjustJournalHeader.FINDFIRST then
                                                    repeat
                                                        BenefitAdjustJournalLine.RESET;
                                                        BenefitAdjustJournalLine.SETRANGE("Journal No.", BenefitAdjustJournalHeader."Journal No.");
                                                        BenefitAdjustJournalLine.SETRANGE("Employee Code", RecEmployee."No.");
                                                        BenefitAdjustJournalLine.SETRANGE(Benefit, EmployeeBenefits."Benefit Id");
                                                        if BenefitAdjustJournalLine.FINDSET then
                                                            repeat
                                                                openingBalanceBenefit += BenefitAdjustJournalLine.Amount;
                                                            until BenefitAdjustJournalLine.NEXT = 0;
                                                    until BenefitAdjustJournalHeader.NEXT = 0;
                                                ResultContainer[1] := FORMAT(openingBalanceBenefit, 0, 1);
                                                ResultContainer[2] := '#NumericDataType';
                                            end;
                                        'BA_OB_' + PayrollFormulaKeyWords."Short Name":
                                            begin
                                                _PayrollStatementEmployee.RESET;
                                                _PayrollStatementEmployee.SETRANGE(Worker, RecEmployee."No.");
                                                _PayrollStatementEmployee.SETFILTER("Pay Period End Date", '<%1', FromDate);
                                                if _PayrollStatementEmployee.FINDFIRST then
                                                    repeat
                                                        _PayrollStatementLines.RESET;
                                                        _PayrollStatementLines.SETRANGE("Payroll Statement ID", _PayrollStatementEmployee."Payroll Statement ID");
                                                        _PayrollStatementLines.SETRANGE("Payroll Statment Employee", _PayrollStatementEmployee.Worker);
                                                        _PayrollStatementLines.SETRANGE("Benefit Short Name", EmployeeBenefits."Short Name");
                                                        if _PayrollStatementLines.FINDSET then
                                                            repeat
                                                                openingBalanceBenefit += _PayrollStatementLines."Benefit Amount";
                                                            until _PayrollStatementLines.NEXT = 0;
                                                    until _PayrollStatementEmployee.NEXT = 0;
                                                ResultContainer[1] := FORMAT(openingBalanceBenefit, 0, 1);
                                                ResultContainer[2] := '#NumericDataType';
                                            end;
                                        'BE_' + PayrollFormulaKeyWords."Short Name":                //Benefit maximum units allowed for
                                            begin
                                                HCMEmployeeBenefits_GCC.RESET;
                                                HCMEmployeeBenefits_GCC.SETRANGE(Worker, RecEmployee."No.");
                                                HCMEmployeeBenefits_GCC.SETRANGE("Short Name", EmployeeBenefits."Short Name");
                                                HCMEmployeeBenefits_GCC.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                                                if HCMEmployeeBenefits_GCC.FINDFIRST then begin
                                                    ResultContainer[1] := FORMAT(HCMEmployeeBenefits_GCC."Max Units");
                                                    ResultContainer[2] := '#NumericDataType';
                                                end;
                                            end;
                                        'BE_' + PayrollFormulaKeyWords."Short Name" + '_SERVICEDAYS':        //Benefit entitlement service days for
                                            begin
                                                HCMEmployeeBenefits_GCC.RESET;
                                                HCMEmployeeBenefits_GCC.SETRANGE(Worker, RecEmployee."No.");
                                                HCMEmployeeBenefits_GCC.SETRANGE("Short Name", EmployeeBenefits."Short Name");
                                                HCMEmployeeBenefits_GCC.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                                                if HCMEmployeeBenefits_GCC.FINDFIRST then begin
                                                    ResultContainer[1] := FORMAT(HCMEmployeeBenefits_GCC."Benefit Entitlement Days");
                                                    ResultContainer[2] := '#NumericDataType';
                                                end;
                                            end;
                                        'BLTA_' + PayrollFormulaKeyWords."Short Name" + '_ADULTS':           //Total number of adults eligible for LTA
                                            begin

                                            end;
                                        'BLTA_' + PayrollFormulaKeyWords."Short Name" + '_CHILDREN':        //Total number of Children eligible for LTA
                                            begin

                                            end;
                                        'BLTA_' + PayrollFormulaKeyWords."Short Name" + '_INFANTS':        //Total number of Infants eligible for LTA
                                            begin

                                            end;
                                        'BU_ADJ_' + PayrollFormulaKeyWords."Short Name":                //Sum of all posted and non included benefit units in same pay period
                                            begin
                                                BenefitAdjustJournalHeader.RESET;
                                                BenefitAdjustJournalHeader.SETFILTER("Pay Period Start", '>=%1', FromDate);
                                                BenefitAdjustJournalHeader.SETFILTER("Pay Period End", '<=%1', ToDate);
                                                BenefitAdjustJournalHeader.SETRANGE(Posted, true);
                                                if BenefitAdjustJournalHeader.FINDFIRST then
                                                    repeat
                                                        BenefitAdjustJournalLine.RESET;
                                                        BenefitAdjustJournalLine.SETRANGE("Journal No.", BenefitAdjustJournalHeader."Journal No.");
                                                        BenefitAdjustJournalLine.SETRANGE("Employee Code", RecEmployee."No.");
                                                        BenefitAdjustJournalLine.SETRANGE(Benefit, EmployeeBenefits."Benefit Id");
                                                        if BenefitAdjustJournalLine.FINDSET then
                                                            repeat
                                                                openingBalanceBenefit += BenefitAdjustJournalLine."Calculation Units";
                                                            until BenefitAdjustJournalLine.NEXT = 0;
                                                    until BenefitAdjustJournalHeader.NEXT = 0;
                                                ResultContainer[1] := FORMAT(openingBalanceBenefit, 0, 1);
                                                ResultContainer[2] := '#NumericDataType';
                                            end;
                                        'BU_ADJ_OB_' + PayrollFormulaKeyWords."Short Name":                //Sum of all posted and non included benefit units of Prev Period
                                            begin
                                                BenefitAdjustJournalHeader.RESET;
                                                BenefitAdjustJournalHeader.SETFILTER("Pay Period Start", '<%1', FromDate);
                                                BenefitAdjustJournalHeader.SETRANGE(Posted, true);
                                                if BenefitAdjustJournalHeader.FINDFIRST then
                                                    repeat
                                                        BenefitAdjustJournalLine.RESET;
                                                        BenefitAdjustJournalLine.SETRANGE("Journal No.", BenefitAdjustJournalHeader."Journal No.");
                                                        BenefitAdjustJournalLine.SETRANGE("Employee Code", RecEmployee."No.");
                                                        BenefitAdjustJournalLine.SETRANGE(Benefit, EmployeeBenefits."Benefit Id");
                                                        if BenefitAdjustJournalLine.FINDSET then
                                                            repeat
                                                                openingBalanceBenefit += BenefitAdjustJournalLine."Calculation Units";
                                                            until BenefitAdjustJournalLine.NEXT = 0;
                                                    until BenefitAdjustJournalHeader.NEXT = 0;
                                                ResultContainer[1] := FORMAT(openingBalanceBenefit, 0, 1);
                                                ResultContainer[2] := '#NumericDataType';
                                            end;
                                        'BU_OB_' + PayrollFormulaKeyWords."Short Name":           //Benefit opening balance units for
                                            begin
                                                _PayrollStatementEmployee.RESET;
                                                _PayrollStatementEmployee.SETRANGE(Worker, RecEmployee."No.");
                                                _PayrollStatementEmployee.SETFILTER("Pay Period End Date", '<%1', FromDate);
                                                if _PayrollStatementEmployee.FINDFIRST then
                                                    repeat
                                                        _PayrollStatementLines.RESET;
                                                        _PayrollStatementLines.SETRANGE("Payroll Statement ID", _PayrollStatementEmployee."Payroll Statement ID");
                                                        _PayrollStatementLines.SETRANGE("Payroll Statment Employee", _PayrollStatementEmployee.Worker);
                                                        _PayrollStatementLines.SETRANGE("Benefit Short Name", EmployeeBenefits."Short Name");
                                                        if _PayrollStatementLines.FINDSET then
                                                            repeat
                                                                openingBalanceBenefit += _PayrollStatementLines."Calculation Units";
                                                            until _PayrollStatementLines.NEXT = 0;
                                                    until _PayrollStatementEmployee.NEXT = 0;
                                                ResultContainer[1] := FORMAT(openingBalanceBenefit, 0, 1);
                                                ResultContainer[2] := '#NumericDataType';
                                            end;
                                    end;
                                    //Insert Parameter Row for Employee Leaves
                                    ParameterTableNavRecL.Reset();
                                    ParameterTableNavRecL.Init();
                                    ParameterTableNavRecL."Entry No." := 0;
                                    ParameterTableNavRecL.Insert();
                                    ParameterTableNavRecL.ParamList__KeyId := PayrollFormulaKeyWords."Formula Key";
                                    if STRPOS(FORMAT(NoOfDays), ',') <> 0 then
                                        ParameterTableNavRecL.SET_ParamList__KeyValue_Code(DELCHR(FORMAT(NoOfDays), '=', ','), ParameterTableNavRecL."Entry No.")
                                    else
                                        ParameterTableNavRecL.SET_ParamList__KeyValue_Code(FORMAT(openingBalanceBenefit, 0, 1), ParameterTableNavRecL."Entry No.");
                                    ParameterTableNavRecL.ParamList__DataType := '#NumericDataType';
                                    ParameterTableNavRecL.Modify();

                                    //Insert Parameter Row for Employee Leaves
                                    //Temp Data
                                    TempDataTable.INIT;
                                    TempDataTable."Entry No." := 0;
                                    TempDataTable."Parameter ID" := PayrollFormulaKeyWords."Formula Key";
                                    TempDataTable."Parameter Value" := FORMAT(openingBalanceBenefit, 0, 1);
                                    TempDataTable."Parameter Datatype" := '#NumericDataType';
                                    TempDataTable.INSERT;
                                //Temp Data
                                until PayrollFormulaKeyWords.NEXT = 0;
                        until EmployeeBenefits.NEXT = 0;
                    //>>>Parameter System Data Table
                    //>>>Paycomponent System Data Table

                    //Paycomponent Table and columns
                    EmployeeEarningCodes.RESET;
                    EmployeeEarningCodes.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    EmployeeEarningCodes.SETRANGE(Worker, RecEmployee."No.");
                    if EmployeeEarningCodes.FINDSET then
                        repeat
                            FormulaForPackage := STRREPLACE(EmployeeEarningCodes."Formula For Package", '[', '([');
                            FormulaForPackage := STRREPLACE(FormulaForPackage, ']', '])');

                            FormulaForAttendance := STRREPLACE(EmployeeEarningCodes.GetFormulaForAttendance, '[', '([');
                            FormulaForAttendance := STRREPLACE(FormulaForAttendance, ']', '])');

                            FormulaForDays := STRREPLACE(EmployeeEarningCodes."Formula For Days", '[', '([');
                            FormulaForDays := STRREPLACE(FormulaForDays, ']', '])');
                            //LT
                            if EmployeeEarningCodes."Package Calc Type" = EmployeeEarningCodes."Package Calc Type"::Amount then begin
                                FormulaForPackage := FORMAT(EmployeeEarningCodes."Package Amount");
                                if STRPOS(FormulaForPackage, ',') <> 0 then
                                    FormulaForPackage := DELCHR(FormulaForPackage, '=', ',');
                            end
                            else begin
                                FormulaForPackage := FORMAT((EmployeeEarningCodeGroup."Gross Salary") * (EmployeeEarningCodes."Package Percentage" / 100));
                                if STRPOS(FormulaForPackage, ',') <> 0 then
                                    FormulaForPackage := DELCHR(FormulaForPackage, '=', ',');
                            end;
                            //Insert System Data Rows
                            PayComponentNavRecL.Init();
                            PayComponentNavRecL."Entry No." := 0;
                            PayComponentNavRecL.Insert();
                            PayComponentNavRecL.EECList__Paycomponentcode := EmployeeEarningCodes."Short Name";
                            PayComponentNavRecL.SETFormulaEECList__UnitFormula_Code(FormulaForPackage, PayComponentNavRecL."Entry No.");
                            PayComponentNavRecL.SETEECList__Formulaforattendance_Code(FormulaForAttendance, PayComponentNavRecL."Entry No.");
                            PayComponentNavRecL.SETEECList__Formulafordays_Code(FormulaForDays, PayComponentNavRecL."Entry No.");
                            PayComponentNavRecL.EECList__Paycomponenttype := Format(EmployeeEarningCodes."Pay Component Type");
                            Evaluate(PayComponentNavRecL.EECList__Pay_Comp_UnitFormula, FormulaForPackage);
                            PayComponentNavRecL.Modify();

                            //Temp Data
                            TempDataTable.INIT;
                            TempDataTable."Entry No." := 0;
                            TempDataTable."Paycomponent Code" := EmployeeEarningCodes."Short Name";
                            TempDataTable."PayComp Unit Formula" := FormulaForPackage;
                            TempDataTable."Formula For Attendance" := COPYSTR(FormulaForAttendance, 1, 250);
                            TempDataTable."Formula for Days" := FormulaForDays;
                            TempDataTable."Paycomponent Type" := FORMAT(EmployeeEarningCodes."Pay Component Type");
                            TempDataTable.INSERT;
                        //Temp Data
                        until EmployeeEarningCodes.NEXT = 0;
                    //>>>Paycomponent System Data Table
                    //>>>Benefit System Data Table              

                    EmployeeBenefits.RESET;
                    EmployeeBenefits.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    EmployeeBenefits.SETRANGE(Worker, RecEmployee."No.");
                    EmployeeBenefits.SETRANGE(Active, true);
                    if EmployeeBenefits.FINDSET then
                        repeat
                            UnitFormula := STRREPLACE(EmployeeBenefits.GetFormulaForUnitCalc, '[', '([');
                            UnitFormula := STRREPLACE(UnitFormula, ']', '])');

                            AmountCalcFormula := STRREPLACE(EmployeeBenefits.GetFormulaForAmountCalc, '[', '([');
                            AmountCalcFormula := STRREPLACE(AmountCalcFormula, ']', '])');

                            EncashmentFormula := STRREPLACE(EmployeeBenefits.GetFormulaForEncashmentFormula, '[', '([');
                            EncashmentFormula := STRREPLACE(EncashmentFormula, ']', '])');

                            BenefitNavRecL.Init();
                            BenefitNavRecL."Entry No." := 0;
                            BenefitNavRecL.Insert();
                            BenefitNavRecL.EBList__Benefitcode := EmployeeBenefits."Short Name";
                            BenefitNavRecL.SET_EBList__UnitFormula_Code(Format(UnitFormula), BenefitNavRecL."Entry No.");
                            BenefitNavRecL.SET_EBList__ValueFormula_Code(AmountCalcFormula, BenefitNavRecL."Entry No.");
                            BenefitNavRecL.SET_EBList__EncashmentFormula_Code(Format(EncashmentFormula), BenefitNavRecL."Entry No.");
                            BenefitNavRecL.Modify();

                            //Temp Data
                            TempDataTable.INIT;
                            TempDataTable."Entry No." := 0;
                            TempDataTable."Benefit Code" := EmployeeBenefits."Short Name";
                            TempDataTable."Unit Formula" := CopyStr(UnitFormula, 1, 250);
                            TempDataTable."Value Formula" := CopyStr(AmountCalcFormula, 1, 250);
                            TempDataTable."Encashment Formula" := CopyStr(EncashmentFormula, 1, 250);
                            TempDataTable.INSERT;
                        //Temp Data
                        until EmployeeBenefits.NEXT = 0;
                end;
                //>>>Benefit System Data Table

                ReturnJsonStringTxtL := DLLSolutionAPI_CU.CreateJSonFomatOfTable_LT(ParameterTableNavRecL, PayComponentNavRecL, BenefitNavRecL);

                ReturnJsonResponse := DLLSolutionAPI_CU.MakeRequest(AdvancePayrollSetupG."Azure Dll URL", ReturnJsonStringTxtL);

                ResultNavRecL.DeleteAll();
                Clear(ResultNavRecL);
                DLLSolutionAPI_CU.CopyJsonStringIntoResultTable(ResultNavRecL, ReturnJsonResponse);

                EmployeeEarningCodeGroup.RESET;
                EmployeeEarningCodeGroup.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                EmployeeEarningCodeGroup.SETRANGE("Employee Code", HcmWorkerRecId."No.");
                EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', ToDate);
                EmployeeEarningCodeGroup.SETFILTER("Valid To", '>=%1|%2', ToDate, 0D);
                if EmployeeEarningCodeGroup.FINDFIRST then begin
                    PayComponentRowCollectionRecL.Copy(ResultNavRecL);
                    CurrCount += 1;
                    EmployeeEarningCodes.RESET;
                    EmployeeEarningCodes.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    EmployeeEarningCodes.SETRANGE(Worker, RecEmployee."No.");
                    if EmployeeEarningCodes.FINDSET then begin
                        repeat
                            PayComponentRowCollectionRecL.Reset();
                            PayComponentRowCollectionRecL.SetCurrentKey("Entry No.");
                            if PayComponentRowCollectionRecL.FindSet() then begin
                                repeat
                                    TempDataTable.INIT;
                                    TempDataTable."Entry No." := 0;
                                    TempDataTable.INSERT;
                                    TempDataTable."Result Formula Type" := PayComponentRowCollectionRecL.FormulaType;
                                    TempDataTable."Result Base Code" := PayComponentRowCollectionRecL.BaseCode;
                                    TempDataTable."Result Fornula ID1" := PayComponentRowCollectionRecL.FormulaID1;
                                    TempDataTable.Result1 := PayComponentRowCollectionRecL.Result1;
                                    TempDataTable."Result Fornula ID2" := PayComponentRowCollectionRecL.FormulaID2;
                                    TempDataTable.Result2 := PayComponentRowCollectionRecL.Result2;
                                    TempDataTable."Result Fornula ID3" := PayComponentRowCollectionRecL.FormulaID3;
                                    TempDataTable.Result3 := PayComponentRowCollectionRecL.Result3;
                                    TempDataTable.SetFormulaForErrorLog(PayComponentRowCollectionRecL.GET_ErrorLog_Code(PayComponentRowCollectionRecL."Entry No."));
                                    TempDataTable.MODIFY;
                                    if (FORMAT(PayComponentRowCollectionRecL.FormulaType) = 'P') and (FORMAT(PayComponentRowCollectionRecL.BaseCode) = EmployeeEarningCodes."Earning Code")
                                    AND (NOT EmployeeEarningCodes."Leave Encashment Enable") then begin
                                        CLEAR(Value);
                                        CLEAR(FSEarningCodes);
                                        recPayCycle.GET(PayCycle);
                                        PayPeriod.RESET;
                                        PayPeriod.SETRANGE("Pay Cycle", recPayCycle."Pay Cycle");
                                        PayPeriod.SETRANGE("Period Start Date", FromDate);
                                        PayPeriod.FINDFIRST;
                                        FSEarningCodes.RESET;

                                        FSEarningCodes.INIT;
                                        FSEarningCodes."Journal ID" := l_FandFJournal."Journal ID";
                                        FSEarningCodes."Employee No." := RecEmployee."No.";
                                        FSEarningCodes."Earning Code" := EmployeeEarningCodes."Earning Code";
                                        EarningCodesRecG.get(EmployeeEarningCodes."Earning Code");
                                        FSEarningCodes."Final Settlement Component" := EarningCodesRecG."Final Settlement Component";

                                        FSEarningCodes."Payroll Period RecID" := PayPeriod."Line No.";
                                        FSEarningCodes."Benefit Code" := '';
                                        FSEarningCodes.INSERT;
                                        FSEarningCodes."Employee Name" := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
                                        FSEarningCodes."Earning Description" := EmployeeEarningCodes.Description;
                                        FSEarningCodes."Earning Code Group" := EmployeeEarningCodeGroup."Earning Code Group";
                                        FSEarningCodes."Pay Cycle" := PayCycle;
                                        FSEarningCodes."Payroll Period" := PayPeriod."Pay Cycle" + ':' + FORMAT(PayPeriod."Period Start Date") + ' - ' + FORMAT(NORMALDATE(PayPeriod."Period End Date"));
                                        FSEarningCodes."Pay Period Start" := PayPeriod."Period Start Date";
                                        FSEarningCodes."Pay Period End" := NORMALDATE(PayPeriod."Period End Date");
                                        FSEarningCodes."Earning Code Calc Class" := EmployeeEarningCodes."Earning Code Calc Class";
                                        Clear(Value);
                                        Value := PayComponentRowCollectionRecL.Result1;
                                        EVALUATE(FSEarningCodes."Calculation Units", Value);

                                        Clear(Value);
                                        Value := PayComponentRowCollectionRecL.Result2;
                                        EVALUATE(FSEarningCodes."Earning Code Amount", Value);

                                        Clear(Value);
                                        Value := PayComponentRowCollectionRecL.Result3;
                                        EVALUATE(FSEarningCodes."Payable Amount", Value);

                                        FSEarningCodes.Currency := EmployeeEarningCodeGroup.Currency;

                                        CreatePayrollAdjmtJournalLines(FromDate, ToDate, RecEmployee."No.", EarningCodeAmount_P, EmployeeEarningCodes."Earning Code");
                                        if EarningCodeAmount_P <> 0 then
                                            FSEarningCodes."Earning Code Amount" := EarningCodeAmount_P;

                                        FSEarningCodes.MODIFY;
                                    end;
                                    if (FORMAT(PayComponentRowCollectionRecL.FormulaType) = 'P') and
                                        (FORMAT(PayComponentRowCollectionRecL.BaseCode) = EmployeeEarningCodes."Earning Code") and
                                        (EmployeeEarningCodes."Leave Encashment Enable") then begin
                                        Clear(Value);
                                        Value := PayComponentRowCollectionRecL.Result2;
                                        CalculateLeaveEncashment_New(PayStartDate, PayEndDate, FandFJournal, RecEmployee."No.", Value)
                                    end;
                                until PayComponentRowCollectionRecL.next = 0;
                            end;
                        until EmployeeEarningCodes.NEXT = 0;
                    end;

                    BenefitRowCollectionRecL.Copy(ResultNavRecL);
                    EmployeeBenefits.RESET;
                    EmployeeBenefits.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    EmployeeBenefits.SETRANGE(Worker, RecEmployee."No.");
                    EmployeeBenefits.SETRANGE(Active, true);
                    if EmployeeBenefits.FINDSET then begin
                        repeat
                            BenefitRowCollectionRecL.Reset();
                            BenefitRowCollectionRecL.SetCurrentKey("Entry No.");
                            if BenefitRowCollectionRecL.FindSet() then begin
                                repeat
                                    TempDataTable.INIT;
                                    TempDataTable."Entry No." := 0;
                                    TempDataTable.INSERT;
                                    TempDataTable."Result Formula Type" := BenefitRowCollectionRecL.FormulaType;
                                    TempDataTable."Result Base Code" := BenefitRowCollectionRecL.BaseCode;
                                    TempDataTable."Result Fornula ID1" := BenefitRowCollectionRecL.FormulaID1;
                                    TempDataTable.Result1 := BenefitRowCollectionRecL.Result1;
                                    TempDataTable."Result Fornula ID2" := BenefitRowCollectionRecL.FormulaID2;
                                    TempDataTable.Result2 := BenefitRowCollectionRecL.Result2;
                                    TempDataTable."Result Fornula ID3" := BenefitRowCollectionRecL.FormulaID3;
                                    TempDataTable.Result3 := BenefitRowCollectionRecL.Result3;
                                    TempDataTable.SetFormulaForErrorLog(BenefitRowCollectionRecL.GET_ErrorLog_Code(BenefitRowCollectionRecL."Entry No."));
                                    TempDataTable.MODIFY;
                                    //Temp Data

                                    if (FORMAT(BenefitRowCollectionRecL.FormulaType) = 'B') and (FORMAT(BenefitRowCollectionRecL.BaseCode) = EmployeeBenefits."Short Name") then begin
                                        CLEAR(FSEarningCodes);
                                        CLEAR(HCMBenefitRecL);
                                        CLEAR(Value);
                                        recPayCycle.GET(PayCycle);
                                        PayPeriod.RESET;
                                        PayPeriod.SETRANGE("Pay Cycle", recPayCycle."Pay Cycle");
                                        PayPeriod.SETRANGE("Period Start Date", FromDate);
                                        PayPeriod.FINDFIRST;
                                        FSEarningCodes.RESET;
                                        FSEarningCodes.INIT;
                                        FSEarningCodes."Journal ID" := l_FandFJournal."Journal ID";
                                        FSEarningCodes."Employee No." := RecEmployee."No.";
                                        FSEarningCodes."Benefit Code" := EmployeeBenefits."Benefit Id";
                                        FSEarningCodes."Payroll Period RecID" := PayPeriod."Line No.";
                                        FSEarningCodes.INSERT;
                                        FSEarningCodes."Employee Name" := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
                                        FSEarningCodes."Benefit Description" := EmployeeBenefits.Description;
                                        FSEarningCodes."Earning Code Group" := EmployeeEarningCodeGroup."Earning Code Group";
                                        HCMBenefitRecL.GET(EmployeeBenefits."Benefit Id");
                                        IF EarningCodesRecG.GET(HCMBenefitRecL."Earning Code") THEN;
                                        FSEarningCodes."Final Settlement Component" := EarningCodesRecG."Final Settlement Component";
                                        FSEarningCodes."Pay Cycle" := PayCycle;
                                        FSEarningCodes."Payroll Period" := PayPeriod."Pay Cycle" + ':' + FORMAT(PayPeriod."Period Start Date") + ' - ' + FORMAT(NORMALDATE(PayPeriod."Period End Date"));
                                        FSEarningCodes."Pay Period Start" := PayPeriod."Period Start Date";
                                        FSEarningCodes."Pay Period End" := NORMALDATE(PayPeriod."Period End Date");

                                        Value := BenefitRowCollectionRecL.Result1;
                                        EVALUATE(FSEarningCodes."Calculation Units", Value);

                                        Value := BenefitRowCollectionRecL.Result2;
                                        EVALUATE(FSEarningCodes."Benefit Amount", Value);

                                        Value := BenefitRowCollectionRecL.Result3;
                                        EVALUATE(FSEarningCodes."Payable Amount", Value);

                                        FSEarningCodes.Currency := EmployeeEarningCodeGroup.Currency;
                                        Clear(openingBalanceBenefitAmountG);
                                        Clear(openingBalanceBenefitCUG);
                                        CreateBenefitLedger_LT(PayPeriod."Period Start Date", PayPeriod."Period End Date", EmployeeEarningCodeGroup."Earning Code Group", Employee."No.", openingBalanceBenefitAmountG, openingBalanceBenefitCUG, EmployeeBenefits."Benefit Id");
                                        IF (openingBalanceBenefitAmountG <> 0) OR (openingBalanceBenefitCUG <> 0) THEN BEGIN
                                            FSEarningCodes."Calculation Units" := openingBalanceBenefitCUG;
                                            FSEarningCodes."Benefit Amount" := openingBalanceBenefitAmountG;
                                        END;
                                        FSEarningCodes.MODIFY;
                                    end;
                                until BenefitRowCollectionRecL.Next() = 0;
                            end;
                        until EmployeeBenefits.NEXT = 0;
                    end;

                    //Employee Loans
                    CLEAR(FSLoans);
                    EmployeeLoans.RESET;
                    EmployeeLoans.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    EmployeeLoans.SETRANGE(Worker, HcmWorkerRecId."No.");
                    EmployeeLoans.SETRANGE(Active, true);
                    if EmployeeLoans.FINDFIRST then
                        repeat
                            LoanInstallmentGeneration.RESET;
                            LoanInstallmentGeneration.SETRANGE("Employee ID", EmployeeLoans.Worker);
                            LoanInstallmentGeneration.SETRANGE("Installament Date", FromDate, NORMALDATE(ToDate));
                            LoanInstallmentGeneration.SETRANGE(Loan, EmployeeLoans."Loan Code");
                            LoanInstallmentGeneration.SETRANGE(Status, LoanInstallmentGeneration.Status::Unrecovered);
                            if LoanInstallmentGeneration.FINDFIRST then
                                repeat
                                    CLEAR(FSEarningCodes);
                                    LoanSetup.GET(LoanInstallmentGeneration.Loan);
                                    LoanSetup.TESTFIELD("Earning Code for Principal");
                                    EarningCodes.GET(LoanSetup."Earning Code for Principal");
                                    recPayCycle.GET(PayCycle);
                                    PayPeriod.RESET;
                                    PayPeriod.SETRANGE("Pay Cycle", recPayCycle."Pay Cycle");
                                    PayPeriod.SETRANGE("Period Start Date", FromDate);
                                    PayPeriod.FINDFIRST;
                                    FSEarningCodes2.RESET;
                                    FSEarningCodes2.SETRANGE("Journal ID", l_FandFJournal."Journal ID");
                                    FSEarningCodes2.SETRANGE("Employee No.", RecEmployee."No.");
                                    FSEarningCodes2.SETRANGE("Earning Code", LoanSetup."Earning Code for Principal");
                                    FSEarningCodes2.SETRANGE("Payroll Period RecID", PayPeriod."Line No.");
                                    if not FSEarningCodes2.FINDFIRST then begin
                                        FSEarningCodes.RESET;
                                        FSEarningCodes.INIT;
                                        FSEarningCodes."Journal ID" := l_FandFJournal."Journal ID";
                                        FSEarningCodes."Employee No." := RecEmployee."No.";
                                        FSEarningCodes."Earning Code" := LoanSetup."Earning Code for Principal";
                                        FSEarningCodes."Payroll Period RecID" := PayPeriod."Line No.";
                                        FSEarningCodes.INSERT;
                                        FSEarningCodes."Employee Name" := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
                                        FSEarningCodes."Earning Description" := EarningCodes.Description;
                                        FSEarningCodes."Earning Code Group" := EmployeeEarningCodeGroup."Earning Code Group";
                                        EarningCodesRecG.GET(LoanSetup."Earning Code for Principal");
                                        FSEarningCodes."Final Settlement Component" := EarningCodesRecG."Final Settlement Component";
                                        FSEarningCodes."Pay Cycle" := PayCycle;
                                        FSEarningCodes."Payroll Period" := PayPeriod."Pay Cycle" + ':' + FORMAT(PayPeriod."Period Start Date") + ' - ' + FORMAT(NORMALDATE(PayPeriod."Period End Date"));
                                        FSEarningCodes."Pay Period Start" := PayPeriod."Period Start Date";
                                        FSEarningCodes."Pay Period End" := NORMALDATE(PayPeriod."Period End Date");
                                        FSEarningCodes."Earning Code Calc Class" := EmployeeEarningCodes."Earning Code Calc Class";
                                        FSEarningCodes."Earning Code Amount" := LoanInstallmentGeneration."Principal Installment Amount";
                                        FSEarningCodes."Calculation Units" := 1;
                                        FSEarningCodes.Currency := EmployeeEarningCodeGroup.Currency;
                                        FSEarningCodes.MODIFY;
                                    end
                                    else begin
                                        FSEarningCodes2."Earning Code Amount" := FSEarningCodes2."Earning Code Amount" + (LoanInstallmentGeneration."Principal Installment Amount" * -1);
                                        FSEarningCodes2.MODIFY;
                                    end;
                                    LoanSetup.TESTFIELD("Earning Code for Interest");
                                    EarningCodes.GET(LoanSetup."Earning Code for Interest");
                                    FSEarningCodes2.RESET;
                                    FSEarningCodes2.SETRANGE("Journal ID", l_FandFJournal."Journal ID");
                                    FSEarningCodes2.SETRANGE("Employee No.", RecEmployee."No.");
                                    FSEarningCodes2.SETRANGE("Earning Code", LoanSetup."Earning Code for Interest");
                                    FSEarningCodes2.SETRANGE("Payroll Period RecID", PayPeriod."Line No.");
                                    if not FSEarningCodes2.FINDFIRST then begin
                                        FSEarningCodes.RESET;
                                        FSEarningCodes.INIT;
                                        FSEarningCodes."Journal ID" := l_FandFJournal."Journal ID";
                                        FSEarningCodes."Employee No." := RecEmployee."No.";
                                        FSEarningCodes."Earning Code" := LoanSetup."Earning Code for Interest";
                                        FSEarningCodes."Payroll Period RecID" := PayPeriod."Line No.";
                                        FSEarningCodes.INSERT;
                                        FSEarningCodes."Employee Name" := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
                                        FSEarningCodes."Earning Description" := EarningCodes.Description;
                                        FSEarningCodes."Earning Code Group" := EmployeeEarningCodeGroup."Earning Code Group";
                                        EarningCodesRecG.GET(LoanSetup."Earning Code for Interest");
                                        FSEarningCodes."Final Settlement Component" := EarningCodesRecG."Final Settlement Component";
                                        FSEarningCodes."Pay Cycle" := PayCycle;
                                        FSEarningCodes."Payroll Period" := PayPeriod."Pay Cycle" + ':' + FORMAT(PayPeriod."Period Start Date") + ' - ' + FORMAT(NORMALDATE(PayPeriod."Period End Date"));
                                        FSEarningCodes."Pay Period Start" := PayPeriod."Period Start Date";
                                        FSEarningCodes."Pay Period End" := NORMALDATE(PayPeriod."Period End Date");
                                        FSEarningCodes."Earning Code Calc Class" := EmployeeEarningCodes."Earning Code Calc Class";
                                        FSEarningCodes."Earning Code Amount" := LoanInstallmentGeneration."Interest Installment Amount";
                                        FSEarningCodes."Calculation Units" := 1;
                                        FSEarningCodes.Currency := EmployeeEarningCodeGroup.Currency;
                                        FSEarningCodes.MODIFY;
                                    end
                                    else begin
                                        FSEarningCodes2."Earning Code Amount" := FSEarningCodes2."Earning Code Amount" + (LoanInstallmentGeneration."Interest Installment Amount" * -1);
                                        FSEarningCodes2.MODIFY;
                                    end;
                                until LoanInstallmentGeneration.NEXT = 0;
                        until EmployeeLoans.NEXT = 0;
                end;
            until l_FandFJournal.Next() = 0;
        end;
    end;

    procedure CreateBenefitLedger(FromDate: Date; ToDate: Date; l_FandFJournal: Record "Full and Final Calculation"; Worker: Code[20]);
    var
        FSBenefits: Record "FS Benefits";
        EmployeeBenefits: Record "HCM Benefit Wrkr";
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        RecEmployee: Record Employee;
        PayrollStatementEmployee: Record "Payroll Statement Employee";
        PayrollStatementLines: Record "Payroll Statement Lines";
        recPayCycle: Record "Pay Cycles";
        PayPeriod: Record "Pay Periods";
        FSEarningCodes: Record "FS - Earning Code";
        BenefitLedgerAmount: Decimal;
        BenefitLedgerUnits: Decimal;
        PayrollAmount: Decimal;
    begin
        l_FandFJournal.Reset();
        if l_FandFJournal.FindSet() then begin
            repeat
                RecEmployee.GET(Worker);
                EmployeeEarningCodeGroup.RESET;
                EmployeeEarningCodeGroup.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                EmployeeEarningCodeGroup.SETRANGE("Employee Code", Worker);
                EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', ToDate);
                EmployeeEarningCodeGroup.SETFILTER("Valid To", '>=%1|%2', ToDate, 0D);
                if EmployeeEarningCodeGroup.FINDFIRST then begin
                    EmployeeBenefits.RESET;
                    EmployeeBenefits.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    EmployeeBenefits.SETRANGE(Worker, RecEmployee."No.");
                    EmployeeBenefits.SETRANGE(Active, true);
                    EmployeeBenefits.SETFILTER("Short Name", '<>%1', 'ALB');
                    if EmployeeBenefits.FINDSET then
                        repeat
                            CLEAR(BenefitLedgerAmount);
                            CLEAR(BenefitLedgerUnits);
                            CLEAR(PayrollAmount);
                            CLEAR(PayrollStatementEmployee);
                            CLEAR(FSEarningCodes);
                            PayrollStatementEmployee.RESET;
                            PayrollStatementEmployee.SETRANGE(Worker, EmployeeBenefits.Worker);
                            PayrollStatementEmployee.SETRANGE("Pay Period End Date", 12000101D, FromDate);
                            if PayrollStatementEmployee.FINDFIRST then
                                repeat
                                    CLEAR(PayrollStatementLines);
                                    PayrollStatementLines.RESET;
                                    PayrollStatementLines.SETCURRENTKEY("Payroll Statement ID", "Payroll Statment Employee", "Benefit Code", "Payroll Year", "Payroll Month");
                                    PayrollStatementLines.SETRANGE("Payroll Statement ID", PayrollStatementEmployee."Payroll Statement ID");
                                    PayrollStatementLines.SETRANGE("Payroll Statment Employee", PayrollStatementEmployee.Worker);
                                    PayrollStatementLines.SETRANGE("Benefit Code", EmployeeBenefits."Benefit Id");
                                    PayrollStatementLines.SETRANGE("Payroll Year", PayrollStatementEmployee."Payroll Year");
                                    PayrollStatementLines.SETRANGE("Payroll Month", PayrollStatementEmployee."Payroll Month");
                                    PayrollStatementLines.CALCSUMS("Benefit Amount", "Calculation Units");
                                    BenefitLedgerAmount += PayrollStatementLines."Benefit Amount";
                                    BenefitLedgerUnits += PayrollStatementLines."Calculation Units";
                                until PayrollStatementEmployee.NEXT = 0;

                            FSEarningCodes.RESET;
                            FSEarningCodes.SETCURRENTKEY("Journal ID", "Benefit Code");
                            FSEarningCodes.SETRANGE("Journal ID", l_FandFJournal."Journal ID");
                            FSEarningCodes.SETRANGE("Benefit Code", EmployeeBenefits."Benefit Id");
                            FSEarningCodes.CALCSUMS("Benefit Amount");
                            PayrollAmount := FSEarningCodes."Benefit Amount";
                            if (BenefitLedgerAmount <> 0) or (BenefitLedgerUnits <> 0) or (PayrollAmount <> 0) then begin
                                recPayCycle.GET(PayCycle);
                                PayPeriod.RESET;
                                PayPeriod.SETRANGE("Pay Cycle", recPayCycle."Pay Cycle");
                                PayPeriod.SETRANGE("Period Start Date", FromDate);
                                PayPeriod.FINDFIRST;
                                FSBenefits.INIT;
                                FSBenefits."Journal ID" := l_FandFJournal."Journal ID";
                                FSBenefits."Employee No." := EmployeeBenefits.Worker;
                                FSBenefits."Benefit Code" := EmployeeBenefits."Benefit Id";
                                FSBenefits."Payroll Period RecID" := PayPeriod."Line No.";
                                FSBenefits.INSERT;
                                FSBenefits."Benefit Description" := EmployeeBenefits.Description;
                                FSBenefits."Benefit Amount" := BenefitLedgerAmount + PayrollAmount;
                                FSBenefits."Calculation Unit" := BenefitLedgerUnits;
                                FSBenefits."Employee Name" := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
                                FSBenefits.MODIFY;
                            end;
                        until EmployeeBenefits.NEXT = 0;
                end;
            until l_FandFJournal.Next() = 0;
        end;
    end;

    procedure CreateLoanTransLines(FromDate: Date; ToDate: Date; l_FandFJournal: Record "Full and Final Calculation"; Worker: Code[20]);
    var
        EarningCode: Record "Payroll Earning Code";
        FSLoans: Record "FS Loans";
        EmployeeLoans: Record "HCM Loan Table GCC Wrkr";
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        RecEmployee: Record Employee;
        recPayCycle: Record "Pay Cycles";
        PayPeriod: Record "Pay Periods";
        LoanSetup: Record "Loan Type Setup";
        LoanInstallmentGeneration: Record "Loan Installment Generation";
    begin
        l_FandFJournal.Reset();
        if l_FandFJournal.FindSet() then begin
            repeat
                EmployeeEarningCodeGroup.RESET;
                EmployeeEarningCodeGroup.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                EmployeeEarningCodeGroup.SETRANGE("Employee Code", Worker);
                EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', ToDate);
                EmployeeEarningCodeGroup.SETFILTER("Valid To", '>=%1|%2', ToDate, 0D);
                if EmployeeEarningCodeGroup.FINDFIRST then begin
                    EmployeeLoans.RESET;
                    EmployeeLoans.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
                    EmployeeLoans.SETRANGE(Worker, Worker);
                    EmployeeLoans.SETRANGE(Active, true);
                    if EmployeeLoans.FINDFIRST then
                        repeat
                            LoanInstallmentGeneration.RESET;
                            LoanInstallmentGeneration.SETRANGE("Employee ID", EmployeeLoans.Worker);
                            LoanInstallmentGeneration.SETRANGE("Installament Date", CALCDATE('1D', ToDate), 99991231D);
                            LoanInstallmentGeneration.SETRANGE(Loan, EmployeeLoans."Loan Code");
                            LoanInstallmentGeneration.SETRANGE(Status, LoanInstallmentGeneration.Status::Unrecovered);
                            if LoanInstallmentGeneration.FINDFIRST then
                                repeat
                                    if LoanInstallmentGeneration."Principal Installment Amount" <> 0 then begin
                                        LoanSetup.GET(LoanInstallmentGeneration.Loan);
                                        LoanSetup.TESTFIELD("Earning Code for Principal");
                                        recPayCycle.GET(PayCycle);
                                        PayPeriod.RESET;
                                        PayPeriod.SETRANGE("Pay Cycle", recPayCycle."Pay Cycle");
                                        PayPeriod.SETRANGE("Period Start Date", CALCDATE('-CM', LoanInstallmentGeneration."Installament Date"));
                                        PayPeriod.FINDFIRST;
                                        FSLoans.INIT;
                                        FSLoans."Journal ID" := l_FandFJournal."Journal ID";
                                        FSLoans."Employee No." := Worker;
                                        FSLoans.Loan := EmployeeLoans."Loan Code";
                                        FSLoans."Payroll Period RecID" := PayPeriod."Line No.";
                                        FSLoans."EmployeeEarning Code" := EmployeeLoans."Earning Code for Principal";
                                        FSLoans.INSERT;
                                        FSLoans."Loan Request ID" := LoanInstallmentGeneration."Loan Request ID";
                                        FSLoans."Installment Date" := LoanInstallmentGeneration."Installament Date";
                                        FSLoans."Employee Name" := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
                                        FSLoans."EMI Amount" := LoanInstallmentGeneration."Principal Installment Amount" * -1;
                                        FSLoans."Installment Amount" := LoanInstallmentGeneration."Principal Installment Amount" * -1;
                                        FSLoans."Earning Code Group" := EmployeeEarningCodeGroup."Earning Code Group";
                                        FSLoans.Currency := EmployeeEarningCodeGroup.Currency;
                                        FSLoans.MODIFY;
                                    end;

                                    if LoanInstallmentGeneration."Interest Installment Amount" <> 0 then begin
                                        LoanSetup.TESTFIELD("Earning Code for Interest");
                                        FSLoans.RESET;
                                        FSLoans.INIT;
                                        FSLoans."Journal ID" := l_FandFJournal."Journal ID";
                                        FSLoans."Employee No." := Worker;
                                        FSLoans.Loan := EmployeeLoans."Loan Code";
                                        FSLoans."Payroll Period RecID" := PayPeriod."Line No.";
                                        FSLoans."EmployeeEarning Code" := EmployeeLoans."Earning Code for Interest";
                                        FSLoans.INSERT;
                                        FSLoans."Loan Request ID" := LoanInstallmentGeneration."Loan Request ID";
                                        FSLoans."Installment Date" := LoanInstallmentGeneration."Installament Date";
                                        FSLoans."Employee Name" := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
                                        FSLoans."EMI Amount" := LoanInstallmentGeneration."Interest Installment Amount" * -1;
                                        FSLoans."Interest Amount" := LoanInstallmentGeneration."Interest Installment Amount" * -1;
                                        FSLoans."Earning Code Group" := EmployeeEarningCodeGroup."Earning Code Group";
                                        FSLoans.Currency := EmployeeEarningCodeGroup.Currency;
                                        FSLoans.MODIFY;
                                    end;
                                until LoanInstallmentGeneration.NEXT = 0;
                        until EmployeeLoans.NEXT = 0;
                end;
            until l_FandFJournal.Next() = 0;
        end;
    end;

    procedure CalculateLeaveEncashment(FromDate: Date; ToDate: Date; l_FandFJournal: Record "Full and Final Calculation"; Worker: Code[20]);
    var
        RecEmployee: Record Employee;
        recPayCycle: Record "Pay Cycles";
        PayPeriod: Record "Pay Periods";
        LeaveEncashment: Record "Leave Encashment";
        EmployeeEarningCodes: Record "Payroll Earning Code Wrkr";
        PerDayAmount: Decimal;
        TerminationDays: Decimal;
        LeaveCalcDays: Decimal;
    begin
        EmployeeInterimAccruals.RESET;
        EmployeeInterimAccruals.SETRANGE("Worker ID", Worker);
        EmployeeInterimAccruals.SETRANGE("Start Date", FromDate, ToDate);
        if EmployeeInterimAccruals.FINDLAST then begin
            RecEmployee.GET(Worker);
            recPayCycle.GET(PayCycle);
            PayPeriod.RESET;
            PayPeriod.SETRANGE("Pay Cycle", recPayCycle."Pay Cycle");
            PayPeriod.SETRANGE("Period Start Date", FromDate);
            PayPeriod.FINDFIRST;
            LeaveEncashment.INIT;
            LeaveEncashment."Journal ID" := l_FandFJournal."Journal ID";
            LeaveEncashment."Employee No." := Worker;
            LeaveEncashment.INSERT;
            LeaveEncashment."Employee Name" := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
            CLEAR(TerminationDays);
            TerminationDays := l_FandFJournal."Termination Date" - CALCDATE('-CM', l_FandFJournal."Termination Date");
            CLEAR(LeaveCalcDays);
            LeaveCalcDays := ROUND(EmployeeInterimAccruals."Opening Balance Unit" + ((EmployeeInterimAccruals."Monthly Accrual Units" / (CALCDATE('CM', l_FandFJournal."Termination Date") - CALCDATE('-CM', l_FandFJournal."Termination Date"))) * TerminationDays), 1, '=');

            if EmployeeInterimAccruals."Opening Balance Unit" <> 0 then
                LeaveEncashment."Leave Units" := LeaveCalcDays;

            EmployeeEarningCodes.RESET;
            EmployeeEarningCodes.SETRANGE(Worker, RecEmployee."No.");
            EmployeeEarningCodes.SETRANGE("Earning Code Group", RecEmployee."Earning Code Group");
            EmployeeEarningCodes.SETRANGE("Calc Accrual", true);
            if EmployeeEarningCodes.FINDFIRST then
                repeat
                    PerDayAmount += EmployeeEarningCodes."Package Amount";
                until EmployeeEarningCodes.NEXT = 0;
            if PerDayAmount <> 0 then
                PerDayAmount := PerDayAmount / 30;

            LeaveEncashment."Leave Encashment Amount" := LeaveCalcDays * PerDayAmount;
            LeaveEncashment.MODIFY;
        end;
    end;

    procedure GetParameterKey(_FormulaKey: Code[100]; l_Worker: Record Employee; l_FromDate: Date; l_ToDate: Date);
    var
        PayrollFormulaKeyWord: Codeunit "Formula Keyword";
        recPayCycle: Record "Pay Cycles";
        PayPeriod: Record "Pay Periods";
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
    begin
        EmployeeEarningCodeGroup.RESET;
        EmployeeEarningCodeGroup.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
        EmployeeEarningCodeGroup.SETRANGE("Employee Code", l_Worker."No.");
        EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', l_ToDate);
        EmployeeEarningCodeGroup.SETFILTER("Valid To", '>=%1|%2', l_ToDate, 0D);
        if EmployeeEarningCodeGroup.FINDFIRST then begin
            recPayCycle.GET(PayCycle);
            PayPeriod.RESET;
            PayPeriod.SETRANGE("Pay Cycle", recPayCycle."Pay Cycle");
            PayPeriod.SETRANGE("Period Start Date", l_FromDate);
            PayPeriod.FINDFIRST;
            case _FormulaKey of
                'P_PERIODENDDATE':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_PeriodEndDate(l_Worker."No.", PayPeriod."Pay Cycle", PayPeriod."Line No."));
                        ResultContainer[2] := '#DateDataType';
                    end;
                'P_PERIODENDDATEMONTH':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_PeriodEndDateMonth(l_Worker."No.", PayPeriod."Pay Cycle", PayPeriod."Line No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_PERIODENDDATEYEAR':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_PeriodEndDateYear(l_Worker."No.", PayPeriod."Pay Cycle", PayPeriod."Line No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_PERIODSTARTDATE':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_PeriodStartDate(l_Worker."No.", PayPeriod."Pay Cycle", PayPeriod."Line No."));
                        ResultContainer[2] := '#DateDataType';
                    end;
                'P_PERIODSTARTDATEMONTH':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_PeriodStartDateMonth(l_Worker."No.", PayPeriod."Pay Cycle", PayPeriod."Line No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_PERIODSTARTDATEYEAR':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_PeriodStartDateYear(l_Worker."No.", PayPeriod."Pay Cycle", PayPeriod."Line No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_PROBATIONENDDATE':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_ProbationEndDate(l_Worker."No."));
                        ResultContainer[2] := '#DateDataType';
                    end;
                'P_PROBATIONSTARTDATE':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_ProbationStartDate(l_Worker."No."));
                        ResultContainer[2] := '#DateDataType';
                    end;
                'P_ANNUALSALARY':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_AnnualSalary(l_Worker."No.", PayPeriod."Period Start Date", PayPeriod."Period End Date"));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_SERVICEDAYS':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_ServiceDays(l_Worker."No.", NORMALDATE(l_ToDate)));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_DAYSINPERIOD_1':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_DaysInPeriod(l_Worker."No.", PayPeriod."Period Start Date", PayPeriod."Period End Date"));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_CALENDARYEARDAYS':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_CalendarYearDays(PayPeriod."Period Start Date", PayPeriod."Period End Date"));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_COLR':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_COLR(l_Worker."No.", PayPeriod."Period Start Date", PayPeriod."Period End Date"));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_CHILDCOUNT':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_ChildCount(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_CHILDBELOW12':
                    BEGIN
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_ChildCountAgeLessThan12(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    END;
                'P_CHILDABOVE12':
                    BEGIN
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_ChildCountAgeGreaterThan12(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    END;
                'P_CHILDBELOW2':
                    BEGIN
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_ChildCountAgeLessThan2(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    END;
                'P_ADULTTICKETFARE':
                    BEGIN
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_AdultTicketFare(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    END;
                'P_INFANTTICKETFARE':
                    BEGIN
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_InfantTicketFare(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    END;

                'P_CHILDTICKETFARE':
                    BEGIN
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_ChildTicketFare(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    END;

                'P_SPOUSECOUNT':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_SpouseCount(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_EMPLOYEEMARITALSTATUS':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_EmployeeMaritalStatus(l_Worker."No."));
                        ResultContainer[2] := '#TextDataType';
                    end;
                'P_COUNTOFFEMALEMARRIEDCHILD':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_CountOfFemaleMarriedChild(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_EMPLOYEEJOINDATEMONTH':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_EmployeeJoinDateMonth(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_EMPLOYEEJOINDATEYEAR':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_EmployeeJoinDateYear(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_DAYSINPERIOD':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_DaysInPeriod(l_Worker."No.", l_FromDate, l_ToDate));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_DAYSINPAYCYCLEPERIOD':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_DaysInPayCyclePeriod(l_Worker."No.", l_FromDate, l_ToDate));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_PERIODACCRUEDUNITS':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_PeriodAccruedUnits(l_Worker."No.", l_FromDate, l_ToDate));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_TOTALABSENCEHOURS':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_TotalAbsenceHours(l_Worker."No.", l_FromDate, l_ToDate));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_PERMISSIBLEABHRS':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_PermissibleABHrs);
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_SERVICEYEARS':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_SERVICEYEARS(l_Worker."No.", NORMALDATE(l_ToDate)));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_SEPARATIONDATE':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_SeparationDate(l_Worker."No."));
                        ResultContainer[2] := '#DateDataType';
                    end;
                'P_SEPARATIONMONTH':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_SeparationMonth(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_UNSATISFACTORY_PERF_SERYRS':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_UNSATISFACTORY_PERF_SERYRS(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_SEPARATIONREASON':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_SeparationReason(l_Worker."No."));
                        ResultContainer[2] := '#NumericDataType';
                    end;
                'P_EMPLOYEENATIONALITY':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_EMPLOYEENATIONALITY(l_Worker."No."));
                        ResultContainer[2] := '#TextDataType';
                    end;
                'P_LEAVEENCASHMENTUNITS':
                    begin
                        ResultContainer[1] := FORMAT(PayrollFormulaKeyWord.P_LEAVEENCASHMENTUNITS(PayPeriod."Period Start Date", PayPeriod."Period End Date", l_Worker."No.", FandFJournal));
                        ResultContainer[2] := '#NumericDataType';
                    end;
            end;
        end;
    end;

    procedure CreateBenefitLedger_LT(FromDate: Date; ToDate: Date; EarningCodeGroup_P: Code[20]; Worker: Code[20]; VAR openingBalanceBenefitAmount: Decimal; VAR openingBalanceBenefitCU: Decimal; BenefitCode: Code[20])
    var
        FSBenefits: Record "FS Benefits";
        EmployeeBenefits: Record "HCM Benefit Wrkr";
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        RecEmployee: Record Employee;
        PayrollStatementEmployee: Record "Payroll Statement Employee";
        PayrollStatementLines: Record "Payroll Statement Lines";
        recPayCycle: Record "Pay Cycles";
        PayPeriod: Record "Pay Periods";
        FSEarningCodes: Record "FS - Earning Code";
        BenefitLedgerAmount: Decimal;
        BenefitLedgerUnits: Decimal;
        PayrollAmount: Decimal;
        BenefitAdjustJournalHeader: Record "Benefit Adjmt. Journal header";
        BenefitAdjustJournalLine: Record "Benefit Adjmt. Journal Lines";
        HCMBenefitRecL: Record "HCM Benefit";
    begin
        RecEmployee.GET(Worker);
        EmployeeEarningCodeGroup.RESET;
        EmployeeEarningCodeGroup.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
        EmployeeEarningCodeGroup.SETRANGE("Employee Code", Worker);
        EmployeeEarningCodeGroup.SETFILTER("Valid From", '<=%1', ToDate);
        EmployeeEarningCodeGroup.SETFILTER("Valid To", '>=%1|%2', ToDate, 0D);
        IF EmployeeEarningCodeGroup.FINDFIRST THEN BEGIN
            EmployeeBenefits.RESET;
            EmployeeBenefits.SETRANGE("Earning Code Group", EarningCodeGroup_P);
            EmployeeBenefits.SETRANGE(Worker, RecEmployee."No.");
            EmployeeBenefits.SETRANGE(Active, TRUE);
            EmployeeBenefits.SETFILTER("Short Name", '<>%1', 'ALB');
            IF EmployeeBenefits.FINDSET THEN
                REPEAT
                    openingBalanceBenefitAmount := 0;
                    openingBalanceBenefitCU := 0;
                    BenefitAdjustJournalHeader.RESET;
                    BenefitAdjustJournalHeader.SETCURRENTKEY("Pay Period Start", "Pay Period End", Posted);
                    BenefitAdjustJournalHeader.SETRANGE("Pay Period Start", FromDate, ToDate);
                    BenefitAdjustJournalHeader.SETRANGE(Posted, TRUE);
                    IF BenefitAdjustJournalHeader.FINDFIRST THEN
                        REPEAT
                            BenefitAdjustJournalLine.RESET;
                            BenefitAdjustJournalLine.SETCURRENTKEY("Journal No.", "Employee Code", Benefit);
                            BenefitAdjustJournalLine.SETRANGE("Journal No.", BenefitAdjustJournalHeader."Journal No.");
                            BenefitAdjustJournalLine.SETRANGE("Employee Code", Worker);
                            BenefitAdjustJournalLine.SETRANGE(Benefit, BenefitCode);
                            IF BenefitAdjustJournalLine.FINDSET THEN
                                REPEAT
                                    openingBalanceBenefitAmount += BenefitAdjustJournalLine.Amount;
                                    openingBalanceBenefitCU += BenefitAdjustJournalLine."Calculation Units";
                                UNTIL BenefitAdjustJournalLine.NEXT = 0;
                        UNTIL BenefitAdjustJournalHeader.NEXT = 0;
                UNTIL EmployeeBenefits.NEXT = 0;
        END;
    end;

    procedure CreatePayrollAdjmtJournalLines(FromDate: Date;
                                             ToDate: Date;
                                             Worker: Code[20];
                                             VAR EarningCodeAmount: Decimal;
                                             EarningCode: Code[20])
    var
        PayrollAdjmtJrnlHeaderRecL: Record "Payroll Adjmt. Journal header";
        PayrollAdmtJrnlLinesRecL: Record "Payroll Adjmt. Journal Lines";
    begin
        Clear(EarningCodeAmount);
        PayrollAdjmtJrnlHeaderRecL.Reset();
        PayrollAdjmtJrnlHeaderRecL.SetRange("Pay Cycle", PayCycle);
        PayrollAdjmtJrnlHeaderRecL.SetRange("Pay Period Start", FromDate, ToDate);
        PayrollAdjmtJrnlHeaderRecL.SetRange(Posted, true);
        if PayrollAdjmtJrnlHeaderRecL.FindFirst() then begin
            PayrollAdmtJrnlLinesRecL.Reset();
            PayrollAdmtJrnlLinesRecL.SetRange("Journal No.", PayrollAdjmtJrnlHeaderRecL."Journal No.");
            PayrollAdmtJrnlLinesRecL.SetRange("Earning Code", EarningCode);
            if PayrollAdmtJrnlLinesRecL.FindSet() then begin
                repeat
                    EarningCodeAmount += PayrollAdmtJrnlLinesRecL.Amount;
                until PayrollAdmtJrnlLinesRecL.Next() = 0;
            end;
        end;
    end;

    procedure CalculateLeaveEncashment_New(FromDate: Date; ToDate: Date; l_FandFJournal: Record "Full and Final Calculation"; Worker: Code[20]; FianlAmount: Decimal);
    var
        RecEmployee: Record Employee;
        recPayCycle: Record "Pay Cycles";
        PayPeriod: Record "Pay Periods";
        LeaveEncashment: Record "Leave Encashment";
        EmployeeEarningCodes: Record "Payroll Earning Code Wrkr";
        PerDayAmount: Decimal;
        TerminationDays: Decimal;
        LeaveCalcDays: Decimal;
    begin
        EmployeeInterimAccruals.RESET;
        EmployeeInterimAccruals.SETRANGE("Worker ID", Worker);
        EmployeeInterimAccruals.SETRANGE("Start Date", FromDate, ToDate);
        if EmployeeInterimAccruals.FINDLAST then begin
            RecEmployee.GET(Worker);
            recPayCycle.GET(PayCycle);
            PayPeriod.RESET;
            PayPeriod.SETRANGE("Pay Cycle", recPayCycle."Pay Cycle");
            PayPeriod.SETRANGE("Period Start Date", FromDate);
            PayPeriod.FINDFIRST;
            LeaveEncashment.INIT;
            LeaveEncashment."Journal ID" := l_FandFJournal."Journal ID";
            LeaveEncashment."Employee No." := Worker;
            LeaveEncashment.INSERT;
            LeaveEncashment."Employee Name" := RecEmployee."First Name" + ' ' + RecEmployee."Last Name";
            CLEAR(TerminationDays);
            TerminationDays := l_FandFJournal."Termination Date" - CALCDATE('-CM', l_FandFJournal."Termination Date");
            CLEAR(LeaveCalcDays);
            LeaveCalcDays := ROUND(EmployeeInterimAccruals."Opening Balance Unit" + ((EmployeeInterimAccruals."Monthly Accrual Units" / (CALCDATE('CM', l_FandFJournal."Termination Date") - CALCDATE('-CM', l_FandFJournal."Termination Date"))) * TerminationDays), 1, '=');

            if EmployeeInterimAccruals."Opening Balance Unit" <> 0 then
                LeaveEncashment."Leave Units" := LeaveCalcDays;

            EmployeeEarningCodes.RESET;
            EmployeeEarningCodes.SETRANGE(Worker, RecEmployee."No.");
            EmployeeEarningCodes.SETRANGE("Earning Code Group", RecEmployee."Earning Code Group");
            EmployeeEarningCodes.SETRANGE("Calc Accrual", true);
            if EmployeeEarningCodes.FINDFIRST then
                repeat
                    PerDayAmount += EmployeeEarningCodes."Package Amount";
                until EmployeeEarningCodes.NEXT = 0;
            if PerDayAmount <> 0 then
                PerDayAmount := PerDayAmount / 30;

            LeaveEncashment."Leave Encashment Amount" := FianlAmount;
            LeaveEncashment.MODIFY;
        end;
    end;
}