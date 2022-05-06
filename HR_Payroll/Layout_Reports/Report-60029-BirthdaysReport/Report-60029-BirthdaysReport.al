report 60029 "Birthdays Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'HR_Payroll\Layout_Reports\Report-60029-BirthdaysReport\BirthdaysReport.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(Employee_PersonnelNumber; Employee."No.")
            { }
            column(EmployeeName; STRSUBSTNO(Employee."First Name" + Employee."Middle Name" + Employee."Last Name"))
            { }
            column(EmployeeDepartments; Employee.Department)
            { }
            column(EmployeeDateOfbirth; Employee."Birth Date")
            { }
            column(EmpBirthDateCaption_Caption; EmpBirthDateCaption)
            { }
            column(EmpCodeCaption_Caption; EmpCodeCaption)
            { }
            column(EmpNameCaption_Caption; EmpNameCaption)
            { }
            column(EmpDepartCaption_Caption; EmpDepartCaption)
            { }
            column(EmpDOBCaption_Caption; EmpDOBCaption)
            { }
            column(EmpAgeCaption_Caption; EmpAgeCaption)
            { }
            column(EmpAge; EmpAge)
            { }
            column(EmpBirthDateCurrYear; EmpBirthDateCurrYear)
            { }
            column(CompName; CompanyInformation.Name)
            { }
            column(From; StartDate)
            { }
            column("To"; EndDate)
            { }

            trigger OnAfterGetRecord();
            begin
                EmpAge := 0;
                EmpBirthDateCurrYear := 0D;
                IsBirthday := false;
                BirthdayDateEndDateYear := 0D;
                BirthdayDateStartDateYear := 0D;

                if Employee."Birth Date" <> 0D then begin
                    if DATE2DMY(EndDate, 3) > DATE2DMY(StartDate, 3) then begin
                        BirthdayDateEndDateYear := DMY2DATE(DATE2DMY(Employee."Birth Date", 1), DATE2DMY(Employee."Birth Date", 2), DATE2DMY(EndDate, 3));
                        BirthdayDateStartDateYear := DMY2DATE(DATE2DMY(Employee."Birth Date", 1), DATE2DMY(Employee."Birth Date", 2), DATE2DMY(StartDate, 3));
                        if (BirthdayDateEndDateYear >= StartDate) and (BirthdayDateEndDateYear <= EndDate) then begin
                            EmpBirthDateCurrYear := BirthdayDateEndDateYear;
                            EmpAge := DATE2DMY(EmpBirthDateCurrYear, 3) - DATE2DMY(Employee."Birth Date", 3);
                            IsBirthday := true;
                        end;
                        if (BirthdayDateStartDateYear >= StartDate) and (BirthdayDateStartDateYear <= EndDate) then begin
                            EmpBirthDateCurrYear := BirthdayDateStartDateYear;
                            EmpAge := DATE2DMY(EmpBirthDateCurrYear, 3) - DATE2DMY(Employee."Birth Date", 3);
                            IsBirthday := true;
                        end;
                    end
                    else
                        if DATE2DMY(EndDate, 3) = DATE2DMY(StartDate, 3) then begin
                            BirthdayDateStartDateYear := DMY2DATE(DATE2DMY(Employee."Birth Date", 1), DATE2DMY(Employee."Birth Date", 2), DATE2DMY(StartDate, 3));
                            if (BirthdayDateStartDateYear >= StartDate) and (BirthdayDateStartDateYear <= EndDate) then begin
                                EmpBirthDateCurrYear := BirthdayDateStartDateYear;
                                EmpAge := DATE2DMY(EmpBirthDateCurrYear, 3) - DATE2DMY(Employee."Birth Date", 3);
                                IsBirthday := true;
                            end;
                        end;
                end;
                if not IsBirthday then
                    CurrReport.SKIP;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Date"; StartDate)
                {
                    ApplicationArea = All;
                }
                field("End Date"; EndDate)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnPreReport();
    begin
        if CompanyInformation.GET then;

        if (StartDate = 0D) or (EndDate = 0D) then
            ERROR('Start Date and End Date should have a value');
        if StartDate > EndDate then
            ERROR('Start Date cant be greater than End Date');
        if EndDate - StartDate > 365 then
            ERROR('You cant enter a date period greater than a year');
    end;

    var
        EmpAge: Integer;
        EmpBirthDateCurrYear: Date;
        EmpNameCaption: Label 'Name';
        EmpCodeCaption: Label 'Personnel Number';
        EmpDepartCaption: Label 'Departments';
        EmpDOBCaption: Label 'Date Of Birth';
        EmpAgeCaption: Label 'Age';
        EmpBirthDateCaption: Label 'Birthday';
        StartDate: Date;
        EndDate: Date;
        BirthdayDateStartDateYear: Date;
        BirthdayDateEndDateYear: Date;
        IsBirthday: Boolean;
        CompanyInformation: Record "Company Information";
}