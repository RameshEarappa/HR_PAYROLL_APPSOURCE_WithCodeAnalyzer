page 60080 "Educational Claim Subform"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Educational Claim Lines LT";
    SourceTableView = SORTING("Claim ID", "Employee No.", "Line No.")
                      ORDER(Ascending);
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Claim ID"; Rec."Claim ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Allowance Type"; Rec."Allowance Type")
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field("Dependent ID"; Rec."Dependent ID")
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Dependent Name"; Rec."Dependent Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Claim Date"; Rec."Claim Date")
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Fee Description"; Rec."Fee Description")
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field("Level of Education"; Rec."Level of Education")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Institution Name"; Rec."Institution Name")
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field(Grade; Rec.Grade)
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Utilized Amount"; Rec."Utilized Amount")
                {
                    ApplicationArea = All;
                }
                field("Balance Amount"; Rec."Balance Amount")
                {
                    ApplicationArea = All;
                }
                field("Selected Currency"; Rec."Selected Currency")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Selected Claim Amount"; Rec."Selected Claim Amount")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Current Claim Amount"; Rec."Current Claim Amount")
                {
                    Editable = EditBool;
                    ApplicationArea = All;
                }
                field("Academic year"; Rec."Academic year")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EditFields;
    end;

    trigger OnAfterGetRecord()
    begin
        EditFields;
    end;

    trigger OnInit()
    begin
        EditFields;
    end;

    var
        EditBool: Boolean;
        EduClaim_L: Record "Educational Claim Lines LT";
        EmpRecL: Record Employee;
        EducationalAllowanceLT: Record "Educational Allowance LT";
        CountofChil: Integer;
        DepID: Code[20];
        NOcount: Integer;
        EduClamLineRecL: Record "Educational Claim Lines LT";

    local procedure EditFields()
    var
        HeadRec: Record "Educational Claim Header LT";
    begin
        HeadRec.RESET;
        HeadRec.SETRANGE("Claim ID", Rec."Claim ID");
        HeadRec.SETRANGE("Employee No.", Rec."Employee No.");
        if HeadRec.FINDFIRST then begin
            if HeadRec."Approval Status" <> HeadRec."Approval Status"::Open then
                EditBool := false
            else
                EditBool := true;
        end;
    end;
}