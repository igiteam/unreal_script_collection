class EvilAICmd_EmergeByAI extends EvilAiCmd_Emerge within EvilAIController;

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    return true;
    //return ReturnValue;    
}

function Popped()
{
    Outer.MyEvilPawn.CheckGetUpFromAnimation();
    super.Popped();
    //return;    
}

defaultproperties
{
    bIgnoreNotifies=false
}