class EvilAiCmd_Emerge extends EvilAICmd_Base_PushedByPawnAction within EvilAIController;

function Pushed()
{
    super.Pushed();
    Outer.Pawn.SetPhysics(0);
    //return;    
}

function Popped()
{
    super.Popped();
    // End:0x62
    if(Outer.Pawn != none)
    {
        Outer.Pawn.SetMovementPhysics();
    }
    //return;    
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    return false;
    //return ReturnValue;    
}
