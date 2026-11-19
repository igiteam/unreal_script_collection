class SPKrakenAIController extends SPAIController
    native;

/** Constants MACROS struct DECLARATIONS VARIABLE DECLARATIONSvar SPGameDifficultyTuneKrakenm_KrakenGDTuneData;var SPTuneDataKraken m_KrakenTuneData; */
var() bool bNoAttack;
var bool m_bAttacking;
var SPKrakenPawnPersistent m_KrakenPawn;

// Export USPKrakenAIController::execSearchForTargets(FFrame&, void* const)
native function SearchForTargets();

// Export USPKrakenAIController::execIsValidEnemyController(FFrame&, void* const)
native function bool IsValidEnemyController(Controller chkController, optional bool bNoListCheck, optional bool bNoPreferredSquadCheck);

// Export USPKrakenAIController::execGetBestEnemy(FFrame&, void* const)
native function Pawn GetBestEnemy(array<EnemyListInfo> enemyList, float MaxDistance, bool bTestOnly, out int outBestEnemyIdx, out float outBestEnemyDist);

// Export USPKrakenAIController::execGetBestTarget(FFrame&, void* const)
native function int GetBestTarget();

simulated event PostBeginPlay()
{
    super(Controller).PostBeginPlay();
    //return;    
}

function StartAction(SPKrakenPawnPersistent.eKrakenActionState actionState, optional bool Reset)
{
    m_KrakenPawn.m_actionState = actionState;
    // End:0x31
    if(Reset)
    {
        m_KrakenPawn.m_bResetAction = true;
    }
    //return;    
}

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

function EvaluateSituation()
{
    // End:0x15
    if(m_bAIDisabled)
    {
        SoftDisableAI();
        return;
    }
    //return;    
}

function int DetermineEnemy()
{
    return DecideTarget();
    //return ReturnValue;    
}

function int DecideTarget()
{
    local int targetID;

    SearchForTargets();
    targetID = GetBestTarget();
    // End:0x2F
    if(targetID > -1)
    {
        return targetID;
    }
    return -1;
    //return ReturnValue;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        // End:0x1B
        if(m_KrakenPawn == none)
        {
            m_KrakenPawn = SPKrakenPawnPersistent(NewPawn);
        }
        super.Possess(NewPawn, bVehicleTransition);
        SetPawnRotationRate(0, 0, 0);
        //return;        
    }
    stop;    
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }
Begin:

    stop;                
}

state Attack
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }
Begin:

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
