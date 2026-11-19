class SPGorgonAIController extends SPAIController
    native;

/** Constants MACROS struct DECLARATIONS VARIABLE DECLARATIONS */
var() bool bNoAttack;
var bool bDoingBloodTicks;
var Vector escapeVector;

// Export USPGorgonAIController::execIsFriendly(FFrame&, void* const)
native function bool IsFriendly(Controller checkPlayer);

function EnableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    // End:0x21
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    super.EnableAI(bDontResetPhysics, bDontResetSceneAnims);
    //return;    
}

function SoftEnableAI()
{
    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    super.SoftEnableAI();
    //return;    
}

function NotifyDying()
{
    // End:0x22
    if(!IsInState('ControllerDying'))
    {
        PushState('ControllerDying');
    }
    //return;    
}

function EvaluateSituation()
{
    // End:0x15
    if(m_bAIDisabled)
    {
        SoftDisableAI();
        return;
    }
    // End:0x94
    if(!bNoAttack && (CheckForEnemy()) || HasValidEnemy())
    {
        // End:0x7B
        if(!EnemyRecentlyVisible(true) && ShouldIPursueEnemy())
        {
            GotoState('PursueEnemy', 'Begin', true, false);            
        }
        else
        {
            GotoState('Attack', 'Begin', true, false);
        }        
    }
    else
    {
        GotoState('Idle', 'Begin', true, false);
    }
    //return;    
}

function StartFire()
{
    SetTimer(2.0000000, true, 'FireJavelin');
    SetTimer(9.0000000, true, 'FireTicks');
    //return;    
}

function StopFire()
{
    ClearTimer('FireJavelin');
    ClearTimer('FireTicks');
    SPGorgonPawnPersistent(Pawn).Disarm();
    //return;    
}

function FireJavelin2()
{
    // End:0x57
    if(SPGorgonPawnPersistent(Pawn).IsJavelinReady())
    {
        SPGorgonPawnPersistent(Pawn).FireJavelin(GetEnemy());
        bDoingBloodTicks = false;
        ClearTimer('FireJavelin2');
    }
    //return;    
}

function FireJavelin()
{
    // End:0x0B
    if(bDoingBloodTicks)
    {
        return;
    }
    SPGorgonPawnPersistent(Pawn).ArmJavelin();
    SetTimer(0.1250000, true, 'FireJavelin2');
    //return;    
}

function FireTicks2()
{
    // End:0x59
    if(SPGorgonPawnPersistent(Pawn).IsBloodTickReady())
    {
        SPGorgonPawnPersistent(Pawn).FireBloodTicks(GetEnemy(), 10);
        bDoingBloodTicks = false;
        ClearTimer('FireTicks2');
    }
    //return;    
}

function FireTicks()
{
    SPGorgonPawnPersistent(Pawn).ArmBloodTicks();
    SetTimer(0.1250000, true, 'FireTicks2');
    //return;    
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        Focus = none;
        Target = none;
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x1C
        if(CheckForEnemy(true))
        {
            EvaluateSituation();
        }
        //return;        
    }

    function OnHearEnemy(int PlayerIdx)
    {
        super(SPAIController).OnHearEnemy(PlayerIdx);
        //return;        
    }
    stop;    
}

state Attack
{
    function BeginState(name PreviousStateName)
    {
        StartFire();
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        StartFire();
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x16
        if(bNewEnemy)
        {
            AcquireEnemy(PlayerIdx);
        }
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState('MoveToGoalAttack');
        //return;        
    }
Begin:

    Sleep(0.1000000);
    // End:0x24
    if(!HasValidEnemy())
    {
        EvaluateSituation();
    }
    Focus = GetEnemy();
    SetPawnRotationRate(65536, 65536, 65536);
    FireJavelin();
    J0x53:

    // End:0x110 [Loop If]
    if(true)
    {
        // End:0xBE
        if(VSize(Pawn.Location - GetEnemy().Location) > float(1200))
        {
            SetMoveGoal(GetEnemy(), 1, GetEnemy().Location, 0);            
        }
        else
        {
            FinishRotation();
        }
        // End:0x105
        if(!HasValidEnemy() || (GetEnemy()) == none)
        {
            StopFire();
            GotoState('Idle', 'Begin', true, false);
        }
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x53;
    }
    stop;                
}

state MoveToGoalAttack extends MoveToGoal
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        // End:0x3A
        if(VSize(Pawn.Location - GetEnemy().Location) < float(650))
        {
            PopState();
        }
        //return;        
    }
    stop;    
}

state ControllerDying
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function NotifyDied()
    {
        PopState();
        GotoState('WaitingForTheInevitable');
        //return;        
    }
Begin:

    stop;                
}

state WaitingForTheInevitable
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }
    stop;    
}
