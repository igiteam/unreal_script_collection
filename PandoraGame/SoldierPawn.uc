class SoldierPawn extends HumanPawn
    native
    config(Game);

enum eHitDirection
{
    eHitLeft,                       // 0
    eHitRight,                      // 1
    eHitForward,                    // 2
    eHitBack,                       // 3
    eHitDownLeft,                   // 4
    eHitDownRight,                  // 5
    eHitDownForward,                // 6
    eHitDownBack,                   // 7
    eHitNone,                       // 8
    eHitDirection_MAX               // 9
};

enum ESoldierPawnActionState
{
    ESPACTION_NORMAL,               // 0
    ESPACTION_WEREWOLFSLAM,         // 1
    ESPACTION_WEREWOLFMAUL,         // 2
    ESPACTION_STARTGRIFFONMAUL,     // 3
    ESPACTION_ENDGRIFFONPOUNCE,     // 4
    ESPACTION_STARTGRIFFONPOUNCE,   // 5
    ESPACTION_GRIFFONMAULDEATH,     // 6
    ESPACTION_WEREWOLFMAULRECOVER,  // 7
    ESPACTION_KNOCKAWAY,            // 8
    ESPACTION_CARRIED,              // 9
    ESPACTION_GRABBEDBYTENTACLE,    // 10
    ESPACTION_THROWNBYTENTACLE,     // 11
    ESPACTION_MAX                   // 12
};

enum ESoldierPawnFireBurnDeathState
{
    ESPFIREBURN_BURN,               // 0
    ESPFIREBURN_DEATH,              // 1
    ESPFIREBURN_MAX                 // 2
};

enum ESoldierPawnMaterialState
{
    ESPMS_Normal,                   // 0
    ESPMS_Burned,                   // 1
    ESPMS_MAX                       // 2
};

var name m_animDamagedBone;
var bool m_bRestartHitState;
var bool m_bRestartActionStateAnim;
var bool m_bActionStateAnimFinished;
var bool m_bChangeBurnedMaterial;
var bool m_deathWasKneeling;
/** Is the AI kneeling or standing? */
var(AI) bool m_bKneel;
var bool m_bForceWeaponFiringAnimationToReset;
var bool m_bClearForceWeaponFiringAnimationToReset;
var bool m_bHasCheckedForGrenades;
var bool m_bIsThrowingGrenade;
var bool m_bCanPlaySounds;
var float m_headShotDamageMultiplier;
var SoldierPawn.ESoldierPawnActionState m_actionState;
var SoldierPawn.ESoldierPawnFireBurnDeathState m_burnState;
var SoldierPawn.eHitDirection m_hitDirection;
var CoverLink.ECoverType m_deathCoverType;
var CoverLink.ECoverAction m_deathCoverAction;
var SPPawn.eKnockDirection m_knockDirection;
var name m_takeDamageBone;
var MaterialInterface m_burnedMaterial;
var MaterialInstanceConstant m_burnedMaterialInstance;
var float m_maxBurnedTimeOut;
var float m_BurnedTimeOut;
var float m_burnedTimeDelay;
var Vector m_deathVelocity;
var SPGameDifficultyTuneSoldier m_SoldierGDData;
var(AI) float MinShootDist;
var(AI) float MaxShootDist;
var SPGrenadeLauncherPersistentNPC m_grenadeWeapon;
var SoundCue GrenadeAlertSoundCue;
var float m_upperBodyCurrentBlendModifier;
var float m_upperBodyTargetBlendModifier;

// Export USoldierPawn::execGetCurrentWeaponStateGrenadeActionName(FFrame&, void* const)
native function name GetCurrentWeaponStateGrenadeActionName();

// Export USoldierPawn::execGetSightRadiusForActor(FFrame&, void* const)
native function float GetSightRadiusForActor(Actor inActor);

// Export USoldierPawn::execCanAttackActorAtAnyDistance(FFrame&, void* const)
native final function bool CanAttackActorAtAnyDistance(Actor inActor);

// Export USoldierPawn::execGetTargetLocation(FFrame&, void* const)
native simulated function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc, optional bool bVisionCheck);

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.CivilianGD;
    //return ReturnValue;    
}

