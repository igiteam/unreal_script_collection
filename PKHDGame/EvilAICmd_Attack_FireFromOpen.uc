class EvilAICmd_Attack_FireFromOpen extends EvilAICmd_SpecialMove within EvilAIController;

var int BurstsToFire;
var float BurstTimeOut;
var float BurstDelay;
var bool Initialized;

static function bool FireFromOpen(EvilAIController AI, optional int InBursts = 1, optional float InBurstDelay, optional bool bAllowFireWhileMoving = true)
{
    local EvilAICmd_Attack_FireFromOpen Cmd;

    Cmd = new (AI) Class'EvilAICmd_Attack_FireFromOpen';
    // End:0xB4
    if(Cmd != none)
    {
        Cmd.BurstDelay = InBurstDelay;
        Cmd.BurstsToFire = InBursts;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function FireFailure()
{
    GotoState('DelayedFailure');
    //return;    
}

function Pushed()
{
    super.Pushed();
    // End:0x31
    if(Outer.Enemy != none)
    {        
    }
    else
    {
        GotoState('DelayedFailure');
    }
    GotoState('Command_SpecialMove');
    //return;    
}

function Popped()
{
    super.Popped();
    // End:0x6A
    if(Status != 'Success')
    {
        Outer.ReactionManager.NudgeChannel(Outer, 'AbortedShooting');        
    }
    //return;    
}

state Command_SpecialMove
{
    function byte GetPawnAction()
    {
        return Outer.MyEvilPawn.PawnAction;
        //return ReturnValue;        
    }

    function bool SetupSpecialMove()
    {
        // End:0x6E
        if(Outer.MyEvilPawn.CanAim())
        {
            // End:0x6E
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
        return ((Outer.Enemy != none) && Outer.IsWeaponAimingAt(Outer.Enemy, 0.9000000)) && !Outer.MyEvilPawn.bPlayingTurnTransition;
        //return ReturnValue;        
    }

    function bool ExecuteSpecialMove()
    {
        // End:0x7C
        if(Outer.Pawn.HasRangedAttack())
        {
            Outer.StartShootAttack();
            // End:0x7A
            if(int(GetPawnAction()) == 11)
            {
                Initialized = true;
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
        return super.IsSpecialMoveComplete() || ((Outer.Enemy != none) && Outer.bFireWhileMoving) && Outer.NavigationHandle.ActorReachable(Outer.Enemy) || int(Outer.MyEvilPawn.PawnAction) == 12;
        //return ReturnValue;        
    }

    function float GetPostSpecialMoveSleepTime()
    {
        return Outer.RestDelayAfterShoot;
        //return ReturnValue;        
    }

    function FinishedSpecialMove()
    {
        BurstsToFire--;
        // End:0xCD
        if(BurstsToFire > 0)
        {
            // End:0xCD
            if(int(Outer.MyEvilPawn.PawnAction) == 11)
            {
                Outer.MyEvilPawn.EndPawnAction();
                Outer.MyEvilPawn.StartAim();
                GotoState('Command_Delay');
            }
        }
        //return;        
    }
    stop;    
}

state Command_Delay
{Begin:

    Outer.Sleep(BurstDelay);
    GotoState('Command_SpecialMove', 'Begin', false, true);
    stop;                    
}

defaultproperties
{
    BurstTimeOut=3.0000000
    BurstDelay=2.0000000
}