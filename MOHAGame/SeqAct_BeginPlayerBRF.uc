class SeqAct_BeginPlayerBRF extends SequenceAction
    hidecategories(Object);

var() AnimTree LevelSpecificAnimtree;
var() AnimSet LevelSpecificAnimset;
var() float fViewPitchMax;
var() float fViewPitchMin;
var() float fViewYawMax;
var() float fViewYawMin;

defaultproperties
{
    fViewPitchMax=90.0000000
    fViewPitchMin=-41.0000000
    fViewYawMax=60.0000000
    fViewYawMin=-60.0000000
    bLatentExecution=true
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    ObjName="Begin Player BRF Sequence"
    ObjCategory="In The Briefing Room"
}