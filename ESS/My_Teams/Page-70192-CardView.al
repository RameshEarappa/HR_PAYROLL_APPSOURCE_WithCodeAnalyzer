page 70192 "My Teams Details"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Employee;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field("Personal Title"; Rec.Title)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                }
                field("Joining Date"; Rec."Joining Date")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Line manager"; Rec."Line manager")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Control3; "DME Employee Picture 3")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("No.");
                UpdatePropagation = both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Employee Education")
            {
                Image = EmployeeAgreement;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "My Team Education List";
                RunPageLink = "Emp ID" = FIELD("No.");
            }
            action("Employee Professional Exp.")
            {
                Image = EmployeeAgreement;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "My Team Prof. Exp. List";
                RunPageLink = "Emp No." = FIELD("No.");
                ToolTip = 'Employee Professional Exprience of Last Employer';
            }

            action("Employee Certificate")
            {
                Image = Certificate;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "My Team Certificates List";
                RunPageLink = "Emp ID" = FIELD("No.");
            }

            action("Employee Skills")
            {
                Image = Skills;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                RunObject = Page "My Team Skills List";
                RunPageLink = "Emp ID" = FIELD("No.");
            }
        }
    }
}