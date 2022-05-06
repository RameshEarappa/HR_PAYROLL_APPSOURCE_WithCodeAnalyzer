xmlport 65020 "Import Time Details"
{
    Direction = Import;
    Format = VariableText;
    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'TimeAttendanceCheckinLog';
                SourceTableView = SORTING(Number) WHERE(Number = FILTER(1));
                textelement(empid)
                {
                    XmlName = 'a';
                }
                textelement(checdate)
                {
                    XmlName = 'b';
                }
                textelement(checkintime)
                {
                    XmlName = 'c';
                }
                textelement(checkouttime)
                {
                    XmlName = 'd';
                }
                textelement(gatein)
                {
                    XmlName = 'e';
                }
                textelement(gateout)
                {
                    XmlName = 'f';
                }

                trigger OnAfterInsertRecord();
                begin
                    InitialiazeVar;
                    EVALUATE(EID, EmpID);
                    Employee.GET(EmpID);
                    EVALUATE(CDate, ChecDate);
                    EVALUATE(CTime, CheckInTime);
                    EVALUATE(Ctimeout, CheckOutTime);
                    if Gatein <> '' then
                        EVALUATE(GIn, Gatein);
                    if Gateout <> '' then
                        EVALUATE(Gout, Gateout);
                    UploadAttendance;
                end;

                trigger OnBeforeInsertRecord();
                begin
                    if firstline then begin
                        firstline := false;
                        currXMLport.SKIP;
                    end;
                end;
            }
        }
    }

    trigger OnPostXmlPort();
    begin
        MESSAGE('Entries uploaded successfully');
    end;

    trigger OnPreXmlPort();
    begin
        firstline := true;
    end;

    var
        firstline: Boolean;
        EID: Code[50];
        CDate: Date;
        CTime: Time;
        Ctimeout: Time;
        GIn: Code[20];
        Gout: Code[20];
        Employee: Record Employee;
        EmployeeWorkDate_GCC: Record EmployeeWorkDate_GCC;
        TimeAttendanceDetails: Record "Time Attendance - Details";

    local procedure InitialiazeVar();
    begin
        CLEAR(EID);
        CLEAR(CDate);
        CLEAR(CTime);
        CLEAR(Ctimeout);
        CLEAR(GIn);
        CLEAR(Gout);
    end;

    local procedure UploadAttendance();
    var
        TimeAttendanceDetails: Record "Time Attendance - Details";
    begin
        TimeAttendanceDetails.INIT;
        TimeAttendanceDetails."Employee ID" := EmpID;
        if Employee.GET(EmpID) then
            TimeAttendanceDetails.VALIDATE("Employee Full Name", Employee."First Name" + ' ' + Employee."Last Name");

        TimeAttendanceDetails.VALIDATE("Check -In Date", CDate);

        EmployeeWorkDate_GCC.SETRANGE("Employee Code", EmpID);
        EmployeeWorkDate_GCC.SETRANGE("Trans Date", CDate);
        if EmployeeWorkDate_GCC.FINDFIRST then
            TimeAttendanceDetails.VALIDATE("Day Type", EmployeeWorkDate_GCC."Calculation Type");

        TimeAttendanceDetails."Check -In Time" := CTime;
        TimeAttendanceDetails.VALIDATE("Check -Out Time", Ctimeout);
        TimeAttendanceDetails.VALIDATE("Gate In", GIn);
        TimeAttendanceDetails.VALIDATE("Gate Out", Gout);
        TimeAttendanceDetails.INSERT(true);
    end;
}