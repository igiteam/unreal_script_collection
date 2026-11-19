class SeqAct_ForceMoveMode extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Pawn TargetPawn;
var() EvilTypesNative.EMoveMode MoveMode;

event Activated()
{
    local EvilPawn EPawn;

    EPawn = EvilPawn(TargetPawn);
    // End:0x53
    if(EPawn != none)
    {
        EPawn.ForceLimitedMoveMode(MoveMode);
    }
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TargetPawn",LinkVar="None",PropertyName="TargetPawn",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Force Move Mode"
}