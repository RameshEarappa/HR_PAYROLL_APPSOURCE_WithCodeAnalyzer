codeunit 70100 "Expression Formula"
{
    trigger OnRun();
    begin
        strFormula := '((10000*12)/365)';
        MESSAGE(Calc(strFormula, CurrentSeparator));
    end;

    var
        strFormula: Text[250];

    procedure Calc(Expression: Text[250]; Separator: Char): Text[250];
    var
        Pos: Integer;
        strBuf: Text[250];
        stackNumber: array[256] of Decimal;
        stackNumberCount: Integer;
        stackSign: array[256] of Char;
        stackSignCount: Integer;
        decNumber1: Decimal;
        decNumber2: Decimal;
        Text001: Label 'Error: You cannot enter ''%1'' in decimal.';
        Text002: Label 'Error: The Calc is not support ''%1'' symbol.';
        flagBegin: Boolean;
    begin
        /* --- set Pos --- */
        Pos := 1;

        /* --- main loop --- */
        WHILE Pos <= STRLEN(Expression) DO BEGIN
            CASE Expression[Pos] OF

                /* --- get number --- */
                '0' .. '9':
                    BEGIN
                        strBuf := COPYSTR(Expression, Pos, 1);
                        WHILE (Expression[Pos + 1] IN ['0' .. '9']) OR (Expression[Pos + 1] = Separator) DO BEGIN
                            Pos += 1;
                            strBuf := strBuf + COPYSTR(Expression, Pos, 1);
                        END;
                        stackNumberCount += 1;
                        IF NOT EVALUATE(stackNumber[stackNumberCount], strBuf) THEN
                            EXIT(STRSUBSTNO(Text001, strBuf));
                    END;

                /* --- get operation or sign ---*/
                '-', '+', '*', '/':
                    BEGIN
                        /* --- for negative numbers --- */
                        IF (Expression[Pos] = '-') AND flagBegin THEN BEGIN
                            stackNumberCount += 1;
                            stackNumber[stackNumberCount] := -1;
                            stackSignCount += 1;
                            stackSign[stackSignCount] := '*';
                        END
                        ELSE BEGIN
                            stackSignCount += 1;
                            stackSign[stackSignCount] := Expression[Pos];
                        END;
                    END;

                /* --- calc --- */
                ')':
                    BEGIN
                        decNumber1 := stackNumber[stackNumberCount];
                        stackNumberCount -= 1;
                        decNumber2 := stackNumber[stackNumberCount];
                        CASE stackSign[stackSignCount] OF
                            '-':
                                decNumber2 -= decNumber1;
                            '+':
                                decNumber2 += decNumber1;
                            '*':
                                decNumber2 *= decNumber1;
                            '/':
                                decNumber2 /= decNumber1;
                        END;
                        stackSignCount -= 1;
                        stackNumber[stackNumberCount] := decNumber2;
                    END;

                /* --- skip --- */
                ' ', '(':
                    WHILE Expression[Pos + 1] IN [' ', '('] DO
                        Pos += 1;

                /* --- error --- */
                ELSE
                    EXIT(STRSUBSTNO(Text002, Expression[Pos]));

            END;

            /* --- keep begin --- */
            flagBegin := Expression[Pos] = '(';

            /* -- inc Pos --- */
            Pos += 1;
        END;

        /* --- result --- */
        EXIT(FORMAT(stackNumber[stackNumberCount]));

    end;

    procedure CurrentSeparator(): Char;
    begin
        EXIT(FORMAT(3 / 2) [2])
    end;
}