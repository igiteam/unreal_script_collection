class MOHAPlayerPawn extends MOHAPawn
    native
    nativereplication
    config(Player)
    hidecategories(Navigation);

const MAX_WEAPON_TYPE_SP = 25;
const MAX_SP_MISSIONS = 7;
const MAX_SP_MEDALS = 6;
const MAX_HUD_NOTIFICATIONS = 8;
const NUM_MP_MAPS = 6;
const NUM_MP_AWARDS = 19;
const NUM_WEAPON_CLASSES = 7;
const MAX_RIVALS = 8;
const NUM_WEAPON_EXP_LEVELS = 3;
const NUM_MP_MEDALS = 15;
const NUM_MP_WEAPON_UPGRADES = 4;
const MAX_MISSION_SKILL_DROPS = 5;
const MAX_UPGRADEABLE_WEAPONS_SP = 16;
const NUM_XBLACH_UPGRADED_WEAPONS = 5;
const NUM_KILL_TIMES_TO_TRACK = 5;
const NUM_CONSECUTIVE_HEADSHOT_XBLACH = 10;
const MAX_DIFFICULTIES = 3;
const MAX_HUD_RENDERMODES = 4;
const MAX_SP_CHEAT_FLAGS = 7;
const WIDESCREEN_ASPECT_RATIO = 1.7777f;
const WIDESCREEN_INVERSE_ASPECT_RATIO = 0.5625f;
const MAX_HEALTH_DROPPED_PICKUPS = 1;
const MAX_HEALTH_DROPPED_PICKUPS_MP = 10;

enum EPlayerActivity
{
    PLAYER_ACTIVITY_IDLE,           // 0
    PLAYER_ACTIVITY_STAND_WALK,     // 1
    PLAYER_ACTIVITY_STAND_SPRINT,   // 2
    PLAYER_ACTIVITY_CROUCH_WALK,    // 3
    PLAYER_ACTIVITY_PRONE_CRAWL,    // 4
    PLAYER_ACTIVITY_PRONE_CRAWL_IN, // 5
    PLAYER_ACTIVITY_PRONE_CRAWL_OUT,// 6
    PLAYER_ACTIVITY_FIRE,           // 7
    PLAYER_ACTIVITY_RELOAD,         // 8
    PLAYER_ACTIVITY_RELOAD_IN,      // 9
    PLAYER_ACTIVITY_RELOAD_OUT,     // 10
    PLAYER_ACTIVITY_MELEE,          // 11
    PLAYER_ACTIVITY_RECHAMBER,      // 12
    PLAYER_ACTIVITY_PRIME,          // 13
    PLAYER_ACTIVITY_PRIME_IDLE,     // 14
    PLAYER_ACTIVITY_PRIME_COOK,     // 15
    PLAYER_ACTIVITY_READY_COOK,     // 16
    PLAYER_ACTIVITY_THROW,          // 17
    PLAYER_ACTIVITY_TOSS,           // 18
    PLAYER_ACTIVITY_LOWER_WEAPON,   // 19
    PLAYER_ACTIVITY_RAISE_WEAPON,   // 20
    PLAYER_ACTIVITY_IRONSIGHTS_IN,  // 21
    PLAYER_ACTIVITY_IRONSIGHTS_OUT, // 22
    PLAYER_ACTIVITY_IRONSIGHTS_IDLE,// 23
    PLAYER_ACTIVITY_IRONSIGHTS_FIRE,// 24
    PLAYER_ACTIVITY_STANCE_CHANGE,  // 25
    PLAYER_ACTIVITY_JUMP_START,     // 26
    PLAYER_ACTIVITY_JUMP_IDLE,      // 27
    PLAYER_ACTIVITY_JUMP_END_SOFT,  // 28
    PLAYER_ACTIVITY_JUMP_END_HARD,  // 29
    PLAYER_ACTIVITY_DEMOCHARGE_IDLE,// 30
    PLAYER_ACTIVITY_DEMOCHARGE_PRIME,// 31
    PLAYER_ACTIVITY_DEMOCHARGE_PRIME_LOWER,// 32
    PLAYER_ACTIVITY_DEATH,          // 33
    PLAYER_ACTIVITY_DEATH_IN,       // 34
    PLAYER_ACTIVITY_CHUTE_DEPLOY,   // 35
    PLAYER_ACTIVITY_CHUTE_HANGING,  // 36
    PLAYER_ACTIVITY_CHUTE_CUT_ROPES,// 37
    PLAYER_ACTIVITY_CONTROLLED_FALL,// 38
    PLAYER_ACTIVTIY_CONTROLLED_FALL_MELEE,// 39
    PLAYER_ACTIVITY_CONTROLLED_FLARE,// 40
    PLAYER_ACTIVITY_CONTROLLED_LANDING,// 41
    PLAYER_ACTIVITY_REMOVE_GEAR,    // 42
    PLAYER_ACTIVITY_FREE_FALL,      // 43
    PLAYER_ACTIVITY_ALTFIRE_IN,     // 44
    PLAYER_ACTIVITY_ALTFIRE_OUT,    // 45
    PLAYER_ACTIVITY_MULTIPLAYER_ITP,// 46
    PLAYER_ACTIVITY_MULTIPLAYER_OBJECTIVE_RAISE,// 47
    PLAYER_ACTIVITY_MULTIPLAYER_OBJECTIVE_IDLE,// 48
    PLAYER_ACTIVITY_MULTIPLAYER_OBJECTIVE_LOWER,// 49
    PLAYER_ACTIVITY_ENTER_LADDER_TOP,// 50
    PLAYER_ACTIVITY_ENTER_LADDER_BOTTOM,// 51
    PLAYER_ACTIVITY_EXIT_LADDER_TOP,// 52
    PLAYER_ACTIVITY_EXIT_LADDER_BOTTOM,// 53
    PLAYER_ACTIVITY_ON_LADDER,      // 54
    PLAYER_ACTIVITY_SCOPE_IN,       // 55
    PLAYER_ACTIVITY_SCOPE_OUT,      // 56
    PLAYER_ACTIVITY_COUNT,          // 57
    PLAYER_MAX                      // 58
};

enum EITPActivity
{
    ITP_ACTIVITY_MAIN,              // 0
    ITP_ACTIVITY_VOL_JUMP,          // 1
    ITP_ACTIVITY_INVOL_JUMP,        // 2
    ITP_ACTIVITY_COUNT,             // 3
    ITP_ACTIVITY_MAX                // 4
};

enum EBRFActivity
{
    BRF_ACTIVITY_SIT_IDLE,          // 0
    BRF_ACTIVITY_STANDING,          // 1
    BRF_ACTIVITY_MAX                // 2
};

enum EPlayerStance
{
    STANCE_STANDING,                // 0
    STANCE_CROUCHED,                // 1
    STANCE_PRONE,                   // 2
    STANCE_COUNT,                   // 3
    STANCE_MAX                      // 4
};

enum EPlayerStanceChange
{
    STANCE_CHANGE_NONE,             // 0
    STANCE_CHANGE_CROUCH_TO_PRONE,  // 1
    STANCE_CHANGE_CROUCH_TO_STAND,  // 2
    STANCE_CHANGE_PRONE_TO_CROUCH,  // 3
    STANCE_CHANGE_PRONE_TO_STAND,   // 4
    STANCE_CHANGE_STAND_TO_CROUCH,  // 5
    STANCE_CHANGE_STAND_TO_PRONE,   // 6
    STANCE_CHANGE_COUNT,            // 7
    STANCE_CHANGE_MAX               // 8
};

enum EAnimLocomotionState
{
    LOCOMOTION_IDLE,                // 0
    LOCOMOTION_WALK,                // 1
    LOCOMOTION_SPRINT,              // 2
    LOCOMOTION_MAX                  // 3
};

enum EAirDropLandingType
{
    AIRDROP_LANDING_PERFECT,        // 0
    AIRDROP_LANDING_HARD_FORWARD,   // 1
    AIRDROP_LANDING_HARD_BACK,      // 2
    AIRDROP_LANDING_HARD_LEFT,      // 3
    AIRDROP_LANDING_HARD_RIGHT,     // 4
    AIRDROP_LANDING_FLARED,         // 5
    AIRDROP_LANDING_GREASED,        // 6
    AIRDROP_LANDING_COUNT,          // 7
    AIRDROP_LANDING_MAX             // 8
};

enum EAirDropMoveDirection
{
    AIRDROP_MOVE_DIRECTION_NONE,    // 0
    AIRDROP_MOVE_DIRECTION_FORWARD, // 1
    AIRDROP_MOVE_DIRECTION_BACK,    // 2
    AIRDROP_MOVE_DIRECTION_LEFT,    // 3
    AIRDROP_MOVE_DIRECTION_RIGHT,   // 4
    AIRDROP_MOVE_COUNT,             // 5
    AIRDROP_MOVE_MAX                // 6
};

enum EPickupType
{
    PICKUP_AMMO,                    // 0
    PICKUP_WEAPON,                  // 1
    PICKUP_HEALTH,                  // 2
    PICKUP_MAX                      // 3
};

struct native ViewShakeInfo
{
    var() Vector OffsetMag;
    var() Vector OffsetRate;
    var() float OffsetTime;
    var() Vector RotMag;
    var() Vector RotRate;
    var() float RotTime;
    var() bool bDecayRotOverTime;
    var() bool bDecayOffsetOverTime;
    var float OffsetStartTime;
    var float RotStartTime;

    structdefaultproperties
    {
        OffsetMag=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        OffsetRate=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        OffsetTime=0.0000000
        RotMag=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RotRate=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RotTime=0.0000000
        bDecayRotOverTime=false
        bDecayOffsetOverTime=false
        OffsetStartTime=0.0000000
        RotStartTime=0.0000000
    }
};

struct native PlayerDamageRecord
{
    var string InstigatorName;
    var string InstigatorController;
    var string WeaponUsed;
    var int damageDone;
    var float LastHitDelta;

    structdefaultproperties
    {
        InstigatorName=""
        InstigatorController=""
        WeaponUsed=""
        damageDone=0
        LastHitDelta=0.0000000
    }
};

struct native PlayerDPSRecord
{
    var float dps;
    var float avgRange;
    var string InstigatorName;
    var int damageDone;
    var float Duration;
    var int numHits;
    var float Range;
    var float LastHitTime;

    structdefaultproperties
    {
        dps=0.0000000
        avgRange=0.0000000
        InstigatorName=""
        damageDone=0
        Duration=0.0000000
        numHits=0
        Range=0.0000000
        LastHitTime=0.0000000
    }
};

var(Animation) float fDefaultActivityBlendTime;
var(Animation) AnimSet ITP_AnimSet;
var(Animation) AnimTree ITP_AnimTree;
var(Animation) name HipsBoneName;
var(Animation) name HipsOffsetControlName;
var(Animation) name HipsOffsetControlRollName;
var(Animation) name ProceduralLagControlName;
var(Animation) name RightPropBoneName;
var(Animation) AnimSet ViewModelITPAnimset;
var(Animation) AnimTree ViewModelITPAnimTree;
var(Animation) AnimSet Default_AnimSet;
var(Animation) AnimTree Default_AnimTree;
var(Collision) config float StanceCollisionHeights[EPlayerStance];
var(Collision) config float StanceCollisionRadii[EPlayerStance];
var(Stances) bool bSnapToNewStanceHeight;
var bool bUseLeftFoot;
var(MotionSickness) bool bDisableSprintFX;
var bool bAnimatedStanceChange;
var bool bLockStanceHeight;
var bool bSprintRequested;
var bool bPreviousMotionBlurEnabled;
var bool bIronsightsActive;
var bool bLeanOutSoundPlayed;
var bool bPeekOutSoundPlayed;
var bool bAimButtonDown;
var bool bLeanCollision;
var bool bKeyboardPeek;
var bool bIronsightsWalkEnabled;
var bool bUseProceduralLag;
var bool bMountedOnMG;
var bool bProceduralJump;
var bool bDisableMoveInput;
var bool bDisableLookInput;
var bool bInstantlyStop;
var private bool bDisableWeapon;
var bool bForceIdleAnim;
var bool bSkippedITP;
var bool bVergeOfDeath;
var bool bVergeOfDeathSave;
var bool bHidingWeapons;
var bool bRestoringExperience;
var bool DoLookCompensation;
var bool bDebugLandingType;
var bool bInvoluntaryJump;
var bool bISITPFirstCalcCam;
var bool bRanITPSequence;
var() bool bITPDebugCam;
var(Stances) array<SoundCue> StanceChangeSounds;
var(Stances) float AnimatedStanceHeights[EPlayerStance];
var(Stances) float AnimatedStanceHeights3rdPerson[EPlayerStance];
var(Stances) config float fStanceHeightRestoreForce;
var(Stances) config float fStanceChangeInTime;
var(Stances) config float AnimatedStanceChangeTimes[EPlayerStanceChange];
var(Sounds) SoundCue GotHitSnd;
var(Sounds) SoundCue DeathSnd;
var(BehindView) config float CameraScale;
var(FOV) config float fDefaultViewmodelFOV;
var(Movement) config float fStrafeSpeedMult;
var(Movement) config float fStrafeSpeedMult_Leaning;
var(Movement) config float fBackwardSpeedMult;
var(Movement) config float fSprintSpeedMult;
var(Movement) config float StanceSpeedMult[EPlayerStance];
var(Movement) config float fMaxDeceleration;
var(Movement) config float fIronSightsSpeedMult;
var(Movement) float QuantizedInput;
var(Footsteps) config float fMinFallSpeedForLandedSound;
var(Footsteps) config float FootstepFrequency;
var(Footsteps) config float LadderFootstepFrequency;
var(Footsteps) config float MaxFootstepInterval;
var(Footsteps) config float MaxLadderFootstepInterval;
var(Footsteps) config float FootstepSpeedThreshold;
var(Footsteps) config float FootstepSprintInterval;
var(Footsteps) config float FirstFootstepInterval;
var(Footsteps) config Vector LeftFootLocation;
var(Footsteps) config Vector RightFootLocation;
var(Camera) int tempOffsetX;
var(Camera) int tempOffsetY;
var(Camera) int tempOffsetZ;
var(Health) config float DefaultHealthSettings[3];
var(Health) config float fImmuneTimeAfterDamageSettings[3];
var(Health) config float fInCoverDamageScale;
var(Health) config float fExposedDamageScale;
var(Health) config float fAirdropDamageScale;
var(Health) config Vector2D fBulletFilteredPct_Settings[3];
var(Ironsights) SoundCue LeanInSnd;
var(Ironsights) SoundCue LeanOutSnd;
var(Ironsights) SoundCue PeekInSnd;
var(Ironsights) SoundCue PeekOutSnd;
var(Ironsights) config float LeanOutSndThreshold;
var(Ironsights) config float LeanInSndThreshold;
var(Ironsights) config float PeekOutSndThreshold;
var(Ironsights) config float PeekInSndThreshold;
var(Ironsights) config float fIronsightsMaxRoll;
var(Ironsights) config float fIronsightsMaxLean;
var(Ironsights) config float fIronsightsLeanRestoreForce;
var(Ironsights) config float fIronsightsHeightRestoreForce;
var(Ironsights) config float fIronsightsPeekScale;
var(Ironsights) float fLeanCollisionBuffer;
var(Jump) config float fHardJumpLandingSpeed;
var(Jump) config float fMaxJumpCameraOffset;
var(Jump) config float fAnimatedJumpThreshold;
var(Jump) config float fProceduralJumpRestoreForce;
var(Jump) config float fProceduralJumpLandRestoreRate;
var(Jump) config float fMinDistForFallBlend;
var(Jump) config float fJumpStartAnimTime;
var(Jump) config float fJumpEndSoftAnimTime;
var(Jump) config float fJumpEndHardAnimTime;
var(Lag) config float fShoulderLagRestoreForce_Y;
var(Lag) config float fShoulderLagRestoreForce_Z;
var(Lag) config float fMaxShoulderLag_Y;
var(Lag) config float fMaxShoulderLag_Z;
var(Lag) config float fMaxShoulderLag_Aim_Y;
var(Lag) config float fMaxShoulderLag_Aim_Z;
var(Lag) config float fShoulderLagSensitivity_Y;
var(Lag) config float fShoulderLagSensitivity_Z;
var(Lag) config float fShoulderLagSensitivity_Aim_Y;
var(Lag) config float fShoulderLagSensitivity_Aim_Z;
var(Lag) config float fShoulderLagRestoreForce_Y_Mouse;
var(Lag) config float fShoulderLagRestoreForce_Z_Mouse;
var(Lag) config float fShoulderLagSensitivity_Y_Mouse;
var(Lag) config float fShoulderLagSensitivity_Z_Mouse;
var(Lag) config float fShoulderLagSensitivity_Aim_Y_Mouse;
var(Lag) config float fShoulderLagSensitivity_Aim_Z_Mouse;
var(Death) config float fDeathFadeOutTime;
var(Death) config float fRespawnFadeInTime;
var(Death) config float fDeathFadeOutDelay;
var(Death) config float fScriptedDeathFadeOutTime;
var(Melee) config float fMeleeMissAcceleration;
var(Weapon) name WeaponAttachmentSocket;
var(Sound) SoundRiotMixSelect ShellShockMixSelect;
var(Sound) SoundRiotMixSelect DialogueDuckMix;
var(Sound) export editinline AudioComponent ShellShockSound;
var(Sound) export editinline AudioComponent NonRealtimeAudio;
var(FallDamage) config float fNoDamageNumStories;
var(FallDamage) config float fFullDamageNumStories;
var(FallDamage) config float fSingleStoryDistance;
var(FallDamage) SoundCue FallDamageSoundCue;
var(Sprint) config float fSprintFOV;
var(Sprint) config float fSprintZoomInRate;
var(Sprint) config float fSprintZoomOutRate;
var(Sprint) config float fSprintMotionBlurAmount;
var(Sprint) SoundRiotMixSelect SprintSoundMix;
var(VergeOfDeath) transient int iVergeOfDeathHealth;
var(VergeOfDeath) config float fVergeOfDeathHealthPct;
var(VergeOfDeath) config float fHealthPackDropHealthPct;
var(Airdrop) config float fAirDropDeployChuteAnimTime;
var config float fAirDropDeployChuteAnimTimeMultiplayer;
var(Airdrop) config float fAirDropControlledFallAnimTime[EAirDropMoveDirection];
var(Airdrop) config float fAirDropLandingAnimTime[EAirDropLandingType];
var(Airdrop) config float fAirDropLandedAnimTime;
var(Airdrop) config float fAirdropRemoveGearAnimTime;
var(Airdrop) config float fAirdropCutChuteAnimTime;
var(Airdrop) config float fAirdropMeleeAnimTime;
var export editinline MOHASkeletalMeshComponent FPArms;
var SkelControlSingleBone HipOffsetControl;
var SkelControlSingleBone HipOffsetControl_Roll;
var SkelControlSingleBone ProceduralLagControl;
var repnotify MOHAPlayerPawn.EPlayerActivity CurrentActivity;
var MOHAPlayerPawn.EPlayerActivity LastActivity;
var MOHAPlayerPawn.EPlayerStance eCurrentStance;
var MOHAPlayerPawn.EPlayerStance eDesiredStance;
var MOHAPlayerPawn.EPlayerStanceChange eCurrentStanceChange;
var MOHAPlayerPawn.EAirDropLandingType eLandingType;
var MOHAPlayerPawn.EAirDropMoveDirection eAirMoveDirection;
var MOHAPlayerPawn.EAirDropMoveDirection eAirMoveDirectionInternal;
var MOHAPlayerPawn.EITPActivity CurrentITPActivity;
var MOHAPlayerPawn.EBRFActivity CurrentBRFActivity;
var float PlaybackLength;
var float fActivityBlendTime;
var Vector vCurrentStanceHeightMod;
var Vector vStartingCameraPos_AS;
var float fCurrentSprintFOV;
var float fSprintZoomBlendOutTime;
var float fPreviousMotionBlurAmount;
var(whiz) export editinline WhizComponent whiz;
var float CurrentCameraScale;
var transient bool bInShellShock;
var transient class<DamageType> KillDamageType;
var float fIronsightsLean;
var float fIronsightsRoll;
var float fIronsightsPeek;
var float fDesiredLean;
var float fDesiredRoll;
var export editinline CylinderComponent LeanCollisionComponent;
var float fKeyboardLean;
var Rotator rLagRotVel;
var float fShoulderLag_Y;
var float fShoulderLag_Z;
var Rotator rMGRot;
var float fAimUpBlend;
var float fAimRightBlend;
var HealthSystem HealthManager;
var transient float fImmuneTimeAfterDamage;
var transient float fImmuneTime;
var transient float fBulletFilteredPct_Standing;
var transient float fBulletFilteredPct_Crouched;
var Rotator CurrentView;
var float fRawJoyUp;
var float fRawJoyRight;
var float fRawJoyLookRight;
var float fRawJoyLookUp;
var float fMouseX;
var float fMouseY;
var float fJumpCameraOffset;
var float fStartingPitch;
var float fStateTime;
var Vector vDesiredAnimOffset_AS;
var Vector vCurrentAnimOffset_AS;
var MOHAAnimNodePlayerActivity ActivityNode;
var MaterialInstance BodyMatInst;
var float fAiLodCullDist_AirDrop;
var float fAiLodCullDist_OnGround;
var int AiLodNonStasisClamp_AirDrop;
var int AiLodNonStasisClamp_OnGround;
var float fOverrideMaxSpeed;
var const CCStimulusType Stim_TakingLightDamage;
var const CCStimulusType Stim_DamageFromBehindShot;
var export editinline AudioComponent Airdrop_BG_Loop;
var export editinline AudioComponent Airdrop_WindVolumeLoop;
var Rotator PendulumRotation;
var Rotator AirdropVMRotation;
var float AirdropLookLeftRightAmount;
var float AirdropLookLeftRightOffset;
var float AirdropLookLeftRightPrev;
var float AirdropLookUpDownAmount;
var config float AirdropLookUpDownOffset;
var float AirdropLookUpDownPrev;
var float BlendOutAirdropView;
var float BlendOutAirdropViewTime;
var Quat AirdropViewCache;
var Rotator AirdropYawLookCompensation;
var int AirdropFallingPitchOffset;
var int AirdropFallingPitchTarget;
var float AirdropMouseAccumulator;
var name CameraSocketName;
var MOHAPlayerPlaneBase playerPlane;
var Rotator lastCachedRot;
var float fLastCachedRotCachedTime;
var name CameraSocketNameITP;
var name PushAnimName;
var name ITPLevelName;
var name ITPAnimMuxNodeName;
var Rotator EyeRotation;
var Vector EyeLocation;
var Rotator CameraRotation;
var AnimNodeBlend PushBlend;
var AnimNodeBlendPerBone PushBlendByBone;
var float fAnimControlPosition;
var(Camera) interp float fITPViewYawMin;
var(Camera) interp float fITPViewYawMax;
var(Camera) interp float fITPViewPitchMin;
var(Camera) interp float fITPViewPitchMax;
var(Camera) interp float fBriefingViewPitchMin;
var(Camera) interp float fBriefingViewPitchMax;
var(Camera) interp float fBriefingViewYawMin;
var(Camera) interp float fBriefingViewYawMax;
var float fDebugSkipWorldTimeVal;
var ViewShakeInfo CurrentViewShake;
var Vector ShakeOffset;
var Rotator ShakeRot;
var Rotator LastShakeRot;
var() Vector backVec;
var() export editinline SkeletalMeshComponent ITPClipMesh;
var export editinline MOHAWeaponUpgradeManager WeaponUpgradeManager;
var name AimAtSocketName;
var array<PlayerDamageRecord> DamageHistory;
var array<PlayerDPSRecord> DPSRecord;
var(DPSReport) array<PlayerDPSRecord> CommitedDPSRecord;
var float LastTakeDamageTime;
var float DPSInterval;
var float fMaxNPCBlockedTime;
var float fMaxGTFONPCBlockedTime;

