table 60010 "HCM Leave Types ErnGrp"
{
    Caption = 'HCM Leave Types';
    DrillDownPageID = "HCM Leave Types ErnGrps";
    LookupPageID = "HCM Leave Types ErnGrps";
    DataClassification = CustomerContent;

    fields
    {
        field(5; "Earning Code Group"; Code[20])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(10; "Leave Type Id"; Code[20])
        {
            TableRelation = "HCM Leave Types";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                HCMLeaveTypes: Record "HCM Leave Types";
            begin
                if "Leave Type Id" = '' then
                    exit;
                TESTFIELD("Earning Code Group");

                HCMLeaveTypes.GET("Leave Type Id");
                Rec.TRANSFERFIELDS(HCMLeaveTypes);
            end;
        }
        field(15; "Earning Code"; Code[20])
        {
            TableRelation = "Payroll Earning Code" WHERE(Active = CONST(true));
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Short Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(25; "Max Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Max Times"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Min Service Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Min Days Before Req"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Max Occurance"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(65; "Min Days Avail"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(70; "Max Days Avail"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(80; "Exc Public Holidays"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(85; "Exc Week Offs"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(90; "Allow Half Day"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(95; "Allow Excess Days"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(105; "Entitlement Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(110; "Request Advance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(115; "Religion ID"; Code[20])
        {
            TableRelation = "Payroll Religion";
            DataClassification = CustomerContent;
        }
        field(120; Nationality; Text[50])
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                CountryRegion: Record "Country/Region";
            begin
                CountryRegion.RESET;
                if PAGE.RUNMODAL(0, CountryRegion) = ACTION::LookupOK then begin
                    Nationality := CountryRegion.Name;
                end;
            end;
        }
        field(125; "Balance RoundOff Type"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(130; "Leave Avail Basis"; Option)
        {
            OptionCaption = 'None,Joining Date,Probation End Date,Confirmation Date';
            OptionMembers = "None","Joining Date","Probation End Date","Confirmation Date";
            DataClassification = CustomerContent;
        }
        field(135; Gender; Option)
        {
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
            DataClassification = CustomerContent;
        }
        field(140; "Pay Type"; Option)
        {
            OptionCaption = 'None,Paid,UnPaid';
            OptionMembers = "None",Paid,UnPaid;
            DataClassification = CustomerContent;
        }
        field(145; "Leave Type"; Option)
        {
            OptionCaption = 'None,Days,Hours';
            OptionMembers = "None",Days,Hours;
            DataClassification = CustomerContent;
        }
        field(150; Accrued; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(155; "Max Days Accrual"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(165; Active; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(170; "Is System Defined"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(175; "WorkFlow Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(180; "Attachment Mandate"; Boolean)
        {
            Caption = 'Is Attachment Mandatory';
            DataClassification = CustomerContent;
        }
        field(190; RefTableId; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(195; "Benefit Id"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(205; "Leave Classification"; Option)
        {
            OptionCaption = 'Other,AnnualLeave,SickLeave';
            OptionMembers = Other,AnnualLeave,SickLeave;
            DataClassification = CustomerContent;
        }
        field(210; "Allow Negative"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(225; "Allow Early Late Resumption"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(230; "Roll Over Years"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(240; "Probation Entitlement Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(245; "Attachment Mandatory Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(246; "Leave Carry Over Benefit"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(247; "Allow Encashment"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(248; "Accrual ID"; Code[20])
        {
            TableRelation = "Accrual Components";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IntervalMonthStart: Integer;
                IntervalMonthEnd: Integer;
                i: Integer;
            begin

                IF AccrualComponent.GET("Accrual ID") THEN BEGIN
                    "Accrual Description" := AccrualComponent.Description;
                    "Accrual Interval Basis Date" := AccrualComponent."Accrual Interval Basis Date";
                    "Months Ahead Calculate" := AccrualComponent."Months Ahead Calculate";
                    "Consumption Split by Month" := AccrualComponent."Consumption Split by Month";
                    "Accrual Basis Date" := AccrualComponent."Accrual Basis Date";
                    "Interval Month Start" := AccrualComponent."Interval Month Start";
                    "Accrual Units Per Month" := AccrualComponent."Accrual Units Per Month";
                    "Opening Additional Accural" := AccrualComponent."Opening Additional Accural";
                    "Max Carry Forward" := AccrualComponent."Max Carry Forward";
                    "CarryForward Lapse After Month" := AccrualComponent."CarryForward Lapse After Month";
                    "Repeat After Months" := AccrualComponent."Repeat After Months";
                    "Avail Allow Till" := AccrualComponent."Avail Allow Till";
                END
                ELSE BEGIN
                    "Accrual Description" := '';
                    "Accrual Interval Basis Date" := 0D;
                    "Months Ahead Calculate" := 0;
                    "Consumption Split by Month" := FALSE;
                    "Accrual Basis Date" := 0D;
                    "Interval Month Start" := 0;
                    "Accrual Units Per Month" := 0;
                    "Opening Additional Accural" := 0;
                    "Max Carry Forward" := 0;
                    "CarryForward Lapse After Month" := 0;
                    "Repeat After Months" := 0;
                    "Avail Allow Till" := "Avail Allow Till"::"Accrual Till Date";
                END;
            end;
        }
        field(249; "Accrual Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(250; "Accrual Interval Basis"; Option)
        {
            OptionCaption = ' ,Fixed,Employee Joining Date,Probation End/Confirm,Original Hire Date,Define Per Employee';
            OptionMembers = " ","Fixed","Employee Joining Date","Probation End/Confirm","Original Hire Date","Define Per Employee";
            DataClassification = CustomerContent;
        }
        field(251; "Accrual Frequency"; Option)
        {
            OptionCaption = ' ,Daily,Weekly,Monthly,Annually';
            OptionMembers = " ",Daily,Weekly,Monthly,Annually;
            DataClassification = CustomerContent;
        }
        field(252; "Accrual Policy Enrollment"; Option)
        {
            OptionCaption = ' ,Prorated,Full Accural,No Accural';
            OptionMembers = " ",Prorated,"Full Accural","No Accural";
            DataClassification = CustomerContent;
        }
        field(253; "Accrual Award Date"; Option)
        {
            OptionCaption = ' ,Accural Period Start,Accural Period End';
            OptionMembers = " ","Accural Period Start","Accural Period End";
            DataClassification = CustomerContent;
        }
        field(254; "Months Ahead Calculate"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(255; "Consumption Split by Month"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(256; "Accrual Interval Basis Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(257; "Accrual Basis Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(258; "Min Days Between 2 leave Req."; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(300; "Interval Month Start"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(301; "Accrual Units Per Month"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(302; "Opening Additional Accural"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(304; "Max Carry Forward"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(305; "CarryForward Lapse After Month"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(306; "Repeat After Months"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(307; "Avail Allow Till"; Option)
        {
            OptionCaption = 'Accrual Till Date,End of Period';
            OptionMembers = "Accrual Till Date","End of Period";
            DataClassification = CustomerContent;
        }
        field(350; "Roll Over Period"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(351; "Cover Resource Mandatory"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(352; "Marital Status"; Text[30])
        {
            TableRelation = "Marital Status";
            DataClassification = CustomerContent;
        }
        field(501; "Attachments After Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(502; "Is Compensatory Leave"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(503; "Is Paternity Leave"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(504; "Child Age Limit in Months"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(505; "Adoption leave"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(506; "Adoption Child Age Months"; Integer)
        {
            Caption = 'Adoption Child Age Limit in Months';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Earning Code Group", "Leave Type Id")
        {
        }
        key(Key2; "Leave Type Id")
        {
            Clustered = true;
        }
    }

    var
        AccrualComponent: Record "Accrual Components";
        AccrualComponentLines: Record "Accrual Component Lines";
}