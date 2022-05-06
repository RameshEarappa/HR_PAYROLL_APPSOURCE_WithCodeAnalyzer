report 60001 "Pay Period Process"
{
    ProcessingOnly = true;
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Pay Cycle Frequency"; PayCycleFrequency)
                    {
                        ApplicationArea = all;
                    }
                    field("No Of Periods"; NoOfPeriods)
                    {
                        ApplicationArea = all;
                    }
                    field("First Period Start Date"; FirstPeriodStartDate)
                    {
                        ShowMandatory = true;
                        ApplicationArea = all;
                    }
                }
            }
        }

        trigger OnClosePage();
        begin
            if NoOfPeriods = 0 then
                ERROR('No Of Periods Cannot be blank');
            if FirstPeriodStartDate = 0D then
                ERROR('First Period Start date Cannot be Blank');
        end;
    }

    trigger OnPreReport();
    begin
        PayPeriods.RESET;
        PayPeriods.SETRANGE("Pay Cycle", PayCycle);
        if PayPeriods.FINDFIRST then
            if not CONFIRM('Pay Periods already exist for this Pay Cycle. Do you want to delete and recreate ?') then
                exit;

        PayPeriods.RESET;
        PayPeriods.SETRANGE("Pay Cycle", PayCycle);
        PayPeriods.DELETEALL;

        CLEAR(ActualPeriodStartDate);
        CLEAR(ActualPeriodEndDate);

        case PayCycleFrequency of
            PayCycleFrequency::Daily:
                begin
                    ActualPeriodStartDate := CALCDATE('-CD', FirstPeriodStartDate);
                    ActualPeriodEndDate := CALCDATE('-CD-1D+' + FORMAT(NoOfPeriods) + 'D', FirstPeriodStartDate);
                end;
            PayCycleFrequency::Weekly:
                begin
                    ActualPeriodStartDate := CALCDATE('-CW', FirstPeriodStartDate);
                    ActualPeriodEndDate := CALCDATE('-CW-1D+' + FORMAT(NoOfPeriods) + 'W', FirstPeriodStartDate);
                    ;
                end;
            PayCycleFrequency::Monthly:
                begin
                    ActualPeriodStartDate := CALCDATE('-CM', FirstPeriodStartDate);
                    ActualPeriodEndDate := CALCDATE('-CM-1D+' + FORMAT(NoOfPeriods) + 'M', FirstPeriodStartDate);
                end;
            PayCycleFrequency::Quarterly:
                begin
                    ActualPeriodStartDate := CALCDATE('-CQ', FirstPeriodStartDate);
                    ActualPeriodEndDate := CALCDATE('-CQ-1D+' + FORMAT(NoOfPeriods) + 'Q', FirstPeriodStartDate);
                end;
            PayCycleFrequency::Anually:
                begin
                    ActualPeriodStartDate := CALCDATE('-CY', FirstPeriodStartDate);
                    ActualPeriodEndDate := CALCDATE('-CY-1D+' + FORMAT(NoOfPeriods) + 'Y', FirstPeriodStartDate);
                end;
        end;


        CLEAR(LineNo);
        Period.RESET;
        Period.SETCURRENTKEY("Period Type", "Period Start");
        Period.SETRANGE("Period Type", PayCycleFrequency);
        Period.SETRANGE("Period Start", ActualPeriodStartDate, ActualPeriodEndDate);
        if Period.FINDFIRST then begin
            repeat
                LineNo += 10;
                PayPeriods.INIT;
                PayPeriods."Pay Cycle" := PayCycle;
                PayPeriods."Line No." := LineNo;
                PayPeriods."Period Start Date" := Period."Period Start";
                PayPeriods."Period End Date" := Period."Period End";
                PayPeriods.Year := DATE2DMY(Period."Period Start", 3);
                PayPeriods.Month := FORMAT(Period."Period Start", 0, '<Month Text>');
                PayPeriods.Status := PayPeriods.Status::Open;
                PayPeriods.INSERT;
            until Period.NEXT = 0;
        end;
    end;

    var
        PayCycleFrequency: Option Daily,Weekly,Monthly,Quarterly,Anually;
        NoOfPeriods: Integer;
        FirstPeriodStartDate: Date;
        PayPeriods: Record "Pay Periods";
        PayCycle: Code[20];
        Period: Record Date;
        ActualPeriodStartDate: Date;
        ActualPeriodEndDate: Date;
        LineNo: Integer;

    procedure SetValues(l_PayCycleFrequency: Option Daily,Weekly,Monthly,Quarterly,Anually; l_NoOfPeriods: Integer; l_FirstPeriodStartDate: Date; l_FirstPaymentDate: Date; l_PayCycle: Code[20]);
    begin
        PayCycleFrequency := l_PayCycleFrequency;
        PayCycle := l_PayCycle;
    end;
}