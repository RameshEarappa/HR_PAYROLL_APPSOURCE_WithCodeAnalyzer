page 70171 "Empl Earning Code Groups"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Employee Earning Code Groups";
    UsageCategory = Administration;
    ApplicationArea = All;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval,'','','','',Request Approval', ESP = 'New,Process,Report,Approval,'','','','',Request Approval';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Grade Category"; Rec."Grade Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Calander; Rec.Calander)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Gross Salary"; Rec."Gross Salary")
                {
                    ApplicationArea = All;
                }
                field("Travel Class"; Rec."Travel Class")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Valid From"; Rec."Valid From")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Valid To"; Rec."Valid To")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Earning Code")
            {
                ApplicationArea = All;
                Image = Production;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Payroll Earning Code Wrkr";
                RunPageLink = Worker = FIELD("Employee Code"),
                              "Earning Code Group" = FIELD("Earning Code Group");
            }
            action("Leave Type")
            {
                ApplicationArea = All;
                Image = Holiday;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HCM Leave Types Wrkrs List";
                RunPageLink = Worker = FIELD("Employee Code"),
                              "Earning Code Group" = FIELD("Earning Code Group");
            }
            action(Benefit)
            {
                ApplicationArea = All;
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HCM Benefit Wrkrs";
                RunPageLink = Worker = FIELD("Employee Code"),
                              "Earning Code Group" = FIELD("Employee Code");
            }
            action(Loans)
            {
                ApplicationArea = All;
                Image = Loaner;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HCM Loan Table GCC Wrkrs";
            }
            action("Update/ Change Grade")
            {
                ApplicationArea = All;
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //
                end;
            }
        }
    }
    trigger OnInit()
    begin
        PageUserFilter();
    end;

    procedure PageUserFilter()
    var
        Rcodeunit: Codeunit "ESS RC Page";
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Employee Code", Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;
}

