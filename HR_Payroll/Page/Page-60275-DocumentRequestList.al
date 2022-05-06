page 60275 "Document Request List"
{
    Caption = 'Document Request List';
    Editable = false;
    PageType = List;
    SourceTable = "Document Request";
    CardPageId = "Document request Card";
    ApplicationArea = all;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Request ID"; Rec."Document Request ID")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Addressee; Rec.Addressee)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Document format ID"; Rec."Document format ID")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Document Title"; Rec."Document Title")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Request Date"; Rec."Request Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("WorkFlow Status"; Rec."WorkFlow Status")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}