replication
{
    // Pos:0x000
    if(bNetDirty && !bNetOwner
        eDesiredStance, eLandingType;
}

// Export UMOHAPlayerPawn::execRotateArms_Pitch(FFrame&, void* const)
native function RotateArms_Pitch(out Rotator out_ArmRotator, out Vector out_ArmTranslation, float fPitch);

// Export UMOHAPlayerPawn::execRotateArms_Roll(FFrame&, void* const)
native function RotateArms_Roll(out Rotator out_ArmRotator, out Vector out_ArmTranslation, float fRoll, float fPitch);

// Export UMOHAPlayerPawn::execRotateArms_MountedGun(FFrame&, void* const)
native function RotateArms_MountedGun(out Rotator out_ArmRotator, out Vector out_ArmTranslation, float fYaw, float fPitch);

// Export UMOHAPlayerPawn::execUpdateCollision(FFrame&, void* const)
native function UpdateCollision();

// Export UMOHAPlayerPawn::execPerformLandingDetection(FFrame&, void* const)
native function PerformLandingDetection(out MOHAPlayerPawn.EAirDropLandingType landingType, Vector pawnVelocity);

// Export UMOHAPlayerPawn::execUpdateRadialBlur(FFrame&, void* const)
native function UpdateRadialBlur(float blurIntensity);

// Export UMOHAPlayerPawn::execEnableRadialBlur(FFrame&, void* const)
native function EnableRadialBlur(bool bEnable);

// Export UMOHAPlayerPawn::execGetRootActivity(FFrame&, void* const)
native function MOHAPlayerPawn.EPlayerActivity GetRootActivity(AnimNode AnimNode);

// Export UMOHAPlayerPawn::execLoadAnimSetAndTree(FFrame&, void* const)
native function LoadAnimSetAndTree(AnimSet newAnimSet, AnimTree newAnimTree);

// Export UMOHAPlayerPawn::execUnloadAnimset(FFrame&, void* const)
native function UnloadAnimset(int Index, AnimSet animSetToUnload);

// Export UMOHAPlayerPawn::execNullITPAnimSequences(FFrame&, void* const)
native function NullITPAnimSequences();

// Export UMOHAPlayerPawn::execSetAiLodCullDistance(FFrame&, void* const)
native function SetAiLodCullDistance(float fDistance);

// Export UMOHAPlayerPawn::execSetAiLodNonStasisClamp(FFrame&, void* const)
native function SetAiLodNonStasisClamp(int numActiveNPCs);

// Export UMOHAPlayerPawn::execGetIronsightsLeanTranslation(FFrame&, void* const)
native function float GetIronsightsLeanTranslation(float fLean, float fRoll);

// Export UMOHAPlayerPawn::execResetPlayerPitch(FFrame&, void* const)
native function ResetPlayerPitch();

// Export UMOHAPlayerPawn::execGetAimPosToShootMe(FFrame&, void* const)
native function Vector GetAimPosToShootMe();

// Export UMOHAPlayerPawn::execSendKismetActivitySetEvent(FFrame&, void* const)
native function SendKismetActivitySetEvent(MOHAPlayerPawn.EPlayerActivity PreviousActivity, MOHAPlayerPawn.EPlayerActivity NextActivity);

// Export UMOHAPlayerPawn::execGetStanceHeight(FFrame&, void* const)
native function float GetStanceHeight(MOHAPlayerPawn.EPlayerStance eStance);

// Export UMOHAPlayerPawn::execNativeTick(FFrame&, void* const)
native simulated function NativeTick(float fDeltaTime);

// Export UMOHAPlayerPawn::execUpdateIronsightsLean(FFrame&, void* const)
native simulated function UpdateIronsightsLean(float fDeltaTime);

// Export UMOHAPlayerPawn::execUpdateIronsightsPeek(FFrame&, void* const)
native simulated function UpdateIronsightsPeek(float fDeltaTime);

// Export UMOHAPlayerPawn::execUpdateProceduralLag(FFrame&, void* const)
native simulated function UpdateProceduralLag(float fDeltaTime);

// Export UMOHAPlayerPawn::execUpdateAnimOffsetPos(FFrame&, void* const)
native simulated function UpdateAnimOffsetPos(float fDeltaTime);

// Export UMOHAPlayerPawn::execUpdateSkelControls(FFrame&, void* const)
native simulated function UpdateSkelControls(optional float fDeltaTime);

// Export UMOHAPlayerPawn::execGetStanceHeightModifier(FFrame&, void* const)
native simulated function Vector GetStanceHeightModifier(optional float fDeltaTime);

// Export UMOHAPlayerPawn::execSetControlRotation(FFrame&, void* const)
native simulated function SetControlRotation(SkelControlSingleBone SkelControl, Rotator rRot);

// Export UMOHAPlayerPawn::execSetControlTranslation(FFrame&, void* const)
native simulated function SetControlTranslation(SkelControlSingleBone SkelControl, Vector vTranslation);

// Export UMOHAPlayerPawn::execIronsightsControlEnabled(FFrame&, void* const)
native simulated function bool IronsightsControlEnabled();

// Export UMOHAPlayerPawn::execIronsightsLeanEnabled(FFrame&, void* const)
native simulated function bool IronsightsLeanEnabled();

// Export UMOHAPlayerPawn::execIronsightsMoveEnabled(FFrame&, void* const)
native simulated function bool IronsightsMoveEnabled();

// Export UMOHAPlayerPawn::execGetIronsightsPeekHeight(FFrame&, void* const)
native simulated function float GetIronsightsPeekHeight();

// Export UMOHAPlayerPawn::execGetViewRotationNative(FFrame&, void* const)
native simulated function Rotator GetViewRotationNative();

// Export UMOHAPlayerPawn::execGetPawnViewLocationNative(FFrame&, void* const)
native simulated function Vector GetPawnViewLocationNative();

// Export UMOHAPlayerPawn::execGetTeamIndex(FFrame&, void* const)
native simulated function int GetTeamIndex();

// Export UMOHAPlayerPawn::execIronsightsLeanCollision(FFrame&, void* const)
native simulated function bool IronsightsLeanCollision();

// Export UMOHAPlayerPawn::execSetQuickRotation(FFrame&, void* const)
native simulated function SetQuickRotation(Rotator NewRot);

// Export UMOHAPlayerPawn::execProcessViewRotationNative(FFrame&, void* const)
native simulated function ProcessViewRotationNative(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot);

// Export UMOHAPlayerPawn::execUpdateLagRotationVel(FFrame&, void* const)
native simulated function UpdateLagRotationVel(Rotator DeltaRot, float fDeltaTime);

// Export UMOHAPlayerPawn::execIsFirstPerson(FFrame&, void* const)
native simulated function bool IsFirstPerson();

// Export UMOHAPlayerPawn::execCheckIronsightsLeanCollision(FFrame&, void* const)
native simulated function bool CheckIronsightsLeanCollision(float fCurrentLean, float fCurrentRoll, out float out_fDesiredLean, out float out_fDesiredRoll);

// Export UMOHAPlayerPawn::execGetShoulderLagValues(FFrame&, void* const)
native simulated function GetShoulderLagValues(out float fDesiredShoulderLag_Y, out float fDesiredShoulderLag_Z, out float LagRestoreY, out float LagRestoreZ);

// Export UMOHAPlayerPawn::execIsIronsightsActive(FFrame&, void* const)
native simulated function bool IsIronsightsActive();

// Export UMOHAPlayerPawn::execGetPlayerController(FFrame&, void* const)
native simulated function MOHAPlayerController GetPlayerController();

// Export UMOHAPlayerPawn::execUpdateJumpCameraOffset(FFrame&, void* const)
native simulated function UpdateJumpCameraOffset(float fDeltaTime);

// Export UMOHAPlayerPawn::execUpdateImmunityTimer(FFrame&, void* const)
native simulated function UpdateImmunityTimer(float DeltaTime);

// Export UMOHAPlayerPawn::execUpdateSprintZoom(FFrame&, void* const)
native simulated function UpdateSprintZoom(float DeltaTime);

// Export UMOHAPlayerPawn::execUpdateViewShake(FFrame&, void* const)
native simulated function UpdateViewShake(float DeltaTime);

// Export UMOHAPlayerPawn::execUpdateLeanSound(FFrame&, void* const)
native simulated function UpdateLeanSound(float fActualLeanPct, float fDesiredLeanPct);

// Export UMOHAPlayerPawn::execUpdatePeekSound(FFrame&, void* const)
native simulated function UpdatePeekSound(float fPeek);

// Export UMOHAPlayerPawn::execSetFootstepTimer(FFrame&, void* const)
native simulated function SetFootstepTimer();

// Export UMOHAPlayerPawn::execUpdatePluginMod(FFrame&, void* const)
native simulated function UpdatePluginMod();

// Export UMOHAPlayerPawn::execGetDesiredStanceHeightMod(FFrame&, void* const)
native simulated function Vector GetDesiredStanceHeightMod();

// Export UMOHAPlayerPawn::execGetMaxRunSpeed(FFrame&, void* const)
native simulated function float GetMaxRunSpeed();

// Export UMOHAPlayerPawn::execGetStanceSpeedMult(FFrame&, void* const)
native simulated function float GetStanceSpeedMult();

// Export UMOHAPlayerPawn::execGetWeaponSpeedMultiplier(FFrame&, void* const)
native simulated function float GetWeaponSpeedMultiplier();

// Export UMOHAPlayerPawn::execGetStrafeSpeedMult(FFrame&, void* const)
native simulated function float GetStrafeSpeedMult();

// Export UMOHAPlayerPawn::execIsSprintEnabled(FFrame&, void* const)
native simulated function bool IsSprintEnabled();

// Export UMOHAPlayerPawn::execApplyJumpCameraOffset(FFrame&, void* const)
native simulated function ApplyJumpCameraOffset(out Vector vLocation, Vector vUp);

// Export UMOHAPlayerPawn::execApplyDebugCameraOffset(FFrame&, void* const)
native simulated function ApplyDebugCameraOffset(out Vector vLocation, Vector vFwd, Vector vRight, Vector vUp);

// Export UMOHAPlayerPawn::execApplyWeaponCameraOffset(FFrame&, void* const)
native simulated function ApplyWeaponCameraOffset(out Vector vLocation, Vector vFwd, Vector vRight, Vector vUp);

// Export UMOHAPlayerPawn::execGetActivityBlendTime(FFrame&, void* const)
native simulated function float GetActivityBlendTime(MOHAPlayerPawn.EPlayerActivity NextActivity);

// Export UMOHAPlayerPawn::execIsCrawlActivity(FFrame&, void* const)
native simulated function bool IsCrawlActivity(MOHAPlayerPawn.EPlayerActivity eActivity);

// Export UMOHAPlayerPawn::execGetWeaponUpgradeLevel(FFrame&, void* const)
native simulated function int GetWeaponUpgradeLevel();

// Export UMOHAPlayerPawn::execGetWeaponMode(FFrame&, void* const)
native simulated function int GetWeaponMode();

// Export UMOHAPlayerPawn::execWeaponIronsightsActive(FFrame&, void* const)
native simulated function int WeaponIronsightsActive();

// Export UMOHAPlayerPawn::execGetWeaponTapedMagazineMode(FFrame&, void* const)
native simulated function int GetWeaponTapedMagazineMode();

// Export UMOHAPlayerPawn::execGetWeaponHellBoxIdleMode(FFrame&, void* const)
native simulated function int GetWeaponHellBoxIdleMode();

// Export UMOHAPlayerPawn::execIsWeaponScopeEnabled(FFrame&, void* const)
native simulated function int IsWeaponScopeEnabled();

// Export UMOHAPlayerPawn::execSetDefaultHealth(FFrame&, void* const)
native simulated function SetDefaultHealth(int DefaultHealth);

// Export UMOHAPlayerPawn::execGetEALAWeapon(FFrame&, void* const)
native simulated function bool GetEALAWeapon(out EALAWeapon EALAWeapon);

// Export UMOHAPlayerPawn::execGetSmallArmsWeapon(FFrame&, void* const)
native simulated function bool GetSmallArmsWeapon(out EALASmallArms SmallArmsWeapon);

// Export UMOHAPlayerPawn::execCenterPlayerWithLadder(FFrame&, void* const)
native simulated function CenterPlayerWithLadder();

// Export UMOHAPlayerPawn::execChangeStance(FFrame&, void* const)
native simulated function ChangeStance();

// Export UMOHAPlayerPawn::execSetWeaponDisabled(FFrame&, void* const)
native simulated function SetWeaponDisabled(bool bDisabled);

// Export UMOHAPlayerPawn::execIsWeaponDisabled(FFrame&, void* const)
native simulated function bool IsWeaponDisabled();

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    InitSkeletalControls();
    fActivityBlendTime = fDefaultActivityBlendTime;
    SetViewModelFOV(fDefaultViewmodelFOV);
    CameraRotation = Rotation;
    whiz.RegisterWhiz();
    InitializeHealthSystem();
    FindActivityNode();
    WeaponUpgradeManager.Init();
    RenderBody(false);
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    NativeTick(DeltaTime);
    // End:0x3D
    if(HealthManager != none)
    {
        HealthManager.Tick(DeltaTime);
    }
    // End:0x60
    if(WeaponUpgradeManager != none)
    {
        WeaponUpgradeManager.Tick(DeltaTime);
    }
    // End:0x83
    if(TriggerVolumeSound != none)
    {
        TriggerVolumeSound.Tick(DeltaTime);
    }
    LastActivity = CurrentActivity;
    //return;    
}

function SetCurrentStance(MOHAPlayerPawn.EPlayerStance eNextStance)
{
    // End:0x49
    if(PlayerController(Controller).myHUD != none)
    {
        MOHAHUD(PlayerController(Controller).myHUD).NotifyStanceChange(eCurrentStance, eNextStance);
    }
    eCurrentStance = eNextStance;
    //return;    
}

event OnRemoveGear()
{
    //return;    
}

event OnDoneLanding()
{
    local MOHAPlayerController PlayerController;

    PlayerController = MOHAPlayerController(Controller);
    // End:0x2E
    if(PlayerController != none)
    {
        PlayerController.GotoState(LandMovementState);
    }
    HideWeapon(true);
    SetWeaponDisabled(false);
    GotoState('Idle');
    GotoState('Idle');
    // End:0x8C
    if(EALAWeapon(Weapon) != none)
    {
        EALAWeapon(Weapon).GotoState('WeaponEquipping');
    }
    //return;    
}

function UpwardStanceChangeRequest(optional bool bTwoStanceChange = false)
{
    // End:0x10
    if(bLockStanceHeight)
    {
        return;
    }
    // End:0x2B
    if(int(eCurrentStance) == int(1))
    {
        eDesiredStance = 0;        
    }
    else
    {
        // End:0x50
        if(int(eCurrentStance) == int(2))
        {
            eDesiredStance = ((bTwoStanceChange) ? 0 : 1);
        }
    }
    //return;    
}

function DownwardStanceChangeRequest(optional bool bTwoStanceChange = false)
{
    // End:0x10
    if(bLockStanceHeight)
    {
        return;
    }
    // End:0x28
    if(int(eCurrentStance) == int(0))
    {
        eDesiredStance = 1;
    }
    //return;    
}

simulated event MOHAPlayerPawn.EPlayerStanceChange GetStanceChangeType(MOHAPlayerPawn.EPlayerStance ePrevStance, MOHAPlayerPawn.EPlayerStance eNextStance)
{
    // End:0x28
    if((int(ePrevStance) == int(1)) && int(eNextStance) == int(2))
    {
        return 1;        
    }
    else
    {
        // End:0x50
        if((int(ePrevStance) == int(1)) && int(eNextStance) == int(0))
        {
            return 2;            
        }
        else
        {
            // End:0x78
            if((int(ePrevStance) == int(2)) && int(eNextStance) == int(1))
            {
                return 3;                
            }
            else
            {
                // End:0xA0
                if((int(ePrevStance) == int(2)) && int(eNextStance) == int(0))
                {
                    return 4;                    
                }
                else
                {
                    // End:0xC8
                    if((int(ePrevStance) == int(0)) && int(eNextStance) == int(2))
                    {
                        return 6;                        
                    }
                    else
                    {
                        // End:0xF0
                        if((int(ePrevStance) == int(0)) && int(eNextStance) == int(1))
                        {
                            return 5;                            
                        }
                        else
                        {
                            return 0;
                        }
                    }
                }
            }
        }
    }
    //return ReturnValue;    
}

simulated event bool IsIdle()
{
    return false;
    //return ReturnValue;    
}

simulated event bool IsSprinting()
{
    return false;
    //return ReturnValue;    
}

simulated event bool IsJumping()
{
    return false;
    //return ReturnValue;    
}

function bool IsDemoCharging()
{
    return false;
    //return ReturnValue;    
}

function bool IsDead()
{
    return false;
    //return ReturnValue;    
}

function bool CanRespawn()
{
    return false;
    //return ReturnValue;    
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    ProcessViewRotationNative(DeltaTime, out_ViewRotation, out_DeltaRot);
    super(Pawn).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    // End:0x30
    if(!IsFirstPerson())
    {
        CalcThirdPersonCam(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);        
    }
    else
    {
        GetActorEyesViewPoint(out_CamLoc, out_CamRot);
        // End:0x8F
        if((Weapon != none) && Weapon.IsA('EALASmallArms'))
        {
            EALASmallArms(Weapon).ProcessViewPush(out_CamLoc, out_CamRot, fDeltaTime);
        }
    }
    return true;
    //return ReturnValue;    
}

simulated event Vector GetPawnViewLocation()
{
    return GetPawnViewLocationNative();
    //return ReturnValue;    
}

simulated function Rotator GetViewRotation()
{
    return GetViewRotationNative();
    //return ReturnValue;    
}

simulated event Rotator GetViewRot()
{
    return GetViewRotation();
    //return ReturnValue;    
}

simulated function Vector GetGroundPos()
{
    local Vector GroundPos;

    GroundPos = Location;
    GroundPos.Z -= CylinderComponent.CollisionHeight;
    return GroundPos;
    //return ReturnValue;    
}

simulated function float GetGroundHeight()
{
    return Location.Z - CylinderComponent.CollisionHeight;
    //return ReturnValue;    
}

simulated function float GetCameraHeight()
{
    return GetCameraPos().Z - (GetGroundHeight());
    //return ReturnValue;    
}

simulated function Vector GetCameraPos()
{
    return GetBoneLocation('Camera');
    //return ReturnValue;    
}

simulated function Rotator GetCameraRotation()
{
    return GetBoneRotation('Camera');
    //return ReturnValue;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos, out int foundBase)
{
    local float fCameraHeight;

    // End:0x0D
    if(foundBase == 0)
    {
        return;
    }
    fCameraHeight = GetCameraHeight();
    super(Pawn).DisplayDebug(HUD, out_YL, out_YPos, foundBase);
    HUD.Canvas.__NFUN_465__("Camera Height:" $ string(fCameraHeight));
    HUD.Canvas.__NFUN_465__("Camera Position: " $ string(GetCameraPos()));
    HUD.Canvas.__NFUN_465__("Camera Rotation: " $ string(GetCameraRotation()));
    out_YPos += out_YL;
    //return;    
}

simulated function FindActivityNode()
{
    // End:0x56
    if(FPArms != none)
    {
        ActivityNode = MOHAAnimNodePlayerActivity(FPArms.Animations.FindAnimNode('MOHAAnimNodePlayerActivities'));
        // DebugMode: 0
        assert(ActivityNode != none);
        ActivityNode.SetChildBlendNodeActivities();
    }
    //return;    
}

simulated function InitializeHealthSystem()
{
    // End:0x4C
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x3C
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            HealthManager = new (self) Class'HealthSystem';            
        }
        else
        {
            HealthManager = new (self) Class'MPHealthSystem';
        }
    }
    //return;    
}

simulated function InitDifficultySettings()
{
    local int GameDifficulty;
    local MOHAPlayerController PlayerController;

    PlayerController = MOHAPlayerController(Controller);
    // End:0x1D
    if(PlayerController == none)
    {
        return;
    }
    GameDifficulty = int(PlayerController.GameDifficulty);
    SetDefaultHealth(int(DefaultHealthSettings[GameDifficulty]));
    fImmuneTimeAfterDamage = fImmuneTimeAfterDamageSettings[GameDifficulty];
    fBulletFilteredPct_Crouched = fBulletFilteredPct_Settings[GameDifficulty].X;
    fBulletFilteredPct_Standing = fBulletFilteredPct_Settings[GameDifficulty].Y;
    SetHealth(default.Health);
    iVergeOfDeathHealth = int(fVergeOfDeathHealthPct * float(default.Health));
    // End:0xE2
    if(HealthManager != none)
    {
        HealthManager.InitDifficultySettings(PlayerController.GameDifficulty);
    }
    //return;    
}

simulated function InitSkeletalControls()
{
    // End:0xF5
    if(FPArms != none)
    {
        HipOffsetControl = SkelControlSingleBone(FPArms.FindSkelControl(HipsOffsetControlName));
        HipOffsetControl_Roll = SkelControlSingleBone(FPArms.FindSkelControl(HipsOffsetControlRollName));
        ProceduralLagControl = SkelControlSingleBone(FPArms.FindSkelControl(ProceduralLagControlName));
        // End:0x97
        if(HipOffsetControl != none)
        {
            HipOffsetControl.ControlStrength = 1.0000000;
            HipOffsetControl.SetSkelControlActive(true);
        }
        // End:0xC6
        if(HipOffsetControl_Roll != none)
        {
            HipOffsetControl_Roll.ControlStrength = 1.0000000;
            HipOffsetControl_Roll.SetSkelControlActive(true);
        }
        // End:0xF5
        if(ProceduralLagControl != none)
        {
            ProceduralLagControl.ControlStrength = 1.0000000;
            ProceduralLagControl.SetSkelControlActive(true);
        }
    }
    //return;    
}

