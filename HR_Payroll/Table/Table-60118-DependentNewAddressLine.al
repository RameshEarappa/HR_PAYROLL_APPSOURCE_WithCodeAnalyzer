table 60118 "Dependent New Address Line"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Dependent ID"; Code[20])
        {
            Caption = 'Dependent ID';
            DataClassification = CustomerContent;
        }
        field(2; "Name or Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; Street; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; City; Text[30])
        {
            Caption = 'City';
            Editable = false;
            TableRelation = "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(5; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(6; State; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(7; Primary; Boolean)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Primary = true then
                    PriValidation;
            end;
        }
        field(8; Private; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; Purpose; Option)
        {
            OptionCaption = ' ,Home,Business,Consignment,Delivery,Others';
            OptionMembers = "''",Home,Business,Consignment,Delivery,Others;
            DataClassification = CustomerContent;
        }
        field(10; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Post Code" = '' then
                    CLEAR(City);

                PostCodeRec.RESET;
                PostCodeRec.SETRANGE(Code, "Post Code");
                if PostCodeRec.FINDFIRST then
                    City := PostCodeRec.City;
            end;
        }
        field(20; No2; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; No2, "Line No")
        {
            Clustered = true;
        }
    }

    var
        PostCodeRec: Record "Post Code";
        PostCode: Record "Post Code";

    local procedure PriValidation()
    var
        Rec2: Record "Employee Address Line";
    begin
        Rec2.RESET;
        Rec2.SETRANGE("Dependent ID", "Dependent ID");
        Rec2.SETRANGE(Primary, true);
        if Rec2.FINDFIRST then begin
            if CONFIRM(' A Address type has already marked as Primary. Do you want to change the primary, Click Yes to Continue?', true) then begin
                Rec.Primary := true;
                Rec2.Primary := false;
                Rec2.MODIFY
            end else
                Primary := false;
        end;
    end;
}