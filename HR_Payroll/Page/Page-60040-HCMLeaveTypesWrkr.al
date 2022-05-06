page 60040 "HCM Leave Types Wrkr"
{
    PageType = Card;
    SourceTable = "HCM Leave Types Wrkr";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Leave Types")
            {
                field(Worker; Rec.Worker)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Leave Type Id"; Rec."Leave Type Id")
                {
                    ApplicationArea = All;
                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                }
            }
            group(General)
            {
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = All;
                }
                field("Max Times"; Rec."Max Times")
                {
                    ApplicationArea = All;
                }
                field("Min Service Days"; Rec."Min Service Days")
                {
                    ApplicationArea = All;
                }
                field("Min Days Before Req"; Rec."Min Days Before Req")
                {
                    ApplicationArea = All;
                }
                field("Max Occurance"; Rec."Max Occurance")
                {
                    ApplicationArea = All;
                }
                field("Allow Negative"; Rec."Allow Negative")
                {
                    ApplicationArea = All;
                }
                field("Min Days per Leave Request"; Rec."Min Days Avail")
                {
                    ApplicationArea = All;
                }
                field("Max Days per Leave Request"; Rec."Max Days Avail")
                {
                    ApplicationArea = All;
                }
                field("Exc Public Holidays"; Rec."Exc Public Holidays")
                {
                    ApplicationArea = All;
                }
                field("Exc Week Offs"; Rec."Exc Week Offs")
                {
                    ApplicationArea = All;
                }
                field("Probation Entitlement Days"; Rec."Probation Entitlement Days")
                {
                    ApplicationArea = All;
                }
                field("Allow Half Day"; Rec."Allow Half Day")
                {
                    ApplicationArea = All;
                }
                field("Entitlement Days"; Rec."Entitlement Days")
                {
                    ApplicationArea = All;
                }
                field("Request Advance"; Rec."Request Advance")
                {
                    ApplicationArea = All;
                }
                field("Allow Early Late Resumption"; Rec."Allow Early Late Resumption")
                {
                    ApplicationArea = All;
                }
                field("IsSystem Defined"; Rec."IsSystem Defined")
                {
                    ApplicationArea = All;
                }
            }
            group(Setup)
            {
                field("Religion ID"; Rec."Religion ID")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field("Roll Over Years"; Rec."Roll Over Years")
                {
                    ApplicationArea = All;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = All;
                }
                field("Leave Avail Basis"; Rec."Leave Avail Basis")
                {
                    ApplicationArea = All;
                }
            }
            group("Leave Accrual")
            {
                field("Accrual ID"; Rec."Accrual ID")
                {
                    ApplicationArea = All;
                }
                field("Months Ahead Calculate"; Rec."Months Ahead Calculate")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Consumption Split by Month"; Rec."Consumption Split by Month")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Accrual Interval Basis Date"; Rec."Accrual Interval Basis Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Interval Month Start"; Rec."Interval Month Start")
                {
                    ApplicationArea = All;
                }
                field("Accrual Units Per Month"; Rec."Accrual Units Per Month")
                {
                    ApplicationArea = All;
                }
                field("Opening Additional Accural"; Rec."Opening Additional Accural")
                {
                    ApplicationArea = All;
                }
                field("Roll Over Period Monthly"; Rec."Roll Over Period")
                {
                    ApplicationArea = All;
                }
                field("Max Carry Forward"; Rec."Max Carry Forward")
                {
                    ApplicationArea = All;
                }
                field("CarryForward Lapse After Month"; Rec."CarryForward Lapse After Month")
                {
                    ApplicationArea = All;
                }
                field("Repeat After Months"; Rec."Repeat After Months")
                {
                    ApplicationArea = All;
                }
                field("Avail Allow Till"; Rec."Avail Allow Till")
                {
                    ApplicationArea = All;
                }
            }
            group("Leave Benefit Setup")
            {
                field("Benefit Id"; Rec."Benefit Id")
                {
                    ApplicationArea = All;
                }
                field("Leave Classification"; Rec."Leave Classification")
                {
                    ApplicationArea = All;
                }
            }
            group("Other Setup")
            {
                field("Is Attachment Mandatory"; Rec."Attachment Mandate")
                {
                    ApplicationArea = All;
                    trigger
                   OnValidate()
                    begin
                        if Rec."Attachment Mandate" then
                            ChnageBool := true
                        else
                            ChnageBool := false;
                    end;
                }
                field("Attachments After Days"; Rec."Attachments After Days")
                {
                    ApplicationArea = All;
                    Editable = ChnageBool;
                }
                field("Is Compensatory Leave"; Rec."Is Compensatory Leave")
                {
                    ApplicationArea = All;
                }
                field("Is Paternity Leave"; Rec."Is Paternity Leave")
                {
                    ApplicationArea = All;
                    trigger
                             OnValidate()
                    begin
                        if Rec."Is Paternity Leave" then
                            ChildAgeLimitinMonthsBool := true
                        else
                            ChildAgeLimitinMonthsBool := false;
                    end;
                }
                field("Child Age Limit in Months"; Rec."Child Age Limit in Months")
                {
                    ApplicationArea = All;
                    Editable = ChildAgeLimitinMonthsBool;
                }
                field("Adoption leave"; Rec."Adoption leave")
                {
                    ApplicationArea = All;
                    trigger
                            OnValidate()
                    begin
                        if Rec."Adoption leave" then
                            ChildAgeLimitinAdoptionBool := true
                        else
                            ChildAgeLimitinAdoptionBool := false;
                    end;
                }
                field("Adoption Child Age Months"; Rec."Adoption Child Age Months")
                {
                    ApplicationArea = All;
                    Editable = ChildAgeLimitinAdoptionBool;
                }
                field("WorkFlow Required"; Rec."WorkFlow Required")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field(Accrued; Rec.Accrued)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        ChnageBool: Boolean;
        ChildAgeLimitinMonthsBool: Boolean;
        ChildAgeLimitinAdoptionBool: Boolean;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Earning Code Group" := Rec."Earning Code Group";
    end;

    trigger OnOpenPage()
    begin
        if Rec."Is Paternity Leave" then
            ChildAgeLimitinMonthsBool := true
        else
            ChildAgeLimitinMonthsBool := false;

        if Rec."Adoption leave" then
            ChildAgeLimitinAdoptionBool := true
        else
            ChildAgeLimitinAdoptionBool := false;
    end;
}