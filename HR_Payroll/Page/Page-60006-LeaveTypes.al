page 60006 "Leave Types"
{
    CardPageID = "Leave Type Card";
    PageType = List;
    SourceTable = "HCM Leave Types";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Attachment Mandate"; Rec."Attachment Mandate")
                {
                    ApplicationArea = All;
                }
                field(RefTableId; Rec.RefTableId)
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
            }
        }
    }
}