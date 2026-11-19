class SPBloodTickPawnPersistent extends SPPawn
    native
    config(Game);

enum eBloodTickActionState
{
    eBTActionNone,                  // 0
    eBTActionStinging,              // 1
    eBloodTickActionState_MAX       // 2
};

enum eBloodTickSacInflateState
{
    eBTSacInflateIdle,              // 0
    eBTSacInflateExpanding,         // 1
    eBTSacInflateFullyExpanded,     // 2
    eBloodTickSacInflateState_MAX   // 3
};

/** VARIABLE DECLARATIONS */
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var SPBloodTickPawnPersistent.eBloodTickActionState m_actionState;
var SPBloodTickPawnPersistent.eBloodTickSacInflateState m_sacInflateState;
var Pawn Gorgon;
var bool m_bResetAction;
var bool m_bIsDoneSleeping;
var bool m_bStingAttack;
var bool m_bStingingDone;
var SPDImpulseActor ExplodeDamageActor;
var SPTuneDataBloodTick m_BloodTickTuneData;
var SPGameDifficultyTuneBloodTick m_BloodTickGDTuneData;
var ParticleSystem ExplodeParticleTemplate;
var SoundCue ExplosionSound;
var int m_activeWallAnimChannel;
var WallAnimChannelData m_wallAnimChannelData[2];
var class<Emit_CameraBlood> CameraBloodEmitterClass;

// Export USPBloodTickPawnPersistent::execGetBloodTickPawnClass(FFrame&, void* const)
native static function class<Actor> GetBloodTickPawnClass();

simulated event PrepareForNonAnimationBasedMovement()
{
    SetMovementType(2);
    SetMovementPhysics();
    //return;    
}

simulated function SetSpiderMovementType()
{
    SetMovementType(13);
    //return;    
}

function PrepareForNavPoint(NavigationPoint goal)
{
    // End:0x2E
    if((m_wallMovementData.ReachSpec != none) && m_wallMovementData.bDoingMove)
    {
        return;
    }
    SetMovementType(2);
    super.PrepareForNavPoint(goal);
    //return;    
}

simulated function int GetFreeWallAnimationChannel()
{
    // End:0x10
    if(m_activeWallAnimChannel == 0)
    {
        return 1;        
    }
    else
    {
        return 0;
    }
    //return ReturnValue;    
}

simulated function SetSingleWallAnimation(name NodeName, name AnimName)
{
    // End:0xC1
    if((Mesh != none) && Mesh.Animations != none)
    {
        m_wallRegistrationNode = SPAnimNodeSequence(Mesh.Animations.FindAnimNode(NodeName));
        // End:0xC1
        if(m_wallRegistrationNode != none)
        {
            m_wallRegistrationNode.SetAnim(AnimName);
            m_wallRegistrationNode.SetPosition(0.0000000, false);
            m_wallRegistrationNode.bLooping = false;
            m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'SingleAnim';            
        }
    }
    //return;    
}

simulated function WallAnimationChannel1SingleAnimFinished()
{
    // End:0x5A
    if((m_activeWallAnimChannel == 0) && m_wallAnimChannelData[m_activeWallAnimChannel].MCBName == 'SingleAnim')
    {
        // End:0x52
        if(m_wallMovementData.bExecutingTransition)
        {
            WallTransitionFinished();            
        }
        else
        {
            ArrivedAtWallPathEnd(true, true);
        }
    }
    //return;    
}

simulated function WallAnimationChannel2SingleAnimFinished()
{
    // End:0x5A
    if((m_activeWallAnimChannel == 1) && m_wallAnimChannelData[m_activeWallAnimChannel].MCBName == 'SingleAnim')
    {
        // End:0x52
        if(m_wallMovementData.bExecutingTransition)
        {
            WallTransitionFinished();            
        }
        else
        {
            ArrivedAtWallPathEnd(true, true);
        }
    }
    //return;    
}

