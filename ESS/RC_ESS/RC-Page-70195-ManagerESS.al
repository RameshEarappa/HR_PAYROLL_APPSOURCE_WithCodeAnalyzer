page 70195 "Manager Self Servies ESS Role"
{
    Caption = 'Employee Self Servies';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group("Employee Details")
            {
                part("USer Profile"; "DME Employee Picture 2")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(p1)
            {
                ShowCaption = false;
                part(ChartESS; "My Leave Balance Chart")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Fixed Layout")
            {
                part(IDDownload; "Empl. Identification download")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Fixed Layout 2")
            {
                part(HrAnnouncement; "HR Announcements ESS List")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(Control16; "DME Activities Cue")
            {
                AccessByPermission = TableData "DME Activities Cue" = I;
                ApplicationArea = Basic, Suite;
            }
            part(Control17; "DME Activities Cue 2")
            {
                AccessByPermission = TableData "DME Activities Cue" = I;
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(embedding)
        {
            ToolTip = 'Manage your business. See KPIs, trial balance, and favorite customers.';
            action("My Personal Info.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'My Personal Info.';
                Image = ContactPerson;
                RunObject = Page "Employee PErsonal Info. DME";
            }
            action("My Team")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'My Team';
                Image = TeamSales;
                Visible = true;
                RunObject = Page "My Teams List";
            }
            action("Payslip")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payslip';
                Image = Payables;
                RunObject = Page "Payslip Report Filter";
            }
            action("Employee Directory")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Company Directory';
                RunObject = Page "Employee Directory DME";
                ToolTip = 'View all employee basic contact details.';
            }
            action("MY Operations")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'My Operations';
                Image = TeamSales;
                Visible = true;
                RunObject = codeunit "Rc Open";
            }
        }
    }
}