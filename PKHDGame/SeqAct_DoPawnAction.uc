class SeqAct_DoPawnAction extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum EKismetPawnAction
{
    EKPA_Finisher,                  // 0
    EKPA_MAX                        // 1
};

var() SeqAct_DoPawnAction.EKismetPawnAction PawnActionToDo;

defaultproperties
{
    ObjName="Do Pawn Action!"
}