function DBG_SoldierMsg(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

simulated event PostBeginPlay()
{
    super(SPPawn).PostBeginPlay();
    m_SoldierGDData = SPGameDifficultyTuneSoldier(GetMyGDData());
    HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
    // End:0x13B
    if(m_SoldierGDData != none)
    {
        Health = int(m_SoldierGDData.GetHitPoints());
        HealthMax = Health;
        m_headShotDamageMultiplier = m_SoldierGDData.GetHeadShotDamageMultiplier();
        m_SoldierGDData.GetMinRange(AimMinRange);
        m_SoldierGDData.GetMaxRange(AimMaxRange);
        MinShootDist = float(Clamp(int(m_SoldierGDData.GetMinShootDist()), 0, 5000));
        MaxShootDist = float(Clamp(int(m_SoldierGDData.GetMaxShootDist()), 0, 5000));
        // End:0x13B
        if(((Mesh != none) && Mesh.SkeletalMesh != none) && Mesh.SkeletalMesh.SkelMirrorTable.Length == 0)
        {
        }
    }
    //return;    
}

function OnPlaySceneAnimation(SeqAct_PlaySceneAnimation Action)
{
    HeadTrackComponent.m_GlobalTurnOffHeadTracking = false;
    super(SPPawn).OnPlaySceneAnimation(Action);
    //return;    
}

final function name GetHitLocationGroupByBoneName(name damagedBone)
{
    local int Index;

    // End:0x2A
    if(FindHitLocationGroupingByBoneName(damagedBone, Index))
    {
        return m_hitLocationGroupings[Index].GroupName;
    }
    return 'Default';
    //return ReturnValue;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local name HitLocationGroup;

    m_takeDamageBone = HitInfo.BoneName;
    SPAIController(Controller).ApplyDamageToTargetTable(EventInstigator, DamageAmount, true, m_SoldierGDData.GetValue(m_SoldierGDData.BroadcastDamageToSquadMemberRange));
    // End:0xFA
    if((DamageType != Class'SPDamageTypeMeleeAny') && DamageType != Class'SPDamageTypeAnimusPulse')
    {
        HitLocationGroup = GetHitLocationGroupByBoneName(m_takeDamageBone);
        // End:0xAB
        if(HitLocationGroup == 'head')
        {
            DamageAmount *= m_headShotDamageMultiplier;
        }
        // End:0xF2
        if(EventInstigator != none)
        {
            // End:0xEF
            if(!SPAIController(Controller).IsFriendly(EventInstigator))
            {
                AttemptPhysAnimState_Poking(EventInstigator.Pawn);
            }            
        }
        else
        {
            AttemptPhysAnimState_Poking(none);
        }
    }
    super(SPPawn).ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

final function RecordDeathVars(Controller Killer)
{
    local SPSoldierAIController MyController;
    local SPWeapon Weap;

    MyController = SPSoldierAIController(Controller);
    // End:0x44
    if(MyController.m_currentCover != none)
    {
        m_deathCoverType = MyController.m_currentCover.CoverType;
    }
    m_deathVelocity = Velocity;
    m_deathWasKneeling = m_bKneel;
    m_deathEnemyType = GetPawnTypeName(Killer.Pawn);
    m_deathEnemyRange = GetActorRange(Killer.Pawn, m_SoldierGDData.EnemyMaxNearRange, m_SoldierGDData.EnemyMaxMediumRange);
    // End:0x2A5
    if(int(Role) > int(ROLE_SimulatedProxy))
    {
        Weap = SPWeapon(Weapon);
        // End:0x29A
        if(Weap != none)
        {
            // End:0x125
            if((Weap.WeapID == 'None') || Weap.WeapID == 'Invalid')
            {
                m_deathWeapon = 0;
            }
            // End:0x14A
            if(Weap.WeapID == 'Flame')
            {
                m_deathWeapon = 3;
            }
            // End:0x16F
            if(Weap.WeapID == 'HK_UMP')
            {
                m_deathWeapon = 2;
            }
            // End:0x194
            if(Weap.WeapID == 'shotgun')
            {
                m_deathWeapon = 4;
            }
            // End:0x1B9
            if(Weap.WeapID == 'RocketLauncher')
            {
                m_deathWeapon = 5;
            }
            // End:0x1DE
            if(Weap.WeapID == 'AssaultRifle')
            {
                m_deathWeapon = 6;
            }
            // End:0x203
            if(Weap.WeapID == 'DummyWeapon')
            {
                m_deathWeapon = 1;
            }
            // End:0x228
            if(Weap.WeapID == 'NineMMPistol')
            {
                m_deathWeapon = 7;
            }
            // End:0x24D
            if(Weap.WeapID == 'DesertEagle')
            {
                m_deathWeapon = 8;
            }
            // End:0x272
            if(Weap.WeapID == 'FireAxe')
            {
                m_deathWeapon = 9;
            }
            // End:0x297
            if(Weap.WeapID == 'Saw')
            {
                m_deathWeapon = 10;
            }            
        }
        else
        {
            m_deathWeapon = 0;
        }        
    }
    else
    {
        m_deathWeapon = 0;
    }
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    // End:0x18
    if(class<SPDamageTypeImpactFlame>(DamageType) != none)
    {
        ChangeMaterial(1);
    }
    GotoState('Dying');
    bReplicateMovement = false;
    bTearOff = true;
    Velocity += TearOffMomentum;
    bPlayedDeath = true;
    //return;    
}

event bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    RecordDeathVars(Killer);
    return super(SPPawn).Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

final simulated function name DeathVelocityMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local float deathSpeed;

    deathSpeed = VSizeSq(m_deathVelocity);
    // End:0x34
    if(deathSpeed < (20.0000000 * 20.0000000))
    {
        return 'Stand';        
    }
    else
    {
        // End:0x57
        if(deathSpeed < (200.0000000 * 200.0000000))
        {
            return 'Walk';            
        }
        else
        {
            return 'Run';
        }
    }
    //return ReturnValue;    
}

final simulated function name HitDeathStateAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(m_hitDeathState)
    {
        // End:0x32
        case 1:
            // End:0x28
            if(m_bRestartHitState)
            {
                bResetChildOut = 1;
                m_bRestartHitState = false;                
            }
            return 'Hit';
        // End:0x37
        case 2:
        // End:0x61
        case 3:
            // End:0x57
            if(m_bRestartHitState)
            {
                bResetChildOut = 1;
                m_bRestartHitState = false;                
            }
            return 'Death';
        // End:0xFFFF
        default:
            return 'Normal';
            break;
    }
    //return ReturnValue;    
}

