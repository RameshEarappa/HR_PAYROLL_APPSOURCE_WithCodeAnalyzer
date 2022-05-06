page 70186 "HR Announcements View"
{
    Caption = 'HR Announcements view';
    PageType = Card;
    SourceTable = "HR Announcements";
    Editable = false;
    DataCaptionFields = "Annountment Header";
    MultipleNewLines = false;

    layout
    {
        area(Content)
        {
            group(p3)
            {
                ShowCaption = false;
                group(ContentsArea)
                {
                    Caption = 'Announcements Content';
                    field("Announcements Content"; AnnouncementsContentTxtG)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        MultiLine = true;
                        ColumnSpan = 95;
                        RowSpan = 210;
                        Width = 210;
                        Editable = false;

                        trigger OnValidate()
                        begin
                            Rec.SetAnnouncementsContent(Rec, AnnouncementsContentTxtG);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AnnouncementsContentTxtG := Rec.GetAnnouncementsContent(Rec);
    end;

    trigger OnOpenPage()
    begin
        AnnouncementsContentTxtG := Rec.GetAnnouncementsContent(Rec);
    end;

    var
        AnnouncementsContentTxtG: Text;
}