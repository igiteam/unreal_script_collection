class SeqAct_R6FadeScreen extends SeqAct_Latent
    native
    hidecategories(Object);

var() FadeParams m_FadeParameters;
var bool m_bDone;
var float m_fTotalFadeTime;

defaultproperties
{
    m_FadeParameters=(m_szText="",m_fFadeDuration=1.0000000,m_fBlockInputsTime=1.0000000,m_fPauseHudTime=1.0000000,m_cStartColor=(R=255,G=255,B=255,A=255),m_cEndColor=(R=255,G=255,B=255,A=0),m_bCloseOnceDone=true,m_pMovie=none,m_eInterpolationType=1)
    OutputLinks[0]=(Links=none,LinkDesc="Done",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Player',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Fade To/From Color"
    ObjCategory="Menus"
}