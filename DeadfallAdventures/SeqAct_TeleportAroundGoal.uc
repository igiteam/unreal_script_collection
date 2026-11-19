class SeqAct_TeleportAroundGoal extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor TeleportGoal;
var int TargetIdx;

function CallOnTeleportAroundGoal()
{
    local Object TargetObj;
    local AdvAIController TargetController;

    TargetObj = Targets[TargetIdx];
    TargetController = ((AdvPawn(TargetObj) != none) ? AdvPawn(TargetObj).MyAdvAI : AdvAIController(TargetObj));
    // End:0xA9
    if(TargetController != none)
    {
        TargetController.OnTeleportAroundGoal(self);
    }
    TargetIdx++;
    // End:0xF4
    if(TargetIdx < Targets.Length)
    {
        TargetController.SetTimer(0.3000000, false, 'CallOnTeleportAroundGoal', self);
    }
    //return;    
}

event Activated()
{
    TargetIdx = 0;
    CallOnTeleportAroundGoal();
    //return;    
}

defaultproperties
{
    bCallHandler=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Goal",LinkVar="None",PropertyName="TeleportGoal",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Teleport Around Goal"
}