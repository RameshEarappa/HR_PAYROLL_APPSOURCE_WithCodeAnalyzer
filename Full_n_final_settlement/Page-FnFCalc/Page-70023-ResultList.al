page 70023 "Emp. Result Table FnFCalc"
{
    PageType = List;
    SourceTable = "Emp. Result Table FnFCalc";
    UsageCategory = Lists;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Caption = 'FnF Calc Emp. Result Table';

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
                field(FormulaType; Rec.FormulaType)
                {
                    ApplicationArea = All;
                }
                field(BaseCode; Rec.BaseCode)
                {
                    ApplicationArea = All;
                }
                field(FormulaID1; Rec.FormulaID1)
                {
                    ApplicationArea = All;
                }
                field(Result1; Rec.Result1)
                {
                    ApplicationArea = All;
                }
                field(FormulaID2; Rec.FormulaID2)
                {
                    ApplicationArea = All;
                }
                field(Result2; Rec.Result2)
                {
                    ApplicationArea = All;
                }
                field(FormulaID3; Rec.FormulaID3)
                {

                    ApplicationArea = All;
                }
                field(Result3; Rec.Result3)
                {
                    ApplicationArea = All;
                }
                field(ErrorLogTxt; ErrorLogTxt)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        ErrorLogTxt: text;

    trigger OnAfterGetRecord()
    begin
        ErrorLogTxt := Rec.GET_ErrorLogP();
    end;
}