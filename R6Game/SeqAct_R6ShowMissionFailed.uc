class SeqAct_R6ShowMissionFailed extends SequenceAction
    native
    hidecategories(Object);

var() R6MissionFailedInfo FailureInfo;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Player',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Show Mission Failed Screen"
    ObjCategory="Menus"
}