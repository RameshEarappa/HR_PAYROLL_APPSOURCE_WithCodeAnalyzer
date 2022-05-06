table 60005 "HCM Leave Types"
{
    Caption = 'HCM Leave Types';
    DrillDownPageID = "Leave Types";
    LookupPageID = "Leave Types";
    DataClassification = CustomerContent;
    fields
    {
        field(10; "Leave Type Id"; Code[20])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
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
            trigger OnValidate()
            begin
                if (xRec."Short Name" <> '') and (xRec."Short Name" <> "Short Name") then begin
                    DeleteLeaveTypeFormulas(xRec."Short Name", 3);
                end;
                if "Short Name" <> '' then
                    InsertLeaveTypeFormulas("Short Name");
            end;
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
        field(125; "Balance Round Off Type"; Code[20])
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
            trigger OnValidate()
            begin
                if "Is System Defined" then begin
                    "Max Days" := 0;
                    "Min Days Avail" := 0;
                    "Max Carry Forward" := 0;
                    "Max Days Accrual" := 0;
                    "Max Days Avail" := 0;
                    "Max Occurance" := 0;
                    "Max Times" := 0;
                    "Min Days Before Req" := 0;
                    "Min Days Between 2 leave Req." := 0;
                    "Min Service Days" := 0;
                    "Exc Public Holidays" := false;
                    "Exc Week Offs" := false;
                    "Allow Early Late Resumption" := false;
                    "Allow Encashment" := false;
                    "Allow Half Day" := false;
                    "Allow Negative" := false;
                    "Request Advance" := false;
                end;
            end;
        }
        field(175; "WorkFlow Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(180; "Attachment Mandate"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(190; RefTableId; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(195; "Benefit Id"; Code[20])
        {
            TableRelation = "HCM Benefit";
            DataClassification = CustomerContent;
        }
        field(205; "Leave Classification"; Option)
        {
            OptionCaption = 'Other,Annual Leave,Sick Leave';
            OptionMembers = Other,"Annual Leave","Sick Leave";
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
            MinValue = 1;
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
                    "Roll Over Period" := AccrualComponent."Roll Over Period";
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
                    "Roll Over Period" := 0;
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

        field(500; "Termination Leave"; Boolean)
        {
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
        key(Key1; "Leave Type Id")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        RecLeaveTypeErnGrp: Record "HCM Leave Types ErnGrp";
    begin
        Clear(RecLeaveTypeErnGrp);
        RecLeaveTypeErnGrp.SetRange("Leave Type Id", Rec."Leave Type Id");
        if RecLeaveTypeErnGrp.FindFirst() then
            Error('You cannot delete this Leave Type as it is assigned to Earning Group Code %1', RecLeaveTypeErnGrp."Earning Code Group");
    end;

    var
        PayrollFormula: Record "Payroll Formula";
        AccrualComponent: Record "Accrual Components";
        AccrualComponentLines: Record "Accrual Component Lines";

    procedure InsertLeaveTypeFormulas(ShortName: Code[20])
    begin
        FixedFormula('AC_' + ShortName, 'Total number of days in a specific period.', 3, ShortName);
        FixedFormula('AC_' + ShortName + '_ESD', 'Entitlement service days for the period.', 3, ShortName);
        FixedFormula('AC_' + ShortName + '_TD', 'Total number of days between employee joining date and payroll period end date.', 3, ShortName);
        FixedFormula('AC_' + ShortName + '_TDFY', 'Total number of days between financial year start date and payroll period end date.', 3, ShortName);
        FixedFormula('AC_' + ShortName + '_TDY', 'Total number of  days between calendar year end date and payroll period end date.', 3, ShortName);
        FixedFormula('AC_' + ShortName + '_EJYC', 'Employee from last joining month anniversary to current pay period end date', 3, ShortName);
    end;

    procedure FixedFormula(FormulaKey: Code[100]; FormulaDescription: Text[250]; FormulaKeyType: Option Parameter,"Pay Component",Benefit,"Leave Type",Custom; ShortName: Code[20])
    begin
        if FormulaKey <> '' then begin
            if not PayrollFormula.GET(FormulaKey) then begin
                PayrollFormula.INIT;
                PayrollFormula."Formula Key" := FormulaKey;
                PayrollFormula."Formula description" := FormulaDescription;
                PayrollFormula."Formula Key Type" := FormulaKeyType;
                PayrollFormula."Short Name" := ShortName;
                PayrollFormula.INSERT;
            end;
        end;
    end;

    procedure DeleteLeaveTypeFormulas(ShortName: Code[20]; FormulaKeyType: Option Parameter,"Pay Component",Benefit,"Leave Type",Custom)
    begin
        PayrollFormula.RESET;
        PayrollFormula.SETCURRENTKEY("Short Name");
        PayrollFormula.SETRANGE("Short Name", ShortName);
        PayrollFormula.SETRANGE("Formula Key Type", FormulaKeyType);
        PayrollFormula.DELETEALL;
    end;
}