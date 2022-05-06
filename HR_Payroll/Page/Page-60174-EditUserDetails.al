page 60174 "Edit User Details"
{
    Editable = false;
    PageType = Card;
    SourceTable = Employee;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Visible = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Details; "My Profile FactBox")
            {
                Caption = 'Details';
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Bank Details")
            {
                Image = Bank;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;
                ApplicationArea = All;
            }
            action("Personal Contact")
            {
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;
                ApplicationArea = All;
            }
            action(Identification)
            {
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
            action(Education)
            {
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
            action(Experience)
            {
                Image = Accounts;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
            action(Skills)
            {
                Image = Skills;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Employee Skills List";
                RunPageLink = "Emp ID" = FIELD("No.");
                ApplicationArea = All;
            }
            action(Certificates)
            {
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Employee Certificates List";
                RunPageLink = "Emp ID" = FIELD("No.");
                ApplicationArea = All;
            }
            action(Insurance)
            {
                Image = Insurance;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
            action("My Attendance")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UserSetupRec_G.RESET;
        UserSetupRec_G.SETRANGE("User ID", USERID);
        if UserSetupRec_G.FINDFIRST then;
    end;

    var
        UserSetupRec_G: Record "User Setup";
}