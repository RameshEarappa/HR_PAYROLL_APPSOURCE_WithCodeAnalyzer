codeunit 60009 "Update Employee Earning Code"
{
    trigger OnRun();
    begin
        Employee.RESET;
        if Employee.FINDFIRST then begin
            repeat
                EmplErngCodegrp.RESET;
                EmplErngCodegrp.SETCURRENTKEY("Employee Code", "Valid From", "Valid To");
                EmplErngCodegrp.SETRANGE("Employee Code", Employee."No.");
                EmplErngCodegrp.SETFILTER("Valid From", '<=%1', WORKDATE);
                EmplErngCodegrp.SETFILTER("Valid To", '>=%1|%2', WORKDATE, 0D);
                if EmplErngCodegrp.FINDFIRST then begin
                    Employee."Earning Code Group" := EmplErngCodegrp."Earning Code Group";
                    Employee.MODIFY;
                end;
            until Employee.NEXT = 0;
        end;
    end;

    var
        EmplErngCodegrp: Record "Employee Earning Code Groups";
        Employee: Record Employee;
}