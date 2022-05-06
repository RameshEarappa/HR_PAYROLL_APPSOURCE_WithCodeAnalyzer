table 60045 "Payroll Statement Employee"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Payroll Statement ID"; Code[20])
        {
            TableRelation = "Payroll Statement";
            DataClassification = CustomerContent;
        }
        field(2; "Payroll Pay Cycle"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Payroll Pay Period"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Payroll Year"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Payroll Month"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; Status; Option)
        {
            OptionCaption = 'Draft,Open,Confirmed,Posted,Processing,Cancelled';
            OptionMembers = Draft,Open,Created,Posted,Processing,Cancelled;
            DataClassification = CustomerContent;
        }
        field(7; Worker; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(8; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(9; Voucher; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Currency Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Pay Period Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Pay Period End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Paid Status"; Option)
        {
            OptionCaption = 'Paid,Unpaid';
            OptionMembers = Paid,Unpaid;
            DataClassification = CustomerContent;
        }
        field(100; "Payroll Period RecID"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Payroll Statement ID", "Payroll Pay Cycle", "Payroll Pay Period", Worker)
        {
            Clustered = true;
        }
        key(Key2; Worker, "Payroll Period RecID")
        {
        }
        key(Key3; Worker, "Pay Period Start Date", Status)
        {
        }
        key(Key4; Worker, "Pay Period End Date")
        {
        }
    }

    trigger OnDelete()
    begin
        PayrollStatement.RESET;
        PayrollStatement.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
        if PayrollStatement.FINDFIRST then begin
            PayrollStatement.TESTFIELD("Workflow Status", PayrollStatement."Workflow Status"::Open);
        end;

        PayrollStatementTransLines.RESET;
        PayrollStatementTransLines.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
        PayrollStatementTransLines.SETRANGE("Payroll Statment Employee", Rec.Worker);
        PayrollStatementTransLines.DELETEALL;

        PayrollStatementLines.RESET;
        PayrollStatementLines.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
        PayrollStatementLines.SETRANGE("Payroll Statment Employee", Rec.Worker);
        PayrollStatementLines.DELETEALL;

        PayrollErrorLog.RESET;
        PayrollErrorLog.SETRANGE("Payroll Statement ID", Rec."Payroll Statement ID");
        PayrollErrorLog.DELETEALL;
    end;

    var
        PayrollStatementTransLines: Record "Payroll Statement Emp Trans.";
        PayrollStatementLines: Record "Payroll Statement Lines";
        PayrollStatement: Record "Payroll Statement";
        PayrollErrorLog: Record "Payroll Error Log";
}