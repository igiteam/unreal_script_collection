class SeqAct_Possess extends SequenceAction
    native
    hidecategories(Object);

var transient Pawn PawnToPossess;
var() bool bKillOldPawn;
var() bool bTryToLeaveVehicle;

defaultproperties
{
    bTryToLeaveVehicle=true
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Pawn Target",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Possess Pawn"
    ObjCategory="Pawn"
}