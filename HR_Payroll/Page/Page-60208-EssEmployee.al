// page 60208 Ess_Employee
// {
//     Caption = 'Employee';
//     PageType = RoleCenter;
//     UsageCategory = Administration;
//     ApplicationArea = All;

//     layout
//     {
//         area(rolecenter)
//         {
//             group(Control1900724808)
//             {
//             }
//             part("User Details"; UserPictureDetails)
//             {
//             }
//             group(Control3)
//             {
//                 group(Control7)
//                 {
//                 }
//                 part(Control1; RequeststoApprove_cue)
//                 {
//                 }
//                 part("Employee Request"; "Employee Request_Cue")
//                 {
//                     Caption = 'Employee Request';
//                 }
//                 part(Overtime; OverTime_cue)
//                 {
//                     Caption = 'Overtime';
//                 }
//                 part("Education Allowance"; Education_cue)
//                 {
//                     Caption = 'Education Allowance';
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(creation)
//         {
//             action("My Personal Info")
//             {
//                 Image = Employee;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 RunObject = Page "Edit User Details";
//                 RunPageOnRec = true;
//             }
//             action("My Teams ")
//             {
//                 Caption = 'My Team';
//                 Image = PersonInCharge;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 RunObject = Page "Reporting Employee";
//                 Visible = false;
//             }
//             action(PaySlip)
//             {
//                 Image = PaymentHistory;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 //commented By Avinash   RunObject = Report Payslip;
//             }
//         }
//     }

//     var
//         useridG: Code[20];
//         //commented By Avinash   SummaryPayrollCue: Record Table51005;
//         UserSetup: Record "User Setup";
//         EmpRec: Record Employee;
//     //commented By Avinash  PayslipRep: Report Payslip;
// }

