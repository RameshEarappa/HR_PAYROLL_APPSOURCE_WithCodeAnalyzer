page 70191 "DME Employee Picture 3"
{
    Caption = 'Employee Details';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            field(Image; Rec.Image)
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the picture of the employee.';
            }
            field("Employee ID"; Rec."No.")
            {
                ApplicationArea = All;
            }
            field("Employee Name"; Rec.FullName())
            {
                ApplicationArea = Basic, Suite;
            }
            field("Service Years"; ServiceYearG)
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 1;
            }
            field("Earning Code Group"; EarningCodeGroupG)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Department; DepartmentName)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Position; PositionName)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Years In Current Position"; GetEmployeeCrrPos)
            {
                ApplicationArea = Basic, Suite;
                DecimalPlaces = 1;
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    trigger OnAfterGetRecord()
    begin
        SetEditableOnPictureActions;
    end;

    var
        Camera: Codeunit Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        EmpName: Text;
        DepartmentName: Text[150];
        PositionName: Text[150];
        WelComtex: Label 'Welcome ';
        PayrollDepartment: Record "Payroll Department";
        PayrollJobTitle: Record "Payroll Job Title";
        UserSetup: Record "User Setup";
        EmployeeDetails: Text;
        ServiceYearG: Decimal;
        EarningCodeGroupG: Text;
        EarniningCode: Record "Employee Earning Code Groups";


    local procedure SetEditableOnPictureActions()
    begin
        Clear(EarniningCode);
        EarniningCode.Reset();
        EarniningCode.SetRange("Employee Code", Rec."No.");
        EarniningCode.SetFilter("Valid To", '%1', 0D);
        if EarniningCode.FindFirst() then
            EarningCodeGroupG := EarniningCode.Description;

        ServiceYearG := (((Today - Rec."Joining Date") / 365));
        DepartmentName := GetEmployeeDepartment(Rec."No.");
        PositionName := GetEmployeeDesignation(Rec."No.");
    end;

    local procedure GenerateEmployeeDetails(): Text
    var
        htmlTags: Text;
    begin
        Clear(htmlTags);

        EmpName := Rec.FullName;

        htmlTags := '<style type="text/css">' +
                    'table {font-family: arial, sans-serif;border-collapse: collapse; width: 100%;font-size: 12px;height:100%}' +
                    'tr:hover{  background-color: #0F0121;  color:white;}' +
                    'td, th {  border: 0px solid #dddddd;text-align: left; padding: 2px;}' +
                    '.LastLine{ background-color: #C4E7E9;  color:black;font-weight: 550;}' +
                    '</style>' +
                    '<table>' +
                    '<tr><td > <B> No. </B> </td> <td >' + Format(Rec."No.") + '</td></tr>' +
                    '<tr><td > <B> First Name </B></td> <td >' + Format(Rec."First Name") + '</td> </tr>' +
                    '<tr><td > <B> Middle Name </B></td> <td >' + Format(Rec."Middle Name") + '</td> </tr>' +
                    '<tr><td > <B> Joining Date </B></td> <td >' + Format(Rec."Joining Date") + '</td> </tr>' +
                    '<tr><td > <B> Service Year (Years In Company) </B></td> <td >' + Format(((Today - Rec."Joining Date") / 365), 0, '<Sign><Integer><Decimals,3>') + '</td> </tr>' +
                    '<tr><td > <B> Earning Code Group </B></td> <td >' + Format(EarniningCode.Description) + '</td> </tr>' +
                    '<tr><td > <B> Department </B></td> <td>' + Format(DepartmentName) + '</td> </tr>' +
                    '<tr><td > <B> Position </B> </td> <td >' + Format(PositionName) + '</td></tr>' +
                    '<tr><td > <B> Years In Current Position </B> </td> <td >' + Format(GetEmployeeCrrPos, 0, '<Sign><Integer><Decimals,3>') + '</td></tr>' +
                    '</tbody></table>';
        exit(htmlTags);
    end;

    procedure GetEmployeeDesignation(EmployeeNo: Code[20]): Text
    var
        PayrollJobPosWorkerAssignRecG: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRecG: Record "Payroll Position";
    begin
        PayrollJobPosWorkerAssignRecG.Reset();
        PayrollJobPosWorkerAssignRecG.SetRange(Worker, EmployeeNo);
        PayrollJobPosWorkerAssignRecG.SetRange("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRecG.FindFirst() then begin
            PayrollPositionRecG.Reset();
            PayrollPositionRecG.SetRange("Position ID", PayrollJobPosWorkerAssignRecG."Position ID");
            if PayrollPositionRecG.FindFirst() then
                exit(PayrollPositionRecG.Description);
        end;
    end;

    procedure GetEmployeeDepartment(EmployeeNo: Code[20]): Text
    var
        PayrollJobPosWorkerAssignRecG: Record "Payroll Job Pos. Worker Assign";
        PayrollPositionRecG: Record "Payroll Position";
        DepartMasterRecL: Record "Payroll Department";
    begin
        PayrollJobPosWorkerAssignRecG.Reset();
        PayrollJobPosWorkerAssignRecG.SetRange(Worker, EmployeeNo);
        PayrollJobPosWorkerAssignRecG.SetRange("Is Primary Position", true);
        if PayrollJobPosWorkerAssignRecG.FindFirst() then begin
            PayrollPositionRecG.Reset();
            PayrollPositionRecG.SetRange("Position ID", PayrollJobPosWorkerAssignRecG."Position ID");
            if PayrollPositionRecG.FindFirst() then begin
                if DepartMasterRecL.Get(PayrollPositionRecG.Department) then
                    exit(DepartMasterRecL.Description);
            end;
        end;
    end;

    procedure GetEmployeeCrrPos(): Decimal
    var
        PayrollJobPosWrkAssgnRecG: Record "Payroll Job Pos. Worker Assign";
    begin
        PayrollJobPosWrkAssgnRecG.Reset();
        PayrollJobPosWrkAssgnRecG.SetRange(Worker, Rec."No.");
        PayrollJobPosWrkAssgnRecG.SetRange("Is Primary Position", true);
        if PayrollJobPosWrkAssgnRecG.FindFirst() then
            exit((Today - PayrollJobPosWrkAssgnRecG."Effective Start Date") / 365);
    end;
}