page 70202 "DME Activities Cue 2"
{

    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "DME Activities Cue";
    SourceTableView = SORTING("Primary Key") ORDER(Ascending);
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'My Pending Approvals';

    layout
    {
        area(content)
        {
            cuegroup("Xyz")
            {
                ShowCaption = false;
                field("Requests to Approve"; Rec."Requests to Approve")
                {
                    Caption = 'Pending Approvals';
                    ApplicationArea = All;
                    ShowCaption = false;
                    Visible = true;
                    ToolTip = 'Pending Approvals';
                    DrillDownPageId = "Requests to Approve";
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        Rcodeunit: Codeunit "ESS RC Page";
        ppg: Page "Accountant Role Center";
    begin
        Rec.Reset;
        if not Rec.Get(Database.UserId) then begin
            Rec.Init;
            Rec."Primary Key" := Database.UserId;
            Rec.User_ID_Srch := Database.UserId;
            Rec.Insert;
        end else begin
            Rec."Primary Key" := Database.UserId;
            Rec.User_ID_Srch := Database.UserId;
            Rec.Modify();
        end;
        Rec.Reset();
        Rec.FilterGroup(2);
        Rec.SetRange("Primary Key", Database.UserId);
        Rec.FilterGroup(0);
    end;
}