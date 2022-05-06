table 60021 "HCM Leave Types Wrkr"
{
    DrillDownPageID = "HCM Leave Types Wrkrs List";
    LookupPageID = "HCM Leave Types Wrkrs List";
    DataClassification = CustomerContent;
    fields
    {
        field(5; Worker; Code[20])
        {
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(6; RefRecId; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(10; "Leave Type Id"; Code[20])
        {
            TableRelation = "HCM Leave Types";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TESTFIELD(Worker);
            end;
        }
        field(12; "Earning Code Group"; Code[20])
        {
            TableRelation = "Earning Code Groups"."Earning Code Group";
            DataClassification = CustomerContent;
        }
        field(15; "Earning Code"; Code[20])
        {
            TableRelation = "Payroll Earning Code Wrkr"."Earning Code" WHERE(Worker = FIELD(Worker));
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
            Description = 'Max Number of Leave Days at a time';
            DataClassification = CustomerContent;
        }
        field(30; "Max Times"; Integer)
        {
            Description = 'Max Number of times in a lifetime';
            DataClassification = CustomerContent;
        }
        field(40; "Min Service Days"; Integer)
        {
            Description = 'Min Days from Joining Date';
            DataClassification = CustomerContent;
        }
        field(50; "Min Days Before Req"; Integer)
        {
            Description = 'Min Days before Leave starts';
            DataClassification = CustomerContent;
        }
        field(60; "Max Occurance"; Integer)
        {
            Description = 'Max times in a Year';
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
        field(75; "Carry Over Days"; Integer)
        {
            Description = 'Max Carry Forward to Next Year(Calculation at the time of Benefit)';
            DataClassification = CustomerContent;
        }
        field(80; "Exc Public Holidays"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not "Exc Public Holidays" then
                    "Exc Week Offs" := false;
            end;
        }
        field(85; "Exc Week Offs"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Exc Week Offs" then
                    "Exc Public Holidays" := true;
            end;
        }
        field(90; "Allow Half Day"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(95; "Allow Excess Days"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(100; "Excess Days Action"; Code[20])
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
        field(120; Nationality; Code[20])
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
        field(135; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';
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
        field(160; "Leave Accrual"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(165; Active; Boolean)
        {
            Description = 'First Validation';
            DataClassification = CustomerContent;
        }
        field(170; "IsSystem Defined"; Boolean)
        {
            DataClassification = CustomerContent;
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
            TableRelation = "HCM Benefit Wrkr";
            DataClassification = CustomerContent;
        }
        field(200; "LTA Claim"; Boolean)
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
        field(215; "Benefit LTA"; Code[20])
        {
            TableRelation = "HCM Benefit Wrkr";
            DataClassification = CustomerContent;
        }
        field(220; "HCM Leave Id GCC"; Integer)
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
        field(235; "Benefit Id Leave Carry Over"; Code[20])
        {
            TableRelation = "HCM Benefit Wrkr";
            DataClassification = CustomerContent;
        }
        field(240; "Probation Entitlement Days"; Integer)
        {
            Description = 'Max Days Leave in Probation Period';
            DataClassification = CustomerContent;
        }
        field(245; "Attachment Mandatory Days"; Integer)
        {
            Description = 'Min Days required to Attach the documents';
            DataClassification = CustomerContent;
        }
        field(248; "Accrual ID"; Code[20])
        {
            TableRelation = "Accrual Components";
            DataClassification = CustomerContent;
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
        key(Key1; Worker, "Leave Type Id", RefRecId)
        {
            Clustered = true;
        }
        key(Key2; "Leave Type Id")
        {
        }
        key(Key3; "Earning Code Group", Worker)
        {
        }
    }

    trigger OnDelete()
    var
        RecLeaveRequest: Record "Leave Request Header";
    begin
        Clear(RecLeaveRequest);
        RecLeaveRequest.SetRange("Leave Type", Rec."Leave Type Id");
        if RecLeaveRequest.FindFirst() then
            Error('You cannot delete this Leave Type as it is assigned to Leave Request Id %1', RecLeaveRequest."Leave Request ID");
    end;
}