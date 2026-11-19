class SPSewerTentaclePawnPersistent extends SPPawn
    native
    config(Game);

enum eSewerTentacleActionState
{
    eSTActionNone,                  // 0
    eSTActionIdleLookOut,           // 1
    eSTActionGrabbing,              // 2
    eSTActionGrabbingPlayer,        // 3
    eSTActionPullingPlayerAttached, // 4
    eSTActionPullingEnemyAttached,  // 5
    eSTActionPullingNoEnemyAttached,// 6
    eSTActionPullingNoEnemyAttachedHitCollision,// 7
    eSTActionLoopingDamageSequence, // 8
    eSTActionThrowingForward,       // 9
    eSTActionThrowingBackwards,     // 10
    eSTActionDying,                 // 11
    eSewerTentacleActionState_MAX   // 12
};

enum eSewerTentacleAttackState
{
    eSTAttackUp,                    // 0
    eSTAttackRight,                 // 1
    eSTAttackLeft,                  // 2
    eSTAttackForward,               // 3
    eSTAttackNone,                  // 4
    eSewerTentacleAttackState_MAX   // 5
};

enum eSewerTentaclePullbackState
{
    eSTPullback100,                 // 0
    eSTPullback75,                  // 1
    eSTPullback50,                  // 2
    eSTPullback25,                  // 3
    eSewerTentaclePullbackState_MAX // 4
};

/** VARIABLE DECLARATIONS squad team info */
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var SPSewerTentaclePawnPersistent.eSewerTentacleActionState m_actionState;
var SPSewerTentaclePawnPersistent.eSewerTentacleAttackState m_AttackState;
var StaticMesh m_GooStaticMesh;
var SPDStaticMesh m_GooStaticMeshComponent;
var StaticMesh m_GooStaticMeshOpen;
var SPDStaticMesh m_GooStaticMeshOpenComponent;
var bool m_bResetAction;
var bool m_bCanAttack;
var bool m_bIsDying;
var bool m_bGroundTentacle;
var SPDImpulseActor ExplodeDamageActor;
var Vector m_CollisionStartLocation;
var Vector m_CollisionStartOffset;
var SoundCue GrabbedSound;
var SPGameDifficultyTuneTentacle m_TentacleGDTuneData;

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

event int DetermineAttackCondition()
{
    return int(m_AttackState);
    //return ReturnValue;    
}

event int DeterminePullbackCondition()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x30
    if(MyController != none)
    {
        return MyController.GetPullbackDistanceNode();
    }
    return 3;
    //return ReturnValue;    
}

event bool CanTentacleAttack()
{
    return m_bCanAttack;
    //return ReturnValue;    
}

function SetResetAttackFromController()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x2D
    if(MyController != none)
    {
        MyController.m_bResetAttack = false;
    }
    SetTimer(2.0000000, false, 'ResetAttack');
    //return;    
}

function ResetAttack()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x2D
    if(MyController != none)
    {
        MyController.m_bResetAttack = true;
    }
    //return;    
}

function NotifyDyingAnimEnd()
{
    m_bIsDying = true;
    //return;    
}

function NotifyIdleLookOutEnded()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x2D
    if(MyController != none)
    {
        MyController.m_bIdleLookOutEnded = true;
    }
    //return;    
}

function NotifyKillPlayer()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x3A
    if(MyController != none)
    {
        // End:0x3A
        if(Health > 0)
        {
            MyController.KillEnemyPlayer();
        }
    }
    //return;    
}

function NotifyStretchTimedOut()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x9E
    if(MyController != none)
    {
        // End:0x9E
        if(MyController.m_bStretchingToEnemy)
        {
            // End:0x56
            if(MyController.m_bAttachingToEnemy)
            {
                MyController.m_bStretchingTimedOut = false;                
            }
            else
            {
                MyController.m_bStretchingTimedOut = true;
            }
            MyController.m_bStretchingToEnemy = false;
            MyController.m_bPullingBack = true;
            MyController.m_bLoopingDamageSequence = false;
        }
    }
    //return;    
}

function IdleRetractDisabled()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x2D
    if(MyController != none)
    {
        MyController.m_bIdleRetract = false;
    }
    //return;    
}

function NotifyPullingBackTimedOut()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x77
    if(MyController != none)
    {
        MyController.m_bPullingBack = false;
        // End:0x77
        if(MyController.m_bStretchingTimedOut)
        {
            MyController.m_bStretchingTimedOut = false;
            MyController.m_bResetAttack = false;
            SetTimer(2.0000000, false, 'ResetAttack');
        }
    }
    //return;    
}

function NotifyThrowingNPC()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x2F
    if(MyController != none)
    {
        MyController.ThrowEnemy();
    }
    //return;    
}

