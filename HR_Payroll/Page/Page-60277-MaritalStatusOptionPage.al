page 60277 "Marital Status Option Page"
{
    Caption = 'Marital Status';
    PageType = List;
    SourceTable = "Marital Sstatus Option";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}