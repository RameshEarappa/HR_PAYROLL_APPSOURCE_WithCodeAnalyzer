page 70029 "Approval Entrty Transcation"
{
    SourceTable = "Approval Entrty Transcation";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Trans ID"; Rec."Trans ID")
                {
                    ApplicationArea = All;
                }
                field("Advance Payrolll Type"; Rec."Advance Payrolll Type")
                {
                    ApplicationArea = All;
                }
                field("Employee ID - Sender"; Rec."Employee ID - Sender")
                {
                    ApplicationArea = All;
                }
                field("Reporting ID - Approver"; Rec."Reporting ID - Approver")
                {
                    ApplicationArea = All;
                }
                field("Delegate ID"; Rec."Delegate ID")
                {
                    ApplicationArea = All;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
                field(DocRedID; DocRedID)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger
    OnAfterGetRecord()
    begin
        DocRedID := Format(Rec."Document RecordsID", 0, 1);
    end;

    var
        DocRedID: Text;
}