class SPNariAIController extends SPAIController
    native;

enum ENariGroupAttackTypes
{
    enNone,                         // 0
    enGroupMelee,                   // 1
    enMassMelee,                    // 2
    enGroupSonic,                   // 3
    enGroupPoltergeist,             // 4
    enLGPoltergeist,                // 5
    ENariGroupAttackTypes_MAX       // 6
};

var SPTuneDataNari m_NariTuneData;
var SPGameDifficultyTuneNari m_NariGDTuneData;
var float m_fDirectMoveSpeed;
var bool m_bAllowIdleBuzz;
var bool m_bBelowEnemy;
var bool m_bHitTimeOut;
var bool m_bIsSquadLeader;
var bool m_bAllowAttack;
var bool m_bFinishedAttack;
var bool m_bForceAttack;
var bool m_bAllowSuperAttack;
var bool m_bDirectMoveBump;
var bool m_bWasBumped;
var bool m_bKismetCommand;
var int m_safe;
var Vector m_vHarassmentStartPoint;
var float m_fAttackType;
var SPNariAIController.ENariGroupAttackTypes m_eGroupAttackType;
var SPNariAIController.ENariGroupAttackTypes m_eSavedGroupAttackType;
var Vector m_vMySavedLocation;
var Vector m_vAttackRunStart;
var Vector m_vDirectMoveGoal;
var SPEmitter SonicEmitter;
var SPSonicAttackVolume m_buffetVolume;
var Actor m_PoltergeistTarget;
var() Actor m_PossessObject;
var SPNariPawnPersistent myPawn;

// Export USPNariAIController::execDoSonicAttack(FFrame&, void* const)
native function bool DoSonicAttack();

// Export USPNariAIController::execCanGoSolid(FFrame&, void* const)
native function bool CanGoSolid();

// Export USPNariAIController::execStartSonicAttack(FFrame&, void* const)
native final function StartSonicAttack();

// Export USPNariAIController::execStopSonicAttack(FFrame&, void* const)
native final function StopSonicAttack();

// Export USPNariAIController::execGetAttackRunStartVector(FFrame&, void* const)
native function Vector GetAttackRunStartVector();

// Export USPNariAIController::execGetAttackRunMidpathVector(FFrame&, void* const)
native function Vector GetAttackRunMidpathVector();

// Export USPNariAIController::execGetAttackRunEndVector(FFrame&, void* const)
native function Vector GetAttackRunEndVector();

// Export USPNariAIController::execFindPoltergeistObject(FFrame&, void* const)
native function bool FindPoltergeistObject(Actor pTarget, Actor pPossessObject);

// Export USPNariAIController::execFindLGPoltergeistObject(FFrame&, void* const)
native function bool FindLGPoltergeistObject(Actor pTarget, Actor pPossessObject);

function ResetPawn()
{
    //return;    
}

function SoftDisableAI()
{
    super.SoftDisableAI();
    //return;    
}

function EnableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    super.EnableAI(bDontResetPhysics, bDontResetSceneAnims);
    GotoState('Idle');
    //return;    
}

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].Nari;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.NariGD;
    //return ReturnValue;    
}

simulated event PreBeginPlay()
{
    super(AIController).PreBeginPlay();
    m_NariTuneData = SPTuneDataNari(GetMyTuneData());
    m_NariGDTuneData = SPGameDifficultyTuneNari(GetMyGDData());
    //return;    
}

simulated event PostBeginPlay()
{
    super(Controller).PostBeginPlay();
    //return;    
}

function StartCATAttack(SPPawn defender, CATAnimInfo AnimInfo)
{
    ClearKynapseAgent();
    SetEnemy(defender);
    myPawn.TransitionToSolid();
    super.StartCATAttack(defender, AnimInfo);
    //return;    
}

