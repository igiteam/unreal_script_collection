class SeqAct_R6ShowTextInformationBox extends SequenceAction
    native
    perobjectconfig
    hidecategories(Object);

var() float fTimeShown;
var() const localized string m_strText;
var() bool m_bSendToAllPlayers;
var() bool m_bSendOnlyToInteractor;

defaultproperties
{
    m_bSendToAllPlayers=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Player',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.R6SeqVar_Pawn',LinkedVariables=none,LinkDesc="InteractorPawn",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=5
    ObjName="Show Text In Information Box"
    ObjCategory="Menus"
}