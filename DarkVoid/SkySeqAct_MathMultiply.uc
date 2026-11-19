class SkySeqAct_MathMultiply extends SequenceAction
    native;

enum VarTypeMultiply
{
    Multiply_Float,                 // 0
    Multiply_Integer,               // 1
    Multiply_MAX                    // 2
};

struct native MultiplyEntry
{
    var() string Name;

    structdefaultproperties
    {
        Name=""
    }
};

var() array<MultiplyEntry> InputValues;
var() SkySeqAct_MathMultiply.VarTypeMultiply VariableType;
var float ResultFloat;
var int ResultInt;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

event Activated()
{
    local int I;

    OutputLinks[0].bHasImpulse = false;
    ResultFloat = 0.0000000;
    ResultInt = 0;
    I = 0;
    J0x2E:

    // End:0x13A [Loop If]
    if(I < InputValues.Length)
    {
        switch(VariableType)
        {
            // End:0xB7
            case 0:
                // End:0x86
                if(I == 0)
                {
                    ResultFloat = SeqVar_Float(VariableLinks[I].LinkedVariables[0]).FloatValue;                    
                }
                else
                {
                    ResultFloat *= SeqVar_Float(VariableLinks[I].LinkedVariables[0]).FloatValue;
                }
                // End:0x130
                break;
            // End:0x12A
            case 1:
                // End:0xF7
                if(I == 0)
                {
                    ResultInt = SeqVar_Int(VariableLinks[I].LinkedVariables[0]).IntValue;                    
                }
                else
                {
                    ResultInt *= float(SeqVar_Int(VariableLinks[I].LinkedVariables[0]).IntValue);
                }
                // End:0x130
                break;
            // End:0xFFFF
            default:
                // End:0x130
                break;
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x2E;
    }
    //return;    
}
