class SPBloodTickAIController extends SPAIController
    native;

/** Constants MACROS struct DECLARATIONS VARIABLE DECLARATIONS */
var() bool bNoAttack;
var bool bSelfDestruct;
var bool m_bJumpAttack;
var bool m_bSacInflating;
var bool m_bJumpAttackOverride;
var SPBloodTickPawnPersistent m_BloodTickPawn;
var Controller PreferedEnemy;
var ParticleSystem ExplodeParticleTemplate;
var float PreferedEnemyTimeOut;
var float StartJumpRange;
var Vector LastVelocity;
var Vector LastAcceleration;
var transient float Range;
var float m_JumpPercentage;
var Rotator m_bloodTickViewRotation;
var float m_RandomSpeedRange;
var SPTuneDataBloodTick m_BloodTickTuneData;
var SPGameDifficultyTuneBloodTick m_BloodTickGDTuneData;

// Export USPBloodTickAIController::execIsFriendly(FFrame&, void* const)
native function bool IsFriendly(Controller checkPlayer);

// Export USPBloodTickAIController::execRateEnemy(FFrame&, void* const)
native function float RateEnemy(Controller InPlayer);

// Export USPBloodTickAIController::execIsValidEnemyController(FFrame&, void* const)
native function bool IsValidEnemyController(Controller chkController, optional bool bNoListCheck, optional bool bNoPreferredSquadCheck);

simulated event SPGameDifficultyTuneBloodTick GetBloodTickDifficultyData()
{
    // End:0x20
    if(m_BloodTickGDTuneData == none)
    {
        m_BloodTickGDTuneData = SPGameDifficultyTuneBloodTick(GetMyGDData());
    }
    return m_BloodTickGDTuneData;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.BloodTickGD;
    //return ReturnValue;    
}

simulated event PreBeginPlay()
{
    super(AIController).PreBeginPlay();
    GetBloodTickDifficultyData();
    //return;    
}

function StartAction(SPBloodTickPawnPersistent.eBloodTickActionState actionState, optional bool Reset)
{
    m_BloodTickPawn.m_actionState = actionState;
    // End:0x31
    if(Reset)
    {
        m_BloodTickPawn.m_bResetAction = true;
    }
    //return;    
}

function StartUpperBodyAction(SPBloodTickPawnPersistent.eBloodTickSacInflateState sacActionState, optional bool Reset)
{
    m_BloodTickPawn.m_sacInflateState = sacActionState;
    // End:0x31
    if(Reset)
    {
        m_BloodTickPawn.m_bResetAction = true;
    }
    //return;    
}

function SetPreferedEnemyNone()
{
    PreferedEnemy = none;
    PreferedEnemyTimeOut = 0.0000000;
    ClearTimer('SetPreferedEnemyNone');
    //return;    
}

function SetPreferedEnemy(Controller NewPreferedEnemy)
{
    // End:0x18
    if(NewPreferedEnemy == none)
    {
        SetPreferedEnemyNone();        
    }
    else
    {
        SetPreferedEnemyForTime(NewPreferedEnemy, 10.0000000);
    }
    //return;    
}

function SetPreferedEnemyForTime(Controller NewPreferedEnemy, float NewPreferedEnemyTimeOut)
{
    // End:0x18
    if(NewPreferedEnemy == none)
    {
        SetPreferedEnemyNone();        
    }
    else
    {
        PreferedEnemy = NewPreferedEnemy;
        PreferedEnemyTimeOut = NewPreferedEnemyTimeOut;
        SetTimer(PreferedEnemyTimeOut, false, 'SetPreferedEnemyNone');
        // End:0x6F
        if(PreferedEnemy.Pawn != none)
        {
            SeePlayer(PreferedEnemy.Pawn);
        }
    }
    //return;    
}

