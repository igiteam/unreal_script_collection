class SeqAct_R6AIMoveTo extends SeqAct_Latent
    native
    hidecategories(Object);

var() bool bInterruptable;
var() bool bUltraPrecise;
var() bool bRotatePawnAfterMove;
var() bool bReverseWalk;
var() Actor.ER6MoveFlags m_eMoveFlag;
var Vector m_vFinalLoc;
var Rotator m_rFinalRot;

defaultproperties
{
    m_eMoveFlag=3
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Destination",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Vector',LinkedVariables=none,LinkDesc="Vector Dest",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=4
    ObjName="Move To"
    ObjCategory="R6AI"
}