report 60031 Payslip
{
    DefaultLayout = RDLC;
    RDLCLayout = 'HR_Payroll\Layout_Reports\Report-60031-Payslip\payslip.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            column(EmpNo; Employee."No.")
            {
            }
            column(Filters; PayCyclePayPeriod)
            {
            }
            column(CompLogo; CompanyInformation.Picture)
            {
            }
            column(PayMonth; PayMonth)
            {
            }
            column(ValueDate; ValueDate)
            {
            }
            column(PS1; ArabicTextValue[1])
            {
            }
            column(PS2; ArabicTextValue[2])
            {
            }
            column(PS3; ArabicTextValue[3])
            {
            }
            column(PS4; ArabicTextValue[4])
            {
            }
            column(PS5; ArabicTextValue[5])
            {
            }
            column(PS6; ArabicTextValue[6])
            {
            }
            column(PS8; ArabicTextValue[8])
            {
            }
            column(PS9; ArabicTextValue[9])
            {
            }
            column(PS10; ArabicTextValue[10])
            {
            }
            column(PS11; ArabicTextValue[11])
            {
            }
            column(FT1; FT1)
            {
            }
            column(FT2; FT2)
            {
            }
            column(FT3; FT3)
            {
            }
            column(CurrSymbol; Currency.Symbol)
            {
            }
            column(CompName; CompanyInformation.Name)
            {
            }
            column(IBANNumber; EmployeeBankAccountRecG.IBAN)
            {
            }
            column(BankNameinArabic_EmployeeBankAccount; EmployeeBankAccountRecG."Bank Name in Arabic")
            {
            }
            column(BankAccountNumber; EmployeeBankAccountRecG."Bank Acccount Number")
            {
            }
            column(EnglishBankName; EmployeeBankAccountRecG."Bank Name")
            {
            }
            column(TOTALPAYMENTS1; GetAnyArabicWord('TOTALPAYMENTS'))
            {
            }
            column(DEDUCTIONS1; GetAnyArabicWord('DEDUCTIONS'))
            {
            }
            column(TOTALDEDUCTIONS1; GetAnyArabicWord('TOTALDEDUCTIONS'))
            {
            }
            column(NETPAYMENTUS1; GetAnyArabicWord('NETPAYMENTUS'))
            {
            }
            column(NETPAYMENTSR1; GetAnyArabicWord('NETPAYMENTSR'))
            {
            }
            dataitem(PayrollStatementLines; "Payroll Statement Lines")
            {
                DataItemLink = "Payroll Statment Employee" = FIELD("No.");
                DataItemTableView = SORTING("Payroll Statement ID", "Payroll Statment Employee", "Line No.");
                column(EarningCodeDesc; PayrollStatementLines."Payroll Earning Code Desc")
                {
                }
                column(EarningCodeAmount; PayrollStatementLines."Earning Code Amount")
                {
                }
                column(PayrollEmployeeID; PayrollStatementLines."Payroll Statment Employee")
                {
                }
                column(EmpFullName; Employee."First Name" + '  ' + Employee."Middle Name" + '   ' + Employee."Last Name")
                {
                }
                column(TotalDeductions; TotalDeductions)
                {
                }
                column(TotalPayments; TotalPayments)
                {
                }
                column(EarningCodeArabicName; GetEarnigCodeArabic(PayrollStatementLines."Payroll Earning Code"))
                {
                }
                column(NetPaymentinSAR; NetPaymentinSAR)
                {
                }
                column(PayrollMonthArabic; GetArabicMonths(PayrollStatementLines."Payroll Month"))
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if PayrollStatementLines."Earning Code Amount" < 0 then
                        TotalDeductions += PayrollStatementLines."Earning Code Amount"
                    else
                        TotalPayments += PayrollStatementLines."Earning Code Amount";
                    NetPaymentinSAR := CurrencyExchangeRate.ExchangeAmount(TotalPayments + TotalDeductions, Currency.Code, PayrollStatementLines."Currency Code", TODAY);
                end;

                trigger OnPreDataItem();
                begin
                    TotalDeductions := 0;
                    TotalPayments := 0;
                    NetPaymentinSAR := 0;
                    PayrollStatementLines.SETRANGE("Payroll Pay Cycle", PayCycle);
                    PayrollStatementLines.SETRANGE("Payroll Month", FORMAT(PayMonth));
                    PayrollStatementLines.SETRANGE("Payroll Year", PayYear);
                end;
            }
            dataitem("Employee Bank Account"; "Employee Bank Account")
            {
                DataItemLink = "Employee Id" = FIELD("No.");
                DataItemTableView = SORTING("Employee Id", "Bank Code", "Bank Acccount Number") WHERE(Primary = FILTER(true));
                column(BankAccountNumber1; "Employee Bank Account"."Bank Acccount Number")
                {
                }
                column(BankName; "Employee Bank Account"."Bank Name")
                {
                }
                column(IBAN_EmployeeBankAccount; "Employee Bank Account".IBAN)
                {
                }
                column(BankNameinArabic_EmployeeBankAccount1; "Employee Bank Account"."Bank Name in Arabic")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                EmployeeEarningCodeGroups.RESET;
                EmployeeEarningCodeGroups.SETRANGE("Employee Code", Employee."No.");
                if EmployeeEarningCodeGroups.FINDFIRST then
                    if Currency.GET(EmployeeEarningCodeGroups.Currency) then;

                if ArabicText.FINDSET then
                    repeat

                        case ArabicText."Eng Code" of
                            'PS1':
                                ArabicTextValue[1] := ArabicText."Arabic Text";
                            'PS2':
                                ArabicTextValue[2] := ArabicText."Arabic Text";
                            'PS3':
                                ArabicTextValue[3] := ArabicText."Arabic Text";
                            'PS4':
                                ArabicTextValue[4] := ArabicText."Arabic Text";
                            'PS5':
                                ArabicTextValue[5] := ArabicText."Arabic Text";
                            'PS6':
                                ArabicTextValue[6] := FORMAT(PayCyclePayPeriod) + ' ' + ArabicText."Arabic Text";
                            'PS8':
                                ArabicTextValue[8] := ArabicText."Arabic Text";
                            'PS9':
                                ArabicTextValue[9] := ArabicText."Arabic Text";
                            'PS10':
                                ArabicTextValue[10] := ArabicText."Arabic Text";
                            'PS11':
                                ArabicTextValue[11] := ':' + ArabicText."Arabic Text";
                        end;

                        if ArabicText."Eng Code" = 'PS13' then
                            ValueDate := ArabicText."Arabic Text";
                        if ArabicText."Eng Code" = 'FT-1 60031' then
                            FT1 := ArabicText."Arabic Text";
                        if ArabicText."Eng Code" = 'FT-2 60031' then
                            FT2 := ArabicText."Arabic Text";
                        if ArabicText."Eng Code" = 'FT-3 60031' then
                            FT3 := ArabicText."Arabic Text";
                    until ArabicText.NEXT = 0;

                EmployeeBankAccountRecG.RESET;
                EmployeeBankAccountRecG.SETRANGE("Employee Id", Employee."No.");
                EmployeeBankAccountRecG.SETRANGE(Primary, true);
                if EmployeeBankAccountRecG.FINDFIRST then;
            end;

            trigger OnPreDataItem();
            begin
                PayCyclePayPeriod := FORMAT(PayYear);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Pay Cycle"; PayCycle)
                {
                    TableRelation = "Pay Cycles"."Pay Cycle";
                    ApplicationArea = All;
                }
                field("Pay Period"; PayPeriodCode)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PayPeriod.RESET;
                        PayPeriod.SETRANGE("Pay Cycle", PayCycle);
                        if PAGE.RUNMODAL(PAGE::"Pay Periods List", PayPeriod) = ACTION::LookupOK then begin
                            PayPeriodCode := PayPeriod.Month + ' ' + FORMAT(PayPeriod.Year);
                            PayMonth := PayPeriod.Month;
                            PayYear := PayPeriod.Year;
                        end;
                    end;
                }
            }
        }

    }

    trigger OnPreReport();
    begin
        if CompanyInformation.GET() then
            CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        PayCyclePayPeriod: Text;
        PayYear: Integer;
        PayMonth: Code[50];
        PayrollStatementLinesPosTemp: Record "Payroll Statement Lines" temporary;
        PayrollStatementLinesNegTemp: Record "Payroll Statement Lines" temporary;
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
        Currency: Record Currency;
        TotalDeductions: Decimal;
        TotalPayments: Decimal;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        NetPaymentinSAR: Decimal;
        PayCycle: Code[50];
        PayPeriodCode: Code[50];
        PayPeriod: Record "Pay Periods";
        ArabicText: Record "Arabic Translate Table";
        ArabicTextValue: array[12] of Code[1024];
        ValueDate: Code[50];
        EmployeeBankAccountRecG: Record "Employee Bank Account";
        FT1: Text;
        FT2: Text;
        FT3: Text;

    local procedure GetArabicMonths(EngMonths_P: Code[90]): Text;
    var
        ArabicTranslateTableRecL: Record "Arabic Translate Table";
    begin
        ArabicTranslateTableRecL.RESET;
        if ArabicTranslateTableRecL.GET(EngMonths_P) then
            exit(ArabicTranslateTableRecL."Arabic Text");
    end;

    local procedure GetAnyArabicWord(EngWord: Code[90]): Text;
    var
        ArabicTranslateTableRecL: Record "Arabic Translate Table";
    begin
        ArabicTranslateTableRecL.RESET;
        if ArabicTranslateTableRecL.GET(EngWord) then
            exit(ArabicTranslateTableRecL."Arabic Text");

    end;

    local procedure GetEarnigCodeArabic(Code_P: Code[30]): Text;
    var
        PayrollEarningCodeRecG: Record "Payroll Earning Code";
    begin
        PayrollEarningCodeRecG.RESET;
        if PayrollEarningCodeRecG.GET(Code_P) then
            exit(PayrollEarningCodeRecG."Arabic name");
    end;
}