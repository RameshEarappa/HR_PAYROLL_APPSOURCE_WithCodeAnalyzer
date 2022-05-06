table 60122 "Loan Adjustment Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Loan Adjustment ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee ID"; Code[50])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                LoanAdjustmentLinesRecL: Record "Work Time Template - Ramadn";
            begin
                Employee.RESET;
                if Employee.GET("Employee ID") then begin
                    "Employee ID" := Employee."No.";
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                end;
                if xRec."Employee ID" <> Rec."Employee ID" then begin
                    Clear("Loan Request ID");
                    Clear("Loan ID");
                    Clear("Loan Description");
                    Clear("Loan Request Amount");
                    LoanAdjustmentLines.SETRANGE("Loan Adjustment ID", "Loan Adjustment ID");
                    LoanAdjustmentLines.SETRANGE(Loan, "Loan ID");
                    LoanAdjustmentLines.SETRANGE("Employee ID", xRec."Employee ID");
                    LoanAdjustmentLines.SETRANGE("Loan Request ID", "Loan Request ID");
                    if LoanAdjustmentLines.FindSet() then
                        LoanAdjustmentLines.DeleteAll();
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Adjustment Type"; Option)
        {
            OptionCaption = ',Unrecovered,Recovered,Adjusted';
            OptionMembers = ,Unrecovered,Recovered,Adjusted;
            DataClassification = CustomerContent;
        }
        field(5; "Loan ID"; Code[20])
        {
            Editable = false;
            TableRelation = "Loan Request"."Loan Type" WHERE("Loan Request ID" = FIELD("Loan Request ID"));
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                LoanTypeSetup.SETRANGE(Active, TRUE);
                "Loan ID" := LoanTypeSetup."Loan Code";
                "Loan Description" := LoanTypeSetup."Loan Description";
            end;
        }
        field(6; "Loan Description"; Text[250])
        {
            CalcFormula = Lookup("Loan Type Setup"."Loan Description" WHERE("Loan Code" = FIELD("Loan ID")));
            FieldClass = FlowField;
        }
        field(7; "Adjustment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Workflow Status"; Option)
        {
            OptionCaption = 'Open,Approved,Send for Approval,Rejected';
            OptionMembers = Open,Released,"Pending For Approval",Rejected;
            DataClassification = CustomerContent;
        }
        field(9; "Loan Request ID"; Code[50])
        {
            TableRelation = "Loan Request"."Loan Request ID" WHERE("Employee ID" = FIELD("Employee ID"), "WorkFlow Status" = filter(Released));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                LoanRequest.SETRANGE("Employee ID", "Employee ID");
                if LoanRequest.FINDFIRST then begin
                    "Loan Request ID" := LoanRequest."Loan Request ID";
                    "Loan ID" := LoanRequest."Loan Type";
                    "Loan Description" := LoanRequest."Loan Description";
                    "Loan Request Amount" := LoanRequest."Request Amount";
                    if (("Loan Request ID" <> '') and ("Loan ID" <> '')) then
                        GetLoanLines;
                end;
            end;
        }
        field(10; "Loan Request Amount"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11; RecID; RecordId)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Update Loan Bool"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Loan Adjustment ID", "Loan ID", "Loan Request ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        if "Workflow Status" <> "Workflow Status"::Open then
            ERROR('Loan Adjustment Workflow Status should be Open.');
    end;

    trigger OnInsert()
    begin
        "Workflow Status" := "Workflow Status"::Open;
        Initialise;
        RecID := RecordId;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Employee: Record Employee;
        LoanTypeSetup: Record "Loan Type Setup";
        LoanRequest: Record "Loan Request";
        LoanAdjustmentLines: Record "Loan Adjustment Lines";
        Text50004: Label 'Loan Adjustment Lines already Exist !';
        LoanInstallmentGeneration: Record "Loan Installment Generation";
        AdvancePayrollSetup: Record "Advance Payroll Setup";

    local procedure Initialise()
    begin
        AdvancePayrollSetup.GET;
        "Loan Adjustment ID" := NoSeriesManagement.GetNextNo(AdvancePayrollSetup."Loan Adj. No Series", WORKDATE, true);
    end;

    procedure Reopen(var Rec: Record "Loan Adjustment Header")
    begin
        if Rec.FindSet() then begin
            repeat
                if "Workflow Status" = "Workflow Status"::Open then
                    exit;

                "Workflow Status" := "Workflow Status"::Open;
                MODIFY;
            until Rec.Next() = 0;
        end;
    end;

    local procedure GetLoanLines()
    var
        LoanAdjustmentLinesRecL: Record "Work Time Template - Ramadn";
    begin
        LoanAdjustmentLines.SETRANGE("Loan Adjustment ID", "Loan Adjustment ID");
        LoanAdjustmentLines.SETRANGE(Loan, "Loan ID");
        LoanAdjustmentLines.SETRANGE("Employee ID", "Employee ID");
        LoanAdjustmentLines.SETRANGE("Loan Request ID", "Loan Request ID");
        if LoanAdjustmentLines.FindSet() then
            LoanAdjustmentLines.DeleteAll();

        LoanAdjustmentLines.SETRANGE("Loan Adjustment ID", "Loan Adjustment ID");
        LoanAdjustmentLines.SETRANGE(Loan, "Loan ID");
        LoanAdjustmentLines.SETRANGE("Employee ID", "Employee ID");
        LoanAdjustmentLines.SETRANGE("Loan Request ID", "Loan Request ID");
        if LoanAdjustmentLines.FINDFIRST then
            ERROR(Text50004);

        LoanInstallmentGeneration.RESET;
        LoanInstallmentGeneration.SETRANGE(Loan, "Loan ID");
        LoanInstallmentGeneration.SETRANGE("Employee ID", "Employee ID");
        LoanInstallmentGeneration.SETRANGE("Loan Request ID", "Loan Request ID");
        if LoanInstallmentGeneration.FINDSET then
            repeat
                LoanAdjustmentLinesRecL.RESET;
                IF LoanAdjustmentLinesRecL.FINDLAST THEN;
                LoanAdjustmentLines."Entry No." := LoanAdjustmentLines."Entry No." + 1;
                LoanAdjustmentLines.INIT;
                LoanAdjustmentLines."Entry No." := 0;
                LoanAdjustmentLines."Loan Adjustment ID" := "Loan Adjustment ID";
                LoanAdjustmentLines.INSERT;
                LoanAdjustmentLines."Loan Request ID" := LoanInstallmentGeneration."Loan Request ID";
                LoanAdjustmentLines.Loan := LoanInstallmentGeneration.Loan;
                LoanAdjustmentLines."Loan Description" := LoanInstallmentGeneration."Loan Description";
                LoanAdjustmentLines."Employee ID" := LoanInstallmentGeneration."Employee ID";
                LoanAdjustmentLines."Employee Name" := LoanInstallmentGeneration."Employee Name";
                LoanAdjustmentLines."Installament Date" := LoanInstallmentGeneration."Installament Date";
                LoanAdjustmentLines."Principal Installment Amount" := LoanInstallmentGeneration."Principal Installment Amount";
                LoanAdjustmentLines."Interest Installment Amount" := LoanInstallmentGeneration."Interest Installment Amount";
                LoanAdjustmentLines.Currency := LoanInstallmentGeneration.Currency;
                LoanAdjustmentLines.Status := LoanInstallmentGeneration.Status;
                LoanAdjustmentLines.MODIFY;
            until LoanInstallmentGeneration.NEXT = 0;
    end;
}