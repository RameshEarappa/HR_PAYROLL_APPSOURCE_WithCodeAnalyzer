table 60123 "Loan Adjustment Lines"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Loan Request ID"; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; Loan; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Loan Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Employee ID"; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "Employee Name"; Text[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7; "Installament Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if ((Status = Status::Unrecovered) or (Status = Status::Adjusted)) then begin
                    if "New Line" = false then begin

                        if Rec."Principal Installment Amount" <> xRec."Principal Installment Amount" then
                            if CONFIRM(Text50001, true) then begin
                                Status := Status::Unrecovered;
                                MODIFY;
                            end
                            else
                                ERROR('Cannot Change the Amount');
                    end;
                end
                else
                    ERROR(Text5002);
            end;
        }
        field(8; "Principal Installment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if ((Status = Status::Unrecovered) or (Status = Status::Adjusted)) then begin
                    if "New Line" = false then begin

                        if Rec."Principal Installment Amount" <> xRec."Principal Installment Amount" then
                            if CONFIRM(Text50001, true) then begin
                                Status := Status::Unrecovered;
                                MODIFY;
                            end
                            else
                                ERROR('Cannot Change the Amount');
                    end;
                end
                else
                    ERROR(Text5002);
            end;
        }
        field(9; "Interest Installment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if ((Status = Status::Unrecovered) or (Status = Status::Adjusted)) then begin
                    if "New Line" = false then begin
                        if Rec."Interest Installment Amount" <> xRec."Interest Installment Amount" then
                            if CONFIRM(Text50001, true) then begin
                                Status := Status::Unrecovered;
                                MODIFY;
                            end
                            else
                                ERROR('Cannot Change the Amount');
                    end
                end
                else
                    ERROR(Text5002);
            end;
        }
        field(10; Currency; Code[50])
        {
            TableRelation = Currency.Code;
            DataClassification = CustomerContent;
        }
        field(11; Status; Option)
        {
            OptionCaption = ',Unrecovered,Recovered,Adjusted';
            OptionMembers = ,Unrecovered,Recovered,Adjusted;
            DataClassification = CustomerContent;
        }
        field(12; "New Line"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Loan Adjustment ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Installament Updated"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Loan Adjustment ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        if not "New Line" then
            ERROR('Lines Cannot be Deleted.');
    end;

    var
        Text50001: Label 'Do you want to change the Amount ?';
        Text5002: Label 'Cannot change the Amount since the status is either Recovered or Adjusted !';
}