simulated function OnToggleAI(SeqAct_ToggleAI Action)
{
    local int Idx;

    // End:0x98
    if(m_squad.m_members.Length > 1)
    {
        Idx = 0;
        J0x1D:

        // End:0x98 [Loop If]
        if(Idx < m_squad.m_members.Length)
        {
            // End:0x8E
            if(m_squad.m_members[Idx] != Pawn.Controller)
            {
                SPNariAIController(m_squad.m_members[Idx]).NariToggleAI(Action);
            }
            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    NariToggleAI(Action);
    //return;    
}

function NariToggleAI(SeqAct_ToggleAI Action)
{
    OnToggleAI(Action);
    //return;    
}

function OnAIForceTarget(SeqAct_AIForceTarget Action)
{
    local array<Object> objVars;

    Action.GetObjectVars(objVars, "Thing To Target");
    // End:0x77
    if(objVars.Length > 0)
    {
        // End:0x77
        if(Pawn.DoesObjectHaveOATSTag(Actor(objVars[0]), 7))
        {
            m_PossessObject = Actor(objVars[0]);
            PushState('Poltergeist');
            return;
        }
    }
    super.OnAIForceTarget(Action);
    //return;    
}

function OnAIMoveToActor(SeqAct_AIMoveToActor inAction)
{
    local int Idx;

    // End:0x98
    if(m_squad.m_members.Length > 1)
    {
        Idx = 0;
        J0x1D:

        // End:0x98 [Loop If]
        if(Idx < m_squad.m_members.Length)
        {
            // End:0x8E
            if(m_squad.m_members[Idx] != Pawn.Controller)
            {
                SPNariAIController(m_squad.m_members[Idx]).OnAIMoveToActorSlave(inAction);
            }
            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    OnAIMoveToActorSlave(inAction);
    //return;    
}

function OnAIMoveToActorSlave(SeqAct_AIMoveToActor inAction)
{
    ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', true, inAction);
    myPawn.SetGhost();
    ClearTimer();
    myPawn.ClearTimer();
    OnAIMoveToActor(inAction);
    //return;    
}

function float GetAttackPercent()
{
    local float Value;

    switch(m_squad.m_members.Length)
    {
        // End:0x30
        case 5:
            Value = m_NariGDTuneData.AttackPercent5;
            // End:0xBE
            break;
        // End:0x4D
        case 4:
            Value = m_NariGDTuneData.AttackPercent4;
            // End:0xBE
            break;
        // End:0x6A
        case 3:
            Value = m_NariGDTuneData.AttackPercent3;
            // End:0xBE
            break;
        // End:0x87
        case 2:
            Value = m_NariGDTuneData.AttackPercent2;
            // End:0xBE
            break;
        // End:0xA3
        case 1:
            Value = m_NariGDTuneData.AttackPercent1;
            // End:0xBE
            break;
        // End:0xFFFF
        default:
            Value = m_NariGDTuneData.AttackPercent5;
            // End:0xBE
            break;
            break;
    }
    return Value;
    //return ReturnValue;    
}

function EvaluateSituation()
{
    local Pawn pEnemyPawn;

    // End:0x15
    if(m_bAIDisabled)
    {
        SoftDisableAI();
        return;
    }
    // End:0x59
    if(!(CheckForEnemy(false, Pawn.SightRadius)) || HasValidEnemy(,,, false))
    {
        GotoState('Idle');
        return;
    }
    pEnemyPawn = GetEnemy();
    SPSquadNari(m_squad).m_squadEnemy = pEnemyPawn;
    m_vHarassmentStartPoint = Pawn.Location;
    m_eGroupAttackType = 0;
    // End:0x518
    if(m_bAllowAttack && FRand() < (GetAttackPercent()))
    {
        SetTimer(m_NariGDTuneData.NextAttackTimeDelay,, 'AttackTimer');
        m_bAllowAttack = false;
        m_fAttackType = FRand();
        // End:0x172
        if(((m_squad.m_members.Length > 3) && m_NariGDTuneData.AllowGroupPoltergiest) && FRand() < m_NariGDTuneData.GetValue(m_NariGDTuneData.LGPoltergeistAttackChance))
        {
            // End:0x172
            if(FindLGPoltergeistObject(pEnemyPawn, m_PossessObject))
            {
                m_eGroupAttackType = 5;
                PushState('Poltergeist');
                return;
            }
        }
        m_fAttackType -= m_NariGDTuneData.GetValue(m_NariGDTuneData.PoltergeistAttackChance);
        // End:0x204
        if(((FindPoltergeistObject(pEnemyPawn, m_PossessObject)) && m_NariGDTuneData.AllowPoltergiest) && m_fAttackType < float(0))
        {
            // End:0x1F2
            if(m_NariGDTuneData.AllowGroupPoltergiest)
            {
                m_eGroupAttackType = 4;
            }
            PushState('Poltergeist');
            return;
        }
        m_fAttackType = FRand();
        m_fAttackType -= m_NariGDTuneData.GetValue(m_NariGDTuneData.MeleeAttackChance);
        // End:0x3A8
        if((m_fAttackType < float(0)) && (m_NariGDTuneData.AllowSingleMelee || m_NariGDTuneData.AllowGroupMelee) || m_NariGDTuneData.AllowGroupMelee)
        {
            m_fAttackType = FRand();
            // End:0x2E3
            if(((m_fAttackType -= m_NariGDTuneData.GetValue(m_NariGDTuneData.SingleMeleeAttackChance)) < float(0)) && m_NariGDTuneData.AllowSingleMelee)
            {
                PushState('ClawSwipeAttack');
                return;
            }
            // End:0x344
            if(((m_fAttackType -= m_NariGDTuneData.GetValue(m_NariGDTuneData.GroupMeleeAttackChance)) < float(0)) && m_NariGDTuneData.AllowGroupMelee)
            {
                m_eGroupAttackType = 1;
                PushState('ClawSwipeAttack');
                return;
            }
            // End:0x3A5
            if(((m_fAttackType -= m_NariGDTuneData.GetValue(m_NariGDTuneData.MassMeleeAttackChance)) < float(0)) && m_NariGDTuneData.AllowGroupMelee)
            {
                m_eGroupAttackType = 2;
                PushState('ClawSwipeAttack');
                return;
            }            
        }
        else
        {
            // End:0x503
            if((m_fAttackType -= m_NariGDTuneData.GetValue(m_NariGDTuneData.SonicAttackChance)) < float(0))
            {
                m_fAttackType = FRand();
                // End:0x43E
                if(((m_fAttackType -= m_NariGDTuneData.GetValue(m_NariGDTuneData.SingleSonicAttackChance)) < float(0)) && m_NariGDTuneData.AllowSingleSonic)
                {
                    PushState('SonicBlastAttack');
                    return;                    
                }
                else
                {
                    // End:0x4A2
                    if(((m_fAttackType -= m_NariGDTuneData.GetValue(m_NariGDTuneData.DualSonicMeleeAttackChance)) < float(0)) && m_NariGDTuneData.AllowDualSonicMelee)
                    {
                        m_eGroupAttackType = 1;
                        PushState('SonicBlastAttack');
                        return;                        
                    }
                    else
                    {
                        // End:0x503
                        if(((m_fAttackType -= m_NariGDTuneData.GetValue(m_NariGDTuneData.GroupSonicAttackChance)) < float(0)) && m_NariGDTuneData.AllowGroupSonic)
                        {
                            m_eGroupAttackType = 3;
                            PushState('SonicBlastAttack');
                            return;
                        }
                    }
                }
            }
        }
        PushState('Taunt');
        return;        
    }
    else
    {
        PushState('Taunt');
    }
    //return;    
}

function StartParticleSonic()
{
    local Vector pos;
    local Rotator Rot;

    // End:0x15D
    if(Pawn.Mesh.GetSocketWorldLocationAndRotation('sonic', pos, Rot))
    {
        // End:0x15D
        if(myPawn.SonicParticleTemplate != none)
        {
            // End:0x71
            if(SonicEmitter == none)
            {
                SonicEmitter = Spawn(Class'SPEmitterSpawnable',,, pos, Rot);
            }
            // End:0x15D
            if(SonicEmitter != none)
            {
                SonicEmitter.SetTemplate(myPawn.SonicParticleTemplate, true);
                SonicEmitter.bDestroyOnSystemFinish = false;
                SonicEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                SonicEmitter.ParticleSystemComponent.ActivateSystem();
                SonicEmitter.SetBase(Pawn, vect(0.0000000, 0.0000000, 1.0000000), Pawn.Mesh, 'JO_Root');
                SonicEmitter.bKillDuringLevelTransition = true;
                SonicEmitter.SetOwner(self);
                SonicEmitter.bKillDuringLevelTransition = true;
            }
        }
    }
    //return;    
}

function StopParticleSonic()
{
    // End:0x32
    if(SonicEmitter != none)
    {
        SonicEmitter.ParticleSystemComponent.DeactivateSystem();
        StopSonicAttack();
        SonicEmitter = none;
    }
    // End:0x94
    if(myPawn.m_SonicActor != none)
    {
        myPawn.m_SonicActor.StaticMeshComponent.SetHidden(true);
        myPawn.m_SonicActor.Destroy();
        myPawn.m_SonicActor = none;
    }
    //return;    
}

function RestartParticleSonic()
{
    // End:0x26
    if(SonicEmitter != none)
    {
        SonicEmitter.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

function CheckSquadLeader()
{
    local SPNariAIController leader;

    leader = SPSquadNari(m_squad).m_squadLeader;
    // End:0x3F
    if(leader == none)
    {
        SPSquadNari(m_squad).SetSquadLeader(self);
    }
    // End:0x5F
    if((leader == self) && !m_bIsSquadLeader)
    {
        m_bIsSquadLeader = true;
    }
    // End:0x72
    if(m_squad == none)
    {
        m_bIsSquadLeader = true;
    }
    // End:0x90
    if((leader != self) && m_bIsSquadLeader)
    {
        m_bIsSquadLeader = false;
    }
    //return;    
}

function AttackTimer()
{
    m_bAllowAttack = true;
    //return;    
}

function Vector StartMoving()
{
    local Vector NewSpot, TempStart;
    local float Temp;
    local Vector vPerp, vParal, temp1, temp2;
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    TempStart = pEnemyPawn.Location + (Vector(pEnemyPawn.Rotation) * m_NariGDTuneData.FlockingRange);
    // End:0xBF
    if(!IsTauntLocationValid(TempStart))
    {
        TempStart = pEnemyPawn.Location - (Vector(pEnemyPawn.Rotation) * m_NariGDTuneData.FlockingRange);
        // End:0xBF
        if(!IsTauntLocationValid(TempStart))
        {
            TempStart = Pawn.Location;
        }
    }
    m_vHarassmentStartPoint = TempStart;
    vPerp = Normal(pEnemyPawn.Location - m_vHarassmentStartPoint);
    vParal.X = vPerp.Y;
    vParal.Y = -vPerp.X;
    temp1 = m_vHarassmentStartPoint;
    temp2 = m_vHarassmentStartPoint;
    Temp = (FRand() * float(2)) - float(1);
    temp1 += ((vPerp * Temp) * m_NariGDTuneData.DepthFlockMax);
    Temp = (FRand() * float(2)) - float(1);
    temp2 += ((vParal * Temp) * m_NariGDTuneData.HorizontalFlockMax);
    NewSpot = temp2 - temp1;
    NewSpot.Y *= float(-1);
    NewSpot += m_vHarassmentStartPoint;
    Temp = (FRand() * float(2)) - float(1);
    // End:0x24B
    if(Temp > 0.0000000)
    {
        NewSpot.Z += float(Max(int(Temp * m_NariGDTuneData.VerticalFlockMax), int(m_NariGDTuneData.VerticalFlockMin)));        
    }
    else
    {
        NewSpot.Z += float(Min(int(Temp * m_NariGDTuneData.VerticalDownFlockMax), int(m_NariGDTuneData.VerticalDownFlockMin)));
        NewSpot.Z = float(Max(int(NewSpot.Z), int(pEnemyPawn.Location.Z - 50.0000000)));
    }
    NewSpot.Z = FClamp(NewSpot.Z, pEnemyPawn.Location.Z - m_NariGDTuneData.VerticalDownFlockMax, pEnemyPawn.Location.Z + m_NariGDTuneData.VerticalDownFlockMax);
    return NewSpot;
    //return ReturnValue;    
}

function Vector IdleBuzz(Vector StartPoint)
{
    local Vector BuzzGoal;

    BuzzGoal = StartPoint;
    BuzzGoal.X += (((FRand() * float(2)) - float(1)) * 0.0100000);
    BuzzGoal.Y += (((FRand() * float(2)) - float(1)) * 0.0100000);
    BuzzGoal.Z += (((FRand() * float(2)) - float(1)) * 0.0100000);
    return BuzzGoal;
    //return ReturnValue;    
}

function StopIdleBuzz()
{
    m_bAllowIdleBuzz = false;
    //return;    
}

function GoCombat()
{
    GotoState('RandomBuzzing');
    //return;    
}

event bool NotifyBump(Actor Other, Vector HitNormal)
{
    return true;
    //return ReturnValue;    
}

function DirectlyMovePawn(Vector Dest)
{
    local float l_magnitude;

    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    // End:0x24
    if(Dest == vect(0.0000000, 0.0000000, 0.0000000))
    {
    }
    Pawn.Acceleration = Normal(Dest - Pawn.Location) * FClamp(Pawn.AccelRate, 0.0000000, 2000.0000000);
    Pawn.DesiredSpeed = m_fDirectMoveSpeed;
    l_magnitude = VSize(Pawn.Velocity);
    // End:0x11C
    if((m_fDirectMoveSpeed - l_magnitude) > m_NariGDTuneData.DirectMoveFastAccelDeltaV)
    {
        Pawn.Velocity = Normal(Dest - Pawn.Location) * (l_magnitude + FClamp((m_fDirectMoveSpeed - l_magnitude) * 0.1000000, m_NariGDTuneData.DirectMoveMin, m_NariGDTuneData.DirectMoveMax));        
    }
    else
    {
        Pawn.Velocity = Normal(Dest - Pawn.Location) * (l_magnitude + FClamp((m_fDirectMoveSpeed - l_magnitude) * 0.0500000, 0.0000000, m_NariGDTuneData.DirectMoveMin));
    }
    // End:0x1B9
    if(VSize(Pawn.Velocity) > m_fDirectMoveSpeed)
    {
        Pawn.Velocity = Normal(Pawn.Velocity) * m_fDirectMoveSpeed;
    }
    l_magnitude = VSize(Dest - Pawn.Location);
    // End:0x234
    if((int(myPawn.m_PolterState) != int(1)) && l_magnitude < m_NariGDTuneData.DirectMoveSlowDownRange)
    {
        Pawn.Velocity = Normal(Pawn.Velocity) * 400.0000000;
    }
    //return;    
}

function DoAction()
{
    //return;    
}

function SetDirectMoveGoal(Vector Dest)
{
    m_vDirectMoveGoal = Dest;
    PushState('DirectMove');
    //return;    
}

event bool IsDirectMoveValid(Vector Dest, optional Vector Start)
{
    local Actor TempHitActor;
    local Vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local Vector theDest, theStart;

    // End:0x30
    if(Start == vect(0.0000000, 0.0000000, 0.0000000))
    {
        theStart = Pawn.Location;        
    }
    else
    {
        theStart = Start;
    }
    theDest = Dest - (Normal(Dest - theStart) * Pawn.GetCollisionExtent().X);
    TempHitActor = none;
    TempHitActor = Trace(HitLocation, HitNormal, theDest, theStart, true,, HitInfo, 10, true);
    // End:0xC4
    if((TempHitActor == none) || TempHitActor == (GetEnemy()))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function SPPawn CheckForCATAttack()
{
    local float distSQ;
    local Pawn pEnemyPawn;

    // End:0x1C
    if(int(Pawn.Physics) == int(8))
    {
        return none;
    }
    pEnemyPawn = GetEnemy();
    // End:0xB7
    if(pEnemyPawn != none)
    {
        distSQ = myPawn.DistanceBetweenCollisionSQ(pEnemyPawn);
        // End:0xB7
        if(distSQ < (m_NariGDTuneData.MaxCATRange * m_NariGDTuneData.MaxCATRange))
        {
            // End:0xB7
            if(myPawn.CATCheckForAttack(SPPawn(pEnemyPawn), myPawn.CATAnimationInfo))
            {
                return SPPawn(pEnemyPawn);
            }
        }
    }
    return none;
    //return ReturnValue;    
}

function ExitPossession(optional Vector HitLocation)
{
    // End:0x15B
    if(m_PoltergeistTarget != none)
    {
        m_PoltergeistTarget.UnclaimInteractionRights(Pawn);
        Pawn.SetHidden(false);
        Pawn.SetPhysics(0);
        m_PoltergeistTarget.SetPhysics(0);
        myPawn.CollisionComponent = myPawn.CylinderComponent;
        m_PoltergeistTarget.SetBase(none);
        m_PoltergeistTarget.SetCollision(true, true);
        m_PoltergeistTarget.bCollideWorld = true;
        m_PoltergeistTarget.SetPhysics(10);
        myPawn.RemovePoltergeistMaterial(m_PoltergeistTarget);
        myPawn.RestartParticleTrail();
        OffsetMoveNari(HitLocation);
        Pawn.SetPhysics(4);
        myPawn.m_PolterState = 0;
        m_PoltergeistTarget.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        m_PoltergeistTarget.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        m_PoltergeistTarget = none;
    }
    //return;    
}

// Export USPNariAIController::execOffsetMoveNari(FFrame&, void* const)
native function OffsetMoveNari(optional Vector HitLocation);

function bool IsTauntLocationValid(Vector Dest)
{
    local Actor TempHitActor;
    local Vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    TempHitActor = none;
    TempHitActor = Trace(HitLocation, HitNormal, pEnemyPawn.Location, Dest, true,, HitInfo, 10, true);
    // End:0x66
    if((TempHitActor == none) || TempHitActor == pEnemyPawn)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function StopPawn()
{
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.DesiredSpeed = 0.0000000;
    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    m_vDirectMoveGoal = vect(0.0000000, 0.0000000, 0.0000000);
    ClearKynapseAgent();
    // End:0xA2
    if(HasValidEnemy(,,, true))
    {
        Focus = GetEnemy();
        FocalPoint = GetEnemy().Location;
    }
    //return;    
}

function SPNariAIController GetNextSquadMember()
{
    local int Idx;

    // End:0xA7
    if(m_squad.m_members.Length > 1)
    {
        Idx = 0;
        J0x1D:

        // End:0xA7 [Loop If]
        if(Idx < m_squad.m_members.Length)
        {
            // End:0x9D
            if(m_squad.m_members[Idx] == Pawn.Controller)
            {
                // End:0x9B
                if(Idx < m_squad.m_members.Length)
                {
                    return SPNariAIController(m_squad.m_members[Idx + 1]);
                    // [Explicit Continue]
                    goto J0x9D;
                }
                return none;
            }
            J0x9D:

            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    return none;
    //return ReturnValue;    
}

function SetSquadHarassPoint()
{
    local int Idx;

    // End:0xA7
    if(m_squad.m_members.Length > 1)
    {
        Idx = 0;
        J0x1D:

        // End:0xA7 [Loop If]
        if(Idx < m_squad.m_members.Length)
        {
            // End:0x9D
            if(m_squad.m_members[Idx] != Pawn.Controller)
            {
                SPNariAIController(m_squad.m_members[Idx]).SetHarassPoint(m_vHarassmentStartPoint, GetEnemy(), Idx);
            }
            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    //return;    
}

function SetSquadTauntPoint()
{
    local int Idx;

    // End:0xD8
    if(m_squad.m_members.Length > 1)
    {
        Idx = 0;
        J0x1D:

        // End:0xD8 [Loop If]
        if(Idx < m_squad.m_members.Length)
        {
            // End:0xCE
            if(m_squad.m_members[Idx] != Pawn.Controller)
            {
                SPNariPawnPersistent(m_squad.m_members[Idx].Pawn).m_AttackState = 3;
                SPNariAIController(m_squad.m_members[Idx]).SetHarassPoint(m_vHarassmentStartPoint, GetEnemy(), Idx);
            }
            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    //return;    
}

function Vector FindMyHarassPoint(Vector Point, int Index)
{
    local Vector temp1, temp2, temp3;
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    switch(Index)
    {
        // End:0x25
        case 0:
            return Point;
            // End:0x303
            break;
        // End:0xDB
        case 1:
            temp1 = Normal(pEnemyPawn.Location - Pawn.Location);
            temp2.X = temp1.Y;
            temp2.Y = -temp1.X;
            temp3 = (Point + (temp2 * 300.0000000)) + (temp1 * 50.0000000);
            temp3.Z += float(150);
            return temp3;
            // End:0x303
            break;
        // End:0x192
        case 2:
            temp1 = Normal(pEnemyPawn.Location - Pawn.Location);
            temp2.X = temp1.Y;
            temp2.Y = -temp1.X;
            temp3 = (Point - (temp2 * 300.0000000)) - (temp1 * 50.0000000);
            temp3.Z -= float(150);
            return temp3;
            // End:0x303
            break;
        // End:0x249
        case 3:
            temp1 = Normal(pEnemyPawn.Location - Pawn.Location);
            temp2.X = temp1.Y;
            temp2.Y = -temp1.X;
            temp3 = (Point + (temp2 * 300.0000000)) - (temp1 * 50.0000000);
            temp3.Z += float(150);
            return temp3;
            // End:0x303
            break;
        // End:0x300
        case 4:
            temp1 = Normal(pEnemyPawn.Location - Pawn.Location);
            temp2.X = temp1.Y;
            temp2.Y = -temp1.X;
            temp3 = (Point - (temp2 * 300.0000000)) + (temp1 * 50.0000000);
            temp3.Z -= float(150);
            return temp3;
            // End:0x303
            break;
        // End:0xFFFF
        default:
            break;
    }
    return Point;
    //return ReturnValue;    
}

// Export USPNariAIController::execSetMyEnemy(FFrame&, void* const)
native function SetMyEnemy(Pawn MyEnemy);

function SetHarassPoint(Vector vHarass, Pawn MyEnemy, int squadIndex)
{
    SetMyEnemy(MyEnemy);
    m_vHarassmentStartPoint = vHarass;
    m_vDirectMoveGoal = FindMyHarassPoint(vHarass, squadIndex);
    //return;    
}

function Actor GetSquadTarget()
{
    local int Idx;

    // End:0xC0
    if(m_squad.m_members.Length > 1)
    {
        Idx = 0;
        J0x1D:

        // End:0xC0 [Loop If]
        if(Idx < m_squad.m_members.Length)
        {
            // End:0xB6
            if((m_squad.m_members[Idx] != Pawn.Controller) && SPNariAIController(m_squad.m_members[Idx]).HasValidEnemy(,,, true))
            {
                return m_squad.m_members[Idx].GetEnemy();
            }
            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    return none;
    //return ReturnValue;    
}

function SetSquadAttackRunPoint()
{
    local int Idx;

    // End:0xA2
    if(m_squad.m_members.Length > 1)
    {
        Idx = 0;
        J0x1D:

        // End:0xA2 [Loop If]
        if(Idx < m_squad.m_members.Length)
        {
            // End:0x98
            if(m_squad.m_members[Idx] != Pawn.Controller)
            {
                SPNariAIController(m_squad.m_members[Idx]).SetAttackRunPoint(m_vAttackRunStart, GetEnemy());
            }
            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    //return;    
}

function Vector GetSquadHarassPoint()
{
    local int Idx;

    // End:0xC7
    if(m_squad.m_members.Length > 1)
    {
        Idx = 0;
        J0x1D:

        // End:0xC7 [Loop If]
        if(Idx < m_squad.m_members.Length)
        {
            // End:0xBD
            if((m_squad.m_members[Idx] != Pawn.Controller) && SPNariAIController(m_squad.m_members[Idx]).m_vHarassmentStartPoint != vect(0.0000000, 0.0000000, 0.0000000))
            {
                return SPNariAIController(m_squad.m_members[Idx]).m_vHarassmentStartPoint;
            }
            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    return vect(0.0000000, 0.0000000, 0.0000000);
    //return ReturnValue;    
}

function TellNextSquadMateToAttack()
{
    local int Idx;

    // End:0x106
    if(m_squad.m_members.Length > 1)
    {
        Idx = 0;
        J0x1D:

        // End:0xFE [Loop If]
        if(Idx < m_squad.m_members.Length)
        {
            // End:0xF4
            if(m_squad.m_members[Idx] == Pawn.Controller)
            {
                // End:0xF4
                if((Idx + 1) < m_squad.m_members.Length)
                {
                    SPNariAIController(m_squad.m_members[Idx + 1]).SetAttackRunPoint(SPSquadNari(m_squad).m_vAttackRunLocation, GetEnemy());
                    SPNariAIController(m_squad.m_members[Idx + 1]).m_eGroupAttackType = m_eSavedGroupAttackType;
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
        m_eSavedGroupAttackType = 0;
    }
    //return;    
}

function SetAttackRunPoint(Vector vAttackRun, Pawn MyEnemy)
{
    SetEnemy(MyEnemy);
    m_vAttackRunStart = vAttackRun;
    //return;    
}

function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    // End:0x16
    if(m_PoltergeistTarget != none)
    {
        ExitPossession();
    }
    super.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0xA1
    if(((Pawn != none) && Damage > 0) && Pawn.Health > 0)
    {
        // End:0x77
        if(IsInState('TakeHit'))
        {            
        }
        else
        {
            PushState('TakeHit');
            Pawn.PushState('TakeHit');
        }
    }
    //return;    
}

function NotifyDying()
{
    // End:0x17
    if(IsInState('TakeHit'))
    {
        PopState();
    }
    // End:0x39
    if(!IsInState('ControllerDying'))
    {
        PushState('ControllerDying');
    }
    //return;    
}

state DirectMoveGoal
{Begin:

    m_fDirectMoveSpeed = m_NariGDTuneData.PursueSpeed;
    J0x15:

    // End:0x6F [Loop If]
    if(VSize(m_vDirectMoveGoal - Pawn.Location) > 50.0000000)
    {
        // End:0x55
        if(m_vDirectMoveGoal == vect(0.0000000, 0.0000000, 0.0000000))
        {
            PopState();
        }
        DirectlyMovePawn(m_vDirectMoveGoal);
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x15;
    }
    StopPawn();
    PopState();
    stop;                
}

state KismetMoveToActor
{
    function GotoMoveToGoalState()
    {
        PushState('KyMoveToGoalNari');
        //return;        
    }

    function ContinuedState()
    {
        super.ContinuedState();
        //return;        
    }

    function SetMoveGoal(Actor inGoalActor, int blockedPathAttempts, Vector Loc, SPAIController.EMoveGoalType movetype, optional bool inbInterruptable, optional bool inbReachable, optional Actor inMoveTarget, optional bool bUseRouteCache, optional bool bCheckForDefendArea, optional bool bKismetCommand)
    {
        // End:0x6A
        if(myPawn.IsInGhostState())
        {
            m_bKismetCommand = true;
            // End:0x58
            if(Loc == vect(0.0000000, 0.0000000, 0.0000000))
            {
                SetDirectMoveGoal(inGoalActor.Location);                
            }
            else
            {
                SetDirectMoveGoal(Loc);
            }            
        }
        else
        {
            super(SPAIController).SetMoveGoal(inGoalActor, blockedPathAttempts, Loc, movetype, inbInterruptable, inbReachable, inMoveTarget, bUseRouteCache, bCheckForDefendArea, bKismetCommand);
        }
        //return;        
    }
    stop;    
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        Pawn.SetMovementPhysics();
        Focus = none;
        Target = none;
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        super(SPAIController).OnSeeEnemy(PlayerIdx, bNewEnemy);
        // End:0x38
        if(m_bIsSquadLeader && CheckForEnemy(true))
        {
            EvaluateSituation();
        }
        //return;        
    }

    function OnHearEnemy(int PlayerIdx)
    {
        super(SPAIController).OnHearEnemy(PlayerIdx);
        // End:0x32
        if(m_bIsSquadLeader && CheckForEnemy(true))
        {
            EvaluateSituation();
        }
        //return;        
    }
Begin:

    Sleep(0.1000000);
    m_vHarassmentStartPoint = vect(0.0000000, 0.0000000, 0.0000000);
    ClearEnemy();
    myPawn.RestartParticleTrail();
    Sleep(0.1000000);
    StopPawn();
    myPawn.StopParticleTrail();
    J0x5B:

    // End:0x71 [Loop If]
    if(Pawn == none)
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x5B;
    }
    myPawn.TransitionToGhost();
    CheckSquadLeader();
    // End:0xC3
    if(m_bIsSquadLeader)
    {
        EvaluateSituation();
        // End:0xC3
        if(HasValidEnemy(,,, true))
        {
            PushState('RandomBuzzing');
        }
    }
    // End:0x220
    if(!m_bIsSquadLeader && SPSquadNari(m_squad).m_squadLeader != none)
    {
        // End:0x10B
        if(HasValidEnemy(,,, true))
        {
            GotoState('SquadRandomBuzzing');            
        }
        else
        {
            // End:0x220
            if(VSize(SPSquadNari(m_squad).m_squadLeader.Pawn.Location - Pawn.Location) > float(200))
            {
                m_vDirectMoveGoal = SPSquadNari(m_squad).m_squadLeader.Pawn.Location;
                m_fDirectMoveSpeed = m_NariGDTuneData.IdleFollowerSpeed;
                J0x192:

                // End:0x216 [Loop If]
                if(VSize(m_vDirectMoveGoal - Pawn.Location) > 50.0000000)
                {
                    // End:0x1CE
                    if(m_vDirectMoveGoal == vect(0.0000000, 0.0000000, 0.0000000))
                    {
                        // [Explicit Break]
                        goto J0x216;
                    }
                    DirectlyMovePawn(m_vDirectMoveGoal);
                    Sleep(0.1000000);
                    m_vDirectMoveGoal = SPSquadNari(m_squad).m_squadLeader.Pawn.Location;
                    // [Loop Continue]
                    goto J0x192;
                }
                J0x216:

                StopPawn();
            }
        }
    }
    // End:0x259
    if(SPSquadNari(m_squad).m_squadEnemy != none)
    {
        SetEnemy(SPSquadNari(m_squad).m_squadEnemy);
    }
    Sleep(0.1000000);
    goto 'IdleLoop';
    stop;                    
}

state Retreat
{Begin:

    stop;                
}

state CATAttacker
{
    function FinishCATAttack(bool bSucceeded)
    {
        GotoState('Idle');
        //return;        
    }
    stop;    
}

state RandomBuzzing
{
    event bool UpdateFocus()
    {
        Focus = GetEnemy();
        FocalPoint = GetEnemy().Location;
        return true;
        //return ReturnValue;        
    }
Begin:

    myPawn.RestartParticleTrail();
    StopPawn();
    J0x1E:

    // End:0x193 [Loop If]
    if(HasValidEnemy(,,, true))
    {
        myPawn.m_AttackState = 5;
        m_vHarassmentStartPoint = vect(0.0000000, 0.0000000, 0.0000000);
        PushState('PursueToHarass');
        SPSquadNari(m_squad).m_squadEnemy = GetEnemy();
        myPawn.m_AttackState = 0;
        J0x94:

        // End:0x186 [Loop If]
        if((HasValidEnemy(,,, true)) && VSizeSq(GetEnemy().Location - m_vHarassmentStartPoint) < ((m_NariGDTuneData.HarassmentRange * m_NariGDTuneData.HarassmentRange) * 1.2000000))
        {
            // End:0x112
            if(Pawn != none)
            {
                Pawn.SetMovementPhysics();
            }
            m_vDirectMoveGoal = StartMoving();
            m_fDirectMoveSpeed = m_NariGDTuneData.BuzzingSpeed;
            SetDirectMoveGoal(m_vDirectMoveGoal);
            StopPawn();
            Sleep(FRand());
            J0x155:

            // End:0x179 [Loop If]
            if(!myPawn.IsInGhostState())
            {
                Sleep(0.0100000);
                // [Loop Continue]
                goto J0x155;
            }
            EvaluateSituation();
            // [Loop Continue]
            goto J0x94;
        }
        StopPawn();
        // [Loop Continue]
        goto J0x1E;
    }
    PopState();
    stop;        
}

state SquadRandomBuzzing
{
    event bool UpdateFocus()
    {
        // End:0x64
        if(HasValidEnemy(,,, true))
        {
            // End:0x35
            if(m_vDirectMoveGoal != vect(0.0000000, 0.0000000, 0.0000000))
            {
                FocalPoint = m_vDirectMoveGoal;                
            }
            else
            {
                Focus = GetEnemy();
                FocalPoint = GetEnemy().Location;
            }
            return true;            
        }
        else
        {
            GotoState('Idle');
            return false;
        }
        //return ReturnValue;        
    }
Begin:

    myPawn.RestartParticleTrail();
    StopPawn();
    J0x1E:

    // End:0x195 [Loop If]
    if((HasValidEnemy(,,, true)) && !m_bIsSquadLeader)
    {
        myPawn.TransitionToGhost();
        // End:0x85
        if((int(m_eGroupAttackType) == int(1)) || int(m_eGroupAttackType) == int(2))
        {
            PushState('ClawSwipeAttack');            
        }
        else
        {
            // End:0xA8
            if(int(m_eGroupAttackType) == int(3))
            {
                PushState('SonicBlastAttack');                
            }
            else
            {
                // End:0xC8
                if(int(m_eGroupAttackType) == int(4))
                {
                    PushState('Poltergeist');
                }
            }
        }
        myPawn.TransitionToGhost();
        // End:0xFC
        if(Pawn != none)
        {
            Pawn.SetMovementPhysics();
        }
        // End:0x136
        if(HasValidEnemy(,,, true))
        {
            // End:0x133
            if(m_vDirectMoveGoal == vect(0.0000000, 0.0000000, 0.0000000))
            {
                m_vDirectMoveGoal = StartMoving();
            }            
        }
        else
        {
            GotoState('Idle');
        }
        m_fDirectMoveSpeed = m_NariGDTuneData.PursueSpeed;
        // End:0x17B
        if(HasValidEnemy(,,, true))
        {
            SetDirectMoveGoal(m_vDirectMoveGoal);            
        }
        else
        {
            // [Explicit Break]
            goto J0x195;
        }
        StopPawn();
        CheckSquadLeader();
        // [Loop Continue]
        goto J0x1E;
    }
    J0x195:

    GotoState('Idle');
    stop;                    
}

state DirectMove
{
    function DirectlyMovePawn(Vector Dest)
    {
        local float l_magnitude;

        // End:0x0D
        if(Pawn == none)
        {
            return;
        }
        // End:0x24
        if(Dest == vect(0.0000000, 0.0000000, 0.0000000))
        {
        }
        // End:0x3B
        if(m_vDirectMoveGoal == vect(0.0000000, 0.0000000, 0.0000000))
        {
        }
        Pawn.Acceleration = Normal(Dest - Pawn.Location) * FClamp(Pawn.AccelRate, 0.0000000, 2000.0000000);
        Pawn.DesiredSpeed = m_fDirectMoveSpeed;
        l_magnitude = VSize(Pawn.Velocity);
        // End:0x133
        if((m_fDirectMoveSpeed - l_magnitude) > m_NariGDTuneData.DirectMoveFastAccelDeltaV)
        {
            Pawn.Velocity = Normal(Dest - Pawn.Location) * (l_magnitude + FClamp((m_fDirectMoveSpeed - l_magnitude) * 0.1000000, m_NariGDTuneData.DirectMoveMin, m_NariGDTuneData.DirectMoveMax));            
        }
        else
        {
            Pawn.Velocity = Normal(Dest - Pawn.Location) * (l_magnitude + FClamp((m_fDirectMoveSpeed - l_magnitude) * 0.0500000, 0.0000000, m_NariGDTuneData.DirectMoveMin));
        }
        // End:0x1FD
        if(l_magnitude > float(400))
        {
            l_magnitude = VSize(Dest - Pawn.Location);
            // End:0x1FD
            if(l_magnitude < m_NariGDTuneData.DirectMoveSlowDownRange)
            {
                Pawn.Velocity = Normal(Pawn.Velocity) * 400.0000000;
            }
        }
        // End:0x240
        if(VSize(Pawn.Velocity) > m_fDirectMoveSpeed)
        {
            Pawn.Velocity = Normal(Pawn.Velocity) * m_fDirectMoveSpeed;
        }
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        m_bDirectMoveBump = true;
        return super(SPNariAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    event bool NotifyBumpLevel(Vector HitLocation, Vector HitNormal)
    {
        m_bDirectMoveBump = true;
        return super(Controller).NotifyBumpLevel(HitLocation, HitNormal);
        //return ReturnValue;        
    }

    function bool AmIThere()
    {
        // End:0x2E
        if(VSize(m_vDirectMoveGoal - Pawn.Location) < m_NariGDTuneData.DirectMoveTolerance)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool CanIMove()
    {
        return true;
        //return ReturnValue;        
    }
Begin:

    m_bDirectMoveBump = false;
    Pawn.SetPhysics(4);
    // End:0x24
    if(m_fDirectMoveSpeed == float(0))
    {
    }
    // End:0x42
    if(m_vDirectMoveGoal == vect(0.0000000, 0.0000000, 0.0000000))
    {
        PopState();
    }
    J0x42:

    // End:0xE1 [Loop If]
    if(!AmIThere() && !m_bDirectMoveBump)
    {
        // End:0x7D
        if(CanIMove())
        {
            DirectlyMovePawn(m_vDirectMoveGoal);            
        }
        else
        {
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.DesiredSpeed = 0.0000000;
            Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        }
        DoAction();
        Sleep(0.0500000);
        // [Loop Continue]
        goto J0x42;
    }
    // End:0xFF
    if(m_bKismetCommand)
    {
        ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', false);
        m_bKismetCommand = false;
    }
    StopPawn();
    PopState();
    stop;                
}

state DirectMoveCombat extends DirectMove
{
    function DoAction()
    {
        local SPPawn catTarget;
        local Pawn pEnemyPawn;

        // End:0x1C
        if(int(myPawn.m_AttackState) != int(0))
        {
            return;
        }
        // End:0x3C
        if(!HasValidEnemy(,,, true))
        {
            GotoState('Idle');
        }
        pEnemyPawn = GetEnemy();
        m_vDirectMoveGoal = pEnemyPawn.Location;
        Focus = pEnemyPawn;
        FocalPoint = pEnemyPawn.Location;
        // End:0x2CF
        if(IsDirectMoveValid(m_vDirectMoveGoal))
        {
            catTarget = CheckForCATAttack();
            // End:0xE4
            if(catTarget != none)
            {
                myPawn.TransitionToSolid();
                StartCATAttack(catTarget, myPawn.CATAnimationInfo);
                return;
            }
            // End:0x170
            if(myPawn.IsInGhostState() && VSize(pEnemyPawn.Location - Pawn.Location) < m_NariGDTuneData.GetValue(m_NariGDTuneData.ClawSwipeGoSolidRange))
            {
                myPawn.TransitionToSolid();
                myPawn.m_AttackState = 6;
                return;
            }
            // End:0x1E8
            if((int(myPawn.m_AttackState) == int(0)) && VSize(pEnemyPawn.Location - Pawn.Location) < m_NariGDTuneData.ClawSwipeRange)
            {
                myPawn.m_resetAttackAnim = true;
                myPawn.m_AttackState = 1;
                return;
            }
            // End:0x2CF
            if((((m_bAllowSuperAttack == true) && int(myPawn.m_AttackState) == int(0)) && VSize(pEnemyPawn.Location - Pawn.Location) < m_NariGDTuneData.CloseTheGapRange) && Abs(pEnemyPawn.Location.Z - Pawn.Location.Z) < 100.0000000)
            {
                myPawn.m_AttackState = 7;
                myPawn.m_resetAttackAnim = true;
                Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
                return;
            }
        }
        //return;        
    }

    function bool AmIThere()
    {
        // End:0x14
        if(!HasValidEnemy(,,, true))
        {
            return true;
        }
        return super.AmIThere();
        //return ReturnValue;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        // End:0x1C
        if(Other != (GetEnemy()))
        {
            m_bDirectMoveBump = true;
        }
        return super.NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function bool CanIMove()
    {
        // End:0x29
        if(myPawn.IsInSolidState())
        {
            myPawn.m_AttackState = 0;
        }
        // End:0x5A
        if(int(myPawn.m_AttackState) == int(6))
        {
            myPawn.TransitionToSolid();
            return false;
        }
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state GoHome
{Begin:

    myPawn.TransitionToGhost();
    // End:0xD1
    if(m_bIsSquadLeader)
    {
        // End:0x3E
        if(!HasValidEnemy())
        {
            GotoState('Idle');
        }
        // End:0xD1
        if(VSize(m_vMySavedLocation - GetEnemy().Location) > (m_NariGDTuneData.FlockingRange * 1.5000000))
        {
            myPawn.m_AttackState = 5;
            m_vHarassmentStartPoint = vect(0.0000000, 0.0000000, 0.0000000);
            PushState('PursueToHarass');
            SPSquadNari(m_squad).m_squadEnemy = GetEnemy();
            PopState();
        }
    }
    FocalPoint = m_vMySavedLocation;
    Focus = none;
    SetDirectMoveGoal(m_vMySavedLocation);
    StopPawn();
    m_vAttackRunStart = vect(0.0000000, 0.0000000, 0.0000000);
    m_vMySavedLocation = vect(0.0000000, 0.0000000, 0.0000000);
    PopState();
    stop;            
}

state ClawSwipeAttack
{
    event PoppedState()
    {
        myPawn.TransitionToGhost();
        m_vDirectMoveGoal = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    function EndState(name NextStateName)
    {
        myPawn.TransitionToGhost();
        //return;        
    }

    function SetDirectMoveGoal(Vector Dest)
    {
        m_vDirectMoveGoal = Dest;
        PushState('DirectMoveCombat');
        //return;        
    }

    function bool TryAnAlternativeSpot()
    {
        local Vector Awesome;

        Awesome = GetAttackRunEndVector();
        // End:0x4D
        if(Awesome != vect(0.0000000, 0.0000000, 0.0000000))
        {
            m_fDirectMoveSpeed = m_NariGDTuneData.ClawSwipeSpeed;
            SetDirectMoveGoal(Awesome);
            return true;
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    m_vMySavedLocation = Pawn.Location;
    myPawn.m_bHasDamagedThisAttack = false;
    myPawn.m_AttackState = 0;
    myPawn.SuperDamageCounter = 0.0000000;
    // End:0x8F
    if(int(m_eGroupAttackType) == int(1))
    {
        ClearTimer('TellNextSquadMateToAttack');
        m_eSavedGroupAttackType = m_eGroupAttackType;
        SetTimer(0.5000000,, 'TellNextSquadMateToAttack');        
    }
    else
    {
        // End:0xCD
        if(int(m_eGroupAttackType) == int(2))
        {
            ClearTimer('TellNextSquadMateToAttack');
            m_eSavedGroupAttackType = m_eGroupAttackType;
            SetTimer(0.0100000,, 'TellNextSquadMateToAttack');
        }
    }
    m_eGroupAttackType = 0;
    m_bAllowSuperAttack = false;
    // End:0x10F
    if(FRand() < m_NariGDTuneData.GetValue(m_NariGDTuneData.SuperAttackChance))
    {
        m_bAllowSuperAttack = true;
    }
    myPawn.TransitionToGhost();
    // End:0x1A1
    if(IsDirectMoveValid(GetEnemy().Location))
    {
        m_fDirectMoveSpeed = m_NariGDTuneData.ClawSwipeSpeed;
        SetDirectMoveGoal(GetEnemy().Location);
        J0x179:

        // End:0x19E [Loop If]
        if(int(myPawn.m_AttackState) != int(0))
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x179;
        }        
    }
    else
    {
        // End:0x1B0
        if(!TryAnAlternativeSpot())
        {
        }
        // End:0x22A
        if(IsDirectMoveValid(GetEnemy().Location))
        {
            m_fDirectMoveSpeed = m_NariGDTuneData.ClawSwipeSpeed;
            SetDirectMoveGoal(GetEnemy().Location);
            J0x205:

            // End:0x22A [Loop If]
            if(int(myPawn.m_AttackState) != int(0))
            {
                Sleep(0.1000000);
                // [Loop Continue]
                goto J0x205;
            }
        }
    }
    m_vDirectMoveGoal = Pawn.Location + (Normal(m_vMySavedLocation - Pawn.Location) * 600.0000000);
    Focus = none;
    FocalPoint = m_vDirectMoveGoal;
    PushState('DirectMove');
    StopPawn();
    PopState();
    stop;                    
}

state Poltergeist
{
    event PoppedState()
    {
        ExitPossession();
        myPawn.TransitionToGhost();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ExitPossession();
        myPawn.TransitionToGhost();
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        // End:0x1F
        if(m_PoltergeistTarget == none)
        {
            return super(SPNariAIController).NotifyBump(Other, HitNormal);            
        }
        else
        {
            // End:0xCA
            if(m_PoltergeistTarget.Base == Pawn)
            {
                m_bWasBumped = true;
                // End:0x98
                if(!Other.IsA('SPNariPawn'))
                {
                    Other.TakeDamageAndProcEffects(20.0000000, self, GetEnemy().Location, HitNormal, Class'SPDamageTypeImpactAny',, Pawn);
                }
                ExitPossession(Other.Location);
                myPawn.SetSolid();
                return false;                
            }
            else
            {
                // End:0xF2
                if(Other != m_PoltergeistTarget)
                {
                    m_bWasBumped = true;
                    return super(SPNariAIController).NotifyBump(Other, HitNormal);
                }
            }
        }
        return true;
        //return ReturnValue;        
    }

    event bool NotifyBumpLevel(Vector HitLocation, Vector HitNormal)
    {
        m_bWasBumped = true;
        ExitPossession();
        myPawn.SetGhost();
        myPawn.TransitionToGhost();
        return false;
        //return ReturnValue;        
    }

    function StartPossession()
    {
        myPawn.SetCollision(false, false);
        m_PoltergeistTarget.SetCollision(false, false);
        m_PoltergeistTarget.bCollideWorld = false;
        m_PoltergeistTarget.SetPhysics(0);
        m_PoltergeistTarget.SetHardAttach(true);
        m_PoltergeistTarget.SetBase(myPawn,,,, true);
        myPawn.SetInvisible();
        myPawn.SetPoltergeistCollision(m_PoltergeistTarget);
        myPawn.AttachComponent(myPawn.m_PoltergeistCollision);
        myPawn.SetCollision(true, true);
        myPawn.StartPolterParticleTrail();
        // End:0x10E
        if(myPawn.PoltergeistSound != none)
        {
            PlaySound(myPawn.PoltergeistSound, true);
        }
        //return;        
    }

    function bool IsValidPoltergeistObject()
    {
        return (m_PoltergeistTarget != none) && !m_PoltergeistTarget.IsPendingKill();
        //return ReturnValue;        
    }
Begin:

    myPawn.TransitionToGhost();
    m_bWasBumped = false;
    m_vMySavedLocation = Pawn.Location;
    myPawn.m_PolterPulse = 0.0000000;
    // End:0x83
    if(m_PoltergeistTarget == none)
    {
        FindPoltergeistObject(GetEnemy(), m_PossessObject);
        // End:0x83
        if(int(m_eGroupAttackType) == int(5))
        {
            m_eGroupAttackType = 4;
        }
    }
    // End:0xC1
    if(int(m_eGroupAttackType) == int(4))
    {
        ClearTimer('TellNextSquadMateToAttack');
        m_eSavedGroupAttackType = m_eGroupAttackType;
        SetTimer(3.5000000,, 'TellNextSquadMateToAttack');
    }
    m_eGroupAttackType = 0;
    // End:0xDF
    if(!IsValidPoltergeistObject())
    {
        PopState();
    }
    // End:0x4D3
    if(m_PoltergeistTarget.Location != vect(0.0000000, 0.0000000, 0.0000000))
    {
        m_PoltergeistTarget.ClaimInteractionRights(Pawn, 7, true);
        m_fDirectMoveSpeed = m_NariGDTuneData.GetValue(m_NariGDTuneData.PoltergeistMoveToObjectSpeed);
        J0x147:

        // End:0x224 [Loop If]
        if((IsValidPoltergeistObject()) && VSize(m_PoltergeistTarget.Location - Pawn.Location) > 15.0000000)
        {
            // End:0x200
            if(VSize(m_PoltergeistTarget.Location - Pawn.Location) < 75.0000000)
            {
                m_fDirectMoveSpeed = m_NariGDTuneData.GetValue(m_NariGDTuneData.PoltergeistMoveToObjectSlowSpeed);
                // End:0x200
                if(int(m_PoltergeistTarget.Physics) != int(0))
                {
                    m_PoltergeistTarget.SetPhysics(0);
                }
            }
            DirectlyMovePawn(m_PoltergeistTarget.Location);
            Sleep(0.0100000);
            // [Loop Continue]
            goto J0x147;
        }
        StopPawn();
        // End:0x244
        if(!IsValidPoltergeistObject())
        {
            PopState();
        }
        StartPossession();
        // End:0x27D
        if(myPawn.PoltergeistSound != none)
        {
            PlaySound(myPawn.PoltergeistSound, true);
        }
        Sleep(0.0000000);
        // End:0x2A5
        if(m_PoltergeistTarget.Base != Pawn)
        {
            PopState();
        }
        myPawn.m_AttackState = 4;
        myPawn.m_PolterState = 0;
        J0x2C9:

        // End:0x2EE [Loop If]
        if(int(myPawn.m_PolterState) == int(0))
        {
            Sleep(0.2000000);
            // [Loop Continue]
            goto J0x2C9;
        }
        m_fDirectMoveSpeed = m_NariGDTuneData.GetValue(m_NariGDTuneData.PoltergeistAttackSpeed);
        // End:0x42C
        if(!m_bWasBumped)
        {
            myPawn.m_resetPolterAnim = true;
            myPawn.m_PolterState = 1;
            m_vDirectMoveGoal = GetEnemy().Location + (Normal(GetEnemy().Location - Pawn.Location) * 400.0000000);
            J0x390:

            // End:0x3E8 [Loop If]
            if(((IsValidPoltergeistObject()) && VSize(m_vDirectMoveGoal - Pawn.Location) > 150.0000000) && !m_bWasBumped)
            {
                DirectlyMovePawn(m_vDirectMoveGoal);
                Sleep(0.0100000);
                // [Loop Continue]
                goto J0x390;
            }
            // End:0x422
            if(m_bWasBumped)
            {
                Sleep(0.5000000);
                myPawn.SetSolid();
                myPawn.TransitionToSolid();
            }
            StopPawn();
        }
        Sleep(0.1000000);
        ExitPossession();
        myPawn.SetGhost();
        myPawn.TransitionToGhost();
        // End:0x4C8
        if(m_bWasBumped)
        {
            myPawn.m_PolterState = 2;
            myPawn.TransitionToSolid();
            J0x498:

            // End:0x4BD [Loop If]
            if(int(myPawn.m_PolterState) == int(2))
            {
                Sleep(0.2000000);
                // [Loop Continue]
                goto J0x498;
            }
            m_bWasBumped = false;            
        }
        else
        {
            Sleep(0.5000000);
        }        
    }
    else
    {
        Sleep(2.0000000);
    }
    myPawn.m_AttackState = 0;
    myPawn.TransitionToGhost();
    m_fDirectMoveSpeed = m_NariGDTuneData.PoltergeistRetreatSpeed;
    PushState('GoHome');
    m_PoltergeistTarget = none;
    PopState();
    stop;            
}

state SonicBlastAttack
{
    function EndState(name NextStateName)
    {
        StopParticleSonic();
        //return;        
    }

    event PoppedState()
    {
        StopParticleSonic();
        //return;        
    }

    function ResetPawn()
    {
        myPawn.m_AttackState = 0;
        //return;        
    }
Begin:

    StopPawn();
    m_vMySavedLocation = Pawn.Location;
    myPawn.m_bHasDamagedThisAttack = false;
    // End:0xCD
    if(m_bIsSquadLeader)
    {
        m_vAttackRunStart = Pawn.Location + (Normal(GetEnemy().Location - Pawn.Location) * float(Min(500, int(VSize(GetEnemy().Location - Pawn.Location) * 0.7500000))));
        SPSquadNari(m_squad).m_vAttackRunLocation = m_vAttackRunStart;
    }
    // End:0x10B
    if(int(m_eGroupAttackType) == int(3))
    {
        ClearTimer('TellNextSquadMateToAttack');
        m_eSavedGroupAttackType = m_eGroupAttackType;
        SetTimer(0.0100000,, 'TellNextSquadMateToAttack');
    }
    m_eGroupAttackType = 0;
    myPawn.TransitionToSolid();
    Sleep(2.0000000);
    m_fDirectMoveSpeed = m_NariGDTuneData.PursueSpeed;
    SetDirectMoveGoal(m_vAttackRunStart);
    StopPawn();
    myPawn.m_AttackState = 2;
    Focus = none;
    m_vAttackRunStart = GetEnemy().Location;
    FocalPoint = m_vAttackRunStart;
    SetTimer(10.0000000,, 'ResetPawn');
    J0x1AF:

    // End:0x1D4 [Loop If]
    if(int(myPawn.m_AttackState) != int(0))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x1AF;
    }
    Focus = GetEnemy();
    Sleep(2.5000000);
    myPawn.TransitionToGhost();
    m_fDirectMoveSpeed = m_NariGDTuneData.PursueSpeed;
    PushState('GoHome');
    PopState();
    stop;            
}

state Taunt
{
    function Vector GetTauntLocation()
    {
        local Vector Dest;

        Dest = (Normal(Pawn.Location - GetEnemy().Location) * m_NariGDTuneData.TauntRange) + GetEnemy().Location;
        Dest.X += RandRange(-m_NariGDTuneData.TauntRandom, m_NariGDTuneData.TauntRandom);
        Dest.Y += RandRange(-m_NariGDTuneData.TauntRandom, m_NariGDTuneData.TauntRandom);
        Dest.Z += RandRange(-m_NariGDTuneData.TauntRandom, m_NariGDTuneData.TauntRandom);
        // End:0x114
        if(IsTauntLocationValid(Dest))
        {
            return Dest;
        }
        return Pawn.Location;
        //return ReturnValue;        
    }

    function ResetPawn()
    {
        myPawn.m_AttackState = 0;
        //return;        
    }
Begin:

    StopPawn();
    m_vMySavedLocation = Pawn.Location;
    m_fDirectMoveSpeed = m_NariGDTuneData.TauntSpeed;
    SetDirectMoveGoal(GetTauntLocation());
    StopPawn();
    myPawn.m_AttackState = 3;
    SetTimer(5.0000000,, 'ResetPawn');
    J0x77:

    // End:0x9C [Loop If]
    if(int(myPawn.m_AttackState) != int(0))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x77;
    }
    m_fDirectMoveSpeed = m_NariGDTuneData.PursueSpeed;
    PushState('GoHome');
    PopState();
    stop;                
}

state PursueEnemy
{
    function GotoMoveToGoalState()
    {
        // End:0x37
        if((KynapseComponent != none) && KynapseComponent.IsInitialized())
        {
            PushState('KyPursueToPosition');            
        }
        else
        {
            PushState('PursueToPosition');
        }
        //return;        
    }
    J0x00:
    // End:0xBE [Loop If]
    if(true)
    {
        // End:0xA9
        if(HasValidEnemy(,,, true))
        {
            Focus = GetEnemy();
            // End:0x8F
            if(FarAwayEnoughToPursue(GetEnemy()))
            {
                myPawn.m_AttackState = 5;
                SetMoveGoal(GetEnemy(), 1, GetEnemy().Location, 0);
                myPawn.m_AttackState = 0;                
            }
            else
            {
                // End:0xA9
                if(CloseEnoughToHit(GetEnemy()))
                {
                    PopState();
                }
            }
        }
        Sleep(0.1000000);
        EvaluateSituation();
        // [Loop Continue]
        goto J0x00;
    }
    stop;        
}

state dazed
{
    function ResetPawn()
    {
        myPawn.m_AttackState = 0;
        //return;        
    }
Begin:

    StopPawn();
    myPawn.m_bFinishedDazed = false;
    myPawn.m_AttackState = 8;
    SetTimer(10.0000000,, 'ResetPawn');
    myPawn.StopParticleTrail();
    myPawn.SetCollision(true, true);
    myPawn.bCollideWorld = true;
    myPawn.bBlockActors = true;
    J0x89:

    // End:0xC6 [Loop If]
    if((int(myPawn.m_AttackState) != int(0)) && myPawn.m_bFinishedDazed == false)
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x89;
    }
    myPawn.TransitionToGhost(true);
    GotoState('Idle');
    stop;            
}

state PursueToHarass
{Begin:

    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    m_fDirectMoveSpeed = m_NariGDTuneData.PursueSpeed;
    m_bBelowEnemy = false;
    // End:0x8B
    if((GetEnemy().Location.Z - Pawn.Location.Z) > float(300))
    {
        m_bBelowEnemy = true;
    }
    // End:0x201
    if(m_vHarassmentStartPoint == vect(0.0000000, 0.0000000, 0.0000000))
    {
        J0xA2:

        // End:0x12D [Loop If]
        if((HasValidEnemy(,,, true)) && VSizeSq(Pawn.Location - GetEnemy().Location) > (m_NariGDTuneData.HarassmentRange * m_NariGDTuneData.HarassmentRange))
        {
            DirectlyMovePawn(GetEnemy().Location);
            Sleep(0.0500000);
            // [Loop Continue]
            goto J0xA2;
        }
        StopPawn();
        m_vHarassmentStartPoint = Pawn.Location;
        m_vHarassmentStartPoint.Z = FClamp(m_vHarassmentStartPoint.Z, GetEnemy().Location.Z - m_NariGDTuneData.VerticalDownFlockMin, GetEnemy().Location.Z + m_NariGDTuneData.VerticalFlockMax);
        // End:0x1EE
        if(m_bBelowEnemy)
        {
            m_vHarassmentStartPoint.Z += float(90);
        }
        // End:0x201
        if(m_bIsSquadLeader)
        {
            SetSquadHarassPoint();
        }
    }
    PopState();
    stop;                
}

state KyMoveToGoalNari extends KyMoveToGoal
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        myPawn.m_AttackState = 5;
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        //return;        
    }

    event PushedState()
    {
        super.PushedState();
        myPawn.m_AttackState = 5;
        //return;        
    }

    function ContinuedState()
    {
        super.ContinuedState();
        myPawn.m_AttackState = 5;
        //return;        
    }

    event PoppedState()
    {
        super.PoppedState();
        myPawn.m_AttackState = 0;
        //return;        
    }
    stop;    
}

state KyPursueToPosition extends KyMoveToGoal
{
    function bool IsAtMoveGoal()
    {
        return CloseEnoughToHit(Pawn(m_moveGoalInfo.GoalActor));
        //return ReturnValue;        
    }
Begin:

    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    m_bMoveAborted = false;
    m_bDelayingMove = false;
    m_moveGoalInfo.maxBlockedPathAttempts = 1;
    // End:0xEB
    if(m_moveGoalInfo.GoalActor != none)
    {
        J0x57:

        // End:0xEB [Loop If]
        if(!IsAtMoveGoal())
        {
            // End:0xBA
            if((int(m_moveGoalInfo.moveAttempts++) > m_moveGoalInfo.maxBlockedPathAttempts) && m_moveGoalInfo.maxBlockedPathAttempts != 0)
            {
                AbortMove();
                // [Explicit Break]
                goto J0xEB;                
            }
            else
            {
                // End:0xE8
                if(HasValidMoveGoal())
                {
                    ValidateMoveGoal();
                    KyMoveToward(m_moveGoalInfo.GoalActor,,,,, true);
                }
            }
            // [Loop Continue]
            goto J0x57;
        }
    }
    J0xEB:

    PopState();
    stop;        
}

state TakeHit
{
    function EndState(name NextStateName)
    {
        ClearState();
        //return;        
    }

    event PoppedState()
    {
        ClearState();
        //return;        
    }

    function ClearState()
    {
        // End:0x6B
        if((myPawn != none) && !myPawn.IsInState('Dying'))
        {
            myPawn.SetAnimHitDeathState(0);
            // End:0x6B
            if(myPawn.IsInState('TakeHit'))
            {
                myPawn.PopState();
            }
        }
        //return;        
    }
Begin:

    StopPawn();
    stop;        
}

state ControllerDying
{
    function BeginState(name PreviousStateName)
    {
        SetKynapseRotationControlAllowed(false);
        Focus = none;
        m_buffetVolume = none;
        StopParticleSonic();
        myPawn.TrailEmitter = none;
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
        // End:0x13
        if(m_bIsSquadLeader)
        {
            ResetSquad();
        }
        //return;        
    }

    function NotifyDied()
    {
        PopState();
        GotoState('WaitingForTheInevitable');
        //return;        
    }

    function ResetSquad()
    {
        local int Idx;

        SPSquadNari(m_squad).m_squadLeader = none;
        // End:0xE0
        if(m_squad.m_members.Length > 1)
        {
            Idx = 0;
            J0x33:

            // End:0xE0 [Loop If]
            if(Idx < m_squad.m_members.Length)
            {
                // End:0xD6
                if((m_squad.m_members[Idx] != Pawn.Controller) && !SPNariAIController(m_squad.m_members[Idx]).IsInState('ControllerDying'))
                {
                    SPNariAIController(m_squad.m_members[Idx]).GotoState('Idle');
                }
                Idx++;
                // [Loop Continue]
                goto J0x33;
            }
        }
        //return;        
    }
Begin:

    ClearTimer();
    StopPawn();
    // End:0x25
    if(m_bIsSquadLeader)
    {
        ResetSquad();
    }
    J0x25:

    // End:0x46 [Loop If]
    if(myPawn.m_bFinishedDying != true)
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x25;
    }
    NotifyDied();
    stop;                
}

state WaitingForTheInevitable
{
    function BeginState(name PreviousStateName)
    {
        myPawn.StopParticleTrail();
        myPawn.TrailEmitter.Destroy();
        myPawn.TrailEmitter = none;
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

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        super.Possess(NewPawn, bVehicleTransition);
        myPawn = SPNariPawnPersistent(NewPawn);
        myPawn.MyController = self;
        GotoState('Idle');
        //return;        
    }
    stop;    
}