simulated function SetViewModelFOV(float fFOV)
{
    // End:0x1F
    if(FPArms != none)
    {
        FPArms.FOV = fFOV;
    }
    //return;    
}

simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
    local EALAWeapon OldEALAWeap;

    OldEALAWeap = EALAWeapon(OldWeapon);
    // End:0xBF
    if(OldEALAWeap != none)
    {
        // End:0x43
        if(FPArms != none)
        {
            FPArms.DetachComponent(OldEALAWeap.Mesh);
        }
        // End:0xAC
        if(OldEALAWeap.WeaponSkeletalMesh != none)
        {
            OldEALAWeap.WeaponSkeletalMesh.SetDepthPriorityGroup(1);
            OldEALAWeap.WeaponSkeletalMesh.ForcedLodModel = 0;
            MOHASkeletalMeshComponent(OldEALAWeap.Mesh).fCustomBoundsSize = 0.0000000;
        }
        OldEALAWeap.UpdateViewmodelFOV();
    }
    AttachNewWeaponMesh(NewWeapon);
    //return;    
}

simulated function AttachNewWeaponMesh(Weapon NewWeapon)
{
    local EALAWeapon NewEALAWeap;

    NewEALAWeap = EALAWeapon(NewWeapon);
    // End:0x14F
    if((NewEALAWeap != none) && NewEALAWeap.Mesh != none)
    {
        // End:0x7B
        if(FPArms != none)
        {
            FPArms.AttachComponentToSocket(NewEALAWeap.Mesh, WeaponAttachmentSocket);
            NewEALAWeap.Mesh.SetShadowParent(FPArms);
        }
        NewEALAWeap.WeaponSkeletalMesh.CastShadow = false;
        NewEALAWeap.WeaponSkeletalMesh.SetDepthPriorityGroup(2);
        NewEALAWeap.WeaponSkeletalMesh.ForcedLodModel = 1;
        NewEALAWeap.UpdateViewmodelFOV();
        NewEALAWeap.Mesh.SetOwnerNoSee(NewEALAWeap.Mesh.default.bOwnerNoSee);
        MOHASkeletalMeshComponent(NewEALAWeap.Mesh).fCustomBoundsSize = 100.0000000;
        // End:0x14F
        if(bHidingWeapons)
        {
            NewEALAWeap.Mesh.SetHidden(true);
        }
    }
    //return;    
}

simulated function WeaponAttachmentChanged()
{
    local SmallArmsAttachment SAattachment;

    super.WeaponAttachmentChanged();
    SAattachment = SmallArmsAttachment(CurrentWeaponAttachment);
    // End:0x34
    if(SAattachment != none)
    {
        SAattachment.UpdateVFXAttachments();
    }
    //return;    
}

simulated function LerpAnimOffsetPos(Vector vOffset, float fPerc)
{
    vCurrentAnimOffset_AS = VLerp(default.vCurrentAnimOffset_AS, vOffset, fPerc);
    vDesiredAnimOffset_AS = vCurrentAnimOffset_AS;
    //return;    
}

simulated function ResetAnimOffsetPos()
{
    vDesiredAnimOffset_AS = default.vDesiredAnimOffset_AS;
    //return;    
}

function bool InCoverRelativeToEnemy(Controller InstigatedBy)
{
    local MOHAAIPawn DamageCauser;

    DamageCauser = MOHAAIPawn(InstigatedBy.Pawn);
    // End:0x43
    if(DamageCauser != none)
    {
        // End:0x43
        if(!FastTrace(DamageCauser.GetPawnViewLocation()))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsBulletFiltered()
{
    // End:0x21
    if(int(eCurrentStance) == int(0))
    {
        // End:0x1E
        if(FRand() < fBulletFilteredPct_Standing)
        {
            return true;
        }        
    }
    else
    {
        // End:0x3F
        if(int(eCurrentStance) == int(1))
        {
            // End:0x3F
            if(FRand() < fBulletFilteredPct_Crouched)
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    super.AdjustDamage(inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
    // End:0x56
    if((DamageType == Class'MOHACompBDamageType') && inDamage > (Health - 1))
    {
        inDamage = Health - 1;
    }
    // End:0x81
    if(fImmuneTime > 0.0000000)
    {
        // End:0x7E
        if(ClassIsChildOf(DamageType, Class'MOHABulletDamageType'))
        {
            inDamage = 0;
            return;
        }        
    }
    else
    {
        fImmuneTime = fImmuneTimeAfterDamage;
    }
    // End:0xD0
    if((MOHAAIController(InstigatedBy) != none) && MOHAAIController(InstigatedBy).TeamIndex == 0)
    {
        // End:0xD0
        if(ClassIsChildOf(DamageType, Class'MOHABulletDamageType'))
        {
            inDamage = 0;
            return;
        }
    }
    // End:0x176
    if(ClassIsChildOf(DamageType, Class'MOHABulletDamageType'))
    {
        // End:0x116
        if((Controller != none) && MOHAPlayerController(Controller).IsCheatActive(1))
        {
            inDamage = 0;
            return;            
        }
        else
        {
            // End:0x132
            if(IsAirdropActive())
            {
                inDamage *= fAirdropDamageScale;                
            }
            else
            {
                // End:0x16A
                if(InCoverRelativeToEnemy(InstigatedBy))
                {
                    // End:0x15B
                    if(IsBulletFiltered())
                    {
                        inDamage = 0;                        
                    }
                    else
                    {
                        inDamage *= fInCoverDamageScale;
                    }                    
                }
                else
                {
                    inDamage *= fExposedDamageScale;
                }
            }
        }
    }
    //return;    
}

function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int LastHealth;

    LastHealth = Health;
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x113
    if(Damage > 0)
    {
        // End:0xF9
        if(Health > 0)
        {
            // End:0xAE
            if((MOHAHUD(PlayerController(Controller).myHUD) != none) && MOHAHUD(PlayerController(Controller).myHUD).DrawDamageHistory > 0)
            {
                AddDamageHistory(InstigatedBy, LastHealth - Health);
            }
            // End:0xE7
            if((HealthManager != none) && LastHealth > Health)
            {
                HealthManager.GotHurt(LastHealth, Health);
            }
            PlaySound(GotHitSnd, true);            
        }
        else
        {
            PlaySound(DeathSnd, true);
            KillDamageType = DamageType;
        }
    }
    //return;    
}

simulated function float AdjustFOVAngle(float fFOVAngle)
{
    return (((!bDisableSprintFX && MOHAPlayerController(Controller).GetSprintFXSetting()) && (IsSprinting()) || fSprintZoomBlendOutTime > 0.0000000) ? fCurrentSprintFOV : fFOVAngle);
    //return ReturnValue;    
}

simulated function float GetSign(float fNum)
{
    return ((fNum >= 0.0000000) ? 1.0000000 : -1.0000000);
    //return ReturnValue;    
}

simulated event HealthUpdated(int iNewHealth)
{
    // End:0x2D
    if(MOHAPlayerController(Controller) != none)
    {
        MOHAPlayerController(Controller).HealthUpdated(iNewHealth);
    }
    // End:0x63
    if(((iNewHealth <= iVergeOfDeathHealth) && iNewHealth > 0) && !bVergeOfDeath)
    {
        StartVergeOfDeath();        
    }
    else
    {
        // End:0x94
        if(((iNewHealth > iVergeOfDeathHealth) || iNewHealth == 0) && bVergeOfDeath)
        {
            EndVergeOfDeath();
        }
    }
    // End:0xAD
    if(iNewHealth >= default.Health)
    {
        OnRecoverFullHealth();
    }
    //return;    
}

simulated function NextFootstep()
{
    // End:0x42
    if(VSize(Velocity) < FootstepSpeedThreshold)
    {
        // End:0x40
        if((int(eCurrentStance) == int(0)) && int(Physics) != int(9))
        {
            PlayFootstep(4);
        }
        return;
    }
    PlayFootstep(ChooseFootstep(), GetFootstepTraceLocation());
    UpdateFootstep();
    //return;    
}

simulated function MOHAPhysicalMaterialProperty.EImpactType ChooseFootstep()
{
    // End:0x13
    if(int(Physics) == int(9))
    {
        return 12;
    }
    // End:0x23
    if(IsSprintEnabled())
    {
        return 3;
    }
    switch(eCurrentStance)
    {
        // End:0x35
        case 0:
            return 2;
            // End:0x54
            break;
        // End:0x40
        case 1:
            return 10;
            // End:0x54
            break;
        // End:0x4B
        case 2:
            return 11;
            // End:0x54
            break;
        // End:0xFFFF
        default:
            return 2;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x054
}

simulated function UpdateFootstep()
{
    // End:0x54
    if(((int(Physics) != int(1)) && int(Physics) != int(9)) || VSize(Velocity) < FootstepSpeedThreshold)
    {
        // End:0x52
        if(int(eCurrentStance) == int(0))
        {
            PlayFootstep(4);
        }
        return;
    }
    // End:0x97
    if(int(Physics) == int(9))
    {
        SetTimer(FClamp(1000.0000000 / (VSize(Velocity) * LadderFootstepFrequency), 0.0000000, MaxLadderFootstepInterval), false, 'NextFootstep');        
    }
    else
    {
        // End:0xBB
        if(IsSprintEnabled())
        {
            SetTimer(FootstepSprintInterval, false, 'NextFootstep');            
        }
        else
        {
            SetTimer(FClamp(1000.0000000 / (VSize(Velocity) * FootstepFrequency), 0.0000000, MaxFootstepInterval), false, 'NextFootstep');
        }
    }
    //return;    
}

simulated function Vector GetFootstepTraceLocation()
{
    // End:0x32
    if(SwitchFoot())
    {
        return Location + Class'MOHAUtilities'.static.RotateVector(LeftFootLocation, Rotation);
    }
    return Location + Class'MOHAUtilities'.static.RotateVector(RightFootLocation, Rotation);
    //return ReturnValue;    
}

simulated function bool SwitchFoot()
{
    bUseLeftFoot = !bUseLeftFoot;
    return bUseLeftFoot;
    //return ReturnValue;    
}

function bool ShouldPlayImpactParticleEffect(MOHAPhysicalMaterialProperty.EImpactType ImpactType)
{
    switch(ImpactType)
    {
        // End:0x0C
        case 2:
        // End:0x11
        case 3:
        // End:0x16
        case 4:
        // End:0x1B
        case 5:
        // End:0x20
        case 6:
        // End:0x25
        case 7:
        // End:0x2A
        case 8:
        // End:0x2F
        case 9:
        // End:0x34
        case 10:
        // End:0x39
        case 11:
        // End:0x3E
        case 12:
        // End:0x45
        case 13:
            return false;
        // End:0xFFFF
        default:
            return super.ShouldPlayImpactParticleEffect(ImpactType);
            break;
    }
    //return ReturnValue;    
}

function bool DoJump(bool bUpdating)
{
    local bool jumpSuccess;

    jumpSuccess = super(Pawn).DoJump(bUpdating);
    // End:0x6B
    if(jumpSuccess)
    {
        Class'Engine.JuiceSubsystem'.static.LevelEvent("Gameplay", "PlayerJumped", "", 0, 0.0000000, "", vect(0.0000000, 0.0000000, 0.0000000));
        PlayFootstep(6);
    }
    return jumpSuccess;
    //return ReturnValue;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    EndProceduralJump();
    super.Landed(HitNormal, FloorActor);
    //return;    
}

function PlayLanded(float ImpactVel)
{
    // End:0x67
    if((((int(eCurrentStance) == int(0)) && int(eDesiredStance) == int(0)) && Abs(ImpactVel) >= (JumpZ * FClamp(fMinFallSpeedForLandedSound, 0.0000000, 1.0000000))) && int(Physics) == int(2))
    {
        PlayFootstep(7);
    }
    super(Pawn).PlayLanded(ImpactVel);
    //return;    
}

simulated function float GetFireAxis()
{
    // End:0x2C
    if((Controller == none) || !Controller.IsA('MOHAPlayerController'))
    {
        return 0.0000000;
    }
    return MOHAPlayerController(Controller).GetFireAxis();
    //return ReturnValue;    
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
    CurrentView = NewRotation;
    // End:0x6E
    if(!InFreeCam())
    {
        // End:0x5F
        if(((int(Physics) == int(1)) || int(Physics) == int(2)) || int(Physics) == int(9))
        {
            NewRotation.Pitch = 0;
        }
        SetQuickRotation(NewRotation);
    }
    //return;    
}

simulated function bool CalcThirdPersonCam(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector CamStart, HitLocation, HitNormal, CamDir;
    local Rotator myView;

    myView = GetViewRotation();
    out_CamRot.Yaw = myView.Yaw;
    out_CamRot.Pitch = myView.Pitch;
    CamStart = Location;
    CamStart.Z += ((1.5000000 * (GetCollisionHeight())) + Mesh.Translation.Z);
    CamDir = (Vector(out_CamRot) * (GetCollisionRadius())) * CurrentCameraScale;
    // End:0xFB
    if(CurrentCameraScale < CameraScale)
    {
        CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + ((float(5) * FMax(CameraScale - CurrentCameraScale, 0.3000000)) * fDeltaTime));        
    }
    else
    {
        // End:0x13E
        if(CurrentCameraScale > CameraScale)
        {
            CurrentCameraScale = FMax(CameraScale, CurrentCameraScale - ((float(5) * FMax(CameraScale - CurrentCameraScale, 0.3000000)) * fDeltaTime));
        }
    }
    // End:0x17F
    if(CamDir.Z > (GetCollisionHeight()))
    {
        CamDir *= Square(Cos(float(out_CamRot.Pitch) * 0.0000959));
    }
    out_CamLoc = CamStart - CamDir;
    // End:0x1C9
    if(Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12.0000000, 12.0000000, 12.0000000)) != none)
    {
        out_CamLoc = HitLocation;
    }
    return true;
    //return ReturnValue;    
}

simulated function AimPress()
{
    bAimButtonDown = true;
    //return;    
}

simulated function AimRelease()
{
    bAimButtonDown = false;
    //return;    
}

simulated function bool AimButtonDown()
{
    return bAimButtonDown;
    //return ReturnValue;    
}

event OnProjectileToss()
{
    // End:0x3C
    if((Weapon != none) && Weapon.IsA('EALAWeapon'))
    {
        EALAWeapon(Weapon).OnProjectileToss();
    }
    //return;    
}

simulated event OnAttachKnife()
{
    // End:0x3C
    if((Weapon != none) && Weapon.IsA('EALAWeapon'))
    {
        EALAWeapon(Weapon).OnAttachKnife();
    }
    //return;    
}

simulated event OnDetachKnife()
{
    // End:0x3C
    if((Weapon != none) && Weapon.IsA('EALAWeapon'))
    {
        EALAWeapon(Weapon).OnDetachKnife();
    }
    //return;    
}

exec function ResetDamageHistory()
{
    LastTakeDamageTime = 0.0000000;
    DamageHistory.Length = 0;
    DPSRecord.Length = 0;
    //return;    
}

exec function CommitDPSRecord()
{
    // End:0x0E
    if(DPSRecord.Length == 0)
    {
        return;
    }
    CommitedDPSRecord[CommitedDPSRecord.Length] = DPSRecord[DPSRecord.Length - 1];
    //return;    
}

exec function SetAIBlocking(bool useAIBlocking)
{
    local MOHAAIPawn aPawn;

    // End:0x4A
    foreach DynamicActors(Class'MOHAAIPawn', aPawn)
    {
        aPawn.SetCollision(aPawn.CollisionComponent.CollideActors, useAIBlocking, aPawn.bIgnoreEncroachers);        
    }    
    //return;    
}

exec function UpdateGunView(float new_fViewmodelFOV, float new_tempOffsetX, float new_tempOffsetY, float new_tempOffsetZ)
{
    // End:0x41
    if(EALAWeapon(Weapon) != none)
    {
        EALAWeapon(Weapon).PlayerFOV = new_fViewmodelFOV;
        EALAWeapon(Weapon).UpdateViewmodelFOV();
    }
    tempOffsetX = int(new_tempOffsetX);
    tempOffsetY = int(new_tempOffsetY);
    tempOffsetZ = int(new_tempOffsetZ);
    //return;    
}

exec function VerboseLogging()
{
    bVerboseLogging = !bVerboseLogging;
    // End:0x4A
    if(EALAWeapon(Weapon) != none)
    {
        EALAWeapon(Weapon).bVerboseLogging = !EALAWeapon(Weapon).bVerboseLogging;
    }
    //return;    
}

exec function HideWeapon(bool bWeaponVisible)
{
    // End:0x50
    if((Weapon != none) && Weapon.Mesh != none)
    {
        bHidingWeapons = !bWeaponVisible;
        Weapon.Mesh.SetHidden(!bWeaponVisible);
    }
    //return;    
}

exec function ToggleTrueTriggerMeter()
{
    // End:0x4A
    if(EALASmallArms(Weapon) != none)
    {
        // End:0x4A
        if(EALASmallArms(Weapon).ScopeComponent != none)
        {
            EALASmallArms(Weapon).ScopeComponent.ToggleTrueTriggerMeter();
        }
    }
    //return;    
}

exec function ToggleHoldBreath()
{
    // End:0x4A
    if(EALASmallArms(Weapon) != none)
    {
        // End:0x4A
        if(EALASmallArms(Weapon).TrueTriggerComponent != none)
        {
            EALASmallArms(Weapon).TrueTriggerComponent.ToggleHoldBreath();
        }
    }
    //return;    
}

simulated function OwnerChangeVisibleMesh(bool bFirstPerson)
{
    // End:0x75
    if(bNetOwner)
    {
        Mesh.SetOwnerNoSee(bFirstPerson);
        // End:0x49
        if(Weapon != none)
        {
            Weapon.Mesh.SetOwnerNoSee(!bFirstPerson);
        }
        FPArms.SetOnlyOwnerSee(bFirstPerson);
        FPArms.SetOwnerNoSee(!bFirstPerson);
    }
    //return;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    super(Pawn).FellOutOfWorld(dmgType);
    Class'Engine.JuiceSubsystem'.static.LevelEvent("Gameplay", "FellOutOfWorld", "", 0, WorldInfo.KillZ, "", Location);
    //return;    
}

exec function SetDefaultBlendTime(float fBlendTime)
{
    fDefaultActivityBlendTime = fBlendTime;
    //return;    
}

simulated function SetActivity(MOHAPlayerPawn.EPlayerActivity NextActivity)
{
    SendKismetActivitySetEvent(CurrentActivity, NextActivity);
    fActivityBlendTime = GetActivityBlendTime(NextActivity);
    CurrentActivity = NextActivity;
    SendActivitySetNotifications();
    //return;    
}

simulated function SendActivitySetNotifications()
{
    // End:0x28
    if(FPArms != none)
    {
        FPArms.fActivitySetTime = WorldInfo.RealTimeSeconds;
    }
    //return;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    GotoState('Death_In');
    bReplicateMovement = false;
    bTearOff = true;
    Velocity += (TearOffMomentum * 2.5000000);
    SetPhysics(2);
    bPlayedDeath = true;
    //return;    
}

simulated function CreateParachute(bool SkipITP)
{
    // End:0x1F
    if(AirdropParachuteMesh == none)
    {
        AirdropParachuteMesh = __NFUN_278__(Class'MOHAParachuteActor');
    }
    // End:0x89
    if(AirdropParachuteMesh != none)
    {
        AirdropParachuteMesh.GotoState('UnInitializedState');
        AirdropParachuteMesh.Initialize(self, SkipITP);
        AirdropParachuteMesh.ShowParachute(true);
        AirdropParachuteMesh.PlayerParachuteMesh.SetDepthPriorityGroup(2);
    }
    //return;    
}

event OnSpawnParachuteAndAttach(SequenceAction Other)
{
    // End:0x24
    if(!IsAirdropActive())
    {
        CreateParachute(true);
        AirDrop_DeployChuteEvent();
    }
    //return;    
}

function bool IsAirdropActive()
{
    return (int(CurrentActivity) >= int(35)) && int(CurrentActivity) <= int(43);
    //return ReturnValue;    
}

function bool IsITPActive()
{
    return false;
    //return ReturnValue;    
}

function bool IgnoreWeaponEvents()
{
    return (IsAirdropActive()) || IsITPActive();
    //return ReturnValue;    
}

simulated function StopWindVolumeSound()
{
    Airdrop_WindVolumeLoop.FadeOut(0.5000000, 0.0000000);
    //return;    
}

simulated event UpdateWindVolumeSound(float NewVolume)
{
    Airdrop_WindVolumeLoop.VolumeMultiplier = NewVolume;
    //return;    
}

function OnToggleLetterbox(SeqAct_ToggleLetterbox Action)
{
    // End:0x49
    if(MOHAHUD(PlayerController(Controller).myHUD) != none)
    {
        MOHAHUD(PlayerController(Controller).myHUD).ModifyLetterBox(Action);
    }
    //return;    
}

function OnBeginPlayerITP(SeqAct_BeginPlayerITP Action)
{
    local Rotator NewRot;
    local Vector NewLoc;

    // End:0x28
    if(MOHAPlayerController(Controller) != none)
    {
        MOHAPlayerController(Controller).ForceExitIronSights();
    }
    // End:0xD4
    if(int(eCurrentStanceChange) != int(0))
    {
        bAnimatedStanceChange = false;
        eCurrentStanceChange = 0;
        vCurrentStanceHeightMod.X = 0.0000000;
        vCurrentStanceHeightMod.Y = 0.0000000;
        vCurrentStanceHeightMod.Z = GetStanceHeight(0);
        // End:0xB1
        if(IsTimerActive('StanceChangeTimerDone'))
        {
            ClearTimer('StanceChangeTimerDone');
        }
        // End:0xD4
        if(IsTimerActive('EndStanceChangeInTimer'))
        {
            ClearTimer('EndStanceChangeInTimer');
        }
    }
    PlaybackLength = 0.0000000;
    CurrentActivity = 0;
    ForceStanding();
    // End:0x317
    if(Action.playerPlane != none)
    {
        // End:0x14C
        if((Action.fViewPitchMin >= Action.fViewPitchMax) || Action.fViewYawMin >= Action.fViewYawMax)
        {            
        }
        else
        {
            fITPViewPitchMin = Action.fViewPitchMin * (32768.0000000 / 180.0000000);
            fITPViewPitchMax = Action.fViewPitchMax * (32768.0000000 / 180.0000000);
            fITPViewYawMin = Action.fViewYawMin * (32768.0000000 / 180.0000000);
            fITPViewYawMax = Action.fViewYawMax * (32768.0000000 / 180.0000000);
        }
        ViewModelITPAnimset = Action.LevelSpecificAnimset;
        ViewModelITPAnimTree = Action.LevelSpecificAnimtree;
        fDebugSkipWorldTimeVal = Action.fDebugSkipWorldTimeVal;
        // End:0x21B
        if(ViewModelITPAnimset == none)
        {
        }
        // End:0x226
        if(ViewModelITPAnimTree == none)
        {
        }
        fPlayerPushInterval = Action.fTimeBetweenPushes;
        nMaxPushes = Action.numPushesUntilForceJump;
        Action.playerPlane.PlayerController = MOHAPlayerController(self.Controller);
        playerPlane = Action.playerPlane;
        SetPhysics(7);
        playerPlane.SkeletalMeshComponent.GetSocketWorldLocationAndRotation(playerPlane.referenceSocketName, NewLoc, NewRot);
        SetBase(playerPlane, vect(0.0000000, 0.0000000, 1.0000000), playerPlane.SkeletalMeshComponent, playerPlane.referenceSocketName);
        SetHardAttach(true);
        SetRelativeLocation(vect(0.0000000, 0.0000000, 0.0000000));
        GotoState('ITPInThePlane');
    }
    //return;    
}

function OnBeginPlayerBRF(SeqAct_BeginPlayerBRF Action)
{
    ViewModelITPAnimset = Action.LevelSpecificAnimset;
    ViewModelITPAnimTree = Action.LevelSpecificAnimtree;
    // End:0x33
    if(ViewModelITPAnimset == none)
    {
    }
    // End:0x3E
    if(ViewModelITPAnimTree == none)
    {
    }
    CurrentBRFActivity = 0;
    // End:0x120
    if(Action != none)
    {
        // End:0x98
        if((Action.fViewPitchMin >= Action.fViewPitchMax) || Action.fViewYawMin >= Action.fViewYawMax)
        {            
        }
        else
        {
            fBriefingViewPitchMin = Action.fViewPitchMin * (32768.0000000 / 180.0000000);
            fBriefingViewPitchMax = Action.fViewPitchMax * (32768.0000000 / 180.0000000);
            fBriefingViewYawMin = Action.fViewYawMin * (32768.0000000 / 180.0000000);
            fBriefingViewYawMax = Action.fViewYawMax * (32768.0000000 / 180.0000000);
        }
    }
    GotoState('BRFInTheBriefing');
    MOHAPlayerController(Controller).GotoState('BRFInTheBriefing');
    //return;    
}

function OnFinishPlayerBRF(SeqAct_FinishPlayerBRF Action)
{
    // End:0x13
    if(GetStateName() != 'BRFInTheBriefing')
    {
        return;
    }
    CurrentBRFActivity = 1;
    //return;    
}

simulated function OpenParachuteAnim()
{
    local editinline MOHASkeletalMeshComponent CurMesh;

    // End:0x1E
    if(Mesh != none)
    {
        Mesh.StopAnim();
    }
    SetCollision(true, true, false);
    bCollideWorld = true;
    OnSpawnParachuteAndAttach(none);
    CurMesh = FPArms;
    // End:0x8B
    if((CurMesh != none) && !CurMesh.bOwnerNoSee)
    {
        CurMesh.PlayAnimAtRate('chute_arms_pullleft_idle', 1.0000000, 0.0000000, true, true);
    }
    AirDrop_DecendEvent();
    //return;    
}

function PlayAnimation()
{
    local editinline MOHASkeletalMeshComponent CurMesh;

    CurMesh = FPArms;
    // End:0x98
    if(CurMesh != none)
    {
        // End:0x60
        if((PushBlend != none) && PushBlendByBone != none)
        {
            PushBlend.SetBlendTarget(0.0000000, 0.0000000);
            PushBlendByBone.SetBlendTarget(0.0000000, 0.0000000);
        }
        // End:0x98
        if(!CurMesh.bOwnerNoSee)
        {
            CurMesh.PlayAnimAtRate(AnimName, fAnimRate, fCurrentAnimTime, false, false);
        }
    }
    //return;    
}

simulated exec function RenderBody(bool bShow)
{
    // End:0x70
    if(FPArms != none)
    {
        // End:0x4C
        if(!bShow)
        {
            BodyMatInst = FPArms.GetMaterial(1);
            FPArms.SetMaterial(1, MaterialInstanceConstant'ViewModel_Mesh.NoRenderMatInst');            
        }
        else
        {
            // End:0x70
            if(BodyMatInst != none)
            {
                FPArms.SetMaterial(1, BodyMatInst);
            }
        }
    }
    //return;    
}

function bool GetDemoChargePosAndRot(out Vector vDemoChargePos, out Rotator rDemoChargeRot)
{
    // End:0x33
    if(MOHAPlayerController(Controller) != none)
    {
        return MOHAPlayerController(Controller).GetDemoChargePosAndRot(vDemoChargePos, rDemoChargeRot);
    }
    return false;
    //return ReturnValue;    
}

simulated function OnMissionComplete(SeqAct_MissionComplete Action)
{
    MOHAPlayerController(Controller).OnMissionComplete(Action);
    //return;    
}

simulated function OnSkillDropLanding(SeqAct_SkillDropLanding Action)
{
    MOHAPlayerController(Controller).OnSkillDropLanding(Action);
    //return;    
}

simulated function OnSkillDropDiscovered(SeqAct_SkillDropDiscovered Action)
{
    MOHAHUD(PlayerController(Controller).myHUD).hud_messageQueue.SkillDropDiscovered(Action.Message);
    //return;    
}

event ActivityDoneEvent()
{
    GotoState('Idle');
    //return;    
}

event Weapon_FireEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('Fire');
    }
    //return;    
}

