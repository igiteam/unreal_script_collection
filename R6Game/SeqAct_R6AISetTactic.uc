class SeqAct_R6AISetTactic extends SeqAct_Latent
    native
    hidecategories(Object);

var() Actor.ETacticType m_Tactic;
var() bool m_bNoFeedBack;
var bool m_bCouldSwitch;

defaultproperties
{
    m_Tactic=1
    m_bNoFeedBack=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Set Tactic"
    ObjCategory="R6AI"
}