table 60035 "Payroll Adjmt. Journal Lines"
{
    Caption = 'Payroll Adjmt. Journal Lines';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Journal No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                PayrollAdjmtJournalheader.RESET;
                PayrollAdjmtJournalheader.GET("Journal No.");
                if PayrollAdjmtJournalheader.Posted then
                    ERROR('You cannot modify confirmed journals');
            end;
        }
        field(20; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                PayrollAdjmtJournalheader.RESET;
                PayrollAdjmtJournalheader.GET("Journal No.");
                if PayrollAdjmtJournalheader.Posted then
                    ERROR('You cannot modify confirmed journals');
            end;
        }
        field(30; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PayrollAdjmtJournalheaderRecL: Record "Payroll Adjmt. Journal header";
                EmployeeRecL: Record Employee;
                PayrollJobPosWorkerAssignRecL: Record "Payroll Job Pos. Worker Assign";
                PayrollPositionRecL: Record "Payroll Position";
            begin
                PayrollAdjmtJournalheader.RESET;
                PayrollAdjmtJournalheader.GET("Journal No.");
                if PayrollAdjmtJournalheader.Posted then
                    ERROR('You cannot modify confirmed journals');

                PayrollAdjmtJournalheaderRecL.RESET;
                PayrollAdjmtJournalheaderRecL.SETRANGE("Journal No.", "Journal No.");
                if PayrollAdjmtJournalheaderRecL.FINDFIRST then begin
                    EmployeeRecL.RESET;
                    if EmployeeRecL.GET("Employee Code") then begin
                        PayrollJobPosWorkerAssignRecL.RESET;
                        PayrollJobPosWorkerAssignRecL.SETRANGE(Worker, EmployeeRecL."No.");
                        PayrollJobPosWorkerAssignRecL.SETRANGE("Is Primary Position", true);
                        if PayrollJobPosWorkerAssignRecL.FINDFIRST then begin

                            PayrollPositionRecL.RESET;
                            PayrollPositionRecL.SETRANGE("Position ID", PayrollJobPosWorkerAssignRecL."Position ID");
                            if PayrollPositionRecL.FINDFIRST then
                                if PayrollPositionRecL."Pay Cycle" <> PayrollAdjmtJournalheaderRecL."Pay Cycle" then
                                    ERROR('Employee does not belong to Pay Cycle %1', PayrollPositionRecL."Pay Cycle");

                        end;
                    end;
                end;

                if "Employee Code" <> '' then begin
                    Employee.RESET;
                    Employee.GET("Employee Code");
                    "Employee Name" := Employee."First Name";
                end
                else
                    "Employee Name" := '';
            end;
        }
        field(40; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PayrollAdjmtJournalheader.RESET;
                PayrollAdjmtJournalheader.GET("Journal No.");
                if PayrollAdjmtJournalheader.Posted then
                    ERROR('You cannot modify confirmed journals');
            end;
        }
        field(50; "Earning Code"; Code[20])
        {
            TableRelation = "Payroll Earning Code Wrkr"."Earning Code" WHERE(Worker = FIELD("Employee Code"),
                                                                              "Calc. Payroll Adj." = CONST(true));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PayrollAdjmtJournalheader.RESET;
                PayrollAdjmtJournalheader.GET("Journal No.");
                if PayrollAdjmtJournalheader.Posted then
                    ERROR('You cannot modify confirmed journals');

                if "Earning Code" <> '' then begin
                    PayrllErngCode.RESET;
                    PayrllErngCode.SETRANGE("Earning Code", "Earning Code");
                    if PayrllErngCode.FINDFIRST then
                        "Earning Code Description" := PayrllErngCode.Description;
                end
                else
                    "Earning Code Description" := '';
            end;
        }
        field(60; "Earning Code Description"; Text[100])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PayrollAdjmtJournalheader.RESET;
                PayrollAdjmtJournalheader.GET("Journal No.");
                if PayrollAdjmtJournalheader.Posted then
                    ERROR('You cannot modify confirmed journals');
            end;
        }
        field(70; "Voucher Description"; Text[250])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PayrollAdjmtJournalheader.RESET;
                PayrollAdjmtJournalheader.GET("Journal No.");
                if PayrollAdjmtJournalheader.Posted then
                    ERROR('You cannot modify confirmed journals');
            end;
        }
        field(80; Amount; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PayrollAdjmtJournalheader.RESET;
                PayrollAdjmtJournalheader.GET("Journal No.");
                if PayrollAdjmtJournalheader.Posted then
                    ERROR('You cannot modify confirmed journals');
            end;
        }
        field(90; "Financial Dimension"; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PayrollAdjmtJournalheader.RESET;
                PayrollAdjmtJournalheader.GET("Journal No.");
                if PayrollAdjmtJournalheader.Posted then
                    ERROR('You cannot modify confirmed journals');
            end;
        }
    }

    keys
    {
        key(Key1; "Journal No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Journal No.", "Employee Code")
        {

        }
    }

    trigger OnDelete()
    begin
        PayrollAdjmtJournalheader.GET("Journal No.");
        if PayrollAdjmtJournalheader.Posted then
            ERROR('You cannot modify confirmed journals');
    end;

    trigger OnModify()
    begin
        PayrollAdjmtJournalheader.RESET;
        PayrollAdjmtJournalheader.GET("Journal No.");
        if PayrollAdjmtJournalheader.Posted then
            ERROR('You cannot modify confirmed journals');
    end;

    var
        Employee: Record Employee;
        PayrllErngCode: Record "Payroll Earning Code";
        PayrollAdjmtJournalheader: Record "Payroll Adjmt. Journal header";
}