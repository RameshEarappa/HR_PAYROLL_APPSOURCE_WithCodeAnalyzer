table 60016 "Document Request"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Document Request ID"; Code[20])
        {
            Caption = 'Document Request ID';
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                AllowEditDelet;

                if "Document Request ID" <> xRec."Document Request ID" then begin
                    HR_Setup.GET;
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            TableRelation = Employee where(Status = filter(Active));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                AllowEditDelet;

                EmployeRec.RESET;
                if EmployeRec.GET("Employee ID") then
                    "Employee Name" := EmployeRec."First Name";

                if "Employee ID" = '' then
                    "Employee Name" := '';
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                AllowEditDelet;
            end;
        }
        field(4; Addressee; Text[50])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                AllowEditDelet;
            end;
        }
        field(5; "Document format ID"; Option)
        {
            Caption = 'Document format';
            OptionCaption = ' ,Salary Certificate';
            OptionMembers = " ","Salary Certificate";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                AllowEditDelet;

                if "Document format ID" = "Document format ID"::" " then
                    "Document Title" := '';
            end;
        }
        field(6; "Document Title"; Code[20])
        {
            Caption = 'Document Title';
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                AllowEditDelet;
            end;
        }
        field(7; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                AllowEditDelet;
            end;
        }
        field(8; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                AllowEditDelet;
            end;
        }
        field(9; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(10; "WorkFlow Status"; Option)
        {
            Caption = 'WorkFlow Status';
            Editable = false;
            OptionCaption = 'Open,Approved,Send for Approval,Rejected';
            OptionMembers = Open,Released,"Pending Approval",Rejected;
            DataClassification = CustomerContent;
        }
        field(11; "Certificate For Dependent"; Code[20])
        {
            TableRelation = "Employee Dependents Master" WHERE("Employee ID" = FIELD("Employee ID"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                EmployeeDependentsMaster: Record "Employee Dependents Master";
            begin
                if "Certificate For Dependent" <> '' then begin
                    EmployeeDependentsMaster.RESET;
                    EmployeeDependentsMaster.SETRANGE("No.", "Certificate For Dependent");
                    if EmployeeDependentsMaster.FINDFIRST then begin
                        "Dependent Name" := EmployeeDependentsMaster."Dependent First Name" + ' ' + EmployeeDependentsMaster."Dependent Middle Name" + EmployeeDependentsMaster."Dependent Last Name";
                    end;
                end
                else begin
                    "Dependent Name" := '';
                end;
            end;
        }
        field(12; "Dependent Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(13; RecId; RecordId)
        {
            DataClassification = CustomerContent;
        }
        field(14; Completed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(15; "User_ID_Rec"; Code[250])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Document Request ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        AllowEditDelet;
    end;

    trigger OnInsert()
    begin
        INITINSERT();
    end;

    trigger OnRename()
    begin
        AllowEditDelet;
    end;

    var
        HR_Setup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeRec: Record Employee;
        DR: Record "Document Request";

    local procedure INITINSERT()
    begin
        HR_Setup.RESET();
        HR_Setup.GET();
        if "Document Request ID" = '' then begin
            "Document Request ID" := NoSeriesMgt.GetNextNo(HR_Setup."Document Request ID", Today, true);
            "Request Date" := TODAY;
            "Document Date" := TODAY;
            RecId := RecId;
            User_ID_Rec := Database.UserId;
        end;
    end;

    procedure AllowEditDelet()
    var
        Rec1: Record "Document Request";
    begin
        if "WorkFlow Status" <> Rec1."WorkFlow Status"::Open then
            ERROR('Status should be open');
    end;


    procedure AssistEdit(Old_DR: Record "Document Request"): Boolean
    var
        Cust: Record Customer;
    begin
        DR.Reset();
        if DR.FindSet() then begin
            repeat
                DR := Rec;
                HR_Setup.GET;
                HR_Setup.TESTFIELD("Document Request ID");
                if NoSeriesMgt.SelectSeries(HR_Setup."Document Request ID", Old_DR."Document Request ID", "No. Series") then begin
                    NoSeriesMgt.SetSeries("Document Request ID");
                    Rec := DR;
                    exit(true);
                end;
            until DR.Next() = 0;
        end;
    end;
}