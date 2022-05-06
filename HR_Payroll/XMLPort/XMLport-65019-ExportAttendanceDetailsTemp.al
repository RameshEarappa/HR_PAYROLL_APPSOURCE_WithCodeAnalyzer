xmlport 65019 "Export Attendance Details Temp"
{
    Direction = Export;
    FileName = 'TimeAttendanceDetailsTemplate.csv';
    Format = VariableText;
    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Caption';
                SourceTableView = WHERE(Number = CONST(1));
                textelement(EmployeeID)
                {
                    trigger OnBeforePassVariable();
                    begin
                        EmployeeID := TimeAttendance.FIELDCAPTION("Employee ID");
                    end;
                }
                textelement(Date)
                {
                    trigger OnBeforePassVariable();
                    begin
                        Date := TimeAttendance.FIELDCAPTION("Check -In Date");
                    end;
                }
                textelement(starttime)
                {
                    XmlName = 'StartTime';
                    trigger OnBeforePassVariable();
                    begin
                        StartTime := TimeAttendance.FIELDCAPTION("Check -In Time");
                    end;
                }
                textelement(EndTime)
                {
                    trigger OnBeforePassVariable();
                    begin
                        EndTime := TimeAttendance.FIELDCAPTION("Check -Out Time");
                    end;
                }
                textelement(gatein)
                {
                    XmlName = 'GateIn';
                    trigger OnBeforePassVariable();
                    begin
                        Gatein := TimeAttendance.FIELDCAPTION("Gate In");
                    end;
                }
                textelement(gateout)
                {
                    XmlName = 'Gateout';
                    trigger OnBeforePassVariable();
                    begin
                        Gateout := TimeAttendance.FIELDCAPTION("Gate Out");
                    end;
                }
            }
        }
    }


    trigger OnPostXmlPort();
    begin
        MESSAGE('Template Exported Successfully');
    end;

    var
        LineNo: Integer;
        firstline: Boolean;
        Employee: Record Employee;
        TimeAttendance: Record "Time Attendance - Details";
}