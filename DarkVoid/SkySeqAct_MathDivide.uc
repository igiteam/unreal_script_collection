class SkySeqAct_MathDivide extends SequenceAction
    native;

enum VarTypeDivide
{
    Divide_Float,                   // 0
    Divide_Integer,                 // 1
    Divide_MAX                      // 2
};

struct native DivideEntry
{
    var() string Name;

    structdefaultproperties
    {
        Name=""
    }
};

var() array<DivideEntry> InputValues;
var() SkySeqAct_MathDivide.VarTypeDivide VariableType;
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

    // End:0x198 [Loop If]
    if(I < InputValues.Length)
    {
        switch(VariableType)
        {
            // End:0xE8
            case 0:
                // End:0xE5
                if(SeqVar_Float(VariableLinks[I].LinkedVariables[0]).FloatValue > 0.0000000)
                {
                    // End:0xB7
                    if(I == 0)
                    {
                        ResultFloat = SeqVar_Float(VariableLinks[I].LinkedVariables[0]).FloatValue;                        
                    }
                    else
                    {
                        ResultFloat /= SeqVar_Float(VariableLinks[I].LinkedVariables[0]).FloatValue;
                    }
                }
                // End:0x18E
                break;
            // End:0x188
            case 1:
                // End:0x185
                if(SeqVar_Int(VariableLinks[I].LinkedVariables[0]).IntValue > 0)
                {
                    // End:0x155
                    if(I == 0)
                    {
                        ResultInt = SeqVar_Int(VariableLinks[I].LinkedVariables[0]).IntValue;                        
                    }
                    else
                    {
                        ResultInt /= float(SeqVar_Int(VariableLinks[I].LinkedVariables[0]).IntValue);
                    }
                }
                // End:0x18E
                break;
            // End:0xFFFF
            default:
                // End:0x18E
                break;
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x2E;
    }
    //return;    
}
