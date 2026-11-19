class SeqAct_PlaySound extends SeqAct_Latent
    native
    hidecategories(Object);

var() /*0x04000000-0x00000000*/ SoundCue PlaySound;
var() R6EngineEnums.ESoundSlot m_eSoundSlot;
var transient bool m_bPaused;
var() float ExtraDelay;
var transient float SoundDuration;
var() float FadeInTime;
var() float FadeOutTime;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Pause",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Play Sound"
    ObjCategory="Sound"
}