page 60034 "HCM Leave Types ErnGrp"
{
    PageType = Card;
    SourceTable = "HCM Leave Types ErnGrp";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Leave Types")
            {
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Leave Type Id"; Rec."Leave Type Id")
                {
                    ApplicationArea = all;
                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
            group(General)
            {
                field("Short Name"; Rec."Short Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = all;
                }
                field("Max Times"; Rec."Max Times")
                {
                    ApplicationArea = all;
                }
                field("Min Service Days"; Rec."Min Service Days")
                {
                    ApplicationArea = all;
                }
                field("Min Days Before Req"; Rec."Min Days Before Req")
                {
                    ApplicationArea = all;
                }
                field("Max Occurance"; Rec."Max Occurance")
                {
                    ApplicationArea = all;
                }
                field("Min Days per Leave Request"; Rec."Min Days Avail")
                {
                    ApplicationArea = all;
                }
                field("Max Days per Leave Request"; Rec."Max Days Avail")
                {
                    ApplicationArea = all;
                }
                field("Allow Encashment"; Rec."Allow Encashment")
                {
                    ApplicationArea = all;
                }
                field("Allow Negative"; Rec."Allow Negative")
                {
                    ApplicationArea = all;
                }
                field("Exc Public Holidays"; Rec."Exc Public Holidays")
                {
                    ApplicationArea = all;
                }
                field("Exc Week Offs"; Rec."Exc Week Offs")
                {
                    ApplicationArea = all;
                }
                field("Probation Entitlement Days"; Rec."Probation Entitlement Days")
                {
                    ApplicationArea = all;
                }
                field("Allow Half Day"; Rec."Allow Half Day")
                {
                    ApplicationArea = all;
                }
                field("Entitlement Days"; Rec."Entitlement Days")
                {
                    ApplicationArea = all;
                }
                field("Request Advance"; Rec."Request Advance")
                {
                    ApplicationArea = all;
                }
                field("Allow Early Late Resumption"; Rec."Allow Early Late Resumption")
                {
                    ApplicationArea = all;
                }
            }
            group(Setup)
            {
                field("Religion ID"; Rec."Religion ID")
                {
                    ApplicationArea = all;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = all;
                }
                field("Roll Over Years"; Rec."Roll Over Years")
                {
                    ApplicationArea = all;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ApplicationArea = all;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = all;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = all;
                }
                field("Leave Avail Basis"; Rec."Leave Avail Basis")
                {
                    ApplicationArea = all;
                }
            }
            group("Leave Accrual")
            {
                field("Accrual ID"; Rec."Accrual ID")
                {
                    ApplicationArea = all;
                }
                field("Months Ahead Calculate"; Rec."Months Ahead Calculate")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Consumption Split by Month"; Rec."Consumption Split by Month")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Accrual Interval Basis Date"; Rec."Accrual Interval Basis Date")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Interval Month Start"; Rec."Interval Month Start")
                {
                    ApplicationArea = all;
                }
                field("Accrual Units Per Month"; Rec."Accrual Units Per Month")
                {
                    ApplicationArea = all;
                }
                field("Opening Additional Accural"; Rec."Opening Additional Accural")
                {
                    ApplicationArea = all;
                }
                field("Roll Over Period Monthly"; Rec."Roll Over Period")
                {
                    ApplicationArea = all;
                }
                field("Max Carry Forward"; Rec."Max Carry Forward")
                {
                    ApplicationArea = all;
                }
                field("CarryForward Lapse After Month"; Rec."CarryForward Lapse After Month")
                {
                    ApplicationArea = all;
                }
                field("Repeat After Months"; Rec."Repeat After Months")
                {
                    ApplicationArea = all;
                }
                field("Avail Allow Till"; Rec."Avail Allow Till")
                {
                    ApplicationArea = all;
                }
            }
            group("Leave Benefit Setup")
            {
                field("Benefit Id"; Rec."Benefit Id")
                {
                    ApplicationArea = all;
                }
                field("Leave Carry Over Benefit"; Rec."Leave Carry Over Benefit")
                {
                    ApplicationArea = all;
                }
                field("Leave Classification"; Rec."Leave Classification")
                {
                    ApplicationArea = all;
                }
            }
            group("Other Setup")
            {
                field("Is System Defined"; Rec."Is System Defined")
                {
                    ApplicationArea = all;
                }
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
                field("WorkFlow Required"; Rec."WorkFlow Required")
                {
                    ApplicationArea = all;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = all;
                }
                field(Accrued; Rec.Accrued)
                {
                    ApplicationArea = all;
                }

                field("Is Paternity Leave"; Rec."Is Paternity Leave")
                {
                    ApplicationArea = All;
                    Caption = 'Is paternity/Adoption Leave';

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
            }
        }
    }
    var
        ChnageBool: Boolean;
        ChildAgeLimitinMonthsBool: Boolean;
        ChildAgeLimitinAdoptionBool: Boolean;
}