function NotifyLoopingDamageSequence()
{
    m_actionState = 8;
    //return;    
}

function NotifyLoopingGiveDamage()
{
    local SPSewerTentacleAIController MyController;

    MyController = SPSewerTentacleAIController(Controller);
    // End:0x2F
    if(MyController != none)
    {
        MyController.GiveDamageToEnemy();
    }
    //return;    
}

simulated function name ActionTypeNodeDirectionAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'NoAction';
    Node.m_overrideBlendTime = 0.2500000;
    // End:0x3C
    if(m_bResetAction)
    {
        bResetChildOut = 1;
        m_bResetAction = false;
    }
    switch(m_AttackState)
    {
        // End:0x5B
        case 0:
            retval = 'Up';
            // End:0xA3
            break;
        // End:0x72
        case 1:
            retval = 'Right';
            // End:0xA3
            break;
        // End:0x89
        case 2:
            retval = 'Left';
            // End:0xA3
            break;
        // End:0xA0
        case 3:
            retval = 'Forward';
            // End:0xA3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

simulated function name ActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    retval = 'NoAction';
    Node.m_overrideBlendTime = 0.2500000;
    // End:0x3C
    if(m_bResetAction)
    {
        bResetChildOut = 1;
        m_bResetAction = false;
    }
    switch(m_actionState)
    {
        // End:0x5B
        case 0:
            retval = 'NoAction';
            // End:0x15B
            break;
        // End:0x72
        case 1:
            retval = 'IdleLookOut';
            // End:0x15B
            break;
        // End:0x89
        case 2:
            retval = 'Grabbing';
            // End:0x15B
            break;
        // End:0xA0
        case 3:
            retval = 'GrabbingPlayer';
            // End:0x15B
            break;
        // End:0xB7
        case 4:
            retval = 'PullingPlayerAttached';
            // End:0x15B
            break;
        // End:0xCE
        case 5:
            retval = 'PullingEnemyAttached';
            // End:0x15B
            break;
        // End:0xE5
        case 6:
            retval = 'PullingNoEnemyAttached';
            // End:0x15B
            break;
        // End:0xFC
        case 7:
            retval = 'PullingNoEnemyHitCollision';
            // End:0x15B
            break;
        // End:0x113
        case 8:
            retval = 'LoopingDamageSequence';
            // End:0x15B
            break;
        // End:0x12A
        case 9:
            retval = 'ThrowingEnemyAttachedForward';
            // End:0x15B
            break;
        // End:0x141
        case 10:
            retval = 'ThrowingEnemyAttachedBackwards';
            // End:0x15B
            break;
        // End:0x158
        case 11:
            retval = 'Dying';
            // End:0x15B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTuneTentacle GetTentacleDifficultyData()
{
    // End:0x20
    if(m_TentacleGDTuneData == none)
    {
        m_TentacleGDTuneData = SPGameDifficultyTuneTentacle(GetMyGDData());
    }
    return m_TentacleGDTuneData;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.TentacleGD;
    //return ReturnValue;    
}

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    GetTentacleDifficultyData();
    //return;    
}

simulated function PostBeginPlay()
{
    local Vector NewLocation, RotVec, tLocation, posTentacleTip;
    local Rotator rotTentacleTip;

    super.PostBeginPlay();
    // End:0x50
    if(Mesh.GetSocketWorldLocationAndRotation('GooTip', posTentacleTip, rotTentacleTip) == false)
    {
        NewLocation = Location;
        m_CollisionStartLocation = vect(0.0000000, 0.0000000, 1.0000000);        
    }
    else
    {
        RotVec = Vector(rotTentacleTip);
        tLocation = RotVec;
        tLocation *= m_TentacleGDTuneData.GooScalerLocation;
        NewLocation = Location + tLocation;
        m_CollisionStartLocation = Normal(NewLocation - Location);
    }
    // End:0xCD
    if((m_CollisionStartLocation Dot vect(0.0000000, 0.0000000, 1.0000000)) > 0.7600000)
    {
        m_bGroundTentacle = true;        
    }
    else
    {
        tLocation = RotVec;
        tLocation *= m_TentacleGDTuneData.NonGroundGooScalerLocation;
        NewLocation = Location + tLocation;
        m_bGroundTentacle = false;
    }
    m_CollisionStartLocation = NewLocation;
    m_CollisionStartOffset = Normal(m_CollisionStartLocation - Location) * m_TentacleGDTuneData.CollisionOffset;
    m_GooStaticMeshComponent = Spawn(Class'SPDStaticMesh',,, NewLocation, Rotation);
    m_GooStaticMeshOpenComponent = Spawn(Class'SPDStaticMesh',,, NewLocation, Rotation);
    m_GooStaticMeshComponent.StaticMeshComponent.SetStaticMesh(m_GooStaticMesh);
    m_GooStaticMeshComponent.StaticMeshComponent.SetHidden(true);
    m_GooStaticMeshComponent.SetCollision(false, false);
    m_GooStaticMeshOpenComponent.StaticMeshComponent.SetStaticMesh(m_GooStaticMeshOpen);
    m_GooStaticMeshOpenComponent.StaticMeshComponent.SetHidden(false);
    m_GooStaticMeshOpenComponent.SetCollision(false, false);
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local SPSewerTentacleAIController MyController;
    local PlayerPawn InstigatorPawn;

    // End:0x27
    if(EventInstigator != none)
    {
        InstigatorPawn = PlayerPawn(EventInstigator.Pawn);
    }
    MyController = SPSewerTentacleAIController(Controller);
    // End:0x48
    if(DamageType == Class'SPDamageTypeSewerTentacleExplosion')
    {
        return;
    }
    // End:0x61
    if(InstigatorPawn != none)
    {
        DamageAmount = 55.0000000;        
    }
    else
    {
        DamageAmount = 10.0000000;
    }
    // End:0x8C
    if(ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse'))
    {
        DamageAmount = float(Health + 1);
    }
    // End:0xC1
    if((float(Health) - DamageAmount) <= float(0))
    {
        // End:0xC1
        if(MyController != none)
        {
            MyController.RemoveEnemyFromTentacle();
        }
    }
    super.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function SewerTentacleHurtRadius(class<DamageType> DamageType, float DamageRadius, float Momentum, Vector HurtOrigin, optional Controller InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage)
{
    local Actor Victim;

    // End:0x9F
    foreach VisibleCollidingActors(Class'Engine.Actor', Victim, DamageRadius, HurtOrigin)
    {
        // End:0x9E
        if((Victim != self) && Victim.IsA('SPSewerTentaclePawnPersistent') == false)
        {
            Victim.TakeRadiusDamage(InstigatedByController, 10.0000000, DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);
        }        
    }    
    //return;    
}

function TriggerDesruction()
{
    TakeDamageAndProcEffects(float(Health + 20), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PandoraDamageType',, self);
    //return;    
}

function ApplyDamageImpulse(Vector pos, float DamageAmount, float Radius, class<DamageType> DamageType)
{
    ExplodeDamageActor = Spawn(Class'SPDImpulseActor',,, pos);
    ExplodeDamageActor.ImpulseComponent.ImpulseFalloff = 1;
    ExplodeDamageActor.ImpulseComponent.ImpulseStrength = 1000.0000000;
    ExplodeDamageActor.ImpulseComponent.ImpulseRadius = Radius;
    ExplodeDamageActor.delay = 0.0000000;
    ExplodeDamageActor.Damage = int(DamageAmount);
    ExplodeDamageActor.DamageRadius = Radius;
    ExplodeDamageActor.DamageType = DamageType;
    //return;    
}

state Dying
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        //return;        
    }

    function EndDying()
    {
        local int I;
        local SPSewerTentacleAIController MyController;

        MyController = SPSewerTentacleAIController(Controller);
        // End:0x5D
        if(MyController != none)
        {
            MyController.NotifyDied();
            // End:0x50
            if(Controller.bIsPlayer)
            {
                DetachFromController();                
            }
            else
            {
                Controller.Destroy();
            }
        }
        I = 0;
        J0x64:

        // End:0xA9 [Loop If]
        if(I < Attached.Length)
        {
            // End:0x9F
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0x64;
        }
        //return;        
    }
Begin:

    m_GooStaticMeshComponent.StaticMeshComponent.SetHidden(false);
    m_GooStaticMeshOpenComponent.StaticMeshComponent.SetHidden(true);
    m_GooStaticMeshOpenComponent.SetCollision(true, true);
    m_GooStaticMeshOpenComponent.StaticMeshComponent.SetBlockRigidBody(true);
    // End:0x8E
    if(SPSewerTentacleAIController(Controller) != none)
    {
        SPSewerTentacleAIController(Controller).GotoState('ControllerDying');
    }
    // End:0xA9
    if(int(m_actionState) != int(0))
    {
        m_actionState = 11;        
    }
    else
    {
        m_bIsDying = true;
    }
    J0xB1:

    // End:0xC7 [Loop If]
    if(!m_bIsDying)
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0xB1;
    }
    Mesh.SetHidden(true);
    m_bEnablePhysicsPushing = false;
    SetCollision(true, false);
    bCollideWorld = true;
    SetNovodexBoundingVolume(false);
    SetPhysics(0);
    EndDying();
    Destroy();
    stop;                    
}
