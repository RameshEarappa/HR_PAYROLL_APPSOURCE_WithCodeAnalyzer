report 60009 "Copy Earning Code Group"
{
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(content)
            {
                field("Copy To Grade Category"; GradeCategory)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Copy To Earning Code Group"; EarningCodeGroup)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Copy From Grade Category"; ToGradeCategory)
                {
                    ApplicationArea = all;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RecGradeCategory.RESET;
                        if PAGE.RUNMODAL(0, RecGradeCategory) = ACTION::LookupOK then begin
                            ToGradeCategory := RecGradeCategory."Grade Category ID";
                        end;
                    end;
                }
                field("Copy From Earning Code Group"; ToEarningCodeGroup)
                {
                    ApplicationArea = all;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if ToGradeCategory = '' then
                            ERROR('Select To Grade Category');
                        RecEarningCodeGroup.RESET;
                        RecEarningCodeGroup.SETRANGE("Grade Category", ToGradeCategory);
                        RecEarningCodeGroup.SETFILTER("Earning Code Group", '<>%1', EarningCodeGroup);
                        if PAGE.RUNMODAL(0, RecEarningCodeGroup) = ACTION::LookupOK then begin
                            ToEarningCodeGroup := RecEarningCodeGroup."Earning Code Group";
                        end;
                    end;
                }
            }
        }
    }

    trigger OnPostReport();
    begin
        MESSAGE('Earning Code Group Copied Successfully');
    end;

    var
        GradeCategory: Code[50];
        EarningCodeGroup: Code[20];
        RecEarningCodeGroup: Record "Earning Code Groups";
        ToGradeCategory: Code[50];
        ToEarningCodeGroup: Code[20];
        RecGradeCategory: Record "Payroll Grade Category";

    procedure SetValues(l_EarningCodeGroup: Code[20]; l_GradeCategory: Code[50]);
    begin
        EarningCodeGroup := l_EarningCodeGroup;
        GradeCategory := l_GradeCategory;
    end;
}

