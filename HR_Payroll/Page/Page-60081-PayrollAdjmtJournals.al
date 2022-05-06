page 60081 "Payroll Adjmt. Journals"
{
    PageType = Worksheet;
    UsageCategory = Documents;
    ApplicationArea = All;
    SourceTable = "Payroll Adjmt. Journal header";

    layout
    {
        area(content)
        {
            field("Show Records"; ShowRecords)
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if ShowRecords = ShowRecords::Confirmed then
                        Rec.SETRANGE(Posted, true)
                    else
                        if ShowRecords = ShowRecords::"Not Confirmed" then
                            Rec.SETRANGE(Posted, false)
                        else
                            Rec.SETRANGE(Posted);

                    CurrPage.UPDATE;
                end;
            }
            repeater(Group)
            {
                field("Journal No."; Rec."Journal No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = NotPostedBoolG;
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    Editable = NotPostedBoolG;
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Pay Period Start"; Rec."Pay Period Start")
                {
                    Editable = NotPostedBoolG;
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Pay Period End"; Rec."Pay Period End")
                {
                    Editable = NotPostedBoolG;
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Create By"; Rec."Create By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Confirmed; Rec.Posted)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Card)
            {
                Caption = 'Card';
                Image = JobJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                RunObject = Page "Payroll Adjmt. Journal Card";
                RunPageLink = "Journal No." = FIELD("Journal No.");
                RunPageOnRec = true;
                Visible = false;
            }
            action(Lines)
            {
                Caption = 'Lines';
                Image = ItemVariant;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                applicationArea = All;
                RunObject = Page "Payroll Adjmt. Journal Lines";
                RunPageLink = "Journal No." = FIELD("Journal No.");
            }
            action(Confirm)
            {
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PayrollAdjHeader);
                    if PayrollAdjHeader.FINDFIRST then begin
                        if not PayrollAdjHeader.Posted then begin
                            if not CONFIRM('Do you want to Confirm the Journals') then
                                exit;

                            PayrollStatement.RESET;
                            PayrollStatement.SETRANGE("Pay Cycle", PayrollAdjHeader."Pay Cycle");
                            PayrollStatement.SETRANGE("Pay Period Start Date", PayrollAdjHeader."Pay Period Start");
                            PayrollStatement.SETRANGE("Workflow Status", PayrollStatement."Workflow Status"::Approved);
                            if PayrollStatement.FINDFIRST then begin
                                PayrollAdjmtJournalLines.RESET;
                                PayrollAdjmtJournalLines.SETRANGE("Journal No.", PayrollAdjHeader."Journal No.");
                                if PayrollAdjmtJournalLines.FINDFIRST then
                                    repeat
                                        PayrollStatementEmployee.RESET;
                                        PayrollStatementEmployee.SETRANGE("Payroll Statement ID", PayrollStatement."Payroll Statement ID");
                                        PayrollStatementEmployee.SETRANGE(Worker, PayrollAdjmtJournalLines."Employee Code");
                                        if PayrollStatementEmployee.FINDFIRST then
                                            ERROR('Payroll Statement already approved for the selected period for the employee %1', PayrollAdjmtJournalLines."Employee Code");
                                    until PayrollAdjmtJournalLines.NEXT = 0;
                                PayrollAdjHeader.Posted := true;
                                PayrollAdjHeader."Posted By" := USERID;
                                PayrollAdjHeader."Posted DateTime" := CURRENTDATETIME;
                                PayrollAdjHeader.MODIFY;
                            end else begin
                                PayrollAdjHeader.Posted := true;
                                PayrollAdjHeader."Posted By" := USERID;
                                PayrollAdjHeader."Posted DateTime" := CURRENTDATETIME;
                                PayrollAdjHeader.MODIFY;
                            end;

                        end
                        else begin
                            ERROR('Payroll Adjustment Journal already confirmed');
                        end;
                    end;
                    CurrPage.UPDATE;
                end;
            }
            action(UnConfirm)
            {
                Image = UnApply;
                Promoted = true;

                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PayrollAdjHeader);
                    if PayrollAdjHeader.FINDFIRST then begin
                        PayrollAdjHeader.TESTFIELD(Posted, true);
                        if not CONFIRM('Do you want to Unconfirm?') then
                            exit;
                        if PayrollAdjHeader.Posted then begin
                            PayrollStatement.RESET;
                            PayrollStatement.SETRANGE("Pay Cycle", PayrollAdjHeader."Pay Cycle");
                            PayrollStatement.SETRANGE("Pay Period Start Date", PayrollAdjHeader."Pay Period Start");
                            PayrollStatement.SETRANGE("Workflow Status", PayrollStatement."Workflow Status"::Approved);
                            if PayrollStatement.FINDFIRST then begin
                                ERROR('Payroll Statement already approved for the selected period.');
                            end else begin
                                PayrollAdjHeader.Posted := false;
                                PayrollAdjHeader."Posted By" := '';
                                PayrollAdjHeader."Posted DateTime" := 0DT;
                                PayrollAdjHeader.MODIFY;
                            end;
                        end;
                    end;
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    var
        ShowRecords: Option All,"Not Confirmed",Confirmed;
        ShowUserCreatedRecordsOnly: Boolean;
        PayrollAdjHeader: Record "Payroll Adjmt. Journal header";
        PayrollStatement: Record "Payroll Statement";
        PayrollAdjmtJournalLines: Record "Payroll Adjmt. Journal Lines";
        PayrollStatementEmployee: Record "Payroll Statement Employee";
        NotPostedBoolG: Boolean;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TESTFIELD(Posted, false);
    end;

    trigger OnAfterGetRecord()
    begin
        NotOprn();
    end;

    TRIGGER OnNewRecord(BelowxRec: Boolean)
    BEGIN
        NotOprn();
    END;

    trigger OnOpenPage()
    begin
        NotOprn();
    end;

    procedure NotOprn()
    begin
        Clear(NotPostedBoolG);
        IF NOT Rec.Posted THEN
            NotPostedBoolG := TRUE
        ELSE
            NotPostedBoolG := FALSE;
    end;
}