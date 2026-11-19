class SeqAct_R6AIShoot extends SeqAct_Latent
    native
    hidecategories(Object);

var() bool bInterruptable;
var() bool bNonConcurrent;
var() bool m_bDisableAITalk;
var() float m_fShootTimer;
var() R6GameEnums.EShootBurstLength m_eBurstLength;
var() R6GameEnums.EFiringType m_eFiringType;
var float m_fRemainingShootTimer;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Interactor",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Shoot"
    ObjCategory="R6AI"
}