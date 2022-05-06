table 60102 "Delegate - WFLT"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Employee Code"; Code[30])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                VALIDATE("Employee ID", GetUserIDFromEmployee_LT("Employee Code"));
            end;
        }
        field(2; "Employee ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(3; "Delegate To"; Code[50])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Delegate To" = '' then begin
                    CLEAR("From Date");
                    CLEAR("To Date");
                end;

                if "Delegate To" <> '' then
                    VALIDATE("Delegate ID", GetUserIDFromEmployee_LT("Delegate To"));
            end;
        }
        field(4; "Delegate ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(5; "To Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "To Date" <= "From Date" then
                    ERROR('To Date should not be Less than From Date.');
            end;
        }
        field(6; "From Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "To Date" <> 0D then
                    if "From Date" >= "To Date" then
                        ERROR('From Date should not be greater than To Date .');
            end;
        }
        field(7; "Delegate No."; Code[30])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Delegate No.", "Employee Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        AdvancePayrollSetupRec_G.RESET;
        AdvancePayrollSetupRec_G.GET;
        if "Delegate No." = '' then begin
            "Delegate No." := NoSeriesManagement.GetNextNo(AdvancePayrollSetupRec_G."Delegation No.", TODAY, true);
        end
    end;

    var
        UserSetupRec_G: Record "User Setup";
        AdvancePayrollSetupRec_G: Record "Advance Payroll Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;

    local procedure GetUserIDFromEmployee_LT(Emp_Code: Code[30]): Code[100]
    begin
        UserSetupRec_G.RESET;
        UserSetupRec_G.SETRANGE("Employee Id", Emp_Code);
        if not UserSetupRec_G.FINDFIRST then
            ERROR('Employee Id %1 must have a value in User Setup', Emp_Code);
        exit(UserSetupRec_G."User ID");
    end;
}