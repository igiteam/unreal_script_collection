class SeqAct_BeginPlayerITP extends SequenceAction
    hidecategories(Object);

var MOHAPlayerPlaneBase playerPlane;
var() float fTimeBetweenPushes;
var() int numPushesUntilForceJump;
var() AnimTree LevelSpecificAnimtree;
var() AnimSet LevelSpecificAnimset;
var() float fDebugSkipWorldTimeVal;
var() float fViewPitchMax;
var() float fViewPitchMin;
var() float fViewYawMax;
var() float fViewYawMin;

defaultproperties
{
    fTimeBetweenPushes=3.0000000
    numPushesUntilForceJump=3
    fDebugSkipWorldTimeVal=30.0000000
    fViewPitchMax=90.0000000
    fViewPitchMin=-41.0000000
    fViewYawMax=60.0000000
    fViewYawMin=-60.0000000
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    OutputLinks[0]=(Links=none,LinkDesc="Voluntary",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Involuntary",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Player Plane",LinkVar="None",PropertyName="playerPlane",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Begin Player ITP Sequence"
    ObjCategory="In The Plane"
}