table 60014 "Identification Master"
{
    Caption = 'Identification Master';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Employee,Dependent';
            OptionMembers = " ",Employee,Dependent;
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                    HrSetup.GET;
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                INITINSERT;
                if EmployeeRec.GET("Employee No.") then
                    "Document Type" := "Document Type"::Employee;
            end;
        }
        field(4; "Identification Type"; Code[20])
        {
            Caption = 'Identification Type';
            TableRelation = "Identification Doc Type Master";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                INITINSERT;
                RecIdentType.RESET;
                if RecIdentType.GET("Identification Type") then
                    VALIDATE(Description, RecIdentType.Description);
            end;
        }
        field(5; Description; Text[20])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "Identification No."; Text[20])
        {
            Caption = 'Identification No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Identification No." := UPPERCASE("Identification No.");
            end;
        }
        field(7; "Issuing Country"; Code[100])
        {
            Caption = 'Issuing Country';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if CountryRec.GET("Issuing Country") then
                    "Issuing Country" := CountryRec.Name;
            end;
        }
        field(8; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                HIJIRIDATETEXT: Text;
                IdentificationMasterREcL: Record "Identification Master";

            begin
                EmplDepenMaster.Reset();
                EmplDepenMaster.SetRange("No.", "Dependent No");
                if EmplDepenMaster.FindFirst() then begin
                    Validate("Master-Record ID", EmplDepenMaster."Employee ID");
                    Modify();
                end;

                if ("Expiry Date" < "Issue Date") and ("Expiry Date" <> 0D) then
                    ERROR('Expiry Date cannot be less than Issue date');

                IdentificationMasterREcL.RESET;
                IdentificationMasterREcL.SETRANGE("Document Type", IdentificationMasterREcL."Document Type"::Employee);
                IdentificationMasterREcL.SETRANGE("Identification Type", "Identification Type");
                IdentificationMasterREcL.SETRANGE("Employee No.", "Employee No.");
                IF IdentificationMasterREcL.FINDSET THEN BEGIN
                    REPEAT
                        IF ("Issue Date" <= IdentificationMasterREcL."Expiry Date") AND ("Issue Date" >= IdentificationMasterREcL."Issue Date") THEN
                            ERROR('Issue Date overlaps with the existing record.');
                    UNTIL IdentificationMasterREcL.NEXT = 0;
                END;

                IdentificationMasterREcL.RESET;
                IdentificationMasterREcL.SETRANGE("Document Type", IdentificationMasterREcL."Document Type"::Dependent);
                IdentificationMasterREcL.SETRANGE("Identification Type", "Identification Type");
                IdentificationMasterREcL.SETRANGE("Dependent No", "Dependent No");
                IF IdentificationMasterREcL.FINDSET THEN BEGIN
                    REPEAT
                        IF ("Issue Date" <= IdentificationMasterREcL."Expiry Date") AND ("Issue Date" >= IdentificationMasterREcL."Issue Date") THEN
                            ERROR('Issue Date overlaps with the existing record.');
                    UNTIL IdentificationMasterREcL.NEXT = 0;
                END;
            end;
        }
        field(9; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IdentificationMasterREcL: Record "Identification Master";
            begin
                if "Expiry Date" < "Issue Date" then
                    ERROR('Expiry Date cannot be less than Issue date');
                IdentificationMasterREcL.RESET;
                IdentificationMasterREcL.SETRANGE("Document Type", IdentificationMasterREcL."Document Type"::Employee);
                IdentificationMasterREcL.SETRANGE("Identification Type", "Identification Type");
                IdentificationMasterREcL.SETRANGE("Employee No.", "Employee No.");
                IF IdentificationMasterREcL.FINDSET THEN BEGIN
                    REPEAT
                        IF ("Expiry Date" >= IdentificationMasterREcL."Expiry Date") AND ("Expiry Date" <= IdentificationMasterREcL."Issue Date") THEN
                            ERROR('Expiry Date overlaps with the existing record.');
                    UNTIL IdentificationMasterREcL.NEXT = 0;
                END;

                IdentificationMasterREcL.RESET;
                IdentificationMasterREcL.SETRANGE("Document Type", IdentificationMasterREcL."Document Type"::Dependent);
                IdentificationMasterREcL.SETRANGE("Identification Type", "Identification Type");
                IdentificationMasterREcL.SETRANGE("Dependent No", "Dependent No");
                IF IdentificationMasterREcL.FINDSET THEN BEGIN
                    REPEAT
                        IF ("Expiry Date" >= IdentificationMasterREcL."Expiry Date") AND ("Expiry Date" <= IdentificationMasterREcL."Issue Date") THEN
                            ERROR('Expiry Date overlaps with the existing record.');
                    UNTIL IdentificationMasterREcL.NEXT = 0;
                END;
            end;
        }
        field(10; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(11; "Dependent No"; Code[20])
        {
            TableRelation = "Employee Dependents Master";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Dependent No" <> '' then
                    "Document Type" := "Document Type"::Dependent
            end;
        }
        field(12; "ID Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Regular,Diplomatic,VIP';
            OptionMembers = "''",Regular,Diplomatic,VIP;
            DataClassification = CustomerContent;
        }
        field(13; WarningMsg; Text[35])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Issuing Authority"; Code[20])
        {
            TableRelation = "Issuing Authority";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                RecIssuAuthority: Record "Issuing Authority";
            begin
                RecIssuAuthority.SetRange(Code, "Issuing Authority");
                IF RecIssuAuthority.FINDFIRST THEN
                    "Issuing Authority Description" := RecIssuAuthority.Description;
            end;
        }
        field(15; "Issue Date (Hijiri)"; Text[30])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(16; "Expiry Date (Hijiri)"; Text[30])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(17; "Created From Doc. No."; Code[80])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(18; "Visa Type"; Option)
        {
            Description = 'PHASE - 2';
            OptionCaption = ' ,Work Visa,Family Visa,Hajj Visa,Visit Visa,Exit-Reentry Visa,Mission Visa';
            OptionMembers = " ","Work Visa","Family Visa","Hajj Visa","Visit Visa","Exit-Reentry Visa","Mission Visa";
            DataClassification = CustomerContent;
        }
        field(19; "Active Document"; Boolean)
        {
            Description = 'PHASE - 2';
            Editable = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                UserSetupRecL: Record "User Setup";
                IdentificationMasterRecL: Record "Identification Master";
            begin
                IF "Document Type" = "Document Type"::Dependent THEN BEGIN
                    UserSetupRecL.RESET;
                    IF UserSetupRecL.GET(USERID) THEN BEGIN
                        IF "Active Document" THEN BEGIN
                            IdentificationMasterRecL.RESET;
                            IdentificationMasterRecL.SETRANGE("Dependent No", "Dependent No");
                            IdentificationMasterRecL.SETRANGE("Identification Type", "Identification Type");
                            IdentificationMasterRecL.SETRANGE("Active Document", TRUE);
                            IF IdentificationMasterRecL.FINDSET THEN BEGIN
                                IdentificationMasterRecL.MODIFYALL("Active Document", FALSE);
                            END;
                        END
                    END;
                END;

                IF "Document Type" = "Document Type"::Employee THEN BEGIN
                    UserSetupRecL.RESET;
                    IF UserSetupRecL.GET(USERID) THEN BEGIN
                        IF "Active Document" THEN BEGIN
                            IdentificationMasterRecL.RESET;
                            IdentificationMasterRecL.SETRANGE("Employee No.", "Employee No.");
                            IdentificationMasterRecL.SETRANGE("Identification Type", "Identification Type");
                            IdentificationMasterRecL.SETRANGE("Active Document", TRUE);
                            IF IdentificationMasterRecL.FINDSET THEN BEGIN
                                IdentificationMasterRecL.MODIFYALL("Active Document", FALSE);
                            END;
                        END;
                    END;
                END;

                IF "Active Document" THEN
                    MESSAGE(' %1 Document Activated Successfully.', "Identification Type");
            end;
        }

        field(20; "Issuing Authority Description"; Text[150])
        {
            DataClassification = CustomerContent;
            TableRelation = "Issuing Authority";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                RecIssuAuthority: Record "Issuing Authority";
            begin
                Clear(RecIssuAuthority);
                RecIssuAuthority.SETFILTER(Code, "Issuing Authority Description");
                RecIssuAuthority.FINDFIRST;
                "Issuing Authority" := RecIssuAuthority.Code;
                "Issuing Authority Description" := RecIssuAuthority.Description;
            end;
        }
        field(21; "Master-Record ID"; Code[50])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.", "Dependent No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        INITINSERT;
    end;

    var
        RecIdentType: Record "Identification Doc Type Master";
        HrSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeRec: Record Employee;
        CountryRec: Record "Country/Region";
        EmplDepenMaster: Record "Employee Dependents Master";

    procedure INITINSERT()
    begin
        HrSetup.RESET();
        HrSetup.GET();
        if "No." = '' then
            "No." := NoSeriesMgt.GetNextNo(HrSetup."Employee Identification Nos.", Today, true);
    end;
}