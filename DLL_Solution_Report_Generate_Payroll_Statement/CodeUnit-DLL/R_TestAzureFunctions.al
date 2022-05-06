report 70100 "Test Azure Functions"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = TRUE;

    TRIGGER OnPreReport()
    BEGIN
        // Start here Emp. Benefits List Table
        clear(VJsonObjectLines);
        Clear(JToken);
        Clear(VJsonArrayLines);
        clear(VJsonObjectLines);
        VJsonObjectLines.Add('Benefitcode', 'EOS');
        VJsonObjectLines.Add('UnitFormula', '');
        VJsonObjectLines.Add('ValueFormula', '([BA_OB_EOS])');
        VJsonObjectLines.Add('EncashmentFormula', '');
        VJsonArrayLines.Add(VJsonObjectLines);
        JToken := VJsonArrayLines.AsToken();
        VJsonObjectLines1.Add('EBList', JToken);
        ReturnJsonStringTxtL := FORMAT(VJsonObjectLines1);
        Message(ReturnJsonStringTxtL);
        content.WriteFrom(ReturnJsonStringTxtL);
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        request.Content := content;
        request.SetRequestUri('https://azfn-payroll.azurewebsites.net/api/PayrollCalculationDLL_Levtech');
        request.Method := 'POST';
        client.Send(request, response);
        response.Content().ReadAs(responseText);
        Message(responseText);
    END;

    VAR
        ReturnJsonStringTxtL: Text;
        VJsonObjectLines: JsonObject;
        VJsonObjectLines1: JsonObject;
        VJsonArray: JsonArray;
        VJsonArrayLines: JsonArray;
        JToken: JsonToken;
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
        responseText: Text;
}