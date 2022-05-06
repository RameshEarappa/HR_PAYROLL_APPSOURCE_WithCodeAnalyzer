page 60033 "HCM Leave Types ErnGrps"
{
    CardPageID = "HCM Leave Types ErnGrp";
    Editable = false;
    PageType = List;
    SourceTable = "HCM Leave Types ErnGrp";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Earning Code Group"; Rec."Earning Code Group")
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
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = All;
                }
                field("Max Days"; Rec."Max Days")
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
                field("Min Days Avail"; Rec."Min Days Avail")
                {
                    ApplicationArea = All;
                }
                field("Max Days Avail"; Rec."Max Days Avail")
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
                field("Allow Half Day"; Rec."Allow Half Day")
                {
                    ApplicationArea = All;
                }
                field("Allow Excess Days"; Rec."Allow Excess Days")
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
                field("Religion ID"; Rec."Religion ID")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                }
                field("Balance RoundOff Type"; Rec."Balance RoundOff Type")
                {
                    ApplicationArea = All;
                }
                field("Leave Avail Basis"; Rec."Leave Avail Basis")
                {
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = All;
                }
                field(Accrued; Rec.Accrued)
                {
                    ApplicationArea = All;
                }
                field("Max Days Accrual"; Rec."Max Days Accrual")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("Is System Defined"; Rec."Is System Defined")
                {
                    ApplicationArea = All;
                }
                field("WorkFlow Required"; Rec."WorkFlow Required")
                {
                    ApplicationArea = All;
                }
                field("Benefit Id"; Rec."Benefit Id")
                {
                    ApplicationArea = All;
                }
                field("Leave Classification"; Rec."Leave Classification")
                {
                    ApplicationArea = All;
                }
                field("Allow Negative"; Rec."Allow Negative")
                {
                    ApplicationArea = All;
                }
                field("Allow Early Late Resumption"; Rec."Allow Early Late Resumption")
                {
                    ApplicationArea = All;
                }
                field("Roll Over Years"; Rec."Roll Over Years")
                {
                    ApplicationArea = All;
                }
                field("Probation Entitlement Days"; Rec."Probation Entitlement Days")
                {
                    ApplicationArea = All;
                }
                field("Attachment Mandatory Days"; Rec."Attachment Mandatory Days")
                {
                    ApplicationArea = All;
                }
                field("Attachment Mandate"; Rec."Attachment Mandate")
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
            }
        }
    }
    var
        ChnageBool: Boolean;
}