page 70185 "HR Announcements Card"
{
    Caption = 'HR Announcements Card';
    PageType = Card;
    SourceTable = "HR Announcements";
    DataCaptionFields = "Annountment Header";
    layout
    {
        area(Content)
        {
            group("General")
            {
                ShowCaption = false;
                grid(ColGrid)
                {
                    GridLayout = Columns;
                    ShowCaption = false;
                    group(p4)
                    {
                        ShowCaption = false;
                        field("Effective Date"; Rec."Effective Date")
                        {
                            ApplicationArea = All;
                            Editable = EditBoolG;
                        }
                    }
                    group(p2)
                    {
                        ShowCaption = false;
                        field("Expiry Date"; Rec."Expiry Date")
                        {
                            ApplicationArea = All;
                            Editable = EditBoolG;
                        }
                    }
                }
            }
            group(P5)
            {
                ShowCaption = false;
                group(p1)
                {
                    Caption = 'Annountment Header';
                    field("Annountment Header"; Rec."Annountment Header")
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = EditBoolG;
                    }
                }
            }
            group(p3)
            {
                ShowCaption = false;
                group(ContentsArea)
                {
                    Caption = 'Announcements Content';
                    field("Announcements Content"; AnnouncementsContentTxtG)
                    {
                        ApplicationArea = All;
                        Editable = EditBoolG;
                        ShowCaption = false;
                        MultiLine = true;
                        ColumnSpan = 95;
                        RowSpan = 210;
                        Width = 210;

                        trigger OnValidate()
                        begin
                            Rec.SetAnnouncementsContent(Rec, AnnouncementsContentTxtG);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Publish to ESS")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Are You sure to Publish in ESS') then begin
                        Rec."Publish to ESS" := true;
                        rec.Modify();
                    end;
                end;
            }
            action("Unpublish to ESS")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Are You sure to Publish in ESS') then begin
                        Rec."Publish to ESS" := false;
                        rec.Modify();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AnnouncementsContentTxtG := Rec.GetAnnouncementsContent(Rec);
        BoolCondition();
    end;

    trigger OnOpenPage()
    begin
        AnnouncementsContentTxtG := Rec.GetAnnouncementsContent(Rec);
        BoolCondition();
    end;

    var
        AnnouncementsContentTxtG: Text;
        EditBoolG: Boolean;

    procedure BoolCondition()
    begin
        Clear(EditBoolG);
        if Rec."Publish to ESS" then
            EditBoolG := false
        else
            EditBoolG := true;
    end;
}