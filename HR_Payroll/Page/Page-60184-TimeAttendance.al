page 60184 "Time Attendance"
{
    Caption = 'Time Attendance';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Time Attendance";
    SourceTableView = SORTING("Employee ID", Date)
                      ORDER(Ascending);
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        StartTime := FORMAT(Rec."Start Time", 8, '<Hours24,2>:<Minutes,2>:<Seconds,2>');
                    end;
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        EndTime := FORMAT(Rec."End Time", 8, '<Hours24,2>:<Minutes,2>:<Seconds,2>');
                    end;
                }
                field("Total Hours"; Rec."Total Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Normal Hours"; Rec."Normal Hrs")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Absent Hours"; Rec."Absent Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Overtime Hrs"; Rec."Overtime Hrs")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Project Id"; Rec."Project Id")
                {
                    ApplicationArea = All;
                }
                field("Overtime Approval Status"; Rec."Overtime Approval Status")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Indoor Check-in"; Rec."Indoor Check-in")
                {
                    ApplicationArea = All;
                }
                field("Outdoor Check-out"; Rec."Outdoor Check-out")
                {
                    ApplicationArea = All;
                }
                field(Confirmed; Rec.Confirmed)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Task)
            {
                Caption = 'Task';
                Image = Task;
                action(Confirm)
                {
                    Ellipsis = true;
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        if CONFIRM(Text55016, true) then begin
                            CLEAR(TimeAttendance);
                            CurrPage.SETSELECTIONFILTER(TimeAttendance);
                            if TimeAttendance.FINDSET then
                                repeat
                                    if TimeAttendance.Confirmed = false then begin
                                        TimeAttendance.Confirmed := true;
                                        TimeAttendance.MODIFY;
                                    end;
                                until TimeAttendance.NEXT = 0;
                        end
                        else
                            exit;
                    end;
                }
                action("Export Template")
                {
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                }
                action("Import Attendance")
                {
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                action("Attendance Details")
                {
                    Image = LedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CALCFIELDS("Error Log");
        if Rec."Error Log".HASVALUE then begin
            Rec."Error Log".CREATEINSTREAM(INStr);
            INStr.READ(ErrorMessage);
        end;
        if Rec.Confirmed then
            CurrPage.EDITABLE := false;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TESTFIELD(Confirmed, false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TESTFIELD(Confirmed, false);
    end;

    trigger OnOpenPage()
    begin
        Rec.SETRANGE(Confirmed, false);
    end;

    var
        TimeAttendance: Record "Time Attendance";
        Text55015: Label 'Overtime is not approved';
        StartTime: Text;
        EndTime: Text;
        Text55016: Label 'Do you want to check Validation for all records ?';
        Employee: Record Employee;
        ErrorMessage: Text[250];
        INStr: InStream;
        Remarks: Text[250];
        StreamOut: OutStream;
        FileManagement: Codeunit "File Management";
        EmployeeWorkDate_GCC: Record EmployeeWorkDate_GCC;
        Text0001: Label 'Employee Status is not active !';
        Text0002: Label 'Deletion is not allowed for confirmed record.';
        Text003: Label 'Modification is not allowed for confirmed record.';

    local procedure CheckValidations()
    begin
        TimeAttendance.SETRANGE(Confirmed, false);
        if TimeAttendance.FINDFIRST then begin

            if Employee.GET(TimeAttendance."Employee ID") then
                if Employee.Status <> Employee.Status::Active then
                    TimeAttendance.Remarks := TimeAttendance.Remarks + Text0001;

            StartTime := FORMAT(TimeAttendance."Start Time", 8, '<Hours24,2>:<Minutes,2>:<Seconds,2>');
            EndTime := FORMAT(TimeAttendance."End Time", 8, '<Hours24,2>:<Minutes,2>:<Seconds,2>');

            if StartTime > EndTime then
                TimeAttendance.Remarks := 'Start Time is greater than End Time';

            if Employee.GET(Rec."Employee ID") then begin

                if (TimeAttendance.Date < Employee."Joining Date") then
                    TimeAttendance.Remarks := TimeAttendance.Remarks + Text0001;

                if Employee."Termination Date" <> 0D then
                    if (TimeAttendance.Date > Employee."Termination Date") then
                        TimeAttendance.Remarks := TimeAttendance.Remarks + Text0001;
            end;

            EmployeeWorkDate_GCC.SETRANGE("Employee Code", TimeAttendance."Employee ID");
            EmployeeWorkDate_GCC.SETRANGE("Trans Date", TimeAttendance.Date);
            if EmployeeWorkDate_GCC.FINDFIRST then
                TimeAttendance."Day Type" := EmployeeWorkDate_GCC."Calculation Type";
            TimeAttendance.MODIFY;
        end;
    end;
}