class EvilAICmd_Aim extends EvilAICmd_SpecialMove within EvilAIController;

var float MinAimTime;
var float AimStartTime;
var bool bAimToThrow;

static function bool AimEnemy(EvilAIController AI, optional float InMinAimTime, optional bool bInAimToThrow)
{
    local EvilAICmd_Aim Cmd;

    Cmd = new (AI) Class'EvilAICmd_Aim';
    // End:0xAD
    if(Cmd != none)
    {
        Cmd.MinAimTime = InMinAimTime;
        Cmd.bAimToThrow = bInAimToThrow;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Resumed(name OldCommandName)
{
    Status = 'Failure';
    Outer.ReactionManager.NudgeChannel(Outer, 'AbortedAiming');
    Outer.AbortCommand(self);
    //return;    
}

function Popped()
{
    super.Popped();
    // End:0x80
    if((Status == 'Failure') || Status == 'Aborted')
    {
        Outer.ReactionManager.NudgeChannel(Outer, 'AbortedAiming');
    }
    //return;    
}

function AimFailure()
{
    GotoState('DelayFailure');
    //return;    
}

function Pushed()
{
    super.Pushed();
    // End:0xBD
    if(Outer.Enemy != none)
    {
        // End:0xBA
        if(!Outer.MyEvilPawn.bInMoveLatent)
        {
            Outer.SetFocalPoint(Outer.Enemy.Location);
        }        
    }
    else
    {
        GotoState('DelayFailure');
    }
    Status = 'Failure';
    GotoState('Command_SpecialMove');
    //return;    
}

state Command_SpecialMove
{
    function bool SetupSpecialMove()
    {
        AimStartTime = Outer.WorldInfo.TimeSeconds;
        MinAimTime = FMin(MinAimTime + (Outer.GetEnemyInfo().DistanceToEnemy / float(2000)), 0.5000000);
        Outer.Focus = Outer.Enemy;
        return Outer.Enemy != none;
        //return ReturnValue;        
    }

    function byte GetPawnAction()
    {
        return Outer.MyEvilPawn.PawnAction;
        //return ReturnValue;        
    }

    function bool IsReady()
    {
        return true;
        //return ReturnValue;        
    }

    function bool ExecuteSpecialMove()
    {
        // End:0xB0
        if(Outer.Pawn.HasRangedAttack())
        {
            // End:0x66
            if(bAimToThrow)
            {
                Outer.StartAimToThrow();                
            }
            else
            {
                Outer.MyEvilPawn.StartAim();
            }
            PawnAction = GetPawnAction();
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool IsSpecialMoveComplete()
    {
        // End:0x72
        if(!Outer.HasValidEnemy() || int(Outer.MyEvilPawn.CurrentAimZone) == int(0))
        {
            GotoState('DelayFailure');
        }
        return !Outer.MyEvilPawn.IsAiming() || ((Outer.WorldInfo.TimeSeconds - AimStartTime) > MinAimTime) && Outer.IsWeaponAimingAt(Outer.Enemy, Outer.TargettedAimEpsilon);
        //return ReturnValue;        
    }

    function float GetPostSpecialMoveSleepTime()
    {
        return -1.0000000;
        //return ReturnValue;        
    }

    function FinishedSpecialMove()
    {
        Status = 'Success';
        // End:0x7E
        if(bAimToThrow)
        {
            Outer.ReactionManager.NudgeChannel(Outer.Enemy, 'TargetAimedToThrow');            
        }
        else
        {
            Outer.ReactionManager.NudgeChannel(Outer.Enemy, 'TargetAimed');
        }
        //return;        
    }

    function SpecialMoveTimeout()
    {
        Outer.MyEvilPawn.EndPawnAction(PawnAction);
        super.SpecialMoveTimeout();
        //return;        
    }
    stop;    
}
