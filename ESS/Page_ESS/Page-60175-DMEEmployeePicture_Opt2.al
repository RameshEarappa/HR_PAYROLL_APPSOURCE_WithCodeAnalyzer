page 70176 "DME Employee Picture 2"
{
    Caption = 'Employee Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(MG)
            {
                ShowCaption = false;
                grid(p)
                {
                    ShowCaption = false;
                    GridLayout = Rows;
                    field(Image; Rec.Image)
                    {
                        ApplicationArea = Basic, Suite;
                        ShowCaption = false;
                        ToolTip = 'Specifies the picture of the employee.';
                        ColumnSpan = 1;
                        RowSpan = 1;
                    }
                    usercontrol(html; HTML)
                    {
                        ApplicationArea = All;
                        trigger ControlReady()
                        var
                        begin
                            CurrPage.html.Render(GenerateEmployeeDetails());
                        end;
                    }
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(TakePicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Take';
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Activate the camera on the device.';
                Visible = CameraAvailable;

                trigger OnAction()
                var
                    PictureInStream: InStream;
                    PictureName: Text;
                begin
                    Rec.TestField("No.");
                    Rec.TestField("First Name");
                    Rec.TestField("Last Name");
                    //Camera.AddPicture(Rec, Rec.FieldNo(Image));
                    //Replaced with GetPicture Function
                    if not Camera.GetPicture(PictureInStream, PictureName) then
                        Error('Something went wrong while openning the camera');
                    Rec.Image.ImportStream(PictureInStream, PictureName, 'image/jpeg');
                end;
            }
            action(ImportPicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                    PicInStream: InStream;
                    FromFileName: Text;
                    OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?', Locked = false, MaxLength = 250;
                begin
                    Rec.TestField("No.");
                    Rec.TestField("First Name");
                    Rec.TestField("Last Name");
                    if Rec.Image.HasValue then
                        if not Confirm(OverrideImageQst) then
                            exit;
                    if Rec.Image.HasValue then
                        if not Confirm(OverrideImageQst) then
                            exit;
                    if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', FromFileName, PicInStream) then begin
                        Clear(Rec.Image);
                        Rec.Image.ImportStream(PicInStream, FromFileName);
                        Rec.Modify(true);
                    end;
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export';
                Enabled = DeleteExportEnabled;
                Image = Export;
                Visible = false;
                ToolTip = 'Export the picture to a file.';

                trigger OnAction()
                var
                    DummyPictureEntity: Record "Picture Entity";
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                begin
                    Rec.TestField("No.");
                    Rec.TestField("First Name");
                    Rec.TestField("Last Name");
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    Rec.TestField("No.");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec.Image);
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    trigger OnOpenPage()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", database.USERID);
        if UserSetup.FINDFIRST then
            UserSetup.TestField("Employee Id");
        Rec.SETRANGE("No.", UserSetup."Employee Id");
        CameraAvailable := Camera.IsAvailable();

    end;

    trigger OnAfterGetRecord()
    var
        TextBuilderL: TextBuilder;
        TextBuilder2L: TextBuilder;
    begin
        ImportPicture_LT;
        EmpName := Rec.FullName;
        DepartmentName := GetEmployeeDepartment(UserSetup."Employee Id");
        PositionName := GetEmployeeDesignation(UserSetup."Employee Id");
        TextBuilderL.AppendLine(' Employee Code  ' + ': ' + UserSetup."Employee Id");
        TextBuilderL.AppendLine();
        TextBuilderL.AppendLine(' Employee Name  ' + ': ' + Rec.FullName);
        TextBuilderL.AppendLine();
        TextBuilderL.AppendLine(' Department Name ' + ': ' + DepartmentName);
        TextBuilderL.AppendLine();
        TextBuilderL.AppendLine(' Position Name  ' + ': ' + PositionName);
        EmployeeDetails := TextBuilderL.ToText();
    end;

    var
        Camera: Codeunit Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        DeleteExportEnabled: Boolean;
        EmpName: Text;
        DepartmentName: Text[150];
        PositionName: Text[150];
        WelComtex: Label 'Welcome ';
        UserSetup: Record "User Setup";
        EmployeeDetails: Text;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec.Image.HasValue;
    end;

    local procedure ImportPicture_LT();
    var
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        if UserSetup.FINDFIRST then begin
            Rec.SETRANGE("No.", UserSetup."Employee Id");
            EmpName := WelComtex + Rec.FullName;
            DepartmentName := GetEmployeeDepartment(UserSetup."Employee Id");
            PositionName := GetEmployeeDesignation(UserSetup."Employee Id");
        end;
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

    local procedure GenerateEmployeeDetails(): Text
    var
        htmlTags: Text;
    begin
        Clear(htmlTags);
        ImportPicture_LT;
        EmpName := Rec.FullName;
        DepartmentName := GetEmployeeDepartment(UserSetup."Employee Id");
        PositionName := GetEmployeeDesignation(UserSetup."Employee Id");


        htmlTags := '<style type="text/css">' +
                    'table {font-family: arial, sans-serif;border-collapse: collapse; width: 100%;font-size: 14px;}' +
                    'td, th {  border: 0px solid #dddddd;text-align: left; padding: 9px;}' +
                    '.LastLine{ background-color: #C4E7E9;  color:black;font-weight: 550;}' +
                    '</style>' +
                    '<table>' +
                    '<tr><td > <B>Employee Id </B> </td> <td >' + Format(UserSetup."Employee Id") + '</td></tr>' +
                    '<tr><td > <B>Employee Name </B></td> <td >' + Format(Rec.FullName) + '</td> </tr>' +
                    '<tr><td > <B>Department </B></td> <td>' + Format(DepartmentName) + '</td> </tr>' +
                    '<tr><td > <B>Position </B> </td> <td >' + Format(PositionName) + '</td></tr>' +
                    '</tbody></table>';
        exit(htmlTags);
    end;
}