function bool ShouldIGotoDefendArea(optional bool bInIdleState)
{
    // End:0x20
    if((Pawn == none) || IsActorInDefendArea(Pawn))
    {
        return false;
    }
    // End:0x2D
    if(!bInIdleState)
    {
        return false;
    }
    // End:0x3D
    if(PickDefendAreaDestination(true))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function TransitionToDefendArea()
{
    // End:0x11
    if(m_defendAreaKyVertID == -1)
    {
        return;
    }
    GotoState('GotoDefendAreaDestination');
    //return;    
}

event GorgonDestroyed()
{
    local float DestructTime;

    SetPreferedEnemyNone();
    DestructTime = FRand() * 0.2500000;
    // End:0x68
    if(DestructTime < (GetTimerRate('SelfDestruct') - GetTimerCount('SelfDestruct')))
    {
        ClearTimer('SelfDestruct');
        SetTimer(DestructTime, false, 'SelfDestruct');
    }
    //return;    
}

function SelfDestruct(optional float Time)
{
    SPBloodTickPawnPersistent(Pawn).TriggerDestruction();
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

function NotifyDying()
{
    // End:0x20
    if(!IsInState('ControllerDying'))
    {
        GotoState('ControllerDying');
    }
    //return;    
}

function EvaluateSituation()
{
    // End:0x30
    if(!bSelfDestruct)
    {
        SetTimer(m_BloodTickGDTuneData.GlobalExplodeTime, false, 'SelfDestruct');
        bSelfDestruct = true;
    }
    // End:0x45
    if(m_bAIDisabled)
    {
        SoftDisableAI();
        return;
    }
    // End:0xB4
    if(!bNoAttack && ((CheckForEnemy(,, m_BloodTickGDTuneData.AttackDistance)) && IsValidEnemyPawn(GetEnemy())) || HasValidEnemy())
    {
        GotoState('Attack', 'Begin', true, false);        
    }
    else
    {
        GotoState('Idle', 'Begin', true, false);
    }
    //return;    
}

function CheckJumpAttack()
{
    //return;    
}

function TimerToEndJumpSting()
{
    EvaluateSituation();
    //return;    
}

function TimerToEnableJumpAttackCheck()
{
    m_bJumpAttackOverride = false;
    CheckJumpAttack();
    //return;    
}

function TimerToExplode()
{
    SelfDestruct();
    //return;    
}

function TimerToExplodeFromPawn()
{
    SetTimer(2.0000000, false, 'TimerToExplode');
    //return;    
}

function TimerToReEnable()
{
    m_BloodTickPawn.m_bStingingDone = true;
    //return;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        // End:0x1B
        if(m_BloodTickPawn == none)
        {
            m_BloodTickPawn = SPBloodTickPawnPersistent(NewPawn);
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
        ClearEnemy();
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x2A
        if(CheckForEnemy(true, m_BloodTickGDTuneData.AttackDistance))
        {
            EvaluateSituation();
        }
        //return;        
    }

    function OnHearEnemy(int PlayerIdx)
    {
        // End:0x2A
        if(CheckForEnemy(true, m_BloodTickGDTuneData.AttackDistance))
        {
            EvaluateSituation();
        }
        //return;        
    }
IdleLoop:

    // End:0x2D
    if(CheckForEnemy(true, m_BloodTickGDTuneData.AttackDistance))
    {
        EvaluateSituation();        
    }
    else
    {
        // End:0x45
        if(ShouldIGotoDefendArea(true))
        {
            TransitionToDefendArea();
        }
    }
    Sleep(RandRange(0.2500000, 0.5000000));
    goto 'IdleLoop';
    stop;        
}

state Attack
{
    function BeginState(name PreviousStateName)
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

    function OnHearEnemy(int PlayerIdx)
    {
        super(SPAIController).OnHearEnemy(PlayerIdx);
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState('KyMoveTowardEnemy');
        //return;        
    }

    function CheckJumpAttack()
    {
        // End:0x3B
        if(!m_bJumpAttackOverride)
        {
            // End:0x30
            if(float(Rand(100)) < m_BloodTickGDTuneData.JumpAttackPercentage)
            {
                m_bJumpAttack = true;                
            }
            else
            {
                m_bJumpAttack = false;
            }            
        }
        else
        {
            m_bJumpAttack = false;
        }
        //return;        
    }
Begin:

    CheckJumpAttack();
    J0x0A:

    // End:0x121 [Loop If]
    if(true)
    {
        Range = VSize(Pawn.Location - GetEnemy().Location);
        // End:0xDA
        if((Range > m_BloodTickGDTuneData.JumpAttackDistance) || !m_bJumpAttack)
        {
            // End:0x93
            if(Range < m_BloodTickGDTuneData.StingDistance)
            {
                GotoState('StingAttack', 'Begin', true, false);                
            }
            else
            {
                SetMoveGoal(GetEnemy(), 1, GetEnemy().Location, 0);
                // End:0xD7
                if(m_bMoveAborted)
                {
                    EvaluateSituation();
                }
            }            
        }
        else
        {
            GotoState('JumpAttack', 'Begin', true, false);
        }
        // End:0x116
        if((GetEnemy()) == none)
        {
            GotoState('Idle', 'Begin', true, false);
        }
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x0A;
    }
    stop;            
}

state JumpAttack
{
    function BeginState(name PreviousStateName)
    {
        local Vector Dest;
        local int NumSolutions;
        local Vector InitVelocity1, InitVelocity2;
        local float FlightTime1, FlightTime2, Height;

        Height = (FRand() * float(130 - 50)) + float(100);
        Dest = GetEnemy().Location;
        Dest.Z += Height;
        m_BloodTickPawn.CleanUpPhysSpider(true);
        NumSolutions = SPPawn(Pawn).CalcTrajInitVelGivenSpeed(Pawn.Location, Dest, -9.8000000 * float(100), 1000.0000000, InitVelocity1, FlightTime1, InitVelocity2, FlightTime2);
        // End:0xFC
        if(NumSolutions > 0)
        {
            Pawn.SetPhysics(2);
            Pawn.Velocity = InitVelocity1;
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);            
        }
        else
        {
            Pawn.SetPhysics(2);
            Pawn.SuggestJumpVelocity(Pawn.Velocity, Dest, Pawn.Location);
            Pawn.Velocity.Z = Pawn.JumpZ;
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        SetTimer(2.0000000, false, 'TimerToEndJumpSting');
        //return;        
    }
    J0x00:
    // End:0xA6 [Loop If]
    if(VSizeSq(Pawn.Location - GetEnemy().Location) > (m_BloodTickGDTuneData.StingDistance * m_BloodTickGDTuneData.StingDistance))
    {
        // End:0x9B
        if(VSizeSq(Pawn.Velocity) <= (10.0000000 * 10.0000000))
        {
            m_bJumpAttackOverride = true;
            SetTimer(3.0000000, false, 'TimerToEnableJumpAttackCheck');
            EvaluateSituation();
        }
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x00;
    }
    GotoState('StingAttack', 'Begin', true, false);
    stop;                
}

state StingAttack
{
    function BeginState(name PreviousStateName)
    {
        m_BloodTickPawn.m_bStingAttack = false;
        m_BloodTickPawn.m_bStingingDone = false;
        SetTimer(1.0000000, false, 'TimerToReEnable');
        //return;        
    }
Begin:

    // End:0x110
    if((GetEnemy()) != none)
    {
        // End:0x9C
        if(GetEnemy().IsA('PlayerPawn') == true)
        {
            GetEnemy().TakeDamageAndProcEffects(m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.StingDamageVSPlayer), none, GetEnemy().Location, vect(0.0000000, 0.0000000, 0.0000000), Class'SPDamageTypePoison',, Pawn);            
        }
        else
        {
            GetEnemy().TakeDamageAndProcEffects(m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.StingDamageVSAI), none, GetEnemy().Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PandoraDamageType',, Pawn);
        }
        SelfDestruct();
    }
    // End:0x12F
    if(!m_BloodTickPawn.m_bStingAttack)
    {
        EvaluateSituation();
    }
    StartAction(1);
    J0x13C:

    // End:0x15C [Loop If]
    if(!m_BloodTickPawn.m_bStingingDone)
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x13C;
    }
    EvaluateSituation();
    stop;        
}

