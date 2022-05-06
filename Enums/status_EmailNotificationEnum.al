enum 70500 "Email Notification Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; "Created") { Caption = 'Created'; }
    value(1; "Open") { Caption = 'Open'; }
    value(2; "Canceled") { Caption = 'Canceled'; }
    value(3; "Rejected") { Caption = 'Rejected'; }
    value(4; "Approved") { Caption = 'Approved'; }
}

enum 70501 "Email Notification Sent Status"
{
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; "Open") { Caption = 'Open'; }
    value(1; "Success") { Caption = 'Success'; }
    value(2; "Error") { Caption = 'Error'; }
}