simulated function SetFourWayWallAnimation(name NodeName, name forwardName, name backwardName, name leftName, name rightName)
{
    local SPAnimBlendDirectionalNode fourWayNode;
    local AnimNodeSequence Seq;

    // End:0x1C3
    if((Mesh != none) && Mesh.Animations != none)
    {
        fourWayNode = SPAnimBlendDirectionalNode(Mesh.Animations.FindAnimNode(NodeName));
        // End:0x1A3
        if(fourWayNode != none)
        {
            Seq = AnimNodeSequence(fourWayNode.Children[0].Anim);
            // End:0xA3
            if(Seq != none)
            {
                Seq.SetAnim(forwardName, false);
            }
            // End:0x1A0
            if(fourWayNode.Children.Length >= 4)
            {
                Seq = AnimNodeSequence(fourWayNode.Children[1].Anim);
                // End:0x106
                if(Seq != none)
                {
                    Seq.SetAnim(backwardName, false);
                }
                Seq = AnimNodeSequence(fourWayNode.Children[2].Anim);
                // End:0x153
                if(Seq != none)
                {
                    Seq.SetAnim(leftName, false);
                }
                Seq = AnimNodeSequence(fourWayNode.Children[3].Anim);
                // End:0x1A0
                if(Seq != none)
                {
                    Seq.SetAnim(rightName, false);
                }
            }            
        }
        m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'FourWayAnim';
    }
    //return;    
}

simulated function bool StartWallTransitionAnimations()
{
    local name transName;

    SetSpiderMovementType();
    SetMovementPhysics();
    m_wallRegistrationNode = none;
    m_wallMovementData.bExecutingTransition = true;
    // End:0x130
    if(m_wallMovementData.TransitionData.currentTransition < m_wallMovementData.TransitionData.TransitionList.Length)
    {
        transName = m_wallMovementData.TransitionData.TransitionList[m_wallMovementData.TransitionData.currentTransition].transitionAnimName;
        m_activeWallAnimChannel = GetFreeWallAnimationChannel();
        m_wallAnimChannelData[m_activeWallAnimChannel].bReset = true;
        // End:0xF0
        if(transName == 'None')
        {
            return false;
        }
        // End:0x116
        if(m_activeWallAnimChannel == 0)
        {
            SetSingleWallAnimation('WallAnimationChannel1Single', transName);            
        }
        else
        {
            SetSingleWallAnimation('WallAnimationChannel2Single', transName);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function StartWallMovementAnimations()
{
    local SPAWallAnimation wallData;

    SetSpiderMovementType();
    SetMovementPhysics();
    m_wallRegistrationNode = none;
    wallData = m_wallMovementData.wallAnimData;
    m_wallMovementData.bExecutingTransition = false;
    m_activeWallAnimChannel = GetFreeWallAnimationChannel();
    m_wallAnimChannelData[m_activeWallAnimChannel].bReset = true;
    // End:0x8A
    if(wallData.MainAnimationName == 'None')
    {
    }
    // End:0x120
    if(m_activeWallAnimChannel == 0)
    {
        // End:0xCE
        if(m_wallMovementData.bIsSingleAnim)
        {
            SetSingleWallAnimation('WallAnimationChannel1Single', wallData.MainAnimationName);            
        }
        else
        {
            SetFourWayWallAnimation('WallAnimationChannel1FourWay', wallData.MainAnimationName, wallData.BackwardAnimation, wallData.LeftAnimation, wallData.RightAnimation);
        }        
    }
    else
    {
        // End:0x159
        if(m_wallMovementData.bIsSingleAnim)
        {
            SetSingleWallAnimation('WallAnimationChannel2Single', wallData.MainAnimationName);            
        }
        else
        {
            SetFourWayWallAnimation('WallAnimationChannel2FourWay', wallData.MainAnimationName, wallData.BackwardAnimation, wallData.LeftAnimation, wallData.RightAnimation);
        }
    }
    //return;    
}

function SetSingleWallIdleAnimation(name NodeName, name AnimName)
{
    local SPAnimNodeSequence Seq;

    // End:0x94
    if((Mesh != none) && Mesh.Animations != none)
    {
        Seq = SPAnimNodeSequence(Mesh.Animations.FindAnimNode(NodeName));
        // End:0x94
        if(Seq != none)
        {
            Seq.SetAnim(AnimName, false);
            m_wallAnimChannelData[m_activeWallAnimChannel].MCBName = 'IdleAnim';            
        }
    }
    //return;    
}

event StopWallMovementAnimation()
{
    // End:0x96
    if(!m_wallMovementData.bIsSingleAnim && m_wallMovementData.wallAnimData != none)
    {
        // End:0x69
        if(m_activeWallAnimChannel == 0)
        {
            SetSingleWallIdleAnimation('WallAnimationChannel1Idle', m_wallMovementData.wallAnimData.IdleAnimation);            
        }
        else
        {
            SetSingleWallIdleAnimation('WallAnimationChannel2Idle', m_wallMovementData.wallAnimData.IdleAnimation);
        }
    }
    //return;    
}

simulated function name WallAnimationChannelSelectMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    // End:0x33
    if(m_wallAnimChannelData[m_activeWallAnimChannel].bReset)
    {
        m_wallAnimChannelData[m_activeWallAnimChannel].bReset = false;
    }
    // End:0x50
    if(m_activeWallAnimChannel == 0)
    {
        retval = 'Channel1';        
    }
    else
    {
        retval = 'Channel2';
    }
    return retval;
    //return ReturnValue;    
}

simulated function name WallAnimationChannel1MCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_wallAnimChannelData[0].MCBName;
    //return ReturnValue;    
}

simulated function name WallAnimationChannel2MCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return m_wallAnimChannelData[1].MCBName;
    //return ReturnValue;    
}

function StingingDone()
{
    local SPBloodTickAIController MyController;

    TakeDamageAndProcEffects(float(Health) + m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.HitPoints), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PandoraDamageType',, self);
    MyController = SPBloodTickAIController(Controller);
    // End:0x7F
    if(MyController != none)
    {
        MyController.NotifyDying();
    }
    //return;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

event HitByDamagePulse(const out Vector Origin, float normalizedStrength, class<DamageType> DamageType)
{
    local float DestructTime;

    super.HitByDamagePulse(Origin, normalizedStrength, DamageType);
    // End:0x3D
    if(!ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse') && !ClassIsChildOf(DamageType, Class'SPDamageTypeExplosionFireDrakeImmolate'))
    {
        return;
    }
    DestructTime = FRand();
    // End:0xAC
    if(IsTimerActive('TriggerDestruction') && DestructTime < (GetTimerRate('TriggerDestruction') - GetTimerCount('TriggerDestruction')))
    {
        ClearTimer('TriggerDestruction');
        SetTimer(DestructTime, false, 'TriggerDestruction');        
    }
    else
    {
        SetTimer(DestructTime, false, 'TriggerDestruction');
    }
    //return;    
}

function IsInsideDamagePulse(const out Vector Origin, float normalizedStrength, class<DamageType> DamageType)
{
    local Vector pushDir;

    // End:0x28
    if(!ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse') && !ClassIsChildOf(DamageType, Class'SPDamageTypeExplosionFireDrakeImmolate'))
    {
        return;
    }
    pushDir = Location - Origin;
    pushDir.Z = 0.0000000;
    pushDir = Normal(pushDir);
    ExternalVelocity = pushDir * ((normalizedStrength * 10000.0000000) + float(2000));
    //return;    
}

function SetBloodTickDestruct()
{
    local SPBloodTickAIController MyController;

    MyController = SPBloodTickAIController(Controller);
    // End:0x2F
    if(MyController != none)
    {
        MyController.TimerToExplodeFromPawn();
    }
    //return;    
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
            // End:0x75
            break;
        // End:0x72
        case 1:
            retval = 'Stinging';
            // End:0x75
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

simulated function name ActionTypeSacInflateAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
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
    switch(m_sacInflateState)
    {
        // End:0x5B
        case 0:
            retval = 'Idle';
            // End:0x8C
            break;
        // End:0x72
        case 1:
            retval = 'Inflating';
            // End:0x8C
            break;
        // End:0x89
        case 2:
            retval = 'Inflated';
            // End:0x8C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

simulated function float SacAttackBodySplitPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    childWeights[1] = 1.0000000;
    return 1.0000000;
    //return ReturnValue;    
}

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

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    GetBloodTickDifficultyData();
    //return;    
}

simulated function PostBeginPlay()
{
    local float SpeedRange;

    super.PostBeginPlay();
    SetMovementPhysics();
    // End:0x13B
    if(m_BloodTickGDTuneData.UseRandomInitialSpeed)
    {
        // End:0x94
        if(m_BloodTickGDTuneData.InitialSpeedRange > (m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.MovementSpeed) * 1.5000000))
        {
            SpeedRange = m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.MovementSpeed) * 1.5000000;            
        }
        else
        {
            SpeedRange = m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.MovementSpeed);
        }
        m_movementTypeInfo[0].GroundSpeed = ((FRand() * SpeedRange) - (SpeedRange * 0.5000000)) + m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.MovementSpeed);
        m_movementTypeInfo[1].GroundSpeed = m_movementTypeInfo[0].GroundSpeed - 50.0000000;        
    }
    else
    {
        m_movementTypeInfo[0].GroundSpeed = m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.MovementSpeed);
        m_movementTypeInfo[1].GroundSpeed = m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.MovementSpeed) - 50.0000000;
    }
    SetMovementType(2);
    //return;    
}

function ManualDelay()
{
    m_bIsDoneSleeping = true;
    TakeDamageAndProcEffects(0.0000000, none, vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), Class'SPDamageTypeImpactFlame',, self);
    //return;    
}

function TriggerDestructionFromFlameSpread()
{
    TriggerDestruction();
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local editinline SPActorDestructComponent destruct;

    // End:0x13
    if(DamageType == Class'SPDamageTypeBloodTickExplosion')
    {
        return;
    }
    // End:0xB8
    if(DamageType == Class'SPDamageTypeImpactFlame')
    {
        // End:0x80
        if(m_bIsDoneSleeping)
        {
            m_bHasTakenFlameDamage = true;
            BloodTickHurtRadius(DamageType, true, m_BloodTickGDTuneData.FireSpreadRange, 1.0000000, Location);
            TriggerFlameDestructionSystem();
            SetTimer(0.0100000, false, 'TriggerDestructionFromFlameSpread');
            return;            
        }
        else
        {
            // End:0xA3
            if(DamageAmount > float(0))
            {
                SetTimer(0.0100000, false, 'ManualDelay');                
            }
            else
            {
                SetTimer(0.5000000, false, 'ManualDelay');
            }
            return;
        }
    }
    super.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x152
    if((Health <= 0) && !m_bStingAttack)
    {
        BloodTickHurtRadius(Class'SPDamageTypeBloodTickExplosion', false, m_BloodTickGDTuneData.ImpulseRange, 1.0000000, Location);
        destruct = SPActorDestructComponent(GetActorDestructComponent());
        // End:0x152
        if(destruct != none)
        {
            destruct.AutoTrigger = true;
        }
    }
    //return;    
}

function BloodTickHurtRadius(class<DamageType> DamageType, bool bUseFlameDestruct, float DamageRadius, float Momentum, Vector HurtOrigin, optional Controller InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage)
{
    local Actor Victim;

    // End:0x1BD
    foreach VisibleCollidingActors(Class'Engine.Actor', Victim, DamageRadius, HurtOrigin)
    {
        // End:0x13F
        if(!bUseFlameDestruct)
        {
            // End:0x13C
            if((Victim != self) && Victim.IsA('SPBloodTickPawnPersistent') == false)
            {
                // End:0xE5
                if(Victim.IsA('PlayerPawn') == true)
                {
                    Victim.TakeRadiusDamage(InstigatedByController, m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.DamageVSPlayer), DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);                    
                }
                else
                {
                    Victim.TakeRadiusDamage(InstigatedByController, m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.DamageVSAI), DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);
                }
            }
            // End:0x1BC
            continue;
        }
        // End:0x1BC
        if(((Victim != self) && Victim.IsA('SPBloodTickPawnPersistent') == true) && !SPPawn(Victim).m_bHasTakenFlameDamage)
        {
            Victim.TakeRadiusDamage(InstigatedByController, 0.0000000, DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);
        }        
    }    
    //return;    
}

function TriggerFlameDestructionSystem()
{
    local Emitter E;

    E = Spawn(Class'Engine.EmitterSpawnable',,, Location, Rotator(vect(0.0000000, 0.0000000, 0.0000000)));
    // End:0x9C
    if(E != none)
    {
        E.SetTemplate(ExplodeParticleTemplate, true);
        E.bDestroyOnSystemFinish = true;
        E.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
        E.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

function TriggerDestruction()
{
    // End:0x1B
    if(ExplosionSound != none)
    {
        PlaySound(ExplosionSound, true);
    }
    TakeDamageAndProcEffects(float(Health) + m_BloodTickGDTuneData.GetValue(m_BloodTickGDTuneData.HitPoints), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PandoraDamageType',, self);
    //return;    
}

function ApplyDamageImpulse(Vector pos, float DamageAmount, float Radius, class<DamageType> DamageType)
{
    ExplodeDamageActor = Spawn(Class'SPDImpulseActor',,, pos);
    ExplodeDamageActor.ImpulseComponent.ImpulseFalloff = 1;
    ExplodeDamageActor.ImpulseComponent.ImpulseStrength = m_BloodTickGDTuneData.ImpulseStrength;
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
Begin:

    SetNovodexBoundingVolume(false);
    m_bEnablePhysicsPushing = false;
    stop;                    
}
