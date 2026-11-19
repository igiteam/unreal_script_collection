class SeqAct_R6ShowMissionSuccess extends SequenceAction
    native
    hidecategories(Object);

var() string m_strNextMissionName;
var() bool m_bSaveInventory;
var() bool m_bLastLevel;

defaultproperties
{
    m_bSaveInventory=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Player',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Unlock Mission And Load Next Mission"
    ObjCategory="Menus"
}