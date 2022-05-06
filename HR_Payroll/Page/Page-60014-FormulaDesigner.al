page 60014 "Formula Designer"
{
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control19)
            {
                field("Key Input"; KeyInput)
                {
                    ApplicationArea = All;
                }
            }
            group(Control7)
            {
                field(Parameters; Parameters)
                {
                    ApplicationArea = All;
                    TableRelation = "Payroll Formula" WHERE("Formula Key Type" = CONST(Parameter));
                }
                field("Pay Components"; PayComponents)
                {
                    ApplicationArea = All;
                    TableRelation = "Payroll Formula" WHERE("Formula Key Type" = CONST("Pay Component"));
                }
                field(Benefits; Benefits)
                {
                    ApplicationArea = All;
                    TableRelation = "Payroll Formula" WHERE("Formula Key Type" = CONST(Benefit));
                }
                field("Leave Types"; LeaveTypes)
                {
                    ApplicationArea = All;
                    TableRelation = "Payroll Formula" WHERE("Formula Key Type" = CONST("Leave Type"));
                }
                field("Custom Formula Key"; CustomFormulaKeys)
                {
                    ApplicationArea = All;
                    TableRelation = "Payroll Formula" WHERE("Formula Key Type" = CONST(Custom));
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Add)
            {
                ApplicationArea = All;
                Caption = 'Add';
                Image = Add;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    KeyInput := KeyInput + Parameters + PayComponents + Benefits + LeaveTypes + CustomFormulaKeys;
                    CLEAR(Parameters);
                    CLEAR(PayComponents);
                    CLEAR(Benefits);
                    CLEAR(LeaveTypes);
                    CLEAR(CustomFormulaKeys);
                end;
            }
            action("Clear Input")
            {
                ApplicationArea = All;
                Caption = 'Clear Input';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    Calc('C');
                end;
            }
        }
    }

    var
        KeyInput: Text;
        Parameters: Text;
        PayComponents: Text;
        Benefits: Text;
        LeaveTypes: Text;
        CustomFormulaKeys: Text;

    procedure Calc(input: Char)
    begin
        case input of
            'C':
                begin
                    CLEAR(KeyInput);
                end;
        end;
    end;
}