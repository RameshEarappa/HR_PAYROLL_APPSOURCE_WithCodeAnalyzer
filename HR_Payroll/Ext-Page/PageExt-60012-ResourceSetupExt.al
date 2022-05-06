pageextension 60012 ResourceSetupExt extends "Resources Setup"
{
    layout
    {
        addlast(Content)
        {
            field("HR Email ID"; Rec."HR Email ID")
            {
                ApplicationArea = All;
            }
        }
    }
}
