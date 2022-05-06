report 60015 "Update Increment Amount"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPostDataItem();
            begin
                Window.CLOSE;
                MESSAGE('Increment Amount Updated');
            end;
        }
    }

    requestpage
    {
        trigger OnQueryClosePage(CloseAction: Action): Boolean;
        begin
            if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
                if IncrementSteps = '' then
                    ERROR('Increment Step should not be blank');
                if gEmployeeEarningCodeGroup = '' then
                    ERROR('Earning Code Group Cannot be blank');
                if GradeCategory = '' then
                    ERROR('Grade Category should not be blank');
            end;
        end;
    }
    var
        EmployeeEarningCodeGroup: Record "Employee Earning Code Groups";
        Window: Dialog;
        gEmployeeEarningCodeGroup: Code[20];
        IncrementSteps: Code[20];
        GradeCategory: Code[50];
        Employee: Record Employee;
}