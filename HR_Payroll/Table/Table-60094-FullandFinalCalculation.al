table 60094 "Full and Final Calculation"
{
    DrillDownPageID = "Full and Final Settlement";
    LookupPageID = "Full and Final Settlement";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Journal ID"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                AdvPayrollSetup.GET;
                if "Journal ID" = '' then
                    "Journal ID" := NoSeriesManagement.GetNextNo(AdvPayrollSetup."FS Journal ID", TODAY, true);
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                Employee: Record Employee;
                AdvancePayrollSetupRecL: Record "Advance Payroll Setup";
            begin
                Employee.RESET;
                Employee.FILTERGROUP(2);
                Employee.SETFILTER("Termination Date", '<>%1', 0D);
                Employee.FILTERGROUP(0);
                if PAGE.RUNMODAL(60089, Employee) = ACTION::LookupOK then begin
                    "Employee No." := Employee."No.";
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Last Name";
                    "Service Days" := Employee."Termination Date" - Employee."Joining Date";
                    "Joining Date" := Employee."Joining Date";
                    "Termination Date" := Employee."Employment End Date";
                    EmployeeEarningCodeGroups.RESET;
                    EmployeeEarningCodeGroups.SETRANGE("Employee Code", Employee."No.");
                    EmployeeEarningCodeGroups.SETFILTER("Valid From", '<=%1', Employee."Employment End Date");
                    EmployeeEarningCodeGroups.SETFILTER("Valid To", '>=%1|%2', Employee."Employment End Date", 0D);
                    if EmployeeEarningCodeGroups.FINDFIRST then begin
                        Currency := EmployeeEarningCodeGroups.Currency;
                        "Earning Code Group" := EmployeeEarningCodeGroups."Earning Code Group";
                        PayPosition.GET(Employee.Position);
                        "Pay Cycle" := PayPosition."Pay Cycle";
                        if Employee."Hold Payment from Date" <> 0D then
                            "Pay Period Start Date" := Employee."Hold Payment from Date"
                        else
                            "Pay Period Start Date" := CALCDATE('-CM', Employee."Employment End Date");
                        "Pay Period End Date" := CALCDATE('CM', Employee."Employment End Date");
                    end;
                    AdvancePayrollSetupRecL.Reset();
                    AdvancePayrollSetupRecL.Get();
                end;
            end;

            trigger OnValidate()
            begin
                if "Employee No." = '' then begin
                    "Employee No." := '';
                    "Employee Name" := '';
                    "Service Days" := 0;
                    "Joining Date" := 0D;
                    "Termination Date" := 0D;
                    Currency := '';
                    "Pay Cycle" := '';
                    "Pay Period Start Date" := 0D;
                    "Pay Period End Date" := 0D;
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Service Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Joining Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Termination Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; Currency; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(8; Calculated; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(10; "Pay Cycle"; Code[20])
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
        field(13; "Workflow Status"; Option)
        {
            OptionCaption = 'Open,Approved,Send for Approval,Rejected';
            OptionMembers = Open,Released,"Pending Approval",Rejected;
            DataClassification = CustomerContent;
        }
        field(25; "Payroll Amount"; Decimal)
        {
            CalcFormula = Sum("FS - Earning Code"."Earning Code Amount" WHERE("Journal ID" = FIELD("Journal ID"),
                                                                               "Employee No." = FIELD("Employee No."),
                                                                               "Final Settlement Component" = const(false)));
            FieldClass = FlowField;
        }
        field(26; "Leave Encashment"; Decimal)
        {
            CalcFormula = Sum("Leave Encashment"."Leave Encashment Amount" WHERE("Journal ID" = FIELD("Journal ID")));
            FieldClass = FlowField;
        }
        field(27; "Indemnity/Gratuity Amount"; Decimal)
        {
            CalcFormula = Sum("FS - Earning Code"."Earning Code Amount" WHERE("Journal ID" = FIELD("Journal ID"), "Final Settlement Component" = const(true)));
            Caption = 'Gratuity Amount';
            FieldClass = FlowField;
        }
        field(28; "Loan Recovery"; Decimal)
        {
            CalcFormula = Sum("FS Loans"."EMI Amount" WHERE("Journal ID" = FIELD("Journal ID")));
            FieldClass = FlowField;
        }
        field(29; "Payroll Summarry"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Earning Code Group"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(31; RecId; RecordId)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "Employee No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        FSEarnings: Record "FS - Earning Code";
        FSBenefits: Record "FS Benefits";
        FSLoan: Record "FS Loans";
    begin
        FSBenefits.RESET;
        FSBenefits.SETRANGE("Journal ID", Rec."Journal ID");
        FSBenefits.DELETEALL;

        FSEarnings.RESET;
        FSEarnings.SETRANGE("Journal ID", Rec."Journal ID");
        FSEarnings.DELETEALL;

        FSLoan.RESET;
        FSLoan.SETRANGE("Journal ID", Rec."Journal ID");
        FSLoan.DELETEALL;
    end;

    trigger OnInsert()
    begin
        AdvPayrollSetup.GET;
        RecId := Rec.RecordId;
        if "Journal ID" = '' then
            "Journal ID" := NoSeriesManagement.GetNextNo(AdvPayrollSetup."FS Journal ID", TODAY, true);
    end;

    var
        Employee: Record Employee;
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
        AdvPayrollSetup: Record "Advance Payroll Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PayPosition: Record "Payroll Position";
}