codeunit 70152 "ESS RC Page"
{
    var
        UserSetupRecG: Record "User Setup";

    procedure GetEmployeeID(UserIDTxt: Code[150]): Code[20]
    begin
        UserSetupRecG.Reset();
        UserSetupRecG.SetRange("User ID", UserIDTxt);
        if UserSetupRecG.FindFirst() then;

        UserSetupRecG.TestField("Employee Id");

        exit(UserSetupRecG."Employee Id");
    end;

    procedure FindandFillLoginEmployeeTeams(LoginUSerL: Code[20])
    var
        EmployeePayrollPositionRecL: Record "Payroll Job Pos. Worker Assign";
        PayRollPosRecL: Record "Payroll Position";
        MyTeamsRecL: Record "MY Teams List";
    begin
        MyTeamsRecL.Reset();
        MyTeamsRecL.SetRange("Login Employee No.", GetEmployeeID(LoginUSerL));
        if MyTeamsRecL.FindSet() then
            MyTeamsRecL.DeleteAll();

        EmployeePayrollPositionRecL.Reset();
        EmployeePayrollPositionRecL.SetRange("Is Primary Position", true);
        EmployeePayrollPositionRecL.SetRange(Worker, GetEmployeeID(LoginUSerL));
        if EmployeePayrollPositionRecL.FindFirst() then begin
            PayRollPosRecL.Reset();
            PayRollPosRecL.SetRange("Reports to Position", EmployeePayrollPositionRecL."Position ID");
            if PayRollPosRecL.FindSet() then
                repeat
                    MyTeamsRecL.Init();
                    MyTeamsRecL."Entry No" := 0;
                    MyTeamsRecL.Validate("Login Employee No.", EmployeePayrollPositionRecL.Worker);
                    MyTeamsRecL.Validate("Login Employee Position", EmployeePayrollPositionRecL."Position ID");
                    MyTeamsRecL.Validate("Reporting's Position ID", PayRollPosRecL."Position ID");
                    MyTeamsRecL.Validate("Reporting's Employee ID", GetPositionEmployeeID(PayRollPosRecL."Position ID"));
                    MyTeamsRecL.Insert(true);
                until PayRollPosRecL.Next() = 0;
        end;
    end;

    procedure GetPositionEmployeeID(PositionCode: Code[20]): Code[20]
    var
        EmployeePayrollPositionRecL: Record "Payroll Job Pos. Worker Assign";
        PayRollPosRecL: Record "Payroll Position";
        MyTeamsRecL: Record "MY Teams List";
    begin
        EmployeePayrollPositionRecL.Reset();
        EmployeePayrollPositionRecL.SetRange("Position ID", PositionCode);
        if EmployeePayrollPositionRecL.FindFirst() then
            exit(EmployeePayrollPositionRecL.Worker);
    end;
}