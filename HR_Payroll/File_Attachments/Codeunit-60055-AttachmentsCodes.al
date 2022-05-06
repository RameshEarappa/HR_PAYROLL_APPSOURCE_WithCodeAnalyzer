codeunit 60055 "File Attachments Codes"
{
    [EventSubscriber(ObjectType::Table, 1173, 'OnBeforeInsertAttachment', '', true, true)]
    procedure OnBeforeInsertAttachment_LT(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        LeaveRequestHeaderRecL: Record "Leave Request Header";
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
        DocumentAttachmentRecL: Record "Document Attachment";
    begin
        case RecRef.Number of
            DATABASE::"Leave Request Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);

                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Leave Request Header");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Loan Request":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);

                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Loan Request");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Identification Master":
                begin
                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Identification Master");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::Employee:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::Employee);
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Employee Insurance":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Employee Insurance");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Payroll Job Education Line":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Payroll Job Education Line");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Payroll Job Certificate Line":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Payroll Job Certificate Line");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Payroll Job Skill Line":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Payroll Job Skill Line");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Employee Bank Account":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Employee Bank Account");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Full and Final Calculation":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Full and Final Calculation");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Employee Dependents Master":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Employee Dependents Master");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Employee Prof. Exp.":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Employee Prof. Exp.");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Payroll Jobs":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Payroll Jobs");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
            DATABASE::"Payroll Position":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachmentRecL.Reset();
                    DocumentAttachmentRecL.SetRange("No.", RecNo);
                    DocumentAttachmentRecL.SetRange("Table ID", Database::"Payroll Position");
                    if LeaveRequestHeaderRecL.FindLast() then
                        LineNo += DocumentAttachmentRecL."Line No." + 1000
                    else
                        LineNo := 1000;
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, 1173, 'OnAfterOpenForRecRef', '', true, true)]
    procedure OnAfterOpenForRecRef_LT(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Leave Request Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Leave Request Header");
                end;
            DATABASE::"Loan Request":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Loan Request");
                end;
            DATABASE::"Identification Master":
                begin
                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Identification Master");
                end;
            DATABASE::Employee:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::Employee);
                end;
            DATABASE::"Employee Insurance":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Employee Insurance");
                end;
            DATABASE::"Payroll Job Education Line":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Payroll Job Education Line");
                end;
            DATABASE::"Payroll Job Certificate Line":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Payroll Job Certificate Line");
                end;
            DATABASE::"Payroll Job Skill Line":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Payroll Job Skill Line");
                end;
            DATABASE::"Employee Bank Account":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Employee Bank Account");
                end;
            DATABASE::"Full and Final Calculation":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Full and Final Calculation");
                end;
            DATABASE::"Employee Dependents Master":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Employee Dependents Master");
                end;
            DATABASE::"Employee Prof. Exp.":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Employee Prof. Exp.");
                end;
            DATABASE::"Payroll Jobs":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Payroll Jobs");
                end;
            DATABASE::"Payroll Position":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Table ID", Database::"Payroll Position");
                end;
        end;
    end;
}