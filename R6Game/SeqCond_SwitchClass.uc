class SeqCond_SwitchClass extends SequenceCondition
    native
    hidecategories(Object);

struct SwitchClassInfo
{
    var() name ClassName;
    var() byte bFallThru;

    structdefaultproperties
    {
        ClassName="None"
        bFallThru=0
    }
};

var() array<SwitchClassInfo> ClassArray;

defaultproperties
{
    ClassArray[0]=(ClassName="Default",bFallThru=0)
    OutputLinks[0]=(Links=none,LinkDesc="Default",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Object",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Switch Class"
}