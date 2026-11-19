class SeqAct_R6ShowTeamBasedTextInformationBox extends SequenceAction
    native
    perobjectconfig
    hidecategories(Object);

var() float fTimeShown;
var() const localized string m_strInteractorText;
var() const localized string m_strInteractorTeammateText;
var() const localized string m_strAdversaryTeamText;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.R6SeqVar_Pawn',LinkedVariables=none,LinkDesc="InteractorPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Show Team-Based Text In Information Box"
    ObjCategory="Menus"
}