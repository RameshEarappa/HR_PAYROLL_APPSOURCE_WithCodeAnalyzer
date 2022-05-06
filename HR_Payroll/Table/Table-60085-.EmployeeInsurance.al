table 60085 "Employee Insurance"
{
    LookupPageID = "Employee Insurance List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee Id"; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(2; Type; Option)
        {
            OptionCaption = ' ,Self,Dependents';
            OptionMembers = "''",Self,Dependents;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CLEAR(Relationship);
                CLEAR(Gender);
                CLEAR("Date Of Birth");
                CLEAR(Nationality);

                if Type = Type::Self then
                    VALIDATE("Person Insured", "Employee Id");

                if EmpRec.GET("Employee Id") then begin
                    IF EarnCodeGrouRec.GET(EmpRec."Earning Code Group") THEN
                        EmployeeEarningCodeGroups.RESET;
                    EmployeeEarningCodeGroups.SETRANGE("Employee Code", EmpRec."No.");
                    EmployeeEarningCodeGroups.SETRANGE("Earning Code Group", EmpRec."Earning Code Group");
                    EmployeeEarningCodeGroups.SETRANGE("Valid To", 0D);
                    if EmployeeEarningCodeGroups.FINDFIRST then begin
                        EarnCodeGrouRec.RESET;
                        EarnCodeGrouRec.SETRANGE("Earning Code Group", EmployeeEarningCodeGroups."Earning Code Group");
                        if EarnCodeGrouRec.FINDFIRST then begin
                            EarnCodeGrouRec.TestField("Insurance Service Provider");
                            "Insurance Service Provider" := EarnCodeGrouRec."Insurance Service Provider";
                        end;
                    end;
                end;
            end;
        }
        field(3; "Person Insured"; Code[20])
        {
            Caption = 'Person Insured ';
            TableRelation = IF (Type = FILTER(Dependents)) "Employee Dependents Master" WHERE("Employee ID" = FIELD("Employee Id"), Status = FILTER(Active));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CLEAR(Relationship);
                CLEAR(Gender);
                CLEAR("Date Of Birth");
                CLEAR(Nationality);

                EmployeeInsurance.RESET;
                EmployeeInsurance.SETRANGE("Employee Id", Rec."Employee Id");
                EmployeeInsurance.SETRANGE("Person Insured", Rec."Person Insured");
                if EmployeeInsurance.FINDFIRST then
                    ERROR('This person is already insured');

                if Type <> Type::Self then begin
                    DepMasterRec.RESET;
                    DepMasterRec.SETRANGE("No.", "Person Insured");
                    DepMasterRec.SETRANGE("Employee ID", "Employee Id");
                    if DepMasterRec.FINDFIRST then begin
                        Relationship := FORMAT(DepMasterRec.Relationship);
                        Gender := FORMAT(DepMasterRec.Gender);
                        "Date Of Birth" := DepMasterRec."Date of Birth";
                        Nationality := DepMasterRec.Nationality;
                        "Person Insured Name" := DepMasterRec."Dependent First Name";
                    end;
                end else begin
                    EmpRec.GET("Employee Id");
                    Gender := FORMAT(EmpRec.Gender);
                    "Date Of Birth" := EmpRec."Birth Date";
                    Nationality := EmpRec.Nationality;
                    "Person Insured Name" := EmpRec.FullName;
                end;

                if Type <> Type::Self then begin
                    DepMasterRec.RESET;
                    DepMasterRec.SETRANGE("No.", "Person Insured");
                    DepMasterRec.SETRANGE("Employee ID", "Employee Id");
                    DepMasterRec.SETRANGE(Relationship, DepMasterRec.Relationship::Child);
                    DepMasterRec.SETRANGE(Gender, DepMasterRec.Gender::Male);
                    if DepMasterRec.FINDFIRST then begin
                        ChildAge := TODAY - DepMasterRec."Date of Birth";
                        ChildAge := ChildAge / 365;
                        if (ChildAge > 18) and (DepMasterRec."Full Time Student" = false) then
                            ERROR('The child is not eligible to get the insurance');
                        if ChildAge > 25 then
                            ERROR('The child is not eligible to get the insurance');
                    end;
                end;

                if Type <> Type::Self then begin
                    DepMasterRec.RESET;
                    DepMasterRec.SETRANGE("No.", "Person Insured");
                    DepMasterRec.SETRANGE("Employee ID", "Employee Id");
                    if DepMasterRec.FINDFIRST then begin
                        if (DepMasterRec.Relationship <> DepMasterRec.Relationship::Child) then //BEGIN
                            if (DepMasterRec.Relationship <> DepMasterRec.Relationship::Spouse) then //BEGIN
                                if (DepMasterRec.Relationship <> DepMasterRec.Relationship::Parent) then
                                    ERROR('Only Parent, Spouse and children are eligible for insurance.');
                    end;
                end;
            end;
        }
        field(4; Relationship; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; Gender; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Date Of Birth"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; Nationality; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Insurance Service Provider"; Code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(9; "Insurance Card No"; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Issue Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CLEAR("Expiry Date");
                if "Expiry Date" <> 0D then begin
                    if "Issue Date" > "Expiry Date" then
                        ERROR(DateError);
                end;
            end;
        }
        field(11; "Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Issue Date" > "Expiry Date" then
                    ERROR(DateError);
            end;
        }
        field(12; "Person Insured Name"; Text[50])
        {
            Caption = 'Person Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(13; "Insurance Category"; Code[20])
        {
            TableRelation = "Insurance Category";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Employee Id", "Person Insured")
        {
            Clustered = true;
        }
    }

    var
        DepMasterRec: Record "Employee Dependents Master";
        EmpRec: Record Employee;
        DateError: Label 'Issue date should not be greaterr than Expiry Date.';
        ChildAge: Decimal;
        EarnCodeGrouRec: Record "Earning Code Groups";
        EmployeeEarningCodeGroups: Record "Employee Earning Code Groups";
        EmployeeInsurance: Record "Employee Insurance";
}