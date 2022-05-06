page 60063 "Leave Extension Lines"
{
    Caption = 'Leave Extension Lines';
    AutoSplitKey = true;
    DeleteAllowed = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Leave Extension";
    SourceTableView = SORTING("Leave Request ID", "Line No")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = ControlEditable;
                field("Leave Request ID"; Rec."Leave Request ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Personnel Number"; Rec."Personnel Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Workflow Status"; Rec."Workflow Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = All;
                    Editable = ControlEditable;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Alternative Start Date"; Rec."Alternative Start Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Leave Start Day Type"; Rec."Leave Start Day Type")
                {
                    ApplicationArea = All;
                    Editable = ControlEditable;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = ControlEditable;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Start Date");
                        if xRec."End Date" <> 0D then begin
                            if Rec."End Date" = xRec."End Date" then
                                ERROR('Invalid date');
                        end;

                        if DutyResume.GET(Rec."Leave Request ID") then begin
                            if Rec."End Date" <> 0D then begin
                                if (Rec."End Date" >= DutyResume."Resumption Date") then
                                    ERROR('End date %1 can not be greater than or equal to Resumption date %2', Rec."End Date", DutyResume."Resumption Date");
                            end;
                        end;
                    end;
                }
                field("Alternative End Date"; Rec."Alternative End Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Leave End Day Type"; Rec."Leave End Day Type")
                {
                    ApplicationArea = All;
                    Editable = ControlEditable;
                }
                field("Leave Days"; Rec."Leave Days")
                {
                    ApplicationArea = All;
                    Editable = ControlEditable;
                }
                field("Leave Remarks"; Rec."Leave Remarks")
                {
                    ApplicationArea = All;
                    Editable = ControlEditable;
                }
                field("Cover Resource"; Rec."Cover Resource")
                {
                    ApplicationArea = All;
                    Editable = ControlEditable;
                }
                field("Submission Date"; Rec."Submission Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Leave Cancelled"; Rec."Leave Cancelled")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Leave Planner ID"; Rec."Leave Planner ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Resumption Type"; Rec."Resumption Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Resumption Date"; Rec."Resumption Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Net Leave Days"; Rec."Net Leave Days")
                {
                    ApplicationArea = All;
                    Editable = ControlEditable;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ControlVisiblie;
    end;

    trigger OnAfterGetRecord()
    begin
        ControlVisiblie;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if DutyResume.GET(Rec."Leave Request ID") then;

        if xRec."Personnel Number" <> '' then
            Rec.VALIDATE("Personnel Number", xRec."Personnel Number");

        if (xRec."Start Date" <> 0D) or (xRec."End Date" <> 0D) then begin
            if xRec."End Date" + 1 < DutyResume."Resumption Date" then
                Rec.VALIDATE("Start Date", xRec."End Date" + 1);
        end;
    end;

    trigger OnOpenPage()
    begin
        ControlVisiblie;
    end;

    var
        DutyResume: Record "Duty Resumption";
        ControlEditable: Boolean;

    local procedure ControlVisiblie()
    begin
        if DutyResume.GET(Rec."Leave Request ID") then begin
            if DutyResume."Workflow Status" <> DutyResume."Workflow Status"::Open then
                ControlEditable := false
            else
                ControlEditable := true;
        end;
    end;
}