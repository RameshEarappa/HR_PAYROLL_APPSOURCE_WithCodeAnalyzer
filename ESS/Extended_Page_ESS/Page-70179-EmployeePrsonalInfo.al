page 70179 "Employee PErsonal Info. DME"
{
    Caption = 'My Personal Info.';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Employee;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            group("PP")
            {
                ShowCaption = false;
                part("USer Profile"; "DME Employee Picture 2")
                {
                    ApplicationArea = All;
                }
            }
            group("Employment")
            {
                field("Joining Date"; Rec."Joining Date")
                {
                    ApplicationArea = All;
                }
                field(ServericYearG; ServericYearG)
                {
                    Caption = 'Service Years';
                    ApplicationArea = All;
                    DecimalPlaces = 1;
                }
                field(ServicesInCurrPositionG; ServicesInCurrPositionG)
                {
                    Caption = 'Years In Current Position';
                    ApplicationArea = All;
                    DecimalPlaces = 1;
                }
            }
            group("Address")
            {
                part("Address Part "; "Employee Address ESS")
                {
                    Caption = 'Address';
                    ApplicationArea = All;
                    Editable = false;
                    SubPageLink = "Employee ID" = FIELD("No."), "Table Type Option" = FILTER("Employee Address Line");//, Primary = filter(true);
                }
            }
            group("Contact Details")
            {
                part(Contacts; "Employee Contacts ESS")
                {
                    Caption = 'Contacts';
                    ApplicationArea = All;
                    Editable = false;
                    SubPageLink = "Employee ID" = FIELD("No."), "Table Type Option" = FILTER("Employee Contacts Line");//, Primary = filter(true);
                }
            }
            group("Dependent Details")
            {
                part(PersonalContacts; "Employee Dependent List DME")
                {
                    Caption = 'Dependent Details';
                    ApplicationArea = All;
                    Editable = false;
                    SubPageLink = "Employee ID" = FIELD("No.");
                }
            }

            group("Identification Details")
            {
                part(IDentificationDetails; "Employee Identification ESS")
                {
                    Caption = 'Identification Details';
                    ApplicationArea = All;
                    Editable = false;
                    SubPageLink = "Employee No." = FIELD("No."), "Document Type" = filter(Employee), "Active Document" = filter(true);
                }
            }

            group("Bank Details")
            {
                part(BankDetails; "Employee Bank Account ESS")
                {
                    Caption = 'Bank Details';
                    ApplicationArea = All;
                    Editable = false;
                    SubPageLink = "Employee ID" = FIELD("No."), Primary = filter(true);
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        UserSetupRecG.Reset();
        if UserSetupRecG.Get(Database.UserId) then
            UserSetupRecG.TestField("Employee Id");
        Rec.FilterGroup(2);
        Rec.SetRange("No.", UserSetupRecG."Employee Id");
        Rec.FilterGroup(0);

    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Joining Date" <> 0D then
            ServericYearG := (Today - Rec."Joining Date") / 365;

        ServicesInCurrPositionG := GetEmployeeCrrPos();
    end;

    var
        UserSetupRecG: Record "User Setup";
        ServericYearG: Decimal;
        ServicesInCurrPositionG: Decimal;


    procedure GetEmployeeCrrPos(): Decimal
    var
        PayrollJobPosWrkAssgnRecG: Record "Payroll Job Pos. Worker Assign";
    begin
        PayrollJobPosWrkAssgnRecG.Reset();
        PayrollJobPosWrkAssgnRecG.SetRange(Worker, Rec."No.");
        PayrollJobPosWrkAssgnRecG.SetRange("Is Primary Position", true);
        if PayrollJobPosWrkAssgnRecG.FindFirst() then
            exit((Today - PayrollJobPosWrkAssgnRecG."Effective Start Date") / 365);
    end;
}