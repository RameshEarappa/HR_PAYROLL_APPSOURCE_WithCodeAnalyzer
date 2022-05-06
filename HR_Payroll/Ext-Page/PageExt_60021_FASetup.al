pageextension 60021 Ext_Fa_Setup extends "Fixed Asset Setup"
{
    layout
    {
        addafter("Insurance Nos.")
        {
            field("Issue Document No."; Rec."Issue Document No.")
            {
                ApplicationArea = all;
            }
            field("Return Document No."; Rec."Return Document No.")
            {
                ApplicationArea = all;
            }
            field("Posted Issue Document No"; Rec."Posted Issue Document No")
            {
                ApplicationArea = all;
            }
            field("Posted Return Document No"; Rec."Posted Return Document No")
            {
                ApplicationArea = all;
            }
        }
    }
}