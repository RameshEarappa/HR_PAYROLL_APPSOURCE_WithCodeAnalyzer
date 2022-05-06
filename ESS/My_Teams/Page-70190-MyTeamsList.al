page 70190 "My Teams List"
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = "MY Teams List";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater("General")
            {
                field("Reporting's Employee ID"; Rec."Reporting's Employee ID")
                {
                    Caption = 'Employee Id';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        EmpCardPgL: Page "My Teams Details";
                        EmployeeRecL: Record Employee;
                    begin
                        EmployeeRecL.Reset();
                        EmployeeRecL.SetRange("No.", Rec."Reporting's Employee ID");
                        if EmployeeRecL.FindFirst() then begin
                            Clear(EmpCardPgL);
                            EmpCardPgL.SetTableView(EmployeeRecL);
                            EmpCardPgL.SetRecord(EmployeeRecL);
                            EmpCardPgL.RunModal();
                        end;
                    end;
                }
                field("Reporting's Employee Name"; Rec."Reporting's Employee Name")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Name';
                    trigger OnDrillDown()
                    var
                        EmpCardPgL: Page "My Teams Details";
                        EmployeeRecL: Record Employee;
                    begin
                        EmployeeRecL.Reset();
                        EmployeeRecL.SetRange("No.", Rec."Reporting's Employee ID");
                        if EmployeeRecL.FindFirst() then begin
                            Clear(EmpCardPgL);
                            EmpCardPgL.SetTableView(EmployeeRecL);
                            EmpCardPgL.SetRecord(EmployeeRecL);
                            EmpCardPgL.RunModal();
                        end;
                    end;
                }
            }
        }
        area(factboxes)
        {
            part(Control3; "DME Employee Picture 3")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("Reporting's Employee ID");
                UpdatePropagation = both;
            }
        }
    }

    trigger OnOpenPage()
    var
        CURecL: Codeunit "ESS RC Page";
    begin
        CURecL.FindandFillLoginEmployeeTeams(Database.UserId);
    end;
}