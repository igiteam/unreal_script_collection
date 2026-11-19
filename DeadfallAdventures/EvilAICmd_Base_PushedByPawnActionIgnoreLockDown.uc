class EvilAICmd_Base_PushedByPawnActionIgnoreLockDown extends EvilAICmd_Base_PushedByPawnAction within EvilAIController;

function LockdownAI()
{
    Outer.bPreparingMove = true;
    //return;    
}
