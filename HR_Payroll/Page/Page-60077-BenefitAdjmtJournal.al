page 60077 "Benefit Adjmt. Journal"
{
    PageType = Worksheet;
    SourceTable = "Benefit Adjmt. Journal header";
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Benefit Adjustment Journal';

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
            field("Show User Created Records Only"; ShowUserCreatedRecordsOnly)
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnValidate()
                begin
                    if ShowUserCreatedRecordsOnly then
                        Rec.SETRANGE("Posted By", USERID)
                    else
                        Rec.SETRANGE("Posted By");
                end;
            }
            repeater(Group)
            {
                field("Journal No."; Rec."Journal No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Pay Period Start"; Rec."Pay Period Start")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Pay Period End"; Rec."Pay Period End")
                {
                    Editable = false;
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
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Posted DateTime"; Rec."Posted DateTime")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Lines)
            {
                Caption = 'Lines';
                ApplicationArea = All;
                Image = Line;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Benefit Adjmt. Lines";
                RunPageLink = "Journal No." = FIELD("Journal No.");
            }
            action(Card)
            {
                Caption = 'Card';
                ApplicationArea = All;
                Image = JobJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Benefit Adjmt. Journal Card";
                RunPageLink = "Journal No." = FIELD("Journal No.");
                RunPageOnRec = true;
                Visible = false;
            }

            action(Confirm)
            {
                Caption = 'Confirm';
                ApplicationArea = All;
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(BenefitAdjHeader);
                    IF BenefitAdjHeader.FINDFIRST THEN BEGIN
                        IF NOT BenefitAdjHeader.Posted THEN BEGIN
                            IF NOT CONFIRM('Do you want to Confirm the Journals') THEN
                                EXIT;

                            PayrollStatement.RESET;
                            PayrollStatement.SETRANGE("Pay Period Start Date", BenefitAdjHeader."Pay Period Start");
                            PayrollStatement.SETRANGE("Workflow Status", PayrollStatement."Workflow Status"::Approved);
                            IF PayrollStatement.FINDFIRST THEN BEGIN
                                BenefitAdjJnlLine.RESET;
                                BenefitAdjJnlLine.SETRANGE("Journal No.", BenefitAdjHeader."Journal No.");
                                IF BenefitAdjJnlLine.FINDSET THEN BEGIN
                                    REPEAT
                                        PayrollStatementEmployee.RESET;
                                        PayrollStatementEmployee.SETRANGE("Payroll Statement ID", PayrollStatement."Payroll Statement ID");
                                        PayrollStatementEmployee.SETRANGE(Worker, BenefitAdjJnlLine."Employee Code");
                                        IF PayrollStatementEmployee.FINDFIRST THEN
                                            ERROR('Payroll Statement already approved for the selected period for the employee %1', BenefitAdjJnlLine."Employee Code")
                                        ELSE BEGIN
                                            BenefitAdjHeader.Posted := TRUE;
                                            BenefitAdjHeader."Posted By" := USERID;
                                            BenefitAdjHeader."Posted DateTime" := CURRENTDATETIME;
                                            BenefitAdjHeader."Posted Date" := TODAY;
                                            BenefitAdjHeader.MODIFY;
                                        END;
                                    UNTIL BenefitAdjJnlLine.NEXT = 0;
                                END
                            END
                            ELSE BEGIN
                                BenefitAdjHeader.Posted := TRUE;
                                BenefitAdjHeader."Posted By" := USERID;
                                BenefitAdjHeader."Posted DateTime" := CURRENTDATETIME;
                                BenefitAdjHeader."Posted Date" := TODAY;
                                BenefitAdjHeader.MODIFY;
                            END;
                        END
                        ELSE BEGIN
                            ERROR('Benefit Adjustment Journal already Posted');
                        END;
                    END;
                    CurrPage.UPDATE;
                end;
            }

            action(UnConfirm)
            {
                Caption = 'UnConfirm';
                ApplicationArea = All;
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger
                OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(BenefitAdjHeader);
                    IF BenefitAdjHeader.FINDFIRST THEN BEGIN
                        BenefitAdjHeader.TESTFIELD(Posted, TRUE);
                        IF NOT CONFIRM('Do you want to Unconfirm?') THEN
                            EXIT;
                        IF BenefitAdjHeader.Posted THEN BEGIN
                            PayrollStatement.RESET;
                            PayrollStatement.SETRANGE("Pay Cycle", BenefitAdjHeader."Pay Cycle");
                            PayrollStatement.SETRANGE("Pay Period Start Date", BenefitAdjHeader."Pay Period Start");
                            PayrollStatement.SETRANGE("Workflow Status", PayrollStatement."Workflow Status"::Approved);
                            IF PayrollStatement.FINDFIRST THEN BEGIN
                                ERROR('Payroll Statement already approved for the selected period.');
                            END ELSE BEGIN
                                BenefitAdjHeader.Posted := FALSE;
                                BenefitAdjHeader."Posted By" := '';
                                BenefitAdjHeader."Posted DateTime" := 0DT;
                                BenefitAdjHeader."Posted Date" := 0D;
                                BenefitAdjHeader.MODIFY;
                            END;
                        END;
                    END;
                    CurrPage.UPDATE;
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(BenefitAdjHeader);
                    if BenefitAdjHeader.FINDFIRST then begin
                        if not BenefitAdjHeader.Posted then begin
                            if not CONFIRM('Do you want to Confirm the Journals') then
                                exit;

                            PayrollStatement.RESET;
                            PayrollStatement.SETRANGE("Pay Period Start Date", BenefitAdjHeader."Pay Period Start");
                            PayrollStatement.SETRANGE("Workflow Status", PayrollStatement."Workflow Status"::Approved);
                            if PayrollStatement.FINDFIRST then begin
                                BenefitAdjJnlLine.RESET;
                                BenefitAdjJnlLine.SETRANGE("Journal No.", BenefitAdjHeader."Journal No.");
                                if BenefitAdjJnlLine.FINDFIRST then
                                    repeat
                                        PayrollStatementEmployee.RESET;
                                        PayrollStatementEmployee.SETRANGE("Payroll Statement ID", PayrollStatement."Payroll Statement ID");
                                        PayrollStatementEmployee.SETRANGE(Worker, BenefitAdjJnlLine."Employee Code");
                                        if PayrollStatementEmployee.FINDFIRST then
                                            ERROR('Payroll Statement already approved for the selected period for the employee %1', BenefitAdjJnlLine."Employee Code");
                                    until BenefitAdjJnlLine.NEXT = 0;
                            end
                            else begin
                                BenefitAdjHeader.Posted := true;
                                BenefitAdjHeader."Posted By" := USERID;
                                BenefitAdjHeader."Posted DateTime" := CURRENTDATETIME;
                                BenefitAdjHeader.MODIFY;
                            end;
                        end
                        else begin
                            ERROR('Benefit Adjustment Journal already Posted');
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
        BenefitAdjHeader: Record "Benefit Adjmt. Journal header";
        PayrollStatement: Record "Payroll Statement";
        BenefitAdjJnlLine: Record "Benefit Adjmt. Journal Lines";
        PayrollStatementEmployee: Record "Payroll Statement Employee";
}