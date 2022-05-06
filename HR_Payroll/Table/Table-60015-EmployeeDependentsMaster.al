table 60015 "Employee Dependents Master"
{
    Caption = 'Employee Dependents Master';
    LookupPageID = "Employee Dependent List MS1";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
                if "No." <> xRec."No." then begin
                    HrSetup.GET;
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
                if EmployeeRec.GET("Employee ID") then
                    "Employee Name" := EmployeeRec.FullName;
            end;
        }
        field(3; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(4; "Dependent First Name"; Text[50])
        {
            Caption = 'Dependent First Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
                ValidateFullName;
                Status := Status::Active;
            end;
        }
        field(5; "Dependent Middle Name"; Text[50])
        {
            Caption = 'Dependent Middle Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
                ValidateFullName;
            end;
        }
        field(6; "Dependent Last Name"; Text[50])
        {
            Caption = 'Dependent Last Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
                ValidateFullName;
            end;
        }
        field(7; "Dependent Name in Arabic"; Text[50])
        {
            Caption = 'Dependent Name in Arabic';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(8; "Name in Passport in English"; Text[250])
        {
            Caption = 'Name in Passport in English';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(9; Relationship; Option)
        {
            Caption = 'Relationship';
            OptionCaption = ' ,Child,Domestic Partner,Spouse,Ex-Spouse,Family Contact,Other Contact,Parent,Sibling';
            OptionMembers = " ",Child,"Domestic Partner",Spouse,"Ex-Spouse","Family Contact","Other Contact",Parent,Sibling;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                AdvancePayrollSetup: Record "Advance Payroll Setup";
            begin
                OnEdit;

                if Relationship = Relationship::Spouse then begin
                    AdvancePayrollSetup.GET;
                    AdvancePayrollSetup.TESTFIELD("Default Marital Status Spouse");
                    "Marital Status" := AdvancePayrollSetup."Default Marital Status Spouse";
                end
                else
                    "Marital Status" := '';
            end;
        }
        field(10; Gender; Option)
        {
            Caption = 'Gender';
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(11; Nationality; Code[20])
        {
            Caption = 'Nationality';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
                if CountryRec.GET(Nationality) then
                    Nationality := CountryRec.Name;
            end;
        }
        field(12; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
                if "Date of Birth" > TODAY then
                    ERROR('Date of Birth should be before Today ');
            end;
        }
        field(13; "Marital Status"; Text[30])
        {
            Caption = 'Marital Status';
            TableRelation = "Marital Status";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(14; "Child with Special needs"; Boolean)
        {
            Caption = 'Child with Special needs';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(15; "Child Educational Level"; Option)
        {
            Caption = 'Child Educational Level';
            OptionCaption = ' ,Elementary,Secondary,University';
            OptionMembers = " ",Elementary,Secondary,University;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(16; "Is Emergency Contact"; Boolean)
        {
            Caption = 'Is Emergency Contact';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(17; "Full Time Student"; Boolean)
        {
            Caption = 'Full Time Student';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(18; "Workflow Status"; Option)
        {
            Caption = 'Workflow Status';
            OptionCaption = 'Open,Send for Approval,Approved';
            OptionMembers = Open,"Pending Approval",Released;
            DataClassification = CustomerContent;
        }
        field(19; "Dependent Contact No."; Integer)
        {
            Caption = 'Dependent Contact No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(20; "Dependent Contact Type"; Option)
        {
            Caption = 'Dependent Contact Type';
            OptionCaption = ' ,Mobile,Mobile & E-Mail';
            OptionMembers = " ",Mobile,"Mobile & E-Mail";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(21; "Primary Contact"; Boolean)
        {
            Caption = 'Emergency Contact';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(22; Address; Text[250])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(23; "Address 2"; Text[250])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(24; PostCode; Code[20])
        {
            Caption = 'PostCode';
            TableRelation = "Post Code";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
                PostCodeRec.SETRANGE(Code, PostCode);
                if PostCodeRec.FINDFIRST then begin
                    City := PostCodeRec.City;
                    if CountryRec.GET(PostCodeRec."Country/Region Code") then
                        "Country Region code" := CountryRec.Name;
                end;

                if PostCode = '' then begin
                    CLEAR(City);
                    CLEAR("Country Region code");
                end;
            end;
        }
        field(25; City; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
                if City = '' then
                    CLEAR(PostCode);
            end;
        }
        field(26; "Country Region code"; Code[20])
        {
            Caption = 'Country Region code';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(27; "Private Phone Number"; Integer)
        {
            Caption = 'Private Phone Number';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(28; "Direct Phone Number"; Integer)
        {
            Caption = 'Direct Phone Number';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(29; "Private Email"; Text[30])
        {
            Caption = 'Private Email';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(30; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(31; "Personal Title"; Option)
        {
            Caption = 'Personal Title';
            OptionCaption = 'Mr.,Ms.,Mrs.,Miss.';
            OptionMembers = Mr,Ms,Mrs,Miss;
            DataClassification = CustomerContent;
        }
        field(32; Status; Option)
        {
            OptionCaption = 'Inactive,Active';
            OptionMembers = Inactive,Active;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                OnEdit;
            end;
        }
        field(33; "Full Name"; Text[250])
        {
            Description = 'P_2';
            DataClassification = CustomerContent;
        }
        field(34; "Religion"; Code[20])
        {
            TableRelation = "Payroll Religion";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                ReliginRec: Record "Payroll Religion";
            begin
                if (Religion = '') and (xRec.Religion <> Rec.Religion) then
                    Clear("Religion Desciption");

                ReliginRec.Reset();
                if ReliginRec.Get(Religion) then
                    "Religion Desciption" := ReliginRec.Description;

            end;
        }
        field(35; "Religion Desciption"; Text[120])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(36; "Is Nominee"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.", "Employee ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Dependent First Name", "Dependent Last Name")
        {
        }
    }

    trigger OnDelete()
    begin
        OnEdit;
        EduClimbeRec.RESET;
        EduClimbeRec.SETRANGE("Dependent ID", Rec."No.");
        if EduClimbeRec.FINDFIRST then
            ERROR(Error001);
    end;

    trigger OnInsert()
    begin
        INITINSERT();
        ValidateFullName;
    end;

    trigger OnRename()
    begin
        OnEdit;
    end;

    var
        HrSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeRec: Record Employee;
        PostCodeRec: Record "Post Code";
        gField: Record "Field";
        CountryRec: Record "Country/Region";
        EduClimbeRec: Record "Educational Claim Lines LT";
        Error001: Label 'Record cannot be Deleted.';

    local procedure INITINSERT()
    begin
        HrSetup.RESET();
        HrSetup.GET();
        HrSetup.TESTFIELD("Dependent Request");
        if "No." = '' then begin
            NoSeriesMgt.InitSeries(HrSetup."Dependent Request", xRec."No. Series", TODAY, "No.", "No. Series");
        end;
    end;

    local procedure OnEdit()
    begin
        VALIDATE("Workflow Status", "Workflow Status"::Released);
    end;

    local procedure ValidateFullName()
    begin
        "Full Name" := "Dependent First Name" + ' ' + "Dependent Middle Name" + ' ' + "Dependent Last Name"
    end;


    procedure FullName(): Text[250]
    begin
        if "Dependent Middle Name" = '' then
            exit("Dependent First Name" + ' ' + "Dependent Last Name");

        exit("Dependent First Name" + ' ' + "Dependent Middle Name" + ' ' + "Dependent Last Name");
    end;
}