simulated function name GetHitLocationGroup()
{
    local int Index;

    // End:0x2A
    if(FindHitLocationGroupingByBoneName(m_animDamagedBone, Index))
    {
        return m_hitLocationGroupings[Index].GroupName;
    }
    return 'Default';
    //return ReturnValue;    
}

final simulated function name HitDeathLocationAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return GetHitLocationGroup();
    //return ReturnValue;    
}

final simulated function name ActionStateMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x18
    if(m_bRestartActionStateAnim)
    {
        bResetChildOut = 1;
        m_bRestartActionStateAnim = false;
    }
    switch(m_actionState)
    {
        // End:0x2F
        case 1:
            return 'WerewolfSlam';
        // End:0x3E
        case 2:
            return 'WerewolfMaul';
        // End:0x4D
        case 5:
            return 'StartGriffonPounce';
        // End:0x5C
        case 4:
            return 'EndGriffonPounce';
        // End:0x6B
        case 3:
            return 'GriffonMaul';
        // End:0x7A
        case 6:
            return 'GriffonMaulDeath';
        // End:0x89
        case 7:
            return 'WWMaulRecover';
        // End:0x98
        case 8:
            return 'KnockAway';
        // End:0xA7
        case 9:
            return 'Carried';
        // End:0xB6
        case 10:
            return 'GrabbedByTentacle';
        // End:0xC5
        case 11:
            return 'ThrownByTentacle';
        // End:0xFFFF
        default:
            return 'None';
            break;
    }
    //return ReturnValue;    
}