event Weapon_ReloadEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('Reload');
    }
    //return;    
}

event Weapon_ReloadInEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('Reload_In');
    }
    //return;    
}

event Weapon_ReloadOutEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('Reload_Out');
    }
    //return;    
}

event Weapon_RechamberEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('Rechamber');
    }
    //return;    
}

event Weapon_MeleeEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('Melee');
    }
    //return;    
}

event Weapon_PrimeEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('Prime');
    }
    //return;    
}

event Weapon_PrimeIdleEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('PrimeIdle');
    }
    //return;    
}

event Weapon_PrimeCookEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('PrimeCook');
    }
    //return;    
}

event Weapon_ReadyCookEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('ReadyCook');
    }
    //return;    
}

event Weapon_ThrowEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('Throw');
    }
    //return;    
}

event Weapon_TossEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('Toss');
    }
    //return;    
}

event Weapon_LowerWeaponEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('LowerWeapon');
    }
    //return;    
}

event Weapon_RaiseWeaponEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('RaiseWeapon');
    }
    //return;    
}

event Weapon_IronsightsInEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('IronsightsIn');
    }
    //return;    
}

event Weapon_IronsightsOutEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('IronsightsOut');
    }
    //return;    
}

event Weapon_IronsightsIdleEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('IronsightsIdle');
    }
    //return;    
}

event Weapon_IronsightsFireEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('IronsightsFire');
    }
    //return;    
}

event Weapon_EnterAlternateFireEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('EnterAlternateFire');
    }
    //return;    
}

event Weapon_LeaveAlternateFireEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('LeaveAlternateFire');
    }
    //return;    
}

event Weapon_ScopeModeInEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('ScopeModeIn');
    }
    //return;    
}

event Weapon_ScopeModeOutEvent()
{
    // End:0x1D
    if(!IgnoreWeaponEvents())
    {
        GotoState('ScopeModeOut');
    }
    //return;    
}

simulated function ForceStanding()
{
    eDesiredStance = 0;
    bSnapToNewStanceHeight = true;
    ChangeStance();
    bSnapToNewStanceHeight = false;
    //return;    
}

simulated function PlayStanceChangeSound()
{
    PlaySound(StanceChangeSounds[int(GetStanceChangeType(eCurrentStance, eDesiredStance))]);
    //return;    
}

simulated event Player_StanceChangeEvent()
{
    // End:0x2B
    if(bSnapToNewStanceHeight)
    {
        SetCurrentStance(eDesiredStance);
        vCurrentStanceHeightMod = GetDesiredStanceHeightMod();        
    }
    else
    {
        // End:0x79
        if(((IsIdle()) && !IsSprintEnabled()) && VSize(vCurrentStanceHeightMod - (GetDesiredStanceHeightMod())) < 5.0000000)
        {
            GotoState('StanceChangeIn');            
        }
        else
        {
            PlayStanceChangeSound();
            SetCurrentStance(eDesiredStance);
            UpdateSkelControls();
        }
    }
    //return;    
}

event Player_JumpEvent()
{
    local Vector vInitialVelocity;

    vInitialVelocity = Velocity;
    // End:0x63
    if(DoJump(true))
    {
        // End:0x59
        if((IsIdle()) && VSize(vInitialVelocity) > ((GroundSpeed * (GetWeaponSpeedMultiplier())) * fAnimatedJumpThreshold))
        {
            StartAnimatedJump();            
        }
        else
        {
            StartProceduralJump();
        }
    }
    //return;    
}

function StartProceduralJump()
{
    bProceduralJump = true;
    bForceIdleAnim = true;
    //return;    
}

function EndProceduralJump()
{
    bProceduralJump = false;
    bForceIdleAnim = false;
    //return;    
}

function StartAnimatedJump()
{
    GotoState('JumpStart');
    //return;    
}

simulated function bool CanGrabLadder()
{
    return ((bCanClimbLadders && Controller != none) && int(Physics) == int(1)) && IsIdle();
    //return ReturnValue;    
}

function ClimbLadder(LadderVolume L)
{
    OnLadder = L;
    GotoState('LadderClimb');
    //return;    
}

event AirDrop_DeployChuteEvent()
{
    GotoState('AirDropDeployChute');
    //return;    
}

event AirDrop_DecendEvent()
{
    GotoState('AirDropControlledFall');
    //return;    
}

event AirDrop_ChuteFlareEvent()
{
    GotoState('AirDropControlledFlare');
    //return;    
}

event AirDrop_LandingEvent()
{
    GotoState('AirDropLanding');
    //return;    
}

simulated function ITPCamDebug(out Vector out_CamLoc, out Rotator out_CamRot, Rotator desiredRot)
{
    local Vector debugLoc, vecx, vecy, vecz, toPlayer;

    local Rotator debugRot;

    // End:0x135
    if(bITPDebugCam == true)
    {
        FPArms.GetSocketWorldLocationAndRotation(CameraSocketNameITP, debugLoc, debugRot);
        out_CamLoc = debugLoc + (backVec * 300.0000000);
        GetAxes(debugRot, vecx, vecy, vecz);
        toPlayer = debugLoc - out_CamLoc;
        out_CamRot = Rotator(toPlayer);
        DrawDebugLine(debugLoc, debugLoc + (vecx * 300.0000000), byte(255), 0, 0, false);
        DrawDebugLine(debugLoc, debugLoc + (vecy * 300.0000000), 0, byte(255), 0, false);
        DrawDebugLine(debugLoc, debugLoc + (vecz * 300.0000000), 0, 0, byte(255), false);
        DrawDebugLine(debugLoc, debugLoc + (Vector(desiredRot) * 400.0000000), 0, byte(255), byte(255), false);
        DrawDebugLine(Location, debugLoc, byte(255), byte(255), byte(255), false);
    }
    //return;    
}

exec function ITPDebugCam()
{
    bITPDebugCam = !bITPDebugCam;
    //return;    
}

event ITP_JumpVoluntaryEvent()
{
    GotoState('ITPJumpVoluntary');
    //return;    
}

event ITP_JumpInvoluntaryEvent()
{
    GotoState('ITPJumpInvoluntary');
    //return;    
}

event PlayerExitsPlane()
{
    local array<SequenceObject> AllSeqEvents;
    local Sequence GameSeq;
    local int I;
    local SeqEvent_PlayerExitsPlane PEPEvent;
    local array<int> PlayerEventImpulse;

    PlayerEventImpulse.Insert(0, 2);
    PlayerEventImpulse[0] = 0;
    GameSeq = WorldInfo.GetGameSequence();
    // End:0xBA
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_PlayerExitsPlane', true, AllSeqEvents);
        I = 0;
        J0x53:

        // End:0xBA [Loop If]
        if(I < AllSeqEvents.Length)
        {
            PEPEvent = SeqEvent_PlayerExitsPlane(AllSeqEvents[I]);
            // End:0x8E
            if(bInvoluntaryJump)
            {
                PlayerEventImpulse[1] = 1;                
            }
            else
            {
                PlayerEventImpulse[1] = 2;
            }
            PEPEvent.CheckActivate(self, self, false, PlayerEventImpulse);
            I++;
            // [Loop Continue]
            goto J0x53;
        }
    }
    fLastCachedRotCachedTime = WorldInfo.TimeSeconds;
    GotoState('ITPFalling');
    //return;    
}

event AirDrop_ParachuteHungUpEvent()
{
    GotoState('AirDropHanging');
    //return;    
}

event AirDrop_CutChuteEvent()
{
    GotoState('AirDropCutChute');
    //return;    
}

event Player_PlaceDemoCharge()
{
    GotoState('DemoChargeIdle');
    //return;    
}

event Weapon_LowerPrimedDemoCharge()
{
    GotoState('LowerPrimedDemoCharge');
    //return;    
}

event Player_UseRelease()
{
    //return;    
}

event AirDrop_MeleeEvent()
{
    //return;    
}

simulated function Quat AirdropLimitedView(float fLeftRight, float fUpDown)
{
    local Vector vLocation;
    local name socket_name;
    local Quat Cam, left_right, up_down;
    local Rotator Temp;

    // End:0x45
    if((FPArms == none) || !FPArms.GetSocketWorldLocationAndRotation('CamAirdrop', vLocation, Temp))
    {
        return QuatFromRotator(global.GetViewRotation());
    }
    Cam = QuatFromRotator(Temp);
    socket_name = ((fLeftRight > float(0)) ? 'AirdropLimitRight' : 'AirdropLimitLeft');
    // End:0xB1
    if(!FPArms.GetSocketWorldLocationAndRotation(socket_name, vLocation, Temp))
    {
        return QuatFromRotator(global.GetViewRotation());
    }
    left_right = QuatSlerp(Cam, QuatFromRotator(Temp), Abs(fLeftRight), true) - Cam;
    socket_name = ((fUpDown < float(0)) ? 'AirdropLimitUp' : 'AirdropLimitDown');
    // End:0x138
    if(!FPArms.GetSocketWorldLocationAndRotation(socket_name, vLocation, Temp))
    {
        return QuatFromRotator(global.GetViewRotation());
    }
    up_down = QuatSlerp(Cam, QuatFromRotator(Temp), Abs(fUpDown), true) - Cam;
    return (Cam + up_down) + left_right;
    //return ReturnValue;    
}

simulated function UpdateAirdropViewRotation()
{
    local Quat Temp;

    AirdropViewCache = AirdropLimitedView(AirdropLookLeftRightAmount, AirdropLookUpDownAmount);
    // End:0x6A
    if(DoLookCompensation)
    {
        Temp = AirdropLimitedView(AirdropLookLeftRightPrev, AirdropLookUpDownAmount);
        AirdropYawLookCompensation += (Normalize(QuatToRotator(Temp)) - Normalize(QuatToRotator(AirdropViewCache)));
    }
    //return;    
}

function Rotator GetAirdropViewCompensation()
{
    local Rotator Comp;

    Comp = AirdropYawLookCompensation;
    AirdropYawLookCompensation -= Comp;
    return Comp;
    //return ReturnValue;    
}

reliable client simulated function ClientAirDropLandingEffects()
{
    Airdrop_BG_Loop.Stop();
    EnableRadialBlur(false);
    PlaybackLength = 0.0000000;
    //return;    
}

function ReportLandingType(MOHAPlayerPawn.EAirDropLandingType landingType)
{
    //return;    
}

simulated function StartShellShock(float fEffectTime)
{
    // End:0x6B
    if((fEffectTime > 0.0000000) && !IsTimerActive('EndShellShock'))
    {
        bInShellShock = true;
        ShellShockMixSelect.ActiveAsMixFader();
        ShellShockSound.Play();
        ActivateShellShockSequence(0);
        SetTimer(fEffectTime, false, 'EndShellShock');
    }
    //return;    
}

simulated function EndShellShock()
{
    bInShellShock = false;
    ShellShockMixSelect.DeActivate();
    ActivateShellShockSequence(1);
    ClearTimer('EndShellShock');
    //return;    
}

simulated function StartVergeOfDeath()
{
    bVergeOfDeath = true;
    //return;    
}

simulated function EndVergeOfDeath()
{
    bVergeOfDeath = false;
    bVergeOfDeathSave = true;
    //return;    
}

simulated function bool IsInVergeOfDeath()
{
    return bVergeOfDeath;
    //return ReturnValue;    
}

simulated function OnRecoverFullHealth()
{
    local MOHAPlayerController PlayerController;

    // End:0x5F
    if(bVergeOfDeathSave)
    {
        bVergeOfDeathSave = false;
        PlayerController = MOHAPlayerController(Controller);
        // End:0x5F
        if(PlayerController != none)
        {
            PlayerController.playerStats.GiveXboxLiveAchievement("ACH_SP_Recover_Health");
        }
    }
    //return;    
}

simulated function ActivateShellShockSequence(int iActiveIndex)
{
    local array<SequenceObject> AllShellShockEvents;
    local SeqEvent_ShellShock ShellShockEvent;
    local array<int> actived_indices;
    local Sequence GameSeq;
    local int idx;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0x96
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_ShellShock', true, AllShellShockEvents);
        actived_indices[0] = iActiveIndex;
        idx = 0;
        J0x4E:

        // End:0x96 [Loop If]
        if(idx < AllShellShockEvents.Length)
        {
            ShellShockEvent = SeqEvent_ShellShock(AllShellShockEvents[idx]);
            ShellShockEvent.CheckActivate(self, self, false, actived_indices);
            idx++;
            // [Loop Continue]
            goto J0x4E;
        }
    }
    //return;    
}

