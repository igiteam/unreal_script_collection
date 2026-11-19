class SkySeqAct_MathAdd extends SequenceAction
    native;

enum VarTypeAdd
{
    Add_Float,                      // 0
    Add_Integer,                    // 1
    Add_MAX                         // 2
};

struct native AddEntry
{
    var() string Name;

    structdefaultproperties
    {
        Name=""
    }
};

var() SkySeqAct_MathAdd.VarTypeAdd VariableType;
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

    ResultFloat = 0.0000000;
    ResultInt = 0;
    I = 0;
    J0x19:

    // End:0x1A8 [Loop If]
    if(I < VariableLinks[0].LinkedVariables.Length)
    {
        switch(VariableType)
        {
            // End:0xEB
            case 0:
                // End:0x97
                if(SeqVar_Float(VariableLinks[0].LinkedVariables[I]) != none)
                {
                    ResultFloat += SeqVar_Float(VariableLinks[0].LinkedVariables[I]).FloatValue;                    
                }
                else
                {
                    // End:0xE8
                    if(SeqVar_Union(VariableLinks[0].LinkedVariables[I]) != none)
                    {
                        ResultFloat += SeqVar_Union(VariableLinks[0].LinkedVariables[I]).FloatValue;
                    }
                }
                // End:0x19E
                break;
            // End:0x198
            case 1:
                // End:0x144
                if(SeqVar_Int(VariableLinks[0].LinkedVariables[I]) != none)
                {
                    ResultInt += SeqVar_Int(VariableLinks[0].LinkedVariables[I]).IntValue;                    
                }
                else
                {
                    // End:0x195
                    if(SeqVar_Union(VariableLinks[0].LinkedVariables[I]) != none)
                    {
                        ResultInt += SeqVar_Union(VariableLinks[0].LinkedVariables[I]).IntValue;
                    }
                }
                // End:0x19E
                break;
            // End:0xFFFF
            default:
                // End:0x19E
                break;
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x19;
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}
