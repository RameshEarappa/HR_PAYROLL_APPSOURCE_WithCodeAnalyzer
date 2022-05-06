query 60000 "Payroll Statement Trans."
{
    elements
    {
        dataitem(Payroll_Statement_Emp_Trans; "Payroll Statement Emp Trans.")
        {
            column(Payroll_Statement_ID; "Payroll Statement ID")
            {
            }
            column(Payroll_Statment_Employee; "Payroll Statment Employee")
            {
            }
            column(Worker; Worker)
            {
            }
            column(Employee_Name; "Employee Name")
            {
            }
            column(Payroll_Earning_Code; "Payroll Earning Code")
            {
            }
            column(Payroll_Earning_Code_Desc; "Payroll Earning Code Desc")
            {
            }
            column(Earniing_Code_Short_Name; "Earniing Code Short Name")
            {
            }
            column(Earning_Code_Arabic_Name; "Earning Code Arabic Name")
            {
            }
            column(Earning_Code_Calc_Class; "Earning Code Calc Class")
            {
            }
            column(Earning_Code_Calc_Sub_Type; "Earning Code Calc Sub Type")
            {
            }
            column(Earning_Code_Type; "Earning Code Type")
            {
            }
            column(Benefit_Code; "Benefit Code")
            {
            }
            column(Benefit_Description; "Benefit Description")
            {
            }
            column(Benefit_Short_Name; "Benefit Short Name")
            {
            }
            column(Benenfit_Arabic_Name; "Benenfit Arabic Name")
            {
            }
            column(Fin_Accural_Required; "Fin Accural Required")
            {
            }
            column(Payroll_Transaction_Type; "Payroll Transaction Type")
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            column(Sum_Earning_Code_Amount; "Earning Code Amount")
            {
                Method = Sum;
            }
            column(Sum_Calculation_Units; "Calculation Units")
            {
                Method = Sum;
            }
            column(Sum_Benefit_Amount; "Benefit Amount")
            {
                Method = Sum;
            }
            column(Sum_Benefit_Encashment_Amount; "Benefit Encashment Amount")
            {
                Method = Sum;
            }
        }
    }
}