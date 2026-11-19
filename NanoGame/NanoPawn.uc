/**
 * NanoPawn
 *
 * need to get the correct "PlaySound" functionality figured out.  Gears ended up having like 5 ways to play sounds all of which were slightly different
 * right now we just use PlayerController(Controller).PlaySound() so it is easy to replace
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn extends NanoPawnBase
	implements( NanoInterface_Targetable, NanoInterface_SlickifyAffect, NanoInterface_GreyGooGrabbyAffect, NanoInterface_PowerAffect, NanoInterface_MagLev)
	dependson(NanoDamageType, NanoTypes)
	config(Pawn)
	native(Pawn)
	abstract;

var(Debug) bool bSteveTest;
var(Debug) Name	DebugCameraBone;
var(Debug) Vector DebugLastIdealCameraBoneLoc;
var(Debug) Vector DebugDeltaIdealCameraBoneLoc;
var(Debug) Rotator DebugLastIdealCameraBoneRot;
var(Debug) Rotator DebugDeltaIdealCameraBoneRot;
var(Debug) bool	bDebugHideHead;

var transient bool bJumpSetIsDirty;

var transient AnimNodeAdditiveBlending GunAdditiveBlendNode;
var transient AnimNodeSequence GunAdditiveSeqNode;
var transient float CachedGunAdditiveBlendOutTime;

var transient AnimNodeAdditiveBlending RecoilAdditiveBlendNode;
var transient AnimNodeSequence RecoilAdditiveSeqNode;

var transient AnimNodeAdditiveBlending SprintLeanAdditiveNode;

var transient AnimNodeAimOffset HandGunAimOffset;

var transient SkeletalMeshComponent RootAttachmentComponent;
var transient Name RootAttachmentBoneName;
var transient float RootAttachmentInterpRate;
var transient float RootAttachmentInterpDuration, RootAttachmentInterpTime;

/** Current desired amount of cloth sim to blend into the graphics */
var float DesiredClothBlend;
/** How quickly the cloth blend can decrease */
var float ClothBlendDownRate;
/** How quickly the cloth blend can increase */
var float ClothBlendUpRate;

var transient bool bSlideOnLanding;
var transient bool bSliding;

var transient SplineActor SplineBase;
var transient int SplineComponentIdx;
var transient float SplineBaseVelocity;
var transient float DistAlongSpline;
var transient float TimeAlongSpline;
var transient bool bReachedFirstSplineActor;

var transient float ForceSprintTimer;

/** Velocity to be added after CalcVelocity, beyond the normal maxspeed clamping */
var transient array<AccelCurve>	AccelCurves;
var transient float OverriddenMaxSpeed;
var transient float	OverriddenMaxAccel;

var transient bool bDebugInvisToAI;

var transient bool bHasBaton;
var transient bool bThrowingTesla;
var transient bool bDeployingTesla;

//////////  start nano vars  //////////

/** Actor we are forced to be based on unless teleported. This is a hack to keep the Pawn on certain actors that the physics or server correction will occasionally insist we should detach from. */
var transient Actor ClampedBase;

var transient NanoLadderBase CurrentLadder;
var transient bool bClimbingUp;
var transient float DistanceClimbed;

var transient NanoTurbineBase CurrentTurbine;

/** How much is this pawn worth if killed? */
var config int BaseXPValue;
var transient float TimeOfFirstHit, TimeOfLastKill;
var transient int LastSwordComboCount;

var transient bool bLockPawnRotation;

/**
 * The duration of the Melee attack animation.  We use this to help hint to the AI to not attack the player
 * when there is an overly long animation playing.  (It is not fun to be smacked when you are waiting for your animation to end.
 **/
var transient float MeleeAttackAnimDuration;


/** Name of 1st person camera bone to use for ideal camera location */
var Name FirstPersonCamBoneName;
/** Name of 3rd person camera bone to use for ideal camera location */
var Name ThirdPersonCamBoneName;
/** Name of bone to adjust for obstacle awareness */
var Name AwarenessBoneName;
/** List of bones to use in HandleCameraSafeZone().  These will be used to determine how fast the camera should blend */
var array<name>     CheckCameraBoneNames;

var transient class<NanoWeaponBase> PendingWeaponClass;

/** Current amount of nano power */
var	private transient	float	NanoPower;
/** Maximum allowed nano power */
var transient	float	MaxNanoPower;
/** How quickly nano power recovers */
var config		float	NanoRecoveryRate;
/** Delay before we start recharging nano power */
var config		float	NanoRecoveryDelay;
/** When we last used nano power */
var transient	float	LastNanoPowerUseTime;

var config      float   NanoPowerBucketSize;
var config      float   NumOfNanoPowerBuckets;
var config      float   NumStartingNanoPowerBuckets;

/** how much it to create a nano item */
var config		float	NanoItemCreation;


/** Current amount of nano power forge core */
var	private transient	float	NanoPowerForgeCore;
/** Maximum allowed nano power forge core */
var transient	float	MaxNanoPowerForgeCore;

var config      float   NanoPowerForgeCoreBucketSize;
var config      float   NumOfNanoPowerForgeCoreBuckets;
var config      float   NumStartingNanoPowerForgeCoreBuckets;

/** The pawn's current NanoState **/
var transient ENanoState CurrNanoState;
/** If the current nano state change was forced upon us */
var transient bool bEnforcedNanoStateChanged;

/** Points that build up as you do damage and combos, and can be spent on uber-moves. */
var transient	float		ComboPoints;
/** The last time we gained combo points - used to judge when to start decaying */
var transient	float		ComboLastGainTime;
/** How many combo points you get for successfully hitting an enemy */
var config		float		ComboPointsPerHit;
/** How long after hitting an enemy that combo points start to decay */
var config		float		TimeBeforeComboPointDecay;
/** How quickly (points-per-second) combo points decay */
var config		float		ComboPointDecayRate;
/** Extra multiplier used for attacks done as part of a combo. */
var config		float		ComboPointComboBonus;


/** Skydiving vars */
/** Whether or not we're currently skydiving */
var transient bool    bIsSkydiving;
var float                       SkydiveMinDuration;
/** Maximum amount of radial blur to have when skydiving */
var float                       SkydivingMaxBlur;
/** Radial blur for skydiving */
var protected transient RadialBlurComponent RB_Skydive;

/** Sounds for skydiving */
var protected SoundCue SkydivingSound;
var protected transient AudioComponent AC_Skydiving;

/** Whether or not we're doing a controlled target jump (via AttemptBigJump) */
var transient bool    bIsControlledJump;

/** Whether or not we're currently performing a platforming jump */
var transient bool    bIsPlatformJumping;

/** Whether or not we're currently sucked in a transporter fan */
var protected transient bool    bInDuctFan;

var protected SoundCue RunThroughDustifyEnemySoundCue;


var protected config float AutoDropTheHammerFallThreshold;
/** If we are doing the in air freeze for Dropping the hammer **/
var transient bool bInAirFreezeForDropTheHammer;
/** After you drop the hammer you are not allowed to move for 1 second **/
var transient bool bStuckAfterDroppingTheHammer;

/** If we are forging, we slow down some all anime style **/
var transient bool bSlowVelocityDueToForging;
/** How much slower we go when when forging **/
var config float SlowVelocityDueToForgingAmount;

///////////// Ragdoll
var		transient	Array<AnimNodeSequence>		ResumePlayNodes;

struct native PawnPhysicsImpulseInfo
{
	/** Linear velocity to apply to entire rigid body. */
	var vector LinearVelocity;
	/** Angular velocity to apply to entire rigid body. */
	var vector AngularVelocity;

	/** World-space origin of radial impulse. */
	var vector RadialOrigin;
	/** Radius of radial impulse.  If 0.0, no radial impulse will be applied. */
	var float RadialRadius;
	/** Strength of radial impulse. If 0.0, no impulse will be applied. */
	var float RadialStrength;
	//var float RadialFalloff;		// assume RIF_Linear

	/** Point impulse to apply.  if 0,0,0, no point impulse will be applied.  */
	var vector PointImpulse;
	/** Position in world space at which PointImpulse should be applied. */
	var vector PointImpulsePosition;
	/** Bone that receives point impulse. */
	var Name PointImpulseBoneName;
};

var repnotify PawnPhysicsImpulseInfo KnockdownImpulse;
var vector KnockdownStartingPosition;
var bool bCheckKnockdownFall;
/** whether we are able to be knocked down at all */
var config bool bCanBeKnockedDown;

/** Anim to play when knocked down */
//var BodyStance BS_KnockDownAnim;
/** Whether to play animtion through physics motors when knocked down */
var	bool	bPlayMotorAnimOnKnockDown;
/** Strength of motors to use for knock-down anim */
var()	float	KnockDownMotorStrength;
/** Damping of motors to use for knock-down anim */
var()	float	KnockDownMotorDamping;
/** How motor strength varies over time after knockdown ('time since knockdown' is input, 'motor scale' is output) */
var()	InterpCurveFloat	KnockDownMotorScale;
/** Time (WorlInfo.TimeSeconds) that we were knocked down */
var		float	KnockDownStartTime;
/** Time (WorldInfo.TimeSeconds) to recover from current knockdown */
var		float		RecoverFromRagdollTime;

var(Ragdoll) float RagdollAngularMotorSpring;
var(Ragdoll) float RagdollAngularMotorDamping;
var(Ragdoll) float RagdollAngularMotorForceLimit;


var bool bBlendToGetUp;
var bool bGetUpFromBack;

var		float	GetUpBlendStartTime;
var()	float	GetUpBlendTime;
var()	float	GetUpAnimRate;
var()	float	GetUpAnimStartPos;

var()	Name	UpDownBoneName;
var()	EAxis	UpDownAxis;
var()	bool	bInvertUpDownBoneAxis;
var()	Name	OrientationBoneName;
var()	EAxis	OrientationAxis;

var()	INT		GetUpFromBackYawOffset;

/** If TRUE, ignore pawns when looking for a spot to get up */
var()	bool	bIgnorePawnsOnRecover;
/** If TRUE, when recovering from ragdoll, don't allow kicking of corpses any more */
var bool bDisableKicksCorpseAfterRecovery;

var transient HitReactionInfo	HitReaction;
var transient HitReactionInfo	DeathReaction;
var transient bool bDeathImpulseAdded;
var transient float RagdollTransitionTime;
var transient bool DeathSoundForPawnToPlay;

///////////// physics
/** Time after firing weapon before you can dash */
var config float WeaponFireDashDelay;
/** Last time we were dashing */
var transient float	LastDashingTime;
/** Time we started dashing */
var transient float	LastDashStartTime;

/** This is our AutoSaved AnchorPoint that is updated as we move around the world.  So when you fall off things you will get the auto recovery back to last "safe spot" */
var transient vector AnchorPoint;
var transient rotator AnchorPointRotation;

/** This is our testing AnchorPoint which can be set via the back button.  This allows to test jumping and moving around the world
 * @TODO:  Remove before ship
 **/
var transient vector TestingTeleportBackToAnchorPoint;
var transient rotator TestingTeleportBackToAnchorPointRotation;

var transient Actor	PulledTowardActor;
var transient bool	bActivePullTowardActor;

/** Force applied to thing we are standing on when dusted */
var	config		float	DustBaseForce;
/** Force applied to thing we are standing on in default state */
var config		float	NormalBaseForce;
/** Force applied to thing we are standing on when densed */
var config		float	DenseBaseForce;

var transient	float	DustGravityZScale;
var config		float	DenseGravityZScale;
var config		float	HammerGravityZScale;
var config		float	KnockbackGravityZScale;

var config		float	StepOffLedgeSlopeZ;

/** Play this sound if the user tries to summon and they don't have this unlocked **/
var protected SoundCue ReadiedNanoCreatedItemFailedToCreateSound;

/** If TRUE, weapons will be summoned instantly */
var config      bool    bInstantSummoning;

/** If TRUE, we are currently summoning a weapon. */
var transient bool bSummoningInProgress;

var transient float NanoPowerActivationTime;
var transient float NanoPowerExpiration;
var transient float NanoPowerDuration;
var transient float NanoPowerCooldownExpiration;

/** How long a Nanite Tornado creation point lasts.  We need a certain number of these and they need to be "Around" each other to cause a tornado. **/
var config float NaniteTornadoCreationPointDuration;
/** So here we have the count of Nanite Tornado moves we have done **/
var transient int NaniteTornadoCount;
/** The list of people we are trying to affect with the tornado **/
var transient array<Actor> NaniteTornadoTargets;

/** The effect to play when for the Nanite Tornado when it is ready **/
var ParticleSystem NaniteTornadoReadyEffect;

/** The effect that trails behind the Foes as they are thrown upward **/
var ParticleSystem PS_NaniteTornadoEjectTrail;
var transient ParticleSystemComponent PSC_NaniteTornadoEjectTrail;

/** Tornado that _will_ suck this guy into the sky **/
var transient NaniteTornado NaniteTornadoFunnel;

/** How much velocity is imparted to the pawn from the nanite tornado **/
var config float NaniteTornadoUpVelocity;

/** This is who spawned the nanite tornado that is about to kill this guy **/
var transient Controller NaniteTornadoInstigator;

/**
 *  We need to have this flag to tell us if the pawn has been affectd by a tornado.  We need this as we use the "touch" event to determine
 *  this and that occurs during the physFalling tick cycle.  So for example:  you are being juggled into a tornado you will get the Touch
 *  during moveactor and then the physFalling will overwrite this at the end.
 *
 **/
var transient NaniteTornado AffectedByTornado;


// these need to move to the NanoPC
struct native UnlockedNanoPowersDatum
{
	var class<NanoMissionReward_UnlockNanoPowerBase> PowerType;
	/** Whether this is actually unlocked or not.  You can have an item but have not actually bought it from king yet **/
	var bool bActuallyUnlocked;
};

var array<UnlockedNanoPowersDatum> UnlockedNanoPowers;

/** Amount of time player has held the jump button since takeoff */
var float JumpHoldTime;
/** Amount to scale gravity by when player hold jump button */
var float JumpHoldGravityZScale;

var array<Actor>    IgnoreBlockingList;

//debug
var(Debug) transient float LastGravityZ;
var(Debug) transient float LastVel2D;


//////////////// anim
/** Reference to the seperate head mesh so we can not render it in first person - hidden flag handled by camera code */
var() SkeletalMeshComponent	HeadMesh;

// some of these probably just need to move down to the Player's base class
var	transient MaterialInstanceConstant	HeadMIC;
var	transient MaterialInstanceConstant	Head1MIC;
var	transient MaterialInstanceConstant	Head2MIC;
var	transient MaterialInstanceConstant	Head3MIC;
var	transient MaterialInstanceConstant	Head4MIC;

var	transient MaterialInstanceConstant	BodyMIC;
var	transient MaterialInstanceConstant	ArmMIC;

var	transient MaterialInstanceConstant	Scarf0MIC;
var	transient MaterialInstanceConstant	Scarf1MIC;


var transient float MaskMICValueCurr;
var transient float MaskMICValueGoal;
var transient float MaskMICValueBase, TimeToInterpMaskMIC, CurrentMaskMICInterpTime;

/** Sent from server to feed animation nodes. Aim is relative to Pawn. */
var vector2d	ReplicatedAimOffset;

var const transient bool    bRearAim;
/** Node used for aiming */
var transient array<NanoAnim_AimOffset>	AimNodes;
/** Profiles to handle different aim offsets/transitions/etc */
var array<NanoAimOffsetProfile> AimOffsetProfileList;
var const int                   AimOffsetProfileIdx;

/** Node for blending between fall and walk */
var transient NanoAnimBlendByPhysics PhysBlend;

/** Controller used for pitching mesh when on slope */
var transient editinline SkelControlSingleBone		MeshPitchController;
/** Used to twist wrist */
var transient editinline SkelControlSingleBone		RightWristControl;
var transient editinline SkelControlLimb			LeftWristAwarenessControl;

var(Awareness) const bool bAwarenessActive;
var(Awareness) Vector AwarenessOffsets;
var(Awareness) float  AwarenessTraceDistance;
var(Awareness) float  AwarenessImpactBuffer;

//debug
var	float DebugVelSize;
var	float DebugDistFromImpact;
var	float DebugTimeFromImpact;
var	float DebugPrepTimeRemaining;
var	float DebugPrepRate;
var float DebugLimbCtrlStrength;

/** Pitch applied to mesh root controller, to make it match slope when sliding/stabbed. */
var int MeshPitch;
/** Node to play anim on top half */
var editinline transient NanoAnimNodeSlot TopHalfSlot;
/** Node to play anim on whole body */
var editinline transient NanoAnimNodeSlot FullBodySlot;
/** Node to play anim on whole body when running */
var editinline transient NanoAnimNodeSlot RunningFullBodySlot;
/** Node to play anim on top half when running */
var editinline transient NanoAnimNodeSlot RunningTopHalfSlot;
/** Node to play anim on whole body when falling */
var editinline transient NanoAnimNodeSlot FallingFullBodySlot;
/** Node to play anim on whole body (running or falling) and then have aiming applied */
var editinline transient NanoAnimNodeSlot PreAimFullBodySlot;
/** Node played while sprinting and not holding a weapon */
var editinline transient NanoAnimNodeSlot UnarmedSprintSlot;
/** Node that contains jump/fall anim set info */
var editinline transient NanoAnimBlendByFall BlendFallNode;
/** Node that contains blend by speed when using sword info */
var editinline transient AnimNodeBlendBySpeed SwordBlendBySpeedNode;


/** Player used for running/tackled anim loop */
var editinline transient NanoAnimNodeSequence TackleRunSeqNode;

/** Stores references to any unique (non-preloaded) animsets added by Kismet via OnPlayAnim, so they can be cleaned up on completion */
var transient array<AnimSet>   Kismet_ActiveCustomAnimSets;

/** Time that we a released from a perch */
var transient float LastPerchReleaseTime;

/** Are we being limited to walking? */
var bool bForceWalkingSpeed;

/** == Dash/jump properties - BEGIN == */

/** Are we currently mid-dash? */
var transient bool bIsDashing;
var transient bool bWantsToDash;
var transient bool bWantsToShoot;

/** Are we currently bamfing? */
var transient bool bIsBamfing;
/** Are we currently jumping? */
var transient bool bIsJumping;

var config float SwordDistanceBuffer;

/** the generic "move me to my target" flag */
var transient bool bIsSwordDashing;
/** i'm actually doing a slide/dash/jump */
var transient bool bIsDoingDashAttack;
/** is trying to dash and stab into a mantle target*/
var transient bool bIsDoingStabMantle;
/** is trying to hop between cars */
var transient bool bIsDoingCarHop;
/** is actively doing a melee attack */
var transient bool bIsDoingMeleeAttack;
var transient bool bIsDoingAttack;
/** Past the fail transition point of the active melee attack - only valid if bIsDoingMeleeAttack == TRUE */
var transient bool bRecoveringFromMeleeAttack;
var transient bool bPreventJumpInMeleeAttack;
var transient bool bPreventRotationInputInMeleeAttack;
var transient bool bPreventMoveInMeleeAttack;
/** Push other actors around when moving */
var transient bool bActAsEncroacher;

/** Set during a mantling move */
var array<Name> Mantles;
var transient EMantleType	MantleState;
var transient vector PreMantleVelocity;
var transient bool bFallingFromMantle;
var transient bool bHandspringJump;
var transient vector MantleDir;
var transient float LastMantleTime;
var transient float LastMantleAnimRate;

var config float DashAttackAccelRate;
var config float DashAttackMaxVelocity;
var config float JumpAttackAccelRate;
var config float JumpAttackMaxVelocity;
var config float CarDashAccelRate;
var config float CarDashMaxVelocity;

/** What time did we last perform a jump */
var transient float LastJumpTime;
/** Last time we landed on the floor */
var transient float LastLandingTime;

/** 2D direction we were facing when we last jumped */
var transient Vector LastJumpDir;
/** How long after a jump you can do a sword attack */
var config float PostJumpSwordAttackTime;

var float FlySpeed;

/** This effort is played when the character does the dash attack **/
var SoundCue DashAttachEffortCue;
/** This effort is played when the character does the final attack after at least 2 dashes **/
var SoundCue DashAttachEffortFinalCue;

var transient float LastFallOffLedgeTime;
var transient float StartFallingTime;
var transient vector StartFallingLocation;
var transient float LastFallingDuration;
var transient vector LastSafeLocation;
var transient float LastFallingDistance;
var transient float	DistanceToFloor;

/** Information for replication in the next server move @see NanoSavedMove */
var transient vector LastWallJumpNormal;
var transient bool bLastJumpWasForward;

var transient float LastFailedJumpAttemptTime;

/** Landing sounds **/
var protected float DurationInAirToPlayAMediumLandSound;
var protected float DurationInAirToPlayALargeLandSound;
var protected SoundCue LandedSmallCue;
var protected SoundCue LandedMediumCue;
var protected SoundCue LandedLargeCue;
var protected SoundCue BodyMovementWalkCue;

var transient bool bBRINGDAHAMMER;

/** When going to ranged combat this pawn prefers to use this weapon. **/
var class<NanoWeaponBase> PreferredRangedWeaponClass;

/** Struct used to hold amount of ammo on Pawn for a specific weapon */
struct native AmmoStashInfo
{
	/** Class of weapon this ammo is for */
	var class<NanoWeaponBase>   WeapClass;

	/** Amount of ammo */
	var int                 Ammo;
};

/** Spare ammo carried. Because guns can be forged, this lives on the pawn and not in the gun. Given to weapon on equip. */
var array<AmmoStashInfo>    AmmoStash;

enum ENanoPerchMode
{
	ENPM_None,
	ENPM_PerchPoint,
	ENPM_Car
};

/** ANIMTREE: Which perch pose to use */
var transient ENanoPerchMode PerchingMode;

/** TRUE when pawn is impaled on sword projectile */
var transient bool bImpaledOnSword;

/** Various modes of aiming used by the NanoPawn */
enum ENanoPawnAimMode
{
	ENAM_Gun,
	ENAM_CameraOnly,
	ENAM_Sword
};

/** ANIMTREE: Current mode we are using to aim */
var transient ENanoPawnAimMode CurrentAimMode;

/** If true, air friction should be set to zero.  Useful for big jumps, or directing pawns towards target locations.  Reset in Landed(); */
var transient bool  bIgnoreAirFriction;

/** Air control settings, @see UpdateAirControl */
var config float	NormalAirControl;
var config float	FallingAirControl;
var config float	DustedAirControlModifier;
var config float	DensedAirControlModifier;
var config float	DashAttackAirControl;

/** Actor we are currently attracted to */
var transient Actor TargetedAttractionActor;

/** MagLev spline that currently has control over us **/
var transient NanoVehicleSpline_MagLev  CurrentMagLevAttractor;
/** Time that the pawn was last held in a maglev field **/
var transient float LastMagLevTime;
/** Previous amount of dodge in the maglev tunnel path, for clean blending **/
var transient vector LastMagLevDodgeAmount;

/** If TRUE, this pawn class can perform a tackle and grab another pawn by running in to them. */
var bool							bCanPerformTackle;
/** Time that taclke attachment happened */
var transient float					TackleStartTime;
/** Amount of time before autothrow for tackle */
var float							TackleAutoThrowDuration;
/** If TRUE, we are currently being held by another Pawn (see our Base) */
var transient bool					bAttachedToTackler;
/** If TRUE, we are currently holding and throwing a tackled actor */
var transient bool					bThrowingTackledActor;
/** If TRUE, we are wall slamming a tackled actor */
var transient bool					bSlammingTackledActor;
/** Damage done when tackling guy and hitting wall (not densed) */
var config int						WallSlamDamage;
/** How long before hitting somone we should play tackle anim */
var config float					PreTackleAnimTime;
/** How long before hitting wall to start playing slam anim */
var config float                    PreTackleSlamAnimTime;
/** Component used to play looping sound while holding an actor */
var AudioComponent                  TackleLoopAC;
var SoundCue                        StartTackleLungeBodySound;
var SoundCue                        StartTackleLungeEffortSound;

var SoundCue                        ThrowTackleBodySound;
var SoundCue                        ThrowTackleEffortSound;
var SoundCue                        ThrowTacklePainSound;
var	SoundCue						ThrowTackleFallingSound;

var SoundCue                        TackleSlamLungeBodySound;
var SoundCue                        TackleSlamLungeEffortSound;

var SoundCue                        TackleWallSlamBodySound;
var SoundCue                        TackleWallSlamPainSound;
var SoundCue                        TackleWallSlamDeadBodySound;

/** When this pawn is slashed by the sword play this pain sound **/
var SoundCue HitBySwordSound;
var SoundCue HitBySwordDismember300Sound;
var SoundCue HitBySwordAndKilledSound;
var SoundCue HitByElbowOrFootAndKilledSound;
var SoundCue HitByStaffSound;
var SoundCue HitByStaffAndKilledSound;

/** ANIMTREE: Magnitude of falling speed */
var transient float FallVelMag;

/** == Dash/jump properties - END == */

/** == Sword properties - BEGIN == */

/** If we are falling, but sliding down a surface */
var transient bool bSlidingDown;

/** If sword is not active, this is the last time the bIsSwordActive flag got set to false */
var transient float LastSwordActiveTime;
/** Whether our current jump is a dodge or not */
var transient bool	bDodging;
/** Whether recovering form dodge or not, true allows another dodge immediately */
var transient bool	bRecoveringFromDodge;
/** Whether currently playing a hit reaction or not */
var transient bool	bPlayingHitReaction;

/** ANIMTREE: Are we using the nano sword of justice to stick to a wall? */
var transient bool bIsAttachedToWall;

var transient vector PendingAttachDir;
var transient vector PendingForceNormal;

var transient bool	bPreparingStabMantle;

var transient bool  bStabMantling;
/** How close a stab target has to be for us to dash-stab it */
var config float StabDashMaxDist;


var protected SoundCue SwordAttachedToWallCue;
var protected SoundCue SoundDetachedFromWallCue;

var protected transient AudioComponent AC_SwordDraggingAlongSurface;
var protected SoundCue SwordDraggingAlongSurfaceCue;

var protected transient AudioComponent AC_FeetDraggingAlongSurface;
var protected SoundCue FeetDraggingAlongSurfaceCue;

var protected transient ParticleSystemComponent PSC_FootSlide;
var protected ParticleSystem PS_FootSlide;
var protected name FootSlideSocketName;

var bool bSlidingEffectsActive;
var bool bSwordSlidingEffectsActive;

/** Animation to play for tossing an item out of inventory **/
var protected name ThrowHeldItemAwayAnim;

/** Controls how fast we want to descend a wall when stuck into it with sword */
var transient float	WallStabThrottle;
/** Controls how much strafing we do when using sword on wall */
var transient float WallStabStrafe;

/** What time did we start attachment, used to scale the 'stickiness' over time, @see NewFallVelocity() */
var transient float WallAttachStartTime;

/** What was the normal of the wall that we attached to */
var transient vector WallAttachNormal;

/** */
var config float	WallSlideRepelVel;
/** Used to regulate the fall velocity when attached, @see NewFallVelocity() */
var config float	WallAttachMaxFallVelocity;
/** How fast you can strafe when on the wall, as a proportion of the falling vel. */
var config float	WallAttachMaxStrafeFactor;
/** Output - how much we are currently strafing on a wall */
var transient float	CurrentWallStabStrafeRatio;

/** How fast you slide down a wall, when not stabbed in */
var config float	WallSlideMaxFallVelocity;

/** How much does it cost to stick the nano sword of justice in the wall? */
var config int  	SwordAttachCost;

/** == Sword properties - END == */

/** Material effect used when sprinting */
var	transient MaterialEffect	SpeedPPEffect;
/** Material instance used by SpeedPPEffect. */
var transient MaterialInstanceTimeVarying SpeedPPMatInst;

var transient MaterialEffect ScreenPPEffect;
var transient MaterialInstanceTimeVarying ScreenPPMatInst;

/** Effect that blurs level when menu is up */
var transient DOFAndBloomEffect MenuBlurEffect;

/** Material effect used when in dust/dense state */
var	transient MaterialEffect	StatePPEffect;

/** Material effect used when in dust/dense state */
var	transient MaterialEffect	DamagedPPEEffect;

/** */
var protectedwrite transient MaterialEffect HealthPPEffect;
var protectedwrite transient MaterialInstanceConstant HealthOverlayMIC;


/** When we last touched a slickified surface **/
var transient float Slickify_TimeUntilSlickifiedSurfaceEnds;
/** Duration of the slickify speed effect **/
var config float Slickify_DurationOfSlickifySpeedEffect;

/** This is how much the friction of the surface is reduced by when on the slickify surface. **/
var config float SlickifyFrictionReductionAmt;

/** When we last touched a grabby surface **/
var transient float GreyGooGrabby_TimeUntilGrabbySurfaceEnds;
/** Duration of the grabby speed effect **/
var config float GreyGooGrabby_DurationOfGrabbySpeedEffect;


var array<delegate<DeathNotification> > DeathNotifyReceivers;



var transient bool bIsRechargingHealth;
var config float HealthRechargeDelay;
var config float HealthRechargePerSecond;
var config float HealthRechargeCostPerSecond;
var transient float HealthRegainAccum;

/** If we are touching a health totem or not. **/
var transient bool bTouchingHealthTotem;


/** These affect all incoming damage */
var config float DensedGlobalDamageScale;
var config float DustedGlobalDamageScale;

/** When you attack someone and change their state, how long this lasts for */
var config float StateChangeAttackStunDuration;

/** List of locks on our nano power usage */
var transient array<Name> NanoPowerLocks;

/** This holds the list of nanobombs that have been placed in the world **/
var transient array<NanoBombBase> NanoBombsInFlight;

/** Tail effects for targeted (tier3) dusting and densing **/
var() const protected ParticleSystem TargetedDustEffectTrail;
var() const protected ParticleSystem TargetedDenseEffectTrail;

/** Whether fake ghost/dense effects are active */
var bool bFakeGhostEffects;
var bool bFakeDenseEffects;

var SkeletalMeshComponent ShieldMeshComp;

var transient bool bLockedOnTarget;

var transient Actor ShatteredByActor;

/** Are we currently knocked down? */
var transient bool bKnockedDown;

/** Tracks information about a damage hit, assumed to be sorted by age where bottom == oldest */
struct native RecentHitInfo
{
	var Actor HitInstigator;
	var vector OriginOfHit;
	var float TimeOfHit;
	var int Damage;
	// used for the directional indicator on the HUD
	var MaterialInstanceConstant MatInst;
};
var transient array<RecentHitInfo> RecentHits;


struct native ActiveThirdPersonAnimDatum
{
	var AnimNodeSequence AnimSequence;
	var name AnimName;

};
var transient array<ActiveThirdPersonAnimDatum> ActiveThirdPersonAnims;

/** If we just did a wall jump.  We need to know this for a number of: "maintain / keep increaing dash level" type of things **/
var transient bool bJustDidWallJump;

/** Play this sound when we do not have enough nano juice for the action requested **/
var SoundCue NotEnoughNanoPowerSound;

/**
 * This was the NanoVolume_Fan that the pawn was previously in.   We keep this around to know when the pawn has left a fan volume so we can
 * give it some extra "boost" and air control at the top of the fan volume.
 **/
var transient NanoVolume_Fan PreviousFanVolume;

/** Whether the red screen warning is currently active (so we don't interfere with other camera fades) **/
var transient bool  bRedScreenWarningActive;
/** The time at which the RedScreenDeath Warning went up for the player. **/
var transient float RedScreenDeathWarningTime;
/** How long the player is given before they have been deemed to have had enough time to react to the red screen. **/
var config float RedScreenDeathReactionTime;

/** Mission giver that is currently briefing the pawn **/
var transient NanoPawn_Rebels_QuestGiverBase CurrentMissionBriefer;

/** How long since the pawn moved during the briefing **/
var transient float BriefingPawnIdleTime;
/** How long to wait before the pawn is considered idle during a briefing **/
var() float BriefingPawnIdleThreshold;

var() transient float LastGrabbedTime;
var() transient float LastGrabAttemptTime;
var() config float MinTimeBetweenGrabAttempts;
var() config float MinTimeBetweenGrabVictim;
var() config float AI_ChanceToAttemptGrab;

/** Sound for fluid spurting off a dismembered body part **/
var SoundCue DismemberSpurtingSound;
var SoundCue DismemberSpurtingDecapitateSound;
/** Effect for fluid spurting off a dismembered body **/
var ParticleSystem DismemberSpurtingEffect;


/** When a limb is sliced off sound **/
var SoundCue DismemberSound;

/** List of avail gore effects **/
var NanoGoreEffectCollection GoreEffects;

/** Gore camera focusing.  Set via NanoGoreManager, and processed in Cam3p_Melee::InterpolateCameraOrigin() */
var NanoPawn GoreCamTarget;
var name    GoreCamTargetBoneName;


var transient bool bUsingTPCombatCamera;

/** This is the effect that is playing when the Pawn is in a NanoPhysicsVolume **/
var transient ParticleSystemComponent PSC_InVolumeEffect;

/** Audio Component hold the in volume sound **/
var transient AudioComponent AC_InVolumeSound;

/** This means that the pawn has had something dismembered and is now going to die.  And is no longer "alive" per say. **/
var transient bool bDismemberedAndDying;

/** When the pawn is ejected from a vehicle, a reference is stored here for as long as we want to keep both in frame */
var protected transient Actor ElevatorEjectionTarget;

/** Whether or not we did a gore effect death **/
var transient bool bDidGoreEffectDeath;

var transient name PostDeathImpulseBoneName;
var transient vector PostDeathImpulseVector;


/** Whether or not we have done the transform to ragdoll.  We only want to do this once. **/
var transient bool bHasDoneDeathAnimRagDoll;

/////////////// SPECIAL MOVES ///////////////
/** Array of special moves */
var(SpecialMoves) editinline editconst Array<GameSpecialMoveInfo> SpecialMoves;

/** Special move currently performed by Pawn. SM_None, when doing none. */
var	transient Name					ActiveSpecialMoveName, PreviousSpecialMoveName;
var transient NanoSpecialMove		ActiveSpecialMove;
/** Special move pending, activated after the current one terminates. */
var transient SpecialMoveStruct		PendingSpecialMoveStruct;
/** Are we currently in the process of ending a special move, and should force new moves to delay? */
var transient bool			bEndingSpecialMove;
/** Set when starting PendingSpecialMove to maintain PrevMove reference for transitions. */
var protectedwrite transient bool bIsPendingMove;
/** Time at which last special move was started */
var transient FLOAT					PreviousSpecialMoveTime;
/** INT to pack any additional data into special moves, and get it replicated so it's consistent across network. */
var	transient			INT			SpecialMoveFlags;

/**
 * Special move currently performed by Pawn. '', when doing none. This is necessary
 * because the previous state of SpecialMove is used in DoSpecialMove(), so if the
 * network replication stuff just blows away SpecialMove on the client, then
 * the "from" specialmove information is lost and things no worky.
*/
var	transient repnotify SpecialMoveStruct		ReplicatedSpecialMoveStruct;

/** Actor ref used for special move interactions */
var transient Actor                 InteractionActor;


/** SKILLS VARIABLES */
var() array<SkillInfoItem> SkillList;
/** List of currently active skills */
var transient array<NanoSkill> ActiveSkills;
/** Array, indexed by ENanoSkills, of the state of each NanoSkill, used to replicate to all clients. 0 = Inactive, 1 = Active */
var repnotify private byte   ReplicatedSkillStatus[ENanoSkills.EnumCount];

/** List of owned and unlocked NanoPlans */
var() array<NanoPlan> ActivePlans;



/** If Pawn is allowed to do Floor conforming at all. */
var const	bool					bCanDoFloorConform;
/** If Pawn is currently allowed to do floor conforming. Would perform an interpolation if toggled. */
var()	bool						bDoFloorConform;
/** Average Floor Normal. Cached for speed. */
var const transient vector          FloorConformAverageFloorNormal;
/** Min Time between updates. */
var const           float           FloorConformMinTimeBetweenUpdates;
/** Last Time Floor Conform was updated */
var const transient float           FloorConformLastUpdateTime;
/** Associated Pylon of Poly we're standing on. */
var const transient Pylon           FloorConformCachedPylon;
/** Cached Poly, so we don't have to check the Octree too often. */
var const transient native Pointer  FloorConformCachedPoly{FNavMeshPolyBase};
/** Full floor conform resulting mesh translation */
var const transient vector			FloorConformTranslation;
/** Keep track of Z translation separately. */
var const transient FLOAT			FloorConformZTranslation;
/** Max Slope Angle allowed */
var const FLOAT						FloorConformMaxSlopeAngle;
/** Track last Pawn rotation, to make any updates if necessary */
var const Rotator					FloorConformLastPawnRotation;

/** Floor normal for full mesh floor conform */
var()				bool			bDoFullMeshFloorConform;
var					TAlphaBlend		MeshFloorConformMovementAlpha, MeshFloorConformToggleAlpha;
var const transient vector			MeshFloorConformNormal, MeshFloorConformBackupNormal;
var const transient float			MeshFloorConformTranslation;
var const transient float			MeshFloorConformSlopeAngle;
var const transient Rotator			MeshFloorConformRotation;

/** Alpha for smooth transitions */
var					TAlphaBlend		IKFloorConformMovementAlpha;
var const transient vector			IKFloorConformNormal, IKFloorConformBackupNormal;
var const transient float			IKFloorConformTranslation;
var const transient float			IKFloorConformSlopeAngle;
var const transient Rotator			IKFloorConformRotation;
var					bool			bDoIKFloorConformTorsoBending;
/** Torso rotation following slope changes */
var const transient Quat			IKFloorConformTorsoQuatWorld, IKFloorConformTorsoQuatLocal;

/** Center Of Mass (COM) translation.
 * Offsets the mesh, in relation to the slope angle with a slight delay,
 * to try to get the character to look balanced. (In world space)
 */
var const transient vector			IKFloorConformCOMTranslation;
/** If Pawn should do Center Of Mass adjustments */
var const			bool			bDoIKFloorConformCOM;
/** Time Accumulator for stable COM spring update */
var const			float			IKFloorConformCOMTimeAccumulator;
/** Target translation for COM adjustment. (In world space). */
var const transient vector			IKFloorConformCOMTarget;
/** Limits enforced for COM translation. X=Radius, Y=Height */
var() const			Vector2D		IKFloorConformCOMLimits;
/** Interpolation speed for COM translation (units per second) */
var() const			Vector			IKFloorConformCOMSpeed;
/** COM translation damping. */
var() const			Vector			IKFloorConformCOMDamping;
/** COM translation velocity. */
var const transient Vector			IKFloorConformCOMVelocity;
/**
 * Weight (0..1) between non COM adjusted offset, and fully balanced.
 * 0 means no COM adjustment, 1 means fully balanced. But then the character can be really outside of the collision cylinder
 */
var() const			FLOAT			IKFloorConformCOMWeight;

var() const			FLOAT			LegAdjustInterpSpeed;
var	const transient	FLOAT			LegAdjust;

/** Enable foot placement component */
var					bool			bDoFootPlacement;
/** Alpha for controlling foot placement interpolation */
var					TAlphaBlend		FootPlacementAlpha;

/** SkelControl controlling Feet IK bones */
var	transient SkelControlSingleBone	IKFloorConformSkelControl;
/** Bone Controller to rotate joint targets before IK is applied. To prevent odd IK behaviors */
var transient SkelControlSingleBone LegFloorConformSkelControl;
/** IK Controller for feet bones */
var transient NanoSkelCtrl_FootPlacement	IKFootLeft, IKFootRight;


/** If TRUE, translation of mesh is updated to match desired floor translation (0 unless special move desired floor conforming) */
var bool				bDisableMeshTranslationChanges;
/** Additional translation for mesh */
var vector	MeshTranslationOffset;
/** Additional yaw for mesh */
var transient float MeshYawOffset;/**
 * if TRUE, steps smoothing code will be performed.
 * This compensates Z movement of the pawn down/up stairs by offsetting the mesh, and interpolating it
 * smoothly back.
 */
var()	bool	bCanDoStepsSmoothing;
/** If TRUE, Pawn can do turn in place animations */
var	bool	bCanDoTurnInPlaceAnim;
/** Force animations to use velocity from Base */
var bool								bAnimForceVelocityFromBase;


/** 
 * AIs can now evade melee attacks.  This keeps track of how often globally ANY AI can do an evade 
 * so we don't have everyone and their mother doing it.
 **/
var config Vector2D TimeBetweenEvadesRange;
var transient float NextEvadeTime;


/** 
 * AIs can now turtle melee attacks.  This keeps track of how often globally ANY AI can do an turtle 
 * so we don't have everyone and their mother doing it.
 **/
var config Vector2D TimeBetweenTurtlesRange;
var transient float NextTurtleTime;


// all of the TeslaShock vars
var config float TeslaShock_Duration;
var transient int NumberOfTeslaShockHitsActive;

var config int NumTeslaShockHitsForStunAnimation;

var config bool TeslaShock_NoRun_Allowed;
var config float TeslaShock_NoRun_Duration;
var transient float TeslaShock_NoRun_ActiveUntil;

var config bool TeslaShock_NoJog_Allowed;
var config float TeslaShock_NoJog_Duration;
var transient float TeslaShock_NoJog_ActiveUntil;
var config float TeslaShock_NoJog_MaxSpeed;

var config bool TeslaShock_NoJump_Allowed;
var config float TeslaShock_NoJump_Duration;
var transient float TeslaShock_NoJump_ActiveUntil;

var config bool TeslaShock_NoAttack_Allowed;
var config float TeslaShock_NoAttack_Duration;
var transient float TeslaShock_NoAttack_ActiveUntil;

/** This pawn should _always_ drop weapon pickups of these types */
var array< class<NanoWeapon> > ExtraDroppedWeapons;

/** The panic repulsor that is used when we have a weapon out **/
var transient NanoCrowd_PanicRepulsor_WeaponBase WeaponCrowdPanicRepulsor;

/** Whether or not the pawn is standing still **/
var transient bool bStandingStill;

/** The time the pawn started standing still **/
var transient float LastStandingStillTime;

/** Ref of the dbno audio archetype **/
var NanoDBNOAudio DBNOAudio;
var transient AudioComponent AC_DBNOBreathing;


cpptext
{
	virtual void physFalling(FLOAT deltaTime, INT Iterations);
	virtual void processHitWall(FCheckResult const& Hit, FLOAT TimeSlice=0.f);
	virtual void setPhysics(BYTE NewPhysics, AActor* NewFloor = NULL, FVector NewFloorV = FVector(0,0,1));
	virtual void SetPostLandedPhysics(AActor *HitActor, FVector HitNormal);
	virtual void CalcVelocity(FVector &AccelDir, FLOAT DeltaTime, FLOAT MaxSpeed, FLOAT Friction, INT bFluid, INT bBrake, INT bBuoyant);
	virtual FLOAT MaxSpeedModifier();
	virtual FLOAT GetMaxAccel( FLOAT SpeedModifier = 1.f );
	virtual void TickSpecial(FLOAT DeltaSeconds);
	virtual UBOOL IgnoreBlockingBy( const AActor *Other) const;
	virtual FVector CalcAccelCurvesResult(FLOAT DeltaTime, FLOAT &MaxSpeed, FLOAT &MaxAccel);
	virtual void PostProcessPhysics( FLOAT DeltaSeconds, const FVector& OldVelocity );
	virtual void TickSimulated( FLOAT DeltaSeconds );
	virtual void performPhysics( FLOAT DeltaSeconds );

	virtual void ApplyVelocityBraking(FLOAT DeltaTime, FLOAT Friction);
	virtual void physWalking(FLOAT deltaTime, INT Iterations);
	virtual void physFlying(FLOAT deltaTime, INT Iterations);
	virtual void physInterpolating(FLOAT deltaTime);
	virtual FLOAT GetLedgeWalkMinFloorZ();
	virtual void NotifyBump(AActor *Other, UPrimitiveComponent* OtherComp, const FVector &HitNormal);
	virtual FLOAT GetTerminalVelocity();
	virtual FVector NewFallVelocity(FVector OldVelocity, FVector OldAcceleration, FLOAT timeTick);

	virtual void SetBase( AActor* NewBase, FVector NewFloor = FVector(0,0,1), INT bNotifyActor=1, USkeletalMeshComponent* SkelComp=NULL, FName BoneName=NAME_None );
	virtual void PostNetReceiveBase(AActor* NewBase);

	/** Called when the push body 'sensor' overlaps a physics body. Allows you to add a force to that body to move it. */
	virtual void ProcessPushNotify(const FRigidBodyCollisionInfo& PushedInfo, const TArray<FRigidBodyContactInfo>& ContactInfos);

	/** Called by the default camera mode to determine if we should override the camera origin in the orbit camera interpolation function, or use standard interpolation */
	virtual UBOOL ShouldSkipOrbitCamInterpolation();

	/** Update the mesh component to make it match the Floor surface normal better */
	virtual void UpdateFloorConform(FLOAT DeltaSeconds);
	/** Returns floor normal. Defaults for Infantry Pawns, weighting Floor Normal, and four traces below collision cylinder */
	FVector GetFloorConformNormal();
	/** Get Mesh translation and slope angle from floor normal. Returns TRUE if normal is straight up. */
	UBOOL GetFloorConformTranslationAndAngle(FVector &InFloorNormal, FLOAT &OutTranslation, FLOAT &OutSlopeAngle, FVector &OutFloorNormal2D);
	void UpdateNormalInterpolation(FTAlphaBlend& AlphaInterpolator, FVector& CurrentNormal, const FVector& TargetNormal, FVector& BackupNormal, FLOAT DeltaTime, FLOAT InterpolationSpeed);

	/** smooths out player movement on steps/slopes, primarily by adding mesh translation to spread out the Z change over time
	 * @param OldLocation - the Pawn's previous Location to compare against for adjustments
	 */
	void PerformStepsSmoothing(const FVector& OldLocation, FLOAT DeltaSeconds);
}

replication
{
	// send to owning client
	if (Role == ROLE_Authority && bNetOwner)
		NanoPower, NanoPowerForgeCore, LastNanoPowerUseTime;

	// Send to non-owning clients
	if (Role == ROLE_Authority && !bNetOwner)
		bIsAttachedToWall, ReplicatedAimOffset, JumpHoldGravityZScale;

	// send to all
	if( Role == ROLE_Authority )
		KnockdownImpulse, ReplicatedSkillStatus, ClampedBase;

	// Replicated to ALL but Owning Player
	if ((!bNetOwner || bDemoRecording) && Role == ROLE_Authority)
		ReplicatedSpecialMoveStruct;
}


simulated event ReplicatedEvent(Name VarName)
{
	switch( VarName )
	{
		case nameof(ReplicatedSkillStatus):
			UpdateActiveNanoSkills();
			break;
		case nameof(ReplicatedSpecialMoveStruct) :
//			`log("Received replicated special move:"@ReplicatedSpecialMoveStruct.SpecialMoveName);
			DoSpecialMoveFromStruct( ReplicatedSpecialMoveStruct, TRUE );
			break;

		case 'KnockdownImpulse':
			if (!IsZero(KnockdownImpulse.LinearVelocity) || !IsZero(KnockdownImpulse.AngularVelocity))
			{
				ApplyKnockdownImpulse();
			}
			break;
	}

	Super.ReplicatedEvent(VarName);

}

simulated event PostBeginPlay()
{
	local NanoGRI NGRI;
	local int SkillIdx;
	local NanoSkill Skill;

	Super.PostBeginPlay();

	NGRI = GetGRI();
	if( NGRI != None )
	{
		GetGRI().RegisterTargetableActor(self);
	}

	UpdateAirControl();

    SetNanoBuckets( GetDefaultStartinNanoPowerBuckets(), FALSE );
	AddNanoBuckets( NumStartingNanoPowerBuckets );

	SetNanoForgeCoreBuckets( GetDefaultStartinNanoPowerForgeCoreBuckets(), FALSE );
	AddNanoForgeCoreBuckets( NumStartingNanoPowerForgeCoreBuckets );

	CacheAnimNodes();

	BodyMIC = Mesh.CreateAndSetMaterialInstanceConstant(0);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( BodyMIC );

	ArmMIC = Mesh.CreateAndSetMaterialInstanceConstant(1);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( ArmMIC );

	HeadMIC = HeadMesh.CreateAndSetMaterialInstanceConstant(0);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( HeadMIC );

	UnlockNanoPowersBasedOnOwnedUnlocks();

	for( SkillIdx = 0; SkillIdx < SkillList.Length; SkillIdx++ )
	{
		Skill = AddNanoSkill( SkillList[SkillIdx] );
		SkillList[SkillIdx].Skill = Skill;
	}
}

simulated event Destroyed()
{
	// If we're currently doing a special move when we're being destroyed
	if( ActiveSpecialMoveName != '' && ActiveSpecialMove != None )
	{
		// End the current special move, as other actors may be relying on that
		EndSpecialMove();
	}
	// Clear references to instanced special move classes
	SpecialMoves.Length = 0;

	// clean up this ref
	if( HealthPPEffect != None )
	{
		HealthPPEffect.Material = HealthOverlayMIC.Parent;
	}

	Super.Destroyed();
}


/////////////////////////// BEGIN FORGING ////////////////////////////////

protected function NanoPlan GetActiveNanoPlan(class<NanoPlan> PlanClass)
{
	local NanoPlan Plan;

	foreach ActivePlans(Plan)
	{
		if (Plan.class == PlanClass)
		{
			return Plan;
		}
	}

	// wasn't in active plans list, maybe it should be
	if (GetPRI().PlanIsAvailableForUse(PlanClass))
	{
		Plan = new(self) PlanClass;
		ActivePlans.AddItem(Plan);
		Plan.InitPlan(self);
		return Plan;
	}

	return None;
}

delegate OnForgeFinished();

function StartForge(class<NanoPlan> PlanClass, optional delegate<NanoPawn.OnForgeFinished> OnFinished)
{
	local NanoPlan Plan;

	// find class, instantiate if necessary
	Plan = GetActiveNanoPlan(PlanClass);
	if( Plan != None )
	{
		Plan.StartForge(OnFinished);
	}
	else
	{
		`log(GetFuncName() @ PlanClass @ "FAILED");
	}
}

function EndForge(class<NanoPlan> PlanClass)
{
	local NanoPlan Plan;

	if (PlanClass != None)
	{
		// find class, instantiate if necessary
		Plan = GetActiveNanoPlan(PlanClass);
		if (Plan != None)
		{
			Plan.EndForge();
			if( PlanClass.default.PlanSlot == EPS_Melee )
			{
				//SpawnWeaponCrowdPanicRepulsor( class'NanoCrowd_PanicRepulsor_MeleeWeaponOut' );
			}
		}
		else
		{
			`log(GetFuncName() @ PlanClass @ "FAILED");
		}
	}
}


/////////////////////////// BEGIN SKILLS ////////////////////////////////

simulated function NanoSkill AddNanoSkill( SkillInfoItem SkillInfo, optional const int LevelToSet = -1 )
{
	local int SkillLvl;
	local NanoSkill Skill;

	SkillLvl = LevelToSet;
	if( SkillLvl < 0 )
	{
		SkillLvl = SkillInfo.SkillLevel;
	}

	if( SkillInfo.SkillClass != None && SkillInfo.Skill == None )
	{
		Skill = new(self) SkillInfo.SkillClass;
		Skill.RegisterSkill(self);
		if( SkillLvl != 0 )
		{
			Skill.SetSkillLevel( TRUE, SkillLvl );
		}
	}

	return Skill;
}

/** Searches for active skill of the specified class, @return None if skill not active */
native function coerce NanoSkill GetActiveSkill(class<NanoSkill> SkillClass) const;
/** Searches for a skill (active or not) of the specified class in NanoPRI, @return None if skill not found */
native function coerce NanoSkill GetSkill(class<NanoSkill> SkillClass) const;

simulated function bool ActivateSkill( class<NanoSkill> SkillClass )
{
	local NanoSkill Skill;
	Skill = GetSkill(SkillClass);
	if( Skill != None )
	{
		return Skill.ActivateSkill();
	}
	return FALSE;
}

simulated function DeactivateSkill( class<NanoSkill> SkillClass )
{
	local NanoSkill Skill;
	Skill = GetSkill(SkillClass);
	if( Skill != None )
	{
		Skill.DeactivateSkill();
	}
}

/////////////////////////// BEGIN SPECIAL MOVES ////////////////////////////////
/** Set new MeshTranslationOffset */
native final simulated function SetMeshTranslationOffset( vector NewOffset, optional bool bForce );

/** Accessor function to retrieve special move by name */
simulated event GameSpecialMove GetSpecialMoveByName( Name InMove )
{
	return VerifySpecialMoveHasBeenInstanced( InMove );
}

/** Make sure a special move has been instanced */
simulated final function GameSpecialMove VerifySpecialMoveHasBeenInstanced( Name InMove )
{
	local int Idx;

	if( InMove != '' )
	{
		Idx = SpecialMoves.Find( 'SpecialMoveName', InMove  );
		if( Idx >= 0 )
		{
			if( SpecialMoves[Idx].SpecialMoveInstance == None )
			{
				if( SpecialMoves[Idx].SpecialMoveClass != None )
				{
					SpecialMoves[Idx].SpecialMoveInstance = new(self) SpecialMoves[Idx].SpecialMoveClass;
					SpecialMoves[Idx].SpecialMoveInstance.InitSpecialMove( self, InMove );
				}

`if(`notdefined(FINAL_RELEASE))
				if( SpecialMoves[Idx].SpecialMoveInstance == None )
				{
					`warn( GetFuncName()@"Failed to instance special move"@InMove);
				}
`endif
			}
			return SpecialMoves[Idx].SpecialMoveInstance;
		}
`if(`notdefined(FINAL_RELEASE))
		`warn( GetFuncName()@"Failed to find special move by given name"@InMove );
`endif
	}

	return None;
}

/**
 * Convenience function which takes special move params and returns a SpecialMoveStruct.
 */
simulated final function SpecialMoveStruct FillSpecialMoveStructFromParams( Name InSpecialMove, optional GamePawn InInteractionPawn, optional Actor InInteractionActor, optional int InSpecialMoveFlags = 0 )
{
	local SpecialMoveStruct	OutSpecialMoveStruct;

	OutSpecialMoveStruct.SpecialMoveName  = InSpecialMove;
	OutSpecialMoveStruct.InteractionPawn  = InInteractionPawn;
	OutSpecialMoveStruct.InteractionActor = InInteractionActor;
	OutSpecialMoveStruct.Flags = InSpecialMoveFlags;

	return OutSpecialMoveStruct;
}

/** Convenience function to spit out a SpecialMoveStruct into a String */
simulated final function String SpecialMoveStructToString(SpecialMoveStruct InSMStruct)
{
	return "[SpecialMove:" @ InSMStruct.SpecialMoveName $ ", InteractionPawn:" @ InSMStruct.InteractionPawn $ ", InteractionActor:" @ InSMStruct.InteractionActor $ ", SpecialMoveFlags:" @ InSMStruct.Flags$"]";
}

simulated final function String SpecialMoveToString( Name InSpecialMove, GamePawn InInteractionPawn, Actor InInteractionActor, INT InSpecialMoveFlags )
{
	return "[SpecialMove:" @ InSpecialMove $ ", InteractionPawn:" @ InInteractionPawn $ ", InteractionActor:" @ InInteractionActor $ ", SpecialMoveFlags:" @ InSpecialMoveFlags $ "]";
}

/**
 * Sends a message event to the current special move.
 * returns TRUE if message was correctly processed.
 */
simulated final function bool SpecialMoveMessageEvent( Name EventName, Object Sender )
{
	if( ActiveSpecialMoveName != '' )
	{
		return ActiveSpecialMove.MessageEvent(EventName, Sender);
	}
	return FALSE;
}

/**
 * Return TRUE if Special Move can be performed
 * @param bForceCheck - Allows you to skip the single frame condition (which will be incorrect on clients since LastCanDoSpecialMoveTime isn't replicated)
 */
simulated final event bool CanDoSpecialMove( Name InMove, optional bool bForceCheck )
{
	local GameSpecialMove SM;

	// Can always end special moves.
	if( InMove == '' )
	{
		return TRUE;
	}

	// if it is a valid move and we have a class for the move
	if( Physics != PHYS_RigidBody )
	{
		// Make sure special move is instanced
		SM = VerifySpecialMoveHasBeenInstanced( InMove );
		if( SM != None )
		{
			// and check the instance
			return (CanChainSpecialMove(InMove) && SM.CanDoSpecialMove(bForceCheck));
		}
		`log(GetFuncName() @ "Failed with special move:" @ InMove @ Self);
	}

	`LogSM( "CanDoSpecialMove FALSE" @ self @`showvar(Physics) );
	return FALSE;
}


/** Returns TRUE if player is current performing AMove. */
simulated final native function bool IsDoingSpecialMove( Name InMove ) const;

/** Returns TRUE if Pawn is doing a special move */
simulated final native function bool IsDoingASpecialMove() const;

/** Returns TRUE if the pawn can chain this special move after the current one finishes (or if there currently isn't a special move) */
simulated final function bool CanChainSpecialMove( Name NextMove )
{
	local GameSpecialMove NSM;
	local bool bRetval;

	// Can always do a special move if not already doing one
	if( ActiveSpecialMoveName == '' )
	{
		return TRUE;
	}

	NSM = GetSpecialMoveByName( NextMove );
	if( ActiveSpecialMove != None && NSM != None )
	{
		 bRetval = (ActiveSpecialMove.CanChainMove(NextMove) || ActiveSpecialMove.CanOverrideMoveWith(NextMove) || NSM.CanOverrideSpecialMove(ActiveSpecialMoveName));

		 if( bRetval == FALSE )
		 {
			 `LogSM( "Unable ToChainSpecialMove" @ `showvar(NextMove) @ `showvar(ActiveSpecialMove.CanChainMove(NextMove)) @ `showvar(ActiveSpecialMove.CanOverrideMoveWith(NextMove)) @ `showvar(NSM.CanOverrideSpecialMove(ActiveSpecialMoveName)) @ `showvar(ActiveSpecialMoveName) );
		 }

		 return bRetval;

	}

	`LogSM( "No ActiveMove Or No Next Move" @ `showvar(ActiveSpecialMove) @ `showvar(NSM) );
	return FALSE;
}

simulated final function SetActiveSpecialMove( Name SM )
{
	ActiveSpecialMoveName = SM;
	ActiveSpecialMove = NanoSpecialMove(GetSpecialMoveByName( ActiveSpecialMoveName ));
}

/**
 * Start a special move.
 * @Note this doesn't handle replication to owning client if called from server.
 * See ServerDictateSpecialMove() and DoSpecialMove() for alternatives.
 * @network: local player and server
 */
private simulated event InternalDoSpecialMove( Name NewMove, optional bool bForceMove, optional GamePawn InInteractionPawn, optional Actor InInteractionActor, optional INT InSpecialMoveFlags, optional bool bSkipReplication )
{
	local Name				PrevMove, NextMove;
	local GameSpecialMove	PrevSM, NextSM, PendingSM;
	local SpecialMoveStruct	NewMoveStruct;

	`LogSM("New special move requested:" @ NewMove @ "bForceMove:" @ bForceMove);

	// Make sure NewMove is instanced.
	if( NewMove != '' )
	{
		NextSM = VerifySpecialMoveHasBeenInstanced(NewMove);
		if( NextSM == None )
		{
			`warn(WorldInfo.TimeSeconds @ self @ GetFuncName() @ "couldn't instance special move" @ NewMove);
			return;
		}
	}
	PrevSM = ActiveSpecialMove;

	// Create struct for new move.
	NewMoveStruct = FillSpecialMoveStructFromParams( NewMove, InInteractionPawn, InInteractionActor, InSpecialMoveFlags );

	// If we are starting our pending special move, clear pending move struct
	if( bIsPendingMove )
	{
		`LogSM("- PendingSpecialMove is being started.");
		PendingSpecialMoveStruct = FillSpecialMoveStructFromParams( '', None, None, 0 );
	}

	// Ignore redundant calls to the same move
	if( NewMove == ActiveSpecialMoveName )
	{
		if( NewMove != '' && InSpecialMoveFlags != SpecialMoveFlags )
		{
			`LogSM("- updating special move flags");
			SpecialMoveFlags = InSpecialMoveFlags;
			if( Role == ROLE_Authority && !bSkipReplication )
			{
				ReplicatedSpecialMoveStruct.Flags = SpecialMoveFlags;
				bForceNetUpdate = true;
			}
			NextSM.SpecialMoveFlagsUpdated();
		}
		`LogSM("- ignoring redundant call");
		return;
	}

	// If we're currently in the process of ending the current move
	if( bEndingSpecialMove )
	{
		// Then force the new request to pending
		`LogSM("- bEndingSpecialMove, setting" @ NewMove @ "as pending specialmove, previous PendingSpecialMove:" @ SpecialMoveStructToString(PendingSpecialMoveStruct));
		PendingSpecialMoveStruct = NewMoveStruct;
		return;
	}

	// If doing a special move transition, see if we can have an override or a chaining.
	if( !bIsPendingMove && !bForceMove && ActiveSpecialMoveName != '' && NewMove != '' )
	{
		// See if we can override current special move, otherwise just queue new one until current is finished.
		if( PrevSM.CanOverrideMoveWith(NewMove) || NextSM.CanOverrideSpecialMove(ActiveSpecialMoveName) )
		{
			bForceMove = TRUE;
			`LogSM("- Overriding" @ ActiveSpecialMoveName @ "with" @ NewMove @ "(previous pending:" @ SpecialMoveStructToString(PendingSpecialMoveStruct) $ ")");
		}
		else
		{
			// extra check to see if we can chain since non-owning clients can call DoSpecialMove directly in certain cases
			if( PrevSM.CanChainMove(NewMove) )
			{
				`LogSM("- chaining" @ NewMove @ "after" @ ActiveSpecialMoveName @ "(previous pending:" @ SpecialMoveStructToString(PendingSpecialMoveStruct) $ ")");
				PendingSpecialMoveStruct = NewMoveStruct;
			}
			else
			{
				`warn(WorldInfo.TimeSeconds @ self @ GetFuncName() @ "Cannot override, cannot chain." @ NewMove @ "is lost! SpecialMove:" @ ActiveSpecialMoveName @ "Pending:" @ SpecialMoveStructToString(PendingSpecialMoveStruct) );
			}
			return;
		}
	}

	// Check that we can do special move and special move has been/can be instanced
	if( NewMove != '' && !bForceMove && !CanDoSpecialMove(NewMove) )
	{
		`warn(WorldInfo.TimeSeconds @ self @ GetFuncName() @ "cannot do requested special move" @ `showvar(NewMove) @ `showvar(!bForceMove) @ `showvar(!CanDoSpecialMove(NewMove)) );
		return;
	}

	PrevMove = ActiveSpecialMoveName;
	NextMove = NewMove;

	// Stop previous special move
	if( ActiveSpecialMoveName != '' )
	{
		if( !bIsPendingMove )
		{
			`LogSM("- leaving move:" @ ActiveSpecialMoveName);
			bEndingSpecialMove = TRUE;
			// clear the special move so that checks like IsDoingSpecialMove and IsEvading no longer pass
			SetActiveSpecialMove( '' );
			SpecialMoveEnded( PrevMove, NewMove );
			bEndingSpecialMove = FALSE;
		}
		else
		{
			`LogSM("- Skip SpecialMoveEnded for" @ ActiveSpecialMoveName @ "as we're starting PendingSpecialMove" @ NewMoveStruct.SpecialMoveName );
		}
	}

	// If we're ending a specialmove, and we have a pending one. Start it now.
	if( NewMove == '' && PendingSpecialMoveStruct.SpecialMoveName != '' )
	{
		`LogSM("- triggering pending special move:" @ SpecialMoveStructToString(PendingSpecialMoveStruct));
		// Restore SpecialMove so we can track PrevMove properly when calling DoSpecialMove() again.
		SetActiveSpecialMove( PrevMove );
		NextMove = PendingSpecialMoveStruct.SpecialMoveName;
		PendingSM = GetSpecialMoveByName( PendingSpecialMoveStruct.SpecialMoveName );

		bIsPendingMove = TRUE;
		PendingSM.LastCanDoSpecialMoveTime = WorldInfo.TimeSeconds - 1.0; // make sure we do a fresh check
		DoSpecialMoveFromStruct( PendingSpecialMoveStruct );
		bIsPendingMove = FALSE;

		if( ActiveSpecialMoveName == NextMove )
		{
			`LogSM("- PendingSpecialMove trigger successful for" @ NextMove);
			// success, we can leave
			return;
		}
		else
		{
			`LogSM("- PendingSpecialMove trigger failed for" @ NextMove @ "Proceeding to clear SpecialMove");
		}
	}

	// Set new special move
	`LogSM( SpecialMoveStructToString(NewMoveStruct) );
	SetActiveSpecialMove( NewMoveStruct.SpecialMoveName );
	InteractionPawn		= NanoPawn(NewMoveStruct.InteractionPawn);
	InteractionType     = PAWNINTER_None;
	InteractionActor    = NewMoveStruct.InteractionActor;
	SpecialMoveFlags	= NewMoveStruct.Flags;


//   	ScriptTrace();

	if ( !bSkipReplication &&
		 (((WorldInfo.NetMode != NM_Standalone || WorldInfo.IsRecordingDemo()) && Role == ROLE_Authority) &&
		  (ActiveSpecialMoveName == '' || ActiveSpecialMove.ShouldReplicate())) )
	{
		`LogSM("- Replicating New SM" @ SpecialMoveStructToString(NewMoveStruct));

		// Force replication now to non-owning clients
		// If previous replicated SM and new one are the SM,
		// we have to make sure something is different so it is correctly replicated.
		if( ReplicatedSpecialMoveStruct.SpecialMoveName == NewMoveStruct.SpecialMoveName )
		{
			// If SM_None, we can just bump up the flags, they don't matter in that case.
			if( ReplicatedSpecialMoveStruct.SpecialMoveName == '' )
			{
				ReplicatedSpecialMoveStruct.Flags++;
			}
			else if( ReplicatedSpecialMoveStruct.InteractionPawn == NewMoveStruct.InteractionPawn
				&& ReplicatedSpecialMoveStruct.InteractionActor == NewMoveStruct.InteractionActor
				&& ReplicatedSpecialMoveStruct.Flags == NewMoveStruct.Flags )
			{
				// Huston we have have a problem, this special move is not going to be replicated properly!!
				// Report an error, so it can be fixed.
				`warn("Special Move cannot be replicated properly!!!");
				`warn(" Old SM:" @ SpecialMoveStructToString(ReplicatedSpecialMoveStruct) );
				`warn(" New SM:" @ SpecialMoveStructToString(ReplicatedSpecialMoveStruct) );
				ScriptTrace();
			}
			else
			{
				// SMs are different, so they can be replicated properly.
				ReplicatedSpecialMoveStruct = NewMoveStruct;
			}
		}
		else
		{
			// SMs are different, so they can be replicated properly.
			ReplicatedSpecialMoveStruct = NewMoveStruct;
		}

		bForceNetUpdate = TRUE;
	}

	// Notification of a special move state change.
	SpecialMoveAssigned( ActiveSpecialMoveName, PrevMove);

	// if it's a valid special move
	if( ActiveSpecialMoveName != '' )
	{
		// notify the special move it should start
		SpecialMoveStarted( ActiveSpecialMoveName, PrevMove, bForceMove );

		// if this was a forced move clear any pending moves since this was an interrupt of the current move
		if( bForceMove )
		{
			PendingSpecialMoveStruct = FillSpecialMoveStructFromParams( '', None, None, 0 );
		}
		// track the event for feedback
		if( WorldInfo.NetMode != NM_Client )
		{
			//@STATS - Record Generic Special Move
			//`RecordPlayerSpecialMoveEvent(PLAYER_SPECIAL_MOVE,Controller,SpecialMove,PendingSpecialMoveStruct.InteractionPawn != None ? PendingSpecialMoveStruct.InteractionPawn.Controller : None);
		}
	}
}

/**
 * Convenience function that takes a SpecialMoveStruct, and calls InternalDoSpecialMove() from its parameters.
 */
simulated final function DoSpecialMoveFromStruct( SpecialMoveStruct InSpecialMoveStruct, optional bool bForceMove )
{
	InternalDoSpecialMove( InSpecialMoveStruct.SpecialMoveName, bForceMove, InSpecialMoveStruct.InteractionPawn, InSpecialMoveStruct.InteractionActor, InSpecialMoveStruct.Flags );
}

/**
 * Have a locally controlled Pawn start a special move.
 * PlayerControllers will automatically replicate the move to the server. Will then be replicated to ALL.
 * AI is already executing those on the server, so they're all replicated.
 */
simulated function DoSpecialMove( Name NewMove, optional bool bForceMove = FALSE, optional GamePawn InInteractionPawn, optional Actor InInteractionActor, optional INT InSpecialMoveFlags = 0 )
{
	if( !IsLocallyControlled() )
	{
		`warn( WorldInfo.TimeSeconds @ self @ GetFuncName() @ "not called on a locally controlled Pawn!" @ NewMove );
		ScriptTrace();
		return;
	}

	if( bForceMove || CanDoSpecialMove( NewMove ) )
	{
		if( Controller.IsA('NanoPC') )
		{
			NanoPC(Controller).DoSpecialMove( NewMove, bForceMove, InInteractionPawn, InInteractionActor, InSpecialMoveFlags );
		}
		else
		{
			InternalDoSpecialMove( NewMove, TRUE, InInteractionPawn, InInteractionActor, InSpecialMoveFlags );
		}
	}
	else
	{
		`LogSM("Couldn't start SpecialMove:" @ NewMove @ self);
	}
}

/** Start a SpecialMove on the Server, and have it locally replicated to owning client. */
simulated function ServerDictateSpecialMove( Name NewMove, optional bool bForceMove = FALSE, optional GamePawn InInteractionPawn, optional Actor InInteractionActor, optional INT InSpecialMoveFlags = 0, optional Name SMToChain )
{
	`LogSM( SpecialMoveToString(NewMove, InInteractionPawn, InInteractionActor, InSpecialMoveFlags) );

	if( WorldInfo.NetMode == NM_Client && !bTearOff )
	{
		`warn(WorldInfo.TimeSeconds @ self @ GetFuncName() @ "called on client!!" @ NewMove);
		ScriptTrace();
		return;
	}

	if( bForceMove || CanDoSpecialMove(NewMove) )
	{
		if( NanoPC(Controller) != None )
		{
			NanoPC(Controller).ServerDictateSpecialMove( NewMove, InInteractionPawn, InInteractionActor, InSpecialMoveFlags );
		}
		else
		{
			InternalDoSpecialMove( NewMove, TRUE, InInteractionPawn, InInteractionActor, InSpecialMoveFlags );
		}
		if( SMToChain != '' )
		{
			InternalDoSpecialMove( SMToChain, FALSE );
		}
	}
	else
	{
		`LogSM("Couldn't start SpecialMove On Server:" @ NewMove @ self);
	}
}

/**
 * Request to abort/stop current SpecialMove
 * This is not replicated to owning client. See ClientEndSpecialMove() below for this.
 */
final simulated exec function EndSpecialMove( optional Name SpecialMoveToEnd )
{
	`LogSM( "SpecialMoveToEnd:" @ SpecialMoveToEnd );

	if( IsDoingASpecialMove() )
	{
		// clear the pending move
		if( SpecialMoveToEnd != '' && PendingSpecialMoveStruct.SpecialMoveName == SpecialMoveToEnd )
		{
			`LogSM("- Clearing PendingSpecialMove:" @ SpecialMoveToEnd);
			PendingSpecialMoveStruct = FillSpecialMoveStructFromParams( '' );
		}

		// if no move specified, or it matches the current move
		if( SpecialMoveToEnd == '' || IsDoingSpecialMove( SpecialMoveToEnd ) )
		{
			// force it to end
			InternalDoSpecialMove( '', TRUE);
		}
	}
}

/**
 * Abort current special move.
 * Called on ROLE_Authority, and replicated to owning client if needed.
 */
final event ServerEndSpecialMove( optional Name SpecialMoveToEnd )
{
	// make sure we're called on server.
	if( WorldInfo.NetMode == NM_Client )
	{
		`warn(WorldInfo.TimeSeconds @ self @ GetFuncName() @ "not called on server!!!");
		return;
	}

	`LogSM(`showvar(SpecialMoveToEnd)@`showvar(ActiveSpecialMoveName));

	if( SpecialMoveToEnd == '' )
	{
		SpecialMoveToEnd = ActiveSpecialMoveName;
	}

	// For replication we require a special move to be specified consistency accross network.
	if( SpecialMoveToEnd != '' )
	{
		// Force special move to end locally.
		EndSpecialMove( SpecialMoveToEnd );

		// If we're a player controlled Pawn on the server, replicate this to owning client.
		if( Controller != None && Controller.IsA('NanoPC') && !IsLocallyControlled() )
		{
			ReplicatedClientEndSpecialMove( SpecialMoveToEnd );
		}
	}
}

/**
 * Replicated function from Server to Client, called only from ClientEndSpecialMove()
 * Should not be called directly.
 */
final simulated reliable client function ReplicatedClientEndSpecialMove( optional Name SpecialMoveToEnd )
{
	`LogSM("SpecialMoveToEnd:" @ SpecialMoveToEnd);
	EndSpecialMove( SpecialMoveToEnd );
}

/**
 * Abort current special move.
 * Called on locally controlled pawn, and replicated to server if needed.
 */
final simulated event LocalEndSpecialMove( optional Name SpecialMoveToEnd )
{
	// make sure we're called on a locally controlled pawn.
	if( !IsLocallyControlled() )
	{
		`warn(WorldInfo.TimeSeconds @ self @ GetFuncName() @ "called on non locally controlled pawn!!!");
		return;
	}

	`LogSM(`showvar(SpecialMoveToEnd)@`showvar(ActiveSpecialMoveName));

	if( SpecialMoveToEnd == '' )
	{
		SpecialMoveToEnd = ActiveSpecialMoveName;
	}

	// For replication we require a special move to be specified consistency accross network.
	if( SpecialMoveToEnd != '' )
	{
		// End SpecialMove locally
		EndSpecialMove( SpecialMoveToEnd );

		// Replicate to server if needed
		if( Controller != None && Controller.IsA('NanoPC') && WorldInfo.NetMode == NM_Client )
		{
			ReplicatedServerEndSpecialMove(SpecialMoveToEnd);
		}
	}
}

/**
 * Replicated function from Client to Server, called only from LocalEndSpecialMove()
 * Should not be called directly.
 */
final simulated reliable server function ReplicatedServerEndSpecialMove(optional Name SpecialMoveToEnd)
{
	`LogSM("SpecialMoveToEnd:" @ SpecialMoveToEnd);
	EndSpecialMove( SpecialMoveToEnd );
}

/* Notification called when SpecialMove enum changes. */
simulated function SpecialMoveAssigned( Name NewMove, Name PrevMove)
{
	`LogSM("NewMove:" @ NewMove @ "PrevMove:" @ PrevMove);

	PreviousSpecialMoveName = PrevMove;
	PreviousSpecialMoveTime = WorldInfo.TimeSeconds;
}

/** Event called when a new special move has started */
simulated final function SpecialMoveStarted( Name NewMove, Name PrevMove, bool bForced )
{
	local NanoPC	PC;
	local GameSpecialMove SM;

	`LogSM("NewMove:" @ NewMove @ "PrevMove:" @ PrevMove);

	if( NewMove != '' )
	{
		// notify controller that special move started.
		PC = NanoPC(Controller);
		if( PC != None )
		{
//			PC.SpecialMoveStarted(NewMove);
		}
		// forward notification to special move instance
		SM = GetSpecialMoveByName( NewMove );
		if( SM != None )
		{
			SM.SpecialMoveStarted( bForced, PrevMove );
		}
`if(`notdefined(FINAL_RELEASE))
		else
		{
			`LogSM("No class for special move:" @ NewMove @ self);
		}
`endif
	}
}


/** Event called when A new special move has stopped */
simulated final function SpecialMoveEnded( Name PrevMove, Name NextMove)
{
	local GameSpecialMove PrevSM;

	`LogSM("PrevMove:" @ PrevMove);

	if( PrevMove != '' )
	{
		PrevSM = GetSpecialMoveByName( PrevMove );
		if( PrevSM != None )
		{
			PrevSM.SpecialMoveEnded( PrevMove, NextMove );
		}
`if(`notdefined(FINAL_RELEASE))
		else
		{
			`LogSM("No class for special move:" @ PrevMove);
		}
`endif

		// give ai notification
/*		if (MyGearAI != None)
		{
			MyGearAI.NotifyEndOfSpecialMove(PrevMove);
		}*/
	}
}

/////////////////////////// END SPECIAL MOVES ////////////////////////////////

function Knockdown( optional float KnockDownTime, optional bool bLanded )
{
	if( !bCanBeKnockedDown )
		return;

	if( Health > 0 && !bKnockedDown )
	{
		if( !bLanded && Physics == PHYS_Falling)
		{
			bKnockDownOnLanding = TRUE;
		}
		else
		{
			RecoverFromRagdollTime = WorldInfo.TimeSeconds + KnockDownTime;
			ServerKnockdown(,vect(1,1,1));
		}
   }
}

/**
* Send this pawn to ragdoll and apply the given forces.  All params are optional, to enable
* any combination of forces (whole-body, radial, or point)
*
* @param RBLinearVelocity			Linear velocity to apply to entire rigid body.
* @param RBAngularVelocity			Angular velocity to apply to entire rigid body.
* @param RadialOrigin				World-space origin of radial impulse.
* @param RadialRadius				Radius of radial impulse.  If 0.0, no radial impulse will be applied.
* @param RadialStrength			Strength of radial impulse.  If 0.0, no radial impulse will be applied.
* @param PointImpulse				Point impulse to apply.  if 0,0,0, no point impulse will be applied.
* @param PointImpulsePosition		Position in world space at which PointImpulse should be applied.
* @param PointImpulseBoneName		Bone that receives point impulse.
*/
reliable server function ServerKnockdown
(
 optional vector RBLinearVelocity,
 optional vector RBAngularVelocity,
 optional vector RadialOrigin,
 optional float	RadialRadius,
 optional float	RadialStrength,
 optional vector PointImpulse,
 optional vector PointImpulsePosition,
 optional Name	PointImpulseBoneName
 )
{
	if (Role < ROLE_Authority)
	{
		`if(`notdefined(FINAL_RELEASE))
			`warn("Only allowed on server");
		ScriptTrace();
		`endif
			return;
	}

	if (IsZero(RBLinearVelocity) && IsZero(RBAngularVelocity))
	{
		`Warn("No linear or angular velocity - one or the other must be set for replication to work");
		ScriptTrace();
		return;
	}

	// only one knockdown allowed at a time and not at all if dead
	if( Physics == PHYS_RigidBody || bPlayedDeath  )
	{
		return;
	}

	DropShield();

	if( bCanBeKnockedDown )
	{
		StopFiring();

		// set the knockdown information for use in ApplyKnockdownImpulse()
		KnockdownImpulse.LinearVelocity = RBLinearVelocity;
		KnockdownImpulse.AngularVelocity = RBAngularVelocity;
		KnockdownImpulse.PointImpulse = PointImpulse;
		KnockdownImpulse.PointImpulseBoneName = PointImpulseBoneName;
		KnockdownImpulse.PointImpulsePosition = PointImpulsePosition;
		KnockdownImpulse.RadialOrigin = RadialOrigin;
		KnockdownImpulse.RadialRadius = RadialRadius;
		KnockdownImpulse.RadialStrength = RadialStrength;

		// transition to the KnockedDown state
		GotoState( 'Posture_KnockedDown' );
	}
}

simulated function float GetKnockDownFailSafeTimeout()
{
	return 15.f;
}

/** Applies the contents of KnockdownImpulse.  Clients shouldn't call this function directly, only from repnotify. */
simulated protected function ApplyKnockdownImpulse()
{
	//`Log("KNOCKDOWN");
	//	`log("!!!"@`showvar(KnockdownImpulse.LinearVelocity)@`showvar(Location)@`showvar(Mesh.GetPosition()));
	// Record when knockdown happened
	KnockDownStartTime = WorldInfo.TimeSeconds;
	KnockdownStartingPosition = Location;

	if( Physics != PHYS_RigidBody || Mesh != CollisionComponent )
	{
		// first send them to ragdoll
		DoRagdollKnockdown();
	}

	if( Physics == PHYS_RigidBody )
	{
		// and apply the forces additively

		// whole-body velocities
		//@note: we set instead of adding for angular velocity as it's generally zero for newly created ragdolls
		//	and if it weren't, the client wouldn't be able to reliably derive the same value so it would just cause mismatches
		Mesh.SetRBAngularVelocity(KnockdownImpulse.AngularVelocity, false);
		if (!IsZero(KnockdownImpulse.LinearVelocity))
		{
			Mesh.SetRBLinearVelocity(KnockdownImpulse.LinearVelocity, true);
		}

		// radial impulses
		if ( (KnockdownImpulse.RadialRadius > 0.f) && (KnockdownImpulse.RadialStrength > 0.f) )
		{
			Mesh.AddRadialImpulse(KnockdownImpulse.RadialOrigin, KnockdownImpulse.RadialRadius, KnockdownImpulse.RadialStrength, RIF_Linear);
		}

		// point impulses
		if (!IsZero(KnockdownImpulse.PointImpulse))
		{
			Mesh.AddImpulse(KnockdownImpulse.PointImpulse, KnockdownImpulse.PointImpulsePosition, KnockdownImpulse.PointImpulseBoneName);
		}

		if( Role == ROLE_Authority )
		{
			SetTimer(GetKnockDownFailSafeTimeout(),FALSE,nameof(KnockdownFailsafe));
			bCheckKnockdownFall = FALSE;
			SetTimer(0.5f,FALSE,nameof(EnableKnockdownFallChecking));
		}
	}
	else
	{
		`warn(self@"failed to transition to RigidBody for"@GetFuncName());
	}
}

event KnockdownFailsafe()
{
	if (Health > 0)
	{
		`warn( "KnockdownFailsafe is triggering!!!" @ self @ Controller );
		Died( LastHitBy, class'NDT_Environment', Location );
	}
}

final function EnableKnockdownFallChecking()
{
	bCheckKnockdownFall = TRUE;
}


/** Util to update motor strength of motors after being knocked down */
native function TickKnockDownMotorStrength(float DeltaSeconds);

simulated state Posture_KnockedDown
{
	simulated function BeginState( Name PreviousStateName )
	{
		local NanoAI AI;
		AI = NanoAI(Controller);
		if( AI != None )
		{
			AI.StunAI( 0, 'Posture_KnockedDown' );
		}

		bKnockedDown = TRUE;
		bKnockDownOnLanding = FALSE;
	}

	simulated function EndState( Name NextStateName )
	{
		local NanoAI AI;

		if( bBlendToGetUp )
		{
			FinishedBlendToGetUp();
		}

		bBlendToGetUp = FALSE;

		// Restore things we turned off when we went into rag doll
		PostRagDollRecovery();
		Mesh.RootMotionMode = default.Mesh.RootMotionMode;
//		BS_SetAnimEndNotify(BSToPlay, FALSE);

		AI = NanoAI(Controller);
		if( AI != None )
		{
			AI.UnstunAI( 'Posture_KnockedDown' );
			AI.UnstunAI('Knockback');
		}

		bKnockedDown = FALSE;
		bKnockDownOnLanding = FALSE;
		bJuggled = FALSE;

		if( !bImpaledOnSword )
		{
			SetMovementPhysics();
		}
	}

	simulated function Tick(float DeltaTime)
	{
		Super.Tick( DeltaTime );

		// if using motorised-anim during knockdown, update motor strengths
		if( bPlayMotorAnimOnKnockDown )
		{
			TickKnockDownMotorStrength(DeltaTime);
		}
	}


	simulated function CheckFinishedGetup()
	{
		local float Alpha;

		// If we are in process of blending to get up animation, modify physics weight between ragdoll finish pose and get-up start pose.
		if( GetUpBlendStartTime + GetUpBlendTime > WorldInfo.TimeSeconds )
		{
			Alpha = 1.f - ((WorldInfo.TimeSeconds - GetUpBlendStartTime)/GetUpBlendTime);
			Mesh.PhysicsWeight = FClamp(FCubicInterp(0.f, 0.f, 1.f, 0.f, Alpha), 0.f, 1.f);
		}
		// Done with blend, start the get-up animation, start updating physics bones again, and show result.
		// Bones should all be fixed at this point.
		else
		{
			FinishedBlendToGetUp();
		}
	}

	simulated function FinishedBlendToGetUp()
	{
		bBlendToGetUp = FALSE;

		Mesh.RootMotionMode = RMM_Accel;
		SetPhysics(PHYS_Falling);
		ZeroMovementVariables();
		CollisionComponent = CylinderComponent;
		//PreRagdollCollisionComponent = None;

		// Retore params to defaults.
		if( !default.Mesh.bHasPhysicsAssetInstance )
		{
			Mesh.SetHasPhysicsAssetInstance(FALSE);
		}
		Mesh.bUpdateKinematicBonesFromAnimation = default.Mesh.bUpdateKinematicBonesFromAnimation;
		Mesh.bUpdateJointsFromAnimation = default.Mesh.bUpdateJointsFromAnimation;
		Mesh.PhysicsWeight = default.Mesh.PhysicsWeight;

		// Turn on physics collision again - you are a pawn again, and can collide with other live pawns (for flappy bits), and corpses, but not knocked down alive people
		Mesh.SetRBChannel(RBCC_Pawn);
		Mesh.SetRBCollidesWithChannel(RBCC_Untitled3, FALSE);
		Mesh.SetRBCollidesWithChannel(RBCC_Pawn, TRUE);

		// Check flag before letting you kick corpses again
		if( !bDisableKicksCorpseAfterRecovery )
		{
			Mesh.SetRBCollidesWithChannel(RBCC_DeadPawn, TRUE);
		}

		// restore danglers
		if( Mesh != None && Mesh.PhysicsAssetInstance != None )
		{
			Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, Mesh);
		}
	}

	simulated function float GetKnockdownZThreshold()
	{
		return 256.f;
	}

	function EndKnockedDownState()
	{
		ClearTimer(nameof(EndKnockedDownState));
		ClearTimer(nameof(KnockdownFailsafe));
		ClearTimer(nameof(EnableKnockdownFallChecking));

		// if we've fallen a significant distance then assume we're dead
		if( Abs(KnockdownStartingPosition.Z - Location.Z) > GetKnockdownZThreshold() )
		{
			KnockdownFailsafe();
		}

		KnockdownImpulse.LinearVelocity = vect(0,0,0);
		KnockdownImpulse.AngularVelocity = vect(0,0,0);
	}

Begin:
	// Do ragdoll transition
	DoRagdollKnockdown();

	// apply the impulse
	ApplyKnockdownImpulse();

	// Stay in ragdoll until recovery time has elapsed
	while( WorldInfo.TimeSeconds < RecoverFromRagdollTime && Physics == PHYS_RigidBody )
	{
		Sleep( 0.25f );
	}

	// Do ragdoll recovery/getup
	RecoverFromRagdoll();
	while( bBlendToGetUp )
	{
		Sleep( 0.1f );
		CheckFinishedGetup();
	}

	while( IsTimerActive(nameof(GetupAnimTimer) ) )
	{
		Sleep(0.1f);
	}

	EndKnockedDownState();

	// Release pawn to move around again
	GotoState( '' );
}

function DoRagdollKnockdown()
{
	ReadyPawnForRagdoll();

	if( InitRagdoll() )
	{
		// Move into post so that we are hitting physics from last frame, rather than animated from this
		Mesh.SetTickGroup(TG_PostAsyncWork);
		SetTickGroup(TG_PostAsyncWork);

		// Set physics to NOT be updated from Kinematic data
		Mesh.bUpdateKinematicBonesFromAnimation = FALSE;

		PauseAllAnimations();

		if( bPlayMotorAnimOnKnockDown )
		{
			if( Mesh.PhysicsAssetInstance != None )
			{
				// Make sure all motors are on
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(TRUE, TRUE, Mesh, TRUE);
				// Set motor strength
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(KnockDownMotorStrength, KnockDownMotorDamping, 0.f, Mesh, TRUE);
			}
			// Want to update joints with anim data
			Mesh.bUpdateJointsFromAnimation = TRUE;

			// Play anim
			PlayKnockdown();
		}
		else
		{
			if( Mesh.PhysicsAssetInstance != None )
			{
				// Make sure all motors are off on joints.
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(FALSE, FALSE, Mesh, TRUE);
				// Turn on velocity motors, to add some joint friction
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(0.f, 0.f, 0.004f, Mesh, TRUE);
				// Don't set motors on dangly bits.
				Mesh.PhysicsAssetInstance.SetAllMotorsAngularVelocityDrive(TRUE, TRUE, Mesh, TRUE);
			}

			Mesh.bUpdateJointsFromAnimation = FALSE;
		}

		// Record when knockdown happened
		KnockDownStartTime = WorldInfo.TimeSeconds;

		PlayFallDownPhysicsModify();

		// we purposefully do NOT turn collide with RBBC_Pawn on
		// we will innerpenetrate other ragdolled pawns as we do not collide with the Pawn channel.  This is acceptable because if we do
		// collide with other ragdolled pawns there is a chance that we will have the physics system forcibly push us apart causing one
		// or both the pawns to fly through the world

//		ReduceConstraintLimits();
//		ReduceMotorStrength();
	}
	else
	{
		`Warn("Failed to init ragdoll for"@self);
	}
}

function ReadyPawnForRagdoll()
{
	// Turn off HeadLook controller
	if( HeadTrackSkelControl != None )
	{
		HeadTrackSkelControl.SetSkelControlActive(FALSE);
	}
	// Turn off EyeLook controller
	if( EyeTrackSkelControl != None )
	{
		EyeTrackSkelControl.SetSkelControlActive(FALSE);
	}
}

/** This will modify the physics is the correct way for PlayFallDown **/
simulated function PlayFallDownPhysicsModify()
{
	// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
	//Mesh.SetRBChannel(RBCC_Default);

	Mesh.SetRBChannel(RBCC_Untitled3);
	Mesh.SetRBCollidesWithChannel(RBCC_Untitled3, TRUE);
	Mesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
	Mesh.SetRBCollidesWithChannel(RBCC_DeadPawn, FALSE);
}

simulated function RecoverFromRagdoll()
{
	local vector	HitLocation, HitNormal, TraceStart, TraceEnd, Extent;
	local vector	HeightVec;
	local Actor		HitActor;

	// Stop updating the physics bones to match the animation
	Mesh.bUpdateKinematicBonesFromAnimation = FALSE;
	Mesh.PhysicsWeight = 1.f;
	// Ensure we are always updating kinematic
	Mesh.MinDistFactorForKinematicUpdate = default.Mesh.MinDistFactorForKinematicUpdate;

	Mesh.SetTickGroup(TG_PreAsyncWork);
	SetTickGroup(TG_PreAsyncWork);

	// This will fix all bones, and stop Actor location being changed.
	SetPhysics(PHYS_None);

	// Figure out Actor Rotation and Recovery animation to play
	SetupRotationAndAnimation();

	// Move Actor origin so its feet will be on the ground.
	// Move Pawn off walls
	Extent = vect(0,0,0);
	// Trace down to floor level
	HeightVec	= vect(0,0,1) * CylinderComponent.CollisionHeight;
	TraceStart	= Location + HeightVec * 1.1f;	// Don't go to high, so we don't start trace inside a ceiling.
	TraceEnd	= Location - HeightVec * 3.f;

	if( bIgnorePawnsOnRecover )
	{
		HitActor = TraceNoPawns( self, TraceEnd, TraceStart, HitLocation);
	}
	else
	{
		HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, TRUE, Extent);
	}

	if( HitActor != None )
	{
		// Move off geometry by collision extent.
		HitLocation += HeightVec - vect(0,0,1) * Extent.Z;
		Extent = Vect(1,1,0) * CylinderComponent.CollisionRadius + HeightVec;
		if( FindSpot(Extent, HitLocation) )
		{
			if( Location != HitLocation )
			{
				SetLocation(HitLocation);
			}
		}
		else
		{
			SetLocation(HitLocation);
			// `if(`notdefined(FINAL_RELEASE))
			// 			`Log(class @ "Failed findspot");
			// 			DrawDebugCylinder(Location - HeightVec, Location + HeightVec, CylinderComponent.CollisionRadius, 12, 255, 0, 0, TRUE);
			// `endif
		}
	}
	else
	{
		// `if(`notdefined(FINAL_RELEASE))
		// 		`Log(class @ "Failed trace");
		// 		DrawDebugCylinder(TraceStart + vect(0,0,1) * Extent.Z, TraceEnd - vect(0,0,1) * Extent.Z, Extent.X, 4, 0, 255, 0, TRUE);
		// 		DrawDebugLine(TraceStart, TraceEnd, 0, 0, 255, TRUE);
		// `endif
	}

	// Start changing PhysicsWeight from 1.f (showing ragdoll position) to 0.f (showing first frame of get up anim)
	bBlendToGetUp = TRUE;
	GetUpBlendStartTime = WorldInfo.TimeSeconds;
}


/** Trace, but ignore volumes and triggers */
simulated function Actor TraceNoPawns(Pawn TraceOwner, vector End, vector Start, out vector HitLocation)
{
	local Actor HitActor;
	local vector HitLoc, HitNorm;

	// Iterate over each actor along trace...
	foreach TraceOwner.TraceActors(class'Actor', HitActor, HitLoc, HitNorm, End, Start, vect(0,0,0))
	{
		// .. if it's not a pawn, use it!
		if(Pawn(HitActor) != None)
		{
			HitLocation = HitLoc;
			return HitActor;
		}
	}
	return None;
}

/**
* Figure out what the Actor's Rotation should be.
* And which recovery animation should be played.
*/
function SetupRotationAndAnimation()
{
	local float GetupAnimTime;
	local Rotator NewRotation;
	local int OrientationBodyIndex, UpDownBodyIndex;
	local matrix BodyTM;

	// restart any animations on the pawn
	ResumeAllAnimations();

	bGetUpFromBack = FALSE;

	// Make sure we have a bone set to do these things.
	OrientationBodyIndex = Mesh.PhysicsAsset.FindBodyIndex(OrientationBoneName);
	if( OrientationBodyIndex != INDEX_NONE )
	{
		// force rotation to match the body's direction so the blend to the getup animation looks more natural
		BodyTM = Mesh.PhysicsAssetInstance.Bodies[OrientationBodyIndex].GetUnrealWorldTM();
		NewRotation.Yaw = rotator(MatrixGetAxis(BodyTM, OrientationAxis)).Yaw;
		//DrawDebugCoordinateSystem(MatrixGetOrigin(BodyTM), MatrixGetRotator(BodyTM), 5.f, TRUE);

		UpDownBodyIndex = Mesh.PhysicsAsset.FindBodyIndex(UpDownBoneName);

		if( UpDownBodyIndex != INDEX_NONE )
		{
			BodyTM = Mesh.PhysicsAssetInstance.Bodies[UpDownBodyIndex].GetUnrealWorldTM();
			bGetUpFromBack = (MatrixGetAxis(BodyTM, UpDownAxis).Z > 0.f);
			//DrawDebugCoordinateSystem(MatrixGetOrigin(BodyTM), MatrixGetRotator(BodyTM), 5.f, TRUE);
			if( bInvertUpDownBoneAxis )
			{
				bGetUpFromBack = !bGetUpFromBack;
			}
		}

		// flip it around if the head is facing upwards, since the animation for that makes the character
		// end up facing in the opposite direction that its body is pointing on the ground
		if( bGetUpFromBack )
		{
			NewRotation.Yaw += GetUpFromBackYawOffset;
			NewRotation = Normalize(NewRotation);
		}
		SetRotation(NewRotation);
		//DrawDebugCoordinateSystem(Location, Rotation, 50.f, TRUE);
	}
	else
	{
		NewRotation.Yaw = Rotation.Yaw;
		SetRotation(NewRotation);
	}

	GetupAnimTime = PlayGetup( bGetUpFromBack );
	SetTimer( GetupAnimTime, FALSE, nameof(GetupAnimTimer));
}

simulated function GetupAnimTimer();

/**
* Cancel effects of ragdolling, to get up.
*/
simulated function PostRagDollRecovery()
{
	Mesh.MinDistFactorForKinematicUpdate = default.Mesh.MinDistFactorForKinematicUpdate;
}

/** Stops all animations from playing and saves a list of the active ones to be restarted on the next call to ResumeAllAnimations(). */
final simulated function PauseAllAnimations()
{
	local AnimNodeSequence SeqNode;
	// make sure we aren't already paused
	if (ResumePlayNodes.Length == 0)
	{
		foreach Mesh.AllAnimNodes(class'AnimNodeSequence', SeqNode)
		{
			// if it's currently playing then save it to a list for resuming later
			if( SeqNode.bPlaying )
			{
				ResumePlayNodes.AddItem(SeqNode);
			}
			// stop all nodes from playing
			SeqNode.bPlaying = FALSE;
		}
	}
}

/** Starts playing any animations that were playing at the time PauseAllAnimations() was called. */
final simulated function ResumeAllAnimations()
{
	local AnimNodeSequence SeqNode;
	// Resume nodes playing animation.
	foreach ResumePlayNodes(SeqNode)
	{
		SeqNode.bPlaying = TRUE;
	}
	ResumePlayNodes.Length = 0;
}

/** Stops all animations on character */
simulated function StopAllAnimations()
{
	local AnimNodeSequence	SeqNode;

	foreach Mesh.AllAnimNodes(class'AnimNodeSequence', SeqNode)
	{
		SeqNode.bPlaying = FALSE;
	}

	if( !AnimTree(Mesh.Animations).bUseSavedPose )
	{
		// Save a pose using the current mesh
		AnimTree(Mesh.Animations).SetUseSavedPose(TRUE);
		// Clear references to AnimTree nodes.
		ClearAnimNodes();
		// Now clear the rest of the tree, as we are only going to use the saved pose from now on
		AnimTree(Mesh.Animations).Children[0].Anim = None;
		// When dead, no need to animate when not rendered
		Mesh.bUpdateSkelWhenNotRendered = FALSE;
	}
}

simulated function PlayKnockdown();
simulated function float PlayGetup( bool bFromBack );
simulated function PlayHitReaction( out HitReactionInfo HRI );

function Knockback( vector Dir, bool InbKnockDownOnLanding, optional name StunDesc )
{
	local NanoAI AI;

	bKnockDownOnLanding = InbKnockDownOnLanding;
	SetPhysics(PHYS_Falling);
	Velocity = Dir;

	// Stun AI until they land from the knockback
	AI = NanoAI(Controller);
	if( AI != None )
	{
		if( StunDesc == '' )
		{
			AI.StunAI( 0.f, 'Knockback' );
		}
		else
		{
			AI.StunAI( 0.f, StunDesc );
		}
	}
}

function CreateShield();
function DropShield()
{
	local NanoAI AI;
	AI = NanoAI(Controller);
	if (AI != None)
	{
		AI.NotifyShieldDropped();
	}
}


simulated function CacheAnimNodes()
{
	local NanoAnim_AimOffset AimNode;

	Super.CacheAnimNodes();

	foreach Mesh.AllAnimNodes( class'NanoAnim_AimOffset', AimNode )
	{
		AimNodes[AimNodes.Length] = AimNode;
	}

	PhysBlend = NanoAnimBlendByPhysics(Mesh.FindAnimNode('PhysBlend'));

	MeshPitchController = SkelControlSingleBone(Mesh.FindSkelControl('MeshPitch'));
	RightWristControl = SkelControlSingleBone(Mesh.FindSkelControl('RightWristControl'));
	LeftWristAwarenessControl = SkelControlLimb(Mesh.FindSkelControl('LeftWristAwarenessControl'));

	TopHalfSlot = NanoAnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));
	FullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('FullBodySlot'));
	RunningFullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('RunningFullBodySlot'));
	RunningTopHalfSlot = NanoAnimNodeSlot(Mesh.FindAnimNode('RunningTopHalfSlot'));
	FallingFullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('FallingFullBodySlot'));
	PreAimFullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('PreAimFullBodySlot'));
	UnarmedSprintSlot = NanoAnimNodeSlot(Mesh.FindAnimNode('UnarmedSprintSlot'));
	BlendFallNode = NanoAnimBlendByFall(Mesh.FindAnimNode('BlendFallNode'));
	SwordBlendBySpeedNode = AnimNodeBlendBySpeed(Mesh.FindAnimNode('SwordBlendBySpeed'));

	TackleRunSeqNode = NanoAnimNodeSequence(Mesh.FindAnimNode('TackleRun'));

	HandGunAimOffset = AnimNodeAimOffset(Mesh.FindAnimNode('HandGunAimOffset'));

	if( PhysBlend != None )
	{
		// hook up the blend fall to the phys, so that the phys can do custom blend times on landing
		PhysBlend.FallNode = BlendFallNode;
	}


	GunAdditiveBlendNode = AnimNodeAdditiveBlending(Mesh.FindAnimNode('GunAdditiveBlend'));
	GunAdditiveSeqNode = AnimNodeSequence(Mesh.FindAnimNode('GunAdditiveSeq'));

	RecoilAdditiveBlendNode = AnimNodeAdditiveBlending(Mesh.FindAnimNode('RecoilAdditiveBlend'));
	RecoilAdditiveSeqNode = AnimNodeSequence(Mesh.FindAnimNode('RecoilAdditiveSeq'));

	SprintLeanAdditiveNode = AnimNodeAdditiveBlending(Mesh.FindAnimNode('SprintLeanAdditiveNode'));

	IKFootLeft = NanoSkelCtrl_FootPlacement(Mesh.FindSkelControl('FootPlacement_Left'));
	IKFootRight = NanoSkelCtrl_FootPlacement(Mesh.FindSkelControl('FootPlacement_Right'));
}

function PlayGunAdditiveAnim(Name SeqName, float AdditiveWeight, float BlendTime)
{
	if( GunAdditiveSeqNode != none )
	{
		GunAdditiveSeqNode.SetAnim(SeqName);
		GunAdditiveSeqNode.Rate = 1.f;
		GunAdditiveSeqNode.SetPosition(0.f,FALSE);
		GunAdditiveBlendNode.SetBlendTarget(AdditiveWeight,BlendTime);
		SetTimer(FMax(0.01,GunAdditiveSeqNode.GetTimeLeft()-BlendTime),FALSE,nameof(StopGunAdditiveAnim));
		CachedGunAdditiveBlendOutTime = BlendTime;
	}
}

function StopGunAdditiveAnim()
{
	GunAdditiveBlendNode.SetBlendTarget(0.f,CachedGunAdditiveBlendOutTime);
}

function SetRecoilWeight(float NewWeight, float BlendTime)
{
	if( RecoilAdditiveBlendNode != None )
	{
		RecoilAdditiveBlendNode.SetBlendTarget(NewWeight,BlendTime);
	}
}

function PlayRecoilAdditiveAnim(Name SeqName, float AdditiveWeight, float BlendTime)
{
	if( RecoilAdditiveSeqNode != None )
	{
		RecoilAdditiveSeqNode.SetAnim(SeqName);
		RecoilAdditiveSeqNode.Rate = 1.f;
		//RecoilAdditiveSeqNode.SetPosition(0.f,FALSE);
		RecoilAdditiveSeqNode.PlayAnim(FALSE,1.f,0.f);
		RecoilAdditiveBlendNode.SetBlendTarget(AdditiveWeight,BlendTime);
	}
}

/** Clear references to anim nodes so AnimTree can be garbage collected. */
simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();

	AimNodes.Length = 0;

	PhysBlend = None;

	MeshPitchController = None;
	RightWristControl = None;
	LeftWristAwarenessControl = None;

	TopHalfSlot = None;
	FullBodySlot = None;
	RunningFullBodySlot = None;
	RunningTopHalfSlot = None;
	FallingFullBodySlot = None;
	PreAimFullBodySlot = None;
	UnarmedSprintSlot = None;
	BlendFallNode = None;

	TackleRunSeqNode = None;
}


function PossessedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C, bVehicleTransition);

	NotifyTeamChanged();

	if (PlayerController(C) != None)
	{
		SetTimer(0.5f,TRUE,nameof(SaveAnchorPoint));
	}

	// If human controller, give ammo for any unlocked weapons now
	if(IsHumanControlled())
	{
		//GetPRI().GiveMaxAmmoForUnlockedWeapons(self);
	}
}

function SaveAnchorPoint()
{
	if( ( Health > 0 )
		&& ( Physics == PHYS_Walking )
		&& ( NanoVehicleAgent(Base) == None )
		&& ( IsTimerActive( nameof(ResetToAnchorIsValid) ) == FALSE )
	   )
	{
		AnchorPoint = Location;
		AnchorPointRotation = Controller.Rotation;
		LastSafeLocation = Location;
		//`log(`location@`showvar(AnchorPoint));
	}
}

simulated function NotifyTeamChanged()
{
	local int TeamNum;
	local LinearColor TeamColor;

	Super.NotifyTeamChanged();

	// Update team color param
	TeamNum = GetTeamNum();
	TeamColor = (TeamNum == 0) ? MakeLinearColor( 1.0, 0.0, 0.0, 1.0) : MakeLinearColor( 0.0, 0.25, 1.0, 1.0);
	BodyMIC.SetVectorParameterValue( 'TeamColor', TeamColor );
}

function LockNanoPower(Name LockName)
{
	NanoPowerLocks.AddItem(LockName);
	if (NanoPowerLocks.Length == 1)
	{
		StopAllPowers();
	}
	ClientToggleNanoPowerLock(LockName,TRUE);
}

function UnlockNanoPower(Name LockName)
{
	NanoPowerLocks.RemoveItem(LockName);
	ClientToggleNanoPowerLock(LockName,FALSE);
}


/** This will unlock all of the nano powers that we own **/
simulated function UnlockNanoPowersBasedOnOwnedUnlocks()
{
}


/** Just print out the unlocked nano powers **/
exec simulated function ShowUnlockedNanoPowers()
{
	local UnlockedNanoPowersDatum NanoUnlock;

	`loginfo( 'Nano_Powers', "Unlocked Nano Powers:" );

	foreach UnlockedNanoPowers( NanoUnlock )
	{
		`loginfo( 'Nano_Powers', "  " @ NanoUnlock.PowerType );
	}
}


function SetUnlimitedClips( bool bSet )
{
	local NanoWeapon Weap;

	//bUnlimitedClips = bSet;
	ForEach InvManager.InventoryActors(class'NanoWeapon', Weap)
	{
		if( bSet )
		{
			Weap.SetInfiniteSpareAmmo();
		}
		else
		{
			Weap.ClearInfiniteSpareAmmo();
		}
	}
}


/** 
 *   Give some ammo to the pawn for a specirfic weapon
 *   If bSetAmmo is TRUE, will override current ammo, otherwise will add
 */
function GiveAmmo(class<NanoWeaponBase> AmmoWeaponClass, int Amount, bool bSetAmmo)
{
	local int i, SlotIndex, MaxAmmo;


	// If ammo is for gun being used, give it straight to the gun
	if((Weapon != None) && (AmmoWeaponClass == Weapon.Class))
	{
		//`log( "Add ammo to the" @ Weapon.Class @ `showvar(Amount) );
		Weapon.AddAmmo(Amount);
	}
	// If gun not being used, put it into our reserve on the pawn
	else
	{
		// Look for existing entry
		SlotIndex = -1;
		for(i=0; i<AmmoStash.length; i++)
		{
			if(AmmoStash[i].WeapClass == AmmoWeaponClass)
			{
				SlotIndex = i;
				break;
			}
		}

		// No entry found, make a new one
		if(SlotIndex == -1)
		{
			SlotIndex = AmmoStash.length;
			AmmoStash.length = SlotIndex+1;
			AmmoStash[SlotIndex].WeapClass = AmmoWeaponClass;
		}

		// How much ammo can we carry for this weapon?
		MaxAmmo = AmmoWeaponClass.default.WeaponMaxSpareAmmo;

		// Either set or add to this entry
		if(bSetAmmo)
		{
			AmmoStash[SlotIndex].Ammo = Min(Amount, MaxAmmo);
			//`log( `showvar(AmmoStash[SlotIndex].Ammo) );
		}
		else
		{
			AmmoStash[SlotIndex].Ammo = Min(AmmoStash[SlotIndex].Ammo + Amount, MaxAmmo);
		}
	}
}


/** Get the amount of ammo in the stash for the specified weapon class */
function int GetStashAmmoForWeapon( class<NanoWeapon> AmmoWeaponClass, bool bActuallyTakeTheAmmo )
{
	local int Retval;
	local int i;

	Retval = 0;

	// Look to find this class
	for(i=0; i<AmmoStash.length; i++)
	{
		if(AmmoStash[i].WeapClass == AmmoWeaponClass)
		{
			Retval =  AmmoStash[i].Ammo;
			if( bActuallyTakeTheAmmo == TRUE )
			{
				AmmoStash[i].Ammo = 0; // we gave the ammo to the weapon we have none
			}

			return Retval;

		}
	}

	// Not found, no ammo
	return Retval;
}

/** Get total amount of ammo for weapon. If weapon is equipped, will look at that - otherwise will look in stash */
function GetAmmoForWeapon(class<NanoWeapon> AmmoWeaponClass, out int InWeapAmmo, out int SpareAmmo)
{
	local NanoWeapon NanoWeap;

	if((Weapon != None) && (Weapon.Class == AmmoWeaponClass))
	{
		NanoWeap = NanoWeapon(Weapon);
		InWeapAmmo = NanoWeap.GetMagazineSize()-NanoWeap.AmmoUsedCount;

		SpareAmmo = NanoWeap.SpareAmmoCount;

		// semi hack to make UA work with our current ammo system
		if( NanoWeap.HasInfiniteSpareAmmo() == TRUE )
		{
			SpareAmmo += 1;
		}
	}
	else
	{
		//InWeapAmmo = Min(GunClass.default.WeaponMagSize, NP.SpareAmmo);
		//SpareAmmo = Max(0, NP.SpareAmmo - GunClass.default.WeaponMagSize);
		InWeapAmmo = 0;
		SpareAmmo = GetStashAmmoForWeapon(AmmoWeaponClass, FALSE);
	}
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	Super.DisplayDebug(HUD, out_YL, out_YPos);

	HUD.Canvas.SetDrawColor(255,255,128,255);

	out_YPos += out_YL*2;
	HUD.Canvas.SetPos(24,out_YPos);
	HUD.Canvas.DrawText("ActiveSpecialMoveName:" @ ActiveSpecialMoveName);
	out_YPos += out_YL;

	if( ( TeslaShock_NoRun_ActiveUntil - WorldInfo.TimeSeconds ) > 0 )
	{
		HUD.Canvas.DrawText("TeslaShock_NoRun_ActiveUntil:" @ ( TeslaShock_NoRun_ActiveUntil - WorldInfo.TimeSeconds ));
		out_YPos += out_YL;
	}

	if( ( TeslaShock_NoJog_ActiveUntil - WorldInfo.TimeSeconds ) > 0 )
	{
		HUD.Canvas.DrawText("TeslaShock_NoJog_ActiveUntil:" @ ( TeslaShock_NoJog_ActiveUntil - WorldInfo.TimeSeconds ));
		out_YPos += out_YL;
	}

	if( ( TeslaShock_NoJump_ActiveUntil - WorldInfo.TimeSeconds ) > 0 )
	{
		HUD.Canvas.DrawText("TeslaShock_NoJump_ActiveUntil:" @ ( TeslaShock_NoJump_ActiveUntil - WorldInfo.TimeSeconds ));
		out_YPos += out_YL;
	}

	if( ( TeslaShock_NoAttack_ActiveUntil - WorldInfo.TimeSeconds ) > 0 )
	{
		HUD.Canvas.DrawText("TeslaShock_NoAttack_ActiveUntil:" @ ( TeslaShock_NoAttack_ActiveUntil - WorldInfo.TimeSeconds ));
		out_YPos += out_YL;
	}

}

/** Debug mode for sword */
exec simulated function DebugSword()
{
	local NanoWeap_Melee Sword;

	Sword = NanoWeap_Melee(MyNanoWeapon);
	if(Sword != None)
	{
		Sword.bSwordDebug = !Sword.bSwordDebug;
	}
}

reliable client function ClientToggleNanoPowerLock(Name LockName, bool bLocked)
{
	if (bLocked)
	{
		NanoPowerLocks.AddItem(LockName);
		if (NanoPowerLocks.Length == 1)
		{
			StopAllPowers();
		}
	}
	else
	{
		NanoPowerLocks.RemoveItem(LockName);
	}
}

simulated function bool IsNanoPowerLocked()
{
	return NanoPowerLocks.Length > 0;
}

simulated function name GetDefaultCameraMode( PlayerController RequestedBy )
{
	if( RequestedBy != None && RequestedBy.PlayerCamera != None && RequestedBy.PlayerCamera.CameraStyle == 'Fixed' )
	{
		return 'Fixed';
	}

	return 'Default';
}

simulated private function InternalSetCameraType( bool bThirdPerson, optional bool bForce )
{
	local NanoPC PC;
	local NanoPlayerCamera Cam;

	PC = NanoPC(Controller);
	if( PC != None )
	{
		Cam = NanoPlayerCamera(PC.PlayerCamera);
		if( Cam != None )
		{
			if( bThirdPerson )
			{
				Cam.SetThirdPersonCamera( bForce );
			}
			else
			{
				Cam.SetFirstPersonCamera( bForce );
			}
		}
	}
}

simulated event SetThirdPersonCamera( optional bool bForce )
{
	ClearTimer( nameof(SetFirstPersonCamera) );
	ClearTimer( nameof(SetThirdPersonCamera) );
	InternalSetCameraType( TRUE, bForce );
}

simulated event SetFirstPersonCamera( optional bool bForce )
{
	ClearTimer( nameof(SetFirstPersonCamera) );
	ClearTimer( nameof(SetThirdPersonCamera) );
	InternalSetCameraType( FALSE, bForce );
}

simulated event bool ShouldUseThirdPersonCamera()
{
	local NanoPC PC;
	local NanoPlayerCamera Cam;

	PC = NanoPC(Controller);
	if( PC != None )
	{
		Cam = NanoPlayerCamera(PC.PlayerCamera);
		if( Cam != None )
		{
			return Cam.ShouldUseThirdPersonCamera();
		}
	}
	return FALSE;
}

simulated function bool CalcCamera(float DeltaTime, out vector out_CamLoc, out rotator out_camRot, out float out_FOV)
{
	return FALSE;
}

simulated event GetActorEyesViewPoint( out vector out_Location, out Rotator out_Rotation )
{
	local NanoPC PC;

	PC = NanoPC(Controller);

	if( PC != None && PC.PlayerCamera != None )
	{
		PC.PlayerCamera.GetCameraViewPoint(out_Location, out_Rotation);
	}
	else if( Mesh != None )
	{
		out_Location = Mesh.GetBoneLocation( FirstPersonCamBoneName );
		if( IsHumanControlled() )
		{
			out_Rotation = QuatToRotator(Mesh.GetBoneQuaternion(FirstPersonCamBoneName));
		}
		else
		{
			out_Rotation = GetViewRotation();
		}
	}
	else
	{
		Super.GetActorEyesViewPoint( out_Location, out_Rotation );
	}
}

simulated function rotator GetViewRotation()
{
	local NanoPC PC;

	PC = NanoPC(Controller);
	if( PC != None && PC.PlayerCamera != None )
	{
		return PC.PlayerCamera.GetCameraRotation();
	}

	// fallback
	return super.GetViewRotation();
}

simulated function NotifyGrappleTarget()
{
//	TopHalfSlot.PlayCustomAnim('NW_Nano_Absorb_A_Loop', 1.f, 0.25f, 0.25f, TRUE, TRUE, 0.f);
}

simulated function NotifyGrappleTargetInvalid()
{
	TopHalfSlot.StopCustomAnim(0.25f);
}

simulated function bool IsSkydiving()
{
	return bIsSkydiving;
}

simulated function bool IsPlatformJumping()
{
	return bIsPlatformJumping;
}

simulated function bool IsInFan()
{
	return (CurrNanoState == ENS_Dust) && (NanoVolume_Fan(PhysicsVolume) != None);
}

simulated function bool IsInDuctFan()
{
	return bInDuctFan;
}

/** Traces down to where we will be at SkydiveMinDuration seconds from now (if no input), and if nothing is  */
simulated event CheckForSkydive()
{
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local vector Endpoint, HitLocation, HitNormal;
	local float GravityZ;

	if (SplineBase != None)
	{
		bIsSkyDiving = FALSE;
	}
	else
	{
		GravityZ = GetGravityZ();
		if( GravityZ < -100.f )
		{
			Endpoint = Location;

			// Set the endpoint to be approximately where we would land after SkydiveMinDuration
			Endpoint += Velocity * SkydiveMinDuration;

			// Trace from our current location to the endpoint to see if we have anything to land on
			HitActor = Trace(HitLocation, HitNormal, Endpoint, Location, TRUE, vect(0,0,0), HitInfo, TRACEFLAG_Blocking | TRACEFLAG_Bullet);

//			FlushPersistentDebugLines();
//			DrawDebugLine(Location, Endpoint, 255,0,0, TRUE);
//			DrawDebugBox( HitLocation, vect(20,20,20), 255, 0, 0, TRUE );

			// If we hit nothing, then enter the skydive!
			bIsSkydiving = (HitActor == None);
		}
	}
}

simulated function NotifySkydiveCamActivated()
{
	local NanoPC NPC;

	// Play the skydiving animation
	FallingFullBodySlot.PlayCustomAnim('Car_Stab_Mantle_Fly', 1.f, 0.5f, -1.0f);

	// Set the sound mode to the skydiving sound mode
	NPC = NanoPC(Controller);
	if( NPC != None )
	{
		NPC.SetSoundMode('SkyDive');
	}

	// Handle playing the wind whipping sound
	if( AC_Skydiving == None )
	{
		AC_Skydiving = new(self) class'AudioComponent';

		if( AC_Skydiving != None )
		{
			AC_Skydiving.SoundCue = SkydivingSound;
			AttachComponent(AC_Skydiving);
			AC_Skydiving.FadeIn(class'Cam3p_Skydive'.default.FOVBlendTime, 1.f);    // Fade in the sound as the FOV blends
		}
	}

	// Create and enable the skydiving radial blur
	if( RB_Skydive == None )
	{
		RB_Skydive = new(self) class'RadialBlurComponent';

		if( RB_Skydive != None )
		{
			Mesh.AttachComponent(RB_Skydive, class'Cam3p_Skydive'.default.FocusBoneName);
			RB_Skydive.SetEnabled(TRUE);
			RB_Skydive.SetBlurScale(0.f);
		}
	}
}

simulated function NotifySkydiveCamDeactivated()
{
	local NanoPC NPC;

	// Stop the skydiving animation
	FallingFullBodySlot.StopCustomAnim( 0.1f );

	// Set the sound mode back to default
	NPC = NanoPC(Controller);
	if( NPC != None )
	{
		NPC.SetSoundMode('Default');
	}

	// Turn off the wind sounds
	if( AC_Skydiving != None )
	{
		AC_Skydiving.FadeOut(0.15f, 0.f);
		DetachComponent(AC_Skydiving);
		AC_Skydiving = None;
	}

	// Turn off the radial blur
	if( RB_Skydive != None )
	{
		RB_Skydive.SetEnabled(FALSE);
		Mesh.DetachComponent(RB_Skydive);
		RB_Skydive = None;
	}
}

simulated function NotifySuckedIntoFan()
{
	bInDuctFan = TRUE;

	FullBodySlot.PlayCustomAnim('NW_Dust_FanSuck', 1.f, 0.2f, 0.1f, TRUE);
}

simulated function NotifyEjectedFromFan()
{
	local float AnimDuration;

	bInDuctFan = FALSE;

	AnimDuration = FullBodySlot.PlayCustomAnim('NW_Dust_FloatStart', 1.f, 0.25f, 0.1f, TRUE);
	SetTimer(AnimDuration, FALSE, nameof(PlayFanGlideAnim));
}

simulated function PlayFanGlideAnim()
{
	if( Physics == PHYS_Falling )
	{
		FullBodySlot.PlayCustomAnim('NW_Dust_FloatLoop', 1.f, 0.25f, 0.1f, TRUE);
	}
}

delegate DeathNotification(Controller Killer, NanoPawn Victim);

/** Util to see if Other is in front of us - so that we will block damage coming from them */
function bool BlocksDamageFromPawn(Pawn Other)
{
	local float FrontDot;

	// Dot vector from us to other pawn against our 'forward' vector
	FrontDot = Normal(Other.Location - Location) Dot (vect(1,0,0) >> Rotation);

	return(FrontDot > 0.7);
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local Pawn InstigatedByPawn;
	local int SkillIdx;
	local class<NanoDamageType> NanoDamageType;

	// @todo
	// this take damage is missing all of the "structured" handling of damage that we have needed in other games.
	// so we need to at least put that framework in place otherwise we end up in crazy land


	if (Health == DefaultHealth && Damage > 0)
	{
		TimeOfFirstHit = WorldInfo.TimeSeconds;
	}

	// Skip damage if invulnerbale
	if(bPawnInvulnerable)
	{
		//`log(`location@"pawn invulnerable");
		return;
	}

	// Disallow your thrown sword to damage yourself
	if((DamageType == class'NanoGame.NDT_NanoSwordThrown') && (InstigatedBy == Controller))
	{
		return;
	}

	// cache the instigator parms
	if( InstigatedBy != None )
	{
		InstigatedByPawn = InstigatedBy.Pawn;
	}

	NanoDamageType = class<NanoDamageType>(DamageType);

	// when dense and hit by sword/moon/hammer, insta-death
	if((CurrNanoState == ENS_Dense) && (DamageType == class'NanoGame.NDT_RicochetMoonThrown' || DamageType == class'NanoGame.NDT_NanoSwordThrown' || DamageType == class'NanoGame.NDT_DroppingTheHammer'))
	{
		ShatteredByActor = DamageCauser;
		Died(InstigatedBy, class'NanoGame.NDT_Shattered', HitLocation);
	}

	// If you take 'dropping hammer' damage while dusted - insta death by 'dusting'
	if((CurrNanoState == ENS_Dust) && (DamageType == class'NDT_DroppingTheHammer'))
	{
		Died(InstigatedBy, class'NanoGame.NDT_Dusted', Location);
	}

	// for now if they have a shield they block
	if( ( ClassIsChildOf( NanoDamageType, class'NDT_Ballistic' ) == TRUE ) 
		&& bHasShield //  && HitInfo.HitComponent == ShieldMeshComp)
		&& Normal(InstigatedBy.Pawn.Location - Location) dot vector(Rotation) > -0.4  // in front 
		)
	{
		DoBlockedByEffects( HitLocation, rotator(-Momentum), None, SoundCue'Weapon_Sword.Sword.Sword_Impact_Metal_Cue' );
		Damage = 0;
		//`log(`location@"shield block");
	}

	//scripttrace();

	//`log( "!!Orig Damage:" @ Damage @ "InstigatedBy:" @ InstigatedBy @ "DamageType:" @ DamageType );

	// so here we have an issue with the determination of what the state of this pawn is
	// nano skills are active on players
	// CurrNanoState is active on all pawns
	// there is no notion of "aggressive" / "defensive" / "self imposed" powers   So we will need to figure out what to do with that.

	// if we are an AI then we just look at our current state
	if( IsHumanControlled() == FALSE )
	{
		if (CurrNanoState == ENS_Dust && DustedGlobalDamageScale != 1.f)
		{
			Damage *= DustedGlobalDamageScale;
		}
		else if (CurrNanoState == ENS_Dense && DensedGlobalDamageScale != 1.f)
		{
			Damage *= DensedGlobalDamageScale;
		}
	}
	// look at the NanoSkills that are active as we are a human
	else
	{
		// give a chance for each active skill to modify the damage
		for( SkillIdx = 0; SkillIdx < SkillList.Length; SkillIdx++ )
		{
			SkillList[SkillIdx].Skill.ModifyDamage( self, Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );
			//`log( self @ "Skill:" @ Skill @ Skill.bActive @ "Damage:" @ Damage );
		}

		Momentum = vect(0,0,0);
	}


	if( ClassIsChildOf(DamageType, class'NDT_Ballistic') == TRUE )
	{
		//`log(`location@"bullet proof");
		Damage *= (1.0f - ResistenceToBullets);
	}

	// if we are attached to a bull then take 50% damage
	if( NanoPawn_MetaCorp_BullRamBase(Base) != none )
	{
		Damage *= 0.5f;
	}


	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

	// so if we took damage
	if( ( Damage > 0 )
		&& ( IsLocallyControlled() )
		&& ( IsHumanControlled() )
		)
	{
		if( (DamageCauser == None) && ( InstigatedBy != none ) )
		{
			DamageCauser = InstigatedBy.Pawn;
		}

		if (DamageType != class'DmgType_Fell')
		{
			AddRecentHit(DamageCauser,DamageCauser.Location,Damage);
		}

		if( DamagedPPEEffect != None )
		{
			// if we are a NDT use that specific NDT's Damage overlay
			// @ todo we should not be doing non nanodamagetypes
			if( NanoDamageType != none )
			{
				DamagedPPEEffect.Material = NanoDamageType.default.MI_DamageOverlay;
			}
			// use the generic one
			else
			{
				DamagedPPEEffect.Material = class'NanoDamageType'.default.MI_DamageOverlay;
			}

			DamagedPPEEffect.bShowInGame = TRUE;
			// turn off the damage effect
			SetTimer( 0.250f, FALSE, nameof(TurnOffDamagedPPEEffect) );
		}


		// play any associated fx/sounds
		DoDamageEffects( Damage, InstigatedByPawn, HitLocation, NanoDamageType, Momentum, HitInfo );

		// allow the damage type to add any extra fx/etc
		NanoDamageType.static.HandleDamagedPawn( self, InstigatedByPawn, Damage, Momentum );

	}

	if( Damage > 0 )
	{
		if( NanoDamageType != None )
		{
			NanoDamageType.static.PlayExtraDamageSound( self );
		}

		// spawn a crowd panic repulsor
		if( ( NanoDamageType != None ) && ( ClassIsChildOf( NanoDamageType, class'NDT_Melee' ) == TRUE ) )
		{
			SpawnDurationCrowdPanicRepulsor( class'NanoCrowd_PanicRepulsor_MeleeImpact' );
		}
		else
		{
			SpawnDurationCrowdPanicRepulsor( class'NanoCrowd_PanicRepulsor_BulletImpact' );
		}



	}

	if (Health > 0 && HealthRechargeDelay > 0.f)
	{
		// normal delayed health regening
		if( bTouchingHealthTotem == FALSE )
		{
			bIsRechargingHealth = FALSE;
			SetTimer(HealthRechargeDelay,FALSE,nameof(EnableHealthRecharge));
		}
		// if we are touching a health totem then don't set any health recharge delay
		else
		{
			EnableHealthRecharge();
		}
	}
}


function AdjustDamage(out int InDamage, out vector Momentum, Controller InstigatedBy, vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
	local NanoPRI PRI;
	local NanoWeapon Wpn;
	local class<NanoAmmoModifier> AmmoMod;
	local int AmmoModLvl;

	if( InstigatedBy != None && InstigatedBy.Pawn != None )
	{
		Wpn = NanoWeapon(InstigatedBy.Pawn.Weapon);
		PRI = NanoPRI(InstigatedBy.PlayerReplicationInfo);
		if( Wpn != None && PRI != None )
		{
			AmmoMod = PRI.GetAmmoModClass( Wpn.Class, AmmoModLvl );
			if( ( AmmoMod != None ) && ( AmmoModLvl > -1 ) )
			{
				AmmoMod.static.HandleAmmoImpact( AmmoModLvl, self, InstigatedBy, inDamage, HitLocation, HitInfo );
			}
		}
	}
}


/**
 * Creates any damage effects, sounds, anims, etc.
 * Called from TakeDamage(), so only called on ROLE_Authority.
 */
function DoDamageEffects(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
{
	// this should follow the same set up at Gears does.
	// @todo: fix up all our w

}


simulated function StopHitReaction()
{
	//`log(WorldInfo.TimeSeconds@"clearing hit reaction");
	FullBodySlot.StopCustomAnim(0.2f);
}

simulated final function AddRecentHit(Actor NewHitInstigator, vector NewOriginOfHit, int NewDamage)
{
	local int Idx;
	Idx = RecentHits.Length;
	RecentHits.Length = Idx + 1;
	RecentHits[Idx].HitInstigator = NewHitInstigator;
	RecentHits[Idx].OriginOfHit = NewOriginOfHit;
	RecentHits[Idx].Damage = NewDamage;
	RecentHits[Idx].TimeOfHit = WorldInfo.TimeSeconds;
}

/** Quick and dirty function to play the effects for when TakeDamage is blocked by something **/
simulated function DoBlockedByEffects( vector HitLocation, rotator HitRotation, ParticleSystem BlockedEffect, SoundCue BlockedSound )
{
	local SpawnedNanoEmitter ShatteredEffect;

	if( BlockedSound != None )
	{
		PlaySound( BlockedSound, TRUE );
	}


	if( BlockedEffect != None )
	{
		ShatteredEffect = Spawn( class'SpawnedNanoEmitter',,, HitLocation, HitRotation );
		ShatteredEffect.SetTemplate( BlockedEffect, TRUE );
		ShatteredEffect.ParticleSystemComponent.SetScale( 1.0f );
	}
}


simulated function TurnOffDamagedPPEEffect()
{
	DamagedPPEEffect.bShowInGame = FALSE;
}


function EnableHealthRecharge()
{
	bIsRechargingHealth = TRUE;
}

function ThrowWeaponOnDeath()
{
	local NanoDroppedWeapon Asset;
	local vector SocketLocation, StartVelocity;
	local rotator SocketRotation;
	local class<NanoWeapon> WeapClass;
	local SkeletalMeshComponent WeapSkelComp;

	// Init to actor origin, as fallback
	SocketLocation = Location;
	// See if we can do better by spawning from weapon bone (maybe should be belt or something?)
	Mesh.GetSocketWorldLocationAndRotation( 'Weapon_R', SocketLocation, SocketRotation);

	foreach ExtraDroppedWeapons(WeapClass)
	{
		// If this is not the weapon we are already holding (which will be dropped anyway)
		if(WeapClass != MyNanoWeapon.Class)
		{
			Asset = Spawn(class'NanoDroppedWeapon',,, SocketLocation, SocketRotation);
			if (Asset != None)
			{
				WeapSkelComp = SkeletalMeshComponent(WeapClass.default.Mesh);

				if( WeapSkelComp.PhysicsAsset == none )
				{
					`warn( "!!!! ThrowWeaponOnDeath with a NONE PhysicsAsset !!!!"  );	
					ScriptTrace();
				}

				Asset.WeaponClass = WeapClass;

				// Non-melee weapon pickups get ammo
				if(!WeapClass.default.bMeleeWeapon)
				{
					Asset.AmmoAmount = WeapClass.default.DropMagazines * WeapClass.default.WeaponMagSize;
				}

				Asset.SetMeshAndPhysAsset(WeapSkelComp.SkeletalMesh, WeapSkelComp.PhysicsAsset);
				Asset.SkeletalMeshComponent.WakeRigidBody();
				Asset.SkeletalMeshComponent.SetRBAngularVelocity(VRand() * RandRange(-64,64),TRUE);
				
				// we might want to randomize this instead of the default throw at the player
				StartVelocity = vect(0,0,-50);
				Asset.SkeletalMeshComponent.SetRBLinearVelocity(StartVelocity);
				Asset.SkeletalMeshComponent.SetNotifyRigidBodyCollision(TRUE);

				Asset.ActivateInFlightSounds();
			}
		}
	}

	//if( IsHumanControlled() )
	//{
		Super.ThrowWeaponOnDeath();
	//}
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local delegate<DeathNotification> NotifyDeath;
	local NanoPawn NP;
	local NanoPC NPC;
	local float EXPPercentage;

`if(`notdefined(FINAL_RELEASE))
	if( Controller != None && Controller.bGodMode )
	{
		`warn( `location@"KILLED IN GOD MODE?!"@Killer@DamageType );
		ScriptTrace();
	}
`endif

    EndSpecialMove(); // end any special moves we are doing


	if (Super.Died(Killer,DamageType,HitLocation))
	{
		// if anyone is targeting us, make them untarget
		foreach WorldInfo.AllControllers(class'NanoPC', NPC)
		{
			if( NPC.TargetedActor == self )
			{
				// note:  we don't use NanoPC::SetTargetedActor() because that clears the SelectTarget timer, which would prevent a new target from being selected
				NPC.TargetedActor = None;
			}
		}

		EXPPercentage = 1.0f;


		NP = Killer != None ? NanoPawn(Killer.Pawn) : None;


		// need to check for turret killing
		if( NP == None )
		{
			if( NanoTurretBase(Killer.Pawn) != None )
			{
				if( NanoTurretBase(Killer.Pawn).bWasSpawnedByPlayer == TRUE )
				{
					NP = NanoTurretBase(Killer.Pawn).PawnWhoSpawnedMe;
					EXPPercentage = class'NanoSentryTurretBase'.default.EXPPercentage;

					GetGRI().MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumKills_Turret, 1 );
				}
			}
		}

		AddEXP( NP, DamageType, EXPPercentage );
	
		AwardRewardsFromProceduralMissions( NP );

		if( PSC_NaniteTornadoEjectTrail != none )
		{
			PSC_NaniteTornadoEjectTrail.DeactivateSystem();
			PSC_NaniteTornadoEjectTrail = none;
		}

		if( NaniteTornadoFunnel != none )
		{
			NaniteTornadoFunnel.SetTimer( 20.0f, FALSE, nameof( NaniteTornadoFunnel.ShutDownTornado) );
			NaniteTornadoFunnel = none;
		}


		foreach DeathNotifyReceivers(NotifyDeath)
		{
			NotifyDeath(Killer,self);
		}

		// Shattering case
		if(DamageType == class'NDT_Shattered')
		{
			ShatteredBy(ShatteredByActor);
		}
		// Boulder case
		else if(DamageType == class'NDT_BoulderedInto')
		{
			InitRagdoll();
			BoulderedIntoBy(NP);
		}
		// If we died by being hit by a thrown sword- go into thrown pose (see also NanoProj_ThrownSword.ProcessTouch)
		else if(DamageType == class'NanoGame.NDT_NanoSwordThrown')
		{
			bImpaledOnSword = TRUE;
			SetCollision(FALSE, FALSE);
			bCollideWorld = FALSE;
			SetPhysics(PHYS_None);
		}
		else
		{
			DropShield();
			SetPushesRigidBodies(FALSE);
			Mesh.MinDistFactorForKinematicUpdate = 0.0;


			if( DeathReaction.AnimName != '' )
			{
				//`log( "PlayDeathAnimPlayDeathAnim" @ DeathReaction.AnimName );
				//ScriptTrace();

				PlayDeathAnim( Killer );
			}
			else
			{
				InitRagdoll();
				//TurnOnDualSpineConstraints();
			}

			if (DamageType == class'NDT_DroppingTheHammer')
			{
				//Mesh.AddImpulse(Normal(Location - HitLoc) * 1024.f + vect(0,0,512),Location,,FALSE);
				Mesh.SetRBLinearVelocity(Normal(Location - HitLocation) * 512 + vect(0,0,512),TRUE);
				Mesh.SetRBAngularVelocity(VRand() * RandRange(8,16),TRUE);
			}
		}

		// Spawn a blood pool
		if( WorldInfo.NetMode != NM_DedicatedServer )
		{
			SetTimer( 4.0f, FALSE, nameof(SpawnBloodPool) );
		}

		// some death paths seem to go through this (for the time being until we find them and fix them)
		PlayRagDollDeathPhysicsModify();


		StopAllPowers();
		ActiveSkills.Length = 0;

		return TRUE;
	}

	return FALSE;
}


/**
 * This will look at the damage type and give the correct exp to the pawn 
 * For some AddEXP calls we want to divide the exp by some amount.
 *
 **/
function AddEXP( const out NanoPawn NP, class<DamageType> DamageType, optional float EXPPercentage = 1.0f )
{
	local int BonusXP;
	local string XPLabel;
	local PlayerController PC;
	local vector XPFloatDir;


	if( ( NP != none ) && (NP.GetPRI() != None) )
	{
		BonusXP = 0;
		if (`TimeSince(TimeOfFirstHit) < 5.f)
		{
			XPLabel @= class'NanoBonusXPValues'.default.QuickKill.Desc;
			BonusXP += class'NanoBonusXPValues'.default.QuickKill.XP;
		}
		else if (`TimeSince(TimeOfFirstHit) > 20.f)
		{
			XPLabel @= class'NanoBonusXPValues'.default.SlowKill.Desc;
			BonusXP += class'NanoBonusXPValues'.default.SlowKill.XP;
		}

		if (!IsNearFloor(64.f))
		{
			XPLabel @= class'NanoBonusXPValues'.default.ArielKill.Desc;
			BonusXP += class'NanoBonusXPValues'.default.ArielKill.XP;
		}

		if (DamageType == class'NDT_DroppingTheHammer')
		{
			XPLabel @= class'NanoBonusXPValues'.default.DropTheHammerKill.Desc;
			BonusXP += class'NanoBonusXPValues'.default.DropTheHammerKill.XP;
		}
		else if (DamageType == class'NDT_NaniteTornado')
		{
			XPLabel @= class'NanoBonusXPValues'.default.NaniteTornadoKill.Desc;
			BonusXP += class'NanoBonusXPValues'.default.NaniteTornadoKill.XP;
		}
		else if (DamageType == class'NDT_NanoSwordThrown')
		{
			if( NanoAI(Controller) != none && NanoAI(Controller).IsStunnedBy( class'NaniteTornado'.default.StunType ) == TRUE )
			{
				if( `TimeSince(LastJuggleTime) < 3.0f )
				{
					XPLabel @= class'NanoBonusXPValues'.default.SwordThrownJuggledQuickKill.Desc;
					BonusXP += class'NanoBonusXPValues'.default.SwordThrownJuggledQuickKill.XP;
				}
				else
				{
					XPLabel @= class'NanoBonusXPValues'.default.SwordThrownJuggledKill.Desc;
					BonusXP += class'NanoBonusXPValues'.default.SwordThrownJuggledKill.XP;
				}
			}
			else
			{
				XPLabel @= class'NanoBonusXPValues'.default.SwordThrownImpaledKill.Desc;
				BonusXP += class'NanoBonusXPValues'.default.SwordThrownImpaledKill.XP;
			}
		}

		else if (NanoWeap_Melee(NP.Weapon) != None)
		{
			if (NP.LastSwordComboCount > 2)
			{
				XPLabel @= class'NanoBonusXPValues'.default.ComboCountGreaterThan2Kill.Desc;
				BonusXP += class'NanoBonusXPValues'.default.ComboCountGreaterThan2Kill.XP;
			}
			else if (NP.LastSwordComboCount > 1)
			{
				XPLabel @= class'NanoBonusXPValues'.default.ComboCountGreaterThan1Kill.Desc;
				BonusXP += class'NanoBonusXPValues'.default.ComboCountGreaterThan1Kill.XP;
			}
			else
			{
				XPLabel @= class'NanoBonusXPValues'.default.ComboCountZeroKill.Desc;
				BonusXP += class'NanoBonusXPValues'.default.ComboCountZeroKill.XP;
			}

			if (`TimeSince(NP.TimeOfLastKill) < 8.f)
			{
				XPLabel @= class'NanoBonusXPValues'.default.ChainLessThan8SecondsKill.Desc;
				BonusXP += class'NanoBonusXPValues'.default.ChainLessThan8SecondsKill.XP;
			}
		}
		NP.TimeOfLastKill = WorldInfo.TimeSeconds;

		BaseXPValue *= EXPPercentage;
		BonusXP *= EXPPercentage;

		NP.GetPRI().AwardXP(BaseXPValue+BonusXP,XPLabel@"Kill");

		foreach WorldInfo.AllControllers( class'PlayerController', PC )
		{
			if( BaseXPValue != 0 )
			{
				XPFloatDir = VRand();
				XPFloatDir.Z = abs(XPFloatDir.Z); // always go up
				PC.AddDebugText( "XP " @ string(BaseXPValue), self, 5.f, vect(0,0,128.f), vect(0.0f,0.0f,220.f) + (vect(96.f,96.f,256.f) * XPFloatDir), class'HUD'.default.RedColor, TRUE, FALSE, FALSE, class'Engine'.static.GetMediumFont() );
			}

			if( BonusXP != 0 )
			{
				XPFloatDir = VRand();
				XPFloatDir.Z = abs(XPFloatDir.Z); // always go up
				PC.AddDebugText( "BonusXP "@ string(BonusXP), self, 5.f, vect(0,0,128.f), vect(0.0f,0.0f,128.f) + (vect(64.f,64.f,128.f) * XPFloatDir), class'HUD'.default.RedColor, TRUE, FALSE, FALSE, class'Engine'.static.GetMediumFont() );
			}
		}


	}
}

function SetDyingPhysics()
{
	if( DeathReaction.AnimName == '' )
	{
		Super.SetDyingPhysics();
	}
}

simulated function float PlayDeathAnim( Controller Killer, optional float AnimPos = -1.f )
{
	DoSpecialMove( 'NSM_Melee_DeathReaction', TRUE );
	return (Mesh.GetAnimLength( DeathReaction.AnimName ) - FMax( AnimPos, 0.f )) * DeathReaction.PlayRate;
}

/** Function that will be active via a timer, so that the tick() function will not force us to ragdoll before our death anim plays. **/
simulated function PlayingDeathAnim();

function TurnToRagDollPhysics()
{
	// Turning to Rag Doll
	if( Physics != PHYS_RigidBody )
	{
		SetPhysics(PHYS_RigidBody);

		// Add velocity of base upon death.
		AddBaseLinearVelocityUponWhenGoingRagDoll();
	}

	// Turn off collision on cylinder component and switch to skeleton physics
	CollisionComponent = Mesh;

	// disable unreal collision on ragdolls
	SetCollision(TRUE, FALSE);

	if( bEnableEncroachCheckOnRagdoll )
	{
		bNoEncroachCheck = FALSE;
	}

	// Set Physics weight to 1
	Mesh.PhysicsWeight = 1.f;
	Mesh.SetRBLinearVelocity( Mesh.RootMotionVelocity, TRUE );

/*
	`log( `showvar(DeathReaction.HitLocation)@`showvar(DeathReaction.HitDirection) );
	FlushPersistentDebugLines();
	DrawDebugBox( DeathReaction.HitLocation, vect(5,5,5), 255, 0, 0, TRUE );
	DrawDebugLine( DeathReaction.HitLocation, DeathReaction.HitLocation + DeathReaction.HitDirection * 64.f, 255, 0, 0, TRUE );
*/
	Mesh.AddImpulse( DeathReaction.HitDirection * 1000.f, DeathReaction.HitLocation,, TRUE );


	// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
	PlayRagDollDeathPhysicsModify();

	// Make sure all bodies are unfixed
	Mesh.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);

	Mesh.bUpdateJointsFromAnimation = TRUE;
	Mesh.bUpdateKinematicBonesFromAnimation = TRUE;

	// Wake up physics
	Mesh.WakeRigidBody();

	// If Pawn had broken constraints, then we need to make sure child bodies and joints are not turned back into kinematic state
	if( bHasBrokenConstraints )
	{
		Mesh.UpdateMeshForBrokenConstraints();
	}
}

/** Add Base Linear Velocity Upon Death. Takes into account ClampedBase and InteractionPawn */
simulated function AddBaseLinearVelocityUponWhenGoingRagDoll()
{
	local Actor TestBase;

	// Current Base
	TestBase = Base;
	if( TestBase != None && !TestBase.bStatic )
	{
		//`log( "TestBase.Velocity:" @ TestBase.Velocity );
		Mesh.SetRBLinearVelocity(TestBase.Velocity, FALSE);
	}
}

simulated function PlayRagDollDeathPhysicsModify()
{
	// Allow all ragdoll bodies to collide with all physics objects (ie allow collision with things marked RigidBodyIgnorePawns)
	Mesh.SetRBChannel(RBCC_DeadPawn);
	Mesh.SetRBCollidesWithChannel(RBCC_Pawn, FALSE);
}

/** Utility for scaling joint limits down of specific bones. */
simulated native function ReduceConstraintLimits();
simulated native function ReduceMotorStrength();


simulated function AwardRewardsFromProceduralMissions( NanoPawn NP )
{
	local NanoProceduralMissionRewardBase NPMR;

	foreach ProceduralMissionRewards( NPMR )
	{
		NP.GetPRI().AwardXP( NPMR.Experience, "Procedural Mission Experience" );
		NP.GetPRI().AwardXP( NPMR.Currency, "Procedural Mission Currency" );
		NPMR.Destroy();
	}


	ProceduralMissionRewards.Length = 0;
}


simulated function ShatteredBy(Actor Shatterer);
simulated function BoulderedIntoBy(NanoPawn NP);

function SetMovementPhysics()
{
	if( bKnockedDown || InteractionPawn != None )
	{
		return;
	}

	if(bImpaledOnSword || bAttachedToTackler || NanoPerchPoint(Base) != None || Pacifier_LimbBase(Base) != None || MantleState != MANTLE_None )
	{
		SetPhysics(PHYS_None);
	}
	else
	{
		// check for water volume
		if( PhysicsVolume.bWaterVolume )
		{
			SetPhysics(PHYS_Swimming);
		}
		else if( Physics != PHYS_Falling )
		{
			if( !FastTrace( Location - vect(0,0,8), Location, GetCollisionExtent() ) )
			{
				SetPhysics(PHYS_Walking);
			}
			else
			{
				SetPhysics(PHYS_Falling);
			}
		}
	}
}

/** Allow basing when tackling */
simulated function bool CanBeBaseForPawn(Pawn APawn)
{
	local NanoWeap_Melee Sword;
	local NanoPawn NP;

	if( bCanBeBaseForPawns )
	{
		return TRUE;
	}

	NP = NanoPawn(APawn);
	if( NP != None && (NP.InteractionPawn == self) )
	{
		return TRUE;
	}

	Sword = NanoWeap_Melee(Weapon);
	if( bIsDoingMeleeAttack && Sword != None && Sword.HasAttackCollidedWithVictim( APawn ) )
	{
		return TRUE;
	}

	return FALSE;
}

simulated function bool CanDoMeleeAttack()
{
	if( bIsAttachedToWall || bStabMantling || bPreparingStabMantle )
	{
		return FALSE;
	}

	if( InteractionPawn != None )
	{
		if( InteractionType == PAWNINTER_Pin )
		{
			return TRUE;
		}
		return FALSE;
	}

	return TRUE;
}

simulated function bool CanTackle()
{
	//`log(`location@`showvar(!bCanPerformTackle)@`showvar(bSummoningInProgress)@`showvar(Physics != PHYS_Walking)@`showvar(InteractionPawn != None));
	if( !bCanPerformTackle || bSummoningInProgress )
	{
		return FALSE;
	}

	if( Physics != PHYS_Walking )
	{
		return FALSE;
	}

	if( InteractionPawn != None )
	{
		return FALSE;
	}

	return TRUE;
}

/** Look ahead to see if a tackle victim is about to be hit */
simulated function bool AttemptToTackle()
{
	local float PredictDist, TestDist;
	local vector TestDir, VelDir;
	local NanoPawn_MetaCorpBase TestPawn, TackledPawn;
	local Rotator PawnRot;
	local NanoPC PC;
	local NanoAI AI;
	local Rotator TackledPawnRot;
	local float AnimTime;

	if (InteractionPawn != None)
	{
		return FALSE;
	}

	// Direction to look in
	if (VSize(Velocity) < 10)
	{
		VelDir = vector(Rotation);
		PredictDist = (2.0 * CylinderComponent.CollisionRadius) + (PreTackleAnimTime * default.GroundSpeed);
	}
	else
	{
		VelDir = Get2DVelDir();
		// How far to look ahead for tacklee
		PredictDist = (2.0 * CylinderComponent.CollisionRadius) + (PreTackleAnimTime * VSize2D(Velocity));
	}

	foreach WorldInfo.AllPawns(class'NanoPawn_MetaCorpBase', TestPawn)
	{
		if( TestPawn != self &&
			TestPawn.CurrNanoState == ENS_Normal &&
			TestPawn.Health > 0 &&
			TestPawn.Physics != PHYS_RigidBody )
		{
			// Calc distance to target
			TestDir = (TestPawn.Location - Location);
			TestDist = VSize(TestDir);
			// normalize to make dir vector
			TestDir /= TestDist;

			// If close enough and ahead
			//`log(TestPawn@TestDist@(TestDir dot VelDir));
			if((TestDist <= PredictDist) && (TestDir dot VelDir > 0.8)) // within ~15 degrees of vel direction
			{
				TackledPawn = TestPawn;
			}
		}
	}

	// We found a pawn! Play tackle anim on both parties
	if( TackledPawn != None )
	{
		if (!bEmptyHanded)
		{
			HolsterCurrentWeapon();
		}

		DropShield();

		RunningFullBodySlot.StopCustomAnim(0.1f);
		AnimTime = FullBodySlot.PlayCustomAnim('NW_Tackle_Start', 1.0, 0.1, 0.1f, FALSE, TRUE);

		// Turn dude we are about to hit to face us
		TackledPawnRot = rotator(vect(-1,0,0) >> Rotation);
		TackledPawn.SetDesiredRotation(TackledPawnRot);

		TackledPawn.FullBodySlot.PlayCustomAnim('Hit_Tackle_Start', 1.0, 0.1, 0.1f, FALSE, TRUE);
		TackledPawn.SetTimer(0.033f,TRUE,nameof(InterpRelativeLocation));

		PlayerController(Controller).PlaySound(StartTackleLungeBodySound);
		PlayerController(Controller).PlaySound(StartTackleLungeEffortSound);

		// We sync up the tackle animations
		TackleRunSeqNode.SetPosition(0.0, FALSE);
		TackledPawn.TackleRunSeqNode.SetPosition(0.0, FALSE);

		LinkInteractionPawn( TackledPawn, PAWNINTER_Tackle, CleanupTackledActor );

		if( NanoPawn_MetaCorp_NanoInfantry(TackledPawn) != None )
		{
			NanoPawn_MetaCorp_NanoInfantry(TackledPawn).NADSResponse_TrooperWasTackled();
		}

		// Sound/shake
		PC = NanoPC(Controller);
		if( PC != None )
		{
			PC.SetTargetedActor(None);
		}

		TackleStartTime = WorldInfo.TimeSeconds;

		// Disable movement physics
		InteractionPawn.SetPhysics( PHYS_None );

		// Move to right location and attach (looking back at you)
		PawnRot = rotator(vect(-1,0,0) >> Rotation);
		InteractionPawn.SetCollision(FALSE,FALSE);
		InteractionPawn.SetRotation(PawnRot);
		//InteractionPawn.SetLocation(Location);
		InteractionPawn.SetHardAttach(TRUE);
		InteractionPawn.SetBase(self);
		InteractionPawn.bAttachedToTackler = TRUE;
		InteractionPawn.DropShield();

		// Fire kismet events
		TriggerEventClass(class'SeqEvt_NanoActionPerformed', InteractionPawn, 2);

		// add stimulus for the AI.  We just tackled a foe and are going throw and kill them!
		NanoGRI(WorldInfo.GRI).AddStimuliInARadiusAroundEvent( 1024, self, Location, TRUE, FALSE, TRUE, TRUE );

		// Start looping sound
		TackleLoopAC.FadeIn(0.25, 1.0);

		AI = NanoAI(InteractionPawn.Controller);
		if( AI != None )
		{
			AI.StunAI( 0.f, 'Tackled' );
			AI.AbortCommand( None, class'GameAICommand' );
		}

		DeactivateSelfNanoPower(class'NanoSkill_Ghost');
		DeactivateSelfNanoPower(class'NanoSkill_Dense');

		ForceSprintTimer = AnimTime;

		return TRUE;
	}

	return FALSE;
}

private function InterpRelativeLocation()
{
	if (VSize(RelativeLocation) > 1)
	{
		SetRelativeLocation(VInterpTo(RelativeLocation,vect(0,0,0),0.033f,4));
	}
	else
	{
		SetRelativeLocation(vect(0,0,0));
		ClearTimer(nameof(InterpRelativeLocation));
	}
}

function KillPawn()
{
	Died( LastHitBy, class'NDT_Melee', Location );
}

simulated function TackledBy( NanoPawn Tackler );

/** Called to throw a tackled actor forwards */
simulated function ThrowTackledActor()
{
	local NanoAI AI;
	local float AnimTime;
	local NanoPC PC;
	local Actor TargetedActor;
	local Vector	FindLoc;
	local Rotator	FindRot;

	//`log(`location@`showvar(InteractionType)@`showvar(!IsTimerActive(nameof(ClearInteractionPawn))));

	if( InteractionPawn != None && InteractionType == PAWNINTER_Tackle && !IsTimerActive(nameof(ClearInteractionPawn)) )
	{
		PC = NanoPC(Controller);
		if( PC != None )
		{
			FindLoc = Location;
			FindRot = Rotation;
			TargetedActor = PC.SelectTarget_Worker( PC.MeleeStickRateTarget, 1024.f, 0.5f, FindLoc, FindRot );
			if( TargetedActor != None )
			{
				SetDesiredRotation( Rotator(TargetedActor.Location-Location), TRUE, FALSE, 0.1f );
			}
			else
			{
				SetDesiredRotation( Rotation, TRUE );
			}
		}

		// Play sound
		PlayerController(Controller).PlaySound(ThrowTackleBodySound);
		PlayerController(Controller).PlaySound(ThrowTackleEffortSound);

		// Play throw anim on both parties
		InteractionPawn.FullBodySlot.SetRootBoneAxisOption(RBA_Discard, RBA_Discard, RBA_Discard);
		AnimTime = InteractionPawn.FullBodySlot.PlayCustomAnim('Hit_Tackle_Throw', 1.0, 0.1, 0.1, FALSE, TRUE);
		InteractionPawn.FullBodySlot.SetRootBoneAxisOption(RBA_Translate, RBA_Translate, RBA_Translate);
		InteractionPawn.Mesh.RootMotionMode = RMM_Relative;

		InteractionPawn.bJuggled = TRUE;

		InteractionPawn.LastHitBy = Controller;
		InteractionPawn.SetTimer(AnimTime,FALSE,nameof(KillPawn));
		InteractionPawn.SetCollision(TRUE,TRUE);

		FullBodySlot.SetRootBoneAxisOption(RBA_Discard, RBA_Discard, RBA_Discard);
		AnimTime = FullBodySlot.PlayCustomAnim('NW_Tackle_Throw', 1.0, 0.1, 0.1, FALSE, TRUE);
		FullBodySlot.SetRootBoneAxisOption(RBA_Discard, RBA_Discard, RBA_Discard);
		Mesh.RootMotionMode = InteractionPawn.default.Mesh.RootMotionMode;
//		FullBodySlot.SetRootBoneAxisOption(RBA_Translate, RBA_Translate, RBA_Translate);
//		Mesh.RootMotionMode = RMM_Accel;
		bThrowingTackledActor = TRUE;

		// And then set timer for actually launching the dude
		SetTimer(AnimTime, FALSE, nameof(ClearInteractionPawn));

		AI = NanoAI(InteractionPawn.Controller);
		if( AI != None )
		{
			AI.UnStunAI( 'Tackled' );
			AI.StunAI( 0.f, 'Knockback' );

			NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_Combat_MeleeCircle_ThrownByPlayer, InteractionPawn);
		}
	}
}

simulated function CleanupTackledActor()
{
	local vector HitL, HitN;
	local Actor HitA;
	//`log(`location@`showvar(InteractionPawn)@`showvar(InteractionPawn.bJuggled));
	if( InteractionPawn != None )
	{
		InteractionPawn.SetBase(None);
		InteractionPawn.SetHardAttach(FALSE);
		InteractionPawn.bAttachedToTackler = FALSE;
		if (InteractionPawn.Health > 0)
		{
			InteractionPawn.FullBodySlot.SetRootBoneAxisOption(RBA_Discard, RBA_Discard, RBA_Discard);
			InteractionPawn.Mesh.RootMotionMode = InteractionPawn.default.Mesh.RootMotionMode;
			InteractionPawn.SetPhysics(PHYS_Falling);
			InteractionPawn.SetCollision(TRUE,TRUE);

			HitA = InteractionPawn.Trace(HitL,HitN,InteractionPawn.Location+vect(0,0,-512),InteractionPawn.Location,FALSE);
			if (HitA == None || Abs(InteractionPawn.Location.Z - HitL.Z) > 256)
			{
				`log(`location);
				InteractionPawn.PlaySound(ThrowTackleFallingSound);
			}
			else
			{
				InteractionPawn.PlaySound(ThrowTacklePainSound);
			}


			InteractionPawn.RecoverFromRagdollTime = WorldInfo.TimeSeconds + 5.f;
			InteractionPawn.ServerKnockdown( InteractionPawn.Mesh.RootMotionVelocity , vect(1,1,1) );

		}
	}

	FullBodySlot.SetRootBoneAxisOption(RBA_Discard, RBA_Discard, RBA_Discard);
	Mesh.RootMotionMode = InteractionPawn.default.Mesh.RootMotionMode;

	bThrowingTackledActor = FALSE;
	bSlammingTackledActor = FALSE;


	// Stop sound
	TackleLoopAC.FadeOut(0.2, 0.0);

	LockDesiredRotation( FALSE );

	SetTimer(1.5f,FALSE,nameof(DisallowMantles));
}

/** Looks ahead to see if we should start playing anim slamming tackled pawn into wall */
simulated function DoPreWallTackleSlamAnimCheck()
{
	local float PredictDist, AnimTime;
	local vector HitL, HitN;
	local Actor HitA;
	local Vector FwdDir;

	// How far to look ahead for wall
	PredictDist = (CylinderComponent.CollisionRadius) + (PreTackleSlamAnimTime * VSize2D(Velocity));

	// Get direction to look in
	FwdDir = Normal(Vector(Rotation) - (Floor * (Floor DOT Vector(Rotation))));

	// Look for something to hit
	HitA = Trace(HitL, HitN, Location + (PredictDist * FwdDir) + vect(32,0,0), Location, FALSE);
	if( HitA != None && HitA.bWorldGeometry && HitN.Z < WalkableFloorZ )
	{
		InteractionPawn.FullBodySlot.SetRootBoneAxisOption(RBA_Discard, RBA_Discard, RBA_Discard);
		InteractionPawn.FullBodySlot.PlayCustomAnim('Hit_Tackle_Wall_Slam', 1.0, 0.1, 0.1, FALSE, TRUE);
		InteractionPawn.FullBodySlot.SetRootBoneAxisOption(RBA_Translate, RBA_Translate, RBA_Translate);
		InteractionPawn.Mesh.RootMotionMode = RMM_Accel;
		InteractionPawn.bKnockDownOnLanding = TRUE;

		FullBodySlot.SetRootBoneAxisOption(RBA_Discard, RBA_Discard, RBA_Discard);
		AnimTime = FullBodySlot.PlayCustomAnim('NW_Tackle_Wall_Slam', 1.0, 0.1, 0.1, FALSE, TRUE);
		FullBodySlot.SetRootBoneAxisOption(RBA_Translate, RBA_Translate, RBA_Translate);
		Mesh.RootMotionMode = RMM_Translate;
		SetDesiredRotation( Rotation, TRUE );
		bSlammingTackledActor = TRUE;

		// safety call just in case we don't make contact with the wall
		SetTimer(AnimTime * 0.7,FALSE,nameof(HitWallWithTackledActor));

		PlayerController(Controller).PlaySound(TackleSlamLungeBodySound);
		PlayerController(Controller).PlaySound(TackleSlamLungeEffortSound);
	}
}

/** Called when we hit a wall with someone tackled */
simulated function HitWallWithTackledActor()
{
	ClearTimer(nameof(HitWallWithTackledActor));
	if( InteractionPawn != None )
	{
		// Sound/shake
		InteractionPawn.PlaySound(TackleWallSlamPainSound);
		InteractionPawn.PlaySound(TackleWallSlamDeadBodySound);

		// Death
		InteractionPawn.Died(Controller, class'NanoGame.NDT_Tackled', Location);

		TriggerEventClass(class'SeqEvt_NanoActionPerformed', InteractionPawn, 3);

		ClearInteractionPawn();

		// Force us to a stop when we hit a wall
		// We have to do this after releasing actor, otherwise it does throw anim
		ForceDashStop();
	}
}

simulated function ClientReStart()
{
	local LocalPlayer LP;

	if (PlayerController(Controller) != None)
	{
		// Grab PP effects, and set to correct initial state
		LP = LocalPlayer(PlayerController(Controller).Player);
		if (LP != None)
		{
			SpeedPPEffect = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('SpeedBlur'));
			if (SpeedPPEffect != None)
			{
				SpeedPPEffect.bShowInGame = FALSE;
				SpeedPPMatInst = MaterialInstanceTimeVarying(SpeedPPEffect.Material);
			}

			ScreenPPEffect = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('ScreenEffect'));
			if (ScreenPPEffect != None)
			{
				ScreenPPMatInst = MaterialInstanceTimeVarying(ScreenPPEffect.Material);
			}

			StatePPEffect = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('DustDense'));
			if (StatePPEffect != None)
			{
				StatePPEffect.Material = None;
			}

			MenuBlurEffect = DOFAndBloomEffect(LP.PlayerPostProcess.FindPostProcessEffect('MenuBlur'));

			DamagedPPEEffect = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('DamageOverlay'));
			if (DamagedPPEEffect != None)
			{
				DamagedPPEEffect.bShowInGame = FALSE;
			}

			// setup health/damage material overlay
	 		HealthPPEffect = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('HealthOverlay'));
			if (HealthPPEffect != None)
			{
 				HealthOverlayMIC = new(self) class'MaterialInstanceConstant';
 				HealthOverlayMIC.SetParent(HealthPPEffect.Material);
 				HealthPPEffect.Material = HealthOverlayMIC;
 				HealthPPEffect.bShowInGame = FALSE;
			}
		}
    }
}


simulated function StopAllPowers()
{
	local int Idx;

	if( CurrNanoState != ENS_Normal )
	{
		SetNanoState( ENS_Normal, Controller );
	}

	for( Idx = 0; Idx < ActiveSkills.Length; Idx++ )
	{
		ActiveSkills[Idx].DeactivateSkill();
	}
}


/** Allows NanoSkill using Pawns to have a chance to modify the Starting NanoPowerBuckets **/
function int GetDefaultStartinNanoPowerBuckets();

simulated final function float GetNanoPower()
{
	return NanoPower;
}


simulated final function bool HasEnoughNanoBuckets( float NumBucketsToConsume, optional bool bPlayNotEnoughSound )
{
	//`log(`location@`showvar(NumBucketsToConsume)@`showvar(NanoPowerBucketSize));
	return HasEnoughNanoPower( NumBucketsToConsume * NanoPowerBucketSize, bPlayNotEnoughSound );
}

/**
 * If you have enough enough nano power.  This is useful for testing before doing things as often you have a bunch of functions to do the action.
 * and the actual paying of the cost is deferred / in a function that is lower level.
 **/
simulated final function bool HasEnoughNanoPower( float Amount, optional bool bPlayNotEnoughSound )
{
	local NanoPC PC;
	PC = NanoPC(Controller);
	if( PC != None && PC.bInfiniteNanoPower )
	{
		return TRUE;
	}

	if( ( GetNanoPower() >= Amount )
		&& ( Amount >= 0 )
		)
	{
		return TRUE;
	}

	if( (bPlayNotEnoughSound == TRUE) && (Amount >= 0) )
	{
		PlaySound( NotEnoughNanoPowerSound, TRUE );
	}

	return FALSE;
}


simulated function SetNanoBuckets(const int NewNumOfBuckets, optional bool bUpdateNanoPower)
{
    NumOfNanoPowerBuckets = NewNumOfBuckets;
    MaxNanoPower = NumOfNanoPowerBuckets * NanoPowerBucketSize;
    if (bUpdateNanoPower)
    {
		NanoPower = MaxNanoPower;
    }
}

simulated function int GetNumEmptyNanoBuckets()
{
	// get how much nano power we have used up and then determine how many buckets that is
	return ( ( MaxNanoPower - GetNanoPower() ) / NanoPowerBucketSize );
}


/** ALL nano power adding must go through this function.  Otherwise we enter the land of madness.  Any code not using this function is incorrect. **/
simulated final function SetNanoPower( float Amount )
{
	NanoPower = Amount;
}


/** Number of buckets of nano power to add **/
simulated final function AddNanoBuckets( float Amount )
{
	AddNanoPower( Amount * NanoPowerBucketSize );
}


/** ALL nano power adding must go through this function.  Otherwise we enter the land of madness.  Any code not using this function is incorrect. **/
simulated final function AddNanoPower( float Amount )
{
	NanoPower += Amount;
	NanoPower = FClamp( NanoPower, 0, MaxNanoPower );

	if( NanoPower >= MaxNanoPower )
	{
		TriggerEventClass( class'SeqEvt_NanoPowerLimitReached', self, 0 );
	}
}


simulated final function bool ConsumeNanoBucket( float NumBucketsToConsume = 1.f, optional bool bForce )
{
    //`log(`location@`showvar(NumBucketsToConsume)@`showvar(NanoPowerBucketSize));
    return ConsumeNanoPower( NumBucketsToConsume * NanoPowerBucketSize, FALSE,, bForce );
}

/** ALL nano power usage must go through this function.  Otherwise we enter the land of madness.  Any code not using this function is incorrect. **/
simulated final function bool ConsumeNanoPower(float Amount, optional bool bDelayRecharge = TRUE, optional float AdditionalRechargeDelay, optional bool bForce)
{
	local NanoPC PC;
    //`log(`location@`showvar(Amount));
	PC = NanoPC(Controller);

	// On the client, always return true, since the server will replicate down our current nano amount
	if( Role < ROLE_Authority )
	{
		return TRUE;
	}

	// If we have infinite power, or amount to spend is zero, automatic 'yes'
	if((PC != None && (PC.bInfiniteNanoPower || PC.bCinematicMode)) || (Abs(Amount) < 0.01))
	{
		return TRUE;
	}

	if (Amount < 0.f)
	{
		AddNanoPower( -Amount );
	}
	else if (bForce || GetNanoPower() >= Amount)
	{
		NanoPower = FClamp(NanoPower - Amount, 0.f, MaxNanoPower);
		if( bDelayRecharge && (WorldInfo.TimeSeconds > LastNanoPowerUseTime) )
		{
			LastNanoPowerUseTime = WorldInfo.TimeSeconds + AdditionalRechargeDelay;
		}
		if( NanoPower <= 0.f )
		{
			TriggerEventClass( class'SeqEvt_NanoPowerLimitReached', self, 1 );
		}
		return TRUE;
	}
	return FALSE;
}


//// our second nanopower economy stat

/** Allows NanoSkill using Pawns to have a chance to modify the Starting NanoPowerBuckets **/
function int GetDefaultStartinNanoPowerForgeCoreBuckets();

simulated final function float GetNanoPowerForgeCore()
{
	return NanoPowerForgeCore;
}


simulated final function bool HasEnoughNanoForgeCoreBuckets( float NumBucketsToConsume, optional bool bPlayNotEnoughSound )
{
	//`log(`location@`showvar(NumBucketsToConsume)@`showvar(NanoPowerBucketSize));
	return HasEnoughNanoPowerForgeCore( NumBucketsToConsume * NanoPowerForgeCoreBucketSize, bPlayNotEnoughSound );
}

/**
 * If you have enough enough nano power.  This is useful for testing before doing things as often you have a bunch of functions to do the action.
 * and the actual paying of the cost is deferred / in a function that is lower level.
 **/
simulated final function bool HasEnoughNanoPowerForgeCore( float Amount, optional bool bPlayNotEnoughSound )
{
	local NanoPC PC;
	PC = NanoPC(Controller);
	if( PC != None && PC.bInfiniteNanoPower )
	{
		return TRUE;
	}

	if( ( GetNanoPowerForgeCore() >= Amount )
		&& ( Amount >= 0 )
		)
	{
		return TRUE;
	}

	if( (bPlayNotEnoughSound == TRUE) && (Amount >= 0) )
	{
		PlaySound( NotEnoughNanoPowerSound, TRUE );
	}

	return FALSE;
}


simulated function SetNanoForgeCoreBuckets(const int NewNumOfBuckets, optional bool bUpdateNanoPower)
{
    NumOfNanoPowerForgeCoreBuckets = NewNumOfBuckets;
    MaxNanoPowerForgeCore = NumOfNanoPowerForgeCoreBuckets * NanoPowerForgeCoreBucketSize;

	if (bUpdateNanoPower)
    {
		NanoPowerForgeCore = MaxNanoPowerForgeCore;
    }
}

simulated function int GetNumEmptyNanoForgeCoreBuckets()
{
	// get how much nano power we have used up and then determine how many buckets that is
	return ( ( MaxNanoPowerForgeCore - GetNanoPowerForgeCore() ) / NanoPowerForgeCoreBucketSize );
}


/** ALL nano power adding must go through this function.  Otherwise we enter the land of madness.  Any code not using this function is incorrect. **/
simulated final function SetNanoPowerForgeCore( float Amount )
{
	NanoPowerForgeCore = Amount;
}


/** Number of buckets of nano power to add **/
simulated final function AddNanoForgeCoreBuckets( float Amount )
{
	AddNanoPowerForgeCore( Amount * NanoPowerForgeCoreBucketSize );
}


/** ALL nano power adding must go through this function.  Otherwise we enter the land of madness.  Any code not using this function is incorrect. **/
simulated final function AddNanoPowerForgeCore( float Amount )
{
	NanoPowerForgeCore += Amount;
	NanoPowerForgeCore = FClamp( NanoPowerForgeCore, 0, MaxNanoPowerForgeCore );

	if( NanoPowerForgeCore >= MaxNanoPowerForgeCore )
	{
		TriggerEventClass( class'SeqEvt_NanoPowerForgeCoreLimitReached', self, 0 );
	}
}


simulated final function bool ConsumeNanoForgeCoreBucket( float NumBucketsToConsume = 1.f, optional bool bForce )
{
    //`log(`location@`showvar(NumBucketsToConsume)@`showvar(NanoPowerBucketSize));
    return ConsumeNanoPowerForgeCore( NumBucketsToConsume * NanoPowerForgeCoreBucketSize, FALSE,, bForce );
}

/** ALL nano power usage must go through this function.  Otherwise we enter the land of madness.  Any code not using this function is incorrect. **/
simulated final function bool ConsumeNanoPowerForgeCore(float Amount, optional bool bDelayRecharge = TRUE, optional float AdditionalRechargeDelay, optional bool bForce)
{
	local NanoPC PC;
    //`log(`location@`showvar(Amount));
	PC = NanoPC(Controller);

	// On the client, always return true, since the server will replicate down our current nano amount
	if( Role < ROLE_Authority )
	{
		return TRUE;
	}

	// If we have infinite power, or amount to spend is zero, automatic 'yes'
	if((PC != None && (PC.bInfiniteNanoPower || PC.bCinematicMode)) || (Abs(Amount) < 0.01))
	{
		return TRUE;
	}

	if (Amount < 0.f)
	{
		AddNanoPowerForgeCore( -Amount );
	}
	else if (bForce || GetNanoPowerForgeCore() >= Amount)
	{
		NanoPowerForgeCore = FClamp(NanoPowerForgeCore - Amount, 0.f, MaxNanoPowerForgeCore);
		if( bDelayRecharge && (WorldInfo.TimeSeconds > LastNanoPowerUseTime) )
		{
			LastNanoPowerUseTime = WorldInfo.TimeSeconds + AdditionalRechargeDelay;
		}
		if( NanoPowerForgeCore <= 0.f )
		{
			TriggerEventClass( class'SeqEvt_NanoPowerForgeCoreLimitReached', self, 1 );
		}
		return TRUE;
	}
	return FALSE;
}



/** Turn on effects for sliding to a stop */
simulated function FootSlideEffectOn()
{
	if( PSC_FootSlide == None )
	{
		PSC_FootSlide = new(self) class'NanoParticleSystemComponent';
		PSC_FootSlide.bAutoActivate = FALSE;
		PSC_FootSlide.SetTemplate( PS_FootSlide );
		Mesh.AttachComponentToSocket( PSC_FootSlide, FootSlideSocketName );
	}

	PSC_FootSlide.ActivateSystem();
	// the issue is that sometimes the notify for the FootSlideEffectOff will not be triggered as that animation was interrupted
	SetTimer( 5.0f, FALSE, nameof(FootSlideEffectOff) );  // safeguard to turn this off
}

/** Turn off effects for sliding to a stop */
simulated function FootSlideEffectOff()
{
	ClearTimer( nameof(FootSlideEffectOff) );
	//if seeing access nones here that means that this or FootSlideEffectOn is not being called at the correct time
	PSC_FootSlide.DeactivateSystem();
}


/** Called by an anim notify when stabbing a wall with the sword */
simulated function OnAnimSwordWallStab()
{
	local NanoWeap_Melee Weap;

	Weap = NanoWeap_Melee(Weapon);
	if( Weap != None )
	{
		Weap.PSC_WallStabEffect.ActivateSystem();
	}
}

/** Toggle status of effects for sliding down slope on back */
simulated function ToggleSlidingEffects(bool bActive)
{
	if(bSlidingEffectsActive == bActive)
	{
		return;
	}

	if(bActive)
	{
		AC_FeetDraggingAlongSurface.FadeIn( 0.250f, 1.0f );
	}
	else
	{
		AC_FeetDraggingAlongSurface.FadeOut( 0.250f, 0.0f );
	}

	bSlidingEffectsActive = bActive;
}

/** Toggle status of effects for sliding down slope using sword */
simulated function ToggleSwordSlidingEffects(bool bActive)
{
	if(bSwordSlidingEffectsActive == bActive)
	{
		return;
	}

	if(bActive)
	{
		AC_SwordDraggingAlongSurface.FadeIn( 0.250f, 1.0f );
		NanoWeap_Melee(Weapon).PSC_WallSlideEffect.ActivateSystem();
	}
	else
	{
		AC_SwordDraggingAlongSurface.FadeOut( 0.250f, 0.0f );
		NanoWeap_Melee(Weapon).PSC_WallSlideEffect.DeactivateSystem();
	}

	bSwordSlidingEffectsActive = bActive;
}

final function FindFloor()
{
	local Actor HitA;
	local vector HitN, HitL, TraceStart;//, FwdVel;
	DistanceToFloor = 0.f;

	if( AC_SwordDraggingAlongSurface == None )
	{
		AC_SwordDraggingAlongSurface = new(self) class'AudioComponent';
		AttachComponent( AC_SwordDraggingAlongSurface );
		AC_SwordDraggingAlongSurface.SoundCue = SwordDraggingAlongSurfaceCue;
	}

	if( AC_FeetDraggingAlongSurface == None )
	{
		AC_FeetDraggingAlongSurface = new(self) class'AudioComponent';
		AttachComponent( AC_FeetDraggingAlongSurface );
		AC_FeetDraggingAlongSurface.SoundCue = FeetDraggingAlongSurfaceCue;
	}

	bSlidingDown = FALSE;

	if (CurrNanoState == ENS_Normal && Physics == PHYS_Falling && Velocity.Z <= 0.1)
	{
		//FwdVel = Velocity >> Rotation;
		TraceStart = Location + (vect(0,0,1) * -GetCollisionHeight());
		HitA = Trace(HitL, HitN, TraceStart - vect(0,0,4096),TraceStart);
		// If we hit a non-moving thing, slide down it
		if (HitA != None && (HitA.bStatic || !HitA.bMovable))
		{
			DistanceToFloor = VSize(TraceStart - HitL);

			// See if we should be in slide mode - and record wall normal if so
			if(DistanceToFloor < 120.0 && !bIsAttachedToWall && HitN.Z < MINFLOORZ)
			{
				bSlidingDown = TRUE;
				WallAttachNormal = HitN;
			}

			// Body sliding down surface effects
			ToggleSlidingEffects((bSlidingDown || bIsAttachedToWall) && (FallVelMag > 100.0));

			// Sword-in sliding effects
			ToggleSwordSlidingEffects(bIsAttachedToWall && (FallVelMag > 100.0));
		}
		else
		{
			ToggleSlidingEffects(FALSE);
			ToggleSwordSlidingEffects(FALSE);
		}
	}
	else
	{
		ToggleSlidingEffects(FALSE);
		ToggleSwordSlidingEffects(FALSE);
	}
}

simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	local rotator WallRot;

	// no pitch while mantling
	if (MantleState != MANTLE_None)
	{
		NewRotation.Pitch = 0;
		NewRotation.Roll = 0;
		SetRotation(NewRotation);
		return;
	}
	// When on wall, pawn's rotation is forced to point out from wall
	if(IsAttachedToPerch() || Pacifier_LimbBase(Base) != None)
	{
		return;
	}
	if( bIsDoingMeleeAttack )
	{
		return;
	}

	if( bIsAttachedToWall || bSlidingDown )
	{
		WallRot = rotator(WallAttachNormal);
		WallRot.Pitch = 0;
		SetRotation(WallRot);
	}
	else if( (InteractionPawn != None && Base == InteractionPawn) )
	{
		// using set desired rotation in NanoPC.UpdateRotation for now
		// unless attached to our interaction pawn (which means MoveActor is calling us)
		Super.FaceRotation(NewRotation, DeltaTime);
	}
}

/** Executed on server - used to send new aim offset from owning client */
unreliable server function ServerUpdateReplicatedAimOffset(vector2d NewRepAimOffset)
{
	ReplicatedAimOffset = NewRepAimOffset;
}

simulated function rotator GetReplicatedAim()
{
	local rotator Aim;

	// ReplicatedAimOffset is calculated and updated on the client, and accounts for the camera loc / rot relative to pawn
	Aim.Yaw     = ReplicatedAimOffset.X * 16384 + Rotation.Yaw;
	Aim.Pitch   = ReplicatedAimOffset.Y * 16384;
	Aim.Roll    = 0;

	return Aim;
}

simulated function bool ShouldZeroAimOffset()
{
	return (IsAttachedToPerch() && bStabMantling );
}

/** Update wall slide status - the new wall normal, move us close to wall, and detach if we need to. */
simulated function UpdateWallSlide(float DeltaTime)
{
	local bool bShouldDetach, bHit, bTestHit;
	local vector CheckDir, TempHit, TempNormal, BestNormal, BestDir;
	local float BestDist, TestDist;

	// Trace both the current wall normal, and the same direction with no Z
	CheckDir = -WallAttachNormal;
	bTestHit = IsNearWall(CheckDir,TempNormal,TempHit,GetCollisionRadius() * 5.f);
	if(bTestHit)
	{
		bHit = TRUE;
		BestNormal = TempNormal;
		BestDir = CheckDir;
		BestDist = VSize(Location - TempHit);
	}
	else
	{
		BestDist = 100000.0;
	}

	CheckDir.Z = 0.0;
	CheckDir = Normal(CheckDir);

	bTestHit = IsNearWall(CheckDir,TempNormal,TempHit,GetCollisionRadius() * 5.f);
	if(bTestHit)
	{
		bHit = TRUE;
		TestDist = VSize(Location - TempHit);
		if(TestDist < BestDist)
		{
			BestNormal = TempNormal;
			BestDir = CheckDir;
			BestDist = TestDist;
		}
	}

	// if we found a nearby wall - update wall normal and move close to it
	if(bHit)
	{
		Move(BestDir * GetCollisionRadius() * 5.f);
		Move(-BestDir * 10.0); // And a bit away from it, so we don't get stuck
		WallAttachNormal = BestNormal;
	}
	else
	{
		bShouldDetach = TRUE;
	}

	// If we should come off, do that now
	if(bShouldDetach)
	{
		DetachFromWall();
	}
}

simulated final function NanoPRI GetPRI()
{
	return NanoPRI(PlayerReplicationInfo);
}

simulated function bool CanDash()
{
	if( bSummoningInProgress || bIsDoingMeleeAttack || bForceWalkingSpeed || bIsTargeting )
	{
		return FALSE;
	}

	if( IsAttachedToPerch() || (ElevatorEjectionTarget != None) )
	{
		return FALSE;
	}

	if( ForceSprintTimer <= 0.f &&
		(`TimeSince(LastWeaponFireTime) <= WeaponFireDashDelay || (MyNanoWeapon != None && MyNanoWeapon.IsFiring())) )
	{
		return FALSE;
	}

	if( TeslaShock_NoRun_ActiveUntil > WorldInfo.TimeSeconds )
	{
		return FALSE;
	}

	return TRUE;
}

/** Looks at the forward stick, and activates/deactivates Dash skill */
simulated function UpdateWalkingState(NanoPC NPC, float DeltaTime)
{
	local bool bWantsToWalk;
	bWantsToWalk = !bIsDashing && Abs(NPC.RemappedJoyUp) < 0.5f && Abs(NPC.RemappedJoyRight) < 0.5f;
	SetWalking( bWantsToWalk );
}

simulated function ForceDashStart( optional float ForceTime )
{
	ForceSprintTimer = ForceTime;
	HolsterCurrentWeapon();
	if( !bIsDashing )
	{
		ActivateSkill( class'NanoSkill_Dash' );
	}
}

/** Forcibly stops the pawn from dashing, and also stops any slide afterwards */
simulated function ForceDashStop()
{
	if( bIsDashing )
	{
		DeactivateSkill(class'NanoSkill_Dash');
	}
}

simulated function EComboJoyDirection GetJoyDirection( Rotator BaseRot, Vector Dir, optional out Vector out_AxisDir, optional bool bTreatIdleAsDown )
{
	local Vector X, Y, Z;
	local float VelDotX, VelDotY;
	local EComboJoyDirection Result;

	GetAxes( BaseRot, X, Y, Z );
	VelDotX = Normal(Dir) DOT X;
	VelDotY = Normal(Dir) DOT Y;

	if( VelDotX > 0.5f )
	{
		out_AxisDir = X;
		Result = CJD_Up;
	}
	else if( VelDotX < -0.5f )
	{
		out_AxisDir = -X;
		Result = CJD_Down;
	}
	else if( VelDotY > 0.5f )
	{
		out_AxisDir = Y;
		Result = CJD_Right;
	}
	else if( VelDotY < -0.5f )
	{
		out_AxisDir = -Y;
		Result = CJD_Left;
	}
	else
	{
		Result = bTreatIdleAsDown ? CJD_Down : CJD_None;
	}

	return Result;
}


simulated function UpdateJumpAnimSet(optional Name OverrideSet)
{
	local Name NewSetName;

	//`log(`location@`showvar(OverrideSet));
	//scripttrace();

	ClearTimer(nameof(UpdateJumpAnimSet));
	if( BlendFallNode == None )
		return;

	bJumpSetIsDirty = FALSE;
	if (OverrideSet != '')
	{
		NewSetName = OverrideSet;
	}
	else
	{
		NewSetName = 'Default';
		if( bUseHammerAnim )
		{
			NewSetName = 'DropTheHammer';
		}
		else if( bIsSwordActive )
		{
			NewSetName = 'Sword_Jump';
		}
		else if( !bEmptyHanded )
		{
			if( bAimAnim )
			{
				NewSetName = 'SMG_Jump_Aim';
			}
			else
			{
				NewSetName = 'SMG_Jump';
			}
		}
		else if (Velocity dot vector(Rotation) > 0.f)
		{
			if (VSize2D(Velocity) > 1000)
			{
				NewSetName = 'Sprint_Jump';
			}
			else if (VSize2D(Velocity) > 450)
			{
				NewSetName = 'Running_Jump';
			}
			else if (VSize2D(Velocity) > 50)
			{
				NewSetName = 'Small_Jump';
			}
		}
	}

	//ScriptTrace();
	//`log(`location@`showvar(NewSetName));
	BlendFallNode.CopyAnimsFromSetByName( NewSetName );
}

simulated function UpdateJumpBoost( PlayerController PC, float DeltaTime )
{
	local NanoPC NPC;
	local NanoSkill_Jump JumpSkill;

	NPC = NanoPC(PC);
	if(NPC == None)
	{
		return;
	}

	if( Physics != PHYS_Falling || bIsAttachedToWall )
	{
		JumpHoldGravityZScale = 1.f;
		return;
	}

	JumpSkill = GetSkill(class'NanoSkill_Jump');
	if( JumpSkill != None )
	{
		JumpSkill.ApplyJumpBoost( self, DeltaTime );
	}
}

simulated function UpdateMesh( float DeltaTime )
{
	local float SlopeAngle, ConformTarget;

	// If the active special move doesn't prevent it, blend the MeshTranslationOffset back to the default translation
	if( ActiveSpecialMove == None || !ActiveSpecialMove.bLockMeshTranslationOffset )
	{
		if (!IsZero(MeshTranslationOffset))
		{
			MeshTranslationOffset = VInterpTo(MeshTranslationOffset,vect(0,0,0),DeltaTime,8.f);
			Mesh.SetTranslation(Mesh.default.Translation + MeshTranslationOffset);
		}
		else
		{
			Mesh.SetTranslation(default.Mesh.Translation);
		}
	}

	if( IsHumanControlled() )
	{
		if(bIsAttachedToWall || bSlidingDown)
		{
			// Find angle from horizontal
			MeshPitch = ACos(WallAttachNormal.Z) * 10430.2192;

			// And update controller
			if( MeshPitchController != none )
			{
				MeshPitchController.BoneRotation.Pitch = -MeshPitch;
				MeshPitchController.SetSkelControlActive(TRUE);
			}

			// Offset mesh down onto slope
			SlopeAngle = FMax(ACos(WallAttachNormal.Z), 0.0); // Ensure positive angle
			ConformTarget = (CylinderComponent.CollisionRadius * Tan(SlopeAngle));
			ConformTarget = Clamp(ConformTarget, 0.f, 50.0); // Limit how much we can translate the mesh

			Mesh.SetTranslation((ConformTarget * vect(0,0,-1)) + default.Mesh.Translation);
		}
		else
		{
			MeshPitch = 16394; // when not on wall - assume 90 degrees (vertical mesh)
			if( MeshPitchController != none )
			{
				MeshPitchController.SetSkelControlActive(FALSE);
			}
		}

		// Get wrist control updated when sliding down
		if( RightWristControl != none )
		{
			RightWristControl.SetSkelControlActive(bIsAttachedToWall);
			RightWristControl.BoneRotation.Yaw = CurrentWallStabStrafeRatio * 12000;
		}
	}
}

simulated function UpdateClothBlend(float DeltaTime)
{
	if(DesiredClothBlend > HeadMesh.ClothBlendWeight)
	{
		HeadMesh.ClothBlendWeight = FInterpTo(HeadMesh.ClothBlendWeight, DesiredClothBlend, DeltaTime, ClothBlendUpRate);
	}
	else if(DesiredClothBlend < HeadMesh.ClothBlendWeight)
	{
		HeadMesh.ClothBlendWeight = FInterpTo(HeadMesh.ClothBlendWeight, DesiredClothBlend, DeltaTime, ClothBlendDownRate);
	}
}

simulated native function GetAimOffsetValue( const out Rotator CamRot, const out Rotator PawnRot, out float out_AimX, out float out_AimY );
simulated native function Rotator GetAimRotation();

simulated function UpdateAimOffsetNodes( float DeltaTime )
{
	local int Idx;
	local float AimX, AimY;
	local Rotator AimRotation;


	// If there is no controller, then this is a remote client's pawn, and we should use the replicated aim offset
	if( Controller == None )
	{
		for( Idx = 0; Idx < AimNodes.Length; Idx++ )
		{
			if( AimNodes[Idx] == None )
			{
				AimNodes.Remove( Idx--, 1 );
				continue;
			}
			AimNodes[Idx].Aim = ReplicatedAimOffset;
			AimNodes[Idx].DesiredAim = AimNodes[Idx].Aim;
		}
	}
	else
	{
		AimRotation = GetAimRotation();
		GetAimOffsetValue( AimRotation, DesiredRotation, AimX, AimY );

		for( Idx = 0; Idx < AimNodes.Length; Idx++ )
		{
			if( AimNodes[Idx] == None )
			{
				AimNodes.Remove( Idx--, 1 );
				continue;
			}

			AimNodes[Idx].DesiredAim.X = AimX;
			AimNodes[Idx].DesiredAim.Y = AimY;
		}
	}
}


function ResetToAnchor()
{
	local PlayerController PC;
	PC = PlayerController(Controller);
	if (PC != None)
	{
		PC.ClientSetCameraFade(TRUE,MakeColor(255,255,255,255),vect2d(1,0),0.5f);
	}

	// recharge nano power on reset
	SetNanoPower( MaxNanoPower );

	SetLocation(AnchorPoint);
	Controller.SetRotation(AnchorPointRotation);
	LastSafeLocation = Location;
	SetPhysics(PHYS_Falling);
}

final function DisallowMantles();

simulated function FireMantleKismetEvents(Actor MantledOverActor, vector MantleNormal)
{
	local array<int> ActivateIndices;
	local array<SequenceEvent> ActivatedEvents;
	local SequenceEvent it;
	local SeqEvt_ObstacleMantled Evt;

	if( MantledOverActor != None )
	{
		ActivateIndices[0] = 0;

		// Activate the ObstacleMounted event
		MantledOverActor.ActivateEventClass(class'SeqEvt_ObstacleMantled', self, MantledOverActor.GeneratedEvents, ActivateIndices, FALSE, ActivatedEvents);
		foreach ActivatedEvents(it)
		{
			Evt = SeqEvt_ObstacleMantled(it);
			if( Evt != None )
			{
				Evt.WallNormal = MantleNormal;
			}
		}
	}
}

simulated final function bool ShouldCheckForMantles(NanoPC PC, optional bool bFollowUpCheck)
{
	if (!IsLocallyControlled())
	{
		// clients tell server when to mantle currently
		return FALSE;
	}

	if( PC != None && PC.bCheatFlying )
	{
		return FALSE;
	}

	if ( bForceWalkingSpeed || bDodging || bIsControlledJump )
	{
		return FALSE;
	}

	if ( !bFollowUpCheck && NSM_Mantle_Base(ActiveSpecialMove) != None )
	{
		return FALSE;
	}

	if( bIsSwordDashing || bIsDoingDashAttack || bIsDoingStabMantle || bIsDoingCarHop || bIsDoingMeleeAttack || PerchingMode != ENPM_None || bPlayingHitReaction )
	{
		return FALSE;
	}

	if( bSlidingDown )
	{
		return FALSE;
	}

	if( InteractionPawn != None )
	{
		return FALSE;
	}

	if ( IsTimerActive(nameof(DisallowMantles)) )
	{
		return FALSE;
	}

	return TRUE;
}

simulated final function bool HandleMantleChecks(NanoPC PC)
{
	local Name Mantle;
	local bool bFollowUp;
	local NSM_Mantle_Base CurMantle, ChkMantle;
	local int Idx, Flags;

	CurMantle = NSM_Mantle_Base(ActiveSpecialMove);
	bFollowUp = CurMantle != None && CurMantle.CheckForMantleContinuous.Length > 0;
	if( ShouldCheckForMantles( PC, bFollowUp ) )
	{
		foreach Mantles(Mantle,Idx)
		{
			if( CurMantle != None && CurMantle.CheckForMantleContinuous.Find(Mantle) < 0 )
			{
				continue;
			}

			ChkMantle = NSM_Mantle_Base(GetSpecialMoveByName(Mantle));
			if( ChkMantle == None )
			{
				continue;
			}

			if( ChkMantle.CanDoSpecialMove( TRUE ) )
			{
				ChkMantle.InitSpecialMoveFlags( Flags );
				DoSpecialMove( Mantle,,,, Flags );
				return TRUE;
			}
		}
	}

	return FALSE;
}


// Use this as a chance to play an antic when player stopped moving over a ledge
simulated event bool HandlePartialLedgeOverhang( Vector MoveDir )
{
	return FALSE;
}

simulated event RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
	if( ActiveSpecialMove != None )
	{
		ActiveSpecialMove.RootMotionExtracted( SkelComp, ExtractedRootMotionDelta );
	}
	else if( NanoWeap_Melee(Weapon) != None )
	{
		NanoWeap_Melee(Weapon).ModifyPawnRootMotion(SkelComp,ExtractedRootMotionDelta);
	}
}

simulated function AnimNotify_CheckHandspringTransition()
{
	local NSM_Mantle_Base MantleSM;
	MantleSM = NSM_Mantle_Base(ActiveSpecialMove);
	if( MantleSM != None )
	{
		MantleSM.CheckHandSpringTransition();
	}
}

/** Called after an elevator launch to restore collision, which was turned off to ensure an unobstructed flight path */
simulated function RestoreCollisionAfterLaunch()
{
	SetCollision(TRUE, TRUE, FALSE);
}

simulated function ResetRunSyncGroup()
{
	//`log(`location);
	AnimTree(Mesh.Animations).SetGroupRateScale('Run',1.f);
	AnimTree(Mesh.Animations).ForceGroupRelativePosition('Run',0.f);
}

/**
 * Event called from C++ when transition is either finished or aborted.
 */
simulated event Move2IdleTransitionFinished()
{
/*  if( IsDoingMove2IdleTransition() )
	{
		EndSpecialMove();
	}*/
}

/** Responding to AI_CustomAimOffset
 *  Allows to get custom aimoffset with AI_CustomAimOffset set up
 *  @param AimOffset: 2D vector of AimOffset
 *  @return : TRUE if successfully found. FALSE otherwise
 */
event bool GetCustomAimOffset( out vector2D  AimOffset )
{
	return FALSE;
}

/** Returns TRUE is Pawn is reloading his weapon */
simulated native final function bool IsReloadingWeapon() const;

simulated function SetSplineBase(SplineActor NewSplineActor, float NewSplineVelocity)
{
	`log(`location@`showvar(NewSplineActor));
	bIsSkyDiving = FALSE;
	SplineBase = NewSplineActor;
	SplineBaseVelocity = NewSplineVelocity;
	DistAlongSpline = 0.f;
	TimeAlongSpline = 0.f;
	bReachedFirstSplineActor = FALSE;
	SetPhysics(PHYS_None);
}

simulated function InterpMaskMIC( float NewGoal, float TimeToInterp )
{
	MaskMICValueBase = MaskMICValueCurr;
	MaskMICValueGoal = NewGoal;
	TimeToInterpMaskMIC = TimeToInterp;
	CurrentMaskMICInterpTime = 0.f;
}

simulated function ResetDefaultCamAdhereToCameraBone()
{
	GetCamera().Default3pCam.AdhereToCameraBone(FALSE);
}

simulated event Tick(float DeltaTime)
{
	local Nano_KActor BaseKActor;
	local float DownForce;
	local float Amt;
	local float VelSize;
	local NanoPC PC;
	local rotator PCRot;
	local bool bLocallyControlled;
	local NanoSkill_Ping PingSkill;
	local vector BoneLoc;
	local Rotator AimRotation;
	local SplineComponent SplineComp;
	local vector PrevLoc;
	local vector TargetLoc;
	local Vector Dir;
	local Actor PrelandAttractionActor;
	local NanoSkill_Ghost GhostSkill;
	local NanoSkill_Dense DenseSkill;
	local float HealthRegainAmt;
	local float HealthRegainAmtFloored;


	PC = NanoPC(Controller);

	// Forward tick event to special move
	if( ActiveSpecialMoveName != '' )
	{
		if( ActiveSpecialMove != None )
		{
			ActiveSpecialMove.Tick( DeltaTime );
		}
	}

	UpdateMaskedMICs( DeltaTime );

	if (SplineBase != None)
	{
		SplineComp = SplineBase.Connections[0].SplineComponent;
		if (SplineComp != None)
		{
			PrevLoc = Location;
			if (SplineBase.SplineVelocityOverTime.Points.Length > 0)
			{
				SplineBaseVelocity = EvalInterpCurveFloat(SplineBase.SplineVelocityOverTime,TimeAlongSpline);
			}
			if (!bReachedFirstSplineActor)
			{
				TargetLoc = SplineComp.GetLocationAtDistanceAlongSpline(0.f);
				if (VSize(Location - TargetLoc) < (SplineBaseVelocity * DeltaTime))
				{
					//`log(WorldInfo.TimeSeconds@"- reached first spline actor");
					bReachedFirstSplineActor = TRUE;
				}
				else
				{
					SetLocation(Location + Normal(TargetLoc - Location) * SplineBaseVelocity * DeltaTime);
					//`log(WorldInfo.TimeSeconds@"moving to spline start"@VSize(TargetLoc-Location)@Normal(TargetLoc - Location));
					bReachedFirstSplineActor = VSize(Location - TargetLoc) < (SplineBaseVelocity * DeltaTime);
				}
			}
			if (bReachedFirstSplineActor)
			{
				//`log(WorldInfo.TimeSeconds@"moving along spline"@`showvar(DistAlongSpline)@SplineComp.GetLocationAtDistanceAlongSpline(DistAlongSpline));
				SetLocation(SplineComp.GetLocationAtDistanceAlongSpline(DistAlongSpline));
				TimeAlongSpline += DeltaTime;
				DistAlongSpline += DeltaTime * SplineBaseVelocity;
				if (DistAlongSpline > SplineComp.GetSplineLength())
				{
					if (SplineBase.SplineVelocityOverTime.Points.Length > 0 && SplineBase.Connections[0].ConnectTo.SplineVelocityOverTime.Points.Length == 0)
					{
						// copy over the velocity points from the originating spline actor unless overridden
						SplineBase.Connections[0].ConnectTo.SplineVelocityOverTime.Points = SplineBase.SplineVelocityOverTime.Points;
					}
					SplineBase = SplineBase.Connections[0].ConnectTo;
					DistAlongSpline = 0.f;
					if (SplineBase.Connections.Length == 0)
					{
						//`log("- reached end of spline");
						FullBodySlot.StopCustomAnim(0.35f);
						SplineBase = None;
						if (Physics == PHYS_None)
						{
							SetPhysics(PHYS_Falling);
						}
						bSlideOnLanding = TRUE;
					}
				}
			}
			Velocity = (Location - PrevLoc)/DeltaTime;
			PCRot = rotator(Velocity);
			if (TimeAlongSpline > 0.35f)
			{
				PCRot.Pitch = Rotation.Pitch;
				PCRot.Pitch = FInterpTo(PCRot.Pitch,0,DeltaTime,1.f);
			}
			//`log("spline velocity"@Velocity@`showvar(PCRot));
			SetRotation(RInterpTo(Rotation,PCRot,DeltaTime,16.f));
		}
	}

	if (RootAttachmentComponent != None && RootAttachmentBoneName != '')
	{
		BoneLoc = RootAttachmentComponent.GetBoneLocation(RootAttachmentBoneName);
		if (RootAttachmentInterpDuration > 0.f)
		{
			RootAttachmentInterpTime += DeltaTime;
			SetLocation(VLerp(Location,Location + (BoneLoc-Mesh.GetBoneLocation('b_MF_Root')),FMin(1.f,RootAttachmentInterpTime/RootAttachmentInterpDuration)));
			if (RootAttachmentInterpTime >= 1.f)
			{
				RootAttachmentInterpDuration = 0.f;
				RootAttachmentInterpTime = 0.f;
				//`log("root interp finished");
			}
		}
		else
		{
			SetLocation(VInterpTo(Location,Location + (BoneLoc-Mesh.GetBoneLocation('b_MF_Root')),DeltaTime,RootAttachmentInterpRate));
		}
	}

	if (Physics == PHYS_Walking)
	{
		if( Mesh.Animations != None )
		{
			VelSize = VSize2D(Velocity);
			if (VelSize >= 400 && VelSize < 1000.f)
			{
				AnimTree(Mesh.Animations).SetGroupRateScale('Run',FMax(0.85,VelSize/default.GroundSpeed - 1.f));
			}
			else
			{
				AnimTree(Mesh.Animations).SetGroupRateScale('Run',1.f);
			}
		}
	}

	if (PC != None)
	{
		Amt = GetFallingZImpactBasedOnJumpSkill();
		if( Amt > 0.1f )
		{
			if( !bFakeDenseEffects )
			{
				EnableFakeDenseEffects();
			}
		}
	}

/*
//remove falling failsafe so we can iron out actual design jump mechanics
		if (Amt > 0.1f)
		{
			if (!PC.bGodMode && !FastTrace(Location + vect(0,0,-512.f),Location,GetCollisionExtent(),FALSE))
			{
				PC.PlayerCamera.bEnableFading = TRUE;
				PC.PlayerCamera.FadeColor = MakeColor(40,10,10);
				//PC.PlayerCamera.FadeAmount = 0.3f;
				PC.PlayerCamera.FadeAmount = FInterpTo(PC.PlayerCamera.FadeAmount,0.4,DeltaTime,2.f);
			}

			if( IsTimerActive( nameof(ResetToAnchorIsValid) ) == FALSE )
			{
				RedScreenDeathWarningTime = WorldInfo.TimeSeconds;
				//`log( "setting setting setting" @ RedScreenDeathWarningTime );
			}

			SetTimer( 15.0f, FALSE, nameof(ResetToAnchorIsValid) ); // since we are going to die give the player a chance to return to their anchor if they want for 5 seconds.  otherwise they can enjoy the fallll

			bRedScreenWarningActive = TRUE;
		}
		else if( bRedScreenWarningActive )     // Only fade out the camera here if it was faded in above (i.e. RedScreenDeathWarningTime was set).  Prevents interference with kismet-triggered fades
		{
			PC.PlayerCamera.FadeAmount = FInterpTo(PC.PlayerCamera.FadeAmount,0,DeltaTime,1.f);
			RedScreenDeathWarningTime = 0.0f;
			ClearTimer( nameof(ResetToAnchorIsValid) );

			if( PC.PlayerCamera.FadeAmount == 0.f )
			{
				bRedScreenWarningActive = FALSE;
			}
		}
	}
*/

	if( bFakeDenseEffects && Physics != PHYS_Falling && ActiveSpecialMove == None )
	{
		DisableFakeDenseEffects();
	}

	GhostSkill = GetSkill(class'NanoSkill_Ghost');
	if( GhostSkill != None && ( bFakeGhostEffects || GhostSkill.bActive == TRUE ) )
	{
		GhostSkill.UpdatePowerEffects( DeltaTime, self );
	}
	DenseSkill = GetSkill(class'NanoSkill_Dense');
	if( DenseSkill != None && ( bFakeDenseEffects || DenseSkill.bActive == TRUE ) )
	{
		DenseSkill.UpdatePowerEffects( DeltaTime, self );
	}

	bLocallyControlled = IsLocallyControlled();

	if( PC != None )
	{
		if( bLocallyControlled )
		{
			FindFloor();

			UpdateWalkingState( PC, DeltaTime );

			// handle mantling
			HandleMantleChecks(PC);

			if( bIsAttachedToWall && (Physics != PHYS_None) )
			{
				UpdateWallSlide(DeltaTime);
			}
		}

		UpdateJumpBoost( PC, DeltaTime );
	}

	if( Physics == PHYS_Falling )
	{
 		if( TargetedAttractionActor != None )
 		{
 			if( !NanoInterface_Attraction(TargetedAttractionActor).ShouldAttractActor(self) )
 			{
 				TargetedAttractionActor = None;
 				UpdateJumpAnimSet();
 			}
 		}

 		if( TargetedAttractionActor == None )
 		{
 			TargetedAttractionActor = FindAttractTarget();
 			if (TargetedAttractionActor == None)
 			{
 				PreLandAttractionActor = FindAttractTarget( PrepLandRateAttractTarget );
 			}
 			if( TargetedAttractionActor != None || PreLandAttractionActor != None )
 			{
 				if (NanoPerchPoint(TargetedAttractionActor) != None || NanoPerchPoint(PreLandAttractionActor) != None)
 				{
 					if( BlendFallNode != none )
 					{
 						BlendFallNode.CopyAnimsFromSetByName( 'Perch_Land' );
 						BlendFallNode.ChangeFallState(FBT_PreLand);
 					}
 				}
 			}
 		}

		if( !bIsSkydiving && Velocity.Z < GetTerminalVelocity() * -0.9f )
		{
			CheckForSkydive();
		}
		if( bIsSkydiving && (RB_Skydive != None) )
		{
			// If we're skydiving, blend the blur up to the max amount over the camera's blend time
			if( RB_Skydive.BlurScale < SkydivingMaxBlur )
			{
				RB_Skydive.SetBlurScale( FInterpConstantTo(RB_Skydive.BlurScale, SkydivingMaxBlur, DeltaTime, SkydivingMaxBlur / class'Cam3p_Skydive'.default.FOVBlendTime) );
			}
		}
	}

	if (bIsRechargingHealth && Health > 0)
	{
		if ( `TimeSince(LastTookDamageTime) >= HealthRechargeDelay 
			//&& `TimeSince(LastNanoPowerUseTime) >= HealthRechargeDelay 
			&& ConsumeNanoPower(HealthRechargeCostPerSecond * DeltaTime,FALSE)
			)
		{
			// this will accum the potentially small values
			HealthRegainAmt = HealthRechargePerSecond * DeltaTime;
			HealthRegainAccum += HealthRegainAmt;
			// then figure out how much we should add this frame
			HealthRegainAmtFloored = FFloor( HealthRegainAccum );
			// remove what we added from our accum
			HealthRegainAccum -= HealthRegainAmtFloored;

			Health += HealthRegainAmtFloored;
			if (Health >= DefaultHealth)
			{
				Health = DefaultHealth;
				bIsRechargingHealth = FALSE;
			}
	    }
		else
		{
			bIsRechargingHealth = FALSE;
			SetTimer(HealthRechargeDelay,FALSE,nameof(EnableHealthRecharge));
		}
	}

	if (bCheckForFalling && Velocity.Z <= 0)
	{
		bCheckForFalling = FALSE;
		Falling();
	}

	Super.Tick(DeltaTime);

	UpdateMesh( DeltaTime );

	UpdateClothBlend( DeltaTime );

	// Force controller rotation to pawn rotation - that is, zero aiming
	if((PC != None) && ShouldZeroAimOffset() )
	{
		PCRot = RInterpTo(PC.Rotation, Rotation, DeltaTime, 4.0);
		PC.SetRotation(PCRot);
	}

	// On owning client, update the aim offset
	// This is then sent to server via a replicated function
	// Non-owning clients just get the var replicated to them
	if( PC != None && bLocallyControlled )
	{
		AimRotation = GetAimRotation();

		GetAimOffsetValue( AimRotation, Rotation, ReplicatedAimOffset.X, ReplicatedAimOffset.Y );
		ServerUpdateReplicatedAimOffset(ReplicatedAimOffset);
	}

    // Update all aiming nodes
    UpdateAimOffsetNodes( DeltaTime );

	// If we hit zero, stop all powers
	if(GetNanoPower() <= 0.0)
	{
		StopAllPowers();
		SetNanoPower( 0.0f );
	}

	// Handle nano power recovery
	if( `TimeSince(LastNanoPowerUseTime) > NanoRecoveryDelay && (Physics == PHYS_Walking || IsAttachedToPerch() || NanoPerchPoint(Base) != None) )
	{
		if( NanoRecoveryRate > 0.f && NanoPower < MaxNanoPower )
		{
			AddNanoPower( DeltaTime * NanoRecoveryRate );
		}
		else if( NanoRecoveryRate < 0.f && NanoPower > 0.f )
		{
			ConsumeNanoPower( DeltaTime * -NanoRecoveryRate, FALSE,, TRUE );
		}
	}

	// Handle combo point decay
	if(`TimeSince(ComboLastGainTime) > TimeBeforeComboPointDecay)
	{
		ComboPoints -= (DeltaTime * ComboPointDecayRate);
		ComboPoints = Max(ComboPoints, 0.0);
	}

	// Add force to KActor we are standing on
	BaseKActor = Nano_KActor(Base);
	if(BaseKActor != None)
	{
		if(CurrNanoState == ENS_Dust)
		{
			DownForce = DustBaseForce;
		}
		else if(CurrNanoState == ENS_Dense)
		{
			DownForce = DenseBaseForce;
		}
		else
		{
			DownForce = NormalBaseForce;
		}

		BaseKActor.StaticMeshComponent.AddForce(vect(0,0,-1) * DownForce * BaseKActor.PawnStandForceScale, Location);
		BaseKActor.StaticMeshComponent.WakeRigidBody();
	}

	// ANIM UPDATE
	UpdateCurrentAimMode();

	// If we are dashing holding a dude
	if( InteractionPawn != None && InteractionType == PAWNINTER_Tackle && !bSlammingTackledActor && Physics == PHYS_Walking )
	{
		// See if we are about to hit a wall, so we can start slam anim
		DoPreWallTackleSlamAnimCheck();
	}

	// Update bool to indicate empty-handed
	bEmptyHanded = (Weapon == None || NanoWeap_Hands(Weapon) != None);

	if( bEmptyHanded && bAimAnim )
	{
		TurnOffAiming();
	}

	// Show flying pose if desired
	bFlyingBackPose = (bImpaledOnSword || bKnockDownOnLanding) && (Physics == PHYS_Falling || Physics == PHYS_None);

	// Use 'holding tackled actor' pose
	bHoldingTackledActor = (InteractionPawn != None && InteractionType == PAWNINTER_Tackle);

    // check to see if we have touched a tornado recventl
	if( AffectedByTornado != none )
	{
		AffectedByTornado.KillDueTornado( self );
		AffectedByTornado = none;
	}

	if( ( PC != None ) && ( bLocallyControlled ) )
	{
		PC.bFire = 0;
		if( WantsToShoot() )
		{
			if( NanoWeap_MP7(MyNanoWeapon) == None )
			{
				StartForge(GetPRI().GunPlan);
			}
			else
			{
				PC.bFire = 1;
			}
		}

		if( !bSummoningInProgress )
		{
			HandleWeaponFiring();
		}
	}

	// this could probably have PHYS_Walking check on it.  But it is actually pretty cool to be in mid air, ping, slooow down, then speed up
	PingSkill = GetActiveSkill( class'NanoSkill_Ping' );

	if( ( PingSkill != none ) && ( PingSkill.TimeOutwardPingFired != 0.0f ) )
	{
		Velocity *= class'NanoSkill_Ping'.default.VelocityPercentWhenPingIsActive;
	}

	// Check if we should smash through windows n stuff
	if( ShouldBreakThroughBustableActors( Dir ) )
	{
		CheckForDenseBash( DeltaTime, Dir );
	}


	// standing still data
	if( VSize(Velocity) == 0.0f )
	{
		// if I am not standing still already (this is the firt time I am standing still so record it)
		if( bStandingStill == FALSE )
		{
			LastStandingStillTime = WorldInfo.TimeSeconds;
		}
		bStandingStill = TRUE;
	}
	else
	{
		bStandingStill = FALSE;
	}


	//debug
	LastVel2D = VSize2D(Velocity);
}

simulated function bool WantsToShoot()
{
	if( bSummoningInProgress )
	{
		return FALSE;
	}

	if( ( InteractionPawn != None ) && ( InteractionPawn_AllowShootingOverride == FALSE ) )
	{
		return FALSE;
	}

	return bWantsToShoot;
}


simulated function HandleWeaponFiring()
{
	local NanoPC PC;

	PC = NanoPC(Controller);

	if( PC != None && !PC.bCinematicMode && Weapon != None && !bIsSwordActive )
	{
		if( PC.bFire == 1 && !Weapon.IsFiring() )
		{
			StartFire(0);
		}
		else if( PC.bFire == 0 && Weapon.IsFiring() )
		{
			StopFire(0);
		}
	}
}

simulated function bool ShouldBreakThroughBustableActors( out Vector out_Dir )
{
	out_Dir = Normal(Velocity);
	if( bFlyingBackPose || bIsDashing )
	{
		return TRUE;
	}

	if( Physics == PHYS_Falling && VSize2D(Velocity) > 100.f )
	{
		return TRUE;
	}

	if( Physics == PHYS_RigidBody )
	{
		return TRUE;
	}

	if( Physics == PHYS_None && InteractionPawn != None && InteractionType == PAWNINTER_Tackle )
	{
		out_Dir = -Vector(Rotation);
		return TRUE;
	}

	return FALSE;
}

simulated function NanoThirdPersonCamera GetCamera()
{
	local NanoPC PC;
	PC = GetPC();
	if (PC != None)
	{
		return NanoThirdPersonCamera(GamePlayerCamera(PC.PlayerCamera).CurrentCamera);
	}
	return None;
}

simulated function bool UpdateMaskedMICs( float DeltaTime )
{
	if( MaskMICValueCurr != MaskMICValueGoal )
	{
		if (TimeToInterpMaskMIC > 0.f)
		{
			MaskMICValueCurr = Lerp(MaskMICValueBase,MaskMICValueGoal,FMin(1.f,CurrentMaskMICInterpTime/TimeToInterpMaskMIC));
			CurrentMaskMICInterpTime += DeltaTime;
		}
		else
		{
			MaskMICValueCurr = FInterpTo( MaskMICValueCurr, MaskMICValueGoal, DeltaTime, 3 );
		}
		BodyMIC.SetScalarParameterValue( 'Mask', MaskMICValueCurr );
		ArmMIC.SetScalarParameterValue( 'Mask', MaskMICValueCurr );
		HeadMIC.SetScalarParameterValue( 'Mask', MaskMICValueCurr );

		return TRUE;
	}

	return FALSE;
}



simulated function UpdateCurrentAimMode()
{
	// When dropping hammer, don't try and do gun aiming
	if( bUseHammerAnim )
	{
		CurrentAimMode = ENAM_CameraOnly;
	}
	// When sword is out..
	else if( bIsSwordActive || bEmptyHanded )
	{
		CurrentAimMode = ENAM_Sword;
	}
	// default to gun aiming
	else
	{
		CurrentAimMode = ENAM_Gun;
	}
}


simulated function SpawnMyPreferredWeapon()
{
	SpawnANanoWeapon( PreferredRangedWeaponClass );
}


simulated function SpawnNanoMP7()
{
	SpawnANanoWeapon( class'NanoWeap_MP7' );
}

simulated function float SpawnNanoBaton();


simulated function SpawnNanoSword()
{
	SpawnANanoWeapon( class'NanoWeap_Sword' );
}


protected reliable server function SpawnANanoWeapon( class<NanoWeaponBase> ClassToSpawn )
{
	if (Weapon != None)
	{
		// don't do anything if we already have that weapon active
		if (Weapon.Class == ClassToSpawn)
		{
			return;
		}
		if( IsHumanControlled() == FALSE )
		{
			DiscardCurrentWeapon();
		}
	}

	MyNanoWeapon = NanoWeapon(InvManager.CreateInventory(ClassToSpawn));

	`loginfo( 'Nano_Weapons', " -> SpawnANanoWeapon SpawnANanoWeapon SpawnANanoWeapon " @ MyNanoWeapon @ClassToSpawn );

	MakeNoise(0.25);

	InvManager.SetCurrentWeapon( MyNanoWeapon );
	SetSwordActive( MyNanoWeapon != None && ClassIsChildOf( MyNanoWeapon.Class, class'NanoWeap_Melee' ) );
}

/** This is the accessor function that people should use to tell the pawn to deactivate the current nano power. **/
simulated function DeactivateCurrNanoPower()
{
	SetNanoState( ENS_Normal, Controller );
}

reliable server function ServerSetNanoState(ENanoState NewState)
{
	SetNanoState(NewState, Controller);
}

simulated function bool CanBeChanged( ENanoState NewState )
{
	if( NewState == ENS_Dust )
	{
		return CanBeDusted();
	}
	if( NewState == ENS_Dense )
	{
		return CanBeDensed();
	}
	return TRUE;
}

simulated function bool CanBeDusted()
{
	return (Health > 0); // don't allow changing state once dead
}

simulated function bool CanBeDensed()
{
	return (Health > 0);
}

simulated function bool IsDensed()
{
	return (CurrNanoState == ENS_Dense);
}

simulated function bool IsDusted()
{
	return (CurrNanoState == ENS_Dust);
}

simulated function OnModifyNanoAffectedActor( SeqAct_ModifyNanoAffectedActor InAction )
{
	if( InAction.NanoStateToBe == ENS_Dust )
	{
		ActivateSelfNanoPower(class'NanoSkill_Ghost');
	}
	else if( InAction.NanoStateToBe == ENS_Dense )
	{
		ActivateSelfNanoPower(class'NanoSkill_Dense');
	}
	else
	{
		DeactivateSelfNanoPower(class'NanoSkill_Ghost');
		DeactivateSelfNanoPower(class'NanoSkill_Dense');
	}

}

final simulated function RestoreDefaultNanoState()
{
	SetNanoState(ENS_Normal,self);
}

/** This will do the correct work for changing our nano power / state.  Implementation that is hidden from callers **/
simulated function bool SetNanoState(ENanoState NewState, Actor InInstigator, optional float NanoPowerAmount)
{
	local NanoAI AI;
	local bool bChangingSelf;

	AI = NanoAI(Controller);
	bChangingSelf = ((InInstigator == self) || (InInstigator == Controller));

	if( NewState != CurrNanoState )
	{
		if (Role < ROLE_Authority)
		{
			ServerSetNanoState(NewState);
		}

		if(NewState != ENS_Normal)
		{
			if(NewState == ENS_Dust)
			{
				if (!bChangingSelf)
				{
					if (AI != None)
					{
						AI.StunAI(0.f,'Dusted');
					}
					// You drop your shield when dusted
					DropShield();
				}

				// Change material on char
				class'NanoTypes'.static.SetMaterialInstanceToDusted( HeadMIC );
				class'NanoTypes'.static.SetMaterialInstanceToDusted( BodyMIC );
				class'NanoTypes'.static.SetMaterialInstanceToDusted( ArmMIC );

			}
			else if(NewState == ENS_Dense)
			{
				if (StatePPEffect != None)
				{
					StatePPEffect.Material = MaterialInterface'Nano_PostProcess.PPM_Dense';
				}

				if (!bChangingSelf)
				{
					if (AI != None)
					{
						AI.StunAI(0.f,'Densed');
					}
					DropShield();
				}

				// Change material on char
				class'NanoTypes'.static.SetMaterialInstanceToDensed( HeadMIC );
				class'NanoTypes'.static.SetMaterialInstanceToDensed( BodyMIC );
				class'NanoTypes'.static.SetMaterialInstanceToDensed( ArmMIC );
			}

			if (NewState != ENS_Normal && AI != None)
			{
				AI.AddStimulus(InInstigator,InInstigator.Location,TRUE,FALSE);
			}
		}
		else
		{
			if( StatePPEffect != None )
			{
				StatePPEffect.Material = None;
			}

			// If the current state we are in was enforced, we unstun ourself when changing away from that state
			if (bEnforcedNanoStateChanged && AI != None)
			{
				AI.UnstunAI('Dusted');
				AI.UnstunAI('Densed');
			}
			// Reset material on char
			class'NanoTypes'.static.SetMaterialInstanceToDefault( HeadMIC );
			class'NanoTypes'.static.SetMaterialInstanceToDefault( BodyMIC );
			class'NanoTypes'.static.SetMaterialInstanceToDefault( ArmMIC );
		}

		// Note if this state change was forced upon us
		bEnforcedNanoStateChanged = (!bChangingSelf);

		`loginfo( 'Nano_Powers', "NanoState CHANGE TO"@NewState);
		CurrNanoState = NewState;

		// If force to different state, set timer for turning back.
		if(bEnforcedNanoStateChanged && (CurrNanoState != ENS_Normal))
		{
			SetTimer(StateChangeAttackStunDuration, FALSE, nameof(RestoreDefaultNanoState));
		}

		UpdateAirControl();

		// Fire any kismet events
		class'NanoTypes'.static.FireNanoStateChangeEvent(self, Controller, NewState);
	}
	return TRUE;
}

simulated event EnableFakeGhostEffects()
{
	local NanoSkill_Ghost GhostSkill;

	GhostSkill = GetSkill(class'NanoSkill_Ghost');
	if( GhostSkill != None && !bFakeGhostEffects )
	{
		bFakeGhostEffects = TRUE;

		//GhostSkill.ActivePowerParticleSystems( self );
		GhostSkill.NanoPowerParticleBodyEffects_On( self );
		GhostSkill.SpawnEffectsFromArcheType( self );
		GhostSkill.SwitchToPowerActivatedMaterials( self );
	}
}

simulated event DisableFakeGhostEffects()
{
	local NanoSkill_Ghost GhostSkill;

	ClearTimer( nameof(DisableFakeGhostEffects) );

	GhostSkill = GetSkill(class'NanoSkill_Ghost');
	if( GhostSkill != None && !GhostSkill.bActive && bFakeGhostEffects )
	{
		bFakeGhostEffects = FALSE;

		GhostSkill.DeactivePowerParticleSystems( self );
		GhostSkill.NanoPowerParticleBodyEffects_Off( self );
		GhostSkill.RestoreDefaultMaterials( self );
	}
}

simulated function EnableFakeDenseEffects()
{
	local NanoSkill_Dense DenseSkill;

	DenseSkill = GetSkill(class'NanoSkill_Dense');
	if( DenseSkill != None && !bFakeDenseEffects )
	{
		bFakeDenseEffects = TRUE;

//		DenseSkill.ActivePowerParticleSystems( self );
		DenseSkill.NanoPowerParticleBodyEffects_On( self );
		DenseSkill.SpawnEffectsFromArcheType( self );
		DenseSkill.SwitchToPowerActivatedMaterials( self );

//		UpdateJumpAnimSet( 'DropTheHammer' );
	}
}

simulated function DisableFakeDenseEffects()
{
	local NanoSkill_Dense DenseSkill;

	ClearTimer( nameof(DisableFakeDenseEffects) );

	DenseSkill = GetSkill(class'NanoSkill_Dense');
	if( DenseSkill != None && !DenseSkill.bActive && bFakeDenseEffects )
	{
		bFakeDenseEffects = FALSE;

//		DenseSkill.DeactivePowerParticleSystems( self );
		DenseSkill.NanoPowerParticleBodyEffects_Off( self );
		DenseSkill.RestoreDefaultMaterials( self );
	}
}

/** == Dash/jump functions - BEGIN == */

native function float GetGravityZ();

/** Helper function that checks for an LaunchTarget interface, and uses that location if available */
event bool AttemptBigJumpToActor(Actor ActorTarget, float JumpTime)
{
	local NanoInterface_LaunchTarget LT;

	if( ActorTarget != None )
	{
		LT = NanoInterface_LaunchTarget(ActorTarget);
		return AttemptBigJump( (LT != None ? LT.GetLandingLocation() : ActorTarget.Location), JumpTime );
	}

	return FALSE;
}

event bool AttemptBigJump(vector Destination, float JumpTime)
{
	local float BackupGravityScale;
	local vector JumpVelocity, JumpDelta;
	local NanoPC NPC;

	// Backup the current gravity scale, so we can restore it if we fail.
	BackupGravityScale = JumpHoldGravityZScale;
	// Set the gravity scale to 1.f so we get an accurate launch trajectory
	JumpHoldGravityZScale = 1.f;

	// Attempt to calculate a trajectory to the target
	if( SuggestBigJumpVelocity(JumpVelocity, Destination, Location, JumpTime) )
	{
		bIsControlledJump = TRUE;

		DeactivateSkill(class'NanoSkill_Jump');

		// End special moves that might interfere with jumping
		if( IsLocallyControlled() )
		{
			EndSpecialMove();
		}
		else
		{
			ServerEndSpecialMove();
		}

		// Make sure the pawn isn't attached to anything
		SetBase(None);
		SetHardAttach(FALSE);


		// If it is a significant horizontal distance, face in the direction we are going
		JumpDelta = Destination - Location;
		JumpDelta.Z = 0.0;
		if( VSize(JumpDelta) > 100.0 )
		{
			SetDesiredRotation( rotator(JumpDelta) );

			NPC = NanoPC(Controller);
			if(NPC != None)
			{
				NPC.InterpViewRotation( rotator(JumpDelta), 0.5*JumpTime );
			}
		}

		// Jump!
		SetPhysics(PHYS_Falling);
		Velocity = JumpVelocity;

		// Disable air control and ignore air friction to ensure we reach our target.  These will be reset on landing
		AirControl = 0.f;
		bIgnoreAirFriction = TRUE;

		return TRUE;
	}
	else
	{
		JumpHoldGravityZScale = BackupGravityScale;
		return FALSE;
	}
}

/** Suggest vel for a 'big jump' i.e. not one constrained by pawns abilities, e.g. flag pole */
native function bool SuggestBigJumpVelocity(out vector JumpVelocity, vector Destination, vector Start, float JumpTime);

final function SetReplicatedSkillStatus( ENanoSkills SkillType, bool bNewVal )
{
	if( Role == ROLE_Authority )
	{
		ReplicatedSkillStatus[SkillType] = (bNewVal ? 1 : 0);
	}
}

/** Called when the ReplicatedSkillStatus array is changed.  Iterates over the skills array, and activates / deactivates nano skills as needed according to the replicated array */
native final private function UpdateActiveNanoSkills();

reliable server final function ServerSkillActivated( class<NanoSkill> SkillToActivate )
{
	ActivateSkill(SkillToActivate);
}

reliable server final function ServerSkillDeactivated( class<NanoSkill> SkillToDeactivate )
{
	DeactivateSkill(SkillToDeactivate);
}

/**
 * Returns the current dash level index, or if !bActiveDashingOnly will return the last valid dash level index if within the slide duration.
 */
native function int GetDashPip();
simulated function int HackGetDashPip()
{
	return GetDashPip();
}

function bool IsNearFloor(optional float TraceDist = 32.f)
{
	local Actor HitA;
	local vector HitL, HitN, TraceStart;
	TraceStart = Location;
	TraceStart.Z -= GetCollisionHeight();
	HitA = Trace(HitL,HitN,TraceStart - vect(0,0,1) * TraceDist,TraceStart);
	`loginfo( 'Nano_Locomotion', `location@`showvar(HitA));
	return (HitA != None && HitA.bWorldGeometry);
}

function bool IsNearWall(vector TraceDir, optional out vector out_WallNormal, optional out vector out_WallLoc, optional float TraceMag = -1.f)
{
	local Actor HitA;
	local vector TraceStart;
	TraceStart = Location;
	TraceStart.Z -= GetCollisionHeight();
	if (TraceMag == -1.f)
	{
		TraceMag = GetCollisionRadius() * 4;
	}
	HitA = Trace(out_WallLoc,out_WallNormal,TraceStart + (TraceDir * TraceMag),TraceStart);

//	DrawDebugLine(TraceStart,TraceStart + (TraceDir * TraceMag),255,0,0,TRUE);
//	`log( "INW"@HitA@(out_WallNormal DOT TraceDir) );

	return (HitA != None && HitA.bWorldGeometry && (out_WallNormal dot TraceDir) < -0.1f && (out_WallNormal.Z < WalkableFloorZ));
}

simulated function bool AttemptHammer()
{
	if( CanDoSpecialMove( 'NSM_Melee_DropTheHammer' ) == TRUE )
	{
		// if the move says we can do it then FORCE do it! because drop the hammer should trump anything else we are doing
		DoSpecialMove( 'NSM_Melee_DropTheHammer', TRUE );
		return TRUE;
	}

	// if we are already doing DropTheHammer then we are "attempting it"
	if( IsDoingSpecialMove( 'NSM_Melee_DropTheHammer') == TRUE )
	{
		return TRUE;
	}

	return FALSE;
}

simulated function float GetFallingZImpactBasedOnJumpSkill()
{
	local NanoSkill_Jump JumpSkill;
	local NanoSkill_Ghost GhostSkill;
	local NanoSkill_Dense DenseSkill;
	local float FallingZImpact;

	GhostSkill = GetActiveSkill( class'NanoSkill_Ghost' );
	DenseSkill = GetActiveSkill( class'NanoSkill_Dense' );

	// do a bunch of checks here to see if we should take no falling damage
	// if we are dropping the hammer
	// if we are ghosting
	// if we are densing
	if( ( bBRINGDAHAMMER == TRUE ) || ( GhostSkill != none ) || ( DenseSkill != none ) || IsInState( 'CradleSurfing' ) )
	{
		return 0.0f;
	}

	JumpSkill = GetSkill(class'NanoSkill_Jump');

	if( JumpSkill != None )
	{
		FallingZImpact = CalcFallingZImpact(JumpSkill.JumpLevels[JumpSkill.GetMaxJumpLevel(self)].MaxFallVelocity,JumpSkill.JumpLevels[JumpSkill.GetMaxJumpLevel(self)].MinFallVelocity);
	}
	else
	{
		// In case no jump skill is available (i.e. when connecting to a netgame), just return 0.f
		return 0.f;
	}

	// otherwise return the amount of damage we would have taken
	return FallingZImpact;
}

simulated final function float CalcFallingZImpact(const float MaxVel, const float MinVel)
{
	local float Amt;
	if (Velocity.Z < MaxVel)
	{
		Amt = (Velocity.Z - MaxVel)/(MinVel - MaxVel);
		return Amt ** 4;
	}
	return 0.f;
}

function TakeFallingDamage()
{
//	local float Amt;
	if( !IsHumanControlled() )
	{
		Super.TakeFallingDamage();
	}
//remove falling failsafe so we can iron out actual design jump mechanics
/*
	else
	{
		Amt = GetFallingZImpactBasedOnJumpSkill();
		if (Amt > 0.1)
		{
			`log(`location@`showvar(Velocity.Z)@`showvar(Amt));
			if (Amt > 0.1)
			{
				// so here if we were going to die: we need to check that the red screen has been up for enough time to allow
				// the player to react to it
				//`log( "RedScreenDeathWarningTime" @ `TimeSince( RedScreenDeathWarningTime ) ) ;
				if( (Amt >= 0.4) && ( `TimeSince(RedScreenDeathWarningTime) > RedScreenDeathReactionTime ) )
				{
					// safety teleport, would have died
					Velocity = vect(0,0,0);
					ResetToAnchor();
				}
				else
				{
					// survivable
					//TakeDamage( Min( (Amt * DefaultHealth), (DefaultHealth-1) ),Controller,Location,vect(0,0,0),class'DmgType_Fell');
					// so here we want to make it so that you can choose to reset the anchor
					SetTimer( 5.0f, FALSE, nameof(ResetToAnchorIsValid) );
				}
			}
		}
	}
*/
}


/** Function that we are using for our timer on whether or not we can teleport **/
final function ResetToAnchorIsValid();

final native function float CalcSlopeSpeedScale(vector Dir);

simulated final function ScaleVelocityForLanding()
{
	if (Floor.Z == 1.f)
	{
		Velocity *= 0.8f;
	}
	else
	{
		if (Velocity dot Floor > 0.f)
		{
			Velocity *= 1.2f;
		}
		else
		{
			Velocity *= 0.8f;
		}
	}
}

event PreLand( float HowLong )
{
	//`log(`location@`showvar(bSlideOnLanding));
	if (bSlideOnLanding)
	{
		bSlideOnLanding = FALSE;
		DoSpecialMove( 'NSM_Dash_Slide', TRUE );
	}
}

simulated event Landed(vector HitNormal, Actor FloorActor)
{
	local NanoPC PC;
	local NanoAI AI;
	local NanoSkill_Jump JumpSkill;
	local NanoSkill_Dash DashSkill;
	local bool bBustingThroughWithHammer;
	local vector HitLoc, HitNorm;
	local NanoWeaponBase Weap;
	local int Idx;
	local NanoVehicleAgent NVA;
	local NSM_Mantle_Base MantleSM;
	local int PrevHighestFall;


	if( NanoBounceMeshBase(FloorActor) != None )
	{
		// Handle the case where we land on a bounce mesh and need to be bumped off
 		Trace(HitLoc, HitNorm, Location - vect(0.f,0.f,256.f), Location);
 		NanoBounceMeshBase(FloorActor).BouncePawn(self, HitLoc, HitNorm);
	}

	//`log("----- LANDED -----"@ self @ `showvar(Base)@`showvar(bSlideOnLanding));
	if( bSlideOnLanding )
	{
		bSlideOnLanding = FALSE;
		DoSpecialMove( 'NSM_Dash_Slide', TRUE );
	}

	bBustingThroughWithHammer = IsDroppingTheHammer() && (FracturedStaticMeshActor(FloorActor) != None);
	if( !bBustingThroughWithHammer && NanoPerchPoint(Base) == None )
	{
		bJumpSetIsDirty = TRUE;
	}

	Super.Landed(HitNormal,FloorActor);

	for( Idx = 0; Idx < Mantles.Length; Idx++ )
	{
		MantleSM = NSM_Mantle_Base(GetSpecialMoveByName(Mantles[Idx]));

		if( MantleSM != None && MantleSM.bResetOnLanding )
		{
			MantleSM.bDisabled = FALSE;
		}
	}
	MantleState = MANTLE_None;

	// If you want pawn to be knocked down upon landing, set bKnockDownOnLanding (see bottom of this function)

	MakeNoise(1.f);

	`loginfo( 'Nano_Locomotion', `location );
	LastLandingTime = WorldInfo.TimeSeconds;
	LastFallingDuration = `TimeSince(StartFallingTime);
	LastFallingDistance = StartFallingLocation.Z - Location.Z;
	bJustDidWallJump = FALSE; // reset that we just did wall jump
	bIsPlatformJumping = FALSE;

	JumpSkill = GetSkill(class'NanoSkill_Jump');
	if (JumpSkill != None)
	{
		JumpSkill.NotifyLanded(self);
	}

	DashSkill = GetSkill(class'NanoSkill_Dash');
	if (DashSkill != None)
	{
		DashSkill.NotifyLanded(self);
	}

	if( !bBustingThroughWithHammer )
	{
		ScaleVelocityForLanding();
	}

	UpdateAirControl();
	TargetedAttractionActor = None;

	PC = NanoPC(Controller);
	if( PC != None
		&& IsLocallyControlled()
		// don't play a grunt down when you land and are ghosted or densed
		&& GetActiveSkill( class'NanoSkill_Dense' ) == None
		&& GetActiveSkill( class'NanoSkill_Ghost' ) == None
		)
	{
		//`log( `showvar(LastFallingDuration) @ `showvar(LastFallingDistance) );

		if( LastFallingDuration > DurationInAirToPlayALargeLandSound )
		{
			//`log( "LandedLargeCue" );
			PC.PlaySound( LandedLargeCue );
		}
		else if( LastFallingDuration >= DurationInAirToPlayAMediumLandSound )
		{
			// don't play the grunts when we are doing lots of jumps in a row as it sounds silly but sometimes play a grunt
			// when we are chain jumping
			if( LastFallingDuration >= 2.0f )
			{
				//`log( "LandedMediumCue" );
				PC.PlaySound( LandedMediumCue );
			}
			else if( ( LastFallingDuration < 2.0f ) && ( FRand() < 0.40f ) )
			{
				//`log( "LandedMediumCue RAND" );
				PC.PlaySound( LandedMediumCue );
			}
			else
			{
				//`log( "LandedSmallCue MED" );
				PC.PlaySound( LandedSmallCue );
			}
		}
		else
		{
			//`log( "LandedSmallCue" );
			PC.PlaySound( LandedSmallCue );
		}
	}

	Weap = NanoWeaponBase(Weapon);
	if( Weap != None )
	{
		Weap.HandleLanded();
	}


	if (bIsAttachedToWall)
	{
		DetachFromWall();
	}

	if( !IsDroppingTheHammer() && (NanoInterface_StabMantle(FloorActor) != none) && (NanoInterface_StabMantle(FloorActor).IsValidStabMantleTarget(TRUE) == TRUE ) )
	{
		NVA = NanoVehicleAgent(FloorActor);
 		if( NVA != None )
 		{
 			NVA.DoAttachingDamage(self, 0.5f * Velocity);
 		}
		NanoInterface_StabMantle(FloorActor).NotifyFinishedStabMantle( self, TRUE );
	}

 	if (PC != None && (`TimeSince(LastFailedJumpAttemptTime) < 0.2f && JumpHoldTime < 0.f) && !IsPlatformJumping() && !IsDroppingTheHammer() && NanoPerchPoint(FloorActor) == None)
 	{
 		SetTimer(0.05,FALSE,nameof(AutoJumpAfterLand));
 	}

	if(	IsDroppingTheHammer() && NSM_Melee_DropTheHammer(ActiveSpecialMove) != None )
	{
		NSM_Melee_DropTheHammer(ActiveSpecialMove).HandleLanded( HitNormal, FloorActor );
	}

	// reset the power recharge
	if (WorldInfo.TimeSeconds > LastNanoPowerUseTime)
	{
		LastNanoPowerUseTime = WorldInfo.TimeSeconds;
	}

	if( Pawn(FloorActor) == None )
	{
		AI = NanoAI(Controller);
		if( AI != None )
		{
			// Release AI from stun setup during the fall
			AI.UnstunAI( 'Knockback' );
		}

		// Finally see if we should be knocked down upon landing
		if( bKnockDownOnLanding )
		{
			// if we are knocked down then drop our shield
			if( bHasShield == TRUE )
			{
				DropShield();
			}

			//`log( `location@`showvar(Velocity)@Physics@bJuggled );
			if( !bJuggled || Velocity.Z < -MaxJuggleFallSpeed || bJuggleForceKnockDown )
			{
				Knockdown( IsHumanControlled() ? 1.5f : 3.f, TRUE );
			}
			bKnockDownOnLanding = FALSE;
			bJuggleForceKnockDown = FALSE;
		}
		bJuggled = FALSE;
	}

	if( PC != None && PC.bCameraLookAtIsFromSpecialMove )
	{
		PC.SpecialMove_ClearCameraFocus();
	}

// 	if( PC != None )
// 	{
// 		PC.LevelViewRotation(0.3f);
// 	}


	ElevatorEjectionTarget = None;
	bIgnoreAirFriction = FALSE;
	bIsSkydiving = FALSE;
	bIsControlledJump = FALSE;
	bFallingFromMantle = FALSE;
	bDodging = FALSE;


	// handle the case where we are stuck on a wall not falling at all, but stuck. 
	// we invoke a special move which will take care of getting us off the wall
	if( PC != None )
	{
		if( LastFallingDistance == 0.0f ) 
		{
			`warn( "FALLBACK!!" @ `showvar(LastFallingDistance) );
			DoSpecialMove( 'NSM_EscapeFromBeingStuckLandingOnWall', TRUE );
		}

		// when we actually land from the special's "kick" we when end that special move
		if( IsDoingSpecialMove( 'NSM_EscapeFromBeingStuckLandingOnWall' ) == TRUE )
		{
			EndSpecialMove();
		}

		// look for special moves that did not end correct
		// and just FORCE end them
		if( IsDoingSpecialMove( 'NSM_PerchOnPoint' ) == TRUE )
		{
			//EndSpecialMove();
		}

		if( IsDoingSpecialMove( 'NSM_FireEscape' ) == TRUE )
		{
			//EndSpecialMove();
		}

		if( IsDoingSpecialMove( 'NSM_WireSlide' ) == TRUE )
		{
			//	EndSpecialMove();
		}

		// if we we have fallen more than our previous highest fall distance then update
		NanoGRI(WorldInfo.GRI).MCP.FindIntValue( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.HighestFall, PrevHighestFall );
		if( LastFallingDistance > PrevHighestFall )
		{
			NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.HighestFall, LastFallingDistance );
		}

		if( LastFallingDistance > 4000 )
		{
			NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_FellMoreThan4000 );
		}
	}
}

simulated function AutoJumpAfterLand()
{
	local vector StickDir;
	local NanoSkill_Jump JumpSkill;
	local Rotator CamRot;
	local Vector CamLoc;
	local NanoPC PC;

	JumpSkill = GetSkill(class'NanoSkill_Jump');
	if( JumpSkill != None && !bIsDoingMeleeAttack && !bPlayingHitReaction )
	{
		`loginfo('Nano_Locomotion',"auto jumping");

		// If player continues to hold A after auto jump kicks in - activate JumpHoldTime
		PC = NanoPC(Controller);
		if( PC != None && PC.IsButtonActive( GB_A ) )
		{
			GetActorEyesViewPoint(CamLoc,CamRot);

			StickDir.X = PC.PlayerInput.RawJoyUp;
			StickDir.Y = PC.PlayerInput.RawJoyRight;
			StickDir = StickDir >> CamRot;
			if( !JumpSkill.AttemptDodge( self, StickDir ) )
			{
				if( JumpSkill.AttemptJump( self, StickDir, (PC.PlayerInput.aBaseY > 0.1) ) )
				{
					JumpHoldTime = WorldInfo.TimeSeconds;
				}
			}
		}
	}
}

event Falling()
{
	local NanoSkill_Jump JumpSkill;

	Super.Falling();

	`loginfo( 'Nano_Locomotion', `location);
	JumpSkill = GetSkill(class'NanoSkill_Jump');
	if (JumpSkill != None)
	{
		JumpSkill.NotifyFalling(self);
	}

	UpdateAirControl();
	StartFallingTime = WorldInfo.TimeSeconds;
	StartFallingLocation = Location;
}


simulated function bool CanBeJuggled()
{
	return TRUE;
}

function HandleMomentum( vector Momentum, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo );

simulated final function UpdateAirControl()
{
	local NanoPC PC;

	AirControl = NormalAirControl;

	PC = NanoPC(Controller);
	if( PC != None && PC.ViewRotationInterpTimer > 0.f )
	{
		AirControl = 0.f;
	}
	else
	{
		if (Physics == PHYS_Falling)
		{
			if (Velocity.Z < 0)
			{
				AirControl = FallingAirControl;
			}
		}
		if (CurrNanoState == ENS_Dust)
		{
			AirControl += DustedAirControlModifier;
		}
		else if (CurrNanoState == ENS_Dense)
		{
			AirControl += DensedAirControlModifier;
		}
	}
}

/** == Dash/jump functions - END == */



/** This Pawn has touched a slickified surface **/
simulated function OnSlickify()
{
	Slickify_TimeUntilSlickifiedSurfaceEnds = WorldInfo.TimeSeconds + Slickify_DurationOfSlickifySpeedEffect;
}


simulated function OnGreyGooGrabby()
{
	GreyGooGrabby_TimeUntilGrabbySurfaceEnds = WorldInfo.TimeSeconds + GreyGooGrabby_DurationOfGrabbySpeedEffect;
}

/** Util to see if Pawn is in a particular EDashPip */
native simulated function bool IsInAtLeastDashPip(BYTE InLevel) const;

/** Util to see if Pawn is doing the DropTheHammer move.  Which will have dash level requirements and the actual move is being attempted */
native simulated function bool IsDroppingTheHammer() const;

function JumpOffPawn()
{
	local NanoPawn NP;

	NP = NanoPawn(Base);
	if( NP == None || !LandOnPawn( NP ) )
	{
		Super.JumpOffPawn();
	}
}

simulated function bool LandOnPawn( NanoPawn NP );

simulated function SetSwordActive( bool bActive )
{
	bIsSwordActive = bActive;

	if( bIsSwordActive )
	{
		LastSwordActiveTime = WorldInfo.TimeSeconds;
		//SpawnWeaponCrowdPanicRepulsor( class'NanoCrowd_PanicRepulsor_MeleeWeaponOut' );
	}
}

/** Quickly goes to 'hands free' state with no weapon holstered */
simulated function DiscardCurrentWeapon()
{
	SetSwordActive( FALSE );
	DetachFromWall();
	DestroyCurrentWeapon();
}

/** Begin weapon summoning */

delegate WeaponFinishedSummoning();

final function bool SummonWeapon(class<NanoWeaponBase> WeaponToSummon, optional delegate<WeaponFinishedSummoning> OnFinish)
{
	//`log(`location@`showvar(WeaponToSummon)@`showvar(Weapon)@`showvar(WeaponToSummon.default.NanoSummonCost));
	if( (Weapon == None || Weapon.Class != WeaponToSummon) )
	{
		if( Role < ROLE_Authority )
		{
			NotifyServerWeaponSummoning(WeaponToSummon);
		}

		bSummoningInProgress = TRUE;
		PendingWeaponClass = WeaponToSummon;
		WeaponFinishedSummoning = OnFinish;
		// put our current weapon away, which will in turn unholster the pending weapon
		HolsterCurrentWeapon();
		return TRUE;
	}

	return FALSE;
}

reliable server function NotifyServerWeaponSummoning(class<NanoWeaponBase> WeaponToSummon)
{
	// Keep these vars in synch on the server while the client plays effects
	bSummoningInProgress = TRUE;
	PendingWeaponClass = WeaponToSummon;
}

/** Put away the current weapon and set timer for unholstering the pending weapon.  If no current weapon, immediately jump to unholster. */
final function HolsterCurrentWeapon()
{
	local class<NanoWeaponBase> CurrentWeaponClass;
    local Weapon ExistingWeap;
	local float AnimTime;
	local float RateScale;

    ExistingWeap = Weapon(InvManager.FindInventoryType(PendingWeaponClass,FALSE));
	// ExistingWeap == None means we do not have this weapon already in our inventory
    if( ExistingWeap == None && PendingWeaponClass != none )
    {
		// need to pay the summon cost
		ConsumeNanoBucket( PendingWeaponClass.default.NanoSummonCost );
    }

	// Get the class of the weapon we currently hold
	if(Weapon != none)
	{
		CurrentWeaponClass = class<NanoWeaponBase>(Weapon.Class);
	}


	//`log(`location@`showvar(CurrentWeaponClass));
	if (CurrentWeaponClass != None && CurrentWeaponClass != class'NanoWeap_Hands')
	{
		if (CurrentWeaponClass.default.DismissCue != None)
		{
			PlaySound(CurrentWeaponClass.default.DismissCue);
		}

		if (ExistingWeap == None)
		{
		    // if we're summoning a new weapon we need to hide the current slightly before
			InvManager.SetCurrentWeapon(None);
			CleanUpSpawnWeaponCrowdPanicRepulsor();
		}


		AnimTime = 0.01f;
		RateScale = 1.f;

		if( CurrentWeaponClass.default.HolsterWeaponAnim != '' )
		{
			AnimTime = TopHalfSlot.PlayCustomAnim( CurrentWeaponClass.default.HolsterWeaponAnim, 1.f*RateScale, 0.1f, 0.1f, FALSE, TRUE );
		}

		// if switching to 'nothing' (ie just a holster) and we have a throw away anim, play it and pause
		// set the timer to actually draw the weapon
		SetTimer( AnimTime, FALSE, nameof(UnholsterPendingWeapon) );


		// Tell kismet
		TriggerEventClass(class'SeqEvt_NanoActionPerformed', self, 8);
	}
	else
	{
		InvManager.SetCurrentWeapon(None);
		UnholsterPendingWeapon();
	}
}

/** Bring up a weapon from the inventory or start the summoning process if it is a new weapon */
private final function UnholsterPendingWeapon()
{
	local ParticleSystemComponent SummonFXComp;
	local float RateScale;
	local Weapon ExistingWeap;
	local NanoPC NPC;
	local bool bShouldInstantSummon;
	local float AnimTime;
	local name AnimName;

	ExistingWeap = Weapon(InvManager.FindInventoryType(PendingWeaponClass,FALSE));

	// We set this at the beginning of the unholster/summon
	SetSwordActive( ClassIsChildOf( PendingWeaponClass, class'NanoWeap_Melee' ) );

	//`log(`location@`showvar(ExistingWeap)@`showvar(PendingWeaponClass));
	//ScriptTrace();

	// Should instantly summon a weapon if the config says to, the weapon class says to, or if we're in the air
	bShouldInstantSummon = bInstantSummoning || (PendingWeaponClass != None && PendingWeaponClass.default.TimeToSummonWeapon == 0.f) || (Physics == PHYS_Falling);

	RateScale = 1.f;

	// if we have the weapon or we're switching to nothing
	if (ExistingWeap != None || PendingWeaponClass == None || bShouldInstantSummon)
	{
		// play unholster cue
		if (PendingWeaponClass != None && PendingWeaponClass.default.UnholsterCue != None)
		{
			PlaySound(PendingWeaponClass.default.UnholsterCue);
		}

		// switch to the pending weapon
		InvManager.SetCurrentWeapon(ExistingWeap);

		AnimTime = 0.01f;


		if( ( NanoWeapon(ExistingWeap) != None ) && ( NanoWeapon(ExistingWeap).DrawWeaponAnim != 'None' ) )
		{
			AnimName = NanoWeapon(ExistingWeap).DrawWeaponAnim;
		}
		else if( PendingWeaponClass != None )
		{
			AnimName = PendingWeaponClass.default.DrawWeaponAnim;
		}


		if( AnimName != 'None' )
		{
			AnimTime = TopHalfSlot.PlayCustomAnim( AnimName, 1.f*RateScale, 0.1f, 0.1f, FALSE, TRUE );
		}

		//`log( `showvar(ExistingWeap) @ `showvar(PendingWeaponClass) @ `showvar(AnimName) @ `showvar(AnimTime) );

		// set the timer to actually draw the weapon
		SetTimer(AnimTime,FALSE,nameof(WeaponUnholstered));
	}
	else if (PendingWeaponClass != None)
	{
		if( WorldInfo.NetMode != NM_DedicatedServer )
		{
			// create summon fx
			if (PendingWeaponClass.default.SummonEffect != None)
			{
				SummonFXComp = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PendingWeaponClass.default.SummonEffect, Mesh, PendingWeaponClass.default.SummonEffectSocketName, TRUE );
				SummonFXComp.CustomTimeDilation = RateScale;
			}

			// play summon anim
			if (PendingWeaponClass.default.SummonAnimName != 'None')
			{
				TopHalfSlot.PlayCustomAnim( PendingWeaponClass.default.SummonAnimName, 1.f*RateScale, 0.1f, 0.1f, FALSE, TRUE );
			}

			// play summon cue
			if (PendingWeaponClass.default.SummonCue != None)
			{
				if( NanoPC(Controller) != None )
				{
					NanoPC(Controller).SetSoundMode( 'WeaponSummon' );
				}

				PlaySound(PendingWeaponClass.default.SummonCue);
			}

			// play summon slomo curve, and focus on the summon
			if( PendingWeaponClass.default.SummonSlomoCurve.Points.Length > 0 )
			{
				NPC = NanoPC(Controller);
				NanoGRI(WorldInfo.GRI).GameSlomoCurve(PendingWeaponClass.default.SummonSlomoCurve);

 				NPC.SetFocusPoint( FALSE, self, vect2d(3.f, 3.f), vect2d(1.f, 1.f), 65.f, TRUE, TRUE, FALSE, 'b_MF_UpperArm_R', FALSE );
 				NPC.SetTimer(PendingWeaponClass.default.TimeToSummonWeapon, FALSE, nameof(NPC.ClearFocusPoint_KeepRotation));

				NPC.IgnoreLookInput(TRUE);
				NPC.SetTimer(0.9f * PendingWeaponClass.default.TimeToSummonWeapon, FALSE, nameof(NPC.ResetPlayerMovementInput));
			}
		}

		// set timer to finish the summon
		SetTimer(PendingWeaponClass.default.TimeToSummonWeapon * 1.f/RateScale,FALSE,nameof(WeaponUnholstered));


		// and notify kismet
		if( ClassIsChildOf( PendingWeaponClass, class'NanoWeap_MP7' ) )
		{
			TriggerEventClass(class'SeqEvt_NanoActionPerformed', self, 5);
		}
		else if( ClassIsChildOf( PendingWeaponClass, class'NanoWeap_Melee' ) )
		{
			TriggerEventClass(class'SeqEvt_NanoActionPerformed', self, 6);
		}
		//CONTENTMOVEBROKE
		//else if( ClassIsChildOf( PendingWeaponClass, class'NanoWeap_RicochetMoon' ) )
		//{
		//	TriggerEventClass(class'SeqEvt_NanoActionPerformed', self, 7);
		//}
		//else if( ClassIsChildOf( PendingWeaponClass, class'NanoWeap_RicochetMoonHook' ) )
		//{
		//	TriggerEventClass(class'SeqEvt_NanoActionPerformed', self, 7);
		//}
	}
}

/** Weapon has finishe unholstering/summoning, so clean up and fire delegate. */
private function WeaponUnholstered()
{
	//`log(`location@`showvar(Weapon)@`showvar(PendingWeaponClass)@WeaponFinishedSummoning);
 	//ScriptTrace();

	if (Weapon == None || Weapon.Class != PendingWeaponClass)
	{
		// create the weapon if summoning
		SpawnANanoWeapon(PendingWeaponClass);
	}

	// and clean up
	bSummoningInProgress = FALSE;
	PendingWeaponClass = None;

	if( Role < ROLE_Authority )
	{
		NotifyServerFinishedWeaponSummon();
	}

	// restore SoundMode if we are still in 'WeaponSummon' soundmode
	if( NanoPC(Controller) != none )
	{
		if( NanoPC(Controller).GetCurrentSoundMode() == 'WeaponSummon' )
		{
			NanoPC(Controller).SetSoundMode( 'Default' );
		}
	}

	if( Weapon != None )
	{
		WeaponFinishedSummoning();
	}
}

reliable server function NotifyServerFinishedWeaponSummon()
{
	bSummoningInProgress = FALSE;
	PendingWeaponClass = None;
}

/** End weapon summoning */
function bool ConfineToClampedBase()
{
	// If no longer on our clamped base
	if( ClampedBase != None && Base != ClampedBase )
	{
		// Confine the pawn to our original clamped base
		// TODO:  Insert conditional checks, if needed later
		return TRUE;
	}
	return FALSE;
}
event BaseChange()
{
	local NanoInterface_StabMantle NISM;
	local bool	bBasedOnInteractionPawn;

	// See if Pawn is based on his interaction pawn (eg. hostage)
	bBasedOnInteractionPawn = InteractionPawn != None && IsDoingASpecialMove() && (Base == InteractionPawn);

	// if necessary, force the Pawn to stay on its old Base
	if( ClampedBase != None && ClampedBase != Base && (bJustTeleported || Physics == PHYS_RigidBody) && (Role == ROLE_Authority) )
	{
		//`DLog("Clear ClampedBase:" @ ClampedBase @ "cleared. New Base:" @ Base @ "SpecialMove" @ SpecialMove @ "Physics:" @ Physics @ "bJustTeleported:" @ bJustTeleported);
		ClampedBase = None;
	}

	//`DLog("ClampedBase:" @ ClampedBase @ "NewBase:" @ Base @ "bHardAttach:" @ bHardAttach @ "bBasedOnInteractionPawn:" @ bBasedOnInteractionPawn @ "ConfineToClampedBase:" @ ConfineToClampedBase());

	// if necessary, force the Pawn to stay on its old Base
	// Don't override Pawns doing a special move which can be forced to be based on their InteractionPawn
	if( ClampedBase != None && !bHardAttach && !bBasedOnInteractionPawn && ConfineToClampedBase() )
	{
		//`DLog("Restore ClampedBase:" @ ClampedBase @ "instead of keeping NewBase:" @ Base );
		SetBase(ClampedBase);
 		if( Physics == PHYS_Falling && Controller != None )
 		{
 			bCanJump = true;
 			Controller.MayFall(FALSE, vect(0,0,0));
 			if (!bCanJump)
 			{
 				SetPhysics(PHYS_Walking);
 			}
 		}
	}
	else
	{
		// If no clamped base, perform the normal move
		if (Base == None)
		{
			// update our jump set if we've just left the ground
			if (bJumpSetIsDirty)
			{
				UpdateJumpAnimSet();
			}
			if (PerchingMode != ENPM_None)
			{
				UpdatePerchMode();
			}
			StartFallingTime = 99999999999.f;
		}

		NISM = NanoInterface_StabMantle(Base);
		if( NISM == None && bIsDoingStabMantle )
		{
			AbortStabMantle();
		}
		else if( bIsDoingCarHop )
		{
			AbortCarHop();
		}


		Super.BaseChange();
	}
}

/** Called when an  */
simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

simulated function DetachFromWall()
{
	if( bIsAttachedToWall )
	{
		bIsAttachedToWall = FALSE;
		PlayerController(Controller).PlaySound( SoundDetachedFromWallCue );

		if(Physics == PHYS_None)
		{
			SetPhysics(PHYS_Falling);
			SetHardAttach(FALSE);
			SetCollision(TRUE,TRUE,FALSE);
		}
	}
}

simulated function DoAttachToWall()
{
	local Rotator WallRot;
	local NanoPC NPC;

	bIsAttachedToWall = TRUE;
	WallAttachStartTime = WorldInfo.TimeSeconds;

	PlayerController(Controller).PlaySound( SwordAttachedToWallCue );

	if(PendingForceNormal != vect(0,0,0))
	{
		WallAttachNormal = PendingForceNormal;
	}
	else
	{
		IsNearWall(PendingAttachDir, WallAttachNormal,, GetCollisionRadius() * 5.f);
	}

	// Update pawn rotation now
	WallRot = rotator(WallAttachNormal);
	WallRot.Pitch = 0;
	SetRotation(WallRot);

	// Set PC to look away from wall now
	NPC = NanoPC(Controller);
	if(NPC != None)
	{
		WallRot = rotator(WallAttachNormal);
		WallRot.Pitch = NPC.Rotation.Pitch;
		WallRot.Roll = 0;

		NPC.SetRotation(WallRot);
		//`log("--------- SET ROT"@WallRot@NPC.Rotation);
	}

	TriggerEventClass(class'SeqEvt_NanoActionPerformed', self, 13);
}

simulated function AttachToWall(vector AttachDir, optional vector ForceNormal, optional bool bStepOff)
{
	if (ConsumeNanoBucket(SwordAttachCost))
	{
		PendingAttachDir = AttachDir;
		PendingForceNormal = ForceNormal;

		// Play stabbing animation if we were sliding down
		if(bSlidingDown)
		{
			FullBodySlot.PlayCustomAnim('Wall_Slide_Stab_Fast', 1.0, 0.0, 0.1);
			SetTimer(0.6, FALSE, nameof(DoAttachToWall));
		}
		// Or from jump one if not
		else
		{
			if(!bStepOff)
			{
				FullBodySlot.PlayCustomAnim('Wall_Hang_Stab', 1.0, 0.0, 0.1);
			}

			DoAttachToWall();
			// Lose the pitch aim when doing this
			Controller.SetRotation(Rotation);
		}
	}
}

simulated function UpdatePerchMode()
{
	// perching pose
	if(NanoPerchPoint(Base) != None)
	{
		PerchingMode = ENPM_PerchPoint;
	}
	else if(IsAttachedToPerch() && !bStabMantling)
	{
		PerchingMode = ENPM_Car;
	}
	else
	{
		PerchingMode = ENPM_None;
	}

	//`log(`location@`showvar(PerchingMode));
	//scripttrace();
}

event Vector GetCarHopTargetLocation()
{
	local NanoPC PC;
	local NanoVehicleAgent NVA;
	local vector PerchOffset;
	local rotator PerchRotation;

	PC = NanoPC(Controller);
	if( PC != None )
	{
		NVA = NanoVehicleAgent(PC.TargetedActor);

		if( NVA != None )
		{
			NVA.GetVehiclePerchOffsets(PerchOffset, PerchRotation);
			return NVA.Location + vect(0.f,0.f,64.f) + (PerchOffset >> NVA.Rotation);
		}
		else
		{
			// No target, so abort!
			AbortCarHop();
		}
	}
}

simulated event Vector GetSwordDashTargetLocation( out float out_DistThreshold )
{
	local Vector Result;
	local Actor TargetedActor;
	local NanoWeap_Melee Weap;
	local float TargCylRadius, TargCylHeight;
	local float Vel2D, TimeTilIntersect;
	local Vector TargetedActorOffset;
	local Pawn TargPawn;
	local Rotator R;
	local NanoInterface_StabMantle NISM;

	out_DistThreshold = GetCollisionRadius();

	// Use the interaction actor from a special move over the targetedactor, to ensure MP compatibility
	if( InteractionActor != None )
	{
		TargetedActor = InteractionActor;
	}
	Weap = NanoWeap_Melee(Weapon);
	if( Weap != None && Weap.IsFiring() )
	{
		TargetedActor = Weap.ComboTargetedActor;
	}

	if( TargetedActor != None )
	{
		TargetedActor.GetBoundingCylinder( TargCylRadius, TargCylHeight );
		out_DistThreshold += TargCylRadius;

		NISM = NanoInterface_StabMantle(TargetedActor);
		if( NISM != None )
		{
			TargetedActorOffset += NISM.GetStabAttachOffset();
		}

		Result = TargetedActor.Location + (TargetedActorOffset >> TargetedActor.Rotation);

		TargPawn = Pawn(TargetedActor);
		if( TargPawn != None && (TargPawn.Location.Z < Location.Z) )
		{
			Result.Z -= TargPawn.GetCollisionHeight();
		}

		// Add some lead time if not mantling to a car
		Vel2D = VSize2D(Velocity);
		if( Vel2D > 0.f && !bIsDoingStabMantle )
		{
			TimeTilIntersect = VSize2D(TargetedActor.Location - Location) / Vel2D;
			Result += TargetedActor.Velocity * TimeTilIntersect * 0.1f;
		}
	}
	else
	{
		R = DesiredRotation;
		R.Pitch = -5192;
		Result = Location + Vector(R) * 1024.f;
	}

//	FlushPersistentDebugLines();
//	DrawDebugBox( Result, vect(5,5,5), 255, 0, 0, TRUE );

	return Result;
}

/** Kicks off physics/movement to 'fly' the player to the car, @see NanoPawn.NewFallVelocity() for the goodies */
function AttemptStabMantle()
{
	local NanoPC PC;

	// Perform the special move, with the PC's TargetedActor as the destination
	PC = NanoPC(Controller);
	if( PC != None )
	{
		PC.bLockedOnTargetedActor = TRUE;
	}

	DoSpecialMove( 'NSM_StabMantle', TRUE, None, PC.TargetedActor );
}

/**  */
simulated event bool IsAttachedToPerch()
{
	return ((Physics == PHYS_None || Physics == PHYS_Interpolating || Physics == PHYS_Custom) && NanoInterface_StabMantle(Base) != None && bHardAttach );
}

/** Util to get the perch pole that we are sat on (if any) */
simulated function NanoPerchPole_Base GetPerchPole()
{
	local NanoPerchPoint Point;

	Point = NanoPerchPoint(Base);
	if(Point != None)
	{
		return Point.PerchPole;
	}
	else
	{
		return None;
	}
}

simulated function AbortStabMantle()
{
	local NSM_StabMantle SM;

	SM = NSM_StabMantle(ActiveSpecialMove);
	if( SM != None )
	{
		SM.AbortStabMantle();
	}
}

/** Kicks off physics/movement to hop from one car to another, @see NanoPawn.NewFallVelocity() for the goodies */
function AttemptHopToCar()
{
	local float DistToCar;
	local NanoPC PC;
	PC = NanoPC(Controller);

	// Abort the car hop if we're already sword mantling
	if( bIsDoingStabMantle || bStabMantling || bIsDoingCarHop)
	{
		return;
	}

	DistToCar = VSize(PC.TargetedActor.Location - Location);

	// Give an initial velocity, so we don't have to start from 0 and accelerate
	Velocity = Base.Velocity;

	SetPhysics(PHYS_Falling);

	// Turn off collision before moving pawn into position
	SetCollision(FALSE,FALSE,FALSE);

	bIsDoingCarHop = TRUE;

	PC.bLockedOnTargetedActor = TRUE;

	StartedHopToCar(DistToCar);
	BlendFallNode.CopyAnimsFromSetByName( 'Sprint_Jump' );
}

simulated function AbortCarHop()
{
	local NanoPC NPC;

	//`log("ABORT CAR HOP!");
	//ScriptTrace();

	// Turn off collision before moving pawn into position
	SetCollision(TRUE,TRUE,TRUE);

	NPC = NanoPC(Controller);

	FallingFullBodySlot.StopCustomAnim( 0.1f );

	bIsDoingCarHop = FALSE;

	NPC.SetTargetedActor(None);

	UpdatePerchMode();
}

event FinishCarHop()
{
	local NanoPC NPC;
	local NanoVehicleAgent NVA;

	NPC = NanoPC(Controller);

	SetCollision(TRUE,TRUE,TRUE);
	FallingFullBodySlot.StopCustomAnim( 0.1f );

	bIsDoingCarHop = FALSE;

	NVA = NanoVehicleAgent(NPC.TargetedActor);

	if( NVA != None )
	{
		//NVA.Attach(self);
		NVA.NotifyFinishedCarHop(self);
	}

	NPC.SetTargetedActor(None);

	UpdatePerchMode();
}

/** Called once a player starts a hop to the targeted car */
event StartedHopToCar(float DistToCar)
{
	`log(`location@`showvar(DistToCar));

	TriggerEventClass(class'SeqEvt_NanoActionPerformed', self, 18);

}

/** Called from ANanoPawn::SetBase when the base changes away from the vehicle - NO NEED TO CALL DIRECLTY! */
event DetachedFromCarPerch( NanoVehicleAgent VAgent )
{
	local array<int> ActivateIndices;
	local array<SequenceEvent> ActivatedEvents;
	local SequenceEvent it;
	local SeqEvt_VehicleMounted Evt;

	// Handle the VehicleMounted event.  Since the pawn no longer is based on the vehicle, in order to have a ref to the vehicle being dismounted, we have to set it manually
	if( VAgent != None )
	{
		if( (VAgent.Health <= 0) && (VAgent.DeadVehicleCameraShake != None) )
		{
			// Stop the camera shake, if any
			NanoPC(Controller).ClientStopCameraShake(VAgent.DeadVehicleCameraShake);
		}

		if( NanoVehicle_ElevatorBase(VAgent) != None )
		{
			// Activate elevator specific output
			ActivateIndices[0] = 3;
		}
		else
		{
			// Activate normal vehicle output
			ActivateIndices[0] = 1;
		}

		// Activate VehicleMounted event on the pawn
		ActivateEventClass(class'SeqEvt_VehicleMounted', self, GeneratedEvents, ActivateIndices, FALSE, ActivatedEvents);
		foreach ActivatedEvents(it)
		{
			Evt = SeqEvt_VehicleMounted(it);
			if( Evt != None )
			{
				Evt.Vehicle = VAgent;
			}
		}

		// Activate VehicleMounted event on the vehicle
		ActivatedEvents.length = 0;
		VAgent.ActivateEventClass(class'SeqEvt_VehicleMounted', self, VAgent.GeneratedEvents, ActivateIndices, FALSE, ActivatedEvents);
		foreach ActivatedEvents(it)
		{
			Evt = SeqEvt_VehicleMounted(it);
			if( Evt != None )
			{
				Evt.Vehicle = VAgent;
			}
		}
	}

	SetHardAttach(FALSE);

	bIsSwordDashing = FALSE;
	bIsDoingStabMantle = FALSE;
	bPreparingStabMantle = FALSE;

	UpdatePerchMode();
}

/** Try and platform hop over to a specified car, without mantle attaching */
simulated function AttemptCarPlatformJump( NanoVehicleAgent NVA )
{
	local vector LandingLocation;
	local rotator LandingRotation, FaceRot;

	if( bIsPlatformJumping )
	{
		// Don't allow pawns to attempt another platform jump until they've landed!
		return;
	}

	// determine the landing location that we want to end up at
	NVA.GetVehiclePerchOffsets(LandingLocation, LandingRotation);
	LandingLocation = (LandingLocation >> NVA.Rotation) + NVA.Location - Mesh.Translation;
	LandingLocation.Z += 15.f;

	// calculate the velocity required
	if( AttemptBigJump(LandingLocation, 0.85f) )
	{
		if (!bEmptyHanded)
		{
			HolsterCurrentWeapon();
		}
		// Deactivate ghosting
		DeactivateSkill(class'NanoSkill_Ghost');
		bIsPlatformJumping = TRUE;
		FaceRot.Yaw = rotator(Velocity).Yaw;
		SetDesiredRotation(FaceRot);
	}
}

/** Try and step over ledge and go straight into sword slide */
simulated function bool AttemptOverLedgeStab()
{
	local vector FaceDir;

	SetPhysics(PHYS_Falling);

	FaceDir = vector(Rotation);

	// First move out beyond ledge- this must be at least 2x radius, but add extra
	Move(FaceDir * GetCollisionRadius() * 3.0);
	// Now move down so we are overlapping wall
	Move(vect(0,0,-1) * GetCollisionHeight() * 1.0);

	// Now see if we find a wall to stab
	if (IsNearWall(-FaceDir,,,GetCollisionRadius() * 5.f))
	{
		// If so, stab it!
		AttachToWall(-FaceDir,,TRUE);
		return TRUE;
	}

	return FALSE;
}

simulated function bool PerformSwordAction()
{
	local vector FaceDir;

	if (bIsAttachedToWall)
	{
		// detach using jump instead
//		DetachFromWall();
	}
	else if( Physics == PHYS_Falling && !bJuggled )
	{
		FaceDir = vector(Rotation);

		// check in front of me
		if( !bIsDoingMeleeAttack && IsNearWall(FaceDir,,,GetCollisionRadius() * 5.f) )
		{
			AttachToWall(FaceDir);
			return TRUE;
		}

		// If sliding down - check backwards as well
		if (bSlidingDown && IsNearWall(-FaceDir,,,GetCollisionRadius() * 5.f))
		{
			AttachToWall(-FaceDir);
			return TRUE;
		}
	}
	// otherwise do a melee swing or something
	return FALSE;
}

/** Callbacks from NSM_Grapple to start and stop special effects */
simulated function BeginGrappleEffects( Actor GrappleTarget );
simulated function EndGrappleEffects();

event EncroachedBy(Actor Other)
{
	//`warn( self @ "EncroachedBy" @ `showvar(Other) );
	// if we are a NanoPawnBase or a GameCrowdAgent
	if( ( NanoPawnBase(Other) != None ) || ( GameCrowdAgent(Other) != None ) )
	{
		// do nothing
	}
	// otherwise something from the world encroached on us and we should be gibbed prob
	else
	{
		Super.EncroachedBy(Other);
	}
}

event bool EncroachingOn(Actor Other)
{
	local Pawn P;
	local Vector PushVelocity;

	P = Pawn(Other);
	if ( P == None )
		return FALSE;

	if( (P.Velocity Dot (Location - P.Location)) >= 0.f )
	{
		// push away other pawn
		PushVelocity = Normal(P.Location - Location) * 200;
		PushVelocity.Z = 100;
		P.AddVelocity( PushVelocity, Location, class'NDT_Tackled' );
		return FALSE;
	}

	return FALSE;
}

delegate float RateAttractTarget( NanoInterface_Attraction AttractInterface, vector CamLoc, rotator CamRot );

simulated final function float StandardRateAttractTarget( NanoInterface_Attraction AttractInterface, vector CamLoc, rotator CamRot )
{
	local Actor A;
	local Vector VectToTarget;
	local float Weight, Dist, VelDot, ZDist;
	local float Ratio;

	Weight = -1.f;
	if( AttractInterface != None && AttractInterface.ShouldAttractActor(self) )
	{
		A = AttractInterface.GetAttractionActor();
		ZDist = A.Location.Z - Location.Z;
		if( ZDist < 0.f )
		{
			VectToTarget = A.Location - Location;
			Dist = VSize2D(VectToTarget);
			Ratio = Abs(Dist / ZDist);

			Weight = 1.f - Dist/1024.f;
			VelDot = Normal(VectToTarget) dot Normal(Velocity);
			if( VelDot > 0.1 && Ratio > 0.5f )
			{
				Weight *= VelDot;
			}
			else
			{
				// reject anything behind the view direction
				Weight = -1.f;
			}
		}
	}
	return Weight;
}

simulated final function float PrepLandRateAttractTarget( NanoInterface_Attraction AttractInterface, vector CamLoc, rotator CamRot )
{
	local Actor A;
	local Vector VectToTarget;
	local float Weight, Dist, VelDot, ZDist;

	Weight = -1.f;
	if( AttractInterface != None && AttractInterface.ShouldAttractActor(self) )
	{
		A = AttractInterface.GetAttractionActor();
		ZDist = A.Location.Z - Location.Z;
		if( ZDist < 0.f )
		{
			VectToTarget = A.Location - Location;
			Dist = VSize2D(VectToTarget);

			Weight = 1.f - Dist/384.f;
			VelDot = Normal(VectToTarget) dot Normal(Velocity);
			if( VelDot > 0.1 )
			{
				Weight *= VelDot;
			}
			else
			{
				// reject anything behind the view direction
				Weight = -1.f;
			}
		}
	}
	return Weight;
}


simulated final function Actor FindAttractTarget( optional delegate<RateAttractTarget> RateAttractTarget = StandardRateAttractTarget )
{
	local Actor A, Best;
	local float Weight, BestWeight;
	local vector CamLoc;
	local rotator CamRot;
	local NanoPC PC;
	GetActorEyesViewPoint(CamLoc,CamRot);
	// force the pitch slightly down since we're looking for something to jump on
	CamRot.Pitch = -4096;

	foreach CollidingActors( class'Actor', A, 1024.f,,, class'NanoInterface_Attraction' )
	{
		Weight = RateAttractTarget(NanoInterface_Attraction(A),CamLoc,CamRot);
		if( Weight > 0.f && (Best == None || Weight > BestWeight) )
		{
			Best = A;
			BestWeight = Weight;
			break;
		}
	}

	// if we have a locktarget then test the (weighted) weighting of that actor
	PC = NanoPC(Controller);
	if (PC != None && PC.TargetedActor != None)
	{
		Weight = RateAttractTarget(NanoInterface_Attraction(PC.TargetedActor),CamLoc,CamRot);
		if (Weight > 0.f && (Best == None || (Weight * 2.f) > BestWeight))
		{
			Best = PC.TargetedActor;
		}
	}

	//`loginfo( 'Nano_Locomotion', `location@`showvar(Best));
	return Best;
}

simulated event bool ShouldMagLevitate()
{
	return (Health > 0) && (TargetedAttractionActor == None) && (CurrNanoState == ENS_Dense) && (`TIMESINCE(LastMagLevTime) > 1.f) && !IsAttachedToPerch();
}

simulated event BeginMagLevAttraction( NanoVehicleSpline_MagLev LevitatingSpline )
{
	CurrentMagLevAttractor = LevitatingSpline;

	SetPhysics(PHYS_Flying);
}

simulated event EndMagLevAttraction()
{
	CurrentMagLevAttractor = None;

	SetPhysics(PHYS_Falling);

	LastMagLevTime = WorldInfo.TimeSeconds;
}

simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	if( !IsTargetable() )
	{
		return INDEX_NONE;
	}
	// ignore if same team
	else if (Askee != None && Askee.GetTeamNum() == GetTeamNum())
	{
		return INDEX_NONE;
	}
	else if( InteractionPawn != None && InteractionPawn == AskeePawn )
	{
		return INDEX_NONE;
	}
	else
	{
		// default priority
		//@todo - config property?
		return 10.f;
	}
}

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return (Health > 0 && CurrNanoState == ENS_Normal) || IsInState( 'DBNO' );
}


/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}


simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	if( Health <= 0 )
	{
		return FALSE;
	}

	return TRUE;
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local NanoPawn OtherNP;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	// so if we are moving through a NanoVolume_Dust we will get this touch event
	if( NanoVolume_Dust(Other) != none )
	{
		if( NanoVolume_Dust(Other).MovingThroughSound != none )
		{
			PlayerController(Controller).PlaySound( NanoVolume_Dust(Other).MovingThroughSound );
		}
		FullBodySlot.PlayCustomAnim('NW_Dust_Sprint_Hit',1.f,0.1,0.1f);
	}

	// If we are dusted and are touched by a dashing non-dusted pawn - insta death by dusting
	OtherNP = NanoPawn(Other);
	if((Health > 0) && (OtherNP != None) && (CurrNanoState == ENS_Dust) && OtherNP.bIsDashing && (OtherNP.CurrNanoState != ENS_Dust))
	{
		Died(OtherNP.Controller, class'NanoGame.NDT_Dusted', Location);
	}
}


event UnTouch( Actor Other )
{
	local NanoVolume_ChaosZone ChaosZone;

	Super.UnTouch( Other );

	ChaosZone = NanoVolume_ChaosZone(Other);

	// if we just untouched this zone and the pawn is pointing to us.  We need to check self here as the touch untouch order
	// could be flipped
	if( ( ChaosZone != None ) && ( ChaosZone == GetChaosZone() ) )
	{
		SetChaosZone( none );
	}

	if( NanoPhysicsVolume(Other) != none )
	{
		if( PSC_InVolumeEffect != none )
		{
			PSC_InVolumeEffect.DeactivateSystem();
			PSC_InVolumeEffect = none;
		}

		if( AC_InVolumeSound != none )
		{
			AC_InVolumeSound.FadeOut( 0.500f, 0.0f );
			AC_InVolumeSound = none;
		}
	}
}

event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	local NanoInterface_BoulderedInto BoulderInt;
	local NanoInterface_JuggleCollision JuggleCollisionInterface;
	local NanoWeap_Melee Weap;

	//`log(`location@`showvar(Other)@`showvar(bJuggled)@`showvar(VSize(Velocity))@`showvar(InteractionType)@`showvar(InteractionPawn));

	Super.Bump( Other, OtherComp, HitNormal );

	// Fire event when bouldering into thing
	if( bIsDashing && !Other.bStatic && (CurrNanoState == ENS_Dense) )
	{
		// Call notify function if it implements interface
		BoulderInt = NanoInterface_BoulderedInto(Other);

		//`log( "Boulder!" @ `showvar(other) @ `showvar(BoulderInt) );

		if( BoulderInt != None )
		{
			//`log( "Boulderered into by" @ self );
			BoulderInt.BoulderedIntoBy( self );
			PlayDenseBash();
		}

		// Fire kismet event
		Other.TriggerEventClass(class'SeqEvt_BoulderedInto', self, 0);

		//// DenseBash impact handling

		// so if we are dashing and  have a DenseBash skill and we are bashing into a MetaCorp Infantry
		if( ( NanoPawn_MetaCorp_NanoInfantry(Other) != None ) 
			&& ( NanoPawn_MetaCorp_NanoInfantry(Other).IsDoingSpecialMove( 'NSM_DenseBashedFlyThroughTheAir') == FALSE ) 
			&& ( GetSkill(class'NanoSkill_DenseBash') != None )
			)
		{
			NanoPawn(Other).DenseBash_BashDir = -HitNormal;
			NanoPawn(Other).DoSpecialMove( 'NSM_DenseBashedFlyThroughTheAir', TRUE, self );	
			//DoSpecialMove( 'NSM_DenseBash', TRUE ); // we are no longer stopping when we hit a foe so we no longer do this special move
			PlayDenseBash();
		}
	}
	else if( bJuggled && InteractionPawn != Other && (VSize(Velocity) > 50.f || InteractionType == PAWNINTER_Grab || InteractionType == PAWNINTER_Tackle) )
	{
		// Call notify function if it implements interface
		JuggleCollisionInterface = NanoInterface_JuggleCollision(Other);
		if(JuggleCollisionInterface != none)
		{
			JuggleCollisionInterface.JuggleCollisionWithJuggledActor(self);
		}
	}
	

	// If we have a collision with a vehicle in the spline, pop us off
	if( (CurrentMagLevAttractor != None) && (NanoVehicleAgent(Other) != None) )
	{
		CurrentMagLevAttractor.RemoveActorFromMagLevSpline(self);
		Velocity += Other.Velocity;
	}

	Weap = NanoWeap_Melee(Weapon);
	if( Weap != None && bIsSwordDashing )
	{
		Weap.PossiblyPlayAttackAnim( TRUE );
	}
}


function CheckForDenseBash( float DeltaTime, Vector Dir )
{
	local Vector HitL, HitN;
	local Vector TraceStart, TraceEnd;
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local NanoBustableActor Bustable;

	//@todo - move other dense bashable checks here
	TraceStart	= Location;
	TraceEnd	= TraceStart + Normal(Dir) * 200.f * DeltaTime * CylinderComponent.CollisionRadius;
	HitActor	= Trace( HitL, HitN, TraceEnd, TraceStart, TRUE, vect(1,1,1), HitInfo );

	if( ProcBuilding(HitActor) != None && FracturedStaticMeshComponent(HitInfo.HitComponent) != None )
	{
		ProcBuilding(HitActor).BreakFractureComponent(FracturedStaticMeshComponent(HitInfo.HitComponent),HitL - GetCollisionExtent() * 1.5,HitL + GetCollisionExtent() * 1.5);
		FracturedStaticMeshComponent(HitInfo.HitComponent).SetActorCollision(TRUE,FALSE);
		PlayDenseBash();
	}
	else
	{
		Bustable = NanoBustableActor(HitActor);
	}
	if( Bustable != None )
	{
		if( !Bustable.bBusted )
		{
			Bustable.bBusted = TRUE;
			Bustable.OnBust();
			PlayDenseBash();
		}
	}
}

simulated function PlayDenseBash()
{
	if( !bFlyingBackPose && bIsDashing )
	{
		FullBodySlot.PlayCustomAnim('NW_Dense_Sprint_Hit', 1.0, 0.1, 0.1, FALSE, TRUE);
	}
}


event HitWall( vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	Super.HitWall(HitNormal, Wall, WallComp);

	// If we are holding someone and we hit a wall, it kills them!
	if( InteractionPawn != None && InteractionType == PAWNINTER_Tackle )
	{
		// If tackle victim hit the wall
		if( bAttachedToTackler )
		{
			// Notify our attacker
			InteractionPawn.HitWallWithTackledActor();
		}
		else
		{
			// Otherwise, we are the attacker
			HitWallWithTackledActor();
		}
	}
	else if( NanoBounceMeshBase(Wall) != None )
	{
		NanoBounceMeshBase(Wall).BouncePawn(self, Location, HitNormal);
	}
	else
	// Fire event when bouldering into thing
	if(bIsDashing && !Wall.bStatic && (CurrNanoState == ENS_Dense))
	{
		Wall.TriggerEventClass(class'SeqEvt_BoulderedInto', self, 0);
	}
}

simulated function AddXP( int Amount )
{
	GetPRI().AwardXP( Amount, "AddXP" );
}

simulated function AddCurrency( int Amount )
{
	GetPRI().AwardCurrency( Amount, "AddCurrency" );
}

simulated function OnCurrencyGive( SeqAct_CurrencyGive InAction )
{
	GetPRI().AwardCurrency( InAction.Amount, "AddCurrency" );
}

simulated function OnCurrencyTake( SeqAct_CurrencyTake InAction )
{
	GetPRI().AwardCurrency( -InAction.Amount, "TakeCurrency" );
}

simulated function OnCurrencyHasEnough ( SeqAct_CurrencyHasEnough InAction )
{
	if( GetPRI().AmountOfCurrencyOwned >= InAction.Amount )
	{
		InAction.ActivateOutputLink( 0 ); // Yes, enough currency
	}
	else
	{
		InAction.ActivateOutputLink( 1 ); // No, not enough currency
	}
}


simulated function OnModifyNanoPower( SeqAct_ModifyNanoPower InAction )
{
	local bool bHasEnough;
	local float OrigPowerAmt, PowerAmt;

	OrigPowerAmt = NanoPower;
	PowerAmt = InAction.Amount * NanoPowerBucketSize;

	// Add power
	if( InAction.InputLinks[0].bHasImpulse )
	{
		if( !InAction.bTest )
		{
			AddNanoPower( PowerAmt );
		}
		// Trigger FULL POWER output
		if( OrigPowerAmt + PowerAmt >= MaxNanoPower )
		{
			InAction.ActivateOutputLink( 1 );
		}
		// Fire SUCCESS output
		InAction.ActivateOutputLink( 0 );

	}
	// Consume power
	else if( InAction.InputLinks[1].bHasImpulse )
	{
		bHasEnough = (NumOfNanoPowerBuckets - GetNumEmptyNanoBuckets()) >= InAction.Amount;
		// If has enough or allow partial consumption
		if( bHasEnough || InAction.bAllowPartial )
		{
			// Consume the juice and fire SUCCESS output
			if( !InAction.bTest )
			{
				ConsumeNanoPower( PowerAmt, FALSE,, InAction.bAllowPartial );
			}
			InAction.ActivateOutputLink( 0 );
		}
		else
		{
			// Otherwise, fire NOT ENOUGH output
			InAction.ActivateOutputLink( 3 );
		}

		// If power is drained ... fire EMPTY POWER output
		if( OrigPowerAmt - PowerAmt <= 0 )
		{
			InAction.ActivateOutputLink( 2 );
		}
	}
	// Set recharge rate
	else if( InAction.InputLinks[2].bHasImpulse )
	{
		NanoRecoveryRate = InAction.RecoveryRate;
		InAction.ActivateOutputLink( 0 );
	}
	// Default recovery rate
	else if( InAction.InputLinks[3].bHasImpulse )
	{
		NanoRecoveryRate = default.NanoRecoveryRate;
		InAction.ActivateOutputLink( 0 );
	}
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
	// End the special move, if any
 	if( IsDoingSpecialMove('NSM_PerchOnPoint') )
 	{
 		LocalEndSpecialMove('NSM_PerchOnPoint');
 	}

	Super.OnTeleport(Action);

	// Turn off skydiving effects
	bIsSkydiving = FALSE;
	NotifySkydiveCamDeactivated();
}

simulated function OnSetTeleportAnchorPoint( SeqAct_SetTeleportAnchorPoint InAction )
{
	NanoPlayerInput(NanoPC(Controller).PlayerInput).SetTestingTeleportBackToAnchorPoint();
}

simulated function OnSetHotZoneLocation( SeqAct_SetHotZoneLocation InAction )
{
	NanoGRI(WorldInfo.GRI).NPES.UpdateHotZoneLocation();
}

/** Give out the reward **/
simulated function OnBloodyLyrikHands( SeqAct_BloodyLyrikHands InAction )
{
	BloodyLyrikHands( InAction.bShouldBloodyHands );
}

/** Gore function stubs */
function RemoveSomeBlood( float DeltaTime );
function AddSomeBlood();
function SetFullBlood();
function BloodyLyrikHands( bool bShouldBloodyHands );


/** Give out the reward **/
simulated function OnGiveReward( SeqAct_GiveReward InAction )
{
	NanoGRI(WorldInfo.GRI).GiveReward( InAction.Reward, self );
}


/** Get the skill level in NanoSkill **/
simulated function OnGetNanoSkillLevel( SeqAct_GetNanoSkillLevel InAction )
{
	local NanoSkill NSK;
	local SeqVar_Int IntVar;

	NSK = GetSkill( InAction.Skill );

	if( NSK != none )
	{
		// set the new value for all linked targets
		foreach InAction.LinkedVariables( class'SeqVar_Int', IntVar, "SkillLevel" )
		{
			IntVar.IntValue = NSK.SkillLevel + 1; // skills are indexed by zero but UI shows 1-4 so we want to match that
		}
	}
}


/** Modify passed in NanoSkill **/
simulated function OnModifyNanoSkill( SeqAct_ModifyNanoSkill InAction )
{
	local NanoSkill SkillToModify;

	SkillToModify = GetSkill( InAction.NanoSkillToModify );

	if( SkillToModify != none )
	{
		if( InAction.bUpgradeCurrentSkill )
		{
			SkillToModify.SetSkillLevel( TRUE, SkillToModify.SkillLevel+1 );
		}
		else
		{
			SkillToModify.SetSkillLevel( TRUE, InAction.SkillLevel-1 );
		}
	}
}


/**
* Spawn tracer effect for instant hit shots.
* Network: All Clients
*
* @param HitLocation	Location instant trace did hit
& @param HitDistance	Distance to the hit location
*/

simulated function SpawnTracerEffect( ParticleSystem PSToSpawn, vector HitLocation )
{
	local ParticleSystem	TracerFX;
	local vector			SpawnLoc;
	local Rotator			SocketRot;
	local ParticleSystemComponent SpawnedTracerEmitter;

	Mesh.GetSocketWorldLocationAndRotation( LeftHandSocketName, SpawnLoc, SocketRot );

	// NOTE we want the tracers to ALWAYS be relevant as there are lots of cases where people are shooting things far far away
	// and maybe have been hidden somewhere for more than 2 seconds.
	// and in MP seeing tracers from some hidden spot is vital
	// and in SP the AI often hides behind you so you can get into the case where they are shooting but you see not tracers

	TracerFX = PSToSpawn;
	if( TracerFX != None )
	{
		SpawnedTracerEmitter = WorldInfo.MyEmitterPool.SpawnEmitter( TracerFX, SpawnLoc, Rotation );
		SpawnedTracerEmitter.SetVectorParameter( 'SnipeEnd', HitLocation );
		//`log("***"@self@"spawned tracer"@TracerFX@SpawnLoc@HitLocation);
	}
}


/** Return location of objective, used by radar */
simulated function vector GetObjectiveLocation()
{
	return Location;
}

/** When this NanoPawn is targetted, which location should we focus on */
simulated event vector GetTargetedLocation()
{
	local vector TargetedLocation;

	TargetedLocation = Location;

	// When crouching, aim down a bit to still hit player
	if(PerchingMode != ENPM_None)
	{
		TargetedLocation.Z -= (0.5 * CylinderComponent.CollisionHeight);
	}
	// Otherwise, aim up so we are not aiming at crotch
	else
	{
		TargetedLocation += vect(0,0,24);
	}

	return TargetedLocation;
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum )
{
	Out_FiringTargetableDatum.bIsDashing = bIsDashing;
	Out_FiringTargetableDatum.LastDashStartTime = LastDashStartTime;

	Out_FiringTargetableDatum.bIsTeslaShockStunned = NumberOfTeslaShockHitsActive >= NumTeslaShockHitsForStunAnimation;
}

simulated event BoxSphereBounds GetTargetableBounds()
{
	return Mesh.Bounds;
}


simulated native function vector GetTargetLocation(optional actor RequestedBy, optional bool bRequestAlternateLoc) const;


simulated function PossiblyDoBodyMovementSounds()
{
	// play the walking body movement sound not all the time
	if( PlayerController(Controller) != None && FRand() > 0.60 )
	{
		PlayerController(Controller).PlaySound( BodyMovementWalkCue );
	}
}


protected simulated delegate DecalTrace_StraightBack( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector RotX, RotY, RotZ;
	local vector StartLocation;

	GetAxes(Rotation, RotX, RotY, RotZ);

	//`log( "DecalTrace_StraightBack" );

	StartLocation = Location;
	out_TraceStart = StartLocation;
	out_TraceStart.Z = StartLocation.Z + 50.0f;

	out_TraceDest = out_TraceStart - (512.0f * (RotX * +1.0f));
	out_TraceDest.Z = out_TraceStart.Z;

	//DrawDebugLine(out_TraceStart,out_TraceDest,255,0,0,TRUE);
}

/** Called from sword when it hits someone, to build up combo points. */
simulated function RegisterSwordHit(int ComboStage)
{
	// gain some points - more if this is part of a combo
	if(ComboStage > 0)
	{
		ComboPoints += (ComboPointsPerHit * ComboPointComboBonus);
	}
	else
	{
		ComboPoints += ComboPointsPerHit;
	}
	// Cap at 100
	ComboPoints = Min(ComboPoints, 100.0);

	// note the time - delays decay
	ComboLastGainTime = WorldInfo.TimeSeconds;
}

/** Cause civilians to run away from this spot */
simulated function CauseCrowdPanic();
/** Stop crowd from running away */
simulated function ClearCrowdPanic();



simulated function bool InRangeForSwordAttack( const out Actor InVictim )
{
	return InVictim != None && VSize2D(InVictim.Location - Location) < 256.f;
}



simulated function DoMeleeAttack()
{
	StartMeleeAttack();
}


/**
*	This will attempt a melee attack
*
*	MeleeAttacks are determined by the weapon the pawn is holding.	So a pistol maybe
* gives you a pistol whip melee attack, the AssaultRifle gives you a chainsaw melee attack.
*
* To have a melee attack work you need to be:
*
*	-in range of your target
*	-be targeting your target
*	-not have done a melee attack in the last MeleeAttackCoolDownInSeconds
*
* If you are able to do a melee attack you will do RandRange( MeleeAttackDamageMin, MeleeAttackDamageMax )
* for the specific weapon's melee attack.
*/
simulated function StartMeleeAttack()
{
	StartFire(2);

	// Set this flag indicating our desire to do a melee attack.
	// Code in Tick() will check to see if we can actually start it.
	//bWantsToMelee = TRUE;
}


simulated function StopMeleeAttack(optional bool bForcedByDamage)
{
// 	bWantsToMelee = FALSE;
// 	bPendingMeleeAttack = FALSE;
//
// 	if( bForcedByDamage )
// 	{
// 		// if melee was stopped because we took damage,
// 		// remember when it hapened to add a delay
// 		LastTookDamageTime = WorldInfo.TimeSeconds;
// 		MyGearWeapon.StopFire(class'GearWeapon'.const.MELEE_ATTACK_FIREMODE);
// 	}
}


/**
 * The dash skill is no longer active by the time the effects should be turned off so the pawn gets this called via SetTimer
 *
 * NOTE: If they are bShowInGame they are still evaluated and will take up GPU time even if their effects are not seen
 **/
simulated function TurnOffDashPostProcessEffects()
{
	//`log( "TurnOffDashPostProcessEffects" );
	if( SpeedPPEffect != None )
	{
		SpeedPPEffect.bShowInGame = FALSE;
	}

	if( ScreenPPEffect != None )
	{
		//ScreenPPEffect.bShowInGame = FALSE;
	}
}


function bool ActivateSelfNanoPower( class<NanoSkill_NanoPowerBase> NanoPowerClass )
{
	local NanoSkill_Ghost GhostSkill;
	local NanoSkill_Dense DenseSkill;

	GhostSkill = GetActiveSkill( class'NanoSkill_Ghost' );
	DenseSkill = GetActiveSkill( class'NanoSkill_Dense' );

	//`log( "ToggleSelfNanoPower" @ `showvar(CurrNanoState) @ `showvar(NanoPowerClass)  @ IsNanoPowerLocked() );


	if( ( class'NanoSkill_Ghost' == NanoPowerClass ) )
	{
		// check to see if we are densing
		if( ( DenseSkill != none ) && ( DenseSkill.bActive == TRUE ) )
		{
			//`log( "  force deactivating dense" );
			DeactivateSkill(class'NanoSkill_Dense'); // deactivate as we can't be both ghosted and densed
		}

		// turn on ghosting
		return class'NanoSkill_Ghost'.static.AttemptToActivate(self);
	}


	if( ( class'NanoSkill_Dense' == NanoPowerClass ) )
	{
		// check to see if we are ghosting
		if( ( GhostSkill != none ) && ( GhostSkill.bActive == TRUE ) )
		{
			//`log( "  force deactivating dense" );
			DeactivateSkill(class'NanoSkill_Ghost'); // deactivate as we can't be both ghosted and densed
		}

		// turn on densing
		return class'NanoSkill_Dense'.static.AttemptToActivate(self);
	}


	return TRUE;
}


function DeactivateSelfNanoPower( class<NanoSkill_NanoPowerBase> NanoPowerClass )
{
	// deactivate
	DeactivateSkill(NanoPowerClass);
}


/** Look around and pick best object to interact with - returns NULL if nothing to interact with */
function array<NanoInterface_Interact> GetBestInteractObject( ENanoInteractType Type, bool bOneObjectOnly )
{
	local array<NanoInterface_Interact> Retval;
	local Actor InteractActor;
	local NanoInterface_Interact TestInt;

	// Look for something to interact with
	// @todo: Pick closest, rather than first
	foreach CollidingActors( class'Actor', InteractActor, 1024.0f, Location, TRUE, class'NanoInterface_Interact' )
	{
		TestInt = NanoInterface_Interact(InteractActor);
		//`log( `showvar(TestInt) @ `showvar( NanoPC(Controller).IsAimingAt( InteractActor, 0.10f) ) @ `showvar(TestInt.CanInteract(self, Type)) );
		if( ( NanoPC(Controller).IsAimingAt( InteractActor, 0.10f) == TRUE ) && TestInt.CanInteract(self, Type) )
		{
			Retval.AddItem( TestInt );
			if( bOneObjectOnly == TRUE )
			{
				break;
			}
		}
	}

	return Retval;
}

state UsingSuitcase
{
	function BeginState(Name PrevStateName)
	{
		FullBodySlot.PlayCustomAnim('L_Deploy',1.f,0.1,-1.f,FALSE,TRUE);
	}

	function EndState(Name NextStateName)
	{
		FullBodySlot.StopCustomAnim(1.f);
	}
}

// Called when the player holds the cancel briefing button
function CancelMissionBriefing();

event bool IsPawnIdleInBriefing()
{
	return FALSE;
}

// State for when a pawn is near a mission giver
state NearMissionBriefing
{
	simulated event BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		// Force the pawn to put away their current weapon, so we can't attack
		HolsterCurrentWeapon();

		// Force the pawn to walk when in range
		bForceWalkingSpeed = TRUE;
	}

	simulated event EndState(Name NextStateName)
	{
		local NanoPC NPC;

		Super.EndState(NextStateName);

		NPC = NanoPC(Controller);
		if( NPC != None )
		{
			// Reset the player look at cam, so we're not stuck following the mission briefer with our heads
			NPC.SetBriefingCameraLookAt(None);
		}

		// If we're still tracking the quest giver, shut off the IK control for the head (can happen on teleport)
		if( NanoPawn_Rebels_QuestGiverBase(HeadLookAtActor) != None )
		{
			HeadLookAtActor = None;
			HeadLookAtBoneName = '';

			HeadTrackSkelControl.SetSkelControlActive(FALSE);
		}

		bForceWalkingSpeed = FALSE;
	}

	simulated function Tick(float DeltaTime)
	{
		local NanoPC NPC;
		local bool bWasHeadTrackingEnabled;
		local vector ToMissionBriefer;

		Super.Tick( DeltaTime );

		if( CurrentMissionBriefer != None )
		{
			NPC = NanoPC(Controller);

			ToMissionBriefer = CurrentMissionBriefer.Location - Location;

			// Check the distance to the mission briefing pawn
			if( VSizeSq2D(ToMissionBriefer) <= Square(CurrentMissionBriefer.PawnDisarmRadius) )
			{
				// Do not override a lookat set by the mission briefing kismet actions
				if( !NPC.bCameraLookAtIsFromKismet )
				{
					// Handle head tracking of the mission giver for the pawn
					if( HeadTrackSkelControl != None )
					{
						bWasHeadTrackingEnabled = (HeadLookAtActor != None);

						// If we're within radius, check to see if we're in front of the pawn (120deg), and enable head tracking if so
						if( Normal(ToMissionBriefer) dot vector(Rotation) >= 0.5f )
						{
							HeadLookAtActor = CurrentMissionBriefer;
						}
						else
						{
							HeadLookAtActor = None;
						}

						// If there has been a change, activate or deactivate the headlook skel controls
						if( !bWasHeadTrackingEnabled && (HeadLookAtActor != None) )
						{
							HeadLookAtBoneName = 'b_MF_Head';//(CurrentMissionBriefer.HeadBoneNames.Length ? CurrentMissionBriefer.HeadBoneNames[0] : '');
							HeadTrackSkelControl.DesiredTargetLocation = GetHeadLookTargetLocation();
							HeadTrackSkelControl.TargetLocation = HeadTrackSkelControl.DesiredTargetLocation;
							HeadTrackSkelControl.SetSkelControlActive(TRUE);
						}
						else if( bWasHeadTrackingEnabled && (HeadLookAtActor == None) )
						{
							HeadTrackSkelControl.SetSkelControlActive(FALSE);
						}
					}
				}
			}
			else
			{
				CurrentMissionBriefer.PawnLeftBriefing();
			}
		}
	}
};

// State for when a pawn is in a mission briefing
state MissionBriefing extends NearMissionBriefing
{
	simulated event BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		// Reset the idle counter
		BriefingPawnIdleTime = 0.f;
	}

	function CancelMissionBriefing()
	{
		// Tell the mission briefer that we've cancelled the briefing
		if( CurrentMissionBriefer != None )
		{
			CurrentMissionBriefer.NotifyCancelBriefing();
		}
	}

	event bool IsPawnIdleInBriefing()
	{
		// Never trigger idle if the pawn is being reset
		if( CurrentMissionBriefer != None && CurrentMissionBriefer.IsResettingPlayer() )
		{
			return FALSE;
		}

		return BriefingPawnIdleTime >= BriefingPawnIdleThreshold;
	}

	simulated function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		// Perform a check to see if the pawn has moved since the last tick
		if( IsZero(Velocity) )
		{
			BriefingPawnIdleTime += DeltaTime;
		}
		else
		{
			BriefingPawnIdleTime = 0.f;
		}
	}
};

function ToggleJumpHoldTime(bool bHoldingJump)
{
	if (bHoldingJump)
	{
		PreAimFullBodySlot.PlayCustomAnim('NW_Super_Jump_Charge',0.5f,0.1f,-1.f,FALSE,TRUE);
	}
	else
	{
		PreAimFullBodySlot.StopCustomAnim(0.1f);
	}
}


/** Update any Tornado vars  **/
function UpdateNaniteTornado()
{
	local NanoPC NPC;
	local NanoPawn TargetNP;
	local vector SpawnLocation;

	NPC = NanoPC(Controller);

	//DrawDebugCoordinateSystem( Location, rot(0,0,0), 5.0f, TRUE );
	NaniteTornadoCount++;
	if( NaniteTornadoTargets.Find( NPC.TargetedActor ) == INDEX_NONE )
	{
		NaniteTornadoTargets.AddItem( NPC.TargetedActor );
	}

	if( NaniteTornadoCount >= 4 )
	{
		SpawnLocation = NPC.TargetedActor.Location - (vect(0,0,1) * 88.0f);
		//WorldInfo.MyEmitterPool.SpawnEmitter( NaniteTornadoReadyEffect, SpawnLocation, rot(0,0,0) );

		TargetNP = NanoPawn(NPC.TargetedActor);
		if( ( TargetNP != none ) && ( TargetNP.NaniteTornadoFunnel == none ) )
		{
			TargetNP.NaniteTornadoFunnel = spawn( class'NaniteTornado',,,SpawnLocation );
			TargetNP.NaniteTornadoFunnel.StartMiniTornado( TargetNP, Controller );
		}
	}

	SetTimer( NaniteTornadoCreationPointDuration, FALSE, nameof(ResetNaniteTornadoCount) );
}


/**
 * This will rest all of the transient vars for an instance of a tornado.  We use an optional bool here so the SetTimer method will
 * turn off the tornado but still allow use re use this code but keep the tornados alive (i.e. when we manually trigger them).
 **/
function ResetNaniteTornadoCount( optional bool bShouldKeepTornadoAlive )
{
	local Actor TornadoTarget;
	local NanoPawn TargetNP;

	ClearTimer( nameof(ResetNaniteTornadoCount) );
	NaniteTornadoCount = 0;

	if( bShouldKeepTornadoAlive == FALSE )
	{
		foreach NaniteTornadoTargets( TornadoTarget )
		{
			TargetNP = NanoPawn(TornadoTarget);
		    if( ( TargetNP != none ) && ( TargetNP.NaniteTornadoFunnel != none ) )
			{
				TargetNP.NaniteTornadoFunnel.ShutDownTornado();
				TargetNP.NaniteTornadoFunnel = none;
			}
		}
	}


	NaniteTornadoTargets.Length = 0;
}


/** We need this function as we want to kill the pawn when he is high up in the air **/
function KillPawnDueToNaniteTornado()
{
	if( PSC_NaniteTornadoEjectTrail != none )
	{
		PSC_NaniteTornadoEjectTrail.DeactivateSystem();
		PSC_NaniteTornadoEjectTrail = none;
	}

	TakeDamage( DefaultHealth, NaniteTornadoInstigator, vect(0,0,0), vect(0,0,0), class'NDT_NaniteTornado' );
}

function DeployTesla();
function ThrowTesla();


/** Interface function to allow pawns to surf the cradle tendrils **/
simulated function bool CradleSurfingFilterButtonInput( Name ButtonName, bool bPressed, int ButtonIdx )
{
	return FALSE;
}

/** Interface function to allow pawns to scan the city for audio signals **/
simulated function bool CityScanningFilterButtonInput( Name ButtonName, bool bPressed, int ButtonIdx )
{
	return FALSE;
}

function TestSummonEffects( class<NanoWeaponBase> InPendingWeaponClass )
{
	local ParticleSystemComponent SummonFXComp;
	local float RateScale;

	RateScale = 1.0f;

	// create summon fx
	if (InPendingWeaponClass.default.SummonEffect != None)
	{
		SummonFXComp = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( InPendingWeaponClass.default.SummonEffect, Mesh, InPendingWeaponClass.default.SummonEffectSocketName, TRUE );
		SummonFXComp.CustomTimeDilation = RateScale;
	}

	// play summon anim
	if (InPendingWeaponClass.default.SummonAnimName != 'None')
	{
		PreAimFullBodySlot.PlayCustomAnim( InPendingWeaponClass.default.SummonAnimName, 1.f*RateScale, 0.1, 0.25, FALSE, TRUE );
	}

	// play summon cue
	if (InPendingWeaponClass.default.SummonCue != None)
	{
		PlaySound(InPendingWeaponClass.default.SummonCue);
	}

}

simulated function OnForceWalkingSpeed(SeqAct_ForceWalkingSpeed Action)
{
	bForceWalkingSpeed = Action.bForceWalkingSpeed;
}

function OnPlayAnim(SeqAct_PlayAnim Action)
{
	local AnimSet CustomAnimSet;
	local float AnimTime;
	if (Action.InputLinks[0].bHasImpulse)
	{
		foreach Action.CustomAnimSets(CustomAnimSet)
		{
			// Only add the anim set if it is isn't already loaded
			if( Mesh.AnimSets.Find(CustomAnimSet) == INDEX_NONE )
			{
				Kismet_ActiveCustomAnimSets.AddItem(CustomAnimSet);
				Mesh.AnimSets.AddItem(CustomAnimSet);
			}
		}
		`log(`location@`showvar(Action.AnimName));
		if (Action.bUpperBodyOnly)
		{
			AnimTime = TopHalfSlot.PlayCustomAnim(Action.AnimName,Action.Rate,Action.BlendInTime,Action.BlendOutTime,Action.bLooping,TRUE);
		}
		else
		{
			AnimTime = FullBodySlot.PlayCustomAnim(Action.AnimName,Action.Rate,Action.BlendInTime,Action.BlendOutTime,Action.bLooping,TRUE);
		}
		SetTimer(AnimTime,FALSE,'OnAnimEnd',Action);
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		if (Action.bUpperBodyOnly)
		{
			TopHalfSlot.StopCustomAnim(Action.BlendOutTime);
		}
		else
		{
			FullBodySlot.StopCustomAnim(Action.BlendOutTime);
		}
		foreach Kismet_ActiveCustomAnimSets(CustomAnimSet)
		{
			Mesh.AnimSets.RemoveItem(CustomAnimSet);
		}
		Action.bAborted = TRUE;
	}
}

// Helper function to play an animation for things like mission briefings, etc
event PlayBodyAnim(name AnimToPlay, optional bool bUpperBodyOnly)
{
	if( bUpperBodyOnly )
	{
		TopHalfSlot.PlayCustomAnim(AnimToPlay, 1.f, 0.1f, 0.1f, TRUE, TRUE);
	}
	else
	{
		FullBodySlot.PlayCustomAnim(AnimToPlay, 1.f, 0.1f, 0.1f, TRUE, TRUE);
	}
}

function bool LookForLadderToClimb()
{
	local vector Start, End, HitL, HitN;
	local Actor HitA;
	local TraceHitInfo HitInfo;

	if( CurrentLadder == None && Physics == PHYS_Walking )
	{
		//`log(`location);
		Start = Location + vect(0,0,1) * (CylinderComponent.CollisionHeight / 2.0f);
		End = Start + vector(Rotation) * 256.f;
		HitA = Trace(HitL,HitN,End,Start,TRUE,vect(64,64,256),HitInfo);
		
		//DrawDebugLine( Start, End, 0, 0, 255, TRUE );

		//`log("-"@`showvar(HitA));

		if( NanoLadderBase(HitA) != None )
		{
			//`log( "starting ladder climb" );
			StartLadderClimb(NanoLadderBase(HitA),Location.Z < HitA.Location.Z);
			return TRUE;
		}
	}
	
	return FALSE;
}

function AbortLadderClimb()
{
	if (CurrentLadder != None)
	{
		if (NanoPC(Controller) != None)
		{
			NanoPC(Controller).SetPreciseDestination(vect(0,0,0));
		}
		ClearTimer(nameof(LadderClimbLoop));
		ClearTimer(nameof(EndLadderClimb));
		GetOffLadder();
	}
}

function StartLadderClimb(NanoLadderBase LadderToClimb, bool bClimbUp)
{
	local vector ClimbPosition;

	ClimbPosition = LadderToClimb.Location + vector(LadderToClimb.Rotation) * (bClimbUp ? 64.f : -64.f);
	ClimbPosition.Z = Location.Z;
	CurrentLadder = LadderToClimb;
	bClimbingUp = bClimbUp;

	if (NanoPC(Controller) != None)
	{
		if (!bEmptyHanded)
		{
			HolsterCurrentWeapon();
		}

		//`log( `showvar(ClimbPosition) );
		//DrawDebugCoordinateSystem( ClimbPosition, rot(0,0,0), 10.f, TRUE);
		NanoPC(Controller).SetPreciseDestination(ClimbPosition,self.LadderClimbMount);
	}
	else
	{
		LadderClimbMount();
	}
}

function LadderClimbMount()
{
	local float AnimTime;
	local Name AnimName;

	`log(`location@`showvar(CurrentLadder)@`showvar(CurrentLadder.DistToClimb)@`showvar(bClimbingUp));
	bCollideWorld = FALSE;
	bIgnoreForces = TRUE;
	SetCollision(TRUE,FALSE,FALSE);
	SetPhysics(PHYS_None);
	DistanceClimbed = 0.f;

	if (bClimbingUp)
	{
		SetRotation(CurrentLadder.Rotation + rot(0,32768,0));
		AnimName = 'Ladder_Up_A_Mount';
	}
	else
	{
		SetLocation(CurrentLadder.Location + vector(CurrentLadder.Rotation) * -GetCollisionRadius() + vect(0,0,1) * GetCollisionHeight());
		SetRotation(CurrentLadder.Rotation);
		AnimName = 'Ladder_Down_A_Mount';
	}

	AnimTime = FullBodySlot.PlayCustomAnim( AnimName, 1.f, 0.1, -1.f, FALSE, TRUE );
	FullBodySlot.SetRootBoneAxisOption(RBA_Translate, RBA_Translate, RBA_Translate);
	Mesh.RootMotionMode = RMM_Translate;
	SetTimer(AnimTime,FALSE,nameof(LadderClimbLoop));
	//`log( GetFuncName() @ `showvar(Mesh.RootMotionMode) );

}

function LadderClimbLoop()
{
	local float DismountDistance;
	local float AnimTime;
	local Name AnimName;
	//`log(`location@`showvar(DistanceClimbed)@`showvar(CurrentLadder.DistToClimb - DistanceClimbed));

	if( bClimbingUp == TRUE)
	{
		DismountDistance = 128.0f;
	}
	// we are having issues with AIs dismounting and falling through the world.
	// so dismount earlier
	else
	{
		DismountDistance = 256.0f;
	}


	// check to keep climbing or not
	if (CurrentLadder.DistToClimb - DistanceClimbed > DismountDistance)
	{
		if (bClimbingUp)
		{
			AnimName = 'Ladder_Up_A_Loop';
		}
		else
		{
			AnimName = 'Ladder_Down_A_Loop';
		}
		AnimTime = FullBodySlot.PlayCustomAnim( AnimName, 1.75f, 0.f, -1.f, FALSE, TRUE );
		SetTimer(AnimTime,FALSE,nameof(LadderClimbLoop));
	}
	// dismount
	else
	{
		if (bClimbingUp)
		{
			AnimName = 'Ladder_Up_A_Dismount';
		}
		else
		{
			AnimName = 'Ladder_Down_A_Dismount';
		}
		AnimTime = FullBodySlot.PlayCustomAnim( AnimName, 1.f, 0.0, -1.f, FALSE, TRUE );
		SetTimer(AnimTime,FALSE,nameof(EndLadderClimb));
	}

	DistanceClimbed += 128.f;
}


function GetOffLadder()
{
	Mesh.RootMotionMode = RMM_Ignore;
	FullBodySlot.SetRootBoneAxisOption(RBA_Discard,RBA_Discard,RBA_Discard);
	FullBodySlot.StopCustomAnim(0.1f);
	bCollideWorld = TRUE;
	bIgnoreForces = FALSE;
	SetCollision(TRUE,TRUE,FALSE);

	if (CurrentLadder.CurrentClimber == self)
	{
		CurrentLadder.CurrentClimber = None;
	}
	CurrentLadder = None;
	//SetPhysics(PHYS_Falling);
	SetPhysics(PHYS_Walking);
}


function EndLadderClimb()
{
	local vector Extent, HitL;

	Extent.X = GetCollisionRadius();
	Extent.Y = Extent.X;
	Extent.Z = GetCollisionHeight();
	
	//`log(`location);

	// we want to find a box that is near the Queue location
	if( bClimbingUp == TRUE )
	{
		HitL = CurrentLadder.TopQueueLocation; 
	}
	else
	{
		HitL = CurrentLadder.BottomQueueLocation;
	}

	GetOffLadder();


	if( FindSpot( Extent, HitL ) == TRUE )
	{
		//`log( GetFuncName() @ `showvar(HitL) );
	    //DrawDebugCoordinateSystem( HitL, rot(0,0,0), 10.0f, TRUE );
		if( Location != HitL )
		{
			SetLocation(HitL);
		}
	}
	else
	{
		`warn( "FindSpot did not find a place to put us after we get off the ladder" );
	}
}

simulated function FinishedHitReaction( optional float BlendOutTime = 0.25f );

function TurnOnDualSpineConstraints();



simulated function SpawnBloodPool()
{
	if(( bSpawnBloodTrailDecals ) && ( bDidGoreEffectDeath == FALSE ) )
	{
		NanoPawnFX.SpawnABloodTrail_BloodPool();
	}

	// semi hack
	// since we know we are "still enough" to spawn a blood pool go ahead and possibly spawn an orb
	SpawnAnOrb();
}

function SpawnAnOrb();


delegate ActivateSpark();

function PlayDeathScreamSound();

/** Events to turn on and off the Fan Flying Wind sounds**/
event PlayNanoFanFlyingWindSound();
event StopNanoFanFlyingWindSound();

/**
 * Boids:  Pawn is playing fullbodyslot anim and wants to move more than StopCustomAnimDelta
 * Extra logic can be addded here to choose when to actually stop the custom anim
**/
event StopFullBodyAnimationDueToBoidsWantingToMove()
{
	FullBodySlot.StopCustomAnim( 0.250f );
}

function SetElevatorEjectionTarget(Actor NVA, float Duration)
{
	if( NVA != None && Duration > 0.f )
	{
		ElevatorEjectionTarget = NVA;
		SetTimer(Duration, FALSE, nameof(ClearElevatorEjectionTarget));
	}
}

function bool IsElevatorEjectionTarget()
{
	return (ElevatorEjectionTarget != None);
}

function ClearElevatorEjectionTarget()
{
	ElevatorEjectionTarget = None;
}

native function float GetMaxSpeed();

native function ExtractRootMotionCurve( Name AnimName, float SampleRate, out RootMotionCurve out_InterpCurve, optional bool bDrawResults );

native function SetAimOffsetProfileByName( Name ProfileName );
native function SetAimOffsetProfileByIndex( int Idx );


/** 
 * Check the various timers to see if we are allowed to Evade.
 * 
 * NOTE: might want to add some logic here to check around us and make certain there is enough room
 * to do the evade roll.
 **/
final function bool ShouldIEvadeThisAttack()
{
	local NanoAIBlackboard Blackboard;

	Blackboard = NanoGRI(WorldInfo.GRI).AIBlackBoard;

	if( IsDoingSpecialMove( 'NSM_Melee_HitReaction' ) == TRUE )
	{
		return FALSE;
	}

	//if stunned do not evade
	if( NanoAI(Controller).FindCommandOfClass( class'NanoAICmd_Stunned' ) != None )
	{
		return FALSE;
	}

	//`log( `showvar(`TimeSince(Blackboard.LastEvadeTime)) @ `showvar(Blackboard.TimeBetweenEvades) );
	// check global evade times
	if( `TimeSince(Blackboard.LastEvadeTime) < Blackboard.TimeBetweenEvades )
	{
		return FALSE;
	}

	//`log( `showvar(NextEvadeTime) @ `showvar(WorldInfo.TimeSeconds) );
	// check pawn evade times
	if( NextEvadeTime > WorldInfo.TimeSeconds )
	{
		return FALSE;
	}

	if( Weapon != None && Weapon.IsFiring() == TRUE )
	{
		return FALSE;
	}

	return TRUE;
}


/** 
 * This will do the Evade.  Bt picking from the set of evades we have.
 *
 **/
function DoTheEvade()
{
	// update timers
	NanoGRI(WorldInfo.GRI).AIBlackBoard.LastEvadeTime = WorldInfo.TimeSeconds;
	NextEvadeTime =  WorldInfo.TimeSeconds + RandRange( TimeBetweenEvadesRange.X, TimeBetweenEvadesRange.Y );

	//// so we have two evades to choose from

	if( FRand() > 0.5f )
	{
		// Jump Back
		DoTheEvade_JumpBack();
	}
	else
	{
		// Dive roll evade
		DoTheEvade_DiveRoll();
	}

}


/** 
 * This will do the Evade.  Just jump straight back!
 *
 * TODO: prob check to see if we can jump straight back hah!
 **/
private function DoTheEvade_JumpBack()
{
	local vector StickDir;
	local Rotator CamRot;
	local Vector CamLoc;
	local Rotator Rot;

	GetActorEyesViewPoint(CamLoc,CamRot);

	StickDir.X = 0.0f;
	StickDir.Y = -1.0f; // go straight back based on where the trooper is facing

	StickDir = StickDir >> CamRot;

	//`log( `showvar(StickDir) );

	Rot.Yaw = Rotator(StickDir).Yaw;
	SetRotation( Rot );
	SetDesiredRotation( Rot );


	DoSpecialMove( 'NSM_Evade_Jump_Back', TRUE );

}


/** 
 * This will do the Evade.  Basically, just pick a random evade dir and evade that way.
 * Looks pretty sweet to not even try any logic on which way to evade.  
 *
 **/
private function DoTheEvade_DiveRoll()
{
	local vector StickDir;
	local Rotator CamRot;
	local Vector CamLoc;
	local Rotator Rot;

	// do the actual dodge
	GetActorEyesViewPoint(CamLoc,CamRot);

	StickDir.X = Frand() * 2.0f;
	StickDir.X -= 1.0f;
	StickDir.Y = Frand() * 2.0f;
	StickDir.Y -= 1.0f;

	StickDir = StickDir >> CamRot;

	//`log( `showvar(StickDir) );

	Rot.Yaw = Rotator(StickDir).Yaw;
	SetRotation( Rot );
	SetDesiredRotation( Rot );

	// so here we are raise our combat effector
	NanoAI(Controller).CombatResponse[ERT_Attack] += class'NanoCombatEffectors'.const.DOIT_CHANCE;

	//NanoGRI(WorldInfo.GRI).AIBlackboard.HandleCombatEvent( NCAT_AI_Evaded_With_DiveRoll, NanoAIBase(Controller) );

	DoSpecialMove( 'NSM_Evade_Fwd', TRUE );
}



/** 
 * Check the various timers to see if we are allowed to turtle.
 * 
 **/
final function bool ShouldITurtleThisAttack()
{
	local NanoAIBlackboard Blackboard;

	Blackboard = NanoGRI(WorldInfo.GRI).AIBlackBoard;

	// if we are already doing the turtle move then keep with it
	if( IsDoingSpecialMove( 'NSM_Melee_Turtle' ) == TRUE )
	{
		return TRUE;
	}

	// if you have a shield you always turtle!!
	if( bHasShield == TRUE )
	{
		return TRUE;
	}

	if( IsDoingSpecialMove( 'NSM_Melee_HitReaction' ) == TRUE )
	{
		return FALSE;
	}

	if( IsDoingSpecialMove( 'NSM_Melee_DropTheHammer_Victim' ) == TRUE )
	{
		return FALSE;
	}

	//if stunned do not turtle
	 if( NanoAI(Controller).FindCommandOfClass( class'NanoAICmd_Stunned' ) != None )
	 {
		 return FALSE;
	 }


	//`log( `showvar(`TimeSince(Blackboard.LastTurtleTime)) @ `showvar(Blackboard.TimeBetweenTurtles) );
	// check global turtle times
	if( `TimeSince(Blackboard.LastTurtleTime) < Blackboard.TimeBetweenTurtles )
	{
		return FALSE;
	}

	//`log( `showvar(NextTurtleTime) @ `showvar(WorldInfo.TimeSeconds) );
	// check pawn turtle times
	if( NextTurtleTime > WorldInfo.TimeSeconds )
	{
		return FALSE;
	}

	if( Weapon != None && Weapon.IsFiring() == TRUE )
	{
		return FALSE;
	}


	return TRUE;
}


/** 
 * This will do the Evade.  Bt picking from the set of evades we have.
 *
 **/
function DoTheTurtle()
{
	// update timers
	NanoGRI(WorldInfo.GRI).AIBlackBoard.LastTurtleTime = WorldInfo.TimeSeconds;
	NextTurtleTime =  WorldInfo.TimeSeconds + RandRange( TimeBetweenTurtlesRange.X, TimeBetweenTurtlesRange.Y );


	if( IsDoingSpecialMove( 'NSM_Melee_Turtle' ) == TRUE )
	{
		NSM_Melee_Turtle(ActiveSpecialMove).PlayNewAnim();
	}
	else
	{
		DoSpecialMove( 'NSM_Melee_Turtle', TRUE );
	}
}


//// semi hack for now to pause a pose during an attack

function StartHoldPose( float HoldPoseTime )
{
	local int i;

	local AnimNodeSequence Seq;
	//local AnimSequence AnimSeq;
	local float RateToPlay;

	local float HoldAPoseStartTime;
	local float HoldAPoseDuration;
	local float TimeWeHaveLeft;

	Seq = FullBodySlot.GetCustomAnimNodeSeq();


	`log( "StartHoldPoseStartHoldPoseStartHoldPoseStartHoldPoseStartHoldPoseStartHoldPose" @ `showvar(Seq.AnimSeqName) @ `showvar(Seq) @ `showvar(FullBodySlot) @ `showvar(FullBodySlot.GetPlayedAnimation()) @ `showvar(FullBodySlot.bIsPlayingCustomAnim) );
	
	
	// we need to figure out the rate at which to play the anim to match the hold pose
	//AnimSeq = Mesh.FindAnimSequence( Seq.AnimSeqName );

	for( i = 0; i < Seq.AnimSeq.Notifies.length; i++ )
	{
		// First notify of desired class after this 'start'
		if( ClassIsChildOf(Seq.AnimSeq.Notifies[i].Notify.Class, class'NanoAnimNotify_MeleeHoldPose'))
		{
			HoldAPoseDuration += NanoAnimNotify_MeleeHoldPose(Seq.AnimSeq.Notifies[i].Notify).DurationToHold;
			`log( "   -->" @ `showvar(NanoAnimNotify_MeleeHoldPose(Seq.AnimSeq.Notifies[i].Notify).DurationToHold) @ " Total:" @ `showvar(HoldAPoseDuration) );

			HoldAPoseStartTime += Seq.AnimSeq.Notifies[i].Time;


		}
	}


	TimeWeHaveLeft = Seq.AnimSeq.SequenceLength - HoldAPoseStartTime;

	RateToPlay = TimeWeHaveLeft / (TimeWeHaveLeft + HoldAPoseDuration);

	`log( `showvar(RateToPlay) @ `showvar(TimeWeHaveLeft) @ `showvar(HoldAPoseDuration) @ `showvar(HoldPoseTime) @ `showvar((TimeWeHaveLeft + HoldAPoseDuration)) );

	//RateToPlay = 0.1f; // AnimSeq.SequenceLength / (AnimSeq.SequenceLength + HoldPoseTime);


	NanoWeap_Melee(Weapon).ClearTimer( 'PossiblyPlayAttackRecoverToReadyPositionAnim' );

	//`log( `showvar(Seq.Rate) );

	Seq.Rate = RateToPlay;


	//`log( `showvar(RateToPlay) @ `showvar(Seq.Rate) );

	//Seq.bPlaying = FALSE;

}

function EndHoldPose()
{
	local AnimNodeSequence Seq;
	//local AnimSequence AnimSeq;
	//local float RateToPlay;

	//local float TimeLeft;

	Seq = FullBodySlot.GetCustomAnimNodeSeq();

	`log( "EndHoldPoseEndHoldPoseEndHoldPoseEndHoldPoseEndHoldPoseEndHoldPoseEndHoldPose"  @ `showvar(Seq.AnimSeqName) );

	//if( Seq != None )
	//{
		//TimeLeft = Seq.AnimSeq.SequenceLength - Seq.CurrentTime;

		//


		//NanoWeap_Melee(Weapon).SetTimer( TimeLeft, FALSE, 'PossiblyPlayAttackRecoverToReadyPositionAnim' );

		// need to check to see if there is another combo scheduled
		//if( NanoWeap_Melee(Weapon).BufferedComboInput.ButtonPressed == GB_MAX )
		//if( NanoWeap_Melee(Weapon).HACKHACK_AllowInstantTransitionOnEndHoldPose == TRUE )
	if( NanoWeap_Melee(Weapon).WeaponSheet.AttackAnimState == AAS_AttackHoldPose )
	{
			`log( "Forcibly calling PossiblyPlayAttackRecoverToReadyPositionAnim PossiblyPlayAttackRecoverToReadyPositionAnim PossiblyPlayAttackRecoverToReadyPositionAnim PossiblyPlayAttackRecoverToReadyPositionAnim PossiblyPlayAttackRecoverToReadyPositionAnim " );
			NanoWeap_Melee(Weapon).PossiblyPlayAttackRecoverToReadyPositionAnim();
		}




		Seq.Rate = 1.0f; // prob need to get the original value :-\

		//Seq.bPlaying = TRUE;
	//}


}


function SpawnDurationCrowdPanicRepulsor( class<NanoCrowd_PanicRepulsor_TimeBasedBase> ClassToSpawn )
{
	Spawn( ClassToSpawn, self,, Location, Rotation,, TRUE );
}


function SpawnWeaponCrowdPanicRepulsor( class<NanoCrowd_PanicRepulsor_WeaponBase> ClassToSpawn )
{
	// clean up old one if it exists
	CleanUpSpawnWeaponCrowdPanicRepulsor();

	WeaponCrowdPanicRepulsor = Spawn( ClassToSpawn, self,, Location, Rotation,, TRUE );
	WeaponCrowdPanicRepulsor.SetBase( self );

	LastCausedCrowdPanicTime = WorldInfo.TimeSeconds;
}


function CleanUpSpawnWeaponCrowdPanicRepulsor()
{
	if( WeaponCrowdPanicRepulsor != None )
	{
		WeaponCrowdPanicRepulsor.Destroy();
		WeaponCrowdPanicRepulsor = None;
	}
}


defaultproperties
{
	Begin Object Name=CollisionCylinder
		BlockZeroExtent=FALSE
	End Object

	Begin Object Class=SkeletalMeshComponent Name=NanoPawnMesh
		bRootMotionExtractedNotify=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		RBChannel=RBCC_Pawn
		RBCollideWithChannels=(Default=TRUE,Pawn=TRUE,DeadPawn=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,FracturedMeshPart=TRUE,SoftBody=TRUE)
		bIgnoreControllersWhenNotRendered=TRUE
		LightEnvironment=MyLightEnvironment
		bUpdateSkelWhenNotRendered=TRUE			// need this for AI, since they rely on root motion for navigating
		MinDistFactorForKinematicUpdate=0.2
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=TRUE
		bCullModulatedShadowOnBackfaces=FALSE
		bAllowAmbientOcclusion=FALSE
		MotionBlurScale=0.0
		// Nice translucent lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
	End Object
	Mesh=NanoPawnMesh
	Components.Add(NanoPawnMesh)

	Begin Object Class=SkeletalMeshComponent Name=NanoPawnHeadMesh
	    bAllowAmbientOcclusion=FALSE
		LightEnvironment=MyLightEnvironment
		ParentAnimComponent=NanoPawnMesh
		ShadowParent=NanoPawnMesh
		bUpdateSkelWhenNotRendered=TRUE
		bCastHiddenShadow=TRUE
		CastShadow=TRUE
	End Object
	// NOTE: this is adding a skel comp to every single nano pawn even tho they don't need one
	HeadMesh=NanoPawnHeadMesh
	Components.Add(NanoPawnHeadMesh)

	DesiredClothBlend=1.0
	ClothBlendUpRate=1.0
	ClothBlendDownRate=4.0

	ControllerClass=class'NanoAI'
	InventoryManagerClass=class'NanoInventoryManager'

	HeadSocketName="Head"
	LeftHandSocketName="LeftHand"
	RightHandSocketName="RightHand"

	SupportedEvents.Add(class'SeqEvt_NanoStateChanged')
	SupportedEvents.Add(class'SeqEvt_VehicleMounted')

	// all of the DBNO events
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Drag')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Drag_Release')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Drag_ThrowOffLedge_Start')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Drag_ThrowOffLedge_Thrown')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_EnteredState')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Harvested')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Interrogated')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Interrogated_BeNice')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Interrogated_Drop')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Interrogated_Execute')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Interrogated_Failure')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Interrogated_Hit')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Interrogated_Success')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_Interrogated_Threaten')
	SupportedEvents.Add(class'SeqEvt_NanoPawn_DBNO_PattedDown')


	SkydivingMaxBlur=0.25f
	SkydiveMinDuration=3.f
	SkydivingSound=SoundCue'Foley_Body.Player.Body_FlyingWind_Loop_Cue'

	Begin Object Class=AudioComponent Name=MyTackleLoopAC
		SoundCue=SoundCue'Foley_Body.MetaCorps.MetaCorpsB_SlamRunLoop_Cue'
	End Object
	TackleLoopAC=MyTackleLoopAC

	StartTackleLungeBodySound=SoundCue'Foley_Body.Player.Body_Lunge_Cue'
	StartTackleLungeEffortSound=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_JumpDouble_Cue'

	ThrowTackleBodySound=SoundCue'Foley_Body.Player.Body_Throw_Cue'
	ThrowTackleEffortSound=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_PainMedium_Cue'
	ThrowTacklePainSound=SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatThrown_Cue'
	ThrowTackleFallingSound=SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.Metacorps_FallDeath_Cue'

	TackleSlamLungeBodySound=SoundCue'Foley_Body.Player.Body_Lunge_Cue'
	TackleSlamLungeEffortSound=SoundCue'Character_Lyrik_Efforts.Lyrik_Efforts_Dodge_Cue'

	TackleWallSlamBodySound=SoundCue'Foley_Body.MetaCorps.MetaCorpsB_SlamImpact_Cue'
	TackleWallSlamPainSound=SoundCue'Dialog_Temp.MetaCorps_NewTrooperA.MetaCorps_CombatTackled_Cue'
	TackleWallSlamDeadBodySound=SoundCue'Foley_Body.MetaCorps.MetaCorpsB_BodyFall_Cue'

	DurationInAirToPlayAMediumLandSound=0.750f
	DurationInAirToPlayALargeLandSound=2.500f
	LandedSmallCue=SoundCue'Foley_Footsteps.Stone.Footstep_Stone_Land_Cue'

	BodyMovementWalkCue=SoundCue'Foley_Body.Player.Body_Walk_Cue'

	ReadiedNanoCreatedItemFailedToCreateSound=SoundCue'Interface_Audio.Interface.WeaponSelectHighlightCue'

	TargetedDustEffectTrail=ParticleSystem'War_BulletEffects.FX.FX_P_BulletTrail_Normal'
	TargetedDenseEffectTrail=ParticleSystem'War_BulletEffects.FX.FX_P_BulletTrail_HighPower'


	SwordAttachedToWallCue=SoundCue'Weapon_Sword.Sword.Sword_Surface_StickIn_Cue'
	SoundDetachedFromWallCue=SoundCue'Weapon_Sword.Sword.Sword_Surface_PullFrom_Cue'
	SwordDraggingAlongSurfaceCue=SoundCue'Weapon_Sword.Sword.Sword_ScrapeLoop_Cue'
	FeetDraggingAlongSurfaceCue=SoundCue'Foley_Body.Player.Body_SlideLoop_Cue'

	PS_FootSlide=ParticleSystem'Nano_FX.Effects.P_FX_Nano_FootSlide'
    FootSlideSocketName="Footslide"

	// lots of flags
	bBlockActors=TRUE
	bBlocksNavigation=TRUE

	// allow controller to loop all the way around.  camera clamps itself
	ViewPitchMin=-65536
	ViewPitchMax=65546


	Buoyancy=+000.99000000
	UnderWaterTime=+00020.000000
	BaseEyeHeight=+00060.000000
	EyeHeight=+00060.000000
	CrouchHeight=+64.0
	CrouchRadius=+34.0
	GroundSpeed=600.0
	AirSpeed=+00200.000000
	FlySpeed=1000.00
	WaterSpeed=+00300.000000
	AccelRate=2048.f
	JumpZ=+01024.000000
	MaxFallSpeed=+0900.0

	LedgeCheckThreshold=384.0f

	TackleAutoThrowDuration=5.f

	HearingThreshold=10000.f
	bMuffledHearing=TRUE

	bCanSwim=TRUE
	RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
	AirControl=+0.15
	bCanCrouch=FALSE

	bJumpCapable=TRUE
	bCanJump=TRUE
	bStopAtLedges=TRUE
	bAvoidLedges=TRUE
	bAllowLedgeOverhang=FALSE

	bCanClimbLadders=TRUE

	bCanPickupInventory=TRUE

	SightRadius=+12000.0

	bNoEncroachCheck=FALSE

	bKillDuringLevelTransition=TRUE

	bPushesRigidBodies=FALSE
	RBPushRadius=10.0
	RBPushStrength=50.0

	JumpHoldTime=-1.f
	JumpHoldGravityZScale=1.f

	NotEnoughNanoPowerSound=SoundCue'Interface_Audio.Interface.ActiveReloadFailCue'

	PS_NaniteTornadoEjectTrail=ParticleSystem'Nano_Effects_Ghost.Effects.P_Nano_Effects_EjectTrail'
	NaniteTornadoReadyEffect=ParticleSystem'Nano_WeaponFX2.Tornado.P_FX_NaniteTornadoReadyEffect'

	FirstPersonCamBoneName=b_Camera
	ThirdPersonCamBoneName=b_Camera_3rdP

	CheckCameraBoneNames(0)=b_MF_Pelvis
	CheckCameraBoneNames(1)=b_MF_Neck
//	CheckCameraBoneNames(0)=b_MF_Neck

	UpDownBoneName="b_MF_Spine_01"
	UpDownAxis=AXIS_Y
	bInvertUpDownBoneAxis=TRUE
	OrientationBoneName="b_MF_Spine_01"
	OrientationAxis=AXIS_X
	GetUpFromBackYawOffset=+32768

	GetUpBlendTime=0.42f
	GetUpAnimRate=1.f
	GetUpAnimStartPos=0.f

	AwarenessOffsets=(X=0,Y=12.f,Z=36.f)
	AwarenessTraceDistance=256.f
	AwarenessImpactBuffer=10.f

	PeripheralVision=0.7f

	BriefingPawnIdleThreshold=3.f

	bCanStepUpOn=FALSE

	RootAttachmentInterpRate=8.f

	MaskMICValueGoal=15

	RagdollAngularMotorSpring=5000.f
	RagdollAngularMotorDamping=250.f
	RagdollAngularMotorForceLimit=0.3f
	TimeToScaleMotors=0.5f

//	bDebugShowCameraLocation=TRUE
//	bDebugHideHead=TRUE

//	bSteveTest=TRUE

	bCanDoStepsSmoothing=TRUE
	bCanDoTurnInPlaceAnim=TRUE

	bNeedsBaseTickedFirst=TRUE	// Needed for floor conform, so base is updated before our animation.
	bCanDoFloorConform=FALSE
	bDoFloorConform=TRUE
	bDoFullMeshFloorConform=FALSE
	FloorConformAverageFloorNormal=(X=0,Y=0,Z=1.f)
	FloorConformMinTimeBetweenUpdates=0.2f
	FloorConformMaxSlopeAngle=40.f
	MeshFloorConformToggleAlpha=(BlendTime=0.42f,BlendType=ABT_Cubic)
	MeshFloorConformMovementAlpha=(BlendType=ABT_Linear)
	IKFloorConformMovementAlpha=(BlendType=ABT_Linear)
	bDoIKFloorConformCOM=TRUE
	IKFloorConformCOMLimits=(X=25,Y=15)
	IKFloorConformCOMSpeed=(X=50,Y=50,Z=50)
	IKFloorConformCOMDamping=(X=10,Y=10,Z=10)
	IKFloorConformCOMWeight=0.5f
	bDoFootPlacement=FALSE
	FootPlacementAlpha=(BlendTime=0.42f,BlendType=ABT_Cubic)
	LegAdjustInterpSpeed=6
	bDoIKFloorConformTorsoBending=TRUE
	IKFloorConformTorsoQuatWorld=(X=0,Y=0,Z=0,W=1)
	IKFloorConformTorsoQuatLocal=(X=0,Y=0,Z=0,W=1)

	AimOffsetProfileList(0)=(ProfileName=Standard,TransDegrees_FrontToRear_Right=90,TransDegrees_RearToFront_Right=90,TransDegrees_FrontToRear_Left=-90,TransDegrees_RearToFront_Left=-90)
	AimOffsetProfileList(1)=(ProfileName=SMGv1,TransDegrees_FrontToRear_Right=145,TransDegrees_RearToFront_Right=125,TransDegrees_FrontToRear_Left=-100,TransDegrees_RearToFront_Left=-80)
}

