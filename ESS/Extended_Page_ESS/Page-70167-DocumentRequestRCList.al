page 70167 "Document Request RC List"
{
    Caption = 'Document Request List ESS';
    Editable = false;
    PageType = List;
    SourceTable = "Document Request";
    CardPageId = "Document request Card ESS";
    InsertAllowed = false;
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
    actions
    {
        area(Processing)
        {
            action(New)
            {
                Caption = 'New';
                Image = New;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    EssCUL: Codeunit "ESS RC Page";
                    Rec2: Record "Document Request";
                BEGIN
                    Rec2.Reset();
                    Rec2.Init();
                    if Rec2."Document Request ID" = '' then begin
                        Rec2.Validate("Employee Id", EssCUL.GetEmployeeID(Database.UserId));
                        Rec2.Validate(User_ID_Rec, Database.UserId);
                        Rec2.Insert(true);
                        Page.Run(page::"Document request Card ESS", Rec2);
                    end;
                END;
            }
        }
    }

    trigger OnInit()
    begin
        PageUserFilter();
    end;

    procedure PageUserFilter()
    var
        Rcodeunit: Codeunit "ESS RC Page";
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Employee ID", Rcodeunit.GetEmployeeID(UserId));
        Rec.FilterGroup(0);
    end;
}