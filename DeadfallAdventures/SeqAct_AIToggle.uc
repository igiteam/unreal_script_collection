class SeqAct_AIToggle extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bForceEnable;
var() bool bForceDisable;
var() bool bDontMove;
var() bool bForceDisableVO;
var() bool bForceEnableVO;

defaultproperties
{
    bDontMove=true
    ObjName="Disable AI"
}