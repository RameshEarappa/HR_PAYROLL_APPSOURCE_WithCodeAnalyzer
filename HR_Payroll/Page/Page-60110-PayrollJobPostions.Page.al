page 60110 "Payroll Job Postions"
{
    Caption = 'All Positions';
    CardPageID = "Payroll Job Position Card";
    PageType = List;
    SourceTable = "Payroll Position";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Position ID"; Rec."Position ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Assigned Employee"; AssignedEmployee)
                {
                    ApplicationArea = All;
                }
                field("Assigned Employee Name"; AssignedEmployeeName)
                {
                    ApplicationArea = All;
                }
                field(Job; Rec.Job)
                {
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Reports to Position"; Rec."Reports to Position")
                {
                    ApplicationArea = All;
                }
                field("Earning Code Group"; Rec."Earning Code Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Worker; Rec.Worker)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Attachment")
            {
                ApplicationArea = All;
                Image = Attachments;
                Promoted = true;
                Caption = 'Attachment';
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                trigger
                OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GETTABLE(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RUNMODAL;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.UpdateOpenPositions;
        Rec.CheckPositionActive;
        GetAssignedEmployee;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        PayrollJobPosWorkerAssign.RESET;
        PayrollJobPosWorkerAssign.SETRANGE("Position ID", Rec."Position ID");
        if PayrollJobPosWorkerAssign.FINDFIRST then
            ERROR('Worker Already assign , you cannot delete this document.');
    end;

    trigger OnOpenPage()
    begin
        GetAssignedEmployee
    end;

    var
        PayrollPosDuration: Record "Payroll Position Duration";
        PayrollJobPosWorkerAssign: Record "Payroll Job Pos. Worker Assign";
        AssignedEmployee: Code[20];
        AssignedEmployeeName: Text;

    local procedure GetAssignedEmployee()
    var
        PayrollPosRec: Record "Payroll Job Pos. Worker Assign";
        Employee: Record Employee;
    begin
        CLEAR(AssignedEmployee);
        CLEAR(AssignedEmployeeName);
        PayrollPosRec.RESET;
        PayrollPosRec.SETRANGE("Position ID", Rec."Position ID");
        if PayrollPosRec.FINDFIRST then begin
            if Employee.GET(PayrollPosRec.Worker) then begin
                AssignedEmployee := Employee."No.";
                AssignedEmployeeName := Employee.FullName;
            end;
        end;
    end;
}