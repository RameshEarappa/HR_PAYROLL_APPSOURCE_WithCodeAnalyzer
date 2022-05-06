codeunit 70012 "Gen Payroll"
{
    procedure InserPayComponent(EmpResultTableRecL: Record "Emp. Result Table";
                                RecPayrollStatement: Record "Payroll Statement";
                                PayrollStatementEmployee: Record "Payroll Statement Employee";
                                RecEmployee: Record Employee;
                                EmployeeEarningCodes: Record "Payroll Earning Code Wrkr";
                                EmployeeBenefits: Record "HCM Benefit Wrkr";
                                 EmployeeEarningCodeGroup: Record "Employee Earning Code Groups")
    var
        TempDataTable: Record "Temp Datatable Data";
        PayComponentRowCollectionRecL: Record "Emp. Result Table";
        PayrollStatementTransLines2: Record "Payroll Statement Emp Trans.";
        PayrollStatementTransLines: Record "Payroll Statement Emp Trans.";
        Value: Variant;
        BenefitRowCollectionRecL: Record "Emp. Result Table";
    begin
        // Start @BC DLL
        PayComponentRowCollectionRecL.Copy(EmpResultTableRecL);
        // Stop @BC DLL
        // @BC DLL  Below Code need to remove start
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
                //Temp Data
                // @BC DLL STOP
                if (FORMAT(PayComponentRowCollectionRecL.FormulaType) = 'P') and (FORMAT(PayComponentRowCollectionRecL.BaseCode) = EmployeeEarningCodes."Earning Code") then begin
                    PayrollStatementTransLines2.RESET;
                    PayrollStatementTransLines2.SETRANGE("Payroll Statement ID", RecPayrollStatement."Payroll Statement ID");
                    PayrollStatementTransLines2.SETRANGE("Payroll Statment Employee", RecEmployee."No.");
                    if PayrollStatementTransLines2.FINDLAST then;
                    PayrollStatementTransLines.INIT;
                    PayrollStatementTransLines."Payroll Statement ID" := RecPayrollStatement."Payroll Statement ID";
                    PayrollStatementTransLines."Payroll Statment Employee" := RecEmployee."No.";
                    PayrollStatementTransLines."Line No." := PayrollStatementTransLines2."Line No." + 10000;
                    PayrollStatementTransLines.INSERT;
                    PayrollStatementTransLines.Voucher := PayrollStatementEmployee.Voucher;
                    PayrollStatementTransLines.Worker := PayrollStatementEmployee.Worker;
                    PayrollStatementTransLines."Employee Name" := PayrollStatementEmployee."Employee Name";
                    PayrollStatementTransLines."Payroll Pay Cycle" := PayrollStatementEmployee."Payroll Pay Cycle";
                    PayrollStatementTransLines."Payroll Pay Period" := PayrollStatementEmployee."Payroll Pay Period";
                    PayrollStatementTransLines."Payroll Month" := PayrollStatementEmployee."Payroll Month";
                    PayrollStatementTransLines."Payroll Year" := PayrollStatementEmployee."Payroll Year";
                    PayrollStatementTransLines."Currency Code" := PayrollStatementEmployee."Currency Code";
                    PayrollStatementTransLines."Earning Code Type" := PayrollStatementTransLines."Earning Code Type"::"Pay Component";
                    PayrollStatementTransLines."Earniing Code Short Name" := EmployeeEarningCodes."Short Name";
                    PayrollStatementTransLines."Payroll Earning Code" := EmployeeEarningCodes."Earning Code";
                    PayrollStatementTransLines."Payroll Earning Code Desc" := EmployeeEarningCodes.Description;
                    Value := PayComponentRowCollectionRecL.Result1;
                    EVALUATE(PayrollStatementTransLines."Calculation Units", Value);
                    Value := PayComponentRowCollectionRecL.Result2;
                    EVALUATE(PayrollStatementTransLines."Earning Code Amount", Value);
                    Value := PayComponentRowCollectionRecL.Result3;
                    EVALUATE(PayrollStatementTransLines."Per Unit Amount", Value);
                    PayrollStatementTransLines.MODIFY;
                end;
            // @BC DLL //end;
            until PayComponentRowCollectionRecL.Next() = 0
        end;
        // @BC DLL STOP


        //#################################################################################################

        EmployeeBenefits.RESET;
        EmployeeBenefits.SETRANGE("Earning Code Group", EmployeeEarningCodeGroup."Earning Code Group");
        EmployeeBenefits.SETRANGE(Worker, RecEmployee."No.");
        EmployeeBenefits.SETRANGE(Active, true);
        if EmployeeBenefits.FINDSET then
            repeat
                // @BC DLL START
                // @BC DLL //BenefitRowCollection := ResultTable.Rows;
                BenefitRowCollectionRecL.Copy(EmpResultTableRecL);
                BenefitRowCollectionRecL.Reset();
                BenefitRowCollectionRecL.SetCurrentKey("Entry No.");
                if BenefitRowCollectionRecL.FindSet() then begin
                    repeat
                        //Temp Data
                        if (FORMAT(BenefitRowCollectionRecL.FormulaType) = 'B') and (FORMAT(BenefitRowCollectionRecL.BaseCode) = EmployeeBenefits."Short Name") then begin
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
                            PayrollStatementTransLines2.RESET;
                            PayrollStatementTransLines2.SETRANGE("Payroll Statement ID", RecPayrollStatement."Payroll Statement ID");
                            PayrollStatementTransLines2.SETRANGE("Payroll Statment Employee", RecEmployee."No.");
                            if PayrollStatementTransLines2.FINDLAST then;
                            PayrollStatementTransLines.INIT;
                            PayrollStatementTransLines."Payroll Statement ID" := RecPayrollStatement."Payroll Statement ID";
                            PayrollStatementTransLines."Payroll Statment Employee" := RecEmployee."No.";
                            PayrollStatementTransLines."Line No." := PayrollStatementTransLines2."Line No." + 10000;
                            PayrollStatementTransLines.INSERT;
                            PayrollStatementTransLines.Voucher := PayrollStatementEmployee.Voucher;
                            PayrollStatementTransLines.Worker := PayrollStatementEmployee.Worker;
                            PayrollStatementTransLines."Employee Name" := PayrollStatementEmployee."Employee Name";
                            PayrollStatementTransLines."Payroll Pay Cycle" := PayrollStatementEmployee."Payroll Pay Cycle";
                            PayrollStatementTransLines."Payroll Pay Period" := PayrollStatementEmployee."Payroll Pay Period";
                            PayrollStatementTransLines."Payroll Month" := PayrollStatementEmployee."Payroll Month";
                            PayrollStatementTransLines."Payroll Year" := PayrollStatementEmployee."Payroll Year";
                            PayrollStatementTransLines."Earning Code Type" := PayrollStatementTransLines."Earning Code Type"::Benefit;
                            PayrollStatementTransLines."Currency Code" := PayrollStatementEmployee."Currency Code";
                            PayrollStatementTransLines."Benefit Short Name" := EmployeeBenefits."Short Name";
                            PayrollStatementTransLines."Benefit Code" := EmployeeBenefits."Benefit Id";
                            PayrollStatementTransLines."Benefit Description" := EmployeeBenefits.Description;
                            Value := BenefitRowCollectionRecL.Result1;
                            EVALUATE(PayrollStatementTransLines."Calculation Units", Value);
                            Value := BenefitRowCollectionRecL.Result2;
                            EVALUATE(PayrollStatementTransLines."Benefit Amount", Value);
                            Value := BenefitRowCollectionRecL.Result2;
                            EVALUATE(PayrollStatementTransLines."Per Unit Amount", Value);
                            PayrollStatementTransLines.MODIFY;
                        end;
                    until BenefitRowCollectionRecL.Next() = 0;
                end;
            until EmployeeBenefits.NEXT = 0;
        //Employee Loans
    end;
}