class SeqAct_RangeSwitch extends SequenceAction
    native
    hidecategories(Object);

struct SwitchRange
{
    var() int Min;
    var() int Max;

    structdefaultproperties
    {
        Min=0
        Max=0
    }
};

var() editinline array<editinline SwitchRange> Ranges;

defaultproperties
{
    OutputLinks=none
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Int',LinkedVariables=none,LinkDesc="Index",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Ranged"
    ObjCategory="Switch"
}