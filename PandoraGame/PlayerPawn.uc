class PlayerPawn extends HumanPawn
    native
    config(Game);

const THROW_WEAPON_PRIMING_THRESHHOLD = 0.3;
const MAX_TIME_BETWEEN_PLAYER_HIT_SOUNDS = 0.5;

enum EPlayerTagFadeMode
{
    PTFM_OFF,                       // 0
    PTFM_FADEIN,                    // 1
    PTFM_FADEOUT,                   // 2
    PTFM_MAX                        // 3
};

enum EHandEffect
{
    HEFFECT_NOT_SIPHONING,          // 0
    HEFFECT_SIPHONING,              // 1
    HEFFECT_MAX                     // 2
};

enum ePlayerFireAxeDirection
{
    ePlayerFireAxeSwipeFailSafe,    // 0
    ePlayerFireAxeSwipeL,           // 1
    ePlayerFireAxeSwipeLUP45,       // 2
    ePlayerFireAxeNone,             // 3
    ePlayerFireAxeDirection_MAX     // 4
};

enum EGrenadeState
{
    eGSNone,                        // 0
    eGSPriming,                     // 1
    eGSThrowingOverhand,            // 2
    eGSThrowingUnderhand,           // 3
    EGrenadeState_MAX               // 4
};

enum eAmBxCompassDir
{
    amBXDir_Center,                 // 0
    amBXDir_North,                  // 1
    amBXDir_NorthEast,              // 2
    amBXDir_East,                   // 3
    amBXDir_SouthEast,              // 4
    amBXDir_South,                  // 5
    amBXDir_SouthWest,              // 6
    amBXDir_West,                   // 7
    amBXDir_NorthWest,              // 8
    amBXDir_MAX                     // 9
};

enum ADSTransitionState
{
    ADS_TRASITION_STATE_NOT_TRANSITIONING,// 0
    ADS_TRASITION_STATE_TRANSITIONING_INTO_ADS,// 1
    ADS_TRASITION_STATE_TRANSITIONING_OUT_OF_ADS,// 2
    ADS_TRASITION_STATE_MAX         // 3
};

struct native InputSettingsData
{
    var() float playerForwardSpeed;
    var() float playerBackwardSpeed;
    var() float playerStrafeSpeed;

    structdefaultproperties
    {
        playerForwardSpeed=0.0000000
        playerBackwardSpeed=0.0000000
        playerStrafeSpeed=0.0000000
    }
};

struct native PlayerNameTagInfo
{
    var Actor TheActor;
    var string PlayerName;
    var LinearColor RenderColor;
    var LinearColor CurrentColor;
    var PlayerPawn.EPlayerTagFadeMode FadeMode;
    var float LastUpdateTime;
    var bool bRender;

    structdefaultproperties
    {
        TheActor=none
        PlayerName=""
        RenderColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
        CurrentColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
        FadeMode=PTFM_OFF
        LastUpdateTime=0.0000000
        bRender=false
    }
};

struct native ScratchInfo
{
    var MaterialInstanceConstant Material;
    var float Duration;
    var float FadeTime;
    var float Age;
    var Vector worldCoord;
    var bool screenCoordComputed;
    var float xLoc;
    var float yLoc;
    var float xOffset;
    var float yOffset;

    structdefaultproperties
    {
        Material=none
        Duration=0.0000000
        FadeTime=0.0000000
        Age=0.0000000
        worldCoord=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        screenCoordComputed=false
        xLoc=0.0000000
        yLoc=0.0000000
        xOffset=0.0000000
        yOffset=0.0000000
    }
};

/** The player is healing using animus vitae */
var(SP_SOUNDS) SoundCue mSoundCue_HealLoop;
/**  
 *not used
 *var(SP_SOUNDS)SoundCuemSoundCue_SiphonAnimusFull;// The player is stealing animus from a dead creature
 */
var(SP_SOUNDS) SoundCue mSoundCue_Siphon;
/** The player has just primed a flare grenadevar(SP_SOUNDS)SoundCuemSoundCue_MeleeHitPlayer; The player was hit by a melee attack OR thrown objectvar(SP_SOUNDS)SoundCuemSoundCue_BulletHitPlayer; The player was shot by a bullet */
var(SP_SOUNDS) SoundCue mSoundCue_FlareStrike;
/** The player is currently sprinting */
var(SP_SOUNDS) SoundCue mSoundCue_SprintLooping;
/** The post-transition effect that plays after a player active-heals + means verified to work */
var(SP_SOUNDS) SoundCue mSoundCue_HealFinished;
/** The player was killed by a bullet */
var(DEATH_SOUNDS) SoundCue deathSound_Bullet;
/** The player was killed by a explosion */
var(DEATH_SOUNDS) SoundCue deathSound_Explosion;
/** The player was killed by falling damage */
var(DEATH_SOUNDS) SoundCue deathSound_Fall;
/** The player was killed by fire */
var(DEATH_SOUNDS) SoundCue deathSound_Fire;
/** The player was killed by a melee attack */
var(DEATH_SOUNDS) SoundCue deathSound_Melee;
/** The player was killed by a thrown object */
var(DEATH_SOUNDS) SoundCue deathSound_Object;
/** The player was killed by a golem/kraken */
var(DEATH_SOUNDS) SoundCue deathSound_Smash;
/** The player was killed by a sewer tentacle */
var(DEATH_SOUNDS) SoundCue deathSound_Tentacle;
/** The player was killed by electricity */
var(DEATH_SOUNDS) SoundCue deathSound_Zapped;
/** The player was killed by a bloodtick's explosion */
var(DEATH_SOUNDS) SoundCue deathSound_Bloodtick_Expl;
/** The player was killed by a train */
var(DEATH_SOUNDS) SoundCue deathSound_Train;
/** The player was damaged by a bullet */
var(DAMAGE_SOUNDS) SoundCue damageSound_Bullet;
/** The player was damaged by a explosion */
var(DAMAGE_SOUNDS) SoundCue damageSound_Explosion;
/** The player was damaged by falling damage */
var(DAMAGE_SOUNDS) SoundCue damageSound_Fall;
/** The player was damaged by fire */
var(DAMAGE_SOUNDS) SoundCue damageSound_Fire;
/** The player was damaged by a melee bite attack */
var(DAMAGE_SOUNDS) SoundCue damageSound_Melee_Bite;
/** The player was damaged by a melee bite attack */
var(DAMAGE_SOUNDS) SoundCue damageSound_Melee_Hit;
/** The player was damaged by a melee bite attack */
var(DAMAGE_SOUNDS) SoundCue damageSound_Melee_Slash;
/** The player was damaged by a thrown object */
var(DAMAGE_SOUNDS) SoundCue damageSound_Object;
/** The player was damaged by rubble */
var(DAMAGE_SOUNDS) SoundCue damageSound_Rubble;
/** The player was damaged by a golem/kraken */
var(DAMAGE_SOUNDS) SoundCue damageSound_Smash;
/** The player was damaged by a sewer tentacle */
var(DAMAGE_SOUNDS) SoundCue damageSound_Tentacle;
/** The player was damaged by a griffon */
var(DAMAGE_SOUNDS) SoundCue damageSound_Griffon;
/** The player was damaged by electricity */
var(DAMAGE_SOUNDS) SoundCue damageSound_Zapped;
/** The player was damaged by a bloodtick's explosion */
var(DAMAGE_SOUNDS) SoundCue damageSound_Bloodtick_Expl;
/** The player was killed by a fire drake spit attack */
var(DEATH_SOUNDS) SoundCue deathSound_FireDrakeSpit;
var(DAMAGE_SOUNDS) float FIRE_RETRIGGER_DELAY;
var float damageSoundReTrigger;
var EmitterSpawnable AnimusEmitter;
var float sinceLastHitSound;
var transient SPSkelControlPlayerPitch PitchSkelControlCache;
var float timeToRegen;
var float noRegenTimeAfterDamage;
var float noRegenTime;
var float timeSinceLastRegen;
var transient float MeleeFirstHitTime;
var Texture2D hitFromFrontTexture;
var float lastDamagedTime;
var float breakFreeRate;
var float breakFreeMax;
var bool bHealFade;
var bool bCalcJumpImpulseUsingMaxJumpHeight;
var bool m_bSiphoningFromAnimusDrain;
var bool m_bAnimusDrain;
var bool m_bInAnimusPulse;
var bool m_bHasReachedMaxLargeWeaponCount;
var bool bKnifeAttached;
var bool m_bEnableMultipleHits;
var bool m_bDoMultipleHit;
var bool m_bHandToHandFiring;
var bool m_bFireAxeStaticHit;
var bool m_bReloadFromAnimationFinished;
var bool m_bResetAction;
var bool m_bClearResetActionNextTick;
var bool m_bResetFireAnim;
var bool m_bClearResetFireAnimNextTick;
var bool m_bADSResetWeaponFire;
var bool m_bADSResetWeaponFireNextTick;
var transient bool SetCollectAnimNodeStatusNextTick;
var transient bool SetHealAnimNodeStatusNextTick;
var bool m_bFireAxeSuper;
var bool m_bFireAxeBlocking;
var bool m_bFiringSuperAttack;
var bool m_bFireAxeNotifyHit;
var bool m_bFireAxeButtonPress;
var bool m_bFireAxeReset;
var bool bUseViewportNames;
var bool m_bCanSprint;
var private transient bool bIsTryingToLookDownSite;
var bool bGrenadeFired;
var private bool bInSiphon;
var private bool bInHeal;
var bool bActiveHeal;
var bool bActiveCollect;
var bool m_bTentacleCollisionViewOn;
var config bool m_bAmBxLightSnifferUseStaticLights;
var config bool m_bAmBxLightSnifferUseDynamicLights;
var config bool m_bAmBxLightSnifferUseNormalLight;
var config bool m_bAmBxLightSnifferUseNonShadowLight;
var config bool m_bAmBxLightSnifferUseSkyLight;
var bool m_bPlayingAmBxAnimusCollectEffectScript;
var bool m_bPlayingAmBxAnimusHealEffectScript;
var bool m_bPlayingAmBxOutOfBreath;
var bool m_bFinishedPlayingAmBxOutOfBreath;
var bool IsSlavePawn;
var SPHud playerHud;
var float playerForwardSpeed;
var float playerBackwardSpeed;
var float playerStrafeSpeed;
var float playerDodgeSpeed;
var float playerDodgeUpSpeed;
var float playerSprintSpeedScale;
var float DodgeTimeLength;
var float DodgeTimeIntervalMin;
var float playerJumpImpulse;
var float playerMaxJumpHeight;
var float playerJumpHeight;
var float percentOfMoveSpeedUsedForJumpBoost;
var float minPercentageOfMaximumSpeedToApplyBoost;
var float percentOfMoveSpeedUsedForSprintJumpBoost;
var float SprintJumpCost;
var Vector StartJumpLocation;
var float MaxZAttainedDuringJump;
/** Length of time the dodge move takes. */
var(Dodge) config float playerDodgeTime;
/** Minimum time between each dodge. */
var(Dodge) config float playerDodgeDeltaTime;
/** The distance the dodge move should travel.Speed modifier */
var(Dodge) config float playerDodgeDistance;
var float CrouchSpeedMult;
var float DownSiteSpeedMult;
var float CrouchDownSiteSpeedMult;
var(PlayerPhysics) config float playerMaxStepHeight;
var native transient Matrix ScratchPadInverseCameraMat;
var const localized string WordFor;
var const localized string WordsPickupWeaponMessage;
var export editinline PointLightComponent siphonLight;
var float RefSiphonTime;
var export editinline PointLightComponent healLight;
var float RefHealTime;
var float partialHealthRestore;
var(LifeForce) float LifeForce;
var(LifeForce) float maxLifeForce;
var MaterialInstanceConstant HandMaterialInst;
var float handEffectValue;
var PlayerPawn.EHandEffect lastHandEffect;
var PlayerPawn.ePlayerFireAxeDirection m_fireAxeFailSafe;
var PlayerPawn.ePlayerFireAxeDirection m_fireAxeState;
var PlayerPawn.EGrenadeState m_eGrenadeState;
var private PlayerPawn.ADSTransitionState ADSTransitionStatus;
var export editinline AudioComponent AudioComp_HealLoop;
var export editinline AudioComponent AudioComp_Siphon;
var export editinline AudioComponent AudioComp_BloodHUDSplatter;
var SoundCue mSoundCue_BloodHUDSplatterLoop;
var transient float handEffectDeltaMult;
var float m_nextCanAnimusPulseTime;
var SPTuneDataPlayer m_PlayerTuneData;
var SPGameDifficultyTunePlayer m_PlayerGDTuneData;
var array<ScratchInfo> Scratches;
var export editinline AudioComponent Sound_Sprint_Breath_Looping;
var int InSprintAnimNodeStatus;
var class<SPWeapon> SwapToSPWeaponType;
var export editinline SPStaticMeshComponent KnifeComponent;
var float tackledWerewolfDuration;
var DynamicSMActor myDynamicObj;
var PostProcessChain DefaultPostProcessRef;
var PostProcessChain XenonDefaultPostProcessRef;
var MaterialEffect CurrentMaterialHitEffect;
var transient float CurrentHitEffectFadeTime;
var float MaxHitEffectFadeTime;
var DOFAndBloomEffect CurrentDOFHitEffect;
var float m_fForwardMovement;
var float m_fLateralMovement;
var transient int CollectAnimNodeStatus;
var transient int CollectAnimNodeStatusNextTick;
var transient int HealAnimNodeStatus;
var transient int HealAnimNodeStatusNextTick;
var export editinline AudioComponent m_FireAxeSuperAudioComponent;
var int redReticleCounter;
var int blueReticleCounter;
var int greenReticleCounter;
var LinearColor RED_Color;
var LinearColor GREEN_Color;
var LinearColor BLUE_Color;
var LinearColor WHITE_Color;
var LinearColor CharacterColor;
var PlayerPawn LastHighlightedPlayer;
var PlayerNameTagInfo PlayerNameTags[8];
var int CurNumPlayerTags;
var const int MaxNumPlayerTags;
var float FadeInIncr;
var float FadeOutIncr;
var export editinline AudioComponent ImpactSoundComponent;
var export editinline AudioComponent ImpactSoundComponent2;
var float RigidBodyImpactTime;
var float RigidBodyImpactSoundRefireDelay;
var Actor LastPushedObject;
var transient int DesiredAimPitch;
var export editinline SkeletalMeshComponent ThirdPersonMesh;
var export editinline SkeletalMeshComponent FirstPersonMesh;
var PathBlockingInfo m_pathBlockInfo;
var array<SPLifeForceHolder> ActiveLFStreams;
var export editinline SPBillboardComponent m_BillboardComponent;
var transient MultiExtentCollisionInfo MultiExtentCollision;
var Trigger m_currentlyHeldTrigger;
var float m_fWallHitTime;
var config float m_AmBxLightSnifferDistFromPawn;
var config float m_AmBxLightSnifferZOffPawn;
var config Vector m_AmBxLightSnifferSize;
var config float m_AmBxLightSnifferNormalLightFactor;
var config float m_AmBxLightSnifferNonShadowLightFactor;
var config float m_AmBxLightSnifferSkyLightFactor;
var config float m_AmBxLightSnifferHitWallReductionFactor;
var export editinline AmBxLightEnvironmentComponent m_NorthLightEnvironment;
var export editinline AmBxLightEnvironmentComponent m_NorthEastLightEnvironment;
var export editinline AmBxLightEnvironmentComponent m_EastLightEnvironment;
var export editinline AmBxLightEnvironmentComponent m_SouthEastLightEnvironment;
var export editinline AmBxLightEnvironmentComponent m_SouthLightEnvironment;
var export editinline AmBxLightEnvironmentComponent m_SouthWestLightEnvironment;
var export editinline AmBxLightEnvironmentComponent m_WestLightEnvironment;
var export editinline AmBxLightEnvironmentComponent m_NorthWestLightEnvironment;
var config float m_AmBxSnifferDistance;
var config float m_AmBxHighDamageEffectThreshold;
var config float m_AmBxMediumDamageEffectThreshold;
var float m_fAmBxAnimusProximityLast;
var config float m_fAmBxOutOfBreathPerc;
var config float m_fAmBxAnimusProximityEpoch;
var config float m_NStaticMinTimeBetweenFullUpdates;
var config float m_NEStaticMinTimeBetweenFullUpdates;
var config float m_EStaticMinTimeBetweenFullUpdates;
var config float m_SEStaticMinTimeBetweenFullUpdates;
var config float m_SStaticMinTimeBetweenFullUpdates;
var config float m_SWStaticMinTimeBetweenFullUpdates;
var config float m_WStaticMinTimeBetweenFullUpdates;
var config float m_NWStaticMinTimeBetweenFullUpdates;
var config float m_AmBxLightEnvironmentAbsIgnoreDist;
var config float m_AmBxLightEnvironmentGlobalDesaturate;
var private float LookDownSitePercent;
var private float LookDownSitePercentChangeRate;
var SPDamageIndicatorManager DamageIndicatorManager;
var init transient array<init SPLifeForceHolder> touchingLifeForceHolders;
var init transient array<init SPDroppedPickup> touchingDroppedPickups;
var init transient array<init SPWeaponPickupFactory> touchingWeaponPickupFactories;
var int HandMaterialIndex;

