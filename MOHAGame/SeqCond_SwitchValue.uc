class SeqCond_SwitchValue extends SequenceCondition
    native
    hidecategories(Object);

struct native SwitchValueInfo
{
    var() name Value;
    var() byte bAlwaysActivate;

    structdefaultproperties
    {
        Value="None"
        bAlwaysActivate=0
    }
};

var() array<SwitchValueInfo> ValueArray;
var() name CurrentValue;

defaultproperties
{
    ValueArray[0]=(Value="Default",bAlwaysActivate=0)
    OutputLinks[0]=(Links=none,LinkDesc="Default",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Switch Value"
}