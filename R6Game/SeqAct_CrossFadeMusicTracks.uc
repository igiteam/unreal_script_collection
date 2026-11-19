class SeqAct_CrossFadeMusicTracks extends SequenceAction
    native
    hidecategories(Object);

var() name TrackBankName;
var name CurrTrackType;
var export editinline AudioComponent CurrPlayingTrack;

defaultproperties
{
    InputLinks[0]=(LinkDesc="CrossFade",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="CrossFadeTo_Custom",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="CrossFadeTo_Silence",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_String',LinkedVariables=none,LinkDesc="TrackTypeToFadeTo",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_MusicTrackBank',LinkedVariables=none,LinkDesc="MusicTrackBank",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    VariableLinks[3]=(ExpectedType=Class'SeqVar_MusicTrack',LinkedVariables=none,LinkDesc="CustomMusicTrack",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    ObjName="CrossFadeMusicTracks"
    ObjCategory="Sound"
}