function TakeFallingDamage()
{
    local float fFallDamage, fPerc, fDistance, fEffectiveGravity, fNumStories;

    fEffectiveGravity = Abs(2.0000000 * WorldInfo.DefaultGravityZ);
    fDistance = (Velocity.Z * Velocity.Z) / (float(2) * fEffectiveGravity);
    fNumStories = fDistance / fSingleStoryDistance;
    // End:0x138
    if(fNumStories > fNoDamageNumStories)
    {
        // End:0x129
        if(int(Role) == int(ROLE_Authority))
        {
            fPerc = FClamp((fNumStories - fNoDamageNumStories) / fFullDamageNumStories, 0.0000000, 1.0000000);
            fFallDamage = float(default.Health) * fPerc;
            // End:0xFE
            if(int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                // End:0xFE
                if(fNumStories < fFullDamageNumStories)
                {
                    fFallDamage = FClamp(fFallDamage, 0.0000000, float(Health - 1));
                }
            }
            TakeDamage(int(fFallDamage), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
        }
        PlaySound(FallDamageSoundCue);
    }
    //return;    
}

function ShakeView(ViewShakeInfo NewViewShake)
{
    // End:0xC4
    if(VSize(NewViewShake.RotMag) > VSize(CurrentViewShake.RotMag))
    {
        CurrentViewShake.RotMag = NewViewShake.RotMag;
        CurrentViewShake.RotRate = NewViewShake.RotRate;
        CurrentViewShake.RotTime = NewViewShake.RotTime;
        CurrentViewShake.bDecayRotOverTime = NewViewShake.bDecayRotOverTime;
        CurrentViewShake.RotStartTime = NewViewShake.RotTime;
    }
    // End:0x188
    if(VSize(NewViewShake.OffsetMag) > VSize(CurrentViewShake.OffsetMag))
    {
        CurrentViewShake.OffsetMag = NewViewShake.OffsetMag;
        CurrentViewShake.OffsetRate = NewViewShake.OffsetRate;
        CurrentViewShake.OffsetTime = NewViewShake.OffsetTime;
        CurrentViewShake.bDecayOffsetOverTime = NewViewShake.bDecayOffsetOverTime;
        CurrentViewShake.OffsetStartTime = NewViewShake.OffsetTime;
    }
    //return;    
}

event PlayNonRealtimeAudio(SoundCue Cue)
{
    NonRealtimeAudio.Stop();
    NonRealtimeAudio.SoundCue = Cue;
    NonRealtimeAudio.Play();
    //return;    
}

function float GetHealthRatio()
{
    return ((default.Health != 0) ? float(Health) / float(default.Health) : 0.0000000);
    //return ReturnValue;    
}

simulated function float GetVergeOfDeathHealthRatio()
{
    return ((default.Health != 0) ? float(iVergeOfDeathHealth) / float(default.Health) : 0.0000000);
    //return ReturnValue;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super(Pawn).PossessedBy(C, bVehicleTransition);
    // End:0x51
    if(PlayerController(C).myHUD != none)
    {
        MOHAHUD(PlayerController(C).myHUD).AddPostRenderedActor(self);
    }
    InitDifficultySettings();
    //return;    
}

function OnDialogueAudioMix(SeqAct_DialogueAudioMix Action)
{
    // End:0x30
    if(Action.InputLinks[0].bHasImpulse)
    {
        DialogueDuckMix.Activate();        
    }
    else
    {
        // End:0x5D
        if(Action.InputLinks[1].bHasImpulse)
        {
            DialogueDuckMix.DeActivate();
        }
    }
    //return;    
}

simulated function bool IsUpgradeSequenceActive()
{
    // End:0x22
    if(WeaponUpgradeManager != none)
    {
        return WeaponUpgradeManager.IsUpgradeSequenceActive();        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function ConsumeAmmo(EALAWeapon Weap, byte FireModeNum)
{
    // End:0x35
    if((WeaponUpgradeManager == none) || !WeaponUpgradeManager.IsUpgradeSequenceActive())
    {
        super.ConsumeAmmo(Weap, FireModeNum);
    }
    //return;    
}

event RestoreExperience(array<WeaponExperienceInfo> WeapExpList)
{
    local int I;
    local MOHAPlayerController mpc;
    local editinline MOHAWeaponExperienceComponent MWEC;

    mpc = MOHAPlayerController(Controller);
    mpc.playerStats.ResetExperienceComponents();
    bRestoringExperience = true;
    I = 0;
    J0x3B:

    // End:0xC2 [Loop If]
    if(I < WeapExpList.Length)
    {
        MWEC = mpc.playerStats.GetWeaponExpComponent(WeapExpList[I].WeaponClass);
        // End:0xB8
        if(MWEC != none)
        {
            MWEC.RestoreExperience(WeapExpList[I].ExperiencePoints);
            // [Explicit Continue]
        }
        I++;
        // [Loop Continue]
        goto J0x3B;
    }
    bRestoringExperience = false;
    //return;    
}

event array<WeaponExperienceInfo> GetExperienceInfo()
{
    local WeaponExperienceInfo Info;
    local array<WeaponExperienceInfo> WeaponExperience;
    local int I;
    local MOHAPlayerController mpc;
    local editinline MOHAWeaponExperienceComponent MWEC;

    mpc = MOHAPlayerController(Controller);
    I = 0;
    J0x17:

    // End:0xB5 [Loop If]
    if(I < mpc.playerStats.ExperienceComponents.Length)
    {
        MWEC = mpc.playerStats.ExperienceComponents[I];
        Info.WeaponClass = MWEC.WeaponClass;
        Info.ExperiencePoints = int(MWEC.ExperiencePoints);
        WeaponExperience[I] = Info;
        I++;
        // [Loop Continue]
        goto J0x17;
    }
    return WeaponExperience;
    //return ReturnValue;    
}

function float GetCurrentITPAnimPosition()
{
    local AnimNodeSequence animNodeSeq;
    local float retval, animlength;

    // End:0x17
    if(GetStateName() != 'ITPInThePlane')
    {
        return 0.0000000;
    }
    retval = 0.0000000;
    animNodeSeq = AnimNodeSequence(FPArms.Animations.FindAnimNode('playerAnim'));
    // End:0xE6
    if(((animNodeSeq != none) && animNodeSeq.AnimSeq != none) && animNodeSeq.AnimSeq.RateScale != float(0))
    {
        animlength = animNodeSeq.AnimSeq.SequenceLength / animNodeSeq.AnimSeq.RateScale;
        retval = animNodeSeq.GetNormalizedPosition() * animlength;
    }
    return retval;
    //return ReturnValue;    
}

function float GetCurrentITPAnimLength()
{
    local AnimNodeSequence animNodeSeq;
    local float retval;

    // End:0x17
    if(GetStateName() != 'ITPInThePlane')
    {
        return 0.0000000;
    }
    retval = 0.0000000;
    animNodeSeq = AnimNodeSequence(FPArms.Animations.FindAnimNode('playerAnim'));
    // End:0xC6
    if(((animNodeSeq != none) && animNodeSeq.AnimSeq != none) && animNodeSeq.AnimSeq.RateScale != float(0))
    {
        retval = animNodeSeq.AnimSeq.SequenceLength / animNodeSeq.AnimSeq.RateScale;
    }
    return retval;
    //return ReturnValue;    
}

function AddDefaultInventory()
{
    local int I;
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAGameResource GameDataStore;
    local bool bUseDataStore, bIsWeapon, bIsExplosive;
    local class<Inventory> NewWeaponClass;

    bUseDataStore = false;
    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x73
    if(DataStoreManager != none)
    {
        GameDataStore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
        bUseDataStore = (GameDataStore != none) && GameDataStore.HasValidWeapons();
    }
    // End:0xFD
    if(bUseDataStore)
    {
        I = 0;
        J0x83:

        // End:0xFD [Loop If]
        if(I < GameDataStore.GetWeaponSlotCount())
        {
            NewWeaponClass = GameDataStore.GetWeaponClass(I);
            // End:0xF3
            if(ClassIsChildOf(NewWeaponClass, Class'EALAWeapon'))
            {
                // End:0xF3
                if(FindInventoryType(NewWeaponClass) == none)
                {
                    CreateInventory(NewWeaponClass, I > 0);
                }
            }
            I++;
            // [Loop Continue]
            goto J0x83;
        }
    }
    I = 0;
    J0x104:

    // End:0x1CB [Loop If]
    if(I < WorldInfo.WeaponLoadout.Length)
    {
        NewWeaponClass = WorldInfo.WeaponLoadout[I].WeaponClass;
        bIsWeapon = ClassIsChildOf(NewWeaponClass, Class'EALAWeapon');
        bIsExplosive = ClassIsChildOf(NewWeaponClass, Class'EALAGrenade') || ClassIsChildOf(NewWeaponClass, Class'EALADemoCharge');
        // End:0x1C1
        if(bIsExplosive || bIsWeapon && !bUseDataStore)
        {
            // End:0x1C1
            if(FindInventoryType(NewWeaponClass) == none)
            {
                CreateInventory(NewWeaponClass, I > 0);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x104;
    }
    AddReserveAmmo();
    MOHAInventoryManager(InvManager).SetupWeaponPointers();
    MOHAPlayerController(Controller).SetCurrentExperience(EALAWeapon(Weapon));
    // End:0x260
    if(WorldInfo.MapName != "Shell")
    {
        MOHAInventoryManager(InvManager).CopyInventoryToWorldInfoLoadout();
        WorldInfo.WeaponIncludeClass = none;
        WorldInfo.ForceGarbageCollection();
    }
    //return;    
}

event RestoreInventory(array< class<EALAWeapon> > Loadout, class<EALAWeapon> StartingWeaponClass)
{
    local int I, WeaponSlotIndex;
    local MOHAInventoryManager MOHAInvManager;
    local Weapon StartWeapon, NewWeapon;
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAGameResource GameDataStore;
    local bool bPopulateDataStore, bIsExplosive;

    bPopulateDataStore = false;
    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0xA6
    if(DataStoreManager != none)
    {
        GameDataStore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
        // End:0xA6
        if(GameDataStore != none)
        {
            // End:0xA6
            if(((GameDataStore.WeaponSlots[0] == 0) && GameDataStore.WeaponSlots[1] == 0) && GameDataStore.WeaponSlots[2] == 0)
            {
                bPopulateDataStore = true;
            }
        }
    }
    MOHAInvManager = MOHAInventoryManager(InvManager);
    MOHAInvManager.DiscardInventory();
    StartWeapon = none;
    WeaponSlotIndex = 0;
    I = 0;
    J0xDE:

    // End:0x1D4 [Loop If]
    if(I < Loadout.Length)
    {
        NewWeapon = Weapon(CreateInventory(Loadout[I]));
        // End:0x19D
        if(bPopulateDataStore && WeaponSlotIndex < 3)
        {
            bIsExplosive = ClassIsChildOf(Loadout[I], Class'EALAGrenade') || ClassIsChildOf(Loadout[I], Class'EALADemoCharge');
            // End:0x19D
            if((NewWeapon != none) && !bIsExplosive)
            {
                GameDataStore.WeaponSlots[WeaponSlotIndex] = int(EALAWeapon(NewWeapon).WeaponType);
                WeaponSlotIndex++;
            }
        }
        // End:0x1CA
        if((NewWeapon != none) && Loadout[I] == StartingWeaponClass)
        {
            StartWeapon = NewWeapon;
        }
        I++;
        // [Loop Continue]
        goto J0xDE;
    }
    MOHAInvManager.SetupWeaponPointers();
    // End:0x20B
    if(StartWeapon != none)
    {
        MOHAInvManager.SetCurrentWeapon(StartWeapon);
    }
    MOHAPlayerController(Controller).SetCurrentExperience(EALAWeapon(Weapon));
    //return;    
}

event RestoreReserveAmmo(array<ReserveAmmo> AmmoStorage)
{
    local MOHAInventoryManager MOHAInvManager;

    MOHAInvManager = MOHAInventoryManager(InvManager);
    MOHAInvManager.RestoreReserveAmmo(AmmoStorage);
    //return;    
}

function AddReserveAmmo()
{
    local int I;
    local MOHAInventoryManager MOHAInvManager;
    local class<EALAAmmoInventoryClass> AmmoClass;
    local bool bUseDefaultLoadout;

    MOHAInvManager = MOHAInventoryManager(InvManager);
    bUseDefaultLoadout = (WorldInfo.AmmoLoadout.Length == 0) || !WorldInfo.bAmmoLoadoutAbsolute;
    // End:0x104
    if(bUseDefaultLoadout)
    {
        I = 0;
        J0x4F:

        // End:0x104 [Loop If]
        if(I < DefaultAmmoLoadout.Length)
        {
            // End:0xFA
            if(ClassIsChildOf(DefaultAmmoLoadout[I].AmmoClass, Class'EALAAmmoInventoryClass'))
            {
                AmmoClass = class<EALAAmmoInventoryClass>(DefaultAmmoLoadout[I].AmmoClass);
                MOHAInvManager.AddReserveAmmo(AmmoClass, DefaultAmmoLoadout[I].StartingReserveAmmo, true);
                MOHAInvManager.SetMaxAmmoCount(AmmoClass, DefaultAmmoLoadout[I].MaxReserveAmmo);
            }
            I++;
            // [Loop Continue]
            goto J0x4F;
        }
    }
    I = 0;
    J0x10B:

    // End:0x1ED [Loop If]
    if(I < WorldInfo.AmmoLoadout.Length)
    {
        // End:0x1E3
        if(ClassIsChildOf(WorldInfo.AmmoLoadout[I].AmmoClass, Class'EALAAmmoInventoryClass'))
        {
            AmmoClass = class<EALAAmmoInventoryClass>(WorldInfo.AmmoLoadout[I].AmmoClass);
            MOHAInvManager.AddReserveAmmo(AmmoClass, WorldInfo.AmmoLoadout[I].StartingReserveAmmo, true);
            MOHAInvManager.SetMaxAmmoCount(AmmoClass, WorldInfo.AmmoLoadout[I].MaxReserveAmmo);
        }
        I++;
        // [Loop Continue]
        goto J0x10B;
    }
    //return;    
}

function AddDamageHistory(Controller Inst, int Damage)
{
    local PlayerDamageRecord pdr;
    local PlayerDPSRecord dps;
    local int I, HistoryLength;
    local bool bFreshDamageHistory;
    local float Range;

    HistoryLength = 10;
    pdr.InstigatorName = "" $ string(Inst.Pawn);
    pdr.InstigatorController = "" $ string(Inst);
    pdr.WeaponUsed = "" $ string(Inst.Pawn.Weapon);
    pdr.damageDone = Damage;
    pdr.LastHitDelta = WorldInfo.TimeSeconds - LastTakeDamageTime;
    DamageHistory[DamageHistory.Length] = pdr;
    LastTakeDamageTime = WorldInfo.TimeSeconds;
    // End:0x12A
    if(DamageHistory.Length > HistoryLength)
    {
        I = 0;
        J0xEB:

        // End:0x11E [Loop If]
        if(I < HistoryLength)
        {
            DamageHistory[I] = DamageHistory[I + 1];
            I++;
            // [Loop Continue]
            goto J0xEB;
        }
        DamageHistory.Length = HistoryLength;
    }
    Range = VSize(Inst.Pawn.Location - Location);
    bFreshDamageHistory = false;
    // End:0x17C
    if(DPSRecord.Length > 0)
    {
        dps = DPSRecord[DPSRecord.Length - 1];        
    }
    else
    {
        bFreshDamageHistory = true;
    }
    // End:0x2AD
    if(!bFreshDamageHistory)
    {
        // End:0x1BA
        if((LastTakeDamageTime - dps.LastHitTime) > DPSInterval)
        {
            bFreshDamageHistory = true;            
        }
        else
        {
            dps.Duration += (LastTakeDamageTime - dps.LastHitTime);
            dps.damageDone += Damage;
            dps.LastHitTime = LastTakeDamageTime;
            dps.dps = float(dps.damageDone) / dps.Duration;
            dps.Range += Range;
            dps.numHits += 1;
            dps.avgRange = dps.Range / float(dps.numHits);
            DPSRecord[DPSRecord.Length - 1] = dps;
        }
    }
    // End:0x38E
    if(bFreshDamageHistory)
    {
        dps.LastHitTime = LastTakeDamageTime;
        dps.Duration = 0.0000000;
        dps.damageDone = Damage;
        dps.Range = Range;
        dps.avgRange = Range;
        dps.numHits = 1;
        dps.dps = float(dps.damageDone) / DPSInterval;
        dps.InstigatorName = "" $ string(Inst.Pawn);
        DPSRecord[DPSRecord.Length] = dps;
    }
    // End:0x3E4
    if(DPSRecord.Length > HistoryLength)
    {
        I = 0;
        J0x3A5:

        // End:0x3D8 [Loop If]
        if(I < HistoryLength)
        {
            DPSRecord[I] = DPSRecord[I + 1];
            I++;
            // [Loop Continue]
            goto J0x3A5;
        }
        DPSRecord.Length = HistoryLength;
    }
    SetHealth(default.Health);
    //return;    
}

function DrawDamageHistory(Canvas Canvas)
{
    local int I, Y;
    local PlayerDamageRecord pdr;
    local PlayerDPSRecord dps;
    local float XL, YL, Duration;

    Y = Canvas.SizeY / 2;
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    Canvas.__NFUN_464__("W", XL, YL);
    Y -= int(YL * float(DamageHistory.Length));
    I = 0;
    J0x6D:

    // End:0x192 [Loop If]
    if(I < DamageHistory.Length)
    {
        pdr = DamageHistory[I];
        Canvas.SetPos(10.0000000, float(Y));
        Canvas.__NFUN_465__(pdr.InstigatorName);
        Canvas.SetPos(250.0000000, float(Y));
        Canvas.__NFUN_465__(pdr.InstigatorController);
        Canvas.SetPos(500.0000000, float(Y));
        Canvas.__NFUN_465__("" $ string(pdr.damageDone));
        Canvas.SetPos(530.0000000, float(Y));
        Canvas.__NFUN_465__("" $ string(pdr.LastHitDelta));
        Y += int(YL);
        I++;
        // [Loop Continue]
        goto J0x6D;
    }
    // End:0x22B
    if(DPSRecord.Length > 0)
    {
        Canvas.SetPos(10.0000000, float(Y));
        Canvas.__NFUN_465__("Damage Per Second (DPS) History - new dps report in " $ string(DPSInterval - (WorldInfo.TimeSeconds - LastTakeDamageTime)));
        Y += int(YL);
    }
    I = 0;
    J0x232:

    // End:0x35C [Loop If]
    if(I < DPSRecord.Length)
    {
        dps = DPSRecord[I];
        Duration = dps.Duration;
        Canvas.SetPos(10.0000000, float(Y));
        Canvas.__NFUN_465__(string(dps.dps));
        Canvas.SetPos(100.0000000, float(Y));
        Canvas.__NFUN_465__("Avg. Range: " $ string(dps.avgRange));
        Canvas.SetPos(250.0000000, float(Y));
        Canvas.__NFUN_465__(((("" $ string(dps.damageDone)) $ " hp / ") $ string(Duration)) $ "(s)");
        Y += int(YL);
        I++;
        // [Loop Continue]
        goto J0x232;
    }
    //return;    
}

event float GetDefaultFOV()
{
    return 80.0000000;
    //return ReturnValue;    
}

function OnTogglePlayerStance(SeqAct_TogglePlayerStance Action)
{
    // End:0x5A
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x3C
        if(int(eCurrentStance) == int(0))
        {
            DownwardStanceChangeRequest();            
        }
        else
        {
            // End:0x57
            if(int(eCurrentStance) == int(1))
            {
                UpwardStanceChangeRequest();
            }
        }        
    }
    else
    {
        // End:0x98
        if(Action.InputLinks[1].bHasImpulse && int(eCurrentStance) == int(0))
        {
            DownwardStanceChangeRequest();            
        }
        else
        {
            // End:0xB3
            if(int(eCurrentStance) == int(1))
            {
                UpwardStanceChangeRequest();
            }
        }
    }
    //return;    
}

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    return GetBaseAimRotation();
    //return ReturnValue;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    MOHAPlayerController(Controller).DeathCleanup();
    MOHAInventoryManager(InvManager).PlayerPawnDied();
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

exec function ToggleSprintFX()
{
    bDisableSprintFX = !bDisableSprintFX;
    //return;    
}

auto state Idle
{
    function BeginState(name PreviousStateName)
    {
        PlaybackLength = 0.0000000;
        EnableRadialBlur(false);
        // End:0x87
        if(GetStateName() == 'Idle')
        {
            // End:0x48
            if(int(eCurrentStance) == int(0))
            {
                GotoState('Stand_Idle');                
            }
            else
            {
                // End:0x69
                if(int(eCurrentStance) == int(1))
                {
                    GotoState('Crouch_Idle');                    
                }
                else
                {
                    // End:0x87
                    if(int(eCurrentStance) == int(2))
                    {
                        GotoState('Prone_Idle');
                    }
                }
            }
        }
        //return;        
    }

    simulated event bool IsIdle()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function Tick(float DeltaTime)
    {
        CheckForIdleStateChange();
        global.Tick(DeltaTime);
        CheckForAnimatedJumpTransition();
        //return;        
    }

    function CheckForAnimatedJumpTransition()
    {
        local float fDistToGround;

        // End:0x91
        if(int(Physics) == int(2))
        {
            fDistToGround = GetDistToGround();
            // End:0x4D
            if(!bProceduralJump && fDistToGround > fMinDistForFallBlend)
            {
                GotoState('JumpIdle');                
            }
            else
            {
                // End:0x8E
                if((bProceduralJump && Velocity.Z < -JumpZ) && fDistToGround > 200.0000000)
                {
                    StartAnimatedJump();
                }
            }            
        }
        else
        {
            // End:0xB6
            if((int(Physics) == int(1)) && bProceduralJump)
            {
                EndProceduralJump();
            }
        }
        //return;        
    }

    function MOHAPlayerPawn.EAnimLocomotionState GetLocomotionState()
    {
        local float fSpeed, fSprintThreshold;

        fSpeed = VSize(Velocity);
        fSprintThreshold = (GroundSpeed * (GetWeaponSpeedMultiplier())) * ((int(WorldInfo.NetMode) == int(NM_Standalone)) ? 1.0100000 : 0.6000000);
        // End:0x8F
        if(((bForceIdleAnim || fSpeed == 0.0000000) || int(Physics) != int(1)) || int(LastActivity) == int(25))
        {
            return 0;            
        }
        else
        {
            // End:0xB3
            if((fSpeed > fSprintThreshold) && IsSprintEnabled())
            {
                return 2;                
            }
            else
            {
                return 1;
            }
        }
        //return ReturnValue;        
    }

    simulated function float GetDistToGround()
    {
        local Vector vHitLocation, vHitNormal, vStartTrace, vEndTrace, vExtents;

        local Actor HitActor;

        vStartTrace = GetGroundPos();
        vEndTrace = vStartTrace - vect(0.0000000, 0.0000000, 20000.0000000);
        vExtents = ((GetCollisionRadius()) * vect(0.7070000, 0.7070000, 0.0000000)) + vect(0.0000000, 0.0000000, 1.0000000);
        HitActor = Trace(vHitLocation, vHitNormal, vEndTrace, vStartTrace, false, vExtents);
        return ((HitActor != none) ? VSize(vHitLocation - vStartTrace) : 20000.0000000);
        //return ReturnValue;        
    }
    stop;    
}

state Stand extends Idle
{
    function CheckForIdleStateChange()
    {
        local MOHAPlayerPawn.EAnimLocomotionState eLocomotionState;

        eLocomotionState = GetLocomotionState();
        // End:0x31
        if(int(eCurrentStance) == int(1))
        {
            GotoState('Crouch_Idle');            
        }
        else
        {
            // End:0x52
            if(int(eCurrentStance) == int(2))
            {
                GotoState('Prone_Idle');                
            }
            else
            {
                // End:0x86
                if((int(eLocomotionState) == int(0)) && GetStateName() != 'Stand_Idle')
                {
                    GotoState('Stand_Idle');                    
                }
                else
                {
                    // End:0xBA
                    if((int(eLocomotionState) == int(1)) && GetStateName() != 'Stand_Walk')
                    {
                        GotoState('Stand_Walk');                        
                    }
                    else
                    {
                        // End:0xEB
                        if((int(eLocomotionState) == int(2)) && GetStateName() != 'Stand_Sprint')
                        {
                            GotoState('Stand_Sprint');
                        }
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}

state Stand_Idle extends Stand
{
    function BeginState(name PreviousStateName)
    {
        super(Idle).BeginState(PreviousStateName);
        SetActivity(0);
        //return;        
    }
    stop;    
}

state Stand_Walk extends Stand
{
    function BeginState(name PreviousStateName)
    {
        super(Idle).BeginState(PreviousStateName);
        SetActivity(1);
        //return;        
    }
    stop;    
}

state Stand_Sprint extends Stand
{
    function BeginState(name PreviousStateName)
    {
        super(Idle).BeginState(PreviousStateName);
        SetActivity(2);
        // End:0x64
        if(!bDisableSprintFX && MOHAPlayerController(Controller).GetSprintFXSetting())
        {
            WorldInfo.GameModified_bTurnOnMotionBlur = true;
            WorldInfo.GameModified_MotionBlur_Amount = fSprintMotionBlurAmount;
        }
        SprintSoundMix.ActiveAsMixFader();
        fCurrentSprintFOV = MOHAPlayerController(Controller).GetLastFOV();
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        WorldInfo.GameModified_bTurnOnMotionBlur = false;
        SprintSoundMix.DeActivate();
        fSprintZoomBlendOutTime = Abs(fCurrentSprintFOV - 80.0000000) / fSprintZoomOutRate;
        //return;        
    }

    simulated event bool IsSprinting()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state Crouch extends Idle
{
    function CheckForIdleStateChange()
    {
        local MOHAPlayerPawn.EAnimLocomotionState eLocomotionState;

        eLocomotionState = GetLocomotionState();
        // End:0x31
        if(int(eCurrentStance) == int(0))
        {
            GotoState('Stand_Idle');            
        }
        else
        {
            // End:0x52
            if(int(eCurrentStance) == int(2))
            {
                GotoState('Prone_Idle');                
            }
            else
            {
                // End:0x86
                if((int(eLocomotionState) == int(0)) && GetStateName() != 'Crouch_Idle')
                {
                    GotoState('Crouch_Idle');                    
                }
                else
                {
                    // End:0xB7
                    if((int(eLocomotionState) == int(1)) && GetStateName() != 'Crouch_Walk')
                    {
                        GotoState('Crouch_Walk');
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}

state Crouch_Idle extends Crouch
{
    function BeginState(name PreviousStateName)
    {
        super(Idle).BeginState(PreviousStateName);
        SetActivity(0);
        //return;        
    }
    stop;    
}

state Crouch_Walk extends Crouch
{
    function BeginState(name PreviousStateName)
    {
        super(Idle).BeginState(PreviousStateName);
        SetActivity(3);
        //return;        
    }
    stop;    
}

state Prone extends Idle
{
    function CheckForIdleStateChange()
    {
        local MOHAPlayerPawn.EAnimLocomotionState eLocomotionState;

        eLocomotionState = GetLocomotionState();
        // End:0x64
        if(int(eCurrentStance) == int(0))
        {
            // End:0x42
            if(GetStateName() == 'Prone_Idle')
            {
                GotoState('Stand_Idle');                
            }
            else
            {
                // End:0x61
                if(GetStateName() == 'Prone_Crawl')
                {
                    GotoState('Prone_Crawl_Out');
                }
            }            
        }
        else
        {
            // End:0xB8
            if(int(eCurrentStance) == int(1))
            {
                // End:0x96
                if(GetStateName() == 'Prone_Idle')
                {
                    GotoState('Crouch_Idle');                    
                }
                else
                {
                    // End:0xB5
                    if(GetStateName() == 'Prone_Crawl')
                    {
                        GotoState('Prone_Crawl_Out');
                    }
                }                
            }
            else
            {
                // End:0xEC
                if((int(eLocomotionState) == int(0)) && GetStateName() == 'Prone_Crawl')
                {
                    GotoState('Prone_Crawl_Out');                    
                }
                else
                {
                    // End:0x14B
                    if(((int(eLocomotionState) == int(1)) && GetStateName() == 'Prone_Idle') && ((IsLocallyControlled()) ? (fRawJoyUp != 0.0000000) || fRawJoyRight != 0.0000000 : true))
                    {
                        GotoState('Prone_Crawl_In');
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}

state Prone_Idle extends Prone
{
    function BeginState(name PreviousStateName)
    {
        super(Idle).BeginState(PreviousStateName);
        SetActivity(0);
        //return;        
    }
    stop;    
}

state Prone_Crawl_In extends Prone
{
    function BeginState(name PreviousStateName)
    {
        super(Idle).BeginState(PreviousStateName);
        SetActivity(5);
        //return;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        GotoState('Prone_Crawl');
        //return;        
    }
    stop;    
}

state Prone_Crawl extends Prone
{
    function BeginState(name PreviousStateName)
    {
        super(Idle).BeginState(PreviousStateName);
        SetActivity(4);
        //return;        
    }
    stop;    
}

state Prone_Crawl_Out extends Prone
{
    function BeginState(name PreviousStateName)
    {
        super(Idle).BeginState(PreviousStateName);
        SetActivity(6);
        //return;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        GotoState('Prone_Idle');
        //return;        
    }
    stop;    
}

state Fire
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(7);
        PlaybackLength = ((Weapon != none) ? Weapon.GetFireInterval(Weapon.CurrentFireMode) : 0.0000000);
        //return;        
    }
    stop;    
}

state Reload
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(8);
        PlaybackLength = ((EALASmallArms(Weapon) != none) ? EALASmallArms(Weapon).GetReloadInterval() : 0.0000000);
        //return;        
    }
    stop;    
}

state Reload_In
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(9);
        PlaybackLength = ((MOHASingleShotReloadWeapon(Weapon) != none) ? MOHASingleShotReloadWeapon(Weapon).WeaponReloadInTiming : 0.0000000);
        //return;        
    }
    stop;    
}

state Reload_Out
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(10);
        PlaybackLength = ((MOHASingleShotReloadWeapon(Weapon) != none) ? MOHASingleShotReloadWeapon(Weapon).WeaponReloadOutTiming : 0.0000000);
        //return;        
    }
    stop;    
}

state Rechamber
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(12);
        PlaybackLength = ((EALASmallArms(Weapon) != none) ? EALASmallArms(Weapon).GetRechamberInterval(byte(EALASmallArms(Weapon).iRechamberFireMode)) : 0.0000000);
        //return;        
    }
    stop;    
}

state Melee
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(11);
        PlaybackLength = ((EALAWeapon(Weapon) != none) ? EALAWeapon(Weapon).GetMeleeInterval() : 0.0000000);
        //return;        
    }
    stop;    
}

state Prime
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(13);
        PlaybackLength = ((EALAGrenade(Weapon) != none) ? EALAGrenade(Weapon).GetPrimeInterval() : 0.0000000);
        //return;        
    }
    stop;    
}

state PrimeIdle
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(14);
        PlaybackLength = 0.0000000;
        //return;        
    }
    stop;    
}

state PrimeCook
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(15);
        PlaybackLength = ((EALAGrenade(Weapon) != none) ? EALAGrenade(Weapon).GetPullPinInterval() : 0.0000000);
        //return;        
    }
    stop;    
}

state ReadyCook
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(16);
        PlaybackLength = ((EALAGrenade(Weapon) != none) ? EALAGrenade(Weapon).GetPullBackInterval() : 0.0000000);
        //return;        
    }
    stop;    
}

