class SeqAct_R6AISetTacticEntireTeam extends SeqAct_Latent
    native
    hidecategories(Object);

var() Actor.ETacticType m_Tactic;
var() bool bOnRainbowTeam;
var() bool m_bNoFeedBack;

defaultproperties
{
    m_Tactic=1
    m_bNoFeedBack=true
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Teams",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Set Tactic To Entire Team"
    ObjCategory="R6AI"
}