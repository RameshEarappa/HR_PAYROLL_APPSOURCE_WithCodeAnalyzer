page 70007 "Parameter List"
{
    PageType = List;
    SourceTable = "ParamList Data Table";
    UsageCategory = Lists;
    ApplicationArea = All;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(ParamList__KeyId; Rec.ParamList__KeyId)
                {
                    ApplicationArea = All;
                }
                field(ParamList__KeyValueTxt; ParamList__KeyValueTxt)
                {
                    ApplicationArea = All;
                }
                field(ParamList__DataType; Rec.ParamList__DataType)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        ParamList__KeyValueTxt: Text;

    trigger OnAfterGetRecord()
    begin
        ParamList__KeyValueTxt := Rec.GET_ParamList__KeyValueP();
    end;
}

