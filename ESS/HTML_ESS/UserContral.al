controladdin HTML
{
    StartupScript = '.\ESS\HTML_ESS\startup.js';
    Scripts = '.\ESS\HTML_ESS\script.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    RequestedHeight = 200;
    RequestedWidth = 200;
    event ControlReady();

    procedure Render(HTML: text);
}