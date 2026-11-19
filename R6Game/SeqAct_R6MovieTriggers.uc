class SeqAct_R6MovieTriggers extends SeqAct_Latent
    native
    hidecategories(Object);

var() TextureMovie Movie;
var() array<float> m_arrTriggerTimes;
var() bool m_bPlayMovie;
var() bool m_bShowMovieInPIP;
var bool m_bMovieStartedPlaying;
var float m_fLastFrameTime;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Attach",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Started",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Stopped",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Movie Time Triggers"
    ObjCategory="PIP"
}