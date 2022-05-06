page 60240 "Email Notification Entries"
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Email Notification Entries";

    layout
    {
        area(Content)
        {
            group(General)
            {
                repeater(All)
                {
                    field("Entry No"; Rec."Entry No")
                    {
                        ApplicationArea = All;
                    }
                    field("Table No"; Rec."Table No")
                    {
                        ApplicationArea = All;
                    }
                    field("Document No"; Rec."Document No")
                    {
                        ApplicationArea = All;
                    }
                    field(SenderUserID; Rec.SenderUserID)
                    {
                        ApplicationArea = All;
                    }
                    field(ReceiverUserID; Rec.ReceiverUserID)
                    {
                        ApplicationArea = All;
                    }
                    field(RecordIDs; Records)
                    {
                        ApplicationArea = All;
                    }
                    field("Sent status"; Rec."Sent status")
                    {
                        ApplicationArea = All;
                    }
                    field("Email Sent"; Rec."Email Sent")
                    {
                        ApplicationArea = All;
                    }
                    field(status; Rec.status)
                    {
                        ApplicationArea = All;
                    }
                    field(HeaderTxt; Rec.HeaderTxt)
                    {
                        ApplicationArea = All;
                    }
                    field(Error; Rec.Error)
                    {
                        ApplicationArea = All;
                    }
                    field(BodyTxt; Rec.BodyTxt)
                    {
                        ApplicationArea = All;
                    }
                    field(FooterTxt; Rec.FooterTxt)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Records := Format(Rec.RecordIDs, 0, 1);
    end;

    var
        Records: Text;
}