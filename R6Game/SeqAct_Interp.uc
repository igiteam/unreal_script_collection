class SeqAct_Interp extends SeqAct_Latent
    native
    hidecategories(Object);

var() float PlayRate;
var float Position;
var bool bIsPlaying;
var bool bPaused;
var() bool bLooping;
var() bool bRewindOnPlay;
var() bool bNoResetOnRewind;
var() bool bRewindIfAlreadyPlaying;
var bool bReversePlayback;
var() bool bInterpForPathBuilding;
var() bool bClientSideOnly;
var() bool m_bIsNeverStoppedAutomatically;
var() bool m_bStopMatineesPlayingOnActor;
var export InterpData InterpData;
var array<InterpGroupInst> GroupInst;
var const MatineeActor ReplicatedActor;

defaultproperties
{
    PlayRate=1.0000000
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Reverse",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[3]=(LinkDesc="Pause",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[4]=(LinkDesc="Change Dir",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Completed",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'InterpData',LinkedVariables=none,LinkDesc="Data",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    ObjName="Matinee"
}