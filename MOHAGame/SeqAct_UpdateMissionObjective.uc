class SeqAct_UpdateMissionObjective extends SequenceAction
    native
    hidecategories(Object);

var int numNonMiscPromptLinks;
var array<int> wildCards;
var() int numWildCards;

defaultproperties
{
    numNonMiscPromptLinks=4
    numWildCards=1
    InputLinks[0]=(LinkDesc="Activate",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[1]=(LinkDesc="Succeed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[2]=(LinkDesc="Fail",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[3]=(LinkDesc="Discover",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjClassVersion=2
    ObjName="Update Mission Objective"
    ObjCategory="Objectives"
}