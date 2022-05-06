/*table 60078 "Payroll Increment Steps"
{
    LookupPageID = "Payroll Increment Steps";

    fields
    {
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Grade Category"; Code[50])
        {
            TableRelation = "Payroll Grade Category";
        }
        field(4; Grade; Code[20])
        {
            TableRelation = "Earning Code Groups" WHERE("Grade Category" = FIELD("Grade Category"));
        }
        field(5; "Type of Increment"; Option)
        {
            OptionCaption = 'Gross,Earning Code';
            OptionMembers = Gross,"Earning Code";
        }
        field(6; Steps; Option)
        {
            OptionCaption = 'Step-0,Step-1,Step-2,Step-3,Step-4,Step-5,Step-6,Step-7,Step-8,Step-9,Step-10,Step-11,Step-12,Step-13,Step-14,Step-15,Step-16,Step-17,Step-18,Step-19,Step-20,Step-21,Step-22,Step-23,Step-24,Step-25';
            OptionMembers = "Step-0","Step-1","Step-2","Step-3","Step-4","Step-5","Step-6","Step-7","Step-8","Step-9","Step-10","Step-11","Step-12","Step-13","Step-14","Step-15","Step-16","Step-17","Step-18","Step-19","Step-20","Step-21","Step-22","Step-23","Step-24","Step-25";
        }
        field(7; "Calculation Type"; Option)
        {
            OptionCaption = 'Percentage,Amount';
            OptionMembers = Percentage,Amount;

        }
    }

    keys
    {
        key(Key1; "Grade Category", Grade, "Type of Increment", "Calculation Type", "Line No.")
        {
            Clustered = true;
        }
        // Commented By Avinash  key(Key2;'')
        // Commented By Avinash  {
        // Commented By Avinash     Enabled = false;
        // Commented By Avinash  }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PayrollIncrementLine.RESET;
        PayrollIncrementLine.SETRANGE("Grade Category", "Grade Category");
        PayrollIncrementLine.SETRANGE(Grade, Grade);
        PayrollIncrementLine.SETRANGE("Increment Line No.", "Line No.");
        PayrollIncrementLine.SETRANGE("Type of Increment", "Type of Increment");
        PayrollIncrementLine.SETRANGE("Calculation Type", "Calculation Type");
        PayrollIncrementLine.DELETEALL;

        //<LT>
        CLEAR(IncStep);
        IncStep := FORMAT(Steps);*/

/*
EmpCreReq.RESET;
EmpCreReq.SETRANGE("Sub Grade",IncStep);
IF EmpCreReq.FINDFIRST THEN
  ERROR('Record cannot be deleted');
*/
//<LT>
/*
    end;

    trigger OnInsert()
    begin
        PayrollIncrementSteps.RESET;
        PayrollIncrementSteps.SETRANGE(Grade, Grade);
        PayrollIncrementSteps.SETRANGE("Grade Category", "Grade Category");
        PayrollIncrementSteps.SETRANGE(Steps, Steps);
        if PayrollIncrementSteps.FINDFIRST then
            ERROR('You cannot insert duplicate record of Grade Category, Grade and Steps');
    end;

    trigger OnModify()
    begin
        PayrollIncrementSteps.RESET;
        PayrollIncrementSteps.SETRANGE(Grade, Grade);
        PayrollIncrementSteps.SETRANGE("Grade Category", "Grade Category");
        PayrollIncrementSteps.SETRANGE(Steps, Steps);
        if PayrollIncrementSteps.FINDFIRST then
            ERROR('You cannot insert duplicate record of Grade Category, Grade and Steps');
    end;

    trigger OnRename()
    begin

        PayrollIncrementSteps.RESET;
        PayrollIncrementSteps.SETRANGE(Grade, Grade);
        PayrollIncrementSteps.SETRANGE("Grade Category", "Grade Category");
        PayrollIncrementSteps.SETRANGE(Steps, Steps);
        if PayrollIncrementSteps.FINDFIRST then
            ERROR('You cannot insert duplicate record of Grade Category, Grade and Steps');


        PayrollIncrementLine.RESET;
        PayrollIncrementLine.SETRANGE("Increment Line No.", "Line No.");
        if PayrollIncrementLine.FINDFIRST then
            if not CONFIRM('Increment Line exists for this Increment steps. Modifying the record will delete the Increment lines.Do you want to continue ?', false) then
                ERROR('');

        PayrollIncrementLine.RESET;
        PayrollIncrementLine.SETRANGE("Increment Line No.", "Line No.");
        PayrollIncrementLine.DELETEALL;
    end;

    var
        PayrollIncrementLine: Record "Payroll Increment Line";
        PayrollIncrementSteps: Record "Payroll Increment Steps";
        IncStep: Code[10];
}

*/