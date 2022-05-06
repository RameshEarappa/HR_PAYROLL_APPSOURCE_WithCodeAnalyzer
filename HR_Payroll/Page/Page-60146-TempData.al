page 60146 "Temp Data"
{
    PageType = List;
    SourceTable = "Temp Datatable Data";
    ApplicationArea = All;
    UsageCategory = Lists;
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
                field("Parameter ID"; Rec."Parameter ID")
                {
                    ApplicationArea = All;
                }
                field("Parameter Value"; Rec."Parameter Value")
                {
                    ApplicationArea = All;
                }
                field("Parameter Datatype"; Rec."Parameter Datatype")
                {
                    ApplicationArea = All;
                }
                field("Benefit Code"; Rec."Benefit Code")
                {
                    ApplicationArea = All;
                }
                field("Unit Formula"; Rec."Unit Formula")
                {
                    ApplicationArea = All;
                }
                field("Value Formula"; Rec."Value Formula")
                {
                    ApplicationArea = All;
                }
                field("Encashment Formula"; Rec."Encashment Formula")
                {
                    ApplicationArea = All;
                }
                field("Paycomponent Code"; Rec."Paycomponent Code")
                {
                    ApplicationArea = All;
                }
                field("Formula For Attendance"; Rec."Formula For Attendance")
                {
                    ApplicationArea = All;
                }
                field("Formula for Days"; Rec."Formula for Days")
                {
                    ApplicationArea = All;
                }
                field("Paycomponent Type"; Rec."Paycomponent Type")
                {
                    ApplicationArea = All;
                }
                field("PayComp Unit Formula"; Rec."PayComp Unit Formula")
                {
                    ApplicationArea = All;
                }
                field("Result Formula Type"; Rec."Result Formula Type")
                {
                    ApplicationArea = All;
                }
                field("Result Base Code"; Rec."Result Base Code")
                {
                    ApplicationArea = All;
                }
                field("Result Fornula ID1"; Rec."Result Fornula ID1")
                {
                    ApplicationArea = All;
                }
                field(Result1; Rec.Result1)
                {
                    ApplicationArea = All;
                }
                field("Result Fornula ID2"; Rec."Result Fornula ID2")
                {
                    ApplicationArea = All;
                }
                field(Result2; Rec.Result2)
                {
                    ApplicationArea = All;
                }
                field("Result Fornula ID3"; Rec."Result Fornula ID3")
                {
                    ApplicationArea = All;
                }
                field(Result3; Rec.Result3)
                {
                    ApplicationArea = All;
                }
                field("Error Log"; WorkDescription)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        WorkDescription := Rec.GetFormulaForErrorLog;
    end;

    trigger OnOpenPage()
    begin
        WorkDescription := Rec.GetFormulaForErrorLog;
    end;

    var
        WorkDescription: Text;
}