state Throw
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(17);
        PlaybackLength = ((EALAGrenade(Weapon) != none) ? EALAGrenade(Weapon).GetThrowInterval() : 0.0000000);
        //return;        
    }
    stop;    
}

state Toss
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(18);
        PlaybackLength = ((EALAGrenade(Weapon) != none) ? EALAGrenade(Weapon).GetTossInterval() : 0.0000000);
        //return;        
    }
    stop;    
}

state LowerWeapon
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(19);
        PlaybackLength = ((Weapon != none) ? Weapon.PutDownTime : 0.0000000);
        //return;        
    }
    stop;    
}

state RaiseWeapon
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(20);
        PlaybackLength = ((Weapon != none) ? Weapon.EquipTime : 0.0000000);
        //return;        
    }
    stop;    
}

state IronsightsIn
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(21);
        PlaybackLength = ((EALASmallArms(Weapon) != none) ? EALASmallArms(Weapon).IronsightsInTime : 0.0000000);
        bIronsightsActive = true;
        // End:0x6C
        if(EALASmallArms(Weapon) != none)
        {
            EALASmallArms(Weapon).ResetKick();
        }
        // End:0xA0
        if(EALAWeapon(Weapon).HideCursorInIronsights())
        {
            MOHAPlayerController(Controller).ToggleCursor(false);
        }
        //return;        
    }
    stop;    
}

state IronsightsOut
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(22);
        PlaybackLength = ((EALASmallArms(Weapon) != none) ? EALASmallArms(Weapon).IronsightsOutTime : 0.0000000);
        //return;        
    }

    function EndState(name NextStateName)
    {
        MOHAPlayerController(Controller).ToggleCursor(true);
        bIronsightsActive = false;
        //return;        
    }
    stop;    
}

state IronsightsIdle
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(23);
        PlaybackLength = (((EALASmallArms(Weapon) != none) && EALASmallArms(Weapon).IsTrueTriggerEnabled()) ? 100000000.0000000 : 0.0000000);
        //return;        
    }
    stop;    
}

state IronsightsFire
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(24);
        PlaybackLength = ((Weapon != none) ? Weapon.GetFireInterval(Weapon.CurrentFireMode) : 0.0000000);
        //return;        
    }
    stop;    
}

state EnterAlternateFire
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(44);
        PlaybackLength = ((EALASmallArms(Weapon) != none) ? EALASmallArms(Weapon).AlternateFireModeInTime : 0.0000000);
        //return;        
    }
    stop;    
}

state LeaveAlternateFire
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(45);
        PlaybackLength = ((EALASmallArms(Weapon) != none) ? EALASmallArms(Weapon).AlternateFireModeOutTime : 0.0000000);
        //return;        
    }
    stop;    
}

state ScopeModeIn
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(55);
        PlaybackLength = ((EALASmallArms(Weapon) != none) ? EALASmallArms(Weapon).ScopeModeInTime : 0.0000000);
        //return;        
    }
    stop;    
}

state ScopeModeOut
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(56);
        PlaybackLength = ((EALASmallArms(Weapon) != none) ? EALASmallArms(Weapon).ScopeModeOutTime : 0.0000000);
        //return;        
    }
    stop;    
}

state StanceChangeIn
{
    simulated function BeginState(name PreviousStateName)
    {
        eCurrentStanceChange = GetStanceChangeType(eCurrentStance, eDesiredStance);
        // End:0x33
        if(IsLocallyControlled())
        {
            vStartingCameraPos_AS = GetCameraPos_AS();
        }
        // End:0x70
        if(IsCrawlActivity(CurrentActivity))
        {
            bForceIdleAnim = true;
            SetWeaponDisabled(true);
            UpdateSkelControls();
            TimeStanceChangeIn();            
        }
        else
        {
            GotoState('StanceChange');
        }
        //return;        
    }

    simulated function Vector GetCameraPos_AS()
    {
        local Vector vGroundPos;

        vGroundPos = Location;
        vGroundPos.Z -= ((int(eDesiredStance) > int(eCurrentStance)) ? StanceCollisionHeights[int(eCurrentStance)] : CylinderComponent.CollisionHeight);
        return Class'MOHAUtilities'.static.InverseRotateVector((GetCameraPos()) - vGroundPos, Rotation);
        //return ReturnValue;        
    }

    simulated function EndStanceChangeInTimer()
    {
        SetWeaponDisabled(false);
        bForceIdleAnim = false;
        GotoState('StanceChange');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('EndStanceChangeInTimer');
        //return;        
    }

    simulated function TimeStanceChangeIn()
    {
        // End:0x29
        if(!IsTimerActive('EndStanceChangeInTimer'))
        {
            SetTimer(fStanceChangeInTime, true, 'EndStanceChangeInTimer');
        }
        //return;        
    }
    stop;    
}

state StanceChange
{
    simulated function BeginState(name PreviousStateName)
    {
        SetActivity(25);
        PlaybackLength = AnimatedStanceChangeTimes[int(eCurrentStanceChange)];
        PlayStanceChangeSound();
        bAnimatedStanceChange = true;
        UpdateSkelControls();
        // End:0x92
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            // End:0x77
            if(!IsLocallyControlled())
            {
                SetTimer(PlaybackLength, false, 'StanceChangeTimerDone');                
            }
            else
            {
                SetTimer(PlaybackLength * 1.2500000, false, 'StanceChangeTimerDone');
            }
        }
        //return;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        // End:0x47
        if(int(GetRootActivity(SeqNode)) == int(25))
        {
            SetCurrentStance(eDesiredStance);
            EndAnimatedStanceChange(GetDesiredStanceHeightMod());
            ActivityDoneEvent();
        }
        //return;        
    }

    simulated function StanceChangeTimerDone()
    {
        SetCurrentStance(eDesiredStance);
        EndAnimatedStanceChange(GetDesiredStanceHeightMod());
        ActivityDoneEvent();
        //return;        
    }

    simulated function EndAnimatedStanceChange(Vector vEndingStanceHeightMod)
    {
        bAnimatedStanceChange = false;
        SetCurrentStance(eDesiredStance);
        eCurrentStanceChange = 0;
        vCurrentStanceHeightMod = vEndingStanceHeightMod;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local Vector vEndingCameraPos_AS;

        // End:0x65
        if(bAnimatedStanceChange && IsLocallyControlled())
        {
            vEndingCameraPos_AS = Class'MOHAUtilities'.static.InverseRotateVector((GetCameraPos()) - (GetGroundPos()), Rotation);
            EndAnimatedStanceChange((vCurrentStanceHeightMod + vEndingCameraPos_AS) - vStartingCameraPos_AS);
        }
        ClearTimer('StanceChangeTimerDone');
        //return;        
    }
    stop;    
}

state JumpStart
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(26);
        PlaybackLength = fJumpStartAnimTime;
        EndProceduralJump();
        SetTimer(PlaybackLength, false, 'JumpStartTimerDone');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('JumpStartTimerDone');
        //return;        
    }

    simulated function JumpStartTimerDone()
    {
        GotoState('JumpIdle');
        //return;        
    }

    event Landed(Vector HitNormal, Actor FloorActor)
    {
        GotoState('Idle');
        //return;        
    }

    simulated event bool IsJumping()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state JumpIdle
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(27);
        PlaybackLength = 0.0000000;
        //return;        
    }

    event Landed(Vector HitNormal, Actor FloorActor)
    {
        GotoState('JumpEnd');
        super(MOHAPlayerPawn).Landed(HitNormal, FloorActor);
        //return;        
    }

    simulated event bool IsJumping()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state JumpEnd
{
    function BeginState(name PreviousStateName)
    {
        local MOHAPlayerPawn.EPlayerActivity NextActivity;

        NextActivity = ((Velocity.Z < -fHardJumpLandingSpeed) ? 29 : 28);
        SetActivity(NextActivity);
        PlaybackLength = ((int(NextActivity) == int(29)) ? fJumpEndHardAnimTime : fJumpEndSoftAnimTime);
        SetTimer(PlaybackLength, false, 'JumpEndTimerDone');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('JumpEndTimerDone');
        //return;        
    }

    simulated function JumpEndTimerDone()
    {
        ActivityDoneEvent();
        //return;        
    }

    simulated event bool IsJumping()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state LadderClimb
{
    function BeginState(name PreviousStateName)
    {
        // End:0x23
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            CenterPlayerWithLadder();
        }
        SetActivity();
        PlaybackLength = ((Weapon != none) ? Weapon.PutDownTime : 0.0000000);
        SetWeaponDisabled(true);
        SetCurrentStance(0);
        SetPhysics(9);
        Controller.GotoState('PlayerClimbing');
        PlayImpact(13, Location - (vect(0.0000000, 0.0000000, 1.0000000) * (GetCollisionHeight())), vect(0.0000000, 0.0000000, 1.0000000), none, MOHALadderVolume(OnLadder).PhysMaterial);
        //return;        
    }

    function EndClimbLadder(LadderVolume OldLadder)
    {
        super(Pawn).EndClimbLadder(OldLadder);
        SetWeaponDisabled(false);
        GotoState('Idle');
        //return;        
    }
    stop;    
}

state Death
{
    ignores BreathTimer, ActivityDoneEvent, Weapon_RaiseWeaponEvent, AirDrop_DeployChuteEvent, AirDrop_DecendEvent, AirDrop_ChuteFlareEvent, 
	    AirDrop_LandingEvent, ITP_JumpVoluntaryEvent, ITP_JumpInvoluntaryEvent, PlayerExitsPlane, AirDrop_ParachuteHungUpEvent, 
	    AirDrop_CutChuteEvent;

    function BeginState(name PreviousStateName)
    {
        fStateTime = 0.0000000;
        fStartingPitch = float(CurrentView.Pitch);
        bCanPickupInventory = false;
        //return;        
    }

    simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        local float fPerc;

        super(MOHAPlayerPawn).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        fStateTime += DeltaTime;
        fPerc = fStateTime;
        // End:0x80
        if((fPerc >= 0.0000000) && fPerc <= 1.0000000)
        {
            out_ViewRotation.Pitch = int(Class'MOHAUtilities'.static.LerpAngle(fStartingPitch, 0.0000000, fPerc));
        }
        //return;        
    }

    function bool IsDead()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state Death_In extends Death
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        SetActivity(34);
        PlaybackLength = 0.0000000;
        bDisableMoveInput = true;
        bDisableLookInput = true;
        SetWeaponDisabled(true);
        // End:0x7F
        if(Controller != none)
        {
            MOHAPlayerController(Controller).myHUD.bShowHUD = false;
            MOHAPlayerController(Controller).ClearCSAList();
        }
        //return;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        // End:0x28
        if(int(GetRootActivity(SeqNode)) == int(34))
        {
            GotoState('Death_Main');
        }
        //return;        
    }
    stop;    
}

state Death_Main extends Death
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(33);
        PlaybackLength = 0.0000000;
        // End:0x5D
        if(ClassIsChildOf(KillDamageType, Class'MOHAScriptedDeathDamageType'))
        {
            MOHAPlayerController(Controller).FadeOut(0.0000000, fScriptedDeathFadeOutTime);
            SetTimer(fScriptedDeathFadeOutTime, false, 'ScriptedDeathFinished');
        }
        //return;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        // End:0x28
        if(int(GetRootActivity(SeqNode)) == int(33))
        {
            GotoState('Death_End');
        }
        //return;        
    }

    function ScriptedDeathFinished()
    {
        GotoState('Death_End');
        //return;        
    }
    stop;    
}

state Death_End extends Death
{
    function BeginState(name PreviousStateName)
    {
        // End:0x41
        if(!ClassIsChildOf(KillDamageType, Class'MOHAScriptedDeathDamageType'))
        {
            MOHAPlayerController(Controller).NotifyDeath();
            SetTimer(fDeathFadeOutDelay, false, 'StartFadeOut');            
        }
        else
        {
            AutoRespawn();
        }
        //return;        
    }

    function StartFadeOut()
    {
        MOHAPlayerController(Controller).FadeOut(0.0000000, fDeathFadeOutTime);
        SetTimer(fDeathFadeOutTime, false, 'AutoRespawn');
        //return;        
    }

    function EndState(name NextStateName)
    {
        MOHAPlayerController(Controller).myHUD.bShowHUD = true;
        MOHAPlayerController(Controller).FadeIn(0.0000000, fRespawnFadeInTime);
        EndShellShock();
        //return;        
    }

    function AutoRespawn()
    {
        MOHAPlayerController(Controller).respawn();
        //return;        
    }

    function bool CanRespawn()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state ITPJump
{
    function bool IsITPActive()
    {
        return true;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        SetWeaponDisabled(true);
        //return;        
    }

    function EndState(name NextStateName)
    {
        SetWeaponDisabled(false);
        //return;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        InitializeAirdropState();
        GotoState('AirDropControlledFall');
        PlaybackLength = 0.0000000;
        //return;        
    }

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        local Rotator boneRot;
        local float lerpFactor;
        local Quat boneRotQuat, jumpRotQuat, interpQuat;

        lerpFactor = (WorldInfo.TimeSeconds - fLastCachedRotCachedTime) / 0.7500000;
        // End:0x3C
        if(lerpFactor > 1.0000000)
        {
            lerpFactor = 1.0000000;
        }
        FPArms.GetSocketWorldLocationAndRotation(CameraSocketNameITP, out_CamLoc, boneRot);
        boneRotQuat = QuatFromRotator(boneRot);
        jumpRotQuat = QuatFromRotator(lastCachedRot);
        interpQuat = QuatSlerp(jumpRotQuat, boneRotQuat, lerpFactor);
        out_CamRot = QuatToRotator(interpQuat);
        // End:0xCE
        if(bITPDebugCam == true)
        {
            ITPCamDebug(out_CamLoc, out_CamRot, out_CamRot);
        }
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state ITPJumpVoluntary extends ITPJump
{
    function BeginState(name PreviousStateName)
    {
        CurrentITPActivity = 1;
        PlaybackLength = 0.0000000;
        EnableRadialBlur(true);
        super.BeginState(PreviousStateName);
        //return;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        GotoState('AirDropDeployChute');
        //return;        
    }
    stop;    
}

state ITPJumpInvoluntary extends ITPJump
{
    function BeginState(name PreviousStateName)
    {
        local MOHAPlayerController LocalPlayer;

        CurrentITPActivity = 2;
        PlaybackLength = 0.0000000;
        EnableRadialBlur(true);
        LocalPlayer = MOHAPlayerController(Controller);
        // End:0x85
        if((LocalPlayer != none) && LocalPlayer.playerStats != none)
        {
            LocalPlayer.playerStats.GiveXboxLiveAchievement("ACH_SP_Pushed_From_Plane");
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        GotoState('AirDropDeployChute');
        PlaybackLength = 0.0000000;
        //return;        
    }
    stop;    
}

state AirDropDeployChute extends ITPJump
{
    simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
    {
        NewRotation.Yaw = Rotation.Yaw;
        super(MOHAPlayerPawn).FaceRotation(NewRotation, DeltaTime);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local Vector temploc;
        local Rotator temprot;

        SetAiLodCullDistance(fAiLodCullDist_AirDrop);
        SetAiLodNonStasisClamp(AiLodNonStasisClamp_AirDrop);
        MOHAPlayerController(Controller).bInITPAnimScrubMode = false;
        // End:0x5F
        if(bRanITPSequence)
        {
            NullITPAnimSequences();
            UnloadAnimset(0, ViewModelITPAnimset);
            bRanITPSequence = false;
        }
        LoadDefaultAnimTreeAndSet();
        ResetPlayerPitch();
        // End:0xA5
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            CreateParachute(true);
            SetWeaponDisabled(true);            
        }
        else
        {
            FPArms.GetSocketWorldLocationAndRotation(RefBoneName, temploc, temprot);
            SetLocation(temploc);
        }
        SetActivity(35);
        bDisableLookInput = true;
        // End:0x106
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            PlaybackLength = fAirDropDeployChuteAnimTime;            
        }
        else
        {
            PlaybackLength = fAirDropDeployChuteAnimTimeMultiplayer;
        }
        SetTimer(PlaybackLength, false, 'AirDropDeployChuteTimerDone');
        // End:0x148
        if(FPArms != none)
        {
            FPArms.ForceTick(0.0000000);
        }
        HideWeapon(false);
        super.BeginState(PreviousStateName);
        // End:0x17F
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            SetRotation(temprot);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        bDisableLookInput = false;
        ClearTimer('AirDropDeployChuteTimerDone');
        //return;        
    }

    simulated function AirDropDeployChuteTimerDone()
    {
        local Vector vLocation;
        local Rotator vRotation;

        InitializeAirdropState();
        // End:0x67
        if(FPArms != none)
        {
            FPArms.GetSocketWorldLocationAndRotation('CamAirdrop', vLocation, vRotation);
            fLastCachedRotCachedTime = WorldInfo.TimeSeconds;
            lastCachedRot = vRotation;
            Controller.SetRotation(vRotation);
        }
        AirdropParachuteMesh.ChuteOpenAnimDone();
        GotoState('AirDropControlledFall');
        //return;        
    }

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        // End:0x2D
        if(FPArms != none)
        {
            FPArms.GetSocketWorldLocationAndRotation('CamAirdrop', out_CamLoc, out_CamRot);
        }
        // End:0x52
        if(bITPDebugCam == true)
        {
            ITPCamDebug(out_CamLoc, out_CamRot, out_CamRot);
        }
        return true;
        //return ReturnValue;        
    }

    simulated function LoadDefaultAnimTreeAndSet()
    {
        LoadAnimSetAndTree(Default_AnimSet, Default_AnimTree);
        FindActivityNode();
        InitSkeletalControls();
        //return;        
    }
    stop;    
}

