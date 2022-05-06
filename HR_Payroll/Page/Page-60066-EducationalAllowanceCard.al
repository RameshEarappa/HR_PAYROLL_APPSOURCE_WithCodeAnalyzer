page 60066 "Educational Allowance Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Educational Allowance LT";
    SourceTableView = SORTING("Grade Category", "Earnings Code Group")
                      ORDER(Ascending);
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Grade Category"; Rec."Grade Category")
                {
                    Caption = 'Grade Category';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Earnings Code Group"; Rec."Earnings Code Group")
                {
                    Caption = 'Earnings Code Group';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group("Education Allowance")
            {
                field("Eligible Amount"; Rec."Edu. Allow. Eligible Amount")
                {
                    Caption = 'Eligible Amount';
                    ApplicationArea = All;
                }
                field("Min Age"; Rec."Edu. Allow. Min Age")
                {
                    Caption = 'Min Age';
                    ApplicationArea = All;
                }
                field("Max Age"; Rec."Edu. Allow. Max Age")
                {
                    Caption = 'Max Age';
                    ApplicationArea = All;
                }
                field("Count of children eligible"; Rec."Count of children eligible")
                {
                    Caption = 'Count of children eligible';
                    ApplicationArea = All;
                }
                field("Education Type - Full time"; Rec."Education Type - Full time")
                {
                    Caption = 'Education Type - Full time';
                    ApplicationArea = All;
                }
            }
            group("Level of Education- Book Allow")
            {
                field("Elemantary School"; Rec."Book Allow. Elemantary School")
                {
                    Caption = 'Elementary School';
                    ApplicationArea = All;
                }
                field("Secondary Level"; Rec."Book Allow. Secondary Level")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Level';
                }
                field("University Level"; Rec."Book Allow. University Level")
                {
                    Caption = 'University Level';
                    ApplicationArea = All;
                }
            }
            group("Special Need Allowance")
            {
                field(" Applicable"; Rec."Special Applicable")
                {
                    Caption = 'Special Allowance Applicable';
                    ApplicationArea = All;
                }
                field(" Eligible Amount"; Rec."Special Eligible Amount")
                {
                    Caption = 'Eligible Amount';
                    ApplicationArea = All;
                }
            }
        }
    }


}

