class EvilComboAction_DoPawnAction extends EvilComboAction_Base
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Action);

var() SeqAct_DoPawnAction.EKismetPawnAction PawnActionToDo;

function float Run(EvilPawn Instigator, out ComboActionState S)
{
    local SeqAct_DoPawnAction DPA;

    DPA = new Class'SeqAct_DoPawnAction';
    DPA.PawnActionToDo = self.PawnActionToDo;
    Instigator.OnDoPawnAction(DPA);
    return 0.0000000;
    //return ReturnValue;    
}