state AirDropControlledFall
{
    function BeginState(name PreviousStateName)
    {
        SetCollision(true, true, false);
        bCollideWorld = true;
        SetWeaponDisabled(true);
        SetActivity(38);
        PlaybackLength = 0.0000000;
        Airdrop_BG_Loop.Play();
        // End:0x56
        if(IsTouchingWindVolume())
        {
            StartWindVolumeSound();
        }
        ViewPitchMin = -16383.0000000;
        EnableRadialBlur(true);
        AirdropVMRotation = Rotation;
        //return;        
    }

    event AirDrop_MeleeEvent()
    {
        GotoState('AirDropMelee');
        //return;        
    }

    simulated function StartWindVolumeSound()
    {
        Airdrop_WindVolumeLoop.Play();
        //return;        
    }

    simulated function AirDropMoveDone()
    {
        eAirMoveDirection = 0;
        //return;        
    }

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        local bool retval;
        local float lerpFactor;
        local Quat calcedRotQuat, chuteDeployRotQuat, interpQuat;

        retval = super(MOHAPlayerPawn).CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
        lerpFactor = (WorldInfo.TimeSeconds - fLastCachedRotCachedTime) / 0.7500000;
        // End:0x5D
        if(lerpFactor > 1.0000000)
        {
            lerpFactor = 1.0000000;
        }
        calcedRotQuat = QuatFromRotator(out_CamRot);
        chuteDeployRotQuat = QuatFromRotator(lastCachedRot);
        interpQuat = QuatSlerp(chuteDeployRotQuat, calcedRotQuat, lerpFactor);
        out_CamRot = QuatToRotator(interpQuat);
        // End:0xD1
        if(bITPDebugCam == true)
        {
            ITPCamDebug(out_CamLoc, out_CamRot, out_CamRot);
        }
        return retval;
        //return ReturnValue;        
    }

    function NormalizeView(out float X, out float Y, float Amount)
    {
        local float Mult, blend;

        Mult = Sqrt((Y * Y) + (X * X));
        // End:0x7E
        if(Mult > float(1))
        {
            blend = Abs(Y) / Mult;
            blend *= Amount;
            Mult = Lerp(1.0000000, Mult, blend);
            X /= Mult;
            Y /= Mult;
        }
        //return;        
    }

    function SetAirdropMoveDirection(float RawJoyUp, float RawJoyRight)
    {
        local float totalStickDeflection;
        local MOHAPlayerPawn.EAirDropMoveDirection StartingMoveDir;

        StartingMoveDir = eAirMoveDirection;
        totalStickDeflection = RawJoyUp + RawJoyRight;
        // End:0x3F
        if(totalStickDeflection == 0.0000000)
        {
            eAirMoveDirection = 0;
            eAirMoveDirectionInternal = 0;            
        }
        else
        {
            // End:0xBA
            if(Abs(RawJoyUp) > Abs(RawJoyRight))
            {
                // End:0x86
                if((RawJoyUp > 0.0000000) && int(eAirMoveDirectionInternal) != int(1))
                {
                    eAirMoveDirection = 1;
                    eAirMoveDirectionInternal = 1;                    
                }
                else
                {
                    // End:0xB7
                    if((RawJoyUp < 0.0000000) && int(eAirMoveDirectionInternal) != int(2))
                    {
                        eAirMoveDirection = 2;
                        eAirMoveDirectionInternal = 2;
                    }
                }                
            }
            else
            {
                // End:0x132
                if(Abs(RawJoyRight) > Abs(RawJoyUp))
                {
                    // End:0x101
                    if((RawJoyRight > 0.0000000) && int(eAirMoveDirectionInternal) != int(4))
                    {
                        eAirMoveDirection = 4;
                        eAirMoveDirectionInternal = 4;                        
                    }
                    else
                    {
                        // End:0x132
                        if((RawJoyRight < 0.0000000) && int(eAirMoveDirectionInternal) != int(3))
                        {
                            eAirMoveDirection = 3;
                            eAirMoveDirectionInternal = 3;
                        }
                    }
                }
            }
        }
        // End:0x16C
        if(int(StartingMoveDir) != int(eAirMoveDirection))
        {
            PlaybackLength = fAirDropControlledFallAnimTime[int(eAirMoveDirection)];
            SetTimer(PlaybackLength, false, 'AirDropMoveDone');
        }
        //return;        
    }

    simulated function UpdateAirdropLookJoy(float DeltaTime, float aTurn, float aLookUpDown)
    {
        AirdropLookLeftRightOffset += ((aTurn * 2.5000000) * DeltaTime);
        AirdropLookLeftRightPrev = FClamp(AirdropLookLeftRightOffset, -1.0000000, 1.0000000);
        AirdropLookLeftRightOffset *= FClamp(1.0000000 - (1.5000000 * DeltaTime), 0.0000000, 1.0000000);
        AirdropYawLookCompensation.Yaw += int((aTurn * float(15000)) * DeltaTime);
        DoLookCompensation = true;
        AirdropLookLeftRightOffset = FClamp(AirdropLookLeftRightOffset, -1.0000000, 1.0000000);
        // End:0xE0
        if(Abs(aLookUpDown) > 0.2000000)
        {
            AirdropLookUpDownOffset += ((aLookUpDown * DeltaTime) * 3.0000000);
            AirdropLookUpDownOffset = FClamp(AirdropLookUpDownOffset, -1.0000000, 1.0000000);
        }
        //return;        
    }

    simulated function UpdateAirdropLookMouse(float DeltaTime)
    {
        local float mX, mY, DestinationX, AirdropMouseJoySimSensitivity;

        AirdropMouseJoySimSensitivity = 1000.0000000;
        MOHAPlayerController(Controller).GetBlendedMouse(mX, mY, 4);
        // End:0x76
        if((MOHAPlayerController(Controller).PlayerInput != none) && MOHAPlayerController(Controller).PlayerInput.bInvertMouse)
        {
            mY *= -1.0000000;
        }
        DestinationX = AirdropMouseAccumulator;
        AirdropMouseAccumulator = mX / AirdropMouseJoySimSensitivity;
        DestinationX = FClamp((AirdropMouseAccumulator + DestinationX) / 2.0000000, -1.0000000, 1.0000000);
        UpdateAirdropLookJoy(DeltaTime, DestinationX, FClamp(mY / -AirdropMouseJoySimSensitivity, -1.0000000, 1.0000000));
        //return;        
    }

    simulated function UpdateAirdropLookPendulum()
    {
        local Vector DownVec, X, Y, Z;
        local float Prod;

        DownVec = vect(0.0000000, 0.0000000, -1.0000000);
        GetAxes(PendulumRotation, X, Y, Z);
        Prod = DownVec Dot Normal(Y);
        AirdropLookLeftRightPrev = FClamp(Prod + AirdropLookLeftRightPrev, -1.0000000, 1.0000000);
        AirdropLookLeftRightAmount = FClamp(Prod + AirdropLookLeftRightOffset, -1.0000000, 1.0000000);
        Prod = DownVec Dot Normal(X);
        Prod *= ((Prod < float(0)) ? 0.8000000 : 0.2000000);
        AirdropLookUpDownPrev = AirdropLookUpDownAmount;
        AirdropLookUpDownAmount = FClamp(AirdropLookUpDownOffset - Prod, -1.0000000, 1.0000000);
        //return;        
    }

    simulated function UpdateAirdropLook(float DeltaTime)
    {
        local float RawJoyLookUp;

        // End:0x2D
        if(MOHAPlayerController(Controller).IsUsingMouse())
        {
            UpdateAirdropLookMouse(DeltaTime);            
        }
        else
        {
            RawJoyLookUp = fRawJoyLookUp;
            // End:0x7F
            if((MOHAPlayerController(Controller).PlayerInput != none) && MOHAPlayerController(Controller).PlayerInput.bInvertMouse)
            {
                RawJoyLookUp *= -1.0000000;
            }
            UpdateAirdropLookJoy(DeltaTime, fRawJoyLookRight, RawJoyLookUp);
        }
        UpdateAirdropLookPendulum();
        NormalizeView(AirdropLookLeftRightAmount, AirdropLookUpDownAmount, 0.5000000);
        NormalizeView(AirdropLookLeftRightOffset, AirdropLookUpDownOffset, 0.5000000);
        NormalizeView(AirdropLookLeftRightPrev, AirdropLookUpDownPrev, 0.5000000);
        SetAirdropMoveDirection(fRawJoyUp, fRawJoyRight);
        //return;        
    }

    simulated function Rotator GetViewRotation()
    {
        UpdateAirdropViewRotation();
        return QuatToRotator(AirdropViewCache);
        //return ReturnValue;        
    }

    simulated event Vector GetPawnViewLocation()
    {
        local Vector vLocation;

        // End:0x37
        if((FPArms == none) || !FPArms.GetSocketWorldLocationAndRotation('CamAirdrop', vLocation))
        {
            return super(MOHAPlayerPawn).GetPawnViewLocation();
        }
        return vLocation;
        //return ReturnValue;        
    }

    simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
    {
        local int Temp;

        UpdateAirdropLook(DeltaTime);
        PendulumRotation = NewRotation;
        AirdropVMRotation = NewRotation;
        // End:0x53
        if(AirdropVMRotation.Pitch > 0)
        {
            AirdropVMRotation.Pitch *= 0.5000000;            
        }
        else
        {
            AirdropVMRotation.Pitch *= 0.1000000;
        }
        AirdropVMRotation.Pitch -= AirdropFallingPitchOffset;
        // End:0xD2
        if(AirdropFallingPitchOffset < AirdropFallingPitchTarget)
        {
            Temp = AirdropFallingPitchOffset - AirdropFallingPitchTarget;
            Temp *= (float(1) - (1.5000000 * DeltaTime));
            AirdropFallingPitchOffset = Clamp(AirdropFallingPitchTarget + Temp, 0, AirdropFallingPitchTarget);
        }
        super(MOHAPlayerPawn).FaceRotation(AirdropVMRotation, DeltaTime);
        //return;        
    }

    function EndState(name NextStateName)
    {
        SetWeaponDisabled(false);
        ClearTimer('AirDropMoveDone');
        //return;        
    }
    stop;    
}

state AirDropControlledFlare extends AirDropControlledFall
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(40);
        PlaybackLength = 0.0000000;
        SetWeaponDisabled(true);
        //return;        
    }
    stop;    
}

state AirDropLanding
{
    simulated function Rotator GetViewRotation()
    {
        local Quat Result;

        Result = QuatSlerp(AirdropViewCache, QuatFromRotator(global.GetViewRotation()), BlendOutAirdropView, true);
        return QuatToRotator(Result);
        //return ReturnValue;        
    }

    simulated event Vector GetPawnViewLocation()
    {
        local Vector vLocation, vAirdropLocation;

        // End:0x5C
        if(((FPArms == none) || !FPArms.GetSocketWorldLocationAndRotation('CamAirdrop', vAirdropLocation)) || !FPArms.GetSocketWorldLocationAndRotation(CameraSocketName, vLocation))
        {
            return global.GetPawnViewLocation();
        }
        return VLerp(vAirdropLocation, vLocation, BlendOutAirdropView);
        //return ReturnValue;        
    }

    simulated function Tick(float DeltaTime)
    {
        BlendOutAirdropView = FClamp(BlendOutAirdropView + (DeltaTime / BlendOutAirdropViewTime), 0.0000000, 1.0000000);
        global.Tick(DeltaTime);
        //return;        
    }

    simulated function ActivateLandedEvents()
    {
        local array<SequenceObject> AllLandedEvents;
        local SeqEvent_PlayerLanded LandedEvent;
        local Sequence GameSeq;
        local int idx;
        local array<int> LandingEventImpulses;

        LandingEventImpulses.Insert(0, 2);
        LandingEventImpulses[0] = 0;
        // End:0x64
        if((((int(eLandingType) == int(1)) || int(eLandingType) == int(2)) || int(eLandingType) == int(3)) || int(eLandingType) == int(4))
        {
            LandingEventImpulses[1] = 1;            
        }
        else
        {
            // End:0x81
            if(int(eLandingType) == int(5))
            {
                LandingEventImpulses[1] = 2;                
            }
            else
            {
                // End:0x9E
                if(int(eLandingType) == int(6))
                {
                    LandingEventImpulses[1] = 3;                    
                }
                else
                {
                    LandingEventImpulses[1] = -1;
                }
            }
        }
        GameSeq = WorldInfo.GetGameSequence();
        // End:0x134
        if(GameSeq != none)
        {
            GameSeq.FindSeqObjectsByClass(Class'SeqEvent_PlayerLanded', true, AllLandedEvents);
            idx = 0;
            J0xEC:

            // End:0x134 [Loop If]
            if(idx < AllLandedEvents.Length)
            {
                LandedEvent = SeqEvent_PlayerLanded(AllLandedEvents[idx]);
                LandedEvent.CheckActivate(self, self, false, LandingEventImpulses);
                idx++;
                // [Loop Continue]
                goto J0xEC;
            }
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local MOHAPlayerController PlayerController;
        local Rotator vRotation;

        vRotation = QuatToRotator(AirdropViewCache);
        SetRotation(vRotation);
        PlayerController = MOHAPlayerController(Controller);
        // End:0x45
        if(PlayerController != none)
        {
            PlayerController.SetRotation(vRotation);
        }
        SetWeaponDisabled(true);
        PerformLandingDetection(eLandingType, Velocity);
        PostLandingTypeDetermination();
        //return;        
    }

    simulated function PostLandingTypeDetermination()
    {
        local MOHAPlayerController PlayerController;

        PlayerController = MOHAPlayerController(Controller);
        // End:0x53
        if(PlayerController.myHUD != none)
        {
            MOHAHUD(PlayerController.myHUD).hud_messageQueue.ShowAirdropLandingIcon(eLandingType);
        }
        // End:0x95
        if((PlayerController != none) && PlayerController.playerStats != none)
        {
            PlayerController.playerStats.OnLanding(eLandingType);
        }
        // End:0xB0
        if(true == bDebugLandingType)
        {
            ReportLandingType(eLandingType);
        }
        ActivateLandedEvents();
        SetActivity(41);
        PlaybackLength = fAirDropLandingAnimTime[int(eLandingType)];
        SetTimer(PlaybackLength, false, 'AirDropLandingDone');
        Airdrop_BG_Loop.Stop();
        StopWindVolumeSound();
        EnableRadialBlur(false);
        // End:0x12F
        if(AirdropParachuteMesh != none)
        {
            AirdropParachuteMesh.HitGround();
        }
        SetAiLodCullDistance(fAiLodCullDist_OnGround);
        SetAiLodNonStasisClamp(AiLodNonStasisClamp_OnGround);
        //return;        
    }

    simulated function AirDropLandingDone()
    {
        // End:0x1D
        if(int(eLandingType) == int(6))
        {
            OnDoneLanding();            
        }
        else
        {
            GotoState('AirDropLanded');
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        SetWeaponDisabled(false);
        ClearTimer('AirDropLandingDone');
        //return;        
    }
    stop;    
}

state AirDropLanded
{
    function BeginState(name PreviousStateName)
    {
        local MOHAPlayerController PlayerController;

        PlayerController = MOHAPlayerController(Controller);
        SetWeaponDisabled(true);
        // End:0x3D
        if(PlayerController != none)
        {
            PlayerController.GotoState('AirDropLanded');
        }
        HideWeapon(true);
        Class'Engine.JuiceSubsystem'.static.LevelEvent("Gameplay", "Landed", "", int(eLandingType), 0.0000000, "", Location);
        //return;        
    }

    function EndState(name NextStateName)
    {
        SetWeaponDisabled(false);
        //return;        
    }

    event OnRemoveGear()
    {
        SetActivity(42);
        PlaybackLength = fAirdropRemoveGearAnimTime;
        SetTimer(PlaybackLength, false, 'AirDropRemoveGearDone');
        //return;        
    }

    function AirDropRemoveGearDone()
    {
        OnDoneLanding();
        //return;        
    }
    stop;    
}

state AirDropHanging extends AirDropControlledFall
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(36);
        PlaybackLength = 0.0000000;
        SetWeaponDisabled(true);
        //return;        
    }
    stop;    
}

state AirDropCutChute extends AirDropControlledFall
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(37);
        PlaybackLength = fAirdropCutChuteAnimTime;
        SetTimer(PlaybackLength, false, 'AirDropCutChuteDone');
        SetWeaponDisabled(true);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('AirDropCutChuteDone');
        //return;        
    }

    simulated function AirDropCutChuteDone()
    {
        AirdropParachuteMesh.CutChuteDone();
        GotoState('AirDropFreeFall');
        //return;        
    }
    stop;    
}

state AirDropFreeFall extends AirDropControlledFall
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(43);
        PlaybackLength = 0.0000000;
        SetWeaponDisabled(true);
        //return;        
    }
    stop;    
}

state AirDropMelee extends AirDropControlledFall
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(39);
        PlaybackLength = fAirdropMeleeAnimTime;
        SetTimer(PlaybackLength, false, 'AirDropMeleeDone');
        SetWeaponDisabled(true);
        //return;        
    }

    simulated function AirDropMeleeDone()
    {
        GotoState('AirDropControlledFall');
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('AirDropMeleeDone');
        //return;        
    }
    stop;    
}

state DemoChargeIdle
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(31);
        PlaybackLength = ((EALADemoCharge(Weapon) != none) ? EALADemoCharge(Weapon).PrimeInterval : 0.0000000);
        //return;        
    }

    function bool IsDemoCharging()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state LowerPrimedDemoCharge
{
    function BeginState(name PreviousStateName)
    {
        SetActivity(32);
        PlaybackLength = ((EALADemoCharge(Weapon) != none) ? EALADemoCharge(Weapon).PutDownTimePrimed : 0.0000000);
        //return;        
    }
    stop;    
}

state ITPInThePlane
{
    function bool IsITPActive()
    {
        return true;
        //return ReturnValue;        
    }

    function BeginITPPlayerControl()
    {
        MOHAPlayerController(Controller).bInITPAnimScrubMode = true;
        //return;        
    }

    function HideClip()
    {
        ITPClipMesh.SetHidden(true);
        FPArms.DetachComponent(ITPClipMesh);
        //return;        
    }

    function ITPPlayerJump()
    {
        lastCachedRot = GetViewRotation();
        playerPlane.ITPPlayerJump();
        playerPlane.bCamShakeEnabled = false;
        playerPlane = none;
        // End:0x57
        if(ITPClipMesh.bAttached)
        {
            HideClip();
        }
        PlayerExitsPlane();
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        GetCurrentITPAnimPosition();
        UpdatePush();
        //return;        
    }

    function bool UpdatePush()
    {
        // End:0x99
        if(!bIsPlaying)
        {
            // End:0x30
            if(fTimePaused <= 0.0001000)
            {
                fTimePaused = WorldInfo.TimeSeconds;
                return false;
            }
            // End:0x97
            if(((WorldInfo.TimeSeconds - fTimePaused) >= fPlayerPushInterval) && fTimePaused > 0.0000000)
            {
                fTimePaused = 0.0000000;
                // End:0x8A
                if(nPushes < nMaxPushes)
                {
                    PushPlayer(false);
                    return false;                    
                }
                else
                {
                    PushPlayer(true);
                    return true;
                }
            }
            return false;
        }
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        local Vector temploc;
        local Rotator temprot;

        LoadITPAnimTreeAndSet();
        CreateParachute(false);
        // End:0x8C
        if(AirdropParachuteMesh != none)
        {
            AirdropParachuteMesh.PlayerParachuteMesh.LightingChannels.Characters_Weapons_Vehicles = false;
            AirdropParachuteMesh.PlayerParachuteMesh.LightingChannels.CompositeDynamic = false;
            AirdropParachuteMesh.PlayerParachuteMesh.LightingChannels.In_The_Plane_Characters = true;
        }
        FPArms.SetDepthPriorityGroup(1);
        FPArms.LightingChannels.Characters_Weapons_Vehicles = false;
        FPArms.LightingChannels.CompositeDynamic = false;
        FPArms.LightingChannels.In_The_Plane_Characters = true;
        WorldInfo.GameModified_bTurnOffMotionBlur = true;
        // End:0x108
        if(bVerboseLogging)
        {
        }
        Mesh.SetLightEnvironment(none);
        FPArms.SetLightEnvironment(none);
        HideWeapon(false);
        SetWeaponDisabled(true);
        PushBlend = AnimNodeBlend(FPArms.Animations.FindAnimNode('PushBlend'));
        PushBlendByBone = AnimNodeBlendPerBone(FPArms.Animations.FindAnimNode('ITP_PlayPush_Blend'));
        CurrentITPActivity = 0;
        FPArms.GetSocketWorldLocationAndRotation(RefBoneName, temploc, temprot);
        CameraRotation = temprot;
        FPArms.AttachComponentToSocket(ITPClipMesh, 'RightGun');
        bRanITPSequence = true;
        StartAnimation();
        bISITPFirstCalcCam = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        // End:0x27
        if(FPArms != none)
        {
            FPArms.SetDepthPriorityGroup(2);
        }
        HideWeapon(true);
        SetWeaponDisabled(false);
        AirdropParachuteMesh.ExitPlaneIGCFinished();
        //return;        
    }

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        local bool retval;

        // End:0x33
        if(!IsFirstPerson())
        {
            retval = super(MOHAPlayerPawn).CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);            
        }
        else
        {
            GetActorEyesViewPoint(out_CamLoc, out_CamRot);
            FPArms.GetSocketWorldLocationAndRotation(CameraSocketNameITP, out_CamLoc, CameraRotation);
            retval = true;
        }
        // End:0x98
        if(bISITPFirstCalcCam)
        {
            SetViewRotation(CameraRotation);
            out_CamRot = CameraRotation;
            bISITPFirstCalcCam = false;
        }
        // End:0xC5
        if(bITPDebugCam == true)
        {
            ITPCamDebug(out_CamLoc, out_CamRot, out_CamRot);
            retval = true;
        }
        return retval;
        //return ReturnValue;        
    }

    simulated function Rotator GetViewRotation()
    {
        // End:0x1A
        if(Controller != none)
        {
            return Controller.Rotation;
        }
        return Rotation;
        //return ReturnValue;        
    }

    simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        out_ViewRotation += out_DeltaRot;
        out_DeltaRot = rot(0, 0, 0);
        out_ViewRotation = MOHAPlayerController(Controller).LimitViewRotationPitchAndYaw(out_ViewRotation - CameraRotation, fITPViewPitchMin, fITPViewPitchMax, fITPViewYawMin, fITPViewYawMax) + CameraRotation;
        SetViewRotation(out_ViewRotation);
        //return;        
    }

    simulated function LoadITPAnimTreeAndSet()
    {
        local MOHAAnimNodeInThePlane ITPAnimNode;

        LoadAnimSetAndTree(ViewModelITPAnimset, ViewModelITPAnimTree);
        InitSkeletalControls();
        ITPAnimNode = MOHAAnimNodeInThePlane(FPArms.Animations.FindAnimNode('MOHAAnimNodeInThePlane'));
        // End:0x65
        if(ITPAnimNode != none)
        {
            ITPAnimNode.playerPawnOwner = self;
        }
        //return;        
    }

    function PlayPushPlayerAnimation()
    {
        local AnimNodeSequence SeqNode;

        // End:0xC8
        if(PushAnimName != 'None')
        {
            SeqNode = AnimNodeSequence(FPArms.Animations.FindAnimNode(PushAnimName));
            // End:0xC8
            if(((PushBlend != none) && PushBlendByBone != none) && SeqNode != none)
            {
                PushBlend.SetBlendTarget(1.0000000, 0.2500000);
                PushBlendByBone.SetBlendTarget(1.0000000, 0.2500000);
                SeqNode.SetAnim(PushAnimName);
                SeqNode.PlayAnim(false, 1.0000000, 0.0000000);
            }
        }
        //return;        
    }

    function PushPlayer(bool bTimesUp)
    {
        local array<SequenceObject> AllSeqEvents;
        local Sequence GameSeq;
        local int I;
        local SeqEvent_PlayerPushed PPEvent;
        local array<int> PlayerEventImpulse;
        local Vector LocAmp, LocFreq, RotAmp, RotFreq;

        LocAmp = vect(10.0000000, 20.0000000, 20.0000000);
        LocFreq = vect(1.0000000, 10.0000000, 20.0000000);
        RotAmp = vect(300.0000000, 500.0000000, 1000.0000000);
        RotFreq = vect(10.0000000, 10.0000000, 25.0000000);
        PlayPushPlayerAnimation();
        // End:0xA1
        if(MOHAPlayerController(Controller) != none)
        {
            MOHAPlayerController(Controller).CameraShake(1.5000000, RotAmp, RotFreq, LocAmp, LocFreq, 5.0000000, 10.0000000);
        }
        GameSeq = WorldInfo.GetGameSequence();
        // End:0x133
        if(GameSeq != none)
        {
            GameSeq.FindSeqObjectsByClass(Class'SeqEvent_PlayerPushed', true, AllSeqEvents);
            I = 0;
            J0xE2:

            // End:0x133 [Loop If]
            if(I < AllSeqEvents.Length)
            {
                PPEvent = SeqEvent_PlayerPushed(AllSeqEvents[I]);
                PlayerEventImpulse[0] = 0;
                PPEvent.CheckActivate(self, self, false, PlayerEventImpulse);
                I++;
                // [Loop Continue]
                goto J0xE2;
            }
        }
        // End:0x144
        if(bTimesUp)
        {
            bInvoluntaryJump = true;
        }
        nPushes++;
        //return;        
    }

    function PlayAnimation()
    {
        PlayITPAnimAtRate(fAnimRate);
        //return;        
    }

    function StopAnimation()
    {
        bIsPlaying = false;
        SetAnimRate(0.0000000);
        PlayAnimation();
        //return;        
    }

    function PlayITPAnimAtRate(float DesiredRate)
    {
        local AnimNode AnimNode;
        local float DesiredPosition;

        AnimNode = FPArms.Animations.FindAnimNode('playerAnim');
        // End:0x75
        if((AnimNode != none) && AnimNodeSequence(AnimNode) != none)
        {
            DesiredPosition = GetCurrentITPAnimPosition();
            AnimNode.PlayAnim(false, DesiredRate, DesiredPosition);            
        }
        //return;        
    }
    stop;    
}

