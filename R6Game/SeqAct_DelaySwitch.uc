class SeqAct_DelaySwitch extends SeqAct_Latent
    native
    hidecategories(Object);

var() int LinkCount;
var transient int CurrentIdx;
var transient float SwitchDelay;
var transient float NextLinkTime;

defaultproperties
{
    LinkCount=1
    OutputLinks[0]=(Links=none,LinkDesc="Link 1",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Float',LinkedVariables=none,LinkDesc="Delay",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Int',LinkedVariables=none,LinkDesc="Active Link",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0)
    ObjName="Delayed"
    ObjCategory="Switch"
}