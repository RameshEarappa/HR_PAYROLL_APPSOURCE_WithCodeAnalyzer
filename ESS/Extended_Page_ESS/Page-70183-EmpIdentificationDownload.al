page 70183 "Empl. Identification download"
{
    Caption = 'My Documents';
    PageType = ListPart;
    SourceTable = "Identification Master";
    SourceTableView = SORTING("Employee No.") ORDER(Ascending) WHERE("Document Type" = CONST(Employee), "Active Document" = filter(true));
    UsageCategory = Administration;
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    DelayedInsert = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                ShowCaption = false;
                field(Description; Rec.Description)
                {
                    Caption = 'Document Description';
                    ApplicationArea = All;
                    Editable = false;
                    Width = 150;
                    trigger OnDrillDown()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        FileName: Text;
                        DocumentAttachmentRecL: Record "Document Attachment";
                    begin
                        DocumentAttachmentRecL.Reset();
                        DocumentAttachmentRecL.SetRange("Table ID", Database::"Identification Master");
                        DocumentAttachmentRecL.SetRange("No.", Rec."No.");
                        if DocumentAttachmentRecL.FindFirst() then
                            Export(true, DocumentAttachmentRecL);
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        EmployeeFilter();
    end;

    trigger OnAfterGetRecord()
    begin
        EmployeeFilter();
    end;

    var
        UserSetupRecG: Record "User Setup";

    procedure EmployeeFilter()
    begin
        UserSetupRecG.Reset();
        UserSetupRecG.SetRange("User ID", Database.UserId);
        if UserSetupRecG.FindFirst() then begin
            UserSetupRecG.TestField("Employee Id");
            Rec.FilterGroup(2);
            Rec.SetRange("Employee No.", UserSetupRecG."Employee Id");
            Rec.SetRange("Active Document", true);
            Rec.SetRange("Document Type", rec."Document Type"::Employee);
            Rec.FilterGroup(0);
        end;
    end;

    procedure Export(ShowFileDialog: Boolean; DocumentAttachmentRecP: Record "Document Attachment"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        DocumentStream: OutStream;
        FullFileName: Text;
    begin
        if DocumentAttachmentRecP.ID = 0 then
            exit;
        if not DocumentAttachmentRecP."Document Reference ID".HasValue then
            exit;
        FullFileName := DocumentAttachmentRecP."File Name" + '.' + DocumentAttachmentRecP."File Extension";
        TempBlob.CreateOutStream(DocumentStream);
        DocumentAttachmentRecP."Document Reference ID".ExportStream(DocumentStream);
        exit(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;
}