replication
{
    // Pos:0x000
    if(!bNetOwner
        ADSTransitionStatus, LookDownSitePercent;

    // Pos:0x008
    if(bNetDirty
        HealAnimNodeStatus, HealAnimNodeStatusNextTick, 
        LifeForce, SetHealAnimNodeStatusNextTick, 
        bInHeal, m_bAnimusDrain;

    // Pos:0x00E
    if(bNetDirty && !bNetOwner
        m_eGrenadeState;
}

// Export UPlayerPawn::execGetMasterPawn(FFrame&, void* const)
native function Pawn GetMasterPawn();

// Export UPlayerPawn::execGetSlavePawn(FFrame&, void* const)
native function Pawn GetSlavePawn();

// Export UPlayerPawn::execRemoteProcessLifeForceStreams(FFrame&, void* const)
native final function bool RemoteProcessLifeForceStreams(float DeltaTime);

// Export UPlayerPawn::execCheckForLifeForce(FFrame&, void* const)
native final function bool CheckForLifeForce(float DeltaTime);

// Export UPlayerPawn::execKillAttachedParticles(FFrame&, void* const)
native final function KillAttachedParticles();

// Export UPlayerPawn::execResetSignetHandEffect(FFrame&, void* const)
native final function ResetSignetHandEffect(optional bool bSiphon = true);

// Export UPlayerPawn::execShutdownSignetHandEffect(FFrame&, void* const)
native final function ShutdownSignetHandEffect(float DeltaTime);

// Export UPlayerPawn::execUpdateSignetHandEffect(FFrame&, void* const)
native final function UpdateSignetHandEffect(float DeltaTime);

// Export UPlayerPawn::execPlayerTestFn(FFrame&, void* const)
native function PlayerTestFn();

// Export UPlayerPawn::execUpdateReplicatedAim(FFrame&, void* const)
native function UpdateReplicatedAim(float DeltaTime, int NewPitch);

// Export UPlayerPawn::execSocketNameToBoneName(FFrame&, void* const)
native function name SocketNameToBoneName(SkeletalMeshComponent theMesh, name SName);

// Export UPlayerPawn::execSetScratchPadInverseCameraMatrix(FFrame&, void* const)
native function SetScratchPadInverseCameraMatrix();

// Export UPlayerPawn::execGetLocalToCameraPosition(FFrame&, void* const)
native function Vector GetLocalToCameraPosition(Vector vecWorldPos);

// Export UPlayerPawn::execGetLocalDirVectorToCameraPosition(FFrame&, void* const)
native function Vector GetLocalDirVectorToCameraPosition(Vector vecWorldPos);

// Export UPlayerPawn::execGetPlayerCameraMatrix(FFrame&, void* const)
native function Matrix GetPlayerCameraMatrix();

// Export UPlayerPawn::execGetPlayerCameraLookAtVector(FFrame&, void* const)
native function Vector GetPlayerCameraLookAtVector();

// Export UPlayerPawn::execPPBreakPoint(FFrame&, void* const)
native final function PPBreakPoint();

// Export UPlayerPawn::execSetAIPerceivedCollisionSize(FFrame&, void* const)
native final function SetAIPerceivedCollisionSize(SPKynapseLevelData.AITypes eAIType, float ColRadius);

// Export UPlayerPawn::execGetClassSpecificCollisionRadius(FFrame&, void* const)
native function float GetClassSpecificCollisionRadius(Actor askingActor, optional float DefaultValue);

// Export UPlayerPawn::execGetClassSpecificCollisionExtent(FFrame&, void* const)
native function Vector GetClassSpecificCollisionExtent(Actor askingActor);

// Export UPlayerPawn::execStopUsingHoldTrigger(FFrame&, void* const)
native function StopUsingHoldTrigger();

// Export UPlayerPawn::execInitializeMultiExtentCollisionInfo(FFrame&, void* const)
native final function InitializeMultiExtentCollisionInfo();

// Export UPlayerPawn::execIsPlayerReloading(FFrame&, void* const)
native final function bool IsPlayerReloading();

// Export UPlayerPawn::execIsSiphoningOrDraining(FFrame&, void* const)
native final function bool IsSiphoningOrDraining();

final function EmptyCachedTouchedActors()
{
    touchingLifeForceHolders.Length = 0;
    touchingWeaponPickupFactories.Length = 0;
    touchingDroppedPickups.Length = 0;
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local SPLifeForceHolder theLifeForceHolder;
    local SPDroppedPickup theDroppedPickup;
    local SPWeaponPickupFactory theWeaponPickupFactory;
    local SPDroppedPickupTrigger theDroppedPickupTrigger;
    local SPWeaponPickupFactoryTrigger theWeaponPickupFactoryTrigger;

    theLifeForceHolder = SPLifeForceHolder(Other);
    // End:0x42
    if(theLifeForceHolder != none)
    {
        // End:0x3F
        if(touchingLifeForceHolders.Find(theLifeForceHolder) == -1)
        {
            touchingLifeForceHolders.AddItem(theLifeForceHolder);
        }        
    }
    else
    {
        theWeaponPickupFactoryTrigger = SPWeaponPickupFactoryTrigger(Other);
        // End:0x75
        if(theWeaponPickupFactoryTrigger != none)
        {
            theWeaponPickupFactory = theWeaponPickupFactoryTrigger.Owner;            
        }
        else
        {
            theWeaponPickupFactory = none;
        }
        // End:0xAE
        if(theWeaponPickupFactory != none)
        {
            // End:0xAB
            if(touchingWeaponPickupFactories.Find(theWeaponPickupFactory) == -1)
            {
                touchingWeaponPickupFactories.AddItem(theWeaponPickupFactory);
            }            
        }
        else
        {
            theDroppedPickupTrigger = SPDroppedPickupTrigger(Other);
            // End:0x10D
            if(theDroppedPickupTrigger != none)
            {
                theDroppedPickup = theDroppedPickupTrigger.Owner;
                // End:0x10D
                if(theDroppedPickup != none)
                {
                    // End:0x10D
                    if(touchingDroppedPickups.Find(theDroppedPickup) == -1)
                    {
                        touchingDroppedPickups.AddItem(theDroppedPickup);
                    }
                }
            }
        }
    }
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

event UnTouch(Actor Other)
{
    local SPLifeForceHolder theLifeForceHolder;
    local SPDroppedPickup theDroppedPickup;
    local SPWeaponPickupFactory theWeaponPickupFactory;
    local SPDroppedPickupTrigger theDroppedPickupTrigger;
    local SPWeaponPickupFactoryTrigger theWeaponPickupFactoryTrigger;

    theLifeForceHolder = SPLifeForceHolder(Other);
    // End:0x2B
    if(theLifeForceHolder != none)
    {
        touchingLifeForceHolders.RemoveItem(theLifeForceHolder);        
    }
    else
    {
        theWeaponPickupFactoryTrigger = SPWeaponPickupFactoryTrigger(Other);
        // End:0x5E
        if(theWeaponPickupFactoryTrigger != none)
        {
            theWeaponPickupFactory = theWeaponPickupFactoryTrigger.Owner;            
        }
        else
        {
            theWeaponPickupFactory = none;
        }
        // End:0x80
        if(theWeaponPickupFactory != none)
        {
            touchingWeaponPickupFactories.RemoveItem(theWeaponPickupFactory);            
        }
        else
        {
            theDroppedPickupTrigger = SPDroppedPickupTrigger(Other);
            // End:0xC8
            if(theDroppedPickupTrigger != none)
            {
                theDroppedPickup = theDroppedPickupTrigger.Owner;
                // End:0xC8
                if(theDroppedPickup != none)
                {
                    touchingDroppedPickups.RemoveItem(theDroppedPickup);
                }
            }
        }
    }
    super(Actor).UnTouch(Other);
    //return;    
}

function bool ShouldRateActor(Actor TheActor)
{
    local Vector hitPos, HitNormal;
    local Actor HitActor;
    local TraceHitInfo HitInfo;

    // End:0x49
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x46
        if(TheActor.LastRenderTime < (WorldInfo.TimeSeconds - 0.2500000))
        {
            return false;
        }        
    }
    else
    {
        HitActor = Trace(hitPos, HitNormal, Location, TheActor.Location, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 10, true);
        // End:0x93
        if(HitActor != none)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

function float RateTouchingActor(Actor TheActor)
{
    local Vector PawnLoc2D, ActorLoc2d, ViewDir;
    local float NewDot;

    PawnLoc2D = Location;
    PawnLoc2D.Z = 0.0000000;
    ActorLoc2d = TheActor.Location;
    ActorLoc2d.Z = 0.0000000;
    ViewDir = Vector(Rotation);
    NewDot = Normal(ActorLoc2d - PawnLoc2D) Dot ViewDir;
    return NewDot;
    //return ReturnValue;    
}

function SPDroppedPickup FindBestTouchingDroppedPickup(out float bestScore)
{
    local int Count, numDroppedPickups;
    local float currScore;
    local SPDroppedPickup currDroppedPickup, bestDroppedPickup;

    bestScore = -100.0000000;
    bestDroppedPickup = none;
    numDroppedPickups = touchingDroppedPickups.Length;
    Count = 0;
    J0x25:

    // End:0xA8 [Loop If]
    if(Count < numDroppedPickups)
    {
        currDroppedPickup = touchingDroppedPickups[Count];
        // End:0x9E
        if((currDroppedPickup != none) && ShouldRateActor(currDroppedPickup))
        {
            currScore = RateTouchingActor(currDroppedPickup);
            // End:0x9E
            if(currScore > bestScore)
            {
                bestScore = currScore;
                bestDroppedPickup = currDroppedPickup;
            }
        }
        Count++;
        // [Loop Continue]
        goto J0x25;
    }
    return bestDroppedPickup;
    //return ReturnValue;    
}

function SPWeaponPickupFactory FindBestTouchingWeaponPickupFactories(out float bestScore)
{
    local int Count, numWeaponPickupFactories;
    local float currScore;
    local SPWeaponPickupFactory currWeaponPickupFactory, bestWeaponPickupFactory;

    bestScore = -100.0000000;
    bestWeaponPickupFactory = none;
    numWeaponPickupFactories = touchingWeaponPickupFactories.Length;
    Count = 0;
    J0x25:

    // End:0xA8 [Loop If]
    if(Count < numWeaponPickupFactories)
    {
        currWeaponPickupFactory = touchingWeaponPickupFactories[Count];
        // End:0x9E
        if((currWeaponPickupFactory != none) && ShouldRateActor(currWeaponPickupFactory))
        {
            currScore = RateTouchingActor(currWeaponPickupFactory);
            // End:0x9E
            if(currScore > bestScore)
            {
                bestScore = currScore;
                bestWeaponPickupFactory = currWeaponPickupFactory;
            }
        }
        Count++;
        // [Loop Continue]
        goto J0x25;
    }
    return bestWeaponPickupFactory;
    //return ReturnValue;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local PandoraPlayerController PPC;
    local ConsolePandoraPlayerInput cPPI;

    PPC = PandoraPlayerController(Controller);
    cPPI = ConsolePandoraPlayerInput(PPC.PlayerInput);
    // End:0x59
    if(cPPI.bDebugShowAnalog)
    {
        cPPI.DebugRenderAnalogStick(HUD);        
    }
    else
    {
        // End:0xD4
        if((Class'Engine.Engine'.static.GetAudioDevice().spAudioDuck != none) && Class'Engine.Engine'.static.GetAudioDevice().spAudioDuck.bShowDebug)
        {
            Class'Engine.Engine'.static.GetAudioDevice().spAudioDuck.DebugDrawSoundgroups(HUD);            
        }
        else
        {
            super(Pawn).DisplayDebug(HUD, out_YL, out_YPos);
        }
    }
    //return;    
}

function bool CanDeleteOnDetach()
{
    return false;
    //return ReturnValue;    
}

function AddDefaultInventory()
{
    local PandoraPlayerController PPC;
    local SPPlayerReplicationInfo SPPRI;

    // End:0x81
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        PPC = PandoraPlayerController(Controller);
        // End:0x37
        if(PPC == none)
        {
            return;
        }
        SPPRI = SPPlayerReplicationInfo(PPC.PlayerReplicationInfo);
        // End:0x5E
        if(SPPRI == none)
        {
            return;
        }
        PPC.GiveLoadoutInventory(SPPRI.WeaponConfigIdx);
    }
    //return;    
}

function DBG_MsgPP(string Str)
{
    local PlayerController PC;

    // End:0x44
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x43
        if(PC.Pawn != none)
        {
            PC.ClientMessage(Str);
        }        
    }    
    //return;    
}

simulated event CollisionChanged()
{
    InitializeMultiExtentCollisionInfo();
    //return;    
}

function TakeFallingDamage()
{
    local float Distance, Damage;

    // End:0x0D
    if(!m_bCanTakeFallingDamage)
    {
        return;
    }
    Distance = Location.Z - m_fallStartLocation.Z;
    // End:0x103
    if(Distance < float(0))
    {
        // End:0x103
        if(int(Role) == int(ROLE_Authority))
        {
            Damage = m_PlayerGDTuneData.DamageForFallDistance(-Distance);
            // End:0xAC
            if(Damage > float(0))
            {
                TakeDamageAndProcEffects(Damage, none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'SPDamageTypeFall');                
            }
            else
            {
                // End:0xD9
                if(Velocity.Z < (-1.4000000 * JumpZ))
                {
                    MakeNoise(0.5000000);                    
                }
                else
                {
                    // End:0x103
                    if(Velocity.Z < (-0.8000000 * JumpZ))
                    {
                        MakeNoise(0.2000000);
                    }
                }
            }
        }
    }
    //return;    
}

// Export UPlayerPawn::execGetShotTargetOnBody(FFrame&, void* const)
native simulated function Vector GetShotTargetOnBody(optional Actor RequestedBy);

simulated function name ActionMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;
    local PandoraPlayerController PC;

    retval = 'Default';
    PC = PandoraPlayerController(Controller);
    // End:0x33
    if(PC == none)
    {
        return retval;        
    }
    switch(PC.m_actionState)
    {
        // End:0x5C
        case 1:
            retval = 'WWHARMinigameStart';
            // End:0x1E6
            break;
        // End:0x73
        case 2:
            retval = 'WWHARMinigameChain';
            // End:0x1E6
            break;
        // End:0x8A
        case 3:
            retval = 'WWHARMinigameFinish';
            // End:0x1E6
            break;
        // End:0xA1
        case 4:
            retval = 'WWDBUpLeft';
            // End:0x1E6
            break;
        // End:0xB8
        case 5:
            retval = 'WWDBUpRight';
            // End:0x1E6
            break;
        // End:0xCF
        case 6:
            retval = 'WWDBDownLeft';
            // End:0x1E6
            break;
        // End:0xE6
        case 7:
            retval = 'WWDBDownRight';
            // End:0x1E6
            break;
        // End:0xFD
        case 8:
            retval = 'TMGWerewolfFallback';
            // End:0x1E6
            break;
        // End:0x114
        case 9:
            retval = 'TMGWerewolfStage1Attack';
            // End:0x1E6
            break;
        // End:0x12B
        case 10:
            retval = 'TMGWerewolfStage2Choice';
            // End:0x1E6
            break;
        // End:0x142
        case 11:
            retval = 'TMGWerewolfStage1KickOff';
            // End:0x1E6
            break;
        // End:0x159
        case 12:
            retval = 'TMGWerewolfTransitionToStage2';
            // End:0x1E6
            break;
        // End:0x170
        case 13:
            retval = 'TMGWerewolfStage1Fail';
            // End:0x1E6
            break;
        // End:0x187
        case 14:
            retval = 'TMGWerewolfStage2Attack';
            // End:0x1E6
            break;
        // End:0x19E
        case 15:
            retval = 'TMGWerewolfStage2Fail';
            // End:0x1E6
            break;
        // End:0x1B5
        case 16:
            retval = 'TMGWerewolfGetUp';
            // End:0x1E6
            break;
        // End:0x1CC
        case 17:
            retval = 'TMGWerewolfKillshot';
            // End:0x1E6
            break;
        // End:0x1E3
        case 18:
            retval = 'TMGWerewolfKillshotSuccess';
            // End:0x1E6
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

function AttemptAnimusPulse()
{
    local Vector firePos;
    local Rotator fireRot;
    local PandoraPlayerController MyController;
    local float animusPulseAnimusUsed, TimeSeconds;

    animusPulseAnimusUsed = m_PlayerGDTuneData.animusPulseAnimusUsed();
    // End:0x2B
    if(LifeForce < animusPulseAnimusUsed)
    {
        return;
    }
    TimeSeconds = WorldInfo.TimeSeconds;
    // End:0x51
    if(TimeSeconds < m_nextCanAnimusPulseTime)
    {
        return;
    }
    MyController = PandoraPlayerController(Controller);
    // End:0x99
    if(MyController != none)
    {
        MyController.GetPlayerViewPoint(firePos, fireRot);
        firePos -= Location;        
    }
    else
    {
        firePos = vect(0.0000000, 0.0000000, 0.0000000);
    }
    PandoraPlayerController(Controller).PlayAmBxScript("animus_pulse", 0);
    Class'SPAnimusPulseGenerator'.static.Fire(self, m_PlayerGDTuneData.AnimusFireOffset + firePos, m_PlayerGDTuneData.AnimusPulseDamageRadius(), m_PlayerGDTuneData.AnimusPulseDamage(), m_PlayerGDTuneData.AnimusPulseImplse(), m_PlayerGDTuneData.AnimusPulseExpansionRate());
    LifeForce -= m_PlayerGDTuneData.animusPulseAnimusUsed();
    m_nextCanAnimusPulseTime = (WorldInfo.TimeSeconds + m_PlayerGDTuneData.AnimusPulseMinTimeBetweenPulses()) + m_PlayerGDTuneData.AnimusPulseDuration();
    m_bInAnimusPulse = true;
    SetTimer(1.0000000, false, 'AnimusPulseFinished');
    // End:0x1E5
    if(MyController != none)
    {
        MyController.SinglePlayerAnimusPulseUsedAchievement();
    }
    //return;    
}

simulated function name CarryMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;
    local PandoraPlayerController PC;

    retval = 'Default';
    PC = PandoraPlayerController(Controller);
    // End:0x33
    if(PC == none)
    {
        return retval;        
    }
    // End:0x6E
    if((PC.Carried != none) || PC.CarriedPawn != none)
    {
        retval = 'ItemCarried';
    }
    return retval;
    //return ReturnValue;    
}

simulated function float UpperLowerBodySplitPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
{
    childWeights[1] = 1.0000000;
    return 1.0000000;
    //return ReturnValue;    
}

simulated function SPSkelControlPlayerPitch GetPitchSkelControl()
{
    // End:0x3D
    if(PitchSkelControlCache == none)
    {
        // End:0x19
        if(Mesh == none)
        {            
        }
        else
        {
            PitchSkelControlCache = SPSkelControlPlayerPitch(Mesh.FindSkelControl('PitchControl'));
        }
    }
    return PitchSkelControlCache;
    //return ReturnValue;    
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local SPSkelControlPlayerPitch PitchControl;

    PitchControl = GetPitchSkelControl();
    // End:0x53
    if(PitchControl != none)
    {
        ViewPitchMin = PitchControl.m_minPitch * 182.0444000;
        ViewPitchMax = PitchControl.m_maxPitch * 182.0444000;
    }
    super(Pawn).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
    //return;    
}

function bool EnablePitchSkelControl(bool bEnable)
{
    local SPSkelControlPlayerPitch lePitchControl;

    lePitchControl = GetPitchSkelControl();
    // End:0x33
    if(lePitchControl != none)
    {
        lePitchControl.SetSkelControlActive(bEnable);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool SetPitchSkelControlPitch(int pitchRot)
{
    local SPSkelControlPlayerPitch lePitchControl;

    lePitchControl = GetPitchSkelControl();
    // End:0x3D
    if(lePitchControl != none)
    {
        lePitchControl.BoneRotation.Pitch = pitchRot;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool AddPitchSkelControlPitch(int pitchRotToAdd)
{
    local SPSkelControlPlayerPitch lePitchControl;

    lePitchControl = GetPitchSkelControl();
    // End:0x3E
    if(lePitchControl != none)
    {
        lePitchControl.BoneRotation.Pitch += pitchRotToAdd;
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function SetMeshDepthPriorityGroup(Scene.ESceneDepthPriorityGroup DPG_Group)
{
    // End:0x57
    if(Mesh != none)
    {
        Mesh.SetDepthPriorityGroup(DPG_Group);
        // End:0x45
        if(int(DPG_Group) == int(2))
        {
            Mesh.bAllowAmbientOcclusion = false;            
        }
        else
        {
            Mesh.bAllowAmbientOcclusion = true;
        }
    }
    //return;    
}

reliable client simulated function NetDPGChange()
{
    // End:0x12
    if(int(Role) == int(ROLE_Authority))
    {
        return;
    }
    // End:0x49
    if((IsLocallyControlled() && !bPlayedDeath) && int(Role) == int(ROLE_AutonomousProxy))
    {
        SetMeshDepthPriorityGroup(ROLE_AutonomousProxy);        
    }
    else
    {
        SetMeshDepthPriorityGroup(ROLE_SimulatedProxy);
    }
    //return;    
}

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].Player;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.static.GetGameDifficultyTunePlayer();
    //return ReturnValue;    
}

simulated function AssignMPColorByTeam()
{
    local PandoraGRI PGRI;
    local LinearColor TeamColor;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x28
    if(PGRI == none)
    {        
    }
    else
    {
        TeamColor = PGRI.GetTeamColor(self);
        SetMPColorLinear(TeamColor);
    }
    //return;    
}

simulated function AssignMPColorBySpecificTeam(int TeamID)
{
    local PandoraGRI PGRI;
    local LinearColor TeamColor;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x28
    if(PGRI == none)
    {        
    }
    else
    {
        // End:0x60
        if(TeamID < PGRI.m_TeamColors.Length)
        {
            TeamColor = PGRI.m_TeamColors[TeamID];            
        }
        else
        {
            TeamColor.R = 1.0000000;
            TeamColor.G = 1.0000000;
            TeamColor.B = 1.0000000;
            TeamColor.A = 1.0000000;
        }
        SetMPColorLinear(TeamColor);
    }
    //return;    
}

simulated function string UpdateText()
{
    // End:0x1E
    if(PlayerReplicationInfo != none)
    {
        return PlayerReplicationInfo.PlayerName;        
    }
    else
    {
        return "";
    }
    //return ReturnValue;    
}

simulated function InitMPNameBillboard()
{
    m_BillboardComponent.m_Text = UpdateText();
    m_BillboardComponent.__funcUpdateText__Delegate = UpdateText;
    m_BillboardComponent.InitBillboard();
    //return;    
}

simulated function SetAmBxLightEnv(AmBxLightEnvironmentComponent lightEnv, float OffsetX, float OffsetY, float offsetZ)
{
    lightEnv.m_AmBxOffset.X = OffsetX;
    lightEnv.m_AmBxOffset.Y = OffsetY;
    lightEnv.m_AmBxOffset.Z = offsetZ;
    lightEnv.m_AmBxLightSnifferSize = m_AmBxLightSnifferSize;
    lightEnv.m_AmBxLightSnifferNormalLightFactor = m_AmBxLightSnifferNormalLightFactor;
    lightEnv.m_AmBxLightSnifferNonShadowLightFactor = m_AmBxLightSnifferNonShadowLightFactor;
    lightEnv.m_AmBxLightSnifferSkyLightFactor = m_AmBxLightSnifferSkyLightFactor;
    lightEnv.m_AmBxLightSnifferHitWallReductionFactor = m_AmBxLightSnifferHitWallReductionFactor;
    lightEnv.m_bAmBxLightSnifferUseStaticLights = m_bAmBxLightSnifferUseStaticLights;
    lightEnv.m_bAmBxLightSnifferUseDynamicLights = m_bAmBxLightSnifferUseDynamicLights;
    lightEnv.m_bAmBxLightSnifferUseNormalLight = m_bAmBxLightSnifferUseNormalLight;
    lightEnv.m_bAmBxLightSnifferUseNonShadowLight = m_bAmBxLightSnifferUseNonShadowLight;
    lightEnv.m_bAmBxLightSnifferUseSkyLight = m_bAmBxLightSnifferUseSkyLight;
    lightEnv.m_AmBxLightEnvironmentAbsIgnoreDist = m_AmBxLightEnvironmentAbsIgnoreDist;
    lightEnv.m_AmBxLightEnvironmentGlobalDesaturate = m_AmBxLightEnvironmentGlobalDesaturate;
    //return;    
}

simulated function PostBeginPlay()
{
    local bool bRemote;

    bUseViewportNames = WorldInfo.IsConsoleBuild(2);
    // End:0x2D
    if(bUseViewportNames)
    {
        DetachComponent(m_BillboardComponent);
    }
    super(SPPawn).PostBeginPlay();
    m_PlayerTuneData = SPTuneDataPlayer(GetMyTuneData());
    m_PlayerGDTuneData = SPGameDifficultyTunePlayer(GetMyGDData());
    // End:0x96
    if(m_PlayerGDTuneData != none)
    {
        Health = int(m_PlayerGDTuneData.GetValue(m_PlayerGDTuneData.HitPoints));        
    }
    HealthMax = Health;
    JumpZ = GetJumpVelocity();
    MaxJumpHeight = GetMaxJumpHeight();
    MaxStepHeight = playerMaxStepHeight;
    UseTuneData();
    DodgeTimeLength = playerDodgeTime;
    DodgeTimeIntervalMin = playerDodgeDeltaTime;
    DodgeSpeed = playerDodgeDistance / playerDodgeTime;
    CrouchedPct = CrouchSpeedMult;
    m_pathBlockInfo.movingState = 0;
    m_pathBlockInfo.movementUpdateInterval = 1.0000000;
    bRemote = (int(Role) == int(ROLE_SimulatedProxy)) || (int(Role) == int(ROLE_Authority)) && int(RemoteRole) == int(ROLE_AutonomousProxy);
    // End:0x1CA
    if(bRemote || IsSlavePawn)
    {
        // End:0x1A3
        if(Mesh != ThirdPersonMesh)
        {
            Mesh = ThirdPersonMesh;
            AttachComponent(Mesh);
        }
        // End:0x1C7
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            InitMPColor();
        }        
    }
    else
    {
        // End:0x1EF
        if(Mesh != FirstPersonMesh)
        {
            Mesh = FirstPersonMesh;
            AttachComponent(Mesh);
        }
    }
    InitPhysicsAssetInstance(true);
    AttemptPhysAnimState_Fixed(true);
    EnablePitchSkelControl(true);
    // End:0x231
    if(siphonLight != none)
    {
        Mesh.AttachComponentToSocket(siphonLight, 'Hand');
    }
    // End:0x25A
    if(healLight != none)
    {
        Mesh.AttachComponentToSocket(healLight, 'Hand');
    }
    SetupSignetHandEffect();
    // End:0x28B
    if(!bRemote && !bPlayedDeath)
    {
        SetMeshDepthPriorityGroup(2);        
    }
    else
    {
        SetMeshDepthPriorityGroup(1);
    }
    NetDPGChange();
    CurrentHitEffectFadeTime = 0.0000000;
    // End:0x2EC
    if(((int(WorldInfo.NetMode) != int(NM_Standalone)) && IsSlavePawn == false) && bUseViewportNames == false)
    {
        InitMPNameBillboard();
    }
    // End:0x307
    if(!IsSlavePawn)
    {
        DamageIndicatorManager = new (none) Class'SPDamageIndicatorManager';
    }
    PandoraPlayerController(Controller).IgnorePauseInput(false);
    //return;    
}

simulated function DoAmBXWork(Controller C)
{
    local PandoraPlayerController PC;

    PC = PandoraPlayerController(C);
    // End:0x53
    if(PC != none)
    {
        // End:0x49
        if(PC.ProfileSettings.IsAmBxEnabled())
        {
            AttachAmBXLightEnvironments();            
        }
        else
        {
            DetachAmBXLightEnvironments();
        }
    }
    //return;    
}

simulated function DetachAmBXLightEnvironments()
{
    DetachComponent(m_NorthLightEnvironment);
    DetachComponent(m_NorthEastLightEnvironment);
    DetachComponent(m_EastLightEnvironment);
    DetachComponent(m_SouthEastLightEnvironment);
    DetachComponent(m_SouthLightEnvironment);
    DetachComponent(m_SouthWestLightEnvironment);
    DetachComponent(m_WestLightEnvironment);
    DetachComponent(m_NorthWestLightEnvironment);
    m_NorthLightEnvironment.SetEnabled(false);
    m_NorthEastLightEnvironment.SetEnabled(false);
    m_EastLightEnvironment.SetEnabled(false);
    m_SouthEastLightEnvironment.SetEnabled(false);
    m_SouthLightEnvironment.SetEnabled(false);
    m_SouthWestLightEnvironment.SetEnabled(false);
    m_WestLightEnvironment.SetEnabled(false);
    m_NorthWestLightEnvironment.SetEnabled(false);
    //return;    
}

simulated function AttachAmBXLightEnvironments()
{
    local float slantDis;

    AttachComponent(m_NorthLightEnvironment);
    AttachComponent(m_NorthEastLightEnvironment);
    AttachComponent(m_EastLightEnvironment);
    AttachComponent(m_SouthEastLightEnvironment);
    AttachComponent(m_SouthLightEnvironment);
    AttachComponent(m_SouthWestLightEnvironment);
    AttachComponent(m_WestLightEnvironment);
    AttachComponent(m_NorthWestLightEnvironment);
    m_NorthLightEnvironment.SetEnabled(true);
    m_NorthLightEnvironment.MinTimeBetweenFullUpdates = m_NStaticMinTimeBetweenFullUpdates;
    m_NorthEastLightEnvironment.SetEnabled(true);
    m_NorthEastLightEnvironment.MinTimeBetweenFullUpdates = m_NEStaticMinTimeBetweenFullUpdates;
    m_EastLightEnvironment.SetEnabled(true);
    m_EastLightEnvironment.MinTimeBetweenFullUpdates = m_EStaticMinTimeBetweenFullUpdates;
    m_SouthEastLightEnvironment.SetEnabled(true);
    m_SouthEastLightEnvironment.MinTimeBetweenFullUpdates = m_SEStaticMinTimeBetweenFullUpdates;
    m_SouthLightEnvironment.SetEnabled(true);
    m_SouthLightEnvironment.MinTimeBetweenFullUpdates = m_SStaticMinTimeBetweenFullUpdates;
    m_SouthWestLightEnvironment.SetEnabled(true);
    m_SouthWestLightEnvironment.MinTimeBetweenFullUpdates = m_SWStaticMinTimeBetweenFullUpdates;
    m_WestLightEnvironment.SetEnabled(true);
    m_WestLightEnvironment.MinTimeBetweenFullUpdates = m_WStaticMinTimeBetweenFullUpdates;
    m_NorthWestLightEnvironment.SetEnabled(true);
    m_NorthWestLightEnvironment.MinTimeBetweenFullUpdates = m_NWStaticMinTimeBetweenFullUpdates;
    slantDis = Sqrt((m_AmBxLightSnifferDistFromPawn * m_AmBxLightSnifferDistFromPawn) / 2.0000000);
    SetAmBxLightEnv(m_NorthLightEnvironment, m_AmBxLightSnifferDistFromPawn, 0.0000000, m_AmBxLightSnifferZOffPawn);
    SetAmBxLightEnv(m_NorthEastLightEnvironment, slantDis, slantDis, m_AmBxLightSnifferZOffPawn);
    SetAmBxLightEnv(m_EastLightEnvironment, 0.0000000, m_AmBxLightSnifferDistFromPawn, m_AmBxLightSnifferZOffPawn);
    SetAmBxLightEnv(m_SouthEastLightEnvironment, -slantDis, slantDis, m_AmBxLightSnifferZOffPawn);
    SetAmBxLightEnv(m_SouthLightEnvironment, -m_AmBxLightSnifferDistFromPawn, 0.0000000, m_AmBxLightSnifferZOffPawn);
    SetAmBxLightEnv(m_SouthWestLightEnvironment, -slantDis, -slantDis, m_AmBxLightSnifferZOffPawn);
    SetAmBxLightEnv(m_WestLightEnvironment, 0.0000000, -m_AmBxLightSnifferDistFromPawn, m_AmBxLightSnifferZOffPawn);
    SetAmBxLightEnv(m_NorthWestLightEnvironment, slantDis, -slantDis, m_AmBxLightSnifferZOffPawn);
    //return;    
}

simulated function ClientRestart()
{
    local PlayerController MyController;

    super(Pawn).ClientRestart();
    MyController = PlayerController(Controller);
    // End:0x178
    if(MyController != none)
    {
        playerHud = SPHud(MyController.myHUD);
        // End:0xB7
        if(playerHud != none)
        {
            // End:0x65
            if(playerHud != none)
            {
                playerHud.Reset();
            }
            // End:0xB4
            if(playerHud.bShowHUD != false)
            {
                // End:0xB4
                if(playerHud.HudScene != none)
                {
                    playerHud.HudScene.FadeIn(0.5000000);
                }
            }            
        }
        // End:0x175
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            // End:0x175
            if(float(Health) < (m_PlayerGDTuneData.GetValue(m_PlayerGDTuneData.HitResetOnCheckpoint) * m_PlayerGDTuneData.GetValue(m_PlayerGDTuneData.HitPoints)))
            {
                Health = int(m_PlayerGDTuneData.GetValue(m_PlayerGDTuneData.HitResetOnCheckpoint) * m_PlayerGDTuneData.GetValue(m_PlayerGDTuneData.HitPoints));
            }
        }        
    }
    //return;    
}

simulated exec function DumpLFStreams()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x54 [Loop If]
    if(I < ActiveLFStreams.Length)
    {
        DBG_MsgPP((("Stream " @ string(I)) @ " -- ") @ string(ActiveLFStreams[I]));
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

exec function SetPerceivedCollisionSize(name classType, float Radius)
{
    // End:0x23
    if(classType == 'Werewolf')
    {
        SetAIPerceivedCollisionSize(3, Radius);        
    }
    else
    {
        // End:0x46
        if(classType == 'Griffon')
        {
            SetAIPerceivedCollisionSize(1, Radius);            
        }
        else
        {
            return;
        }
    }
    //return;    
}

simulated exec function UseTuneData()
{
    GroundSpeed = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Walk.playerForwardSpeed;
    m_movementTypeInfo[0].GroundSpeed = GroundSpeed;
    playerForwardSpeed = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Walk.playerForwardSpeed;
    playerBackwardSpeed = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Walk.playerBackwardSpeed;
    playerStrafeSpeed = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Walk.playerStrafeSpeed;
    playerSprintSpeedScale = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintSpeedMult;
    m_movementTypeInfo[2].GroundSpeed = m_movementTypeInfo[0].GroundSpeed * playerSprintSpeedScale;
    m_movementTypeInfo[3].GroundSpeed = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().GetValue(Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintBurstSpeed);
    CrouchSpeedMult = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Crouch.CrouchSpeedMult;
    DownSiteSpeedMult = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().DownSite.DownSiteSpeedMult;
    CrouchDownSiteSpeedMult = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().DownSite.CrouchDownSiteSpeedMult;
    playerJumpImpulse = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Jump.playerJumpImpulse;
    playerMaxJumpHeight = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Jump.playerMaxJumpHeight;
    playerJumpHeight = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Jump.playerJumpHeight;
    bCalcJumpImpulseUsingMaxJumpHeight = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Jump.bCalcJumpImpulseUsingMaxJumpHeight;
    percentOfMoveSpeedUsedForJumpBoost = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Jump.percentOfMoveSpeedUsedForJumpBoost;
    minPercentageOfMaximumSpeedToApplyBoost = float(Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Jump.minPercentageOfMaximumSpeedToApplyBoost) * 0.0100000;
    SprintJumpCost = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().SprintJump.SprintJumpCost;
    percentOfMoveSpeedUsedForSprintJumpBoost = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().SprintJump.percentOfMoveSpeedUsedForSprintJumpBoost;
    //return;    
}

simulated event float GetDirectionSpeedMult()
{
    local Vector normalFacing, normalAccel;
    local float dotProduct, Angle, sidePercent, totalSpeed;

    // End:0x1D
    if(Velocity == vect(0.0000000, 0.0000000, 0.0000000))
    {
        return 1.0000000;
    }
    normalFacing = Normal(Vector(Rotation));
    normalAccel = Normal(Acceleration);
    dotProduct = normalFacing Dot normalAccel;
    // End:0x68
    if(dotProduct > 1.0000000)
    {
        dotProduct = 1.0000000;        
    }
    else
    {
        // End:0x82
        if(dotProduct < -1.0000000)
        {
            dotProduct = -1.0000000;
        }
    }
    // End:0xFA
    if(dotProduct >= float(0))
    {
        Angle = Acos(dotProduct);
        sidePercent = (Angle * 57.2957800) / float(90);
        totalSpeed = (sidePercent * playerStrafeSpeed) + ((float(1) - sidePercent) * playerForwardSpeed);
        return totalSpeed / float(Max(int(playerForwardSpeed), int(playerStrafeSpeed)));        
    }
    else
    {
        Angle = Acos(-dotProduct);
        sidePercent = (Angle * 57.2957800) / float(90);
        totalSpeed = (sidePercent * playerStrafeSpeed) + ((float(1) - sidePercent) * playerBackwardSpeed);
        return totalSpeed / float(Max(int(playerBackwardSpeed), int(playerStrafeSpeed)));
    }
    //return ReturnValue;    
}

function bool DidWeFallFarEnoughToPlayJumpLandSound()
{
    local float fallDistance;

    fallDistance = MaxZAttainedDuringJump - Location.Z;
    return fallDistance > m_PlayerGDTuneData.MinFallDistanceToPlayLandingSound;
    //return ReturnValue;    
}

simulated function float GetJumpVelocity()
{
    // End:0x1D
    if(bCalcJumpImpulseUsingMaxJumpHeight)
    {
        return (playerJumpHeight * playerMaxJumpHeight) / 88.0000000;
    }
    return playerJumpImpulse;
    //return ReturnValue;    
}

simulated function float GetMaxJumpHeight()
{
    return playerMaxJumpHeight;
    //return ReturnValue;    
}

event WerewolfTackleGetUpEnded()
{
    local PandoraPlayerController MyController;

    // End:0x3A
    if(Controller != none)
    {
        MyController = PandoraPlayerController(Controller);
        // End:0x3A
        if(MyController != none)
        {
            MyController.WerewolfTackleGetUpEnded();
        }
    }
    //return;    
}

event ReloadSawBullets()
{
    // End:0x3B
    if(SPWeapon(Weapon).WeapID == 'Saw')
    {
        SPWeapon(Weapon).ReloadBullets();
    }
    //return;    
}

function bool CheatWalk()
{
    local PandoraPlayerController PC;

    PC = PandoraPlayerController(Controller);
    // End:0x2F
    if(PC != none)
    {
        PC.DismountPlayer();
    }
    return super(Pawn).CheatWalk();
    //return ReturnValue;    
}

function bool CheatGhost()
{
    local PandoraPlayerController PC;

    PC = PandoraPlayerController(Controller);
    // End:0x2F
    if(PC != none)
    {
        PC.DismountPlayer();
    }
    return super(Pawn).CheatGhost();
    //return ReturnValue;    
}

function bool CheatFly()
{
    local PandoraPlayerController PC;

    PC = PandoraPlayerController(Controller);
    // End:0x2F
    if(PC != none)
    {
        PC.DismountPlayer();
    }
    return super(Pawn).CheatFly();
    //return ReturnValue;    
}

function SetNoRegenTime(float Time)
{
    // End:0x1F
    if(Time == float(-1))
    {
        noRegenTime = 0.0000000;        
    }
    else
    {
        // End:0x39
        if(Time > noRegenTime)
        {
            noRegenTime = Time;
        }
    }
    //return;    
}

simulated function ReloadStart()
{
    local PandoraPlayerController PC;

    super(SPPawn).ReloadStart();
    PC = PandoraPlayerController(Controller);
    // End:0x36
    if(PC != none)
    {
        PC.ResetAndPushLookDownSiteState();
    }
    //return;    
}

function TellReloadFinished(SPWeapon spWeap)
{
    local PandoraPlayerController PC;

    PC = PandoraPlayerController(Controller);
    // End:0x2F
    if(PC != none)
    {
        PC.RestorePushedLookDownSiteState();
    }
    //return;    
}

simulated function UpdateHealingEffects(float DeltaTime)
{
    local PandoraPlayerController thePlayerController;
    local bool bStillActive;
    local float FadeOutTime;

    thePlayerController = PandoraPlayerController(Controller);
    // End:0x1B
    if(thePlayerController == none)
    {
    }
    bStillActive = false;
    // End:0xB0
    if(((Health > 0) && Health < HealthMax) && LifeForce > 0.0000000)
    {
        // End:0x73
        if(bActiveHeal)
        {
            bStillActive = thePlayerController.bHealRequest;            
        }
        else
        {
            // End:0xB0
            if((WorldInfo.TimeSeconds - lastDamagedTime) > Class'PandoraPlayerInput'.default.LifeForceParams.HealDelayTime)
            {
                bStillActive = true;
            }
        }
    }
    // End:0x100
    if((bInHeal && bStillActive) && !m_bPlayingAmBxAnimusHealEffectScript)
    {
        PandoraPlayerController(Controller).PlayAmBxScript("animus_heal", 0);
        m_bPlayingAmBxAnimusHealEffectScript = true;
    }
    // End:0x151
    if((!bInHeal && !bStillActive) && m_bPlayingAmBxAnimusHealEffectScript)
    {
        PandoraPlayerController(Controller).StopAmBxScript("animus_heal");
        m_bPlayingAmBxAnimusHealEffectScript = false;
    }
    // End:0x2C3
    if(bInHeal ^^ bStillActive)
    {
        RefHealTime = WorldInfo.TimeSeconds;
        // End:0x1FE
        if(!bStillActive)
        {
            thePlayerController.RestorePushedLookDownSiteState();
            KillAttachedParticles();
            // End:0x1FB
            if((AudioComp_HealLoop != none) && !bHealFade)
            {
                FadeOutTime = 1.5000000;
                AudioComp_HealLoop.FadeOut(FadeOutTime, 0.0000000);
                bHealFade = true;
                SetTimer(FadeOutTime + 0.1000000, false, 'FinishHeal');
            }            
        }
        else
        {
            lastHandEffect = 0;
            thePlayerController.ResetAndPushLookDownSiteState();
            ResetSignetHandEffect(false);
            HealAnimNodeStatus = 0;
            // End:0x263
            if(AudioComp_HealLoop != none)
            {
                ClearTimer('FinishHeal');
                AudioComp_HealLoop.Stop();
                AudioComp_HealLoop = none;
                bHealFade = false;
            }
            AudioComp_HealLoop = CreateAudioComponent(mSoundCue_HealLoop, false, true);
            // End:0x2A6
            if(AudioComp_HealLoop != none)
            {
                AudioComp_HealLoop.bAutoDestroy = true;
                AudioComp_HealLoop.Play();
            }
        }
        bInHeal = bStillActive;
        SetInHealOnServer(bInHeal);
    }
    // End:0x2DA
    if(bStillActive)
    {
        UpdateSignetHandEffect(DeltaTime);        
    }
    else
    {
        // End:0x2F5
        if(int(lastHandEffect) == int(0))
        {
            ShutdownSignetHandEffect(DeltaTime);
        }
    }
    UpdateHealLight(bStillActive);
    //return;    
}

k2override function ServerOnlyUpdateHealing(float DeltaTime)
{
    local int scratchInt;
    local float recoverRate;

    // End:0xFA
    if(bInHeal)
    {
        scratchInt = Clamp(int(WorldInfo.TimeSeconds - RefHealTime), 0, 2);
        // End:0x5E
        if(bActiveHeal)
        {
            recoverRate = Class'PandoraPlayerInput'.default.LifeForceParams.AHealRate[scratchInt];            
        }
        else
        {
            recoverRate = Class'PandoraPlayerInput'.default.LifeForceParams.PHealRate[scratchInt];
        }
        recoverRate *= DeltaTime;
        recoverRate = FMin(recoverRate, LifeForce);
        partialHealthRestore += (recoverRate * 1.0000100);
        LifeForce -= recoverRate;
        scratchInt = int(partialHealthRestore);
        Health += scratchInt;
        Health = Min(HealthMax, Health);
        partialHealthRestore -= float(scratchInt);
    }
    //return;    
}

reliable server function SetInHealOnServer(bool Heal)
{
    bInHeal = Heal;
    RefHealTime = WorldInfo.TimeSeconds;
    //return;    
}

simulated function UpdateHealLight(bool bActive)
{
    local float lightScale;

    lightScale = FClamp((WorldInfo.TimeSeconds - RefHealTime) / 1.0000000, 0.0000000, 1.0000000);
    // End:0x4C
    if(!bActive)
    {
        lightScale = 1.0000000 - lightScale;
    }
    // End:0x96
    if((lightScale <= 0.0000000) || RefHealTime == 0.0000000)
    {
        // End:0x93
        if(healLight.bEnabled == true)
        {
            healLight.SetEnabled(false);
        }        
    }
    else
    {
        healLight.SetLightProperties(lightScale, healLight.LightColor, healLight.Function);
        healLight.SetEnabled(true);
    }
    //return;    
}

function Vector GetYawVectorFromRotator(Rotator R, float scale_factor)
{
    local float normYaw, Delta;
    local Vector V;

    normYaw = float(R.Yaw) % float(65535);
    Delta = (normYaw * 6.2831850) / float(65535);
    V.X = Cos(Delta) * scale_factor;
    V.Y = Sin(Delta) * scale_factor;
    V.Z = 0.0000000;
    return V;
    //return ReturnValue;    
}

event NotifyDeathBlow()
{
    //return;    
}

simulated event End_ThrowUnderhand_Notify()
{
    m_eGrenadeState = 0;
    PandoraPlayerController(Controller).fPrimeTime = -1.0000000;
    //return;    
}

simulated function ClearFlagsFromPreviousTick()
{
    // End:0x19
    if(m_bClearResetActionNextTick)
    {
        m_bResetAction = false;
        m_bClearResetActionNextTick = false;
    }
    // End:0x32
    if(m_bClearResetFireAnimNextTick)
    {
        m_bResetFireAnim = false;
        m_bClearResetFireAnimNextTick = false;
    }
    // End:0x4B
    if(m_bADSResetWeaponFireNextTick)
    {
        m_bADSResetWeaponFire = false;
        m_bADSResetWeaponFireNextTick = false;
    }
    // End:0x67
    if(SetCollectAnimNodeStatusNextTick)
    {
        CollectAnimNodeStatus = CollectAnimNodeStatusNextTick;
        SetCollectAnimNodeStatusNextTick = false;
    }
    // End:0x83
    if(SetHealAnimNodeStatusNextTick)
    {
        HealAnimNodeStatus = HealAnimNodeStatusNextTick;
        SetHealAnimNodeStatusNextTick = false;
    }
    //return;    
}

simulated event Tick(float DeltaTime)
{
    ClearFlagsFromPreviousTick();
    // End:0x25
    if(IsLocallyControlled())
    {
        LocalTick(DeltaTime);        
    }
    else
    {
        RemoteTick(DeltaTime);
    }
    NonSlaveTick(DeltaTime);
    super(SPPawn).Tick(DeltaTime);
    //return;    
}

simulated function NonSlaveTick(float DeltaTime)
{
    local PandoraPlayerController Con;
    local SPHud playerSPHud;
    local Vector debugFirePos, debugFireDir;

    ServerOnlyUpdateHealing(DeltaTime);
    LastPushedObject = none;
    // End:0x3A
    if(!bUseViewportNames)
    {
        m_BillboardComponent.Update(DeltaTime);
    }
    DamageIndicatorManager.Tick(DeltaTime);
    // End:0x7B
    if(int(Role) == int(ROLE_Authority))
    {
        RemoteViewYaw = NormalizeRotAxis(Rotation.Yaw);
    }
    // End:0x10F
    if((PandoraPlayerController(Controller) != none) && PandoraPlayerController(Controller).IsWeaponDebugOn() == true)
    {
        // End:0x10F
        if(SPWeapon(Weapon) != none)
        {
            SPWeapon(Weapon).GetProjectileFirePositionNoSpread(debugFirePos, debugFireDir);
            DrawDebugLine(debugFirePos, debugFirePos + (debugFireDir * Weapon.GetTraceRange()), 200, 200, 200, false);
        }
    }
    // End:0x349
    if(int(Role) > int(ROLE_SimulatedProxy))
    {
        // End:0x18C
        if(Controller != none)
        {
            // End:0x155
            if(int(m_eGrenadeState) == int(1))
            {
                PandoraPlayerController(Controller).fPrimeTime += DeltaTime;
            }
            // End:0x18C
            if(PandoraPlayerController(Controller).fSinceLastPrime > float(0))
            {
                PandoraPlayerController(Controller).fSinceLastPrime -= DeltaTime;
            }
        }
        Con = PandoraPlayerController(Controller);
        // End:0x217
        if((Con != none) && Con.GetMountedWeapon() == none)
        {
            // End:0x1F3
            if(bHardAttach)
            {
                AddPitchSkelControlPitch(Controller.Rotation.Pitch);                
            }
            else
            {
                SetPitchSkelControlPitch(Controller.Rotation.Pitch);
            }
        }
        // End:0x23B
        if(Con != none)
        {
            Con.RegenSprint(DeltaTime);
        }
        SwapToSPWeaponType = SetQueryCollectableSwapWeapon();
        // End:0x29E
        if(((Con != none) && Con.bHoldUse) && SwapToSPWeaponType != none)
        {
            Con.m_bCanQuickSwap = true;
            Con.PerformedUseAction();
        }
        // End:0x2C3
        if(Con != none)
        {
            playerSPHud = SPHud(Con.myHUD);
        }
        // End:0x349
        if((playerSPHud != none) && playerSPHud.HudScene != none)
        {
            // End:0x32A
            if(SwapToSPWeaponType != none)
            {
                playerSPHud.HudScene.WeaponPickupBarFadeIn(0.0000000, SwapToSPWeaponType.default.WeapID, WordsPickupWeaponMessage);                
            }
            else
            {
                playerSPHud.HudScene.WeaponPickupBarFadeOut();
            }
        }
    }
    // End:0x366
    if(int(m_eGrenadeState) == int(1))
    {
        DoShowFakeGrenade();        
    }
    else
    {
        DoHideFakeGrenade();
    }
    //return;    
}

simulated function RemoteTick(float DeltaTime)
{
    UpdateReplicatedAim(DeltaTime, RemoteViewPitch);
    RemoteProcessLifeForceStreams(DeltaTime);
    //return;    
}

function LocalTick(float DeltaTime)
{
    // End:0x3C
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        UpdatePlayerHighlight();
        // End:0x3C
        if(bUseViewportNames)
        {
            UpdatePlayerTags(DeltaTime);
        }
    }
    sinceLastHitSound += DeltaTime;
    playerHud.Tick(DeltaTime);
    UpdateHealingEffects(DeltaTime);
    CheckForLifeForce(DeltaTime);
    UpdateHUD(DeltaTime);
    // End:0xA1
    if(ShouldDetachFromDeadHelicopter())
    {
        DetachFromDeadHelicopter();
    }
    CurrentHitEffectFadeTime -= (MaxHitEffectFadeTime * DeltaTime);
    // End:0x100
    if(CurrentHitEffectFadeTime <= 0.0000000)
    {
        // End:0xE0
        if(CurrentMaterialHitEffect != none)
        {
            CurrentMaterialHitEffect.bShowInGame = false;
        }
        // End:0xFD
        if(CurrentDOFHitEffect != none)
        {
            CurrentDOFHitEffect.bShowInGame = false;
        }        
    }
    else
    {
        // End:0x150
        if(CurrentMaterialHitEffect != none)
        {
            // End:0x150
            if(MaxHitEffectFadeTime != float(0))
            {
                MaterialInstanceConstant(CurrentMaterialHitEffect.Material).SetScalarParameterValue('Alpha', CurrentHitEffectFadeTime / MaxHitEffectFadeTime);
            }
        }
        // End:0x1AC
        if(CurrentDOFHitEffect != none)
        {
            // End:0x1AC
            if(MaxHitEffectFadeTime != float(0))
            {
                CurrentDOFHitEffect.MaxNearBlurAmount = (CurrentHitEffectFadeTime / MaxHitEffectFadeTime) * float(4);
                CurrentDOFHitEffect.MaxFarBlurAmount = (CurrentHitEffectFadeTime / MaxHitEffectFadeTime) * float(4);
            }
        }
    }
    damageSoundReTrigger += DeltaTime;
    //return;    
}

function bool ShouldDetachFromDeadHelicopter()
{
    local HeliPawnPersistent HeliPawn;

    HeliPawn = HeliPawnPersistent(GetHelicopter());
    // End:0x39
    if((HeliPawn != none) && HeliPawn.Health <= 0)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function DetachFromDeadHelicopter()
{
    local MountedWeapon theMountedWeapon;

    theMountedWeapon = PandoraPlayerController(Controller).GetMountedWeapon();
    // End:0x5D
    if(theMountedWeapon != none)
    {
        theMountedWeapon.Dismount(Controller);
        PandoraPlayerController(Controller).SetMountedWeapon(none);
    }
    // End:0x93
    if((Weapon != none) && SPWeapon(Weapon) != none)
    {
        SPWeapon(Weapon).DetachWeapon();
    }
    PlayDying(Class'SPDamageTypeGriffon', Location);
    //return;    
}

simulated function name HandToHandWeaponChoice(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Child;

    // End:0x2D
    if(int(Role) > int(ROLE_SimulatedProxy))
    {
        Child = SPWeapon(Weapon).WeapID;        
    }
    else
    {
        Child = CurrentWeaponAttachment.WeaponClass.default.WeapID;
    }
    return Child;
    //return ReturnValue;    
}

simulated function name FireAxeMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;

    // End:0x18
    if(m_bResetAction)
    {
        bResetChildOut = 1;
        m_bClearResetActionNextTick = true;
    }
    switch(m_fireAxeState)
    {
        // End:0x37
        case 3:
            retval = 'Idle';
            // End:0x51
            break;
        // End:0x4E
        case 0:
            retval = 'Firing';
            // End:0x51
            break;
        // End:0xFFFF
        default:
            break;
    }
    return retval;
    //return ReturnValue;    
}

simulated function name ReloadMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Child;
    local SPWeapon Weap;

    // End:0xCA
    if(int(Role) > int(ROLE_SimulatedProxy))
    {
        // End:0xC7
        if(Weapon != none)
        {
            Weap = SPWeapon(Weapon);
            // End:0xB8
            if(Weap.WeapID == 'shotgun')
            {
                // End:0x6C
                if(Weap.ReloadCount == 0)
                {
                    Child = 'Begin';
                }
                // End:0x90
                if(Weap.ReloadCount == 1)
                {
                    Child = 'Cycle';
                }
                // End:0xB5
                if(Weap.ReloadCount >= 2)
                {
                    Child = 'Finish';
                }                
            }
            else
            {
                Child = 'Finish';
            }
        }        
    }
    else
    {
        Child = 'Finish';
    }
    return Child;
    //return ReturnValue;    
}

simulated event ShotGunShellEjectNotify()
{
    // End:0x4E
    if((SPWeapon(Weapon) != none) && SPWeapon(Weapon).WeapID == 'shotgun')
    {
        SPWeapon(Weapon).SpawnShellCasing(true);
    }
    //return;    
}

simulated function bool GetFireAxeSuperHit()
{
    return m_bFiringSuperAttack;
    //return ReturnValue;    
}

function FireAxeSlomoSuperHitDisable()
{
    WorldInfo.Game.SetGameSpeed(1.0000000);
    //return;    
}

function SetFireAxeSlomoSuperHit(float delay)
{
    // End:0x1C
    if(delay == 0.0000000)
    {
        FireAxeSlomoSuperHit();        
    }
    else
    {
        SetTimer(delay, false, 'FireAxeSlomoSuperHit');
    }
    //return;    
}

function FireAxeSlomoSuperHit()
{
    // End:0x93
    if((m_bFiringSuperAttack && SPWeapon(Weapon) != none) && SPWeapon(Weapon).WeapID == 'FireAxe')
    {
        WorldInfo.Game.SetGameSpeed(SPWeapon(Weapon).m_SlomoSpeed);
        SetTimer(SPWeapon(Weapon).m_SlomoDuration, false, 'FireAxeSlomoSuperHitDisable');
    }
    //return;    
}

event FireAxeNotify()
{
    // End:0x0B
    if(m_bFiringSuperAttack)
    {
        return;
    }
    m_bFireAxeNotifyHit = true;
    // End:0xEA
    if(m_bFireAxeButtonPress)
    {
        // End:0xEA
        if((SPWeapon(Weapon) != none) && SPWeapon(Weapon).WeapID == 'FireAxe')
        {
            SPWeapon(Weapon).EnableSuperFireAttackSystem();
            SPWeapon(Weapon).m_bFireAxeHit = false;
            m_FireAxeSuperAudioComponent = CreateAudioComponent(mSoundCue_Siphon, false, true);
            // End:0xC3
            if(m_FireAxeSuperAudioComponent != none)
            {
                m_FireAxeSuperAudioComponent.bAutoDestroy = true;
                m_FireAxeSuperAudioComponent.Play();
            }
            m_bFireAxeSuper = true;
            m_bFiringSuperAttack = true;
            SPWeapon(Weapon).m_bCollisionCheckEnabled = false;
        }
    }
    //return;    
}

event EnableMultipleHitsNotify()
{
    // End:0x21
    if((m_bHandToHandFiring == true) && !m_bFiringSuperAttack)
    {
        m_bEnableMultipleHits = true;
    }
    //return;    
}

simulated function AnimusPulseFinished()
{
    m_bInAnimusPulse = false;
    //return;    
}

event FailSafeFireAxeFinished()
{
    StopFiringHandToHandWeapon();
    //return;    
}

event ResetFireAxe()
{
    ResetHandToHandWeapon();
    m_bFireAxeReset = false;
    //return;    
}

event DisableHandToHandCollisions()
{
    // End:0xA5
    if((SPWeapon(Weapon) != none) && SPWeapon(Weapon).WeapID == 'FireAxe')
    {
        SPWeapon(Weapon).m_bFireAxeHit = false;
        SPWeapon(Weapon).DisableSuperFireAttackSystem();
        SPWeapon(Weapon).m_bCollisionCheckEnabled = false;
        // End:0x9D
        if(m_FireAxeSuperAudioComponent != none)
        {
            m_FireAxeSuperAudioComponent.Stop();
            m_FireAxeSuperAudioComponent = none;
        }
        m_bFiringSuperAttack = false;
    }
    //return;    
}

event EnableHandToHandCollisions()
{
    // End:0x5D
    if((SPWeapon(Weapon).WeapID == 'FireAxe') && !m_bFireAxeSuper)
    {
        SPWeapon(Weapon).m_bFireAxeHit = true;
        SPWeapon(Weapon).m_bCollisionCheckEnabled = true;
    }
    //return;    
}

function DetermineHandToHandAnim()
{
    // End:0x2C
    if(SPWeapon(Weapon).WeapID == 'FireAxe')
    {
        GetFireAxeWallCondition();
    }
    //return;    
}

simulated event int CheckFireAxeWallCondition()
{
    return int(m_fireAxeFailSafe);
    //return ReturnValue;    
}

simulated function GetFireAxeWallCondition()
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local Vector LookAtVec, RightVec, RightVecStartPos, cameraLoc;
    local Rotator cameraRot;
    local PandoraPlayerController thePlayerController;

    thePlayerController = PandoraPlayerController(Controller);
    // End:0x1D
    if(thePlayerController == none)
    {
        return;
    }
    thePlayerController.GetPlayerViewPoint(cameraLoc, cameraRot);
    LookAtVec = Normal(GetPlayerCameraLookAtVector());
    RightVec = LookAtVec Cross vect(0.0000000, 0.0000000, 1.0000000);
    RightVec *= 100.0000000;
    LookAtVec *= 150.0000000;
    RightVecStartPos = LookAtVec + cameraLoc;
    HitActor = Trace(HitLocation, HitNormal, RightVecStartPos + RightVec, RightVecStartPos, true,, HitInfo, 10, true);
    // End:0x104
    if(HitActor == none)
    {
        RightVec *= -1.0000000;
        HitActor = Trace(HitLocation, HitNormal, RightVecStartPos + RightVec, RightVecStartPos, true,, HitInfo, 10, true);
    }
    // End:0x14B
    if((HitActor != none) && HitActor.bStatic || HitActor.bWorldGeometry)
    {
        m_fireAxeState = 0;
        m_fireAxeFailSafe = 0;
        return;
    }
    DetermineFireAxeAnim();
    //return;    
}

function DetermineFireAxeAnim()
{
    local float randSwingVar;

    m_fireAxeState = 0;
    randSwingVar = float(Rand(100));
    // End:0x2D
    if(randSwingVar > float(66))
    {
        m_fireAxeFailSafe = 0;        
    }
    else
    {
        // End:0x46
        if(randSwingVar < float(33))
        {
            m_fireAxeFailSafe = 1;            
        }
        else
        {
            m_fireAxeFailSafe = 2;
        }
    }
    //return;    
}

function ResetHandToHandWeapon()
{
    m_bHandToHandFiring = false;
    //return;    
}

simulated function ResetFireAxeFromStaticHit()
{
    m_bHandToHandFiring = false;
    m_bFireAxeStaticHit = false;
    //return;    
}

simulated function SetStaticHitParameter()
{
    m_bFireAxeStaticHit = true;
    //return;    
}

function StopFiringHandToHandWeapon()
{
    local PandoraPlayerController thePlayerController;

    thePlayerController = PandoraPlayerController(Controller);
    // End:0x1D
    if(thePlayerController == none)
    {
        return;
    }
    // End:0x3C
    if(m_bFireAxeStaticHit)
    {
        SetTimer(0.1000000, false, 'ResetFireAxeFromStaticHit');        
    }
    else
    {
        m_bHandToHandFiring = false;
    }
    thePlayerController.StopFiringFromHandToHand();
    m_bResetAction = true;
    m_fireAxeState = 3;
    //return;    
}

simulated function bool CheckForHandToHandWeapon()
{
    // End:0x48
    if(int(Role) < int(ROLE_AutonomousProxy))
    {
        // End:0x46
        if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.WeaponClass.default.WeapID == 'FireAxe')
        {
            return true;
        }
        return false;
    }
    // End:0x8B
    if(((Weapon != none) && SPWeapon(Weapon) != none) && SPWeapon(Weapon).WeapID == 'FireAxe')
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CheckForHandToHandFiring()
{
    return m_bHandToHandFiring;
    //return ReturnValue;    
}

function SetHandToHandFiring()
{
    m_bHandToHandFiring = true;
    // End:0x3C
    if((Weapon != none) && SPWeapon(Weapon) != none)
    {
        SPWeapon(Weapon).m_bCanFire = false;
    }
    //return;    
}

function TriggerExplosion()
{
    // End:0x75
    if(((Weapon != none) && SPWeapon(Weapon) != none) && SPWeapon(Weapon).WeapID == 'RocketLauncher')
    {
        // End:0x75
        if(SPWeapon(Weapon).m_bExplosionEnabled == true)
        {
            SPWeapon(Weapon).ExplodeRocketFromTrigger();
        }
    }
    //return;    
}

simulated function name FiringModeMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Child;

    // End:0x1B
    if(bInEquip)
    {
        Child = 'Equipping';        
    }
    else
    {
        // End:0x36
        if(bInUnequip)
        {
            Child = 'Unequipping';            
        }
        else
        {
            // End:0x51
            if(IsPlayerReloading())
            {
                Child = 'Reloading';                
            }
            else
            {
                // End:0x6C
                if(m_bFireAxeSuper)
                {
                    Child = 'FireAxeSuper';                    
                }
                else
                {
                    // End:0xD2
                    if(IsFiring())
                    {
                        // End:0xA1
                        if(int(Role) < int(ROLE_AutonomousProxy))
                        {
                            // End:0xA1
                            if(m_bResetFireAnim)
                            {
                                bResetChildOut = 1;
                                m_bClearResetFireAnimNextTick = true;
                            }
                        }
                        // End:0xC0
                        if(CheckForHandToHandWeapon())
                        {
                            Child = 'HandToHandWeaponFiring';                            
                        }
                        else
                        {
                            Child = 'Firing';
                        }                        
                    }
                    else
                    {
                        // End:0xED
                        if(m_bInAnimusPulse)
                        {
                            Child = 'AnimusPulse';                            
                        }
                        else
                        {
                            // End:0x108
                            if(m_bAnimusDrain)
                            {
                                Child = 'AnimusDrain';                                
                            }
                            else
                            {
                                // End:0x131
                                if(IsSiphoningOrDraining() || CollectAnimNodeStatus < 3)
                                {
                                    Child = 'Siphoning';                                    
                                }
                                else
                                {
                                    // End:0x15A
                                    if(bInHeal || HealAnimNodeStatus < 3)
                                    {
                                        Child = 'Healing';                                        
                                    }
                                    else
                                    {
                                        // End:0x17C
                                        if(int(m_eGrenadeState) == int(1))
                                        {
                                            Child = 'Priming';                                            
                                        }
                                        else
                                        {
                                            // End:0x19E
                                            if(int(m_eGrenadeState) == int(3))
                                            {
                                                Child = 'ThrowWeapon_Under';                                                
                                            }
                                            else
                                            {
                                                // End:0x1C0
                                                if(int(m_eGrenadeState) == int(2))
                                                {
                                                    Child = 'ThrowWeapon_Over';                                                    
                                                }
                                                else
                                                {
                                                    // End:0x1DB
                                                    if(m_bFireAxeBlocking)
                                                    {
                                                        Child = 'FireAxeBlocking';                                                        
                                                    }
                                                    else
                                                    {
                                                        Child = 'Main';
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return Child;
    //return ReturnValue;    
}

simulated function name IsInADSMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x17
    if(GetIsFullyLookingDownSite())
    {
        return 'InADS';
    }
    return 'NotInADS';
    //return ReturnValue;    
}

simulated function name IsInADSTransitionMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x1F
    if(int(GetADSTransitionState()) == int(0))
    {
        return 'NotDoingADSTransition';
    }
    // End:0x3E
    if(int(GetADSTransitionState()) == int(1))
    {
        return 'TransitioningIntoADS';
    }
    return 'TransitioningOutOfADS';
    //return ReturnValue;    
}

simulated function IntoADSFinished()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerIntoADSFinished();
    }
    IntoADSFinishedForAll();
    //return;    
}

reliable server function ServerIntoADSFinished()
{
    IntoADSFinishedForAll();
    //return;    
}

simulated function IntoADSFinishedForAll()
{
    ADSTransitionStatus = 0;
    SetLookDownSitePercent(1.0000000);
    //return;    
}

simulated function OutOfADSFinished()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerOutOfADSFinished();
    }
    OutOfADSFinishedForAll();
    //return;    
}

reliable server function ServerOutOfADSFinished()
{
    OutOfADSFinishedForAll();
    //return;    
}

simulated function OutOfADSFinishedForAll()
{
    local PandoraPlayerController thePlayerController;

    thePlayerController = PandoraPlayerController(Controller);
    ADSTransitionStatus = 0;
    SetLookDownSitePercent(0.0000000);
    // End:0x5B
    if((thePlayerController != none) && thePlayerController.m_bWantsToLookDownSite)
    {
        thePlayerController.DoReloadFromADSTransition();
    }
    //return;    
}

simulated function name ADSFiringModeMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x2F
    if(IsFiring())
    {
        // End:0x25
        if(m_bADSResetWeaponFire)
        {
            bResetChildOut = 1;
            m_bADSResetWeaponFireNextTick = true;
        }
        return 'Firing';
    }
    return 'Idling';
    //return ReturnValue;    
}

simulated function name ToSprintTransitionInit(SPAnimGenericFunctionMonitorNode Node)
{
    InSprintAnimNodeStatus = 1;
    return 'None';
    //return ReturnValue;    
}

simulated function name IdleModeMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Child;

    // End:0x1D
    if(InSprintAnimNodeStatus != 0)
    {
        Child = 'ToIdle';        
    }
    else
    {
        Child = 'InIdle';
    }
    return Child;
    //return ReturnValue;    
}

simulated function name MoveModeMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Child;

    // End:0x1D
    if(InSprintAnimNodeStatus != 0)
    {
        Child = 'ToMove';        
    }
    else
    {
        Child = 'InMove';
    }
    return Child;
    //return ReturnValue;    
}

simulated function name SprintModeMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Child;

    // End:0x1D
    if(InSprintAnimNodeStatus == 1)
    {
        Child = 'ToSprint';        
    }
    else
    {
        Child = 'InSprint';
    }
    return Child;
    //return ReturnValue;    
}

simulated function ToIdleOut()
{
    InSprintAnimNodeStatus = 0;
    //return;    
}

simulated function ToMoveOut()
{
    InSprintAnimNodeStatus = 0;
    //return;    
}

simulated function ToSprintOut()
{
    InSprintAnimNodeStatus = 0;
    //return;    
}

simulated function BeginOut()
{
    local SPWeapon Weap;

    // End:0x40
    if(Weapon != none)
    {
        Weap = SPWeapon(Weapon);
        Weap.ReloadCount = 1;
        Weap.PlayCycleAnim();
    }
    //return;    
}

simulated function FinishOut()
{
    // End:0x24
    if(Weapon != none)
    {
        SPWeapon(Weapon).ReloadFinished();
    }
    //return;    
}

simulated function name ToCollectTransitionInit(SPAnimGenericFunctionMonitorNode Node)
{
    CollectAnimNodeStatus = 0;
    return 'None';
    //return ReturnValue;    
}

simulated function ToCollectOut()
{
    CollectAnimNodeStatus = 1;
    //return;    
}

simulated function OutCollectOut()
{
    CollectAnimNodeStatus = 3;
    //return;    
}

simulated function name CollectModeMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Child;

    // End:0x29
    if(!IsSiphoningOrDraining() && CollectAnimNodeStatus < 2)
    {
        SetCollectAnimNodeStatusNextTick = true;
        CollectAnimNodeStatusNextTick = 2;
    }
    // End:0x46
    if(CollectAnimNodeStatus == 0)
    {
        Child = 'ToCollect';        
    }
    else
    {
        // End:0x63
        if(CollectAnimNodeStatus == 1)
        {
            Child = 'InCollect';            
        }
        else
        {
            Child = 'OutCollect';
        }
    }
    return Child;
    //return ReturnValue;    
}

simulated function name ToHealTransitionInit(SPAnimGenericFunctionMonitorNode Node)
{
    HealAnimNodeStatus = 0;
    return 'None';
    //return ReturnValue;    
}

function ToHealOut()
{
    HealAnimNodeStatus = 1;
    //return;    
}

function OutHealOut()
{
    HealAnimNodeStatus = 3;
    //return;    
}

simulated function name HealModeMonitor(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name Child;

    // End:0x29
    if(!bInHeal && HealAnimNodeStatus < 2)
    {
        SetHealAnimNodeStatusNextTick = true;
        HealAnimNodeStatusNextTick = 2;
    }
    // End:0x46
    if(HealAnimNodeStatus == 0)
    {
        Child = 'ToHeal';        
    }
    else
    {
        // End:0x63
        if(HealAnimNodeStatus == 1)
        {
            Child = 'InHeal';            
        }
        else
        {
            Child = 'OutHeal';
        }
    }
    return Child;
    //return ReturnValue;    
}

reliable client simulated function PlayAmbxEffectForThisTypeOfDamage(float DamageAmount, Vector HitLocation, class<DamageType> DamageType)
{
    local int hitDirYaw, relHitDirYaw, finalPawnYaw;
    local PlayerPawn.eAmBxCompassDir amBxDirOfHit;
    local string nameAmBxDirOfHit;

    // End:0x17
    if(WorldInfo.IsConsoleBuild(1))
    {
        return;
    }
    // End:0x2E
    if(WorldInfo.IsConsoleBuild(2))
    {
        return;
    }
    // End:0x7B
    if(DamageType == Class'SPDamageTypeBloodTickExplosion')
    {
        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeBloodTickExplosion", 200);        
    }
    else
    {
        // End:0xCD
        if(DamageType == Class'SPDamageTypeExplosionFireDrakeDeath')
        {
            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeExplosionFireDrakeDeath", 200);            
        }
        else
        {
            // End:0x122
            if(DamageType == Class'SPDamageTypeExplosionFireDrakeImmolate')
            {
                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeExplosionFireDrakeImmolate", 200);                
            }
            else
            {
                // End:0x16D
                if(DamageType == Class'SPDamageTypeExplosionGrenade')
                {
                    PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeExplosionGrenade", 200);                    
                }
                else
                {
                    // End:0x1BF
                    if(DamageType == Class'SPDamageTypeExplosionRocketLauncher')
                    {
                        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeExplosionRocketLauncher", 200);                        
                    }
                    else
                    {
                        // End:0x209
                        if(DamageType == Class'SPDamageTypeKrakenExplosion')
                        {
                            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeKrakenExplosion", 200);                            
                        }
                        else
                        {
                            // End:0x25A
                            if(DamageType == Class'SPDamageTypeSewerTentacleExplosion')
                            {
                                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeSewerTentacleExplosion", 200);                                
                            }
                            else
                            {
                                // End:0x2A1
                                if(DamageType == Class'SPDamageTypeExplosionAny')
                                {
                                    PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeExplosionAny", 200);                                    
                                }
                                else
                                {
                                    // End:0x2E3
                                    if(DamageType == Class'SPDamageTypeGriffon')
                                    {
                                        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeGriffon", 200);                                        
                                    }
                                    else
                                    {
                                        // End:0x323
                                        if(DamageType == Class'SPDamageTypeHuman')
                                        {
                                            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeHuman", 200);                                            
                                        }
                                        else
                                        {
                                            // End:0x368
                                            if(DamageType == Class'SPDamageTypeMelee_Bite')
                                            {
                                                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeMelee_Bite", 200);                                                
                                            }
                                            else
                                            {
                                                // End:0x3AC
                                                if(DamageType == Class'SPDamageTypeMelee_Hit')
                                                {
                                                    PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeMelee_Hit", 200);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x3F2
                                                    if(DamageType == Class'SPDamageTypeMelee_Slash')
                                                    {
                                                        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeMelee_Slash", 200);                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x439
                                                        if(DamageType == Class'SPDamageTypeTentacleGrab')
                                                        {
                                                            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeTentacleGrab", 200);                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x480
                                                            if(DamageType == Class'SPDamageTypeWerewolfSlam')
                                                            {
                                                                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeWerewolfSlam", 200);                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x4C3
                                                                if(DamageType == Class'SPDamageTypeMeleeAny')
                                                                {
                                                                    PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeMeleeAny", 200);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x511
                                                                    if(DamageType == Class'SPDamageTypeImpactFireDrakeSpit')
                                                                    {
                                                                        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeImpactFireDrakeSpit", 200);                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x557
                                                                        if(DamageType == Class'SPDamageTypeImpactFlame')
                                                                        {
                                                                            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeImpactFlame", 200);                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x59F
                                                                            if(DamageType == Class'SPDamageTypeImpactGrenade')
                                                                            {
                                                                                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeImpactGrenade", 200);                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x5EA
                                                                                if(DamageType == Class'SPDamageTypeImpactNariScream')
                                                                                {
                                                                                    PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeImpactNariScream", 200);                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x639
                                                                                    if(DamageType == Class'SPDamageTypeImpactRocketLauncher')
                                                                                    {
                                                                                        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeImpactRocketLauncher", 200);                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0x67D
                                                                                        if(DamageType == Class'SPDamageTypeImpactZap')
                                                                                        {
                                                                                            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeImpactZap", 200);                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0x6C4
                                                                                            if(DamageType == Class'SPDamageTypeAssaultRifle')
                                                                                            {
                                                                                                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeAssaultRifle", 200);                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // End:0x706
                                                                                                if(DamageType == Class'SPDamageTypeMinigun')
                                                                                                {
                                                                                                    PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeMinigun", 200);                                                                                                    
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    // End:0x74C
                                                                                                    if(DamageType == Class'SPDamageTypeSniperRifle')
                                                                                                    {
                                                                                                        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeSniperRifle", 200);                                                                                                        
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        // End:0x78A
                                                                                                        if(DamageType == Class'SPDamageType9MM')
                                                                                                        {
                                                                                                            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageType9MM", 200);                                                                                                            
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            // End:0x7C8
                                                                                                            if(DamageType == Class'SPDamageTypeDesertEagle')
                                                                                                            {
                                                                                                                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageType9MM", 200);                                                                                                                
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                // End:0x809
                                                                                                                if(DamageType == Class'SPDamageTypeHK_UMP')
                                                                                                                {
                                                                                                                    PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeHK_UMP", 200);                                                                                                                    
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    // End:0x84A
                                                                                                                    if(DamageType == Class'SPDamageTypePistol')
                                                                                                                    {
                                                                                                                        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypePistol", 200);                                                                                                                        
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        // End:0x88C
                                                                                                                        if(DamageType == Class'SPDamageTypeShotgun')
                                                                                                                        {
                                                                                                                            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeShotgun", 200);                                                                                                                            
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            // End:0x8D0
                                                                                                                            if(DamageType == Class'SPDamageTypeRigidBody')
                                                                                                                            {
                                                                                                                                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeRigidBody", 200);                                                                                                                                
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                // End:0x90F
                                                                                                                                if(DamageType == Class'SPDamageTypeFall')
                                                                                                                                {
                                                                                                                                    PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeFall", 200);                                                                                                                                    
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    // End:0x955
                                                                                                                                    if(DamageType == Class'SPDamageTypeAnimusPulse')
                                                                                                                                    {
                                                                                                                                        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeAnimusPulse", 200);                                                                                                                                        
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        // End:0x997
                                                                                                                                        if(DamageType == Class'SPDamageTypeJavelin')
                                                                                                                                        {
                                                                                                                                            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeJavelin", 200);                                                                                                                                            
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            // End:0x9D8
                                                                                                                                            if(DamageType == Class'SPDamageTypePoison')
                                                                                                                                            {
                                                                                                                                                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypePoison", 200);                                                                                                                                                
                                                                                                                                            }
                                                                                                                                            else
                                                                                                                                            {
                                                                                                                                                // End:0xA19
                                                                                                                                                if(DamageType == Class'SPDamageTypeKismet')
                                                                                                                                                {
                                                                                                                                                    PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeKismet", 200);                                                                                                                                                    
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                    // End:0xA5F
                                                                                                                                                    if(DamageType == Class'SPDamageTypeSonicAttack')
                                                                                                                                                    {
                                                                                                                                                        PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeSonicAttack", 200);                                                                                                                                                        
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        // End:0xA9F
                                                                                                                                                        if(DamageType == Class'SPDamageTypeWater')
                                                                                                                                                        {
                                                                                                                                                            PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeWater", 200);                                                                                                                                                            
                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            // End:0xADE
                                                                                                                                                            if(DamageType == Class'SPDamageTypeFire')
                                                                                                                                                            {
                                                                                                                                                                PandoraPlayerController(Controller).PlayAmBxScript("SPDamageTypeFire", 200);                                                                                                                                                                
                                                                                                                                                            }
                                                                                                                                                        }
                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    hitDirYaw = Rotator(HitLocation - Location).Yaw;
    J0xAFD:

    // End:0xB21 [Loop If]
    if(hitDirYaw > 65535)
    {
        hitDirYaw = hitDirYaw - 65535;
        // [Loop Continue]
        goto J0xAFD;
    }
    J0xB21:

    // End:0xB41 [Loop If]
    if(hitDirYaw < 0)
    {
        hitDirYaw = 65535 + hitDirYaw;
        // [Loop Continue]
        goto J0xB21;
    }
    finalPawnYaw = Rotation.Yaw;
    J0xB57:

    // End:0xB7B [Loop If]
    if(finalPawnYaw > 65535)
    {
        finalPawnYaw = finalPawnYaw - 65535;
        // [Loop Continue]
        goto J0xB57;
    }
    J0xB7B:

    // End:0xB9B [Loop If]
    if(finalPawnYaw < 0)
    {
        finalPawnYaw = 65535 + finalPawnYaw;
        // [Loop Continue]
        goto J0xB7B;
    }
    relHitDirYaw = hitDirYaw - finalPawnYaw;
    J0xBAD:

    // End:0xBD1 [Loop If]
    if(relHitDirYaw > 65535)
    {
        relHitDirYaw = relHitDirYaw - 65535;
        // [Loop Continue]
        goto J0xBAD;
    }
    J0xBD1:

    // End:0xBF1 [Loop If]
    if(relHitDirYaw < 0)
    {
        relHitDirYaw = 65535 + relHitDirYaw;
        // [Loop Continue]
        goto J0xBD1;
    }
    amBxDirOfHit = PandoraPlayerController(Controller).RelativeAmBxDirFromRelYaw(relHitDirYaw);
    nameAmBxDirOfHit = PandoraPlayerController(Controller).NameOfAmBxCompassDir(amBxDirOfHit);
    // End:0xC87
    if(DamageAmount >= m_AmBxHighDamageEffectThreshold)
    {
        PandoraPlayerController(Controller).PlayAmBxScriptPOV("SPDamageDirectionalHigh", nameAmBxDirOfHit, 800);        
    }
    else
    {
        // End:0xCD7
        if(DamageAmount >= m_AmBxMediumDamageEffectThreshold)
        {
            PandoraPlayerController(Controller).PlayAmBxScriptPOV("SPDamageDirectionalMedium", nameAmBxDirOfHit, 800);            
        }
        else
        {
            PandoraPlayerController(Controller).PlayAmBxScriptPOV("SPDamageDirectionalLow", nameAmBxDirOfHit, 800);
        }
    }
    //return;    
}

reliable client simulated function StopAmbxEffectForCurrentWeapon()
{
    PandoraPlayerController(Controller).ForceStopAmBxScript("WeaponStopAll");
    //return;    
}

function AdjustDamage(out int inDamage, out Vector Momentum, Controller instigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local int MaxDamage;

    // End:0x40
    if(ClassIsChildOf(DamageType, Class'SPDamageTypeRigidBody'))
    {
        MaxDamage = m_PlayerGDTuneData.MaxRigidBodyDamage;
        // End:0x40
        if(inDamage > MaxDamage)
        {
            inDamage = MaxDamage;
        }
    }
    //return;    
}

function PlayDeathSound(class<DamageType> killShotDamageType)
{
    // End:0x23
    if(class<SPDamageTypeProjectileAny>(killShotDamageType) != none)
    {
        PlaySound(deathSound_Bullet, true);        
    }
    else
    {
        // End:0x46
        if(class<SPDamageTypeImpactTrain>(killShotDamageType) != none)
        {
            PlaySound(deathSound_Train, true);            
        }
        else
        {
            // End:0x69
            if(class<SPDamageTypeFall>(killShotDamageType) != none)
            {
                PlaySound(deathSound_Fall, true);                
            }
            else
            {
                // End:0x8C
                if(class<SPDamageTypeImpactZap>(killShotDamageType) != none)
                {
                    PlaySound(deathSound_Zapped, true);                    
                }
                else
                {
                    // End:0xC1
                    if((class<SPDamageTypeFire>(killShotDamageType) != none) || class<SPDamageTypeImpactFlame>(killShotDamageType) != none)
                    {
                        PlaySound(deathSound_Fire, true);                        
                    }
                    else
                    {
                        // End:0xE4
                        if(class<SPDamageTypeRigidBody>(killShotDamageType) != none)
                        {
                            PlaySound(deathSound_Object, true);                            
                        }
                        else
                        {
                            // End:0x10D
                            if((class<SPDamageTypeKrakenExplosion>(killShotDamageType) != none) || false)
                            {
                                PlaySound(deathSound_Smash, true);                                
                            }
                            else
                            {
                                // End:0x142
                                if((class<SPDamageTypeTentacleGrab>(killShotDamageType) != none) || class<SPDamageTypeSewerTentacleExplosion>(killShotDamageType) != none)
                                {
                                    PlaySound(deathSound_Tentacle, true);                                    
                                }
                                else
                                {
                                    // End:0x165
                                    if(class<SPDamageTypeBloodTickExplosion>(killShotDamageType) != none)
                                    {
                                        PlaySound(deathSound_Bloodtick_Expl, true);                                        
                                    }
                                    else
                                    {
                                        // End:0x188
                                        if(class<SPDamageTypeImpactFireDrakeSpit>(killShotDamageType) != none)
                                        {
                                            PlaySound(deathSound_FireDrakeSpit, true);                                            
                                        }
                                        else
                                        {
                                            // End:0x1AB
                                            if(class<SPDamageTypeExplosionAny>(killShotDamageType) != none)
                                            {
                                                PlaySound(deathSound_Explosion, true);                                                
                                            }
                                            else
                                            {
                                                // End:0x1CE
                                                if(class<SPDamageTypeMeleeAny>(killShotDamageType) != none)
                                                {
                                                    PlaySound(deathSound_Melee, true);                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function PlayDamageSound(class<DamageType> damageShotDamageType)
{
    // End:0x23
    if(class<SPDamageTypeProjectileAny>(damageShotDamageType) != none)
    {
        PlaySound(damageSound_Bullet, true);        
    }
    else
    {
        // End:0x46
        if(class<SPDamageTypeFall>(damageShotDamageType) != none)
        {
            PlaySound(damageSound_Fall, true);            
        }
        else
        {
            // End:0x69
            if(class<SPDamageTypeBloodTickExplosion>(damageShotDamageType) != none)
            {
                PlaySound(damageSound_Bloodtick_Expl, true);                
            }
            else
            {
                // End:0x8C
                if(class<SPDamageTypeExplosionAny>(damageShotDamageType) != none)
                {
                    PlaySound(damageSound_Explosion, true);                    
                }
                else
                {
                    // End:0xAF
                    if(class<SPDamageTypeImpactZap>(damageShotDamageType) != none)
                    {
                        PlaySound(damageSound_Zapped, true);                        
                    }
                    else
                    {
                        // End:0xFE
                        if((class<SPDamageTypeFire>(damageShotDamageType) != none) || class<SPDamageTypeImpactFlame>(damageShotDamageType) != none)
                        {
                            // End:0xFB
                            if(damageSoundReTrigger > FIRE_RETRIGGER_DELAY)
                            {
                                PlaySound(damageSound_Fire, true);
                                damageSoundReTrigger = 0.0000000;
                            }                            
                        }
                        else
                        {
                            // End:0x127
                            if((class<SPDamageTypeKrakenExplosion>(damageShotDamageType) != none) || false)
                            {
                                PlaySound(damageSound_Smash, true);                                
                            }
                            else
                            {
                                // End:0x15C
                                if((class<SPDamageTypeTentacleGrab>(damageShotDamageType) != none) || class<SPDamageTypeSewerTentacleExplosion>(damageShotDamageType) != none)
                                {
                                    PlaySound(damageSound_Tentacle, true);                                    
                                }
                                else
                                {
                                    // End:0x17F
                                    if(class<SPDamageTypeGriffon>(damageShotDamageType) != none)
                                    {
                                        PlaySound(damageSound_Griffon, true);                                        
                                    }
                                    else
                                    {
                                        // End:0x1C6
                                        if(((class<SPDamageTypeMelee_Hit>(damageShotDamageType) != none) || class<SPDamageTypeMinotaurHit>(damageShotDamageType) != none) || class<SPDamageTypeGriffonFlyingHit>(damageShotDamageType) != none)
                                        {
                                            PlaySound(damageSound_Melee_Hit, true);                                            
                                        }
                                        else
                                        {
                                            // End:0x1FB
                                            if((class<SPDamageTypeMelee_Slash>(damageShotDamageType) != none) || class<SPDamageTypeNari>(damageShotDamageType) != none)
                                            {
                                                PlaySound(damageSound_Melee_Slash, true);                                                
                                            }
                                            else
                                            {
                                                // End:0x21E
                                                if(class<SPDamageTypeMelee_Bite>(damageShotDamageType) != none)
                                                {
                                                    PlaySound(damageSound_Melee_Bite, true);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x265
                                                    if(((class<SPDamageTypeImpactFireDrakeSpit>(damageShotDamageType) != none) && class<SPDamageTypeImpactFireDrakeSpitDOT>(damageShotDamageType) == none) || class<SPDamageTypeImpactRubble>(damageShotDamageType) != none)
                                                    {
                                                        PlaySound(damageSound_Rubble, true);                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x288
                                                        if(class<SPDamageTypeRigidBody>(damageShotDamageType) != none)
                                                        {
                                                            PlaySound(damageSound_Object, true);                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

reliable client simulated function ClientTakeDamage(float DamageAmount, Vector HitLocation, class<DamageType> DamageType)
{
    PlayAmbxEffectForThisTypeOfDamage(DamageAmount, HitLocation, DamageType);
    // End:0xAD
    if(Health <= 0)
    {
        PlayDeathSound(DamageType);
        // End:0x5E
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            Mesh.SetOwnerNoSee(true);
        }
        StopAmbxEffectForCurrentWeapon();
        PandoraPlayerController(Controller).StopInGameAmBX();
        PandoraPlayerController(Controller).PlayAmBxScript("player_death", 200);        
    }
    else
    {
        // End:0xDF
        if(PandoraGameViewportClient(PandoraPlayerController(Controller).GetViewportClient()).FullScreenIsMoviePlaying())
        {
            return;            
        }
        else
        {
            PlayDamageSound(DamageType);
        }
    }
    // End:0x17E
    if(class<SPDamageTypeProjectileAny>(DamageType) != none)
    {
        // End:0x134
        if((sinceLastHitSound > 0.5000000) && int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            sinceLastHitSound = 0.0000000;
        }
        // End:0x17E
        if((playerHud != none) && playerHud.GetEffectsManager() != none)
        {
            playerHud.GetEffectsManager().ActivateBulletEffect();
        }
    }
    // End:0x191
    if(class<SPDamageTypeMeleeAny>(DamageType) != none)
    {        
    }
    else
    {
        ShakeCamera(DamageType);
    }
    //return;    
}

simulated event ProcEffects(float DamageAmount, Pawn DamageInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super.ProcEffects(DamageAmount, DamageInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x71
    if((IsLocallyControlled() == false) && (int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        return;
    }
    // End:0xAA
    if(class<SPDamageTypeMeleeAny>(DamageType) != none)
    {
        // End:0xAA
        if(DamageInstigator != none)
        {
            DoMeleeEffect(SPPawn(DamageInstigator), DamageAmount, HitLocation);
        }
    }
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local PandoraPlayerController PC;
    local Actor InstigatorActor;
    local bool bValidActor;

    InstigatorActor = none;
    bValidActor = false;
    // End:0x2E
    if((class<SPDamageTypeMeleeAny>(DamageType) != none) && m_bFireAxeBlocking)
    {
        return;
    }
    // End:0x45
    if(WorldInfo.Game == none)
    {
        return;
    }
    // End:0xB1
    if((WorldInfo.Game.IsA('PandoraSPGameInfo') && EventInstigator != none) && EventInstigator.IsA('SPAIController'))
    {
        // End:0xB1
        if(SPAIController(EventInstigator).IsFriendly(Controller))
        {
            return;
        }
    }
    PC = PandoraPlayerController(Controller);
    // End:0x105
    if((PC != none) && PC.IsInWerewolfTackleState())
    {
        // End:0x105
        if(PC.GetCurrentTMGEnemy() != EventInstigator)
        {
            return;
        }
    }
    super(SPPawn).ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    lastDamagedTime = WorldInfo.TimeSeconds;
    SetNoRegenTime(noRegenTimeAfterDamage);
    // End:0x191
    if((EventInstigator != none) && EventInstigator.Pawn != none)
    {
        InstigatorActor = EventInstigator.Pawn;
        bValidActor = true;
    }
    // End:0x210
    if(DamageCauser != none)
    {
        // End:0x1C2
        if(Pawn(DamageCauser) != none)
        {
            InstigatorActor = DamageCauser;
            bValidActor = true;            
        }
        else
        {
            // End:0x210
            if((Controller(DamageCauser) != none) && Controller(DamageCauser).Pawn != none)
            {
                InstigatorActor = Controller(DamageCauser).Pawn;
                bValidActor = true;
            }
        }
    }
    InitiateDamageIndicators(InstigatorActor, bValidActor, DamageType, HitLocation);
    // End:0x292
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0x292
        if(Health <= 0)
        {
            // End:0x292
            if(EventInstigator.Pawn != none)
            {
                PlayerController(Controller).SetViewTarget(EventInstigator.Pawn);
            }
        }
    }
    ClientTakeDamage(DamageAmount, HitLocation, DamageType);
    //return;    
}

unreliable client simulated function InitiateDamageIndicators(Actor TheActor, bool bValidActor, class<DamageType> DamageType, Vector InstigatorLoc)
{
    local PandoraPlayerController PC;

    PC = PandoraPlayerController(Controller);
    // End:0x31
    if(bValidActor)
    {
        DamageIndicatorManager.AddNewDamageFromActor(TheActor);        
    }
    else
    {
        DamageIndicatorManager.AddNewDamageFromLocation(InstigatorLoc);
    }
    // End:0x10D
    if((playerHud != none) && playerHud.GetEffectsManager() != none)
    {
        // End:0xB5
        if((class<SPDamageTypeImpactFlame>(DamageType) != none) || class<SPDamageTypeExplosionFireDrakeImmolate>(DamageType) != none)
        {
            playerHud.GetEffectsManager().ActivateFireDamageEffect();            
        }
        else
        {
            // End:0xEB
            if(class<SPDamageTypeSonicAttack>(DamageType) != none)
            {
                playerHud.GetEffectsManager().ActivateSonicDamageEffect();                
            }
            else
            {
                // End:0x10D
                if((class<SPDamageTypeImpactNariScream>(DamageType) != none) || class<SPDamageTypeNari>(DamageType) != none)
                {
                }
            }
        }
    }
    // End:0x1AD
    if((PC != none) && class<SPDamageTypePoison>(DamageType) != none)
    {
        // End:0x16A
        if(TheActor.IsA('SPBloodTickPawnPersistent'))
        {
            PC.ClientSpawnCameraBlood(SPBloodTickPawnPersistent(TheActor).CameraBloodEmitterClass);
        }
        AudioComp_BloodHUDSplatter = CreateAudioComponent(mSoundCue_BloodHUDSplatterLoop, false, true);
        // End:0x1AD
        if(AudioComp_BloodHUDSplatter != none)
        {
            AudioComp_BloodHUDSplatter.bAutoDestroy = true;
            AudioComp_BloodHUDSplatter.Play();
        }
    }
    //return;    
}

function float MeleeEffectReductionScale()
{
    local bool bFirstHit;
    local float Scale, timeSinceFirstHit;
    local PandoraPlayerController PPC;
    local PandoraPlayerInput PPI;

    PPC = PandoraPlayerController(Controller);
    PPI = PandoraPlayerInput(PPC.PlayerInput);
    // End:0x57
    if(PPI.MeleeImpactShakeParams.MultiHitReductionTimeOut <= float(0))
    {
        bFirstHit = true;        
    }
    else
    {
        // End:0x6F
        if(MeleeFirstHitTime == float(0))
        {
            bFirstHit = true;            
        }
        else
        {
            // End:0xAF
            if((MeleeFirstHitTime + PPI.MeleeImpactShakeParams.MultiHitReductionTimeOut) < WorldInfo.TimeSeconds)
            {
                bFirstHit = true;                
            }
            else
            {
                bFirstHit = false;
            }
        }
    }
    // End:0xE3
    if(bFirstHit)
    {
        Scale = 1.0000000;
        MeleeFirstHitTime = WorldInfo.TimeSeconds;        
    }
    else
    {
        timeSinceFirstHit = WorldInfo.TimeSeconds - MeleeFirstHitTime;
        // End:0x16A
        if((PPI.MeleeImpactShakeParams.MultiHitTimeTakenToReduce == float(0)) || timeSinceFirstHit >= PPI.MeleeImpactShakeParams.MultiHitTimeTakenToReduce)
        {
            Scale = Class'PandoraPlayerInput'.default.MeleeImpactShakeParams.MultiHitReductionScale;            
        }
        else
        {
            Scale = 1.0000000 - (timeSinceFirstHit / PPI.MeleeImpactShakeParams.MultiHitTimeTakenToReduce);
            Scale = ((1.0000000 - PPI.MeleeImpactShakeParams.MultiHitReductionScale) * Scale) + PPI.MeleeImpactShakeParams.MultiHitReductionScale;
        }
    }
    return Scale;
    //return ReturnValue;    
}

function DoMeleeEffect(SPPawn InstigatorPawn, float Damage, Vector HitLocation)
{
    local float Duration;
    local Vector newRotAmplitude, newRotFrequency, newLocAmplitude, newLocFrequency;
    local float newFOVAmplitude, newFOVFrequency, signMult, scaleMult;
    local Rotator newRotDelta;
    local Vector scratchVector;
    local Rotator scratchRot;
    local bool bHitFromBehind;
    local SPPawn.EHSDamageDirectionType ehsddType;
    local PandoraPlayerController PPC;
    local PandoraPlayerInput PPI;

    PPC = PandoraPlayerController(Controller);
    PPI = PandoraPlayerInput(PPC.PlayerInput);
    ehsddType = InstigatorPawn.GetDamageDirection();
    scaleMult = FClamp(Damage / PPI.MeleeImpactShakeParams.DamageValToOne, 0.0000000, 1.0000000);
    // End:0xA5
    if(SPGriffonPawnPersistent(InstigatorPawn) != none)
    {
        scaleMult = FClamp(scaleMult * 3.0000000, 0.0000000, 1.0000000);
    }
    bHitFromBehind = false;
    // End:0x344
    if(int(ehsddType) != int(0))
    {
        PandoraPlayerController(Controller).GetPlayerViewPoint(scratchVector, scratchRot);
        bHitFromBehind = ((InstigatorPawn.Location - scratchVector) Dot Vector(scratchRot)) < 0.0000000;
        // End:0x137
        if(bHitFromBehind)
        {
            scaleMult *= PPI.MeleeImpactShakeParams.FromBehindImpactScale;
        }
        // End:0x208
        if((int(ehsddType) & 3) != 0)
        {
            // End:0x167
            if((int(ehsddType) & 3) == 1)
            {
                signMult = scaleMult;                
            }
            else
            {
                signMult = -scaleMult;
            }
            // End:0x18A
            if(bHitFromBehind)
            {
                signMult = -signMult;
            }
            signMult *= (MeleeEffectReductionScale());
            newRotAmplitude.X = PPI.MeleeImpactShakeParams.ShakeAmpl;
            newRotDelta.Pitch = int(((signMult * PPI.MeleeImpactShakeParams.PitchImpactDegrees) * 65536.0000000) / 360.0000000);
        }
        // End:0x2C4
        if((int(ehsddType) & 12) != 0)
        {
            // End:0x239
            if((int(ehsddType) & 12) == 8)
            {
                signMult = scaleMult;                
            }
            else
            {
                signMult = -scaleMult;
            }
            signMult *= (MeleeEffectReductionScale());
            newRotAmplitude.Y = PPI.MeleeImpactShakeParams.ShakeAmpl;
            newRotDelta.Yaw = int(((signMult * PPI.MeleeImpactShakeParams.YawImpactDegrees) * 65536.0000000) / 360.0000000);
        }
        PandoraPlayerController(Controller).SetOverrideRotVel(newRotDelta, PPI.MeleeImpactShakeParams.impactTime, InstigatorPawn, PPI.MeleeImpactShakeParams.RecoveryTime, bHitFromBehind);
        Duration = PPI.MeleeImpactShakeParams.impactTime;        
    }
    else
    {
        newRotAmplitude.X = PPI.MeleeImpactShakeParams.BiteShakeAmpl;
        Duration = PPI.MeleeImpactShakeParams.BiteImpactTime;
    }
    newRotFrequency = vect(75.0000000, 75.0000000, 75.0000000);
    newLocAmplitude = vect(0.0000000, 0.0000000, 0.0000000);
    newLocFrequency = vect(0.0000000, 0.0000000, 0.0000000);
    newFOVAmplitude = 0.0000000;
    newFOVFrequency = 0.0000000;
    // End:0x438
    if(!PandoraPlayerController(Controller).IsInWerewolfTackleState())
    {
        PandoraPlayerController(Controller).CameraShake(Duration, newRotAmplitude, newRotFrequency, newLocAmplitude, newLocFrequency, newFOVAmplitude, newFOVFrequency);
    }
    //return;    
}

simulated function ShakeCamera(class<DamageType> DamageType)
{
    // End:0x4A
    if((Controller != none) && class<PandoraDamageType>(DamageType) != none)
    {
        PandoraPlayerController(Controller).PlayCameraShake(class<PandoraDamageType>(DamageType).default.shakeInfo);
    }
    //return;    
}

reliable client simulated function ClientResetOnDeath()
{
    ResetOnDeath();
    //return;    
}

simulated function ResetOnDeath()
{
    local PandoraPlayerController PPC;
    local PandoraPlayerInput PPI;

    FinishHeal();
    PPC = PandoraPlayerController(Controller);
    // End:0x170
    if(PPC != none)
    {
        PPC.OnSprintStop();
        PPC.SprintTime = Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().Sprint.SprintTimeMax;
        PPC.LastSprintTime = 0.0000000;
        PPC.m_fFatigueAmount = 0.0000000;
        PPC.LastDuckTime = 0.0000000;
        PPC.bDuck = 0;
        PPC.bHoldUse = false;
        PPC.DisableDuckDisplay(0.0000000);
        PPC.UnLookDownSite();
        PPI = PandoraPlayerInput(PPC.PlayerInput);
        // End:0x13B
        if(PPI != none)
        {
            PPI.UnSiphon();            
        }
        PPC.FOV(PPC.PlayerCamera.GetDefaultFOV());        
    }
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    // End:0x42
    if(int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        SPPlayerReplicationInfo(Controller.PlayerReplicationInfo).SetDeadLocation(Location);
    }
    bReplicateMovement = false;
    bTearOff = true;
    // End:0x7C
    if(VSize(TearOffMomentum) > 100.0000000)
    {
        TearOffMomentum = Normal(TearOffMomentum);
        TearOffMomentum *= 100.0000000;
    }
    Velocity += TearOffMomentum;
    bPlayedDeath = true;
    ResetOnDeath();
    AttemptPhysAnimState_Ragdoll(true);
    SetCollision(false, false, true);
    NetDPGChange();
    Mesh.SetDepthPriorityGroup(1);
    Mesh.SetFOV(0.0000000);
    GotoState('Dying');
    //return;    
}

function Actor GetHelicopter()
{
    // End:0x74
    if(Base != none)
    {
        // End:0x2B
        if(ClassIsChildOf(Base.Class, Class'HeliPawnPersistent'))
        {
            return Base;
        }
        // End:0x74
        if(Base.Base != none)
        {
            // End:0x74
            if(ClassIsChildOf(Base.Base.Class, Class'HeliPawnPersistent'))
            {
                return Base.Base;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

simulated function UpdateHUD(float DeltaTime)
{
    UpdateHUDScratches(DeltaTime);
    //return;    
}

exec function PrimeGrenade()
{
    local PandoraPlayerController PPC;

    PPC = PandoraPlayerController(Controller);
    // End:0x36
    if((PPC != none) && PPC.IsFiringInputIgnored())
    {
        return;
    }
    // End:0x50
    if(int(Role) < int(ROLE_Authority))
    {
        AttemptPrimeGrenade();
    }
    ServerPrimeGrenade();
    //return;    
}

unreliable server function ServerPrimeGrenade()
{
    AttemptPrimeGrenade();
    //return;    
}

simulated function bool AttempTriggerGrenadeExplosion()
{
    local SPInventoryManager spInvManager;
    local array<SPWeapon> WeaponList;
    local int I;

    spInvManager = SPInventoryManager(InvManager);
    spInvManager.GetWeaponList(WeaponList);
    I = 0;
    J0x30:

    // End:0x99 [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x8F
        if(WeaponList[I] != none)
        {
            // End:0x8F
            if(WeaponList[I].IsA('SPGrenadeLauncherPersistent'))
            {
                return SPGrenadeLauncherPersistent(WeaponList[I]).TriggerGrenadeExplosion();
            }
        }
        I++;
        // [Loop Continue]
        goto J0x30;
    }
    return false;
    //return ReturnValue;    
}

simulated function DoHideFakeGrenade()
{
    //return;    
}

simulated function DoShowFakeGrenade()
{
    //return;    
}

function AttemptPrimeGrenade()
{
    local SPInventoryManager spInvManager;
    local PandoraPlayerController MyController;

    spInvManager = SPInventoryManager(InvManager);
    MyController = PandoraPlayerController(Controller);
    // End:0x2D
    if(MyController == none)
    {
        return;
    }
    // End:0x46
    if(MyController.IsInWerewolfTackleState())
    {
        return;
    }
    // End:0x6E
    if(MyController.fSinceLastPrime < 1.0000000)
    {
        // End:0x6E
        if(AttempTriggerGrenadeExplosion())
        {
            return;
        }
    }
    // End:0x10F
    if((((((((int(m_eGrenadeState) != int(0)) || MyController.fSinceLastPrime > float(0)) || bInSiphon) || Weapon.StillFiring(0)) || MyController.IsWeaponReloading()) || GetIsPartiallyLookingDownSite()) || GetIsTryingToLookDownSite()) || MyController.IsWeaponSwitching())
    {
        return;
    }
    // End:0x13C
    if(spInvManager.GetGrenadeAmmo(int(spInvManager.curGrenadeType)) <= 0)
    {
        return;
    }
    MyController.fPrimeTime = 0.0000000;
    m_eGrenadeState = 1;
    //return;    
}

exec function ReleaseGrenade()
{
    local PandoraPlayerController PPC;

    PPC = PandoraPlayerController(Controller);
    // End:0x36
    if((PPC != none) && PPC.IsFiringInputIgnored())
    {
        return;
    }
    // End:0x50
    if(int(Role) < int(ROLE_Authority))
    {
        AttemptReleaseGrenade();
    }
    ServerReleaseGrenade();
    //return;    
}

reliable server function ServerReleaseGrenade()
{
    AttemptReleaseGrenade();
    //return;    
}

function AttemptReleaseGrenade()
{
    local PandoraPlayerController MyController;

    MyController = PandoraPlayerController(Controller);
    // End:0x2D
    if((int(m_eGrenadeState) != int(1)) || bInSiphon)
    {
        return;
    }
    // End:0x51
    if(MyController.fPrimeTime > 0.3000000)
    {
        m_eGrenadeState = 2;        
    }
    else
    {
        m_eGrenadeState = 3;
    }
    ThrowGrenade();
    MyController.fSinceLastPrime = 1.2000000;
    //return;    
}

function SPGrenadeLauncherPersistent GetGrenadeLauncher()
{
    local SPGrenadeLauncherPersistent grenLauncher;
    local SPInventoryManager spInvManager;
    local array<SPWeapon> WeaponList;
    local int I;

    spInvManager = SPInventoryManager(InvManager);
    spInvManager.GetWeaponList(WeaponList);
    grenLauncher = none;
    I = 0;
    J0x37:

    // End:0x99 [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x8F
        if(WeaponList[I] != none)
        {
            // End:0x8F
            if(WeaponList[I].IsA('SPGrenadeLauncherPersistent'))
            {
                grenLauncher = SPGrenadeLauncherPersistent(WeaponList[I]);
                // [Explicit Break]
                goto J0x99;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x37;
    }
    J0x99:

    return grenLauncher;
    //return ReturnValue;    
}

function SwitchGrenadeTypeIfNeeded(SPGrenadeLauncherPersistent grenLauncher)
{
    local int numGrenades;
    local PandoraPlayerController PPC;

    // End:0x8A
    if(grenLauncher != none)
    {
        // End:0x8A
        if(grenLauncher.AnyGrenadeTypeAvailable())
        {
            numGrenades = grenLauncher.AmmoCountForType(grenLauncher.curGrenadeType());
            // End:0x8A
            if(numGrenades <= 0)
            {
                PPC = PandoraPlayerController(Controller);
                // End:0x8A
                if(PPC != none)
                {
                    PPC.NextGrenade();
                }
            }
        }
    }
    //return;    
}

function ThrowGrenade()
{
    local SPGrenadeLauncherPersistent grenLauncher;

    grenLauncher = GetGrenadeLauncher();
    // End:0x83
    if(grenLauncher != none)
    {
        SwitchGrenadeTypeIfNeeded(grenLauncher);
        // End:0x45
        if(mSoundCue_FlareStrike != none)
        {
            PlaySound(mSoundCue_FlareStrike);
        }
        // End:0x74
        if(grenLauncher.GrenadeFire(int(m_eGrenadeState) == int(3)) != none)
        {
            bGrenadeFired = true;
        }
        SwitchGrenadeTypeIfNeeded(grenLauncher);
    }
    //return;    
}

simulated function DispLifeForceMeter(HUD H)
{
    local string S, s2;
    local float XL, YL;
    local int Alpha;
    local SPAnimGenericFunctionMonitorNode monitorNode;
    local PlayerPawn nPlayer;
    local Scene.ESceneDepthPriorityGroup nDPG;
    local int Counter, playerFOV, weaponFOV;
    local bool logWeaponAttachments;
    local editinline SPSkeletalMeshComponent SkelMesh;
    local SPInventoryManager spInvManager;

    Alpha = 255;
    H.Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
    H.Canvas.SetDrawColor(255, 255, 255, byte(Alpha));
    S = "Animus:" @ string(int(LifeForce));
    S = Left(S, 11);
    H.Canvas.StrLen(S, XL, YL);
    H.Canvas.SetPos(float(H.Canvas.SizeX - H.OverscanX) - XL, float(H.Canvas.SizeY - H.OverscanY) - (YL * 5.0000000));
    H.Canvas.DrawText(S, false);
    S = "Health:" @ string(Health);
    S = Left(S, 11);
    H.Canvas.StrLen(S, XL, YL);
    H.Canvas.SetPos(float(H.Canvas.SizeX - H.OverscanX) - XL, float(H.Canvas.SizeY - H.OverscanY) - (YL * 6.0000000));
    H.Canvas.DrawText(S, false);
    spInvManager = SPInventoryManager(InvManager);
    // End:0x437
    if(spInvManager != none)
    {
        // End:0x2B6
        if(int(spInvManager.curGrenadeType) == int(spInvManager.0))
        {
            H.Canvas.SetDrawColor(255, 0, 0, byte(Alpha));            
        }
        else
        {
            H.Canvas.SetDrawColor(255, 255, 255, byte(Alpha));
        }
        s2 = "Flares:" @ string(spInvManager.GetGrenadeAmmo(int(spInvManager.0)));
        H.Canvas.StrLen(s2, XL, YL);
        H.Canvas.SetPos(float(H.OverscanX), float(H.Canvas.SizeY - H.OverscanY) - (YL * 6.0000000));
        H.Canvas.DrawText(s2, false);
        // End:0x410
        if(int(spInvManager.curGrenadeType) == int(spInvManager.1))
        {
            H.Canvas.SetDrawColor(255, 0, 0, byte(Alpha));            
        }
        else
        {
            H.Canvas.SetDrawColor(255, 255, 255, byte(Alpha));
        }
    }
    s2 = "Flash Count: " @ string(FlashCount);
    H.Canvas.StrLen(s2, XL, YL);
    H.Canvas.SetPos(float(H.OverscanX), float(H.Canvas.SizeY - H.OverscanY) - (YL * 5.0000000));
    H.Canvas.DrawText(s2, false);
    H.Canvas.SetDrawColor(255, 255, 255, byte(Alpha));
    // End:0x738
    if(PandoraPlayerController(Controller).bLogSprint == true)
    {
        s2 = "Sprint:" @ string(PandoraPlayerController(Controller).GetSprint());
        H.Canvas.StrLen(s2, XL, YL);
        H.Canvas.SetPos(float(H.Canvas.SizeX - H.OverscanX) - XL, float(H.Canvas.SizeY - H.OverscanY) - (YL * 7.0000000));
        H.Canvas.DrawText(s2, false);
        s2 = "Player Location:" @ string(Location);
        H.Canvas.StrLen(s2, XL, YL);
        H.Canvas.SetPos(float(H.Canvas.SizeX - H.OverscanX) - XL, float(H.Canvas.SizeY - H.OverscanY) - (YL * 8.0000000));
        H.Canvas.DrawText(s2, false);
    }
    // End:0x9D7
    if(PandoraPlayerController(Controller).bLogEquip == true)
    {
        s2 = "Weapon Equip:" @ string(bInEquip);
        H.Canvas.StrLen(s2, XL, YL);
        H.Canvas.SetPos(float(H.OverscanX), float(H.Canvas.SizeY - H.OverscanY) - (YL * 6.0000000));
        H.Canvas.DrawText(s2, false);
        s2 = "Weapon Unequip:" @ string(bInUnequip);
        H.Canvas.StrLen(s2, XL, YL);
        H.Canvas.SetPos(float(H.OverscanX), float(H.Canvas.SizeY - H.OverscanY) - (YL * 7.0000000));
        H.Canvas.DrawText(s2, false);
        monitorNode = none;
        s2 = "Player State:" @ string(FiringModeMonitor(monitorNode, Alpha));
        H.Canvas.StrLen(s2, XL, YL);
        H.Canvas.SetPos(float(H.OverscanX), float(H.Canvas.SizeY - H.OverscanY) - (YL * 8.0000000));
        H.Canvas.DrawText(s2, false);
    }
    // End:0xF83
    if(PandoraPlayerController(Controller).bLogNet == true)
    {
        switch(WorldInfo.NetMode)
        {
            // End:0xA2E
            case NM_DedicatedServer:
                s2 = "Net Mode: Dedicated Server";
                // End:0xABB
                break;
            // End:0xA55
            case 2:
                s2 = "Net Mode: Listen Server";
                // End:0xABB
                break;
            // End:0xA75
            case 3:
                s2 = "Net Mode: Client";
                // End:0xABB
                break;
            // End:0xA9C
            case 0:
                s2 = "Net Mode: Single Player";
                // End:0xABB
                break;
            // End:0xFFFF
            default:
                s2 = "Net Mode: Unknown";
                // End:0xABB
                break;
                break;
        }
        H.Canvas.StrLen(s2, XL, YL);
        H.Canvas.SetPos(float(H.OverscanX), float(H.Canvas.SizeY - H.OverscanY) - (YL * 6.0000000));
        H.Canvas.DrawText(s2, false);
        s2 = "Weapon:" @ string(int(SPWeapon(Weapon).WorldCurrFOV));
        H.Canvas.StrLen(s2, XL, YL);
        H.Canvas.SetPos(float(H.OverscanX), float(H.Canvas.SizeY - H.OverscanY) - (YL * 8.0000000));
        H.Canvas.DrawText(s2, false);
        Counter = 0;
        // End:0xF82
        foreach WorldInfo.AllPawns(Class'PlayerPawn', nPlayer)
        {
            nDPG = nPlayer.Mesh.DepthPriorityGroup;
            // End:0xCA8
            if(nPlayer.IsLocallyControlled())
            {
                S = "L";                
            }
            else
            {
                S = "N";
            }
            playerFOV = int(SPSkeletalMeshComponent(nPlayer.Mesh).GetFOV());
            // End:0xD1A
            if(nPlayer.Weapon != none)
            {
                weaponFOV = int(SPWeapon(nPlayer.Weapon).WorldCurrFOV);                
            }
            else
            {
                // End:0xD72
                if(nPlayer.CurrentWeaponAttachment != none)
                {
                    SkelMesh = SPSkeletalMeshComponent(nPlayer.CurrentWeaponAttachment.Mesh);
                    weaponFOV = int(SkelMesh.GetFOV());                    
                }
                else
                {
                    weaponFOV = -1;
                }
            }
            switch(nDPG)
            {
                // End:0xDEF
                case 2:
                    s2 = (((((((("[" $ string(nPlayer.GetTeamNum())) $ "] P") $ string(Counter)) @ S) $ "/F =") @ string(playerFOV)) @ ": Weap(") @ string(weaponFOV)) @ ")";
                    // End:0xEC1
                    break;
                // End:0xE59
                case 1:
                    s2 = (((((((("[" $ string(nPlayer.GetTeamNum())) $ "] P") $ string(Counter)) @ S) $ "/W =") @ string(playerFOV)) @ ": Weap(") @ string(weaponFOV)) @ ")";
                    // End:0xEC1
                    break;
                // End:0xFFFF
                default:
                    s2 = (((((((("[" $ string(nPlayer.GetTeamNum())) $ "] P") $ string(Counter)) @ S) $ "/W =") @ string(playerFOV)) @ ": Weap(") @ string(weaponFOV)) @ ")";
                    // End:0xEC1
                    break;
                    break;
            }
            H.Canvas.StrLen(s2, XL, YL);
            H.Canvas.SetPos(float(H.OverscanX), float(H.Canvas.SizeY - H.OverscanY) - (YL * (10.0000000 + float(Counter))));
            H.Canvas.DrawText(s2, false);
            Counter++;            
        }        
    }
    logWeaponAttachments = false;
    // End:0xF98
    if(!logWeaponAttachments)
    {
        return;
    }
    H.Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
    H.Canvas.SetDrawColor(255, 0, 0, byte(Alpha));
    //return;    
}

simulated function bool DispActivateSiphon(HUD H)
{
    local PandoraPlayerController thePlayerController;
    local SPHudScene HudScene;

    thePlayerController = PandoraPlayerController(Controller);
    // End:0x56
    if((thePlayerController != none) && thePlayerController.myHUD != none)
    {
        HudScene = SPHud(thePlayerController.myHUD).HudScene;
    }
    // End:0x63
    if(HudScene == none)
    {
        return false;
    }
    // End:0x119
    if(((bActiveCollect && thePlayerController.bShowCanSiphon) && !bInSiphon) && !IsInCinematic())
    {
        HudScene.SetAnimusSensor(true);
        // End:0x114
        if((m_fAmBxAnimusProximityLast + m_fAmBxAnimusProximityEpoch) < WorldInfo.TimeSeconds)
        {
            thePlayerController.PlayAmBxScript("animus_proximity", 500);
            m_fAmBxAnimusProximityLast = WorldInfo.TimeSeconds;
        }
        return true;        
    }
    else
    {
        HudScene.SetAnimusSensor(false);
    }
    return false;
    //return ReturnValue;    
}

simulated function bool IsInCinematic()
{
    // End:0x41
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        return PandoraGameInfo(WorldInfo.Game).IsInCinematic();        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function class<SPWeapon> SetQueryCollectableSwapWeapon()
{
    local Actor collectActor;
    local PandoraPlayerController thePlayerController;
    local SPInventoryManager spInvManager;
    local bool bSameType;
    local class<SPWeapon> WeaponTypeToSwapTo;

    thePlayerController = PandoraPlayerController(Controller);
    // End:0x1D
    if(thePlayerController == none)
    {
        return none;
    }
    WeaponTypeToSwapTo = none;
    // End:0x33
    if(IsInCinematic())
    {
        return none;
    }
    // End:0x42
    if(GetIsPartiallyLookingDownSite())
    {
        return none;
    }
    // End:0x5B
    if(thePlayerController.CanInteractWith())
    {
        return none;
    }
    collectActor = thePlayerController.FindClosestValidPickup();
    // End:0x235
    if((collectActor != none) && Weapon != none)
    {
        // End:0xBA
        if(SPPickup(collectActor) != none)
        {
            WeaponTypeToSwapTo = SPPickup(collectActor).SPWeaponType;            
        }
        else
        {
            // End:0xE4
            if(SPDroppedPickup(collectActor) != none)
            {
                WeaponTypeToSwapTo = SPDroppedPickup(collectActor).SPWeaponType;
            }
        }
        spInvManager = SPInventoryManager(InvManager);
        // End:0x22E
        if(spInvManager != none)
        {
            bSameType = spInvManager.FindInventoryType(WeaponTypeToSwapTo) != none;
            // End:0x1B2
            if(!WeaponTypeToSwapTo.default.IsMeleeWeapon)
            {
                // End:0x1AF
                if(((bSameType || (WeaponTypeToSwapTo != none) && !WeaponTypeToSwapTo.default.IsLargeWeapon) || spInvManager.CountLargeWeapons() < spInvManager.maxLargeWeapons) || spInvManager.IsCurrentWeaponMelee())
                {
                    WeaponTypeToSwapTo = none;
                }                
            }
            else
            {
                // End:0x22B
                if(((bSameType || (WeaponTypeToSwapTo != none) && !WeaponTypeToSwapTo.default.IsLargeWeapon) || spInvManager.CountMeleeWeapons() < spInvManager.maxMeleeWeapons) || !spInvManager.IsCurrentWeaponMelee())
                {
                    WeaponTypeToSwapTo = none;
                }
            }            
        }
        else
        {
            WeaponTypeToSwapTo = none;
        }
    }
    return WeaponTypeToSwapTo;
    //return ReturnValue;    
}

simulated function class<SPWeapon> QueryCollectableSwapWeapon()
{
    return SwapToSPWeaponType;
    //return ReturnValue;    
}

simulated function bool DispSwapWeapon(HUD H)
{
    local string S, s2;
    local class<SPWeapon> SPWeaponType;
    local PandoraPlayerController thePlayerController;
    local SPHudScene HudScene;

    thePlayerController = PandoraPlayerController(Controller);
    // End:0x56
    if((thePlayerController != none) && thePlayerController.myHUD != none)
    {
        HudScene = SPHud(thePlayerController.myHUD).HudScene;
    }
    // End:0x63
    if(HudScene == none)
    {
        return false;
    }
    SPWeaponType = QueryCollectableSwapWeapon();
    // End:0x109
    if(SPWeaponType != none)
    {
        s2 = string(Class'SPWeapon'.static.GetWeaponName(SPWeaponType));        
        s2 $= "SwapMessage";
        S = Localize("Weapons", s2, "PandoraGame");
        HudScene.AddTextToBuffer(S, 2, 0.1000000);
        return true;        
    }
    else
    {
        HudScene.RemoveTextFromBuffer(2);
    }
    return false;
    //return ReturnValue;    
}

simulated function bool DispPickupItem(HUD H)
{
    local string S;
    local Actor UseTarget;
    local DynamicSMActor newPickup;
    local PandoraPlayerController thePlayerController;
    local SPHudScene HudScene;

    thePlayerController = PandoraPlayerController(Controller);
    // End:0x56
    if((thePlayerController != none) && thePlayerController.myHUD != none)
    {
        HudScene = SPHud(thePlayerController.myHUD).HudScene;
    }
    // End:0x63
    if(HudScene == none)
    {
        return false;
    }
    // End:0x203
    if(PandoraPlayerController(Controller).ActorInteracted(UseTarget, true))
    {
        // End:0x1E9
        if((UseTarget != none) && (UseTarget.IsA('DynamicSMActor') || UseTarget.IsA('Pawn')) || UseTarget.IsA('SPPDAMessagePickupFactory'))
        {
            // End:0x110
            if(UseTarget.IsA('SPPDAMessagePickupFactory'))
            {
                S = SPPDAMessagePickupFactory(UseTarget).m_PickupMessage;
            }
            HudScene.AddTextToBuffer(S, 3, 0.1000000);
            // End:0x1E4
            if(UseTarget.IsA('DynamicSMActor'))
            {
                newPickup = DynamicSMActor(UseTarget);
                // End:0x19E
                if(newPickup != myDynamicObj)
                {
                    // End:0x193
                    if(myDynamicObj != none)
                    {
                        ResetMaterialForPickupObject(myDynamicObj);
                        myDynamicObj.bIsPickupMaterialChanged = false;
                    }
                    myDynamicObj = newPickup;
                }
                // End:0x1D5
                if(myDynamicObj.bIsPickupMaterialChanged == false)
                {
                    SetupMaterialForPickupObject(myDynamicObj);
                    myDynamicObj.bIsPickupMaterialChanged = true;
                }
                UpdateMaterialForPickupObject(myDynamicObj);
            }
            return true;            
        }
        else
        {
            HudScene.RemoveTextFromBuffer(3);
        }        
    }
    else
    {
        // End:0x22F
        if(myDynamicObj != none)
        {
            ResetMaterialForPickupObject(myDynamicObj);
            myDynamicObj.bIsPickupMaterialChanged = false;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function bool DispUsedTriggerInteractText(HUD H)
{
    local string S, s2;
    local array<Trigger> useList;
    local int Idx, evtIdx;
    local SeqEvent_Used UseSeq;
    local Trigger checkTrigger;
    local PandoraPlayerController PC;
    local bool canUse;
    local SPHudScene HudScene;
    local float TriggerDot;

    PC = PandoraPlayerController(Controller);
    // End:0x1D
    if(PC == none)
    {
        return false;
    }
    // End:0x63
    if((PC != none) && PC.myHUD != none)
    {
        HudScene = SPHud(PC.myHUD).HudScene;
    }
    // End:0x70
    if(HudScene == none)
    {
        return false;
    }
    TriggerDot = PC.m_GameplayGDTuneData.TriggerDotRange;
    // End:0xAC
    if(TriggerDot > 1.0000000)
    {
        TriggerDot = 1.0000000;        
    }
    else
    {
        // End:0xC6
        if(TriggerDot < 0.0000000)
        {
            TriggerDot = 0.0000000;
        }
    }
    PC.GetTriggerUseList(PC.InteractDistance, 1024.0000000, 0.0000000, false, useList, TriggerDot);
    Idx = 0;
    J0x105:

    // End:0x269 [Loop If]
    if(Idx < useList.Length)
    {
        checkTrigger = useList[Idx];
        // End:0x25F
        if(checkTrigger != none)
        {
            canUse = false;
            // End:0x205
            if(PC.m_bAllowInteractTextDisplay)
            {
                evtIdx = 0;
                J0x153:

                // End:0x205 [Loop If]
                if(evtIdx < checkTrigger.GeneratedEvents.Length)
                {
                    UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[evtIdx]);
                    // End:0x1D7
                    if(UseSeq != none)
                    {
                        // End:0x1CF
                        if(UseSeq.DoGameSpecificChecksPass(self) && WouldCheckActivateTestsPass(UseSeq))
                        {
                            canUse = true;                            
                        }
                        else
                        {
                            canUse = false;
                        }
                    }
                    // End:0x1FB
                    if(canUse == true)
                    {
                        s2 = UseSeq.InteractText;
                        // [Explicit Break]
                        goto J0x205;
                    }
                    evtIdx++;
                    // [Loop Continue]
                    goto J0x153;
                }
            }
            J0x205:

            // End:0x248
            if(canUse == true)
            {                
                S @= s2;
                HudScene.AddTextToBuffer(S, 4, 0.1000000);
                return true;
                // [Explicit Continue]
                goto J0x25F;
            }
            HudScene.RemoveTextFromBuffer(4);
        }
        J0x25F:

        Idx++;
        // [Loop Continue]
        goto J0x105;
    }
    return false;
    //return ReturnValue;    
}

function bool WouldCheckActivateTestsPass(SeqEvent_Used UseSeq)
{
    local float timeSinceLastActivation;

    // End:0x3C
    if((UseSeq.MaxTriggerCount > 0) && UseSeq.TriggerCount >= UseSeq.MaxTriggerCount)
    {
        return false;
    }
    // End:0xAB
    if((UseSeq.TriggerCount > 0) && UseSeq.ReTriggerDelay > float(0))
    {
        timeSinceLastActivation = WorldInfo.TimeSeconds - UseSeq.ActivationTime;
        // End:0xAB
        if(timeSinceLastActivation < UseSeq.ReTriggerDelay)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

function SetAnimusRedGlowForFullAnimus()
{
    local SPHudScene hudUIScene;

    // End:0x3F
    if(playerHud != none)
    {
        hudUIScene = playerHud.HudScene;
        // End:0x3F
        if(hudUIScene != none)
        {
            hudUIScene.SetAnimusBarOpacityFadeTime();
        }
    }
    //return;    
}

simulated function DrawHUD(HUD H)
{
    local SPHud HUD;
    local SPHudScene hudUIScene;

    // End:0x8D
    if(H.bShowHUD == true)
    {
        DrawHUDGround(H);
        DisplayUsage(H);
        HUD = SPHud(H);
        hudUIScene = HUD.HudScene;
        // End:0x8D
        if(HUD.bUseNewHud && hudUIScene != none)
        {
            // End:0x8A
            if(bGrenadeFired)
            {
                bGrenadeFired = false;
            }            
        }
    }
    // End:0xA7
    if(!m_bFireAxeBlocking)
    {
        DrawHUDScratches(H);
    }
    super(Pawn).DrawHUD(H);
    //return;    
}

simulated function DisplayUsage(HUD H)
{
    // End:0x38
    if((PandoraPlayerController(Controller).Carried != none) || PandoraPlayerController(Controller).CarriedPawn != none)
    {
        return;
    }
    DispActivateSiphon(H);
    DispPickupItem(H);
    DispUsedTriggerInteractText(H);
    //return;    
}

simulated function UpdateReticleMP(SPHudScene hudUIScene, SPPawn hitPawn)
{
    local Pawn MasterPawn;
    local PlayerPawnMPPersistent HitMPPlayerPawn;

    // End:0xD3
    if(Weapon != none)
    {
        HitMPPlayerPawn = PlayerPawnMPPersistent(hitPawn);
        // End:0x5B
        if(HitMPPlayerPawn != none)
        {
            MasterPawn = HitMPPlayerPawn.GetMasterPawn();
            // End:0x5B
            if(MasterPawn != none)
            {
                hitPawn = SPPawn(MasterPawn);
            }
        }
        // End:0xAC
        if(int(hitPawn.GetTeamNum()) == int(GetTeamNum()))
        {
            blueReticleCounter = 0;
            greenReticleCounter++;
            hudUIScene.SetReticleColor(GREEN_Color);            
        }
        else
        {
            redReticleCounter++;
            blueReticleCounter = 0;
            hudUIScene.SetReticleColor(RED_Color);
        }
    }
    //return;    
}

simulated function DrawHUDGround(HUD H)
{
    local float weaponSpread;
    local SPWeapon mySPW;
    local Actor Target;
    local SPPawn hitPawn;
    local SPAIController spc;
    local PandoraPlayerController thePlayerController;
    local SPHudScene hudUIScene;
    local editinline SPActorDestructComponent targetdestructComponent;
    local float sprintMeterOpacity;
    local int grenadeCount;
    local SPInventoryManager spInvManager;

    thePlayerController = PandoraPlayerController(Controller);
    spInvManager = SPInventoryManager(InvManager);
    H.Canvas.SetDrawColor(255, 255, 255, 255);
    // End:0x4F
    if(playerHud == none)
    {
        return;
    }
    hudUIScene = playerHud.HudScene;
    // End:0x71
    if(hudUIScene == none)
    {
        return;
    }
    // End:0xBD
    if(GetStateName() == 'Dying')
    {
        hudUIScene.WriteHealthCount(H, int(((float(Health) / float(HealthMax)) + 0.0005000) * 100.0000000));
        return;
    }
    // End:0x655
    if(Weapon != none)
    {
        mySPW = SPWeapon(Weapon);
        // End:0x63C
        if(!mySPW.bHudless)
        {
            weaponSpread = mySPW.SpreadCalculate();
            hudUIScene.UpdateReticleWeaponSpread(H, weaponSpread, weaponSpread * mySPW.GetReticleSpreadScale(), mySPW.ammoInMagazine, thePlayerController.bWeaponSwitched, mySPW.WeapID);
            playerHud.Draw(H);
            hudUIScene.WriteAmmoCount(H, float(mySPW.ammoInMagazine), float(mySPW.AmmoCount), float(mySPW.magazineSize), mySPW.IsFiring());
            // End:0x4B4
            if(mySPW.WeapID != 'FireAxe')
            {
                Target = mySPW.GetAimAtActor();
                hitPawn = SPPawn(Target);
                // End:0x377
                if(IsLocallyControlled())
                {
                    // End:0x25C
                    if(hitPawn != none)
                    {
                        spc = SPAIController(hitPawn.Controller);
                    }
                    // End:0x2A0
                    if(((hitPawn != none) && spc == none) && hitPawn.bTargettable)
                    {
                        UpdateReticleMP(hudUIScene, hitPawn);                        
                    }
                    else
                    {
                        // End:0x33D
                        if(((hitPawn != none) && spc != none) && hitPawn.bTargettable)
                        {
                            // End:0x313
                            if(spc.IsFriendly(Controller))
                            {
                                blueReticleCounter = 0;
                                greenReticleCounter++;
                                hudUIScene.SetReticleColor(GREEN_Color);                                
                            }
                            else
                            {
                                redReticleCounter++;
                                blueReticleCounter = 0;
                                hudUIScene.SetReticleColor(RED_Color);
                            }                            
                        }
                        else
                        {
                            redReticleCounter = 0;
                            greenReticleCounter = 0;
                            blueReticleCounter++;
                            // End:0x377
                            if(blueReticleCounter > 5)
                            {
                                hudUIScene.SetReticleColor(BLUE_Color);
                            }
                        }
                    }
                }
                // End:0x47A
                if(Target != none)
                {
                    targetdestructComponent = SPActorDestructComponent(Target.GetActorDestructComponent());
                    // End:0x3E8
                    if((targetdestructComponent != none) && targetdestructComponent.IsAPlayerTarget())
                    {
                        redReticleCounter++;
                        blueReticleCounter = 0;
                        hudUIScene.SetReticleColor(RED_Color);
                    }
                    // End:0x41F
                    if(SPRocketTargetPersistant(Target) != none)
                    {
                        redReticleCounter++;
                        blueReticleCounter = 0;
                        hudUIScene.SetReticleColor(RED_Color);
                    }
                    // End:0x47A
                    if(mySPW.WeapID == 'RocketLauncher')
                    {
                        // End:0x47A
                        if(Target.bSPLockableTarget && Pawn(Target) == none)
                        {
                            hudUIScene.SetReticleColor(RED_Color);
                        }
                    }
                }
                // End:0x4B1
                if(SPBaseWerewolfPawnPersistent(hitPawn) != none)
                {
                    redReticleCounter++;
                    blueReticleCounter = 0;
                    hudUIScene.SetReticleColor(RED_Color);
                }                
            }
            else
            {
                Target = mySPW.GetAimAtActor();
                hitPawn = SPPawn(Target);
                // End:0x60B
                if(hitPawn != none)
                {
                    // End:0x608
                    if(IsLocallyControlled())
                    {
                        // End:0x517
                        if(hitPawn != none)
                        {
                            spc = SPAIController(hitPawn.Controller);
                        }
                        // End:0x546
                        if((hitPawn != none) && spc == none)
                        {
                            UpdateReticleMP(hudUIScene, hitPawn);                            
                        }
                        else
                        {
                            // End:0x5CE
                            if((hitPawn != none) && spc != none)
                            {
                                // End:0x5A4
                                if(spc.IsFriendly(Controller))
                                {
                                    blueReticleCounter = 0;
                                    greenReticleCounter++;
                                    hudUIScene.SetReticleColor(GREEN_Color);                                    
                                }
                                else
                                {
                                    redReticleCounter++;
                                    blueReticleCounter = 0;
                                    hudUIScene.SetReticleColor(RED_Color);
                                }                                
                            }
                            else
                            {
                                redReticleCounter = 0;
                                greenReticleCounter = 0;
                                blueReticleCounter++;
                                // End:0x608
                                if(blueReticleCounter > 5)
                                {
                                    hudUIScene.SetReticleColor(BLUE_Color);
                                }
                            }
                        }
                    }                    
                }
                else
                {
                    redReticleCounter = 0;
                    greenReticleCounter = 0;
                    blueReticleCounter++;
                    hudUIScene.SetReticleColor(BLUE_Color);
                }
            }            
        }
        else
        {
            playerHud.Draw(H);
        }
    }
    // End:0x720
    if(spInvManager != none)
    {
        grenadeCount = spInvManager.GetGrenadeAmmo(int(spInvManager.1));
        hudUIScene.UpdateGrenadeCountChanged(grenadeCount, int(spInvManager.1), int(spInvManager.curGrenadeType));
        grenadeCount = spInvManager.GetGrenadeAmmo(int(spInvManager.2));
        hudUIScene.UpdateGrenadeCountChanged(grenadeCount, int(spInvManager.2), int(spInvManager.curGrenadeType));
    }
    hudUIScene.WriteHealthCount(H, int(((float(Health) / float(HealthMax)) + 0.0005000) * 100.0000000));
    hudUIScene.UpdateAnimus(LifeForce / maxLifeForce);
    // End:0x813
    if(mySPW != none)
    {
        // End:0x7FF
        if(ShouldHideReticle(mySPW))
        {
            // End:0x7D1
            if(GetIsPartiallyLookingDownSite())
            {
                hudUIScene.HideReticle(H, mySPW.WeapID, 1, 0, true);                
            }
            else
            {
                hudUIScene.HideReticle(H, mySPW.WeapID);
            }            
        }
        else
        {
            hudUIScene.ShowReticle();
        }
    }
    // End:0x90E
    if(((thePlayerController != none) && thePlayerController.bWeaponSwitched) && mySPW != none)
    {
        thePlayerController.bWeaponSwitched = false;
        hudUIScene.HideReticle(H, mySPW.WeapID, 0);
        // End:0x8E4
        if((mySPW.WeapID == 'FireAxe') || mySPW.bHudless)
        {
            hudUIScene.AmmoBarFadeOut(0.0000000);
            hudUIScene.PickupWeaponBarFadeOut(0.0000000);            
        }
        else
        {
            hudUIScene.AmmoBarFadeIn();
            hudUIScene.PickupWeaponBarFadeIn();
        }
    }
    // End:0x9D9
    if(thePlayerController != none)
    {
        // End:0x9D9
        if(!thePlayerController.IsSprintFullyCharged())
        {
            // End:0x957
            if(thePlayerController.IsSprinting())
            {
                sprintMeterOpacity = 1.0000000;                
            }
            else
            {
                // End:0x97E
                if(!thePlayerController.IsSprintCharged())
                {
                    sprintMeterOpacity = 0.5000000;                    
                }
                else
                {
                    sprintMeterOpacity = 0.2500000;
                }
            }
            // End:0x9D9
            if((GetLookDownSitePercent()) == float(0))
            {
                playerHud.RenderSprintBar(H, thePlayerController.SprintTime / thePlayerController.SprintTimeMax, sprintMeterOpacity);
            }
        }
    }
    DrawDamageIndicators(H);
    //return;    
}

simulated function bool ShouldHideReticle(optional SPWeapon Weapon)
{
    local PandoraPlayerController thePlayerController;

    // End:0x23
    if((Weapon != none) && Weapon.bHudless)
    {
        return true;
    }
    thePlayerController = PandoraPlayerController(Controller);
    // End:0x68
    if(thePlayerController.IsSprinting() || thePlayerController.IsInWerewolfTackleState())
    {
        return true;        
    }
    else
    {
        // End:0x9A
        if(GetIsPartiallyLookingDownSite())
        {
            // End:0x98
            if(Weapon != none)
            {
                return Weapon.HideReticleInAds();                
            }
            else
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function DrawDamageIndicators(HUD H)
{
    local int currDamageIndex;
    local Vector vectToInstigator;
    local Rotator rotToInstigator;
    local float yawDiff, yawDiffRads;
    local Rotator offsetRotation;
    local Vector offsetFromCenter, rotatedOffsetFromCenter;
    local float distFromCenter;

    distFromCenter = float(H.Canvas.SizeY) * 0.3000000;
    currDamageIndex = 0;
    J0x2F:

    // End:0x28D [Loop If]
    if(currDamageIndex < DamageIndicatorManager.GetNumDamageIndicators())
    {
        vectToInstigator = Location - DamageIndicatorManager.GetDamageIndicatorLocation(currDamageIndex);
        vectToInstigator.Z = 0.0000000;
        rotToInstigator = Rotator(vectToInstigator);
        yawDiff = float(rotToInstigator.Yaw - Rotation.Yaw);
        yawDiff += float(65536 / 2);
        yawDiffRads = yawDiff * ((float(2) * 3.1415930) / float(65536));
        offsetRotation.Pitch = 0;
        offsetRotation.Roll = 0;
        offsetRotation.Yaw = int(yawDiff - float(65536 / 2));
        offsetFromCenter.X = 0.0000000;
        offsetFromCenter.Y = distFromCenter;
        offsetFromCenter.Z = 0.0000000;
        rotatedOffsetFromCenter = TransformVectorByRotation(offsetRotation, offsetFromCenter);
        H.SetPos((H.CenterX + rotatedOffsetFromCenter.X) - float(hitFromFrontTexture.SizeX / 2), (H.CenterY + rotatedOffsetFromCenter.Y) - float(hitFromFrontTexture.SizeY / 2));
        H.Canvas.DrawTile(hitFromFrontTexture, float(hitFromFrontTexture.SizeX), float(hitFromFrontTexture.SizeY), 0.0000000, 0.0000000, float(hitFromFrontTexture.SizeX), float(hitFromFrontTexture.SizeY), yawDiffRads);
        currDamageIndex++;
        // [Loop Continue]
        goto J0x2F;
    }
    //return;    
}

function UpdateHUDScratches(float DeltaTime)
{
    local int Count;

    Count = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(Count < Scratches.Length)
    {
        Scratches[Count].Age += DeltaTime;
        Count++;
        // [Loop Continue]
        goto J0x07;
    }
    Count = Scratches.Length - 1;
    J0x4D:

    // End:0xB7 [Loop If]
    if(Count >= 0)
    {
        // End:0xAD
        if(Scratches[Count].Age >= (Scratches[Count].Duration + Scratches[Count].FadeTime))
        {
            Scratches.Remove(Count, 1);
        }
        Count--;
        // [Loop Continue]
        goto J0x4D;
    }
    //return;    
}

function DrawHUDScratches(HUD H)
{
    local int Count;
    local Vector screenCoord;
    local float scratchBaseSize, scratchScale, opaquePercent, opaqueTime;

    Count = 0;
    J0x07:

    // End:0x30C [Loop If]
    if(Count < Scratches.Length)
    {
        // End:0x302
        if(Scratches[Count].Age < (Scratches[Count].Duration + Scratches[Count].FadeTime))
        {
            // End:0x11A
            if(Scratches[Count].screenCoordComputed == false)
            {
                screenCoord = H.Canvas.Project(Scratches[Count].worldCoord);
                Scratches[Count].xLoc = screenCoord.X;
                Scratches[Count].yLoc = screenCoord.Y;
                Scratches[Count].screenCoordComputed = true;
            }
            scratchBaseSize = 256.0000000;
            scratchScale = GetScratchScale(H);
            // End:0x1A1
            if(Scratches[Count].Age < Scratches[Count].Duration)
            {
                Scratches[Count].Material.SetScalarParameterValue('Opacity', 1.0000000);                
            }
            else
            {
                opaqueTime = Scratches[Count].Age - Scratches[Count].Duration;
                opaquePercent = 1.0000000 - (opaqueTime / Scratches[Count].FadeTime);
                Scratches[Count].Material.SetScalarParameterValue('Opacity', opaquePercent);
            }
            H.Canvas.SetPos(Scratches[Count].xLoc - (Scratches[Count].xOffset * scratchScale), Scratches[Count].yLoc - (Scratches[Count].yOffset * scratchScale));
            H.Canvas.DrawMaterialTile(Scratches[Count].Material, scratchBaseSize * scratchScale, scratchBaseSize * scratchScale);
        }
        Count++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function float GetScratchScale(HUD H)
{
    local float ratio;

    ratio = H.Canvas.ClipX / float(640);
    return 2.2000000 * ratio;
    //return ReturnValue;    
}

function AddScratch(Vector WorldPos, MaterialInstanceConstant theMaterial, int xOffset, int yOffset, float Duration, float FadeTime)
{
    Scratches.Insert(Scratches.Length, 1);
    Scratches[Scratches.Length - 1].Material = theMaterial;
    Scratches[Scratches.Length - 1].Duration = Duration;
    Scratches[Scratches.Length - 1].FadeTime = FadeTime;
    Scratches[Scratches.Length - 1].Age = 0.0000000;
    Scratches[Scratches.Length - 1].xOffset = 0.0000000;
    Scratches[Scratches.Length - 1].yOffset = 0.0000000;
    Scratches[Scratches.Length - 1].worldCoord = WorldPos;
    Scratches[Scratches.Length - 1].xLoc = 0.0000000;
    Scratches[Scratches.Length - 1].yLoc = 0.0000000;
    Scratches[Scratches.Length - 1].screenCoordComputed = true;
    //return;    
}

simulated event ScratchHUDPos(Vector WorldPos, Material theMaterial, int xOffset, int yOffset, float Duration, float FadeTime)
{
    local MaterialInstanceConstant matInstance;

    // End:0x5C
    if(theMaterial != none)
    {
        matInstance = new (none) Class'Engine.MaterialInstanceConstant';
        matInstance.SetParent(theMaterial);
        AddScratch(WorldPos, matInstance, xOffset, yOffset, Duration, FadeTime);
    }
    //return;    
}

simulated event ScratchHUD(Pawn thePawn, Material theMaterial, name theSocket, int xOffset, int yOffset, float Duration, float FadeTime)
{
    local Vector WorldPos;
    local Rotator worldRot;

    // End:0x54
    if(thePawn.Mesh.GetSocketWorldLocationAndRotation(theSocket, WorldPos, worldRot))
    {
        ScratchHUDPos(WorldPos, theMaterial, xOffset, yOffset, Duration, FadeTime);
    }
    //return;    
}

simulated event DoPostProcessMaterialHitEffect(MaterialEffect hitEffect, float HitEffectFadeTime)
{
    CurrentMaterialHitEffect = hitEffect;
    CurrentMaterialHitEffect.bShowInGame = true;
    MaterialInstanceConstant(CurrentMaterialHitEffect.Material).SetScalarParameterValue('HitAmount', 1.0000000);
    MaterialInstanceConstant(CurrentMaterialHitEffect.Material).SetScalarParameterValue('Alpha', 1.0000000);
    CurrentHitEffectFadeTime = HitEffectFadeTime;
    MaxHitEffectFadeTime = HitEffectFadeTime;
    //return;    
}

simulated event DoPostProcessDOFHitEffect(DOFAndBloomEffect DOFEffect, float HitEffectFadeTime)
{
    CurrentDOFHitEffect = DOFEffect;
    CurrentDOFHitEffect.bShowInGame = true;
    CurrentHitEffectFadeTime = HitEffectFadeTime;
    MaxHitEffectFadeTime = HitEffectFadeTime;
    //return;    
}

simulated event FinishHeal()
{
    // End:0x22
    if(AudioComp_HealLoop != none)
    {
        AudioComp_HealLoop.Stop();
        AudioComp_HealLoop = none;
    }
    bHealFade = false;
    //return;    
}

simulated function FinishSiphonSound()
{
    AudioComp_Siphon.Stop();
    AudioComp_Siphon = none;
    //return;    
}

function GiveKnifeToPlayer()
{
    // End:0x6B
    if(Weapon != none)
    {
        // End:0x6B
        if(KnifeComponent != none)
        {
            Weapon.SetHidden(true);
            Mesh.AttachComponentToSocket(KnifeComponent, 'Knife');
            SPWeapon(Weapon).DetermineDestFOV(0.0000000);
            bKnifeAttached = true;
        }
    }
    //return;    
}

function TakeKnifeFromPlayer()
{
    // End:0x62
    if(Weapon != none)
    {
        Weapon.SetHidden(false);
        // End:0x44
        if(KnifeComponent != none)
        {
            Mesh.DetachComponent(KnifeComponent);
            bKnifeAttached = false;
        }
        SPWeapon(Weapon).DetermineDestFOV(0.0000000);
    }
    //return;    
}

function bool HasKnife()
{
    return bKnifeAttached;
    //return ReturnValue;    
}

function float GiveLifeForce(float lifeForceAmt, float DeltaTime)
{
    local float healthToGive, recoverRate;
    local int scratchInt;
    local PandoraPlayerController thePlayerController;

    thePlayerController = PandoraPlayerController(Controller);
    // End:0x21
    if(thePlayerController == none)
    {
        return 0.0000000;
    }
    scratchInt = Clamp(int(WorldInfo.TimeSeconds - RefSiphonTime), 0, 2);
    healthToGive = float(HealthMax) - float(Health);
    // End:0x10D
    if((healthToGive > 0.0000000) && LifeForce >= maxLifeForce)
    {
        recoverRate = Class'PandoraPlayerInput'.default.LifeForceParams.AHealRate[scratchInt];
        recoverRate *= DeltaTime;
        recoverRate = FMin(recoverRate, healthToGive);
        recoverRate = FMin(recoverRate, lifeForceAmt);
        partialHealthRestore += (recoverRate * 1.0000100);
        scratchInt = int(partialHealthRestore);
        Health += scratchInt;
        partialHealthRestore -= float(scratchInt);        
    }
    else
    {
        recoverRate = Class'PandoraPlayerInput'.default.LifeForceParams.ASiphonRate[scratchInt];
        recoverRate *= DeltaTime;
        recoverRate = FMin(recoverRate, lifeForceAmt);
        LifeForce = FClamp(LifeForce + (recoverRate * 1.0000100), 0.0000000, maxLifeForce);
    }
    return recoverRate;
    //return ReturnValue;    
}

simulated function SetupSignetHandEffect()
{
    // End:0x66
    if(HandMaterialInst == none)
    {
        HandMaterialInst = new (none) Class'Engine.MaterialInstanceConstant';
        HandMaterialInst.SetParent(Mesh.GetMaterial(HandMaterialIndex));
        Mesh.SetMaterial(HandMaterialIndex, HandMaterialInst);
    }
    //return;    
}

function SetupMaterialForPickupObject(DynamicSMActor Pickup)
{
    // End:0xB9
    if(Pickup.MaterialInst == none)
    {
        Pickup.MaterialInst = new (none) Class'Engine.MaterialInstanceConstant';
        Pickup.NormalMaterial = Pickup.StaticMeshComponent.GetMaterial(0);
        Pickup.MaterialInst.SetParent(Pickup.NormalMaterial);
        Pickup.StaticMeshComponent.SetMaterial(0, Pickup.MaterialInst);
    }
    //return;    
}

function UpdateMaterialForPickupObject(DynamicSMActor Pickup)
{
    // End:0x41
    if(Pickup.MaterialInst != none)
    {
        Pickup.MaterialInst.SetScalarParameterValue('HighlightScaleValue', 1.0000000);
    }
    //return;    
}

function ResetMaterialForPickupObject(DynamicSMActor Pickup)
{
    // End:0x61
    if((Pickup != none) && Pickup.NormalMaterial != none)
    {
        Pickup.StaticMeshComponent.SetMaterial(0, Pickup.NormalMaterial);
        Pickup.MaterialInst = none;
    }
    //return;    
}

simulated event Destroyed()
{
    // End:0x1D
    if(CurrentMaterialHitEffect != none)
    {
        CurrentMaterialHitEffect.bShowInGame = false;
    }
    // End:0x3A
    if(CurrentDOFHitEffect != none)
    {
        CurrentDOFHitEffect.bShowInGame = false;
    }
    ResetOnDeath();
    super(SPPawn).Destroyed();
    //return;    
}

exec function ToggleNewHud()
{
    // End:0x20
    if(playerHud != none)
    {
        playerHud.ToggleNewHud();
    }
    //return;    
}

exec function NextHud()
{
    //return;    
}

function BlendPlayerMinigameTackleAnimationsStage1(SPAnimGenericFunctionBlendNode Node)
{
    PandoraPlayerController(Controller).BlendPlayerMinigameTackleAnimationsStage1(Node);
    //return;    
}

function BlendPlayerMinigameTackleAnimationsStage2(SPAnimGenericFunctionBlendNode Node)
{
    PandoraPlayerController(Controller).BlendPlayerMinigameTackleAnimationsStage2(Node);
    //return;    
}

function name WWHARMinigameMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local name retval;
    local PandoraPlayerController myplayercontroller;

    myplayercontroller = PandoraPlayerController(Controller);
    // End:0x8C
    if(myplayercontroller != none)
    {
        switch(myplayercontroller.m_minigameState)
        {
            // End:0x44
            case 0:
                retval = 'Start';
                // End:0x8C
                break;
            // End:0x5B
            case 1:
                retval = 'Dodge';
                // End:0x8C
                break;
            // End:0x72
            case 2:
                retval = 'Counter';
                // End:0x8C
                break;
            // End:0x89
            case 3:
                retval = 'Fail';
                // End:0x8C
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return retval;
        //return ReturnValue;        
    }
}

simulated function Vector GetPulledInMuzzleLocation(SPWeapon Weap, Vector AimDir)
{
    local float MuzzleDist;
    local Vector MuzzleLoc, HitLocation, HitNormal;
    local Rotator MuzzleRot;
    local Actor HitActor;
    local editinline SPSkeletalMeshComponent weaponMesh;

    // End:0xF2
    if((GetIsPartiallyLookingDownSite()) && Weap != none)
    {
        weaponMesh = SPSkeletalMeshComponent(Weap.Mesh);
        // End:0xF2
        if(weaponMesh != none)
        {
            // End:0xEF
            if(weaponMesh.GetSocketWorldLocationAndRotation('LookDownSite', MuzzleLoc, MuzzleRot))
            {
                MuzzleDist = VSize2D(MuzzleLoc - Location);
                HitActor = Weap.GetTraceOwner().Trace(HitLocation, HitNormal, MuzzleLoc, MuzzleLoc - (MuzzleDist * AimDir), false, vect(12.0000000, 12.0000000, 12.0000000),, 1);
                // End:0xE6
                if(HitActor == none)
                {
                    return MuzzleLoc;                    
                }
                else
                {
                    return HitLocation;
                }                
            }            
        }
    }
    return super(SPPawn).GetPulledInMuzzleLocation(Weap, AimDir);
    //return ReturnValue;    
}

reliable server event RequestSiphon(SPLifeForceHolder LFHolder)
{
    PandoraGameInfo(WorldInfo.Game).AnimusMgr.RequestSiphon(self, LFHolder);
    //return;    
}

reliable server event RequestUnSiphon(SPLifeForceHolder LFHolder)
{
    PandoraGameInfo(WorldInfo.Game).AnimusMgr.RequestUnSiphon(self, LFHolder);
    //return;    
}

function SpawnDroppedAnimus()
{
    PandoraGameInfo(WorldInfo.Game).AnimusMgr.SpawnDroppedAnimus(self);
    //return;    
}

simulated function AddSiphonStream(SPLifeForceHolder LFHolder)
{
    local int slot;

    slot = ActiveLFStreams.Length;
    ActiveLFStreams[slot] = LFHolder;
    bInSiphon = true;
    CollectAnimNodeStatus = 0;
    lastHandEffect = 1;
    ResetSignetHandEffect(true);
    //return;    
}

simulated function RemoveSiphonStream(SPLifeForceHolder LFHolder)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x76 [Loop If]
    if(I < ActiveLFStreams.Length)
    {
        // End:0x6C
        if((ActiveLFStreams[I] == LFHolder) || ActiveLFStreams[I] == none)
        {
            ActiveLFStreams[I].KillAttachedParticles();
            ActiveLFStreams.Remove(I, 1);
            --I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x9E
    if(ActiveLFStreams.Length == 0)
    {
        bInSiphon = false;
        // End:0x9E
        if(CollectAnimNodeStatus < 2)
        {
            CollectAnimNodeStatus = 2;
        }
    }
    //return;    
}

simulated function RemoveAllActiveSiphonStreams()
{
    // End:0x82
    if(int(Role) == int(ROLE_Authority))
    {
        J0x10:

        // End:0x82 [Loop If]
        if(ActiveLFStreams.Length > 0)
        {
            // End:0x77
            if((ActiveLFStreams[0] != none) && ActiveLFStreams[0].GetTargetPawn() != none)
            {
                ActiveLFStreams[0].KillAttachedParticles();
                ActiveLFStreams[0].SetTargetPawn(none);                
            }
            else
            {
                ActiveLFStreams.Remove(0, 1);
            }
            // [Loop Continue]
            goto J0x10;
        }
    }
    bInSiphon = false;
    // End:0x9E
    if(CollectAnimNodeStatus < 2)
    {
        CollectAnimNodeStatus = 2;
    }
    //return;    
}

simulated function InitMPColor()
{
    local int NumElems, I;

    NumElems = ThirdPersonMesh.GetNumElements();
    MtlInstances.Length = 0;
    MtlInstances.Insert(0, NumElems);
    I = 0;
    J0x35:

    // End:0xBB [Loop If]
    if(I < NumElems)
    {
        MtlInstances[I] = new (none) Class'Engine.MaterialInstanceConstant';
        MtlInstances[I].SetParent(ThirdPersonMesh.GetMaterial(I));
        ThirdPersonMesh.SetMaterial(I, MtlInstances[I]);
        I++;
        // [Loop Continue]
        goto J0x35;
    }
    //return;    
}

simulated function NotifyTeamChanged()
{
    local int squadNameIdx;
    local SPPlayerReplicationInfo SPPRI;
    local PandoraPlayerController PC;

    SPPRI = SPPlayerReplicationInfo(PlayerReplicationInfo);
    // End:0x7A
    if((SPPRI != none) && SPPRI.Team != none)
    {
        squadNameIdx = GetSquadNameIndex();
        SPPRI.SquadNameAssignment = SPTeamInfo(SPPRI.Team).GetPreDefinedSquadName(squadNameIdx);
    }
    // End:0xB3
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        // End:0xB3
        if(WorldInfo.GRI != none)
        {
            AssignMPColorByTeam();
        }
    }
    PC = PandoraPlayerController(Controller);
    PC.NotifyTeamChanged();
    super(Pawn).NotifyTeamChanged();
    //return;    
}

simulated function SetMPColor(float R, float G, float B)
{
    local LinearColor clr;

    clr.R = R;
    clr.G = G;
    clr.B = B;
    clr.A = 1.0000000;
    SetMPColorLinear(clr);
    //return;    
}

simulated event EndCrouch(float HeightAdjust)
{
    local PandoraPlayerController PPC;

    PPC = PandoraPlayerController(Controller);
    // End:0x60
    if(PPC != none)
    {
        PPC.DisableDuckDisplay(0.0000000);
        // End:0x60
        if(int(Physics) == int(9))
        {
            bWantsToCrouch = false;
            PPC.ClearDuckValues();
        }
    }
    super.EndCrouch(HeightAdjust);
    //return;    
}

function ShouldCrouch(bool bCrouch)
{
    local bool bOldCrouch;

    bOldCrouch = bWantsToCrouch;
    super(Pawn).ShouldCrouch(bCrouch);
    // End:0x53
    if(!bOldCrouch && bWantsToCrouch)
    {
        PandoraPlayerController(Controller).LastDuckTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

simulated function SetMPColorLinear(LinearColor clr)
{
    CharacterColor = clr;
    // End:0x45
    if(m_BillboardComponent != none)
    {
        clr.A = 0.0000000;
        m_BillboardComponent.SetColor(clr);
    }
    //return;    
}

simulated function SetMPCharacterColorLinear(LinearColor clr)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xEE [Loop If]
    if(I < MtlInstances.Length)
    {
        MtlInstances[I].SetVectorParameterValue('MPColor', clr);
        // End:0xBC
        if(((clr.R != 1.0000000) || clr.G != 1.0000000) || clr.B != 1.0000000)
        {
            MtlInstances[I].SetScalarParameterValue('MP_Highlight', 1.0000000);
            // [Explicit Continue]
            goto J0xE4;
        }
        MtlInstances[I].SetScalarParameterValue('MP_Highlight', 0.0000000);
        J0xE4:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function HitByDamagePulse(const out Vector Origin, float normalizedStrength, class<DamageType> DamageType)
{
    local Vector knockVelocity;

    // End:0xA1
    if(DamageType == Class'SPDamageTypeExplosionFireDrakeImmolate')
    {
        knockVelocity = Location - Origin;
        knockVelocity.Z = 0.0000000;
        knockVelocity = Normal(knockVelocity);
        // End:0x5E
        if(normalizedStrength < 0.2500000)
        {
            normalizedStrength = 0.2500000;
        }
        knockVelocity = knockVelocity * (normalizedStrength * Class'SPTuneManager'.default.Difficulty.FireDrakeGD.RingImmolateMaxPlayerKnockVelocity);
        ExternalVelocity = knockVelocity;
    }
    //return;    
}

simulated function ApplyDamageImpulseFromKraken(Vector Origin)
{
    local Vector knockVelocity;
    local float normalizedStrength, Radius;

    knockVelocity = Location - Origin;
    Radius = VSize(knockVelocity);
    knockVelocity.Z = 0.0000000;
    knockVelocity = Normal(knockVelocity);
    // End:0xEB
    if(Radius < Class'SPTuneManager'.default.Difficulty.KrakenGD.KrakenTentacleHitKnockRadius)
    {
        normalizedStrength = 1.0000000 - (Radius / Class'SPTuneManager'.default.Difficulty.KrakenGD.KrakenTentacleHitKnockRadius);
        knockVelocity = knockVelocity * (normalizedStrength * Class'SPTuneManager'.default.Difficulty.KrakenGD.KrakenTentacleHitMaxPlayerKnockVelocity);
        ExternalVelocity = knockVelocity;
    }
    //return;    
}

simulated function SPMonsterMachinePersistent GetMonsterMachine()
{
    local SPMonsterMachinePersistent MM;

    // End:0x30
    foreach AllActors(Class'SPMonsterMachinePersistent', MM)
    {
        // End:0x2F
        if(MM.IsOwnedByPlayersTeam(self))
        {            
            return MM;
        }        
    }    
    return none;
    //return ReturnValue;    
}

reliable client simulated function StartAmBXAnimusDrain()
{
    PandoraPlayerController(Controller).PlayAmBxScript("animus_drain", 0);
    //return;    
}

reliable client simulated function StopAmBXAnimusDrain()
{
    PandoraPlayerController(Controller).StopAmBxScript("animus_drain");
    //return;    
}

event EnableSiphonFromDrain()
{
    local SPMonsterMachinePersistent MM;

    // End:0xCA
    if(!m_bSiphoningFromAnimusDrain)
    {
        CollectAnimNodeStatus = 0;
        bInSiphon = true;
        m_bAnimusDrain = true;
        m_bSiphoningFromAnimusDrain = true;
        StartAmBXAnimusDrain();
        // End:0xCA
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            MM = GetMonsterMachine();
            MM.LFHolder.CreateParticleStream(self);
            MM.LFHolder.RepStream.StreamTaker = self;
            MM.LFHolder.RepStream.StreamAdd = true;
        }
    }
    //return;    
}

event DisableSiphonFromDrain()
{
    local SPMonsterMachinePersistent MM;

    // End:0xC1
    if(m_bSiphoningFromAnimusDrain)
    {
        bInSiphon = false;
        m_bAnimusDrain = false;
        m_bSiphoningFromAnimusDrain = false;
        StopAmBXAnimusDrain();
        // End:0xC1
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            MM = GetMonsterMachine();
            MM.LFHolder.TerminateParticleStream(self);
            MM.LFHolder.RepStream.StreamTaker = self;
            MM.LFHolder.RepStream.StreamAdd = false;
        }
    }
    //return;    
}

simulated function bool IsSiphoning()
{
    return bInSiphon;
    //return ReturnValue;    
}

simulated function bool IsDraining()
{
    return m_bSiphoningFromAnimusDrain;
    //return ReturnValue;    
}

simulated function bool IsHealing()
{
    return bInHeal;
    //return ReturnValue;    
}

simulated function MegaDisableAnimusActivities()
{
    local PandoraPlayerController thePandoraPlayerController;

    thePandoraPlayerController = PandoraPlayerController(Controller);
    // End:0x27
    if(IsHealing())
    {
        FinishHeal();
    }
    // End:0x71
    if((thePandoraPlayerController != none) && PandoraPlayerInput(thePandoraPlayerController.PlayerInput) != none)
    {
        PandoraPlayerInput(thePandoraPlayerController.PlayerInput).AnimusDeActivate();
    }
    DisableAnimusActivities();
    RemoveAllActiveSiphonStreams();
    AnimusPulseFinished();
    //return;    
}

simulated function DisableAnimusActivitiesFromClient()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerDisableAnimusActivities();
    }
    MegaDisableAnimusActivities();
    //return;    
}

reliable server function ServerDisableAnimusActivities()
{
    MegaDisableAnimusActivities();
    //return;    
}

simulated function DisableAnimusActivitiesFromServer()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        ClientDisableAnimusActivities();
    }
    MegaDisableAnimusActivities();
    //return;    
}

reliable client simulated function ClientDisableAnimusActivities()
{
    MegaDisableAnimusActivities();
    //return;    
}

simulated function DisableAnimusActivities()
{
    local PandoraPlayerController PlayerController;

    PlayerController = PandoraPlayerController(Controller);
    bInSiphon = false;
    bInHeal = false;
    m_bAnimusDrain = false;
    FinishHeal();
    // End:0x4F
    if(PlayerController != none)
    {
        PlayerController.bLookDownSiteDisabled = false;
    }
    OutCollectOut();
    OutHealOut();
    //return;    
}

simulated function LinearColor GetDarkenedColor(LinearColor Src, float Coeff)
{
    local float ColorMax;
    local int DominantColor;
    local LinearColor OutColor;

    ColorMax = Src.R;
    DominantColor = 0;
    // End:0x54
    if(Src.G > ColorMax)
    {
        ColorMax = Src.G;
        DominantColor = 1;
    }
    // End:0x8C
    if(Src.B > ColorMax)
    {
        ColorMax = Src.B;
        DominantColor = 2;
    }
    switch(DominantColor)
    {
        // End:0xEA
        case 0:
            OutColor.R = Src.R;
            OutColor.G *= Coeff;
            OutColor.B *= Coeff;
            // End:0x19A
            break;
        // End:0x140
        case 1:
            OutColor.R *= Coeff;
            OutColor.G = Src.G;
            OutColor.B *= Coeff;
            // End:0x19A
            break;
        // End:0x197
        case 2:
            OutColor.R *= Coeff;
            OutColor.G *= Coeff;
            OutColor.B = Src.B;
            // End:0x19A
            break;
        // End:0xFFFF
        default:
            break;
    }
    OutColor.A = Src.A;
    return OutColor;
    //return ReturnValue;    
}

simulated function UpdatePlayerTags(float DeltaTime)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x1CE [Loop If]
    if(I < CurNumPlayerTags)
    {
        switch(PlayerNameTags[I].FadeMode)
        {
            // End:0xEA
            case 1:
                PlayerNameTags[I].CurrentColor.A += (FadeInIncr * DeltaTime);
                PlayerNameTags[I].bRender = true;
                // End:0xE7
                if(PlayerNameTags[I].CurrentColor.A > 1.0000000)
                {
                    PlayerNameTags[I].CurrentColor.A = 1.0000000;
                    PlayerNameTags[I].FadeMode = 0;
                }
                // End:0x1C4
                break;
            // End:0x1C1
            case 2:
                PlayerNameTags[I].CurrentColor.A -= (FadeOutIncr * DeltaTime);
                // End:0x1BE
                if(PlayerNameTags[I].CurrentColor.A < 0.0000000)
                {
                    PlayerNameTags[I].CurrentColor.A = 0.0000000;
                    PlayerNameTags[I].FadeMode = 0;
                    PlayerNameTags[I].bRender = false;
                    PlayerNameTags[I].LastUpdateTime = 2147484000.0000000;
                }
                // End:0x1C4
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function UpdatePlayerHighlight()
{
    local Actor HitActor;
    local PlayerPawn Player;
    local PandoraGRI PGRI;
    local SPWeapon theWeapon;
    local PlayerPawnMPPersistent SlavePawn;
    local Pawn MasterPawn;
    local int PlayerNameTagIdx;

    theWeapon = SPWeapon(Weapon);
    // End:0x1D
    if(theWeapon == none)
    {
        return;
    }
    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x44
    if(PGRI == none)
    {
        return;
    }
    // End:0x51
    if(Controller == none)
    {
        return;
    }
    HitActor = theWeapon.GetAimAtActor();
    Player = PlayerPawn(HitActor);
    // End:0xA5
    if((Player != none) && Player.GetStateName() == 'Dying')
    {
        return;
    }
    SlavePawn = PlayerPawnMPPersistent(Player);
    // End:0xEA
    if(SlavePawn != none)
    {
        MasterPawn = SlavePawn.GetMasterPawn();
        Player = PlayerPawn(MasterPawn);
    }
    // End:0x1A4
    if((Player != LastHighlightedPlayer) && LastHighlightedPlayer != none)
    {
        LastHighlightedPlayer.SetMPCharacterColorLinear(WHITE_Color);
        // End:0x17F
        if(bUseViewportNames)
        {
            PlayerNameTagIdx = GetOrAddPlayerNameTagIdx(LastHighlightedPlayer);
            PlayerNameTags[PlayerNameTagIdx].FadeMode = 2;
            PlayerNameTags[PlayerNameTagIdx].LastUpdateTime = WorldInfo.TimeSeconds;            
        }
        else
        {
            LastHighlightedPlayer.m_BillboardComponent.FadeOut();
        }
        LastHighlightedPlayer = none;
    }
    // End:0x2E4
    if((Player != none) && Player != LastHighlightedPlayer)
    {
        Player.SetMPCharacterColorLinear(Player.CharacterColor);
        // End:0x2BB
        if(bUseViewportNames)
        {
            PlayerNameTagIdx = GetOrAddPlayerNameTagIdx(Player);
            PlayerNameTags[PlayerNameTagIdx].FadeMode = 1;
            PlayerNameTags[PlayerNameTagIdx].bRender = true;
            PlayerNameTags[PlayerNameTagIdx].LastUpdateTime = WorldInfo.TimeSeconds;
            // End:0x2B8
            if(LastHighlightedPlayer != none)
            {
                PlayerNameTagIdx = GetOrAddPlayerNameTagIdx(LastHighlightedPlayer);
                PlayerNameTags[PlayerNameTagIdx].FadeMode = 2;
                PlayerNameTags[PlayerNameTagIdx].LastUpdateTime = WorldInfo.TimeSeconds;
            }            
        }
        else
        {
            Player.m_BillboardComponent.FadeIn();
        }
        LastHighlightedPlayer = Player;
    }
    //return;    
}

simulated function int FindOldestOrUnusedNameTagIdx()
{
    local float OldestTime;
    local int OldestIdx, I;

    I = 0;
    J0x07:

    // End:0x8A [Loop If]
    if(I < CurNumPlayerTags)
    {
        // End:0x39
        if(PlayerNameTags[I].bRender == false)
        {
            return I;
        }
        // End:0x80
        if(PlayerNameTags[I].LastUpdateTime > OldestTime)
        {
            OldestTime = PlayerNameTags[I].LastUpdateTime;
            OldestIdx = I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return OldestIdx;
    //return ReturnValue;    
}

simulated function InitPlayerNameTagIdx(int Idx, Actor A)
{
    local PlayerPawn PP;

    PP = PlayerPawn(A);
    PlayerNameTags[Idx].TheActor = A;
    PlayerNameTags[Idx].PlayerName = PP.PlayerReplicationInfo.PlayerName;
    PlayerNameTags[Idx].RenderColor = PP.CharacterColor;
    PlayerNameTags[Idx].RenderColor.A = 1.0000000;
    PlayerNameTags[Idx].CurrentColor = PP.CharacterColor;
    PlayerNameTags[Idx].CurrentColor.A = 0.0000000;
    PlayerNameTags[Idx].FadeMode = 1;
    PlayerNameTags[Idx].bRender = true;
    PlayerNameTags[Idx].LastUpdateTime = WorldInfo.TimeSeconds;
    //return;    
}

simulated function int GetOrAddPlayerNameTagIdx(Actor A)
{
    local int I, OldestIdx;

    // End:0x11
    if(A == none)
    {
        return -1;
    }
    I = 0;
    J0x18:

    // End:0x57 [Loop If]
    if(I < CurNumPlayerTags)
    {
        // End:0x4D
        if(PlayerNameTags[I].TheActor == A)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x18;
    }
    // End:0x8D
    if(CurNumPlayerTags < MaxNumPlayerTags)
    {
        InitPlayerNameTagIdx(CurNumPlayerTags, A);
        CurNumPlayerTags++;
        return CurNumPlayerTags - 1;        
    }
    else
    {
        OldestIdx = FindOldestOrUnusedNameTagIdx();
        InitPlayerNameTagIdx(OldestIdx, A);
        return OldestIdx;
    }
    return -1;
    //return ReturnValue;    
}

simulated function float WeaponWalkSpeedScalar()
{
    local SPWeapon myWeapon;

    myWeapon = SPWeapon(Weapon);
    // End:0x39
    if(myWeapon != none)
    {
        return myWeapon.m_gamePad.WalkSpeedScale;        
    }
    else
    {
        return 1.0000000;
    }
    //return ReturnValue;    
}

singular event BaseChange()
{
    // End:0x7C
    if((Pawn(Base) != none) && (DrivenVehicle == none) || !DrivenVehicle.IsBasedOn(Base))
    {
        // End:0x7C
        if(!Pawn(Base).CanBeBaseForPawn(self))
        {
            Pawn(Base).CrushedBy(self);
            JumpOffPawn();
        }
    }
    //return;    
}

event bool ActorCannotHitMe(const Actor Other)
{
    return false;
    //return ReturnValue;    
}

function bool DoJump(bool bUpdating)
{
    local Vector normalFacing;
    local float boost;
    local bool bApplyBoost;
    local PandoraPlayerController thePlayerController;
    local Vector NormalVelocity;
    local float Speed, SpeedMult, MaxGroundSpeed, MaXBoostSpeed;

    // End:0x343
    if(((bJumpCapable && !bIsCrouched) && !bWantsToCrouch) && ((int(Physics) == int(1)) || int(Physics) == int(9)) || int(Physics) == int(8))
    {
        // End:0x7E
        if(int(Physics) == int(8))
        {
            Velocity = JumpZ * Floor;            
        }
        else
        {
            // End:0xA7
            if(int(Physics) == int(9))
            {
                Velocity.Z = 0.0000000;                
            }
            else
            {
                // End:0x2B2
                if(int(Physics) == int(1))
                {
                    thePlayerController = PandoraPlayerController(Controller);
                    // End:0x13B
                    if(((thePlayerController != none) && thePlayerController.IsSprinting()) && thePlayerController.SprintTime > SprintJumpCost)
                    {
                        thePlayerController.ReduceSprintTime(SprintJumpCost);
                        boost = float(Max(0, int(percentOfMoveSpeedUsedForSprintJumpBoost * 0.0100000)));                        
                    }
                    else
                    {
                        boost = float(Max(0, int(percentOfMoveSpeedUsedForJumpBoost * 0.0100000)));
                    }
                    normalFacing = Normal(Vector(Rotation));
                    Velocity.Z = 0.0000000;
                    Speed = VSize(Velocity);
                    // End:0x1B5
                    if(Speed >= (minPercentageOfMaximumSpeedToApplyBoost * m_movementTypeInfo[m_currentMovementTypeIndex].GroundSpeed))
                    {
                        bApplyBoost = true;
                    }
                    // End:0x299
                    if(bApplyBoost)
                    {
                        // End:0x240
                        if(Speed > 1.0000000)
                        {
                            NormalVelocity = Velocity / Speed;
                            SpeedMult = GetDirectionSpeedMult();
                            MaxGroundSpeed = SpeedMult * m_movementTypeInfo[m_currentMovementTypeIndex].GroundSpeed;
                            MaXBoostSpeed = boost * MaxGroundSpeed;
                            Velocity = NormalVelocity * (MaxGroundSpeed + MaXBoostSpeed);                            
                        }
                        else
                        {
                            // End:0x299
                            if(Speed > 0.1000000)
                            {
                                MaxGroundSpeed = m_movementTypeInfo[m_currentMovementTypeIndex].GroundSpeed;
                                MaXBoostSpeed = boost * MaxGroundSpeed;
                                Velocity = normalFacing * (MaxGroundSpeed + MaXBoostSpeed);                                
                            }
                        }
                    }
                    Velocity.Z = JumpZ;                    
                }
                else
                {
                    Velocity.Z = JumpZ;
                }
            }
        }
        // End:0x33C
        if(((Base != none) && !Base.bWorldGeometry) && Base.Velocity.Z > 0.0000000)
        {
            Velocity.Z += Base.Velocity.Z;
        }
        SetPhysics(2);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Matrix GetPositionTrackerMatrix()
{
    local int BoneIndex;
    local Matrix boneMatrix;

    BoneIndex = Mesh.MatchRefBone('JO_positionTracker');
    boneMatrix = Mesh.GetBoneMatrix(BoneIndex);
    return boneMatrix;
    //return ReturnValue;    
}

simulated function float GetLookDownSitePercent()
{
    return LookDownSitePercent;
    //return ReturnValue;    
}

simulated function SetLookDownSitePercent(float newLookDownSitePercent)
{
    local SPWeapon SPWeapon;

    SPWeapon = SPWeapon(Weapon);
    // End:0x6D
    if(SPWeapon != none)
    {
        // End:0x4C
        if(newLookDownSitePercent == float(1))
        {
            // End:0x49
            if(LookDownSitePercent < float(1))
            {
                SPWeapon.EnterADS();
            }            
        }
        else
        {
            // End:0x6D
            if(LookDownSitePercent == float(1))
            {
                SPWeapon.ExitADS();
            }
        }
    }
    LookDownSitePercent = newLookDownSitePercent;
    //return;    
}

simulated function float GetLookDownSitePercentChangeRate()
{
    return LookDownSitePercentChangeRate;
    //return ReturnValue;    
}

simulated function SetLookDownSitePercentChangeRate(float newLookDownSitePercentChangeRate)
{
    LookDownSitePercentChangeRate = newLookDownSitePercentChangeRate;
    // End:0x23
    if(LookDownSitePercentChangeRate == float(0))
    {
        ADSTransitionStatus = 0;        
    }
    else
    {
        // End:0x3B
        if(LookDownSitePercentChangeRate > float(0))
        {
            ADSTransitionStatus = 1;            
        }
        else
        {
            ADSTransitionStatus = 2;
        }
    }
    //return;    
}

simulated function PlayerPawn.ADSTransitionState GetADSTransitionState()
{
    return ADSTransitionStatus;
    //return ReturnValue;    
}

simulated function BeginLookDownSiteCameraMode(float Time)
{
    // End:0x1F
    if(int(Role) < int(ROLE_Authority))
    {
        DoBeginLookDownSiteCameraMode(Time);
    }
    ServerBeginLookDownSiteCameraMode(Time);
    //return;    
}

unreliable server function ServerBeginLookDownSiteCameraMode(float Time)
{
    DoBeginLookDownSiteCameraMode(Time);
    //return;    
}

simulated function DoBeginLookDownSiteCameraMode(float Time)
{
    local float percentToGo, theChangeRate;

    // End:0x2E
    if(Time ~= float(0))
    {
        SetLookDownSitePercent(1.0000000);
        SetLookDownSitePercentChangeRate(0.0000000);        
    }
    else
    {
        percentToGo = 1.0000000 - (GetLookDownSitePercent());
        theChangeRate = percentToGo / Time;
        // End:0x85
        if(theChangeRate ~= float(0))
        {
            SetLookDownSitePercent(1.0000000);
            SetLookDownSitePercentChangeRate(0.0000000);            
        }
        else
        {
            SetLookDownSitePercentChangeRate(theChangeRate);
        }
    }
    //return;    
}

simulated function BeginFirstPersonCameraMode(float Time, bool notLookingDownSite)
{
    // End:0x25
    if(int(Role) < int(ROLE_Authority))
    {
        DoBeginFirstPersonCameraMode(Time, notLookingDownSite);
    }
    ServerBeginFirstPersonCameraMode(Time, notLookingDownSite);
    //return;    
}

unreliable server function ServerBeginFirstPersonCameraMode(float Time, bool notLookingDownSite)
{
    DoBeginFirstPersonCameraMode(Time, notLookingDownSite);
    //return;    
}

simulated function DoBeginFirstPersonCameraMode(float Time, bool notLookingDownSite)
{
    local float percentToGo, theChangeRate;

    // End:0x39
    if((Time == float(0)) || notLookingDownSite)
    {
        SetLookDownSitePercent(0.0000000);
        SetLookDownSitePercentChangeRate(0.0000000);        
    }
    else
    {
        percentToGo = 0.0000000 - (GetLookDownSitePercent());
        theChangeRate = percentToGo / Time;
        // End:0xBA
        if(theChangeRate ~= float(0))
        {
            // End:0x9D
            if(theChangeRate < float(0))
            {
                SetLookDownSitePercent(0.0000000);
                SetLookDownSitePercentChangeRate(0.0000000);                
            }
            else
            {
                theChangeRate = 0.0010000;
                SetLookDownSitePercentChangeRate(theChangeRate);
            }            
        }
        else
        {
            SetLookDownSitePercentChangeRate(theChangeRate);
        }
    }
    //return;    
}

simulated function UpdateLookDownSitePercent(float DeltaTime)
{
    local float currLookDownSitePercent, currLookDownSitePercentChangeRate;

    currLookDownSitePercentChangeRate = GetLookDownSitePercentChangeRate();
    // End:0x9D
    if(currLookDownSitePercentChangeRate != float(0))
    {
        currLookDownSitePercent = GetLookDownSitePercent();
        currLookDownSitePercent += (currLookDownSitePercentChangeRate * DeltaTime);
        // End:0x67
        if(currLookDownSitePercent > float(1))
        {
            currLookDownSitePercent = 1.0000000;
            SetLookDownSitePercentChangeRate(0.0000000);
        }
        // End:0x8E
        if(currLookDownSitePercent < float(0))
        {
            currLookDownSitePercent = 0.0000000;
            SetLookDownSitePercentChangeRate(0.0000000);
        }
        SetLookDownSitePercent(currLookDownSitePercent);
    }
    //return;    
}

simulated function bool ShouldApplyPlayerOnlyDamage()
{
    return true;
    //return ReturnValue;    
}

simulated event int GetEffectivePitch()
{
    local SPSkelControlPlayerPitch thePitchControl;
    local int thePitch, MinPitch, maxPitch;

    // End:0x34
    if(Controller != none)
    {
        thePitch = NormalizeRotAxis(Controller.Rotation.Pitch);        
    }
    else
    {
        thePitch = NormalizeRotAxis(DesiredAimPitch);
    }
    thePitchControl = GetPitchSkelControl();
    // End:0xE6
    if(thePitchControl != none)
    {
        MinPitch = int((thePitchControl.m_minPitch / float(360)) * float(65536));
        maxPitch = int((thePitchControl.m_maxPitch / float(360)) * float(65536));
        // End:0xCC
        if(thePitch < MinPitch)
        {
            thePitch = MinPitch;
        }
        // End:0xE6
        if(thePitch > maxPitch)
        {
            thePitch = maxPitch;
        }
    }
    return thePitch;
    //return ReturnValue;    
}

event int GetMaxSimultaneousEnemies()
{
    return Class'SPTuneManager'.static.GetGameDifficultyTunePlayer().MaxSimultaneousEnemies;
    //return ReturnValue;    
}

singular simulated function Rotator GetBaseAimRotation()
{
    local Rotator POVRot;
    local Vector cameraPos;
    local Rotator cameraRot;

    // End:0x34
    if(!InFreeCam())
    {
        Class'PandoraPlayerCamera'.static.GetFirstPersonBaseInfo(self, cameraPos, cameraRot);
        return cameraRot;
    }
    POVRot = Rotation;
    // End:0x6B
    if(POVRot.Pitch == 0)
    {
        POVRot.Pitch = RemoteViewPitch;
    }
    return POVRot;
    //return ReturnValue;    
}

simulated function bool HasReachedMaxLargeWeaponCount()
{
    return m_bHasReachedMaxLargeWeaponCount;
    //return ReturnValue;    
}

simulated function SetHasReachedMaxLargeWeaponCount()
{
    m_bHasReachedMaxLargeWeaponCount = true;
    //return;    
}

simulated function SwapWeaponsDueToNoAmmo()
{
    local SPInventoryManager spInvManager;
    local Weapon Weap;

    spInvManager = SPInventoryManager(InvManager);
    // End:0x75
    if((spInvManager != none) && SPWeapon(Weapon) != none)
    {
        Weap = spInvManager.GetWeaponForNoAmmoSwitch(SPWeapon(Weapon));
        // End:0x75
        if(Weap != none)
        {
            InvManager.SetCurrentWeapon(Weap);
        }
    }
    //return;    
}

simulated function AutoReloadFromPickup(Weapon weaponPickup)
{
    local PandoraPlayerController PlayerController;

    PlayerController = PandoraPlayerController(Controller);
    // End:0x40
    if((PlayerController != none) && Weapon == weaponPickup)
    {
        PlayerController.DoReload();
    }
    //return;    
}

simulated event ReloadFromAnimationFinishedNotify()
{
    m_bReloadFromAnimationFinished = true;
    //return;    
}

simulated function bool IsReloadFromAnimationFinished()
{
    return m_bReloadFromAnimationFinished;
    //return ReturnValue;    
}

simulated function ResetReloadFromAnimationValue()
{
    m_bReloadFromAnimationFinished = false;
    //return;    
}

simulated event bool GetIsFullyLookingDownSite()
{
    // End:0x0F
    if(LookDownSitePercent == float(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event bool GetIsPartiallyLookingDownSite()
{
    // End:0x0F
    if(LookDownSitePercent != float(0))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool GetIsTryingToLookDownSite()
{
    return bIsTryingToLookDownSite;
    //return ReturnValue;    
}

simulated function SetIsTryingToLookDownSite(bool NewValue)
{
    bIsTryingToLookDownSite = NewValue;
    //return;    
}

simulated function StartHitMaterialEffect(float FadeTime)
{
    // End:0x4F
    if((playerHud != none) && playerHud.GetEffectsManager() != none)
    {
        playerHud.GetEffectsManager().ActivateHitMaterialEffect(FadeTime);
    }
    //return;    
}

function CheckTMGAllignment()
{
    local PandoraPlayerController PlayerController;

    PlayerController = PandoraPlayerController(Controller);
    // End:0x2F
    if(PlayerController != none)
    {
        PlayerController.CheckTMGAllignment();
    }
    //return;    
}

unreliable client simulated event PlayerShotSomething()
{
    // End:0x1F
    if(playerHud != none)
    {
        playerHud.PlayerShotSomething();
    }
    //return;    
}

state Dying
{
    function BeginState(name PreviousStateName)
    {
        local SPGameUISceneClient theSceneClient;
        local PandoraPlayerController PC;

        // End:0xC2
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            // End:0xC2
            if(Controller != none)
            {
                PC = PandoraPlayerController(Controller);
                theSceneClient = PC.GetSceneClient();
                // End:0x83
                if(PC.IsLocalPlayerController())
                {
                    theSceneClient.CloseScenesByClass('UIScene_WeaponConfig');
                }
                PC.WaitDelay = WorldInfo.TimeSeconds + PandoraGRI(WorldInfo.GRI).RespawnTimer;
            }
        }
        Mesh.SetOwnerNoSee(true);
        // End:0xF2
        if(!bUseViewportNames)
        {
            m_BillboardComponent.hide();
        }
        // End:0x134
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            PandoraPlayerController(Controller).ToggleDeathEffect(true);
            SetTimer(7.0000000, false);            
        }
        else
        {
            SetTimer(2.5000000, false);
            // End:0x163
            if(int(WorldInfo.NetMode) != int(NM_Client))
            {
                SpawnDroppedAnimus();
            }
        }
        SetNovodexBoundingVolume(false);
        // End:0x183
        if(m_currentlyHeldTrigger != none)
        {
            StopUsingHoldTrigger();
        }
        //return;        
    }

    event DestroyTimer()
    {
        Destroy();
        //return;        
    }

    event Timer()
    {
        local PandoraPlayerController PC;

        // End:0x97
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            SPPlayerReplicationInfo(Controller.PlayerReplicationInfo).DeadLocation = vect(0.0000000, 0.0000000, 0.0000000);
            SPPlayerReplicationInfo(Controller.PlayerReplicationInfo).SetDeadLocation(vect(0.0000000, 0.0000000, 0.0000000));
            DetachFromController();
            SetTimer(5.0000000, false, 'DestroyTimer');            
        }
        else
        {
            // End:0x155
            if(Controller != none)
            {
                PC = PandoraPlayerController(Controller);
                // End:0x155
                if(PC != none)
                {
                    // End:0x128
                    if(LocalPlayer(PC.Player) != none)
                    {
                        PandoraGameViewportClient(LocalPlayer(PC.Player).ViewportClient).CurrCheckpointName = PC.SPCM.CurrCheckpoint.Name;
                    }
                    PandoraGameInfo(WorldInfo.Game).LocalPlayerDeath(PandoraPlayerController(Controller));
                }
            }
        }
        //return;        
    }

    k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        // End:0x18
        if(DamageType == none)
        {
            DamageType = Class'Engine.DamageType';
        }
        DamageAmount = float(FloatingPointAdjustDamage(DamageAmount));
        DamageAmount *= DamageType.default.GibModifier;
        Health -= int(DamageAmount);
        //return;        
    }
    stop;    
}