state BRFInTheBriefing
{
    function BeginState(name PreviousStateName)
    {
        LoadBRFAnimTreeAndSet();
        Mesh.SetLightEnvironment(none);
        FPArms.SetLightEnvironment(none);
        HideWeapon(false);
        SetWeaponDisabled(true);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        //return;        
    }

    simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        out_ViewRotation += out_DeltaRot;
        out_DeltaRot = rot(0, 0, 0);
        out_ViewRotation = MOHAPlayerController(Controller).LimitViewRotationPitchAndYaw(out_ViewRotation - CameraRotation, fBriefingViewPitchMin, fBriefingViewPitchMax, fBriefingViewYawMin, fBriefingViewYawMax) + CameraRotation;
        SetViewRotation(out_ViewRotation);
        //return;        
    }

    simulated function LoadBRFAnimTreeAndSet()
    {
        LoadAnimSetAndTree(ViewModelITPAnimset, ViewModelITPAnimTree);
        InitSkeletalControls();
        //return;        
    }

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        local bool retval;

        // End:0x33
        if(!IsFirstPerson())
        {
            retval = super(MOHAPlayerPawn).CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);            
        }
        else
        {
            GetActorEyesViewPoint(out_CamLoc, out_CamRot);
            FPArms.GetSocketWorldLocationAndRotation(CameraSocketNameITP, out_CamLoc, CameraRotation);
            retval = true;
        }
        return retval;
        //return ReturnValue;        
    }

    simulated function Rotator GetViewRotation()
    {
        // End:0x1A
        if(Controller != none)
        {
            return Controller.Rotation;
        }
        return Rotation;
        //return ReturnValue;        
    }
    stop;    
}

state ITPFalling
{
    function bool IsITPActive()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
    {
        FPArms.GetSocketWorldLocationAndRotation(CameraSocketNameITP, out_CamLoc, out_CamRot);
        // End:0x43
        if(bITPDebugCam == true)
        {
            ITPCamDebug(out_CamLoc, out_CamRot, out_CamRot);
        }
        return true;
        //return ReturnValue;        
    }

    simulated event Vector GetPawnViewLocation()
    {
        local Vector vOut;

        // End:0x33
        if((FPArms == none) || !FPArms.GetSocketWorldLocationAndRotation(CameraSocketNameITP, vOut))
        {
            return super(MOHAPlayerPawn).GetPawnViewLocation();
        }
        return vOut;
        //return ReturnValue;        
    }

    simulated function Rotator GetViewRotation()
    {
        return Controller.Rotation;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        ViewPitchMin = -16384.0000000;
        SetAnimRate(0.5000000);
        fCurrentAnimTime = 0.0000000;
        // End:0x3D
        if(!bInvoluntaryJump)
        {
            ITP_JumpVoluntaryEvent();            
        }
        else
        {
            ITP_JumpInvoluntaryEvent();
        }
        SetCollision(true, true, true);
        bCollideWorld = true;
        SetWeaponDisabled(true);
        FPArms.LightingChannels.Characters_Weapons_Vehicles = true;
        FPArms.LightingChannels.CompositeDynamic = true;
        FPArms.LightingChannels.In_The_Plane_Characters = false;
        // End:0x128
        if(AirdropParachuteMesh != none)
        {
            AirdropParachuteMesh.PlayerParachuteMesh.LightingChannels.Characters_Weapons_Vehicles = true;
            AirdropParachuteMesh.PlayerParachuteMesh.LightingChannels.CompositeDynamic = true;
            AirdropParachuteMesh.PlayerParachuteMesh.LightingChannels.In_The_Plane_Characters = false;
        }
        WorldInfo.GameModified_bTurnOffMotionBlur = false;
        Mesh.SetLightEnvironment(self.LightEnvComponent);
        FPArms.SetLightEnvironment(self.LightEnvComponent);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        SetWeaponDisabled(false);
        AirdropParachuteMesh.ChuteButton();
        //return;        
    }
    stop;    
}

defaultproperties
{
    fDefaultActivityBlendTime=0.2500000
    HipsBoneName="HipsOffset"
    HipsOffsetControlName="HipControl"
    HipsOffsetControlRollName="HipControl_Roll"
    ProceduralLagControlName="LagControl"
    RightPropBoneName="RightProp"
    Default_AnimSet=AnimSet'ViewModel_Animset.VM_AnimSet_NoBazooka'
    Default_AnimTree=AnimTree'ViewModel_AnimTree.VM_Tree'
    StanceCollisionHeights[0]=96.0000000
    StanceCollisionHeights[1]=49.0000000
    StanceCollisionHeights[2]=27.0000000
    StanceCollisionRadii[0]=40.0000000
    StanceCollisionRadii[1]=40.0000000
    StanceCollisionRadii[2]=40.0000000
    bUseLeftFoot=true
    bUseProceduralLag=true
    bSkippedITP=true
    StanceChangeSounds[0]=none
    StanceChangeSounds[1]=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_Crouch2Prone'
    StanceChangeSounds[2]=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_Crouch2Stand'
    StanceChangeSounds[3]=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_Prone2Crouch'
    StanceChangeSounds[4]=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_Prone2Stand'
    StanceChangeSounds[5]=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_Stand2Crouch'
    StanceChangeSounds[6]=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_Stand2Prone'
    AnimatedStanceHeights[0]=161.0000000
    AnimatedStanceHeights[1]=96.0000000
    AnimatedStanceHeights[2]=38.0000000
    AnimatedStanceHeights3rdPerson[0]=20.0000000
    AnimatedStanceHeights3rdPerson[2]=38.0000000
    fStanceHeightRestoreForce=3.0000000
    fStanceChangeInTime=0.0500000
    AnimatedStanceChangeTimes[1]=0.7000000
    AnimatedStanceChangeTimes[2]=0.7000000
    AnimatedStanceChangeTimes[3]=0.7000000
    AnimatedStanceChangeTimes[4]=1.7667000
    AnimatedStanceChangeTimes[5]=0.7000000
    AnimatedStanceChangeTimes[6]=1.5333000
    GotHitSnd=SoundCue'Aud_GCm_FakeWAV.PlaceHolder.PlaceHolder'
    DeathSnd=SoundCue'Aud_GCm_FakeWAV.PlaceHolder.PlaceHolder'
    CameraScale=12.0000000
    fDefaultViewmodelFOV=80.0000000
    fStrafeSpeedMult=0.8500000
    fStrafeSpeedMult_Leaning=0.5000000
    fBackwardSpeedMult=0.7200000
    fSprintSpeedMult=1.3500000
    StanceSpeedMult[0]=1.0000000
    StanceSpeedMult[1]=0.5500000
    StanceSpeedMult[2]=0.2300000
    fMaxDeceleration=1000.0000000
    fIronSightsSpeedMult=0.5000000
    fMinFallSpeedForLandedSound=0.2000000
    FootstepFrequency=6.3000000
    LadderFootstepFrequency=15.0000000
    MaxFootstepInterval=0.5000000
    MaxLadderFootstepInterval=1.0000000
    FootstepSpeedThreshold=10.0000000
    FootstepSprintInterval=0.2800000
    FirstFootstepInterval=0.1000000
    LeftFootLocation=(X=0.0000000,Y=-25.0000000,Z=10.0000000)
    RightFootLocation=(X=0.0000000,Y=25.0000000,Z=10.0000000)
    DefaultHealthSettings[0]=600.0000000
    DefaultHealthSettings[1]=500.0000000
    DefaultHealthSettings[2]=400.0000000
    fImmuneTimeAfterDamageSettings[0]=0.2500000
    fImmuneTimeAfterDamageSettings[1]=0.1500000
    fInCoverDamageScale=0.7500000
    fExposedDamageScale=1.0000000
    fAirdropDamageScale=0.2500000
    fBulletFilteredPct_Settings=(X=0.5000000,Y=0.5000000)
    LeanInSnd=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_LeanIn'
    LeanOutSnd=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_LeanOut'
    PeekInSnd=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_PeekIn'
    PeekOutSnd=SoundCue'Aud_GCm_FakeWAV.StanceChanges.StanceChange_PC_PeekOut'
    LeanOutSndThreshold=0.5000000
    LeanInSndThreshold=0.0500000
    PeekOutSndThreshold=30.0000000
    PeekInSndThreshold=10.0000000
    fIronsightsMaxRoll=3000.0000000
    fIronsightsMaxLean=90.0000000
    fIronsightsLeanRestoreForce=3.5000000
    fIronsightsHeightRestoreForce=3.5000000
    fIronsightsPeekScale=1.0000000
    fLeanCollisionBuffer=10.0000000
    fHardJumpLandingSpeed=1000.0000000
    fMaxJumpCameraOffset=8.0000000
    fAnimatedJumpThreshold=1.0100000
    fProceduralJumpRestoreForce=8.0000000
    fProceduralJumpLandRestoreRate=80.0000000
    fMinDistForFallBlend=75.0000000
    fJumpStartAnimTime=0.3300000
    fJumpEndSoftAnimTime=0.5667000
    fJumpEndHardAnimTime=0.7333000
    fShoulderLagRestoreForce_Y=4.0000000
    fShoulderLagRestoreForce_Z=4.0000000
    fMaxShoulderLag_Y=4.0000000
    fMaxShoulderLag_Z=2.5000000
    fMaxShoulderLag_Aim_Y=0.1200000
    fMaxShoulderLag_Aim_Z=0.0900000
    fShoulderLagSensitivity_Y=0.0005000
    fShoulderLagSensitivity_Z=0.0005000
    fShoulderLagSensitivity_Aim_Y=0.0010000
    fShoulderLagSensitivity_Aim_Z=0.0005000
    fShoulderLagRestoreForce_Y_Mouse=4.0000000
    fShoulderLagRestoreForce_Z_Mouse=4.0000000
    fShoulderLagSensitivity_Y_Mouse=0.0002000
    fShoulderLagSensitivity_Z_Mouse=0.0002000
    fShoulderLagSensitivity_Aim_Y_Mouse=0.0005000
    fShoulderLagSensitivity_Aim_Z_Mouse=0.0002500
    fDeathFadeOutTime=1.0000000
    fRespawnFadeInTime=1.0000000
    fDeathFadeOutDelay=1.0000000
    fScriptedDeathFadeOutTime=0.8000000
    fMeleeMissAcceleration=1000.0000000
    WeaponAttachmentSocket="RightGun"
    ShellShockMixSelect=SoundRiotMixSelect'Aud_GCm_MixSnapshot.ShellShock_Fader'
    DialogueDuckMix=SoundRiotMixSelect'Aud_GCm_MixSnapshot.Dialogue_Duck'
    // Reference: AudioComponent'Default__MOHAPlayerPawn.ShellShockSoundComponent'
    begin object name=ShellShockSoundComponent class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'Aud_GCm_FakeWAV.Items.ShellShock_OneShot'
    end object
    ShellShockSound=ShellShockSoundComponent
    // Reference: AudioComponent'Default__MOHAPlayerPawn.NonRealtimeAudio'
    begin object name=NonRealtimeAudio class=Class'Engine.AudioComponent'
        bNonRealtime=true
    end object
    NonRealtimeAudio=NonRealtimeAudio
    fNoDamageNumStories=2.0000000
    fFullDamageNumStories=4.0000000
    fSingleStoryDistance=400.0000000
    FallDamageSoundCue=SoundCue'Aud_GCm_FakeWAV.Vocal.Drop_Damage'
    fSprintFOV=95.0000000
    fSprintZoomInRate=30.0000000
    fSprintZoomOutRate=50.0000000
    fSprintMotionBlurAmount=0.7500000
    SprintSoundMix=SoundRiotMixSelect'Aud_GCm_MixSnapshot.Sprint_Fader'
    fVergeOfDeathHealthPct=0.2300000
    fHealthPackDropHealthPct=0.2500000
    fAirDropDeployChuteAnimTime=2.8300000
    fAirDropDeployChuteAnimTimeMultiplayer=0.5000000
    fAirDropControlledFallAnimTime[0]=3.3333000
    fAirDropControlledFallAnimTime[1]=1.3333000
    fAirDropControlledFallAnimTime[2]=1.3333000
    fAirDropControlledFallAnimTime[3]=1.3333000
    fAirDropControlledFallAnimTime[4]=1.3333000
    fAirDropLandingAnimTime[0]=3.3667000
    fAirDropLandingAnimTime[1]=3.3667000
    fAirDropLandingAnimTime[2]=3.3667000
    fAirDropLandingAnimTime[3]=3.3667000
    fAirDropLandingAnimTime[4]=3.3667000
    fAirDropLandingAnimTime[5]=0.8667000
    fAirDropLandingAnimTime[6]=0.5000000
    fAirDropLandedAnimTime=2.7667000
    fAirdropRemoveGearAnimTime=2.7667000
    fAirdropCutChuteAnimTime=1.8667000
    fAirdropMeleeAnimTime=1.5000000
    // Reference: MOHASkeletalMeshComponent'Default__MOHAPlayerPawn.FPMeshComponent0'
    begin object name=FPMeshComponent0 class=Class'MOHASkeletalMeshComponent'
        fCustomBoundsSize=1000.0000000
        SkeletalMesh=SkeletalMesh'ViewModel_Mesh.SkeletalMesh.VM_Arms'
        AnimTreeTemplate=AnimTree'ViewModel_AnimTree.VM_Tree'
        AnimSets[0]=AnimSet'ViewModel_Animset.VM_AnimSet_NoBazooka'
        AnimSets[1]=AnimSet'ViewModel_Animset.VM_AnimSet_Bazooka'
        bUpdateSkelWhenNotRendered=true
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAPlayerPawn.MyLightEnvironment'
        DepthPriorityGroup=2
        CastShadow=false
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
    end object
    FPArms=FPMeshComponent0
    eLandingType=6
    // Reference: WhizComponent'Default__MOHAPlayerPawn.whiz'
    begin object name=whiz class=Class'WhizComponent'
    end object
    whiz=whiz
    CurrentCameraScale=1.0000000
    // Reference: CylinderComponent'Default__MOHAPlayerPawn.LeanCollisionCylinder'
    begin object name=LeanCollisionCylinder class=Class'Engine.CylinderComponent'
        CollisionHeight=0.0000000
        CollisionRadius=0.0000000
        CollideActors=true
        BlockActors=true
    end object
    LeanCollisionComponent=LeanCollisionCylinder
    vDesiredAnimOffset_AS=(X=-11.1600000,Y=-17.6800000,Z=0.0000000)
    vCurrentAnimOffset_AS=(X=-11.1600000,Y=-17.6800000,Z=0.0000000)
    fAiLodCullDist_AirDrop=6000.0000000
    fAiLodCullDist_OnGround=6000.0000000
    AiLodNonStasisClamp_AirDrop=10
    Stim_TakingLightDamage=CCStimulusType'MOHA_CC.Stimuli.TakingLightDamage'
    Stim_DamageFromBehindShot=CCStimulusType'MOHA_CC.Stimuli.DamageFromBehindShot'
    // Reference: AudioComponent'Default__MOHAPlayerPawn.AirdropBGSound'
    begin object name=AirdropBGSound class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'Aud_Hus_FakeWAV.backgrounds.Airdrop_BG_Loop'
    end object
    Airdrop_BG_Loop=AirdropBGSound
    // Reference: AudioComponent'Default__MOHAPlayerPawn.AirdropWindSound'
    begin object name=AirdropWindSound class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'Aud_GCm_FakeWAV.PlaceHolder.PlaceHolder'
    end object
    Airdrop_WindVolumeLoop=AirdropWindSound
    AirdropLookUpDownOffset=1.0000000
    BlendOutAirdropViewTime=0.5000000
    AirdropFallingPitchTarget=2000
    CameraSocketName="Cam"
    CameraSocketNameITP="CamITP"
    PushAnimName="playerpush"
    ITPLevelName="Husky"
    ITPAnimMuxNodeName="ITPAnimMux"
    fITPViewYawMin=-10923.0000000
    fITPViewYawMax=10923.0000000
    fITPViewPitchMin=-7500.0000000
    fITPViewPitchMax=16384.0000000
    fBriefingViewPitchMin=-7500.0000000
    fBriefingViewPitchMax=16384.0000000
    fBriefingViewYawMin=-10923.0000000
    fBriefingViewYawMax=10923.0000000
    fDebugSkipWorldTimeVal=30.0000000
    backVec=(X=0.0000000,Y=-1.0000000,Z=0.0000000)
    // Reference: MOHASkeletalMeshComponent'Default__MOHAPlayerPawn.clipMesh'
    begin object name=clipMesh class=Class'MOHASkeletalMeshComponent'
        FOV=65.0000000
        SkeletalMesh=SkeletalMesh'GCm_Wpn_US_ITP_RipLine.SkeletalMesh.US_ITP_RipLine_Player'
        CastShadow=false
    end object
    ITPClipMesh=clipMesh
    // Reference: MOHAWeaponUpgradeManager'Default__MOHAPlayerPawn.UpgradeManager'
    begin object name=UpgradeManager class=Class'MOHAWeaponUpgradeManager'
    end object
    WeaponUpgradeManager=UpgradeManager
    AimAtSocketName="AimAtSocket"
    DPSInterval=120.0000000
    fMaxNPCBlockedTime=0.4000000
    fMaxGTFONPCBlockedTime=0.2500000
    DefaultAmmoLoadout[0]=(AmmoClass=Class'MOHASMGAmmoClass',StartingReserveAmmo=250,MaxReserveAmmo=390)
    DefaultAmmoLoadout[1]=(AmmoClass=Class'MOHAMKIIFragGrenadeAmmoClass',StartingReserveAmmo=4,MaxReserveAmmo=8)
    DefaultAmmoLoadout[2]=(AmmoClass=Class'MOHASniperAmmoClass',StartingReserveAmmo=25,MaxReserveAmmo=50)
    DefaultAmmoLoadout[3]=(AmmoClass=Class'MOHAPistolAmmoClass',StartingReserveAmmo=50,MaxReserveAmmo=100)
    DefaultAmmoLoadout[4]=(AmmoClass=Class'MOHARifleAmmoClass',StartingReserveAmmo=40,MaxReserveAmmo=120)
    DefaultAmmoLoadout[5]=(AmmoClass=Class'MOHAGammonGrenadeAmmoClass',StartingReserveAmmo=3,MaxReserveAmmo=5)
    DefaultAmmoLoadout[6]=(AmmoClass=Class'MOHAStickGrenadeAmmoClass',StartingReserveAmmo=4,MaxReserveAmmo=8)
    DefaultAmmoLoadout[7]=(AmmoClass=Class'MOHARocketAmmoClass',StartingReserveAmmo=3,MaxReserveAmmo=7)
    DefaultAmmoLoadout[8]=(AmmoClass=Class'MOHAShotgunAmmoClass',StartingReserveAmmo=40,MaxReserveAmmo=80)
    DefaultAmmoLoadout[9]=(AmmoClass=Class'MOHAAutoRifleAmmoClass',StartingReserveAmmo=200,MaxReserveAmmo=390)
    // Reference: MOHAAirdropComponent'Default__MOHAPlayerPawn.MyAirdropComponent'
    begin object name=MyAirdropComponent class=Class'MOHAAirdropComponent'
    end object
    AirdropComponent=MyAirdropComponent
    SocketName="ReferencePlayer"
    RefBoneName="Spine"
    fAnimRate=1.0000000
    PawnSide=0
    // Reference: AxonScriptEventObserverComponent'Default__MOHAPlayerPawn.AxonObserver0'
    begin object name=AxonObserver0
    end object
    AxonObserver=AxonObserver0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAPlayerPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    WalkableFloorZ=0.6900000
    bCanClimbLadders=true
    bCanPickupInventory=true
    GroundSpeed=490.0000000
    AirSpeed=900.0000000
    LadderSpeed=300.0000000
    JumpZ=690.0000000
    Health=500
    Mesh=FPMeshComponent0
    // Reference: CylinderComponent'Default__MOHAPlayerPawn.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=96.0000000
        CollisionRadius=40.0000000
    end object
    CylinderComponent=CollisionCylinder
    ViewPitchMin=-16300.0000000
    InventoryManagerClass=Class'MOHAInventoryManager'
    // Reference: SpriteComponent'Default__MOHAPlayerPawn.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: ArrowComponent'Default__MOHAPlayerPawn.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=MyLightEnvironment
    Components[4]=AxonObserver0
    Components[5]=FPMeshComponent0
    Components[6]=MyAirdropComponent
    Components[7]=whiz
    Components[8]=UpgradeManager
    Components[9]=LeanCollisionCylinder
    Components[10]=AirdropBGSound
    Components[11]=ShellShockSoundComponent
    Components[12]=AirdropWindSound
    Components[13]=NonRealtimeAudio
    ActorType=3
    CollisionComponent=CollisionCylinder
    CollisionType=0
    SupportedEvents=/* Array type was not detected. */
}