page 60155 "Leave Adjmt. Journal Header"
{
    Caption = 'Leave Adjmt. Journal';
    PageType = Worksheet;
    SourceTable = "Leave Adj Journal header";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            field("Show Records"; ShowRecords)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    if ShowRecords = ShowRecords::Posted then
                        Rec.SETRANGE(Posted, true)
                    else
                        if ShowRecords = ShowRecords::"Not Posted" then
                            Rec.SETRANGE(Posted, false)
                        else
                            Rec.SETRANGE(Posted);

                    CurrPage.UPDATE;
                end;
            }
            field("Show User Created Records Only"; ShowUserCreatedRecordsOnly)
            {
                ApplicationArea = All;
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
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = NotOpenBoolG;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    Editable = NotOpenBoolG;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Pay Period Start"; Rec."Pay Period Start")
                {
                    Editable = NotOpenBoolG;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Pay Period End"; Rec."Pay Period End")
                {
                    Editable = NotOpenBoolG;
                    ShowMandatory = true;
                    ApplicationArea = All;
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
                field("Is Opening"; Rec."Is Opening")
                {
                    Visible = false;
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
                Image = Line;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Leave Adjmt. Journal Lines";
                RunPageLink = "Journal No." = FIELD("Journal No.");
            }
            action(Card)
            {
                Caption = 'Card';
                Image = JobJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Leave Adjmt. Journal Card";
                RunPageLink = "Journal No." = FIELD("Journal No.");
                RunPageOnRec = true;
                Visible = false;
                ApplicationArea = All;
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    LeaveAdjJournal: Record "Leave Adj Journal header";
                    LeaveAdjJournalLines: Record "Leave Adj Journal Lines";
                begin
                    if Rec.Posted then
                        Error('Leave adjustment transaction has already posted.');

                    CurrPage.SETSELECTIONFILTER(LeaveAdjJournal);
                    if LeaveAdjJournal.FINDFIRST then begin
                        LeaveAdjJournalLines.RESET;
                        LeaveAdjJournalLines.SETRANGE("Journal No.", LeaveAdjJournal."Journal No.");
                        if LeaveAdjJournalLines.FINDFIRST then begin
                            repeat
                                if LeaveAdjJournal."Is Opening" then
                                    AccrualCompCalc.ValidateOpeningBalanceLeaves(LeaveAdjJournalLines."Employee Code", LeaveAdjJournalLines."Leave Type ID", NORMALDATE(LeaveAdjJournal."Pay Period Start"),
                                                                                 NORMALDATE(LeaveAdjJournal."Pay Period End"), LeaveAdjJournalLines."Earning Code Group",
                                                                                 LeaveAdjJournalLines."Accrual ID", LeaveAdjJournalLines."Calculation Units")
                                else
                                    AccrualCompCalc.ValidateAdjustmentLeaves(LeaveAdjJournalLines."Employee Code", LeaveAdjJournalLines."Leave Type ID", NORMALDATE(LeaveAdjJournal."Pay Period Start"),
                                                                                 NORMALDATE(LeaveAdjJournal."Pay Period End"), LeaveAdjJournalLines."Earning Code Group",
                                                                                 LeaveAdjJournalLines."Accrual ID", LeaveAdjJournalLines."Calculation Units");
                                AccrualCompCalc.OnAfterValidateAccrualLeaves(LeaveAdjJournalLines."Employee Code", NORMALDATE(LeaveAdjJournal."Pay Period Start"), LeaveAdjJournalLines."Leave Type ID", LeaveAdjJournalLines."Earning Code Group");
                            until LeaveAdjJournalLines.NEXT = 0;
                            LeaveAdjJournal.Posted := true;
                            LeaveAdjJournal."Posted By" := USERID;
                            LeaveAdjJournal."Posted Date" := WORKDATE;
                            LeaveAdjJournal."Posted DateTime" := CURRENTDATETIME;
                            LeaveAdjJournal.MODIFY;
                        end
                        else
                            ERROR('There is nothing to post');
                    end;
                    MESSAGE('Leave Adjusment is posted');
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        LeaveAdjJournalheader: Record "Leave Adj Journal header";
    begin
        LeaveAdjJournalheader.RESET;
        CurrPage.SETSELECTIONFILTER(LeaveAdjJournalheader);
        if LeaveAdjJournalheader.FINDFIRST then begin
            if LeaveAdjJournalheader."Journal No." <> '' then begin
                Rec.TESTFIELD(Description);
                Rec.TESTFIELD("Pay Cycle");
                Rec.TESTFIELD("Pay Period End");
                Rec.TESTFIELD("Pay Period Start");
            end;
        end;
    end;

    trigger OnOpenPage()
    begin
        NotOpen;
    end;

    trigger OnAfterGetRecord()
    begin
        NotOpen;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        NotOpen;
    end;

    var
        ShowRecords: Option All,"Not Posted",Posted;
        ShowUserCreatedRecordsOnly: Boolean;
        AccrualCompCalc: Codeunit "Accrual Component Calculate";
        NotOpenBoolG: Boolean;

    procedure NotOpen()
    begin
        Clear(NotOpenBoolG);
        if Rec.Posted then
            NotOpenBoolG := false
        else
            NotOpenBoolG := true
    end;
}