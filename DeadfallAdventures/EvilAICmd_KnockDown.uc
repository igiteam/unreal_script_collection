class EvilAICmd_KnockDown extends EvilAICommand within EvilAIController;

function Pushed()
{
    super.Pushed();
    Outer.InvalidateCoverAction();
    Outer.InvalidateCover();
    GotoState('WaitForRecovery');
    //return;    
}

function PostPopped()
{
    super(GameAICommand).PostPopped();
    //return;    
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    return false;
    //return ReturnValue;    
}

state WaitForRecovery
{    J0x00:
    // End:0xA1 [Loop If]
    if((int(EvilPawn(Outer.Pawn).PawnAction) == 13) || Outer.Pawn.IsInState('KnockedDown'))
    {
        Outer.Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    Outer.PopCommand(self);
    stop;            
}

defaultproperties
{
    bReplaceActiveSameClassInstance=true
    bIgnoreNotifies=true
}