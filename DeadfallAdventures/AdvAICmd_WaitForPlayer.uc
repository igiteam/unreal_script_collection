class AdvAICmd_WaitForPlayer extends EvilAICommand within EvilAIController;

var float CallIntervals;
var float PlayerDistance;
var bool bCallPlayer;
var bool bIgnoreDistance;
var EvilAIReactConditionConduit WaitingCondition;

static function bool ExecuteWaiting(EvilAIController AI, bool bIgnoreDist)
{
    local AdvAICmd_WaitForPlayer Cmd;

    // End:0xC8
    if((AI != none) && AI.MyEvilPawn != none)
    {
        Cmd = new (AI) Class'AdvAICmd_WaitForPlayer';
        Cmd.bIgnoreDistance = bIgnoreDist;
        Cmd.SetFinishCondition();
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function FinishWaitForPlayer(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    WaitingCondition.UnSubscribeAll();
    WaitingCondition.__OutputFunction__Delegate = None;
    WaitingCondition = none;
    Outer.bAllowCombatTransitions = true;
    GotoState('InFinishCommand');
    //return;    
}

function SetFinishCondition()
{
    Outer.MyEvilPawn.MyEvilAI.ReactionManager.UnSuppressAll();
    // End:0xB8
    if(bIgnoreDistance)
    {
        WaitingCondition = new (Outer.MyEvilPawn.MyEvilAI) Class'AdvAIReactCond_PlayerMovedForward';        
    }
    else
    {
        WaitingCondition = new (Outer.MyEvilPawn.MyEvilAI) Class'AdvAIReactCond_PlayerCloseOrMovedForward';
        AdvAIReactCond_PlayerCloseOrMovedForward(WaitingCondition).DistanceThreshold = PlayerDistance;
    }
    WaitingCondition.__OutputFunction__Delegate = FinishWaitForPlayer;
    WaitingCondition.Initialize();
    //return;    
}

function Pushed()
{
    super.Pushed();
    Outer.bAllowCombatTransitions = false;
    GotoState('InIdle');
    bIgnoreNotifies = false;
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    Outer.bAllowCombatTransitions = true;
    //return;    
}

state InFinishCommand
{Begin:

    // End:0x45
    if(Outer.GetActiveCommand() == self)
    {
        Status = 'Success';
        ExitWithSuccess();        
    }
    else
    {
        Outer.Sleep(0.1000000);
        goto 'Begin';
    }
    stop;                
}

state InCall
{Begin:

    // End:0x5E
    if(Outer.MyEvilPawn != none)
    {
        Outer.MyEvilPawn.ServerDoPawnAction(35);
    }
    GotoState('InIdle');
    stop;                
}

auto state InIdle
{Begin:

    Outer.Sleep(CallIntervals);
    // End:0x3C
    if(bCallPlayer)
    {
        GotoState('InCall');
    }
    goto 'Begin';
    stop;        
}

defaultproperties
{
    CallIntervals=2.0000000
    PlayerDistance=400.0000000
    bIgnoreStepAside=true
}