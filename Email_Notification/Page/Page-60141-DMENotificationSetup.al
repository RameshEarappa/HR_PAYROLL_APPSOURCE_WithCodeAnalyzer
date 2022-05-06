page 60241 "DME Notification Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "DME Notification Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                repeater(GP)
                {
                    field("Process ID"; Rec."Process ID")
                    {
                        ApplicationArea = All;
                    }
                    field("Process Name"; Rec."Process Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Process Caption"; Rec."Process Caption")
                    {
                        ApplicationArea = All;
                    }
                    field("HR Manager"; Rec."HR Manager")
                    {
                        ApplicationArea = All;
                    }
                    field(Finances; Rec.Finances)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
}