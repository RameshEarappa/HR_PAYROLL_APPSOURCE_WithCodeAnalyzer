table 60013 "Employee Earning Code Groups"
{
    Caption = 'Employee Earning Code Groups';
    DataClassification = CustomerContent;

    fields
    {
        field(5; "Employee Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; RecrefId; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(10; "Earning Code Group"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Earning Code Groups";
            DataClassification = CustomerContent;
        }
        field(15; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(20; Calander; Code[20])
        {
            TableRelation = "Work Calendar Header";
            DataClassification = CustomerContent;
        }
        field(30; "Gross Salary"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Travel Class"; Option)
        {
            OptionCaption = 'Economy,Business';
            OptionMembers = Economy,Business;
            DataClassification = CustomerContent;
        }
        field(50; Currency; Code[20])
        {
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(51; "Grade Category"; Code[50])
        {
            TableRelation = "Payroll Grade Category";
            DataClassification = CustomerContent;
        }
        field(55; "Valid From"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Valid To"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(65; Position; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Original Calander Id"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(75; "Benefit Template Id"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(76; "Earning Template Id"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(77; "Loan Template Id"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(78; "Leave Template Id"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(80; Type; Option)
        {
            OptionCaption = 'Original,Salary Change,Policy Change,Currency Change,Earning Code Formula Update';
            OptionMembers = Original,"Salary Change","Policy Change","Currency Change","Earning Code Formula Update";
            DataClassification = CustomerContent;
        }
        field(81; "Employee Pos. Assgn. Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(100; "Insurance Service Provider"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(101; "Edit Service Package"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(500; "Max No. Goals per Dimension"; Integer)
        {
            Description = 'PMS';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Max No. Goals per Dimension" < "Min No. Goals per Dimension" then
                    ERROR('Min No. of Goals per Dimension should not be greater than Max No. of Goals per Dimension');
            end;
        }
        field(501; "Min No. Goals per Dimension"; Integer)
        {
            Description = 'PMS';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Max No. Goals per Dimension" < "Min No. Goals per Dimension" then
                    ERROR('Min No. of Goals per Dimension should not be greater than Max No. of Goals per Dimension');
            end;
        }
        field(502; "Max No. KPI Per Goal"; Integer)
        {
            Description = 'PMS';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Max No. KPI Per Goal" < "Min No. KPI per Goal" then
                    ERROR('Min No. of KPI per Goal should not be greater than Max No. of KPI per Goal');
            end;
        }
        field(503; "Min No. KPI per Goal"; Integer)
        {
            Description = 'PMS';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Max No. KPI Per Goal" < "Min No. KPI per Goal" then
                    ERROR('Min No. of KPI per Goal should not be greater than Max No. of KPI per Goal');
            end;
        }
        field(504; "Max No. of Weight per KPI"; Integer)
        {
            Description = 'PMS';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Max No. of Weight per KPI" < "Min No. of Weight per KPI" then
                    ERROR('Min No. of Weight per KPI should not be greater than Max No. of Weight per KPI');
            end;
        }
        field(505; "Min No. of Weight per KPI"; Integer)
        {
            Description = 'PMS';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Max No. of Weight per KPI" < "Min No. of Weight per KPI" then
                    ERROR('Min No. of Weight per KPI should not be greater than Max No. of Weight per KPI');
            end;
        }
        field(506; "Self Rating"; Boolean)
        {
            Description = 'PMS';
            DataClassification = CustomerContent;
        }
        field(507; "Emp.Comp.Req.In Perf.Appr."; Boolean)
        {
            Description = 'PMS';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Earning Code Group", RecrefId, "Employee Code")
        {
            Clustered = true;
        }
        key(Key2; "Valid From")
        {
        }
    }
    procedure OpenEarningCodes()
    var
        PayrollEarningCodeErnGrp: Record "Payroll Earning Code ErnGrp";
    begin
        PayrollEarningCodeErnGrp.RESET;
        PayrollEarningCodeErnGrp.FILTERGROUP(10);
        PayrollEarningCodeErnGrp.SETRANGE("Earning Code Group", Rec."Earning Code Group");
        PayrollEarningCodeErnGrp.FILTERGROUP(0);
        PAGE.RUNMODAL(60031, PayrollEarningCodeErnGrp);
    end;
}