final simulated function name FireBurnDeathMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(m_burnState)
    {
        // End:0x17
        case 0:
            return 'Burn';
        // End:0x26
        case 1:
            return 'Death';
        // End:0xFFFF
        default:
            return 'Burn';
            break;
    }
    //return ReturnValue;    
}

final function StartGriffonPounceFinished()
{
    // End:0x31
    if(int(m_actionState) == int(5))
    {
        m_actionState = 0;
        SPAIController(Controller).StartGriffonPounceFinished();
    }
    //return;    
}

final function EndGriffonPounceFinished()
{
    // End:0x31
    if(int(m_actionState) == int(4))
    {
        m_actionState = 0;
        SPAIController(Controller).EndGriffonPounceFinished();
    }
    //return;    
}

simulated event bool IsFiringWeaponStateCallback(out int bResetAnim)
{
    // End:0x2A
    if(IsFiring())
    {
        // End:0x1D
        if(m_bForceWeaponFiringAnimationToReset)
        {
            bResetAnim = 1;
        }
        m_bClearForceWeaponFiringAnimationToReset = true;
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

final function FiringAnimationFinished()
{
    // End:0x20
    if(Controller != none)
    {
        SPSoldierAIController(Controller).super(SoldierPawn).FiringAnimationFinished();
    }
    // End:0x3F
    if(Weapon != none)
    {
        Weapon.RefireCheckTimer();
    }
    m_bForceWeaponFiringAnimationToReset = true;
    m_bClearForceWeaponFiringAnimationToReset = false;
    //return;    
}

final function SetAnimHitDeathState(SPPawn.EHitDeathState hitDeathState, optional bool bRestart)
{
    // End:0x2A
    if((int(m_hitDeathState) != int(hitDeathState)) || bRestart == true)
    {
        bRestart = true;
    }
    m_hitDeathState = hitDeathState;
    m_bRestartHitState = bRestart;
    m_animDamagedBone = m_takeDamageBone;
    //return;    
}

final function SetActionState(SoldierPawn.ESoldierPawnActionState actionState)
{
    // End:0x26
    if(int(m_actionState) != int(actionState))
    {
        m_bActionStateAnimFinished = false;
        m_bRestartActionStateAnim = false;        
    }
    else
    {
        m_bRestartActionStateAnim = true;
    }
    m_actionState = actionState;
    //return;    
}

final function ActionStateFinishedAnimCB()
{
    local SPSoldierAIController spSoldierAI;

    m_bActionStateAnimFinished = true;
    // End:0x42
    if(Controller != none)
    {
        spSoldierAI = SPSoldierAIController(Controller);
        // End:0x42
        if(spSoldierAI != none)
        {
            spSoldierAI.ActionStateAnimFinished();
        }
    }
    //return;    
}

final simulated function name LowCoverPopupTypeMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local SPSoldierAIController spSoldierAI;

    spSoldierAI = SPSoldierAIController(Controller);
    // End:0x3F
    if(spSoldierAI != none)
    {
        // End:0x3F
        if(int(spSoldierAI.m_currentCoverAction) == int(12))
        {
            return 'PopUpHigh';
        }
    }
    return 'Default';
    //return ReturnValue;    
}

final function bool IsInWereWolfSlamActionState()
{
    return ((int(m_actionState) == int(1)) || int(m_actionState) == int(2)) || int(m_actionState) == int(7);
    //return ReturnValue;    
}

event KnockEffect()
{
    local SPSoldierAIController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = SPSoldierAIController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.KnockEffect();
        }
    }
    //return;    
}

function PrepareForCATDefenseAnimationToStart()
{
    super(SPPawn).PrepareForCATDefenseAnimationToStart();
    //return;    
}

event Falling()
{
    //return;    
}

