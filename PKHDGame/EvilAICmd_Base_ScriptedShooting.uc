class EvilAICmd_Base_ScriptedShooting extends EvilAICmd_Base_Combat within EvilAIController;

var Actor Target;
var float ShootingTime;

static function bool FireAtTarget(EvilAIController AI, Actor InTarget)
{
    local EvilAICmd_Base_ScriptedShooting Cmd;

    // End:0xA7
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) default.Class;
        Cmd.Target = InTarget;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    return false;
    //return ReturnValue;    
}

function ExitWithFailure()
{
    PopState(true);
    super(EvilAICommand).ExitWithFailure();
    //return;    
}

function ExitWithSuccess()
{
    PopState(true);
    super(EvilAICommand).ExitWithSuccess();
    //return;    
}

function Pushed()
{
    super.Pushed();
    PushState('InCombat');
    //return;    
}

function Popped()
{
    super.Popped();
    //return;    
}

function bool CheckTransition(out class<EvilAICmd_Base_Combat> out_NewCommand, out string out_Reason)
{
    return false;
    //return ReturnValue;    
}

function bool ShouldReturnToIdle()
{
    return false;
    //return ReturnValue;    
}

function ReadyToFire(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    //return;    
}

state InCombat
{Begin:

    Outer.ChangeBehaviorMode(3);
    Outer.ShotTargetActor = Target;
    Outer.Focus = Target;
    J0x71:

    // End:0x16C [Loop If]
    if(true)
    {
        // End:0xE3
        if(Outer.MyEvilPawn.CanAim())
        {
            Outer.MyEvilPawn.StartAim();            
        }
        else
        {
            Outer.StartShootAttack();
        }
        J0x102:

        Outer.Sleep(0.1000000);
        // End:0x102
        if(!(!Outer.IsAiming() && !Outer.IsFiring()))
            goto J0x102;
        // [Loop Continue]
        goto J0x71;
    }
    Outer.ShotTargetActor = none;
    ExitWithSuccess();
    stop;        
}
