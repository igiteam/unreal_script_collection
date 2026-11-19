class EvilAICmd_Base_PushedByPawnAction extends EvilAICmd_SpecialMove within EvilAIController;

static function EvilAICmd_Base_PushedByPawnAction PushSpecialMoveCommand(EvilAIController AIOwner)
{
    local EvilAICmd_Base_PushedByPawnAction Cmd;

    // End:0xE8
    if((AIOwner != none) && AIOwner.MyEvilPawn != none)
    {
        Cmd = new (AIOwner) default.Class;
        // End:0xE8
        if(Cmd != none)
        {
            Cmd.PawnAction = AIOwner.MyEvilPawn.PawnAction;
            AIOwner.PushCommand(Cmd);
            return Cmd;
        }
    }
    return none;
    //return ReturnValue;    
}

event string GetDumpString()
{
    return (super(EvilAICommand).GetDumpString() @ "PawnAction") @ string(PawnAction);
    //return ReturnValue;    
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    GotoState('WaitForMove');
    //return;    
}

function Popped()
{
    Outer.ClearTimer('SpecialMoveTimeout', self);
    super.Popped();
    //return;    
}

state WaitForMove
{
    function bool IsSpecialMoveComplete()
    {
        // End:0x93
        if((!Outer.bPreparingMove || Outer.MyEvilPawn == none) || int(Outer.MyEvilPawn.PawnAction) != int(PawnAction))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    Outer.SetTimer(TimeOutDelaySeconds, false, 'SpecialMoveTimeout', self);
    J0x2C:

    Outer.Sleep(0.1000000);
    // End:0x2C
    if(!(IsSpecialMoveComplete()))
        goto J0x2C;
    Status = 'Success';
    Outer.PopCommand(self);
    stop;            
}

defaultproperties
{
    bIgnoreNotifies=true
}