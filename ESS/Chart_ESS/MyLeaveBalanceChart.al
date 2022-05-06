page 70177 "My Leave Balance Chart"
{
    Caption = 'My Leave Balance';
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                grid(MyGrid)
                {
                    ShowCaption = false;
                    group("General Info")
                    {
                        ShowCaption = false;
                        usercontrol(Demo; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                        {
                            ApplicationArea = All;
                            trigger AddInReady()
                            var
                                Buffer: Record "Business Chart Buffer" temporary;
                            begin
                                Buffer.Initialize();
                                Buffer.AddMeasure(' Leaves ', 1, Buffer."Data Type"::Decimal, 17);
                                Buffer.SetXAxis('Employee Leave', Buffer."Data Type"::String);
                                Buffer.AddColumn('Leaves Balance');
                                Buffer.SetValueByIndex(0, 0, TotalLeaveG - BalanceLeaveG);
                                Buffer.AddColumn('Leaves Consumed');
                                Buffer.SetValueByIndex(0, 1, (BalanceLeaveG));
                                Buffer.Update(CurrPage.Demo);
                            end;
                        }
                    }
                    group("Address Details")
                    {
                        ShowCaption = false;
                        grid(Grid2)
                        {
                            ShowCaption = false;
                            group(GridForm)
                            {
                                ShowCaption = false;
                                usercontrol(html; HTML)
                                {
                                    ApplicationArea = All;
                                    trigger ControlReady()
                                    var
                                    begin
                                        CurrPage.html.Render(GenerateTable());
                                    end;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        TextBuilderL: TextBuilder;
    begin
        Clear(LeaveDetailsG);
        Clear(TotalLeaveG);
        Clear(BalanceLeaveG);
        Clear(CarryForwardLeavesG);
        UserSetupRecL.Reset();
        if UserSetupRecL.Get(Database.UserId) then begin
            UserSetupRecL.TestField("Employee Id");
            BalanceLeaveG := GetEmployeeAnnualLeaveBalance(UserSetupRecL."Employee Id");
            TotalLeaveG := GetEmployeeTotalAnnualLeave(UserSetupRecL."Employee Id");
            CarryForwardLeavesG := GetEmployeeCarryForwardLeaves(UserSetupRecL."Employee Id");
            TextBuilderL.AppendLine(' Entitlement Leaves' + ': ' + Format(TotalLeaveG));
            TextBuilderL.AppendLine(' Approved Leaves ' + ': ' + Format(BalanceLeaveG));
            TextBuilderL.AppendLine(' Balance Leaves' + ': ' + Format(TotalLeaveG - BalanceLeaveG));
            TextBuilderL.AppendLine(' Approved Leaves ' + ': ' + Format(CarryForwardLeavesG));
            TextBuilderL.AppendLine('_________________________________');
            TextBuilderL.AppendLine(' Net Balance Leaves' + ': ' + Format((TotalLeaveG - BalanceLeaveG) + CarryForwardLeavesG));
            LeaveDetailsG := TextBuilderL.ToText();
            OpenMore := 'View More..';
        end;

    end;

    trigger OnAfterGetRecord()
    var
        TextBuilderL: TextBuilder;
    begin
        BalanceLeaveG := GetEmployeeAnnualLeaveBalance(UserSetupRecL."Employee Id");
        TotalLeaveG := GetEmployeeTotalAnnualLeave(UserSetupRecL."Employee Id");
    end;

    var
        TotalLeaveG: Decimal;
        BalanceLeaveG: Decimal;
        LeaveDetailsG: Text;
        UserSetupRecL: Record "User Setup";
        OpenMore: Text[15];
        CarryForwardLeavesG: Decimal;

    procedure GetEmployeeAnnualLeaveBalance(Employee_P: Code[20]): Decimal
    var
        EmployeeErnCodeGrpRecL: Record "Employee Earning Code Groups";
        HCMLeaveTypeWrkrRecL: Record "HCM Leave Types Wrkr";
        AccuralComponentEmployeeRecL: Record "Accrual Components";
        EmplIntrimAccRecL: Record "Employee Interim Accurals";
        FirstDayOfYear: Date;
        LastDayOfYear: Date;
        CountL: Decimal;
    begin
        Clear(CountL);
        Clear(FirstDayOfYear);
        Clear(LastDayOfYear);

        FirstDayOfYear := CALCDATE('<-CY>', WorkDate());
        LastDayOfYear := CALCDATE('<CY>', WorkDate());

        EmployeeErnCodeGrpRecL.Reset();
        EmployeeErnCodeGrpRecL.SetRange("Employee Code", Employee_P);
        EmployeeErnCodeGrpRecL.SetFilter("Valid To", '%1', 0D);
        if EmployeeErnCodeGrpRecL.FindFirst() then begin
            HCMLeaveTypeWrkrRecL.Reset();
            HCMLeaveTypeWrkrRecL.SetRange(Accrued, true);
            HCMLeaveTypeWrkrRecL.SetRange(Worker, Employee_P);
            HCMLeaveTypeWrkrRecL.SetRange("Earning Code Group", EmployeeErnCodeGrpRecL."Earning Code Group");
            if HCMLeaveTypeWrkrRecL.FindFirst() then begin
                AccuralComponentEmployeeRecL.Reset();
                AccuralComponentEmployeeRecL.SetRange("Accrual ID", HCMLeaveTypeWrkrRecL."Accrual ID");
                if AccuralComponentEmployeeRecL.FindFirst() then begin
                    EmplIntrimAccRecL.Reset();
                    EmplIntrimAccRecL.SetRange("Accrual ID", AccuralComponentEmployeeRecL."Accrual ID");
                    EmplIntrimAccRecL.SetRange("Worker ID", Employee_P);
                    EmplIntrimAccRecL.SetFilter("Start Date", '%1..%2', FirstDayOfYear, LastDayOfYear);
                    if EmplIntrimAccRecL.FindSet() then begin
                        repeat
                            CountL += EmplIntrimAccRecL."Leaves Consumed Units";
                        until EmplIntrimAccRecL.Next() = 0;
                    end;
                    exit(CountL);
                end;
            end;
        end;
    end;

    procedure GetEmployeeTotalAnnualLeave(Employee_P: Code[20]) TotalAMT: Decimal
    var
        EmployeeErnCodeGrpRecL: Record "Employee Earning Code Groups";
        HCMLeaveTypeWrkrRecL: Record "HCM Leave Types Wrkr";
        AccuralComponentEmployeeRecL: Record "Accrual Components";
        EmplIntrimAccRecL: Record "Employee Interim Accurals";
        EmployeeInterimAccuralsL: Record "Employee Interim Accurals";
        YearL: Integer;
    begin
        EmployeeErnCodeGrpRecL.Reset();
        EmployeeErnCodeGrpRecL.SetRange("Employee Code", Employee_P);
        EmployeeErnCodeGrpRecL.SetFilter("Valid To", '%1', 0D);
        if EmployeeErnCodeGrpRecL.FindFirst() then begin
            HCMLeaveTypeWrkrRecL.Reset();
            HCMLeaveTypeWrkrRecL.SetRange(Accrued, true);
            HCMLeaveTypeWrkrRecL.SetRange(Worker, Employee_P);
            HCMLeaveTypeWrkrRecL.SetRange("Earning Code Group", EmployeeErnCodeGrpRecL."Earning Code Group");
            if HCMLeaveTypeWrkrRecL.FindFirst() then begin
                EmployeeInterimAccuralsL.Reset();
                Clear(YearL);
                YearL := Date2DMY(WorkDate(), 3);
                EmployeeInterimAccuralsL.SetRange("Accrual ID", HCMLeaveTypeWrkrRecL."Accrual ID");
                EmployeeInterimAccuralsL.SetFilter("Start Date", '>=%1', DMY2Date(01, 01, YearL));
                EmployeeInterimAccuralsL.SetFilter("End Date", '<=%1', DMY2Date(31, 01, YearL + 1));
                EmployeeInterimAccuralsL.SetRange("Worker ID", HCMLeaveTypeWrkrRecL.Worker);
                EmployeeInterimAccuralsL.CalcSums("Monthly Accrual Units", "Adjustment Units");
                TotalAMT := EmployeeInterimAccuralsL."Monthly Accrual Units" + EmployeeInterimAccuralsL."Adjustment Units";
                EmployeeInterimAccuralsL.SetRange("Carryforward Month", true);
                EmployeeInterimAccuralsL.CalcSums("Opening Balance Unit", "Carryforward Deduction");
                TotalAMT += EmployeeInterimAccuralsL."Opening Balance Unit" + EmployeeInterimAccuralsL."Carryforward Deduction";
            end;
        end;
    end;

    procedure GetEmployeeCarryForwardLeaves(Employee_P: Code[20]): Decimal
    var
        EmployeeErnCodeGrpRecL: Record "Employee Earning Code Groups";
        HCMLeaveTypeWrkrRecL: Record "HCM Leave Types Wrkr";
        AccuralComponentEmployeeRecL: Record "Accrual Components";
        EmplIntrimAccRecL: Record "Employee Interim Accurals";
        FirstDayOfYear: Date;
        LastDayOfYear: Date;
        LastYearStartDate: Date;
        CountL: Decimal;
    begin
        Clear(CountL);
        Clear(LastYearStartDate);
        Clear(FirstDayOfYear);
        Clear(LastDayOfYear);
        LastYearStartDate := CALCDATE('-1Y', WorkDate());
        FirstDayOfYear := CALCDATE('<-CY>', WorkDate());
        LastDayOfYear := CALCDATE('<CY>', WorkDate());
        EmployeeErnCodeGrpRecL.Reset();
        EmployeeErnCodeGrpRecL.SetRange("Employee Code", Employee_P);
        EmployeeErnCodeGrpRecL.SetFilter("Valid To", '%1', 0D);
        if EmployeeErnCodeGrpRecL.FindFirst() then begin
            HCMLeaveTypeWrkrRecL.Reset();
            HCMLeaveTypeWrkrRecL.SetRange(Accrued, true);
            HCMLeaveTypeWrkrRecL.SetRange(Worker, Employee_P);
            HCMLeaveTypeWrkrRecL.SetRange("Earning Code Group", EmployeeErnCodeGrpRecL."Earning Code Group");
            if HCMLeaveTypeWrkrRecL.FindFirst() then begin
                AccuralComponentEmployeeRecL.Reset();
                AccuralComponentEmployeeRecL.SetRange("Accrual ID", HCMLeaveTypeWrkrRecL."Accrual ID");
                if AccuralComponentEmployeeRecL.FindFirst() then begin
                    EmplIntrimAccRecL.Reset();
                    EmplIntrimAccRecL.SetRange("Accrual ID", AccuralComponentEmployeeRecL."Accrual ID");
                    EmplIntrimAccRecL.SetRange("Worker ID", Employee_P);
                    EmplIntrimAccRecL.SetFilter("Start Date", '%1..%2', FirstDayOfYear, LastDayOfYear);
                    EmplIntrimAccRecL.SetRange("Carryforward Month", true);
                    if EmplIntrimAccRecL.FindFirst() then begin
                        CountL := EmplIntrimAccRecL."Closing Balance" - EmplIntrimAccRecL."Monthly Accrual Units";
                    end;
                    exit(CountL);
                end;
            end;
        end;
    end;

    local procedure GenerateTable(): Text
    var
        htmlTags: Text;
    begin
        Clear(LeaveDetailsG);
        Clear(TotalLeaveG);
        Clear(BalanceLeaveG);
        Clear(CarryForwardLeavesG);
        UserSetupRecL.Reset();
        if UserSetupRecL.Get(Database.UserId) then begin
            UserSetupRecL.TestField("Employee Id");
            BalanceLeaveG := GetEmployeeAnnualLeaveBalance(UserSetupRecL."Employee Id");
            TotalLeaveG := GetEmployeeTotalAnnualLeave(UserSetupRecL."Employee Id");
            CarryForwardLeavesG := GetEmployeeCarryForwardLeaves(UserSetupRecL."Employee Id");
            Clear(htmlTags);
            htmlTags := '<style type="text/css">' +
                        'table {font-family: arial, sans-serif;border-collapse: collapse; width: 100%;font-size: 14px;}' +
                        'tr:hover{  background-color: #0F0121;  color:white;}' +
                        'td, th {  border: 0px solid #dddddd;text-align: left; padding: 7px;}' +
                        '.LastLine{ background-color: #C4E7E9;  color:black;font-weight: 550;}' +
                        '</style>' +
                        '<table>' +
                        '<tr><td > Entitled Leaves </td> <td >' + Format(TotalLeaveG) + '</td></tr>' +
                        '<tr><td > Consumed Leaves </td> <td >' + Format(BalanceLeaveG) + '</td> </tr>' +
'<tr class="LastLine"><td > Net Leaves </td> <td>' + Format((TotalLeaveG - BalanceLeaveG)) + '</td></tr>' +
                        '</tbody></table>';
            exit(htmlTags);
        end;
    end;
}