state KyMoveTowardEnemy extends KyMoveToGoal
{
    function MoveToGoalTimerUpdate()
    {
        // End:0x1FA
        if((HasValidEnemy()) && (GetEnemy()) != none)
        {
            // End:0x67
            if(int(m_BloodTickPawn.Physics) != int(8))
            {
                m_bloodTickViewRotation = Rotator(Normal(Pawn.Velocity));
                Pawn.SetRotation(m_bloodTickViewRotation);
            }
            Range = VSize(Pawn.Location - GetEnemy().Location);
            // End:0xE0
            if((Range < (m_BloodTickGDTuneData.JumpAttackDistance + m_BloodTickGDTuneData.SacInflateDistance)) && !m_bSacInflating)
            {
                StartUpperBodyAction(1);
                m_bSacInflating = true;
            }
            // End:0x1F7
            if((int(m_BloodTickPawn.Physics) != int(8)) || ((m_BloodTickPawn.m_wallMovementData.ReachSpec != none) && m_BloodTickPawn.m_wallMovementData.wallAnimData != none) && int(m_BloodTickPawn.m_wallMovementData.wallAnimData.LocomotionType) == int(0))
            {
                // End:0x1F7
                if(Range < (m_BloodTickGDTuneData.JumpAttackDistance - (m_BloodTickGDTuneData.JumpAttackDistance * 0.2000000)))
                {
                    // End:0x1B9
                    if(m_bJumpAttack)
                    {
                        AbortMove(false, false, true);                        
                    }
                    else
                    {
                        // End:0x1F7
                        if(Range < (m_BloodTickGDTuneData.StingDistance - (m_BloodTickGDTuneData.StingDistance * 0.2000000)))
                        {
                            AbortMove(false, false, true);
                        }
                    }
                }
            }            
        }
        else
        {
            SetEnemy(none);
            AbortMove(false, false, true);
        }
        //return;        
    }
    stop;    
}

