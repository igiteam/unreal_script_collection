class SeqAct_R6SetAnimation extends SequenceAction
    native
    hidecategories(Object);

var() array<AnimSet> AnimSets;
var() editconst transient array<name> AvailableAnims;
var() bool m_bStopMatineesPlayingOnActor;
var() R6ScriptedAnimInfo AnimInformation;

defaultproperties
{
    AnimInformation=(m_AnimName="None",m_bLooping=false,m_bKeepAnimAtLastFrame=false,m_fAnimPos=0.0000000,m_fStartPos=0.0000000,m_fPlayRate=1.0000000,m_fStartBlendTime=0.5000000,m_fEndBlendTime=0.5000000,m_bApplyRootYawRotation=true,m_bNoFailCollision=false,m_bIsFacial=false,m_bCalculateVelocity=false,m_eRootMotion=2,m_eRootMotion[1]=2,m_eRootMotion[2]=0)
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Pause",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Playing",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Stopped",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Paused",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Set Animation"
    ObjCategory="Pawn"
}