final simulated function bool ShouldUseWildFireAgainstPawn(SPPawn thePawn)
{
    local SPPawn.EEnemyRange rangeType;

    // End:0x0D
    if(thePawn == none)
    {
        return false;
    }
    switch(thePawn.m_eAIType)
    {
        // End:0x26
        case 2:
            return false;
        // End:0xFFFF
        default:
            rangeType = GetActorRange(thePawn, GetMaxNearRange(), GetMaxMediumRange(), true, GetMaxHeightDifferenceForAnimTreeRangeCheck());
            // End:0x6B
            if(int(rangeType) == int(2))
            {
                return false;
            }
            return true;
            break;
    }
    //return ReturnValue;    
}

final simulated function DetermineUpperBodyBlendTarget()
{
    local SPPlayerReplicationInfo repInfo;

    repInfo = SPPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x27
    if(IsReloading())
    {
        m_upperBodyTargetBlendModifier = 0.7500000;        
    }
    else
    {
        // End:0x69
        if((repInfo != none) && ShouldUseWildFireAgainstPawn(SPPawn(repInfo.EnemyPawn)))
        {
            m_upperBodyTargetBlendModifier = m_SoldierGDData.UpperBodyBlendModifierDuringWildfire;            
        }
        else
        {
            m_upperBodyTargetBlendModifier = 0.0000000;
        }
    }
    //return;    
}

final simulated function UpdateUpperBodyBlend(float DeltaTime)
{
    local float dif, blend;

    DetermineUpperBodyBlendTarget();
    // End:0x17
    if(DeltaTime == 0.0000000)
    {
        return;
    }
    blend = DeltaTime * 5.0000000;
    dif = m_upperBodyTargetBlendModifier - m_upperBodyCurrentBlendModifier;
    // End:0x6A
    if((dif >= 0.0000000) && dif > blend)
    {
        m_upperBodyCurrentBlendModifier += blend;        
    }
    else
    {
        // End:0x9B
        if((dif < 0.0000000) && dif > -blend)
        {
            m_upperBodyCurrentBlendModifier -= blend;            
        }
        else
        {
            m_upperBodyCurrentBlendModifier = m_upperBodyTargetBlendModifier;
        }
    }
    //return;    
}

final simulated function float UpperLowerSplitCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    // End:0x1E
    if(int(GetMovementType()) == int(18))
    {
        return 0.0000000;        
    }
    else
    {
        Node.m_globalWeightModifier = m_upperBodyCurrentBlendModifier;
        childWeights[1] = 1.0000000;
    }
    return 1.0000000;
    //return ReturnValue;    
}

event bool CanBeUsed(Pawn User)
{
    // End:0x5A
    if(User.IsA('PlayerPawn') && PandoraPlayerController(User.Controller) != none)
    {
        return PandoraPlayerController(User.Controller).AttemptPickupPawn(self, true);
    }
    return false;
    //return ReturnValue;    
}

event bool UsedBy(Pawn User)
{
    // End:0x5A
    if(User.IsA('PlayerPawn') && PandoraPlayerController(User.Controller) != none)
    {
        return PandoraPlayerController(User.Controller).AttemptPickupPawn(self, false);
    }
    return false;
    //return ReturnValue;    
}

function PlayHit(float Damage, Controller instigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
    local int Delta;
    local SPPawn.EHSDamageDirectionType damagedir;
    local Rotator HitDir;
    local Vector HitImpulse;
    local bool bDown;
    local SPPawn InstigatorPawn;

    super(Pawn).PlayHit(Damage, instigatedBy, HitLocation, DamageType, Momentum, HitInfo);
    // End:0x49
    if(instigatedBy != none)
    {
        InstigatorPawn = SPPawn(instigatedBy.Pawn);
    }
    // End:0x312
    if(((InstigatorPawn != none) && InstigatorPawn.IsA('SPBaseWerewolfPawnPersistent')) && DamageType == Class'SPDamageTypeMeleeAny')
    {
        damagedir = InstigatorPawn.GetDamageDirection();
        Delta = Rotation.Yaw - InstigatorPawn.Rotation.Yaw;
        HitDir.Yaw = Rotation.Yaw;
        HitDir.Pitch = 0;
        HitDir.Roll = 0;
        switch(damagedir)
        {
            // End:0x11D
            case 6:
            // End:0x122
            case 5:
            // End:0x136
            case 4:
                Delta += 16383;
                // End:0x15A
                break;
            // End:0x13B
            case 10:
            // End:0x140
            case 9:
            // End:0x154
            case 8:
                Delta -= 16383;
                // End:0x15A
                break;
            // End:0xFFFF
            default:
                // End:0x15A
                break;
                break;
        }
        // End:0x199
        if(((int(damagedir) == int(2)) || int(damagedir) == int(6)) || int(damagedir) == int(10))
        {
            bDown = true;            
        }
        else
        {
            bDown = false;
        }
        Delta = Delta & 65535;
        // End:0x1F2
        if((Delta < 8191) || Delta > 57344)
        {
            // End:0x1E7
            if(bDown)
            {
                m_hitDirection = 6;                
            }
            else
            {
                m_hitDirection = 2;
            }            
        }
        else
        {
            // End:0x248
            if((Delta > 8191) && Delta < 24574)
            {
                // End:0x226
                if(bDown)
                {
                    m_hitDirection = 4;                    
                }
                else
                {
                    m_hitDirection = 0;
                }
                HitDir.Yaw += 16383;                
            }
            else
            {
                // End:0x28D
                if(Delta > 57344)
                {
                    // End:0x26B
                    if(bDown)
                    {
                        m_hitDirection = 7;                        
                    }
                    else
                    {
                        m_hitDirection = 3;
                    }
                    HitDir.Yaw -= 32767;                    
                }
                else
                {
                    // End:0x2A1
                    if(bDown)
                    {
                        m_hitDirection = 5;                        
                    }
                    else
                    {
                        m_hitDirection = 1;
                    }
                    HitDir.Yaw -= 16383;
                }
            }
        }
        HitImpulse = Normal(Vector(HitDir)) * 5.0000000;
        // End:0x2F8
        if(!bDown)
        {
            HitImpulse.Z += 1.5000000;
        }
        Velocity = HitImpulse * 120.0000000;
        SetPhysics(2);        
    }
    else
    {
        m_hitDirection = 8;
    }
    //return;    
}

final simulated function name HitDirectionMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Direction;

    switch(m_hitDirection)
    {
        // End:0x1F
        case 4:
            Direction = 'DownLeft';
            // End:0xD5
            break;
        // End:0x36
        case 0:
            Direction = 'Left';
            // End:0xD5
            break;
        // End:0x4D
        case 5:
            Direction = 'DownRight';
            // End:0xD5
            break;
        // End:0x64
        case 1:
            Direction = 'Right';
            // End:0xD5
            break;
        // End:0x7B
        case 6:
            Direction = 'DownForward';
            // End:0xD5
            break;
        // End:0x92
        case 2:
            Direction = 'Forward';
            // End:0xD5
            break;
        // End:0xA9
        case 7:
            Direction = 'DownBack';
            // End:0xD5
            break;
        // End:0xC0
        case 3:
            Direction = 'Back';
            // End:0xD5
            break;
        // End:0xFFFF
        default:
            Direction = 'None';
            // End:0xD5
            break;
            break;
    }
    return Direction;
    //return ReturnValue;    
}

final function ChangeMaterial(SoldierPawn.ESoldierPawnMaterialState matState)
{
    // End:0x3F
    if(Mesh != none)
    {
        switch(matState)
        {
            // End:0x1B
            case 0:
                // End:0x3F
                break;
            // End:0x39
            case 1:
                // End:0x36
                if(m_burnedMaterial != none)
                {
                    m_burnedTimeDelay = 2.0000000;
                }
                // End:0x3F
                break;
            // End:0xFFFF
            default:
                // End:0x3F
                break;
                break;
        }
    }
    //return;    
}

final event bool HasGrenades()
{
    local array<SPWeapon> WeaponList;
    local SPGrenadeLauncherPersistentNPC grenadeWeapon;
    local int I;

    // End:0x12
    if(m_bHasCheckedForGrenades)
    {
        return m_grenadeWeapon != none;
    }
    m_bHasCheckedForGrenades = true;
    m_grenadeWeapon = none;
    // End:0xAA
    if(SPInventoryManager(InvManager) != none)
    {
        SPInventoryManager(InvManager).GetWeaponList(WeaponList);
        I = 0;
        J0x56:

        // End:0xAA [Loop If]
        if(I < WeaponList.Length)
        {
            grenadeWeapon = SPGrenadeLauncherPersistentNPC(WeaponList[I]);
            // End:0xA0
            if(grenadeWeapon != none)
            {
                // End:0xA0
                if(m_grenadeWeapon == none)
                {
                    m_grenadeWeapon = grenadeWeapon;
                    // [Explicit Continue]
                }
            }
            I++;
            // [Loop Continue]
            goto J0x56;
        }
    }
    return m_grenadeWeapon != none;
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    super(SPPawn).Tick(DeltaTime);
    ServerTick_SoldierPawn(DeltaTime);
    // End:0x2F
    if(m_bClearForceWeaponFiringAnimationToReset)
    {
        m_bForceWeaponFiringAnimationToReset = false;
        m_bClearForceWeaponFiringAnimationToReset = false;
    }
    UpdateUpperBodyBlend(DeltaTime);
    //return;    
}

final function ServerTick_SoldierPawn(float DeltaTime)
{
    // End:0x39
    if(m_burnedTimeDelay > float(0))
    {
        m_burnedTimeDelay -= DeltaTime;
        // End:0x39
        if(m_burnedTimeDelay <= float(0))
        {
            m_bChangeBurnedMaterial = true;
            m_burnedTimeDelay = 0.0000000;
        }
    }
    // End:0xDF
    if(m_bChangeBurnedMaterial)
    {
        // End:0x5D
        if(m_burnedMaterialInstance == none)
        {
            m_burnedMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
        }
        m_burnedMaterialInstance.SetParent(m_burnedMaterial);
        m_burnedMaterialInstance.SetScalarParameterValue('Alpha', 1.0000000);
        m_BurnedTimeOut = m_maxBurnedTimeOut;
        Mesh.SetMaterial(0, m_burnedMaterialInstance);
        Mesh.SetMaterial(1, m_burnedMaterialInstance);
        m_bChangeBurnedMaterial = false;
    }
    // End:0xFD
    if((m_burnedMaterialInstance == none) || m_BurnedTimeOut == 0.0000000)
    {
        return;
    }
    // End:0x142
    if(m_BurnedTimeOut > float(0))
    {
        m_BurnedTimeOut -= DeltaTime;
        m_burnedMaterialInstance.SetScalarParameterValue('Alpha', m_BurnedTimeOut / m_maxBurnedTimeOut);        
    }
    else
    {
        m_BurnedTimeOut = 0.0000000;
        m_burnedMaterialInstance.SetScalarParameterValue('Alpha', 0.0000000);
    }
    //return;    
}

function SetStateForAttachedTentacle(bool isAttaching)
{
    // End:0x3C
    if((Controller != none) && SPSoldierAIController(Controller) != none)
    {
        SPSoldierAIController(Controller).SetAttachedTentacle(isAttaching);
    }
    //return;    
}

event TentacleThrowing()
{
    SetActionState(11);
    //return;    
}

final simulated function name StandKneelMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local bool bKneel;

    // End:0x19
    if(bPlayedDeath)
    {
        bKneel = m_deathWasKneeling;        
    }
    else
    {
        bKneel = m_bKneel;
    }
    // End:0x3C
    if(bKneel)
    {
        return 'Kneel';        
    }
    else
    {
        return 'Stand';
    }
    //return ReturnValue;    
}

final simulated function name BreakMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x2F
    if(Controller != none)
    {
        // End:0x2F
        if(Controller.IsInState('Break'))
        {
            return 'Break';
        }
    }
    return 'Normal';
    //return ReturnValue;    
}

final function StartThrowingGrenade()
{
    m_bIsThrowingGrenade = true;
    //return;    
}

final function StopThrowingGrenade()
{
    m_bIsThrowingGrenade = false;
    //return;    
}

simulated event GrenadeThrowAnimFinished()
{
    SPSoldierAIController(Controller).GrenadeThrowAnimFinished();
    StopThrowingGrenade();
    //return;    
}

simulated event NotifyTakeOutGrenade()
{
    // End:0x0D
    if(m_grenadeWeapon == none)
    {
        return;
    }
    m_grenadeWeapon.AttachWeapon(Mesh, 'JO_prop');
    SPSoldierAIController(Controller).NotifyTakeOutGrenade();
    //return;    
}

simulated event NotifyThrowGrenade()
{
    // End:0x0D
    if(m_grenadeWeapon == none)
    {
        return;
    }
    m_grenadeWeapon.DetachWeapon();
    SPSoldierAIController(Controller).NotifyThrowGrenade();
    //return;    
}

simulated event name GetAimNodeProfileName()
{
    local SPWeapon Weap;

    Weap = SPWeapon(Weapon);
    // End:0x2B
    if(Weap != none)
    {
        return Weap.AimNodeProfileName;
    }
    return super(SPPawn).GetAimNodeProfileName();
    //return ReturnValue;    
}

final simulated function name AimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x15
    if(Controller == none)
    {
        return 'None';
    }
    return SPSoldierAIController(Controller).GetAimQuadrant();
    //return ReturnValue;    
}

final simulated function name KnockDirectionMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Direction;

    Direction = 'Forward';
    switch(m_knockDirection)
    {
        // End:0x2E
        case 0:
            Direction = 'Left';
            // End:0x5F
            break;
        // End:0x45
        case 1:
            Direction = 'Right';
            // End:0x5F
            break;
        // End:0x5C
        case 2:
            Direction = 'Forward';
            // End:0x5F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return Direction;
    //return ReturnValue;    
}

final simulated function YellGrenadeAlert()
{
    // End:0x1B
    if(GrenadeAlertSoundCue != none)
    {
        PlaySound(GrenadeAlertSoundCue);
    }
    //return;    
}

state Dying
{
    event PushedState()
    {
        super(Object).PushedState();
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        super.PoppedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        //return;        
    }

    simulated function SetMovementPhysics()
    {
        // End:0x16
        if(int(Physics) != int(10))
        {
            super(SPPawn).SetMovementPhysics();
        }
        //return;        
    }

    function StartDying()
    {
        local SPSoldierAIController spSoldierAI;

        // End:0x33
        if(bTearOff && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            LifeSpan = 2.0000000;            
        }
        else
        {
            // End:0x6B
            if(m_DeathTimeout == 0.0000000)
            {
                m_DeathTimeout = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.CorpseLifetime);
            }
            SetTimer(1.0000000, false, 'CheckIfWeShouldDie');
        }
        SetCollision(true, false);
        spSoldierAI = SPSoldierAIController(Controller);
        // End:0xB6
        if(spSoldierAI != none)
        {
            spSoldierAI.NotifyDying();            
        }
        else
        {
            // End:0xEF
            if(Controller != none)
            {
                // End:0xE2
                if(Controller.bIsPlayer)
                {
                    DetachFromController();                    
                }
                else
                {
                    Controller.Destroy();
                }
            }
        }
        //return;        
    }

    function EndDying()
    {
        local int I;
        local SPSoldierAIController spSoldierAI;

        spSoldierAI = SPSoldierAIController(Controller);
        // End:0x5D
        if(spSoldierAI != none)
        {
            spSoldierAI.NotifyDied();
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

    PawnDeathDestructiblePropertyCheck();
    StartDying();
    SetAnimHitDeathState(3);
    // End:0x52
    if(m_bThrowDeath)
    {
        AttemptPhysAnimState_Ragdoll();
        CollisionComponent.AddImpulse(m_DeathThrowDirection * m_DeathThrowImpulse,,, true);        
    }
    SetNovodexBoundingVolume(false);
    m_bEnablePhysicsPushing = false;
    EndDying();
    HandleBodyCleanup();
    stop;            
}

state Ragdoll
{
    function BeginState(name PreviousStateName)
    {
        Mesh.bUpdateAnimTree = false;
        SPAIController(Controller).DisableAI();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Mesh.bUpdateAnimTree = true;
        //return;        
    }
    stop;    
}
