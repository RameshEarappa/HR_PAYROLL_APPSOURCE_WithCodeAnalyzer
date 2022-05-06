report 60023 "Transfer of Salary"
{
    DefaultLayout = RDLC;
    //RDLCLayout = 'TransferofSalary.rdlc';
    Caption = 'Transfer of Salary';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Document Request"; "Document Request")
        {
            column(EmployeeID_DocumentRequest; "Document Request"."Employee ID")
            {
            }
            column(Addressee_DocumentRequest; "Document Request".Addressee)
            {
            }
            column(EmpFullName; EmpFullName)
            {
            }
            column(joinDate; FORMAT(joinDate, 15, '<Day,2> <Month,2> <Year4>'))
            {
            }
            column(ID_Country; IDEmpRec."Issuing Country")
            {
            }
            column(ID_No; IDEmpRec."Identification No.")
            {
            }
            column(CompName; CompanyInfo.Name)
            {
            }
            column(Comp_Logo; CompanyInfo.Picture)
            {
            }
            column(Posison; JobPosRec."Position ID")
            {
            }
            column(AcNo; BankAccEmp."Bank Acccount Number")
            {
            }
            column(BankName; BankAccEmp."Bank Name")
            {
            }
            column(bankAddress; BankAdd)
            {
            }
            column(TodayDate; FORMAT(ThisDate, 15, '<Day,2> <Month,2> <Year4>'))
            {
            }
            column(CurrCode; EarnCodeGrRec.Currency)
            {
            }
            column(GrossSal; ROUND(EarnCodeGrRec."Gross Salary" / 12))
            {
            }

            trigger OnAfterGetRecord();
            begin
                if EmpRec.GET("Document Request"."Employee ID") then;
                EmpFullName := EmpRec.FullName;
                joinDate := EmpRec."Joining Date";

                IDEmpRec.RESET;
                IDEmpRec.SETRANGE("Employee No.", "Document Request"."Employee ID");
                IDEmpRec.SETRANGE("Identification Type", 'PASSPORT');
                if IDEmpRec.FINDFIRST then;

                JobPosRec.RESET;
                JobPosRec.SETRANGE(Worker, "Document Request"."Employee ID");
                JobPosRec.SETRANGE("Is Primary Position", true);
                if JobPosRec.FINDFIRST then;

                BankAccEmp.RESET;
                BankAccEmp.SETRANGE("Employee Id", "Document Request"."Employee ID");
                BankAccEmp.SETRANGE(Primary, true);
                if BankAccEmp.FINDFIRST then;

                BankAdd := GetAddress;

                EarnCodeGrRec.RESET;
                EarnCodeGrRec.SETRANGE("Employee Code", "Document Request"."Employee ID");
                EarnCodeGrRec.SETRANGE("Valid To", 0D);
                if EarnCodeGrRec.FINDFIRST then;
            end;
        }
    }
    trigger OnInitReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        ThisDate := TODAY;
    end;

    var
        EmpRec: Record Employee;
        BankAccEmp: Record "Employee Bank Account";
        EmpFullName: Text;
        IDEmpRec: Record "Identification Master";
        CompanyInfo: Record "Company Information";
        joinDate: Date;
        JobPosRec: Record "Payroll Job Pos. Worker Assign";
        ThisDate: Date;
        EarnCodeGrRec: Record "Employee Earning Code Groups";
        BankAdd: Text;

    procedure GetAddress(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        CR: Text[1];
    begin
        BankAccEmp.CALCFIELDS(Address);
        if not BankAccEmp.Address.HASVALUE then
            exit('');

        CR[1] := 10;
        BankAccEmp.CALCFIELDS(Address);
        BankAccEmp.Address.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;
}