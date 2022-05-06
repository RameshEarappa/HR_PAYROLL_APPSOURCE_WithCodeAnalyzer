page 60039 "HCM Leave Types Wrkrs List"
{
    CardPageID = "HCM Leave Types Wrkr";
    Editable = false;
    PageType = List;
    SourceTable = "HCM Leave Types Wrkr";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Short Name"; Rec."Short Name")
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
                field("Min Days Avail"; Rec."Min Days Avail")
                {
                    ApplicationArea = all;
                }
                field("Max Days Avail"; Rec."Max Days Avail")
                {
                    ApplicationArea = all;
                }
                field("Carry Over Days"; Rec."Carry Over Days")
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
                field("Allow Half Day"; Rec."Allow Half Day")
                {
                    ApplicationArea = all;
                }
                field("Allow Excess Days"; Rec."Allow Excess Days")
                {
                    ApplicationArea = all;
                }
                field("Excess Days Action"; Rec."Excess Days Action")
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
                field("Religion ID"; Rec."Religion ID")
                {
                    ApplicationArea = all;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = all;
                }
                field("Balance RoundOff Type"; Rec."Balance RoundOff Type")
                {
                    ApplicationArea = all;
                }
                field("Leave Avail Basis"; Rec."Leave Avail Basis")
                {
                    ApplicationArea = all;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = all;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ApplicationArea = all;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = all;
                }
                field(Accrued; Rec.Accrued)
                {
                    ApplicationArea = all;
                }
                field("Max Days Accrual"; Rec."Max Days Accrual")
                {
                    ApplicationArea = all;
                }
                field("Leave Accrual"; Rec."Leave Accrual")
                {
                    ApplicationArea = all;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = all;
                }
                field("IsSystem Defined"; Rec."IsSystem Defined")
                {
                    ApplicationArea = all;
                }
                field("WorkFlow Required"; Rec."WorkFlow Required")
                {
                    ApplicationArea = all;
                }
                field("Attachment Mandate"; Rec."Attachment Mandate")
                {
                    ApplicationArea = all;
                }
                field("Benefit Id"; Rec."Benefit Id")
                {
                    ApplicationArea = all;
                }
                field("LTA Claim"; Rec."LTA Claim")
                {
                    ApplicationArea = all;
                }
                field("Leave Classification"; Rec."Leave Classification")
                {
                    ApplicationArea = all;
                }
                field("Allow Negative"; Rec."Allow Negative")
                {
                    ApplicationArea = ALL;

                }
                field("Benefit LTA"; Rec."Benefit LTA")
                {
                    ApplicationArea = ALL;
                }
                field("HCM Leave Id GCC"; Rec."HCM Leave Id GCC")
                {
                    ApplicationArea = ALL;
                }
                field("Allow Early Late Resumption"; Rec."Allow Early Late Resumption")
                {
                    ApplicationArea = ALL;
                }
                field("Roll Over Years"; Rec."Roll Over Years")
                {
                    ApplicationArea = ALL;
                }
                field("Benefit Id Leave Carry Over"; Rec."Benefit Id Leave Carry Over")
                {
                    ApplicationArea = ALL;
                }
                field("Probation Entitlement Days"; Rec."Probation Entitlement Days")
                {
                    ApplicationArea = ALL;
                }
                field("Attachment Mandatory Days"; Rec."Attachment Mandatory Days")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}