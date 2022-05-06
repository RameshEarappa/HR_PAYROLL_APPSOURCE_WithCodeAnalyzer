pageextension 60020 Ext_Fixed_Asset extends "Fixed Asset Card"
{
    layout
    {
        addafter(Maintenance)
        {
            group("Asset_Custody")
            {
                Caption = 'Asset Custody';

                field("Asset Custody"; Rec."Asset Custody")
                {
                    ApplicationArea = all;
                }
                field("Issued to Employee"; Rec."Issued to Employee")
                {
                    ApplicationArea = all;
                }
                field("Issued to Department"; Rec."Issued to Department")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}