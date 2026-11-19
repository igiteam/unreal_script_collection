class EvilAICmd_Attack_Throw extends EvilAICmd_SpecialMove within EvilAIController;

var Vector ThrowLocation;

static function bool Throw(EvilAIController AI)
{
    local EvilAICmd_Attack_Throw Cmd;

    Cmd = new (AI) Class'EvilAICmd_Attack_Throw';
    // End:0x59
    if(Cmd != none)
    {
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function FireFailure()
{
    GotoState('DelayFailure');
    //return;    
}

function Pushed()
{
    super.Pushed();
    Outer.bFailedToThrow = false;
    Outer.MyEvilPawn.bThrowingGrenade = true;
    // End:0x1A6
    if((Outer.Enemy != none) && (int(Outer.MyEvilPawn.CoverType) == int(0)) || int(Outer.MyEvilPawn.CoverAction) != int(0))
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
        ThrowLocation = Outer.Enemy.Location;
        GotoState('Command_SpecialMove');        
    }
    else
    {
        FireFailure();
    }
    //return;    
}

function Popped()
{
    super.Popped();
    Outer.MyEvilPawn.bThrowingGrenade = false;
    Outer.LastThrowGrenadeTime = Outer.WorldInfo.TimeSeconds;
    // End:0x15F
    if((Status == 'Failure') || Status == 'Aborted')
    {
        Outer.bFailedToThrow = true;
        Outer.MyEvilPawn.EndPawnAction(9);
        Outer.ReactionManager.NudgeChannel(Outer, 'AbortedThrowing');
    }
    //return;    
}

state Command_SpecialMove
{
    ignores FinishedSpecialMove;

    function byte GetPawnAction()
    {
        return Outer.MyEvilPawn.PawnAction;
        //return ReturnValue;        
    }

    function bool SetupSpecialMove()
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
        // End:0xC1
        if(Outer.MyEvilPawn.CanAim())
        {
            // End:0xC1
            if(Outer.MyEvilPawn.IsAiming())
            {
            }
        }
        return Outer.Enemy != none;
        //return ReturnValue;        
    }

    function bool IsReady()
    {
        // End:0x32
        if(!Outer.HasValidEnemy())
        {
            GotoState('DelayedFailure');
        }
        // End:0xDC
        if(Outer.GetFocalPoint() != Outer.Enemy.Location)
        {
            Outer.SetFocalPoint(Outer.Enemy.Location);
        }
        return (Outer.Enemy != none) && !Outer.MyEvilPawn.bPlayingTurnTransition;
        //return ReturnValue;        
    }

    function bool ExecuteSpecialMove()
    {
        // End:0x70
        if(Outer.Pawn.HasRangedAttack())
        {
            Outer.StartThrowAttack();
            // End:0x6E
            if(int(GetPawnAction()) == 9)
            {
                return true;                
            }
            else
            {
                return false;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function bool IsSpecialMoveComplete()
    {
        return super.IsSpecialMoveComplete() && int(Outer.MyEvilPawn.PawnAction) != 9;
        //return ReturnValue;        
    }

    function float GetPostSpecialMoveSleepTime()
    {
        return Outer.RestDelayAfterShoot;
        //return ReturnValue;        
    }
    stop;    
}
