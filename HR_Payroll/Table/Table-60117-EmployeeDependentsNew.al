table 60117 "Employee Dependents New"
{
    Caption = 'Employee Dependents New';
    LookupPageID = "Employee Dependent List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
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
                if EmployeeRec.GET("Employee ID") then
                    "Employee Name" := EmployeeRec.FullName;

                UserSetup.RESET;
                UserSetup.SETRANGE("Employee Id", Rec."Employee ID");
                if UserSetup.FINDFIRST then
                    User_ID := UserSetup."User ID";
            end;
        }
        field(3; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(4; "Dependent First Name"; Text[50])
        {
            Caption = 'Dependent First Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateFullName;
            end;
        }
        field(5; "Dependent Middle Name"; Text[50])
        {
            Caption = 'Dependent Middle Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateFullName;
            end;
        }
        field(6; "Dependent Last Name"; Text[50])
        {
            Caption = 'Dependent Last Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateFullName;
            end;
        }
        field(7; "Dependent Name in Arabic"; Text[50])
        {
            Caption = 'Dependent Name in Arabic';
            DataClassification = CustomerContent;
        }
        field(8; "Name in Passport in English"; Text[250])
        {
            Caption = 'Name in Passport in English';
            DataClassification = CustomerContent;
        }
        field(9; Relationship; Option)
        {
            Caption = 'Relationship';
            OptionCaption = ' ,Child,Domestic Partner,Spouse,Ex-Spouse,Family Contact,Other Contact,Parent,Sibling';
            OptionMembers = " ",Child,"Domestic Partner",Spouse,"Ex-Spouse","Family Contact","Other Contact",Parent,Sibling;
            DataClassification = CustomerContent;
        }
        field(10; Gender; Option)
        {
            Caption = 'Gender';
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
            DataClassification = CustomerContent;
        }
        field(11; Nationality; Code[100])
        {
            Caption = 'Nationality';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
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
                if "Date of Birth" > TODAY then
                    ERROR('Date of Birth should be before Today ');
            end;
        }
        field(13; "Marital Status"; Text[30])
        {
            Caption = 'Marital Status';
            DataClassification = CustomerContent;
        }
        field(14; "Child with Special needs"; Boolean)
        {
            Caption = 'Child with Special needs';
            DataClassification = CustomerContent;
        }
        field(15; "Child Educational Level"; Option)
        {
            Caption = 'Child Educational Level';
            OptionCaption = ' ,Elementary,Secondary,University';
            OptionMembers = " ",Elementary,Secondary,University;
            DataClassification = CustomerContent;
        }
        field(16; "Is Emergency Contact"; Boolean)
        {
            Caption = 'Is Emergency Contact';
            DataClassification = CustomerContent;
        }
        field(17; "Full Time Student"; Boolean)
        {
            Caption = 'Full Time Student';
            DataClassification = CustomerContent;
        }
        field(19; "Dependent Contact No."; Integer)
        {
            Caption = 'Dependent Contact No.';
            DataClassification = CustomerContent;
        }
        field(20; "Dependent Contact Type"; Option)
        {
            Caption = 'Dependent Contact Type';
            OptionCaption = ' ,Mobile,Mobile & E-Mail';
            OptionMembers = " ",Mobile,"Mobile & E-Mail";
            DataClassification = CustomerContent;
        }
        field(21; "Primary Contact"; Boolean)
        {
            Caption = 'Primary Contact';
            DataClassification = CustomerContent;
        }
        field(22; Address; Text[250])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(23; "Address 2"; Text[250])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(24; PostCode; Code[20])
        {
            Caption = 'PostCode';
            TableRelation = "Post Code";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
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
                if City = '' then
                    CLEAR(PostCode);
            end;
        }
        field(26; "Country Region code"; Code[20])
        {
            Caption = 'Country Region code';
            DataClassification = CustomerContent;
        }
        field(27; "Private Phone Number"; Integer)
        {
            Caption = 'Private Phone Number';
            DataClassification = CustomerContent;
        }
        field(28; "Direct Phone Number"; Integer)
        {
            Caption = 'Direct Phone Number';
            DataClassification = CustomerContent;
        }
        field(29; "Private Email"; Text[30])
        {
            Caption = 'Private Email';
            DataClassification = CustomerContent;
        }
        field(30; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
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
        }
        field(33; "Full Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50; "Request Type"; Option)
        {
            OptionCaption = ' ,New,Edit,Delete';
            OptionMembers = " ",New,Edit,Delete;
            DataClassification = CustomerContent;
        }
        field(51; "Select Dependent No"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(52; "Workflow Status"; Option)
        {
            Caption = 'Workflow Status';
            OptionCaption = 'Open,Send for Approval,Approved';
            OptionMembers = Open,"Pending Approval",Released;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                WF_Action;
            end;
        }
        field(53; Created; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(54; User_ID; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(55; No2; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; No2, "Employee ID")
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


        EduClimbeRec.RESET;
        EduClimbeRec.SETRANGE("Dependent ID", Rec."No.");
        if EduClimbeRec.FINDFIRST then
            ERROR(Error001);
    end;

    trigger OnInsert()
    begin
        INITINSERT();
        ValidateFullName;

        UserSetup.GET(USERID);
        if not UserSetup."HR Manager" then
            VALIDATE("Employee ID", UserSetup."Employee Id");
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
        UserSetup: Record "User Setup";
        NewDepNo: Code[20];

    local procedure INITINSERT()
    begin
        HrSetup.RESET();
        HrSetup.GET();
        HrSetup.TESTFIELD("Dependent Request");
        if "No." = '' then begin
            NoSeriesMgt.InitSeries(HrSetup."Dependent Request", xRec."No. Series", TODAY, No2, "No. Series");
        end;
    end;

    local procedure ValidateFullName()
    begin
        "Full Name" := "Dependent First Name" + ' ' + "Dependent Middle Name" + ' ' + "Dependent Last Name"
    end;

    local procedure WF_Action()
    var
        DepMasterRec: Record "Employee Dependents Master";
        RecAddLIne: Record "Dependent New Address Line";
        RecContLine: Record "Dependent New Contacts Line";
        DepAddLineRec: Record "Employee Address Line";
        DeptConLineRec: Record "Employee Contacts Line";
    begin
        if "Workflow Status" = "Workflow Status"::Released then begin
            if ("Request Type" = "Request Type"::Edit) and (Created = false) then begin
                DepMasterRec.RESET;
                DepMasterRec.SETRANGE("No.", "Select Dependent No");
                DepMasterRec.SETRANGE("Employee ID", "Employee ID");
                if DepMasterRec.FINDFIRST then begin
                    DepMasterRec.TRANSFERFIELDS(Rec);
                    DepMasterRec.MODIFY;
                end;

                DepAddLineRec.RESET;
                DepAddLineRec.SETRANGE("Dependent ID", "Select Dependent No");
                if DepAddLineRec.FINDSET then begin
                    repeat
                        DepAddLineRec.DELETE;
                    until DepAddLineRec.NEXT = 0;
                end;

                RecAddLIne.RESET;
                RecAddLIne.SETRANGE(No2, No2);
                if RecAddLIne.FINDSET then begin
                    repeat
                        DepAddLineRec.INIT;
                        DepAddLineRec.TRANSFERFIELDS(RecAddLIne);
                        DepAddLineRec."Dependent ID" := "Select Dependent No";
                        DepAddLineRec.INSERT;
                    until RecAddLIne.NEXT = 0;
                end;

                DeptConLineRec.RESET;
                DeptConLineRec.SETRANGE("Dependent ID", "Select Dependent No");
                if DeptConLineRec.FINDFIRST then begin
                    repeat
                        DeptConLineRec.DELETE;
                    until DeptConLineRec.NEXT = 0;
                end;

                RecContLine.RESET;
                RecContLine.SETRANGE(No2, No2);
                if RecContLine.FINDSET then begin
                    repeat
                        DeptConLineRec.INIT;
                        DeptConLineRec.TRANSFERFIELDS(RecContLine);
                        DeptConLineRec."Dependent ID" := "Select Dependent No";
                        DeptConLineRec.INSERT;
                    until RecContLine.NEXT = 0;
                end;
                Created := true;
            end;

            if ("Request Type" = "Request Type"::New) and (Created = false) then begin
                HrSetup.GET();
                HrSetup.TESTFIELD("Dependent Nos.");
                NewDepNo := NoSeriesMgt.GetNextNo(HrSetup."Dependent Nos.", TODAY, true);
                DepMasterRec.INIT;
                DepMasterRec.TRANSFERFIELDS(Rec);
                DepMasterRec."No." := NewDepNo;
                DepMasterRec.INSERT;

                RecAddLIne.RESET;
                RecAddLIne.SETRANGE(No2, No2);
                if RecAddLIne.FINDSET then begin
                    repeat
                        DepAddLineRec.INIT;
                        DepAddLineRec.TRANSFERFIELDS(RecAddLIne);
                        DepAddLineRec."Dependent ID" := NewDepNo;
                        DepAddLineRec.INSERT;
                    until RecAddLIne.NEXT = 0;
                end;

                RecContLine.RESET;
                RecContLine.SETRANGE(No2, No2);
                if RecContLine.FINDSET then begin
                    repeat
                        DeptConLineRec.INIT;
                        DeptConLineRec.TRANSFERFIELDS(RecContLine);
                        DeptConLineRec."Dependent ID" := NewDepNo;
                        DeptConLineRec.INSERT;
                    until RecContLine.NEXT = 0;
                end;
                Created := true;
            end;

            if ("Request Type" = "Request Type"::Delete) and (Created = false) then begin
                DepMasterRec.RESET;
                DepMasterRec.SETRANGE("No.", "Select Dependent No");
                DepMasterRec.SETRANGE("Employee ID", "Employee ID");
                if DepMasterRec.FINDFIRST then
                    DepMasterRec.DELETE;

                DepAddLineRec.RESET;
                DepAddLineRec.SETRANGE("Dependent ID", "Select Dependent No");
                if DepAddLineRec.FINDSET then begin
                    repeat
                        DepAddLineRec.DELETE;
                    until DepAddLineRec.NEXT = 0;
                end;

                DeptConLineRec.RESET;
                DeptConLineRec.SETRANGE("Dependent ID", "Select Dependent No");
                if DeptConLineRec.FINDFIRST then begin
                    repeat
                        DeptConLineRec.DELETE;
                    until DeptConLineRec.NEXT = 0;
                end;
            end;
        end;
    end;
}