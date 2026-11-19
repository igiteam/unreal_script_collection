class SeqAct_DoPawnAction extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum EKismetPawnAction
{
    EKPA_Finisher,                  // 0
    EKPA_JumpOverCover,             // 1
    EKPA_MAX                        // 2
};

var() SeqAct_DoPawnAction.EKismetPawnAction PawnActionToDo;
var() int Flags;
var() Actor InteractionPawn;

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Interaction Pawn",LinkVar="None",PropertyName="InteractionPawn",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Do Pawn Action!"
}