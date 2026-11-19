class SkySeqAct_MathSubtract extends SequenceAction
    native;

enum VarTypeSubtract
{
    Subtract_Float,                 // 0
    Subtract_Integer,               // 1
    Subtract_MAX                    // 2
};

struct native SubtractEntry
{
    var() string Name;

    structdefaultproperties
    {
        Name=""
    }
};

var() array<SubtractEntry> InputValues;
var() SkySeqAct_MathSubtract.VarTypeSubtract VariableType;
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

    // End:0x138 [Loop If]
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
                    ResultFloat -= SeqVar_Float(VariableLinks[I].LinkedVariables[0]).FloatValue;
                }
                // End:0x12E
                break;
            // End:0x128
            case 1:
                // End:0xF7
                if(I == 0)
                {
                    ResultInt = SeqVar_Int(VariableLinks[I].LinkedVariables[0]).IntValue;                    
                }
                else
                {
                    ResultInt -= SeqVar_Int(VariableLinks[I].LinkedVariables[0]).IntValue;
                }
                // End:0x12E
                break;
            // End:0xFFFF
            default:
                // End:0x12E
                break;
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x2E;
    }
    //return;    
}