state MoveToDefendAreaDestination extends KyMoveToGoal
{
    function SetDefendAreaSquadCommand(SPSquad.ESPSquadCommands squadCommand, SquadCommandDefendArea_Params Param)
    {
        // End:0x30
        if(!IsSameDefendAreaCommand(squadCommand, Param))
        {
            super(SPAIController).SetDefendAreaSquadCommand(squadCommand, Param);
            PopState();
        }
        //return;        
    }

    function ClearDefendAreaSquadCommand()
    {
        local bool bWasDefendingArea;

        bWasDefendingArea = IsDefendingArea();
        super(SPAIController).ClearDefendAreaSquadCommand();
        // End:0x23
        if(bWasDefendingArea)
        {
            PopState();
        }
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        // End:0x54
        if((int(m_squadCommandPriority) <= int(1)) && !IsActorInDefendArea(Pawn))
        {
            // End:0x51
            if((HasValidEnemy()) || CheckForEnemy())
            {
                PopState();
                return;
            }            
        }
        else
        {
            // End:0x91
            if(IsActorInDefendArea(Pawn))
            {
                // End:0x91
                if((HasValidEnemy()) || CheckForEnemy())
                {
                    PopState();
                    return;
                }
            }
        }
        super(SPAIController).MoveToGoalTimerUpdate();
        //return;        
    }
    stop;    
}

state GotoDefendAreaDestination
{
    function GotoMoveToGoalState()
    {
        PushState('MoveToDefendAreaDestination');
        //return;        
    }
Begin:

    // End:0x19
    if(m_defendAreaKyVertID == -1)
    {
        EvaluateSituation();
    }
    SetMoveGoal(none, 0, m_defendAreaPosition, 2, false);
    // End:0x56
    if((Pawn != none) && IsActorInDefendArea(Pawn))
    {
        SetHasBeenInDefendArea(true);
    }
    Sleep(0.1000000);
    EvaluateSituation();
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
