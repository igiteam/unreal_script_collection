class EvilAICmd_RideRailCar extends EvilAICmd_Base_Combat within EvilAIController;

static function bool RideRailCar(EvilAIController AI)
{
    local EvilAICmd_RideRailCar Cmd;

    Cmd = new (AI) Class'EvilAICmd_RideRailCar';
    // End:0x59
    if(Cmd != none)
    {
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    return super(GameAICommand).AllowTransitionTo(AttemptCommand);
    //return ReturnValue;    
}
