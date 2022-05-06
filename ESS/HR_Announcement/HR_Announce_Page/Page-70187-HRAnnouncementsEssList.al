page 70187 "HR Announcements ESS List"
{
    Caption = 'HR Announcements';
    PageType = ListPart;
    SourceTable = "HR Announcements";
    CardPageId = "HR Announcements View";
    Editable = false;
    DataCaptionFields = "Annountment Header";
    MultipleNewLines = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Annountments"; Rec."Annountment Header")
                {
                    Caption = 'Announcements';
                    ApplicationArea = All;
                    Width = 100;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        PageFilter();
    end;

    procedure PageFilter()
    var
        CurrRecL: Record "HR Announcements";
    begin
        CurrRecL.Reset();
        CurrRecL.SetRange("Publish to ESS", true);
        if CurrRecL.FindFirst() then
            repeat
                if (WorkDate() >= CurrRecL."Effective Date") AND (WorkDate() <= CurrRecL."Expiry Date") then begin
                    CurrRecL.Mark(true);
                end;
            until CurrRecL.Next() = 0;
        CurrRecL.SetRange("Publish to ESS");
        CurrRecL.MarkedOnly(true);
        Rec.Copy(CurrRecL);
        CurrRecL.ClearMarks();
    end;
}