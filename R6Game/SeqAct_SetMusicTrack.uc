class SeqAct_SetMusicTrack extends SequenceAction
    native
    hidecategories(Object);

var() name TrackBankName;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Set Music Track",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_MusicTrackBank',LinkedVariables=none,LinkDesc="MusicTrackBank",LinkVar="None",PropertyName="Targets",bWriteable=true,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_MusicTrack',LinkedVariables=none,LinkDesc="MusicTrack",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    ObjName="Set Music Track"
    ObjCategory="Sound"
}