/**
 *
 * To debug why attacks are not occurring check:
 * ConditionalMeleeAttack and set bLogWarnings to be true
 * ResolveComboAttackIndex and set bLogWarnings to be true
 *
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Melee extends NanoWeap_MeleeBase
	abstract
	dependson(NanoMeleeWeaponSheet)
	native(Weapon)
	config(Weapon);

`define sword_log(msg)	`loginfo('Nano_Melee',WorldInfo.TimeSeconds@`msg)


const FIREMODE_Attacking	= 0;
const FIREMODE_Throwing		= 2;
const FIREMODE_Grab			= 4;
const FIREMODE_GrabAndBeat	= 6;
const FIREMODE_GrabAHostage	= 8;

// Reflection Variables
const REFLECT_LEVEL_NONE	= -1;
const REFLECT_LEVEL_BAD		=  0;
const REFLECT_LEVEL_GOOD	=  1;
const REFLECT_LEVEL_PERFECT =  2;

const REFLECT_TYPE_INSTANT = 0;
const REFLECT_TYPE_MELEE = 1;
const REFLECT_TYPE_PROJECTILE = 2;




/** Chance that attacker is knocked back from attack blocking */
var transient float ChanceBreakComboOnBlock;
/** Desired combo attack index */
var transient int DesiredComboIdx;
/** Time this attack was started */
var transient float AttackStartTime;
/** Number of sequential combos */
var transient int ComboCount;
/** Number of sequential combos need to get a slomo */
var config int ComboCountForSlomo;

/** Whether to allow next combo to happen - set by NanoAnimNotify_ComboStart */
var transient bool bComboWindowOpen;
/** Whether to do next combo as soon as combo window closes */
var transient bool bComboWindowActivateNextCombo;
/** Whether dead zone is active and we should ignore input for combos */
var transient bool bDeadZoneActive;

/** Whether we have already check to change slomo for this move */
var transient bool bSlomoChecked;
/** Whether slomo was allowed for this attack */
var transient bool bAllowSlomo;
/** Combo slomo set for this attack - used to reset at the end */
var transient float ComboTimeDilation;
var transient float	PreviousTimeDilation;
var SoundCue ComboSlomoSound;



// REFLECT VARIABLES
/** Whether melee weapon can even attempt to reflect projectiles or not */
var(Reflect) config	bool	bCanReflectProjectiles;
/** Whether or not we can reflect projectiles spawned after starting the reflect */
var(Reflect) config	bool	bReflectProjSpawnedAfterStart;
/** Amount of time after block to reflect projectiles back */
var(Reflect) config float	BlockReflectionWindow;
var(Reflect)		bool	bBonusAdded;

struct native ReflectData
{
	var() int		Level;
	var() Vector2d	TimeRange;

	// Angle
	var() Vector2d	Angle;
	var() float		AngleDeviation;
	var() float		AngleFallOff;

	// Damage
	var() Vector2d	HurtScale;
	var() Vector2d	PushScale;
	var() Vector2d	StunScale;
	var() Vector2d	DamageScale;

	// Other
	var() Vector2d	AdrenReward;
	var() Vector2d	SpeedScale;
	var() float		LeadPct;
	var() float		HomeSpeed;
};
var(Reflect) config array<ReflectData>		ProjReflectList;
var(Reflect) config	float					ReflectProjDelay;
var(Reflect)		float					LastReflectStartTime;
var float			LastPerfectReflectTime;
var float			LastReflectSoundTime;

var SoundCue				ReflectLevelSound[3];			// Sounds to play for reflect levels (Index matches REFLECT_LEVEL_*)
var class<NanoEmitter>		ReflectLevelEmitterClass[3];	// Emitters to spawn for reflect levels (Index matches REFLECT_LEVEL_*)
var ForceFeedbackWaveform	ReflectLevelForceFeedback[3];
var Color					ReflectLevelColor[3];

/** This is the min dot product that a projectile must be in for it to be reflected */
var(Reflect) config	float	ReflectProjFOV;
/** Width of the forward facing reflect cylinder - proj outside cylinder == bad reflect */
var(Reflect) config float	ReflectionWidth;
/** Amount of time reflect is on */
var(Reflect) config float   ReflectionTime;
/** Amount of time reflect is actively searching for projectiles */
var(Reflect) config float	ActiveReflectTime;
/** Amount of active reflect time to add per reflected projectile */
var(Reflect) config	float	BonusReflectTime;
/** Amount of time before successful reflect count is reset */
var(Reflect) config	float	BonusTimeOut;
/** Amount of time penalty between reflects after reflect is done */
var(Reflect) config float	ReflectionDelay;
/** Cancel reflect if last reflect was <= this level -- -1 == never cancel on reflect */
var(Reflect) config	int		CancelOnReflectLevel;
/** Number of successful sequential reflections */
var(Reflect)		byte	ReflectSuccessCount;

/** When do a reflect swing, overridden by other sounds */
var	SoundCue ReflectSound;
var SoundCue BlockedSound;
var ParticleSystem PS_Reflect;
var ParticleSystem PS_Blocked;

/** Constraints based on NanoSkill_Melee */
var transient int MaxSuperAttack;
var transient float DamageScale;

/** The weapon is allowed to modify the damage of the move / damage from the melee spreadsheet **/
var config float WeaponDamageScale;


/** If we should be checking for damage */
var transient bool bSlashDamaging;
/** If we should be checking for effects */
var transient bool bSlashEffects;
var transient array<NanoPawn> HitNanoPawnsPlayEffectsOn;

struct native MeleeDamageNotifyInfo
{
	var NanoAnimNotify_MeleeDamage Notify;

	var float	LastDamageTime;
	var vector	LastDamagePosition;
	var quat	LastDamageRotation;
	var int		LastDamageIndex;

	var	vector	OldWeaponBase;
	var vector	OldWeaponDir;
};
var() transient array<MeleeDamageNotifyInfo> ActiveDamageNotifies;
// need to have a transient NanoAnimNotify_MeleeDamage that represents the ActiveDamageNotifies[NotifyIdx] / GetDamageNotifyIndex

/** Temp vars for trail substepping **/
var transient bool bDoTrailSubTicking;
var transient vector BloodSubStepStart;
var transient vector BloodSubStepEnd;
var transient int AlongSwordLength;

/** Is this the first tick for damage? */
var transient bool bFirstDamageTick;
/** Have we done damage this swipe? */
var transient bool bHasDoneDamage;
/** Has there been an anim notify fired to ask for sword blood effects? **/
var transient bool bDoSwordDamageEffect;
/** Weapon trace base from previous frame of DoSweptDamageCheck() */
var	transient vector OldWeaponBase;
/** Weapon trace dir from previous frame of DoSweptDamageCheck() */
var transient vector OldWeaponDir;


/** Should update the attackers desired rotation when the attack starts */
var transient bool	bUpdateAttackerRotation;
var config	  bool	bUpdateAttackerRotationEachAttack;
var transient bool  bReleasedThumbStick;





var()	float	FootDamageCheckLen;
var()	float	ElbowDamageCheckLen;
var()	int		NumSwordLineChecks;

/** Are we doing a super move? */
var transient bool bDoingSuperMove;
var transient int SuperMoveLevel;
var ForceFeedbackWaveform	SuperMoveImpactWaveForm;
var	SoundCue				SuperMoveImpactSound;
var	ParticleSystem			SuperMoveImpactEffect;

/** Used for displaying debug info - toggle with 'DEBUGSWORD' console command */
var(Debug) config bool	bSwordDebug;
var(Debug) config bool	bDebugReflect;
var(Debug) config bool	bDebugDrawReflect;
var(Debug) config bool	bDebugIgnoreSweetSpot;

var protected SoundCue SwordHitPawnCue; //Hit (x6, three metal, three flesh) need to move these to the physical material system
var protected SoundCue SwordHitNonPawnCue; //Hit (x6, three metal, three flesh) need to move these to the physical material system
var protected SoundCue SwordDashAttackCue;
var protected SoundCue ElbowHitPawnCue;
var protected SoundCue FootHitPawnCue;


/** Looping effect when sliding down wall */
var ParticleSystemComponent	PSC_WallSlideEffect;
/** One-shot effect that fires when stabbing a wall/car */
var ParticleSystemComponent	PSC_WallStabEffect;

/** Blood splatters */
var protected MaterialInterface MI_BloodSplatterDecal1;
var protected MaterialInterface MI_BloodSplatterDecal2;

/** This is the name of the anim which will be used when a pawn is stunned (e.g. from RicochetMoon) and then you dash attack them.  Coup De Grace! **/
var config name DashAttackKillStunnedPawnAttackAnimName;

/** This is the amount of health the sword has when blocking before it is broken and shatters **/
var config float BlockingHealthDefault;
var transient float BlockingHealth;

/** Effects for when the sword shatters due to blocking **/
var name BlockingSwordShatterSocketName;
var ParticleSystem BlockingSwordShatterPS;
var SoundCue BlockingSwordShatterSound;

/** Camera shake to play on good impact */
var const NanoCameraShake HitVictimShake;
/** Camera shake to play on blocked impact */
var const NanoCameraShake HitBlockShake;
/** Camera shake to play when target is killed */
var const NanoCameraShake HitAndKillShake;

/** vars needed for functors for decal tracing **/
var transient vector BloodTraceStart;
var transient vector BloodTraceEnd;
var transient rotator BloodRotation;

/** Our prelim blood effects (before we can move them to phys mats) **/
var protected ParticleSystem PS_Blood_DeathSpray;
var protected ParticleSystem PS_Blood_SwordSlash;
var protected ParticleSystem PS_Blood_SwordImpactTrail;
var transient protected ParticleSystemComponent PSC_Blood_SwordImpactTrail;

/** When a blood spray occurs **/
var SoundCue BloodSpraySound;




var transient SpawnedNanoEmitter Emit_Blood_SwordImpactTrail;
var transient NanoTrailProxy TrailProxy;

/** Which socket the blood trail should be attached to for each type of hit **/
var name PS_SwordBloodTrailSocketName;
var name PS_ElbowBloodTrailSocketName;
var name PS_ElbowLeftBloodTrailSocketName;

var name PS_FootBloodTrailSocketName;
var name PS_FootLeftBloodTrailSocketName;



/** The sound to play when swinging **/
var SoundCue SwingEffort;



var(Slomo) config InterpCurveFloat SlomoCurve;
var(Slomo) transient bool bDo300Slomo;

/** We don't use the various firemode damage types for the moment. @see HandleDamageCollision **/
var class<DamageType> DamageCollisionDamageType;


var transient bool bAttackRecover_AllowTransitionToBaseAttack;
var transient bool bAttackRecover_AllowTransitionToNextCombo;

/** Whether or not we are allowed to buffer input. **/
var transient bool bBufferedInputAllowed;

var transient bool HACKHACK_AllowInstantTransitionOnEndHoldPose; // might not need this now



replication
{
	if( Role == ROLE_Authority && bNetDirty )
		ReflectionDelay;
}

/** Overridden to init wall slide/stab fx */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	CreateMeleeSheetData();

	BlockingHealth = BlockingHealthDefault;  // prob need some timer to recharge it

	CreateSwordTrailEffects();
	CreateSwordBladeEffects();
}


simulated event CreateMeleeSheetData()
{
	WeaponSheet = new(self) WeaponSheetClass;
	FixupComboAttackReferences();
	FixupHitRectionReferences();
	FixupAnimNotifyHoldPoses();
}




simulated function FillComboInput()
{
	FillComboInput_Worker( ComboInput );
}


simulated function FillBufferedComboInput()
{
	FillComboInput_Worker( BufferedComboInput );
}



private simulated function FillComboInput_Worker( out MeleeInputInfo out_InputInfo )
{
	local NanoPC PC;
	local Rotator Rot;
	local bool bPlayerInput;

	PC = NanoPC(Instigator.Controller);
	if( PC != None )
	{
		bPlayerInput = (Abs(PC.PlayerInput.RawJoyUp) > 0.2f || Abs(PC.PlayerInput.RawJoyRight) > 0.2f);
		Rot.Yaw = PC.PlayerCamera.Rotation.Yaw;

		// Store left thumbstick input
		out_InputInfo.RawJoyUp			= PC.PlayerInput.RawJoyUp;
		out_InputInfo.RawJoyRight		= PC.PlayerInput.RawJoyRight;

		// Store button presses
		if( PC.IsButtonActive(AttackButtonThree) )
		{
			out_InputInfo.ButtonPressed = AttackButtonThree;
		}
		else if( PC.IsButtonActive(AttackButtonTwo) )
		{
			out_InputInfo.ButtonPressed = AttackButtonTwo;
		}
		else if( PC.IsButtonActive(AttackButtonOne) )
		{
			out_InputInfo.ButtonPressed = AttackButtonOne; // any "valid" button not else if'd gets instant ButtonPressed. (this is "gated" by which PlayerInput HandleButtons call PerformSwordAttack)
		}
		else
		{
			`log( "some other random button pressed that we don't handle" );
			ScriptTrace();
		}

		// Compute and store worldspace attack direction
		out_InputInfo.AttackDir = PC.GetDirFromLeftStick( Rot, !bPlayerInput );
		// Clear combo direction - will be recomputed at execution time
		out_InputInfo.ComboDir = CJD_None; 
	}
}




simulated function EComboJoyDirection DetermineComboDirection( NanoPC PC, Rotator Dir, optional Actor TargetedActor )
{
	local Vector StickDir, X, Y, Z;
	local float StickDotX, StickDotY;
	local EComboJoyDirection Result;
	local bool bHaveDir;

	
	Result = CJD_None;

	if( Abs(ComboInput.RawJoyUp) > 0.2f || Abs(ComboInput.RawJoyRight) > 0.2f )
	{
		StickDir = Vector(ComboInput.AttackDir);
		
		bHaveDir = TRUE;
	}
	else if( TargetedActor != None )
	{
		StickDir = Normal( TargetedActor.Location - Instigator.Location );
		bHaveDir = TRUE;
	}

	if( bHaveDir )
	{
		GetAxes( Instigator.Rotation, X, Y, Z );
		StickDotX = (StickDir DOT X);
		StickDotY = (StickDir DOT Y);
		if( StickDotX > 0.5f )
		{
			Result = CJD_Up;
		}
		else if( StickDotX < -0.5f )
		{
			Result = CJD_Down;
		}
		else if( StickDotY > 0.5f )
		{
			Result = CJD_Right;
		}
		else if( StickDotY < -0.5f )
		{
			Result = CJD_Left;
		}
	}

/*
	`log( `showvar(StickDotX)@`showvar(StickDotY)@`showvar(Result) );
	FlushPersistentDebugLines();
	DrawDebugLine((StickDir * 64.f) + Instigator.Location + vect(0,0,10), Instigator.Location + vect(0,0,10), 255, 255, 255, TRUE );
	DrawDebugLine((X * 64.f) + Instigator.Location, Instigator.Location, 255, 0, 0, TRUE );
	DrawDebugLine((Y * 64.f) + Instigator.Location, Instigator.Location, 0, 255, 0, TRUE );
	DrawDebugLine((Vector(Dir) * 64.f) + Instigator.Location, Instigator.Location, 0, 0, 255, TRUE );
*/

	return Result;
}


simulated function int ResolveMeleeAttackIndex()
{
	local int Idx;

	if( DesiredAttackName != '' )
	{
		return WeaponSheet.MeleeAttacks.Find( 'AttackName', DesiredAttackName );
	}

	Idx = ResolveComboAttackIndex( 0/*, TRUE */);
	return Idx;
}

function int GetDoingBaseAttackComboIndex()
{
	return 0;
}

simulated function int ResolveComboAttackIndex( int CurrentAttackIdx, optional bool bLogWarnings )
{
`if(`notdefined(FINAL_RELEASE))
	local Name ComboAttackName;
`endif

	local int ComboIdx;
	local int DesiredAttackIdx, Result;
	local EComboJoyDirection ComboAttackDirection;
	local NanoPC PC;
	local int MeleeLevel, ReqSkillLevel;
	local NanoSkill_Melee MeleeSkill;
	local int i;
	local int AIBaseAttackComboIndex;
	local EGameButtons ComboButton;

	// a way for the AI to get a different attack
	// this returns 0 (which is the first entry in the BaseAttack combo list for the default case
	AIBaseAttackComboIndex = GetDoingBaseAttackComboIndex();

	//bLogWarnings = TRUE;
	`log( GetFuncName()@"CurAttack"@`showvar(CurrentAttackIdx)@WeaponSheet.MeleeAttacks[CurrentAttackIdx].AttackName, bLogWarnings );
	if( bLogWarnings )
	{
		for( i = 0; i < WeaponSheet.MeleeAttacks.Length; ++i )
		{
			`log( "  " @ WeaponSheet.MeleeAttacks[i].AttackName );
		}
	}


	PC = NanoPC(Instigator.Controller);
	MeleeSkill = NanoPawn(Instigator).GetSkill(class'NanoSkill_Melee');
	if( MeleeSkill != None )
	{
		MeleeLevel = MeleeSkill.SkillLevel;
	}
	
	PendingComboTargetedActor = FindComboTarget();
	ComboInput.ComboDir = DetermineComboDirection( PC, ComboInput.AttackDir, PendingComboTargetedActor );
	
	Result = -1;
	for( ComboIdx = 0; ComboIdx < WeaponSheet.MeleeAttacks[CurrentAttackIdx].ComboAttacks.Length; ComboIdx++ )
	{
`if(`notdefined(FINAL_RELEASE))
		ComboAttackName = WeaponSheet.MeleeAttacks[CurrentAttackIdx].ComboAttacks[ComboIdx].ComboAttackName;
`endif

		if( ( NanoAIBase(Instigator.Controller) != none ) && ( ComboIdx != AIBaseAttackComboIndex ) )
		{
			`log( "Combo was not what the AI wanted!"@ `showvar(ComboIdx) @ `showvar(AIBaseAttackComboIndex), bLogWarnings );
			continue;
		}

		if( WeaponSheet.MeleeAttacks[CurrentAttackIdx].ComboAttacks[ComboIdx].ComboAttackIdx < 0 )
		{
			continue;
		}

		// only check these "error" conditions for the player.  AIs can do what ever they want
		if( NanoAIBase(Instigator.Controller) == None )
		{
			// If player not pressing the button we need for this combo -- skip
			ComboButton = WeaponSheet.MeleeAttacks[CurrentAttackIdx].ComboAttacks[ComboIdx].ComboAttackButton;
			if( ComboInput.ButtonPressed != ComboButton )
			{
				//debug
				`log( "Combo failed button press:"@ComboAttackName@ComboButton, bLogWarnings );
				continue;
			}

			// If player is not pressing in the direction to trigger this combo -- skip
			ComboAttackDirection = WeaponSheet.MeleeAttacks[CurrentAttackIdx].ComboAttacks[ComboIdx].ComboAttackDirection;
			if( ComboAttackDirection != CJD_Any && ComboAttackDirection != ComboInput.ComboDir )
			{
				//debug
				`log( "Combo failed joy direction:"@ComboAttackName@ComboAttackDirection, bLogWarnings );
				continue;
			}
		}

		// If required to have done damage with the last attack but did not -- skip
		if( WeaponSheet.MeleeAttacks[CurrentAttackIdx].ComboAttacks[ComboIdx].bRequireDamageFromLastHit && !bHasDoneDamage )
		{
			//debug
			`log( "Combo failed req damage:"@ComboAttackName, bLogWarnings );
			continue;
		}

		// If player doesn't have required skill level
		ReqSkillLevel = WeaponSheet.MeleeAttacks[CurrentAttackIdx].ComboAttacks[ComboIdx].ReqMeleeSkillLevel;
		if( ReqSkillLevel > MeleeLevel )
		{
			//debug
			`log( "Combo failed req skill level:"@ReqSkillLevel@MeleeLevel, bLogWarnings );
			continue;
		}

		DesiredAttackIdx = WeaponSheet.MeleeAttacks[CurrentAttackIdx].ComboAttacks[ComboIdx].ComboAttackIdx;
		// If instigator fails to meet all the criteria for the desired attack -- skip
		if( !ConditionalMeleeAttack( DesiredAttackIdx, PendingComboTargetedActor, bLogWarnings ) )
		{
			//debug
			`log( "Combo failed conditionals:"@ComboAttackName, bLogWarnings );
			continue;
		}

		//debug
		`log( "GOT COMBO ATTACK"@ComboAttackName, bLogWarnings );

		// Got a valid combo
		Result = DesiredAttackIdx;
		break;
	}

	// Check for invalid combo path
	if( Result < 0 && bLogWarnings )
	{
		`log( GetFuncName()@"Invalid combo path"@`showvar(CurrentAttackIdx)@`showvar(ComboInput.ComboDir)@`showvar(bHasDoneDamage)@ComboInput.ButtonPressed );
		ScriptTrace();
	}

	return Result;
}

simulated function bool ConditionalMeleeAttack( int MeleeAttackIdx, Actor TargetedActor, optional bool bLogWarnings )
{
	local float DistFromVictim2D;
	local Actor HitActor;
	local Vector HitLocation, HitNormal;
	local NanoPawn Attacker;

	Attacker = NanoPawn(Instigator);

	//`log( `location@WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqAttackerPhysics@`showvar(Instigator.Physics)@WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqVictimPhysics@`showvar(TargetedActor)@`showvar(TargetedActor.Physics) );

	// If attackers physics don't meet the condition - fail
	if( (WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqAttackerPhysics == CMP_Ground &&
			(Instigator.Physics != PHYS_Walking && Instigator.Physics != PHYS_None && Instigator.Physics != PHYS_Spider && Instigator.Physics != PHYS_NavMeshWalking)) ||
		(WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqAttackerPhysics == CMP_Air &&
			(Instigator.Physics != PHYS_Falling && Instigator.Physics != PHYS_Flying && Instigator.Physics != PHYS_None)) )
	{
		//debug
		`log( ">> Failed conditional - Attacker Physics Requirement", bLogWarnings );

		return FALSE;
	}

	if( WeaponSheet.MeleeAttacks[MeleeAttackIdx].bReqVictim || TargetedActor != None )
	{
		if( TargetedActor == None )
		{
			//debug
			`log( ">> Failed conditional - Requires Victim", bLogWarnings );

			return FALSE;
		}
		else
		{
			DistFromVictim2D = GetDistFromTargt( TargetedActor );	
			if( (WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqMinVictimDist > 0 && DistFromVictim2D < WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqMinVictimDist) ||
				(WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqMaxVictimDist > 0 && DistFromVictim2D > WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqMaxVictimDist) )
			{
				//debug
				`log( ">> Failed conditional - Required Victim Distance", bLogWarnings );

				return FALSE;
			}
		}
	}

	// If victim physics don't meet the condition - fail
	if( TargetedActor != None )
	{
		if( (WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqVictimPhysics == CMP_Ground &&
				TargetedActor.Physics != PHYS_Walking && TargetedActor.Physics != PHYS_None && TargetedActor.Physics != PHYS_Spider && TargetedActor.Physics != PHYS_NavMeshWalking) ||
			(WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqVictimPhysics == CMP_Air &&
				TargetedActor.Physics != PHYS_Falling && TargetedActor.Physics != PHYS_Flying && TargetedActor.Physics != PHYS_None) )
		{
			//debug
			`log( ">> Failed conditional - Victim Physics Requirement", bLogWarnings );

			return FALSE;
		}
	}

	// Check distance from the ground
	if( WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqMinDistFromGround > 0.f )
	{
		HitActor = Instigator.Trace( HitLocation, HitNormal, Instigator.Location - (WeaponSheet.MeleeAttacks[MeleeAttackIdx].ReqMinDistFromGround * vect(0,0,1)), Instigator.Location, FALSE, Instigator.GetCollisionExtent() );
		if( HitActor != None )
		{
			//debug
			`log( ">> Failed conditional - Min Dist From Ground", bLogWarnings );

			return FALSE;
		}
	}
	
	// Check for dashing requirement
	if( WeaponSheet.MeleeAttacks[MeleeAttackIdx].bReqDashing )
	{
		if( `TimeSince( Attacker.LastDashingTime ) > 0.25f )
		{
			return FALSE;
		}
	}	
		
	return TRUE;
}



simulated function Actor FindComboTarget()
{
	local NanoPC PC;
	local Actor  TargetedActor;
	local NanoInterface_Targetable NTI;
	local Vector	FindLoc;
	local Rotator	FindRot;
	local NanoAI_Combat AI;
	local float FallbackMaxRange;

	PC = NanoPC(Instigator.Controller);
	if( PC != None )
	{
		//debug
		PC.UpdateDebugMeleeTargets();

		// Setup search loc/rot
		FindLoc = Instigator.Location;
		FindRot = ComboInput.AttackDir;

		// Used for fallback checks, give longer distance buffer in the air
		FallbackMaxRange = (Instigator.Physics == PHYS_Falling) ? 2048.f : 1024.f;
		
		// If player is giving input
		if( Abs(ComboInput.RawJoyUp) > 0.2f || Abs(ComboInput.RawJoyRight) > 0.2f )
		{
			// Try to select in a "foward" cone - forward determined first by input
			TargetedActor = PC.SelectTarget_Worker( PC.MeleeStickRateTarget, 512.f, 0.3f, FindLoc, FindRot );
			// If no target found, pick from a much wider front cone
			if( TargetedActor == None )
			{
				TargetedActor = PC.SelectTarget_Worker( PC.MeleeStickRateTarget, FallbackMaxRange, -0.3f, FindLoc, FindRot );
			}
		}
		// Otherwise, if no input given
		else
		{
			TargetedActor = ComboTargetedActor;

			// If we have no targetable last combo target
			NTI = NanoInterface_Targetable(ComboTargetedActor);
			if( NTI == None || !NTI.IsTargetable() )
			{
				// Try to select in a "forward" cone - forward determined first by input then by pawn rotation if no input given
				TargetedActor = PC.SelectTarget_Worker( PC.MeleeStickRateTarget, 512.f, -0.3f, FindLoc, FindRot );
				// If no target found, pick a target anywhere around us
				if( TargetedActor == None )
				{
					// don't select anywhere around us as that makes button mashing make your
					// pawn rotate in really crazy directions which doesn't look as nice as
					// slice slice(kill) keep moving forward, dodge, turn
					// or for having playing active engaged and push thumbstick in direction (c.f. above)
					//TargetedActor = PC.SelectTarget_Worker( PC.MeleeStickRateTarget, 1024.f, -1.f, FindLoc, FindRot );
		
					TargetedActor = PC.SelectTarget_Worker( PC.MeleeStickRateTarget, FallbackMaxRange, -0.3f, FindLoc, FindRot );
				}
			}
		}
	}
	else
	{
		AI = NanoAI_Combat(Instigator.Controller);
		if( AI != None )
		{
			TargetedActor = AI.FireTarget;
		}
	}

	return TargetedActor;
}


simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( ReflectionDelay > 0.0 )
	{
		ReflectionDelay -= DeltaTime;
	}
}


/** Trying to reload a sword does nothing! */
simulated function ForceReload();



simulated function StopAttackAnim( optional bool bForceStop );
simulated function PossiblyPlayAttackAnim( optional bool bForceUpdate );
simulated function PossiblyPlayAttackRecoverToReadyPositionAnim();
simulated function PossiblyPlayPostAttackAnim();


simulated function float GetDelayBeforeUntarget()
{
	return 10.f;
}

simulated state Attacking extends WeaponFiring
{
	simulated function BeginState(Name PrevStateName)
	{
		local int Idx;

		bReleasedThumbStick = TRUE;
		DamageScale = 1.f;
		bDeadZoneActive = FALSE;
		bSlomoChecked = FALSE;
		bAllowSlomo = FALSE;

		`sword_log(`location@`showvar(bReleasedThumbStick));

		bLastHitConnected = FALSE;

		Super.BeginState(PrevStateName);

		// reset the sword trail
		for( Idx = 0; Idx < PS_Trail.Length; Idx++ )
		{
			if( PS_Trail[Idx] != none )
			{
				PSC_Trail[Idx].SetTemplate( PS_Trail[Idx] );
			}
		}

		if( SwingEffort != none )
		{
			if( Instigator != none )
			{
				Instigator.PlaySound( SwingEffort );
			}
		}

		if( Instigator.IsHumanControlled() == TRUE )
		{
			NanoPC(Instigator.Controller).ClearTimer( nameof(NanoPC(Instigator.Controller).AutoSheathMeleeWeapon) );
		}


		ClearTimer( nameof(TurnOffPlayerAttackingMusic) );
	}


	simulated function EndState(Name NextStateName)
	{
		local NanoPawn NP;


		//`log( "WHYYYYYYYYY" @ `showvar(NextStateName) );
		//ScriptTrace();

		`sword_log( `location @ `showvar(NextStateName) );
		Super.EndState(NextStateName);

		ClearTimer(nameof(StopAttackAnim));
		ClearTimer(nameof(FinishMeleeAttack));
		ClearTimer(nameof(PossiblyPlayAttackAnim));
		ClearTimer(nameof(PossiblyPlayAttackRecoverToReadyPositionAnim));
		ClearTimer(nameof(PossiblyPlayPostAttackAnim));
		ClearTimer(nameof(WeaponSheet.UpdateAttackAnimState), WeaponSheet );

		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			if( NP.bIsDoingMeleeAttack )
			{
				StopAttackAnim( TRUE );
			}
			NP.bLockPawnRotation    = FALSE;
			NP.bIsDoingStabMantle   = FALSE;
			NP.bDoNoHitReaction     = FALSE;
			NP.bPawnInvulnerable    = FALSE;
		}

		if( Instigator != None )
		{
			if( Instigator.Physics != PHYS_Walking && Instigator.Physics != PHYS_Falling )
			{
				Instigator.SetMovementPhysics();
			}
		}


		//SetTimer( 0.150f, FALSE, nameof(TurnOffSwordTipBloodTrail) );

		bAttackRecover_AllowTransitionToBaseAttack = FALSE;
		bAttackRecover_AllowTransitionToNextCombo = FALSE;

		SetTimer( 5.0f, FALSE, nameof(TurnOffPlayerAttackingMusic) );

		if( Instigator.IsHumanControlled() == TRUE )
		{
			NanoPC(Instigator.Controller).SetTimer( NanoPC(Instigator.Controller).TimeBeforeMeleeWeaponAutoHolsters, FALSE, nameof(NanoPC(Instigator.Controller).AutoSheathMeleeWeapon) );
		}

	}


	/** Tick function is used to do sword blade traces looking for what we hit (when bSlashDamaging is TRUE from notifies) */
	simulated function Tick(float DeltaTime)
	{
		local NanoPC PC;
		local NanoPawn NP;

		local vector WeaponBase, WeaponDir;
		local float WeaponCheckLen;
		local float Alpha;

		Global.Tick(DeltaTime);

		if ( bDoTrailSubTicking == TRUE )
		{
			//`log( "WHYY??" );
			GetTraceVars( WeaponBase, WeaponDir, WeaponCheckLen );

			// Distance along blade
			// you want to start at the tip of the blade and move toward the base
			Alpha = float(AlongSwordLength)/float(NumSwordLineChecks-1);

			// Interpolate along old blade pos
			BloodSubStepStart = OldWeaponBase + (Alpha * OldWeaponDir * WeaponCheckLen);

			// Interpolate along current blade position
			BloodSubStepEnd = WeaponBase + (Alpha * WeaponDir * WeaponCheckLen);

			RunPhysicsSimulationTilEnd( TrailProxy, BloodSubStepStart, BloodSubStepEnd );
			//bDoTrailSubTicking = FALSE; // hack

			OldWeaponBase = WeaponBase;
			OldWeaponDir = WeaponDir;
		}

		if( bSlashEffects )
		{
			//`log( "bSlashEffects" );
			DoSweptEffectsCheck();
		}

		if( !bReleasedThumbStick )
		{
			bReleasedThumbStick = CheckReleasedThumbStick();
		}

		NP = NanoPawn(Instigator);
		// If recovering from melee attack and player is giving input after releasing the stick
		if( NP != None )
		{
	
			if// ( (bReleasedThumbStick && NP.bRecoveringFromMeleeAttack) || 
			( ( bReleasedThumbStick == TRUE ) && ( NP.bPreventMoveInMeleeAttack == FALSE ) )
			{
				PC = NanoPC(Instigator.Controller);
				if( PC != None && (Abs(PC.PlayerInput.RawJoyUp) > 0.2f || Abs(PC.PlayerInput.RawJoyRight) > 0.2f) )
				{
					//`log( "AHHHHHHHHHHHHHHHHHH We are going to State 'Active'" );
					GotoState( 'Active' );
				}
			}
			else if( NP.bRecoveringFromMeleeAttack && DesiredComboIdx >= 0 && bComboWindowOpen )
			{
				//`log( "AHHHHHHHHHHHHHHHHHH We are going to ReachedComboTransitionPoint" );
				ReachedComboTransitionPoint();
			}
			else if( !NP.bDodging && !NP.bRecoveringFromMeleeAttack )
			{
				if( ComboTargetedActor != None && WorldInfo.TimeDilation == PreviousTimeDilation )
				{
					UpdateAttackerDesiredRotation( ComboTargetedActor == None );
					NP.SetDesiredRotation( AttackerDesiredRotation, FALSE, FALSE );
					//`log( "AHHHHHHHHHHHHHHHHHH We are going to UpdateAttackerDesiredRotation/ SetDesiredRotation" );
				}
			}
		}

		if( !bTargetDodgedDuringHit && (NanoPawn(ComboTargetedActor) != None) && NanoPawn(ComboTargetedActor).bDodging )
		{
			// If the target dodged during the attack, flag it so we can deal with it if desired
			bTargetDodgedDuringHit = TRUE;
		}

		//`sword_log(`location @ `showvar(NP.bRecoveringFromMeleeAttack) @ `showvar(DesiredComboIdx >= 0) @ `showvar(bComboWindowOpen) );
	}

	simulated function bool CanSwitchAwayFromWeapon()
	{
		local NanoPawn NP;

		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			if( NP.bIsDoingMeleeAttack && !NP.bRecoveringFromMeleeAttack )
			{
				return FALSE;
			}
		}

		return TRUE;
	}

	/** @see Weapon::TryPutDown() */
	simulated function bool TryPutDown()
	{
		// Put the weapon down right away, and abort attack
		PutDownWeapon();
		return TRUE;
	}

	/** TimeWeaponFiring is ignored since we rely animation timings */
	simulated function TimeWeaponFiring(byte FireModeNum);

	/** Called from FireAmmunition - only once when state begins, because RefireCheckTimer is empty (see above) */
	simulated function CustomFire()
	{
		local int DesiredAttackIdx;

		`sword_log(`location@`showvar(DesiredAttackName));

		ComboCount = 1;
		bUpdateAttackerRotation = TRUE;
		// Fill combo info from player input
		FillComboInput();
		// Try to resolve our base attack
		DesiredAttackIdx = ResolveMeleeAttackIndex();

		// If failed to get the desired attack - choose one of the base ones
		if( DesiredAttackIdx <= 0 )
		{
			DesiredAttackIdx = WeaponSheet.MeleeAttacks.Find( 'AttackName', 'BaseRight' );
			//debug
			`warn( "Failed to find available base attack... fallback choice:"@WeaponSheet.MeleeAttacks[DesiredAttackIdx].AttackName );
		}

		// Set combo target to pending target found in ResolveComboAttackIndex
		ComboTargetedActor = PendingComboTargetedActor;
		PendingComboTargetedActor = None;
		// Execute the melee attack
		StartMeleeAttack(DesiredAttackIdx);
	}

	/** Custom BeginFire function - called when a fire button is pressed during an attack */
	simulated function BeginFire(byte FireModeNum)
	{
		local bool bRepress;
		local NanoPC PC;

		`sword_log(`location@`showvar(AttackIdx)@`showvar(DesiredComboIdx)@`showvar(bReleasedThumbStick));

		if( FireModeNum == CurrentFireMode && AttackIdx >= 0 )
		{
			// If haven't already "mashed" to the next combo - allow chance to shortcut to next attack
			bRepress = (DesiredComboIdx >= 0);
			if( bDeadZoneActive == FALSE )
			{

				// if we are not waiting to finish a melee move let's go ahead and just find the attack we should use
				if( ( IsTimerActive(nameof(FinishMeleeAttack)) == FALSE )
					//|| ( bAttackRecover_AllowTransitionToBaseAttack == TRUE )
					)
				{

					`log( "AHHHH!!" @ `showvar(IsTimerActive(nameof(FinishMeleeAttack))) @ `showvar(bAttackRecover_AllowTransitionToBaseAttack) @ `showvar(AttackIdx) @ `showvar(bRepress) );

					FillComboInput();

					if( bAttackRecover_AllowTransitionToBaseAttack == TRUE )
					{
						`log( "TRUE Setting attackIdx to " @ `showvar(AttackIdx) );
						DesiredComboIdx = ResolveComboAttackIndex( AttackIdx ); // ??
					}
					else
					{
						DesiredComboIdx = ResolveComboAttackIndex( AttackIdx );
					}



					PC = NanoPC(Instigator.Controller);
					if( bUpdateAttackerRotationEachAttack && PC != None && bReleasedThumbStick )
					{
						bUpdateAttackerRotation = TRUE;
					}
				}

				if( bAttackRecover_AllowTransitionToBaseAttack == TRUE )
				{
					`log( "Ohhhh reset the DesiredComboIdx!!!" @ `showvar(bAttackRecover_AllowTransitionToBaseAttack) @ " was" @ `showvar(DesiredComboIdx) );
					FillComboInput();
					// Try to resolve our base attack
					DesiredComboIdx = ResolveMeleeAttackIndex();

					`log( "   the DesiredComboIdx!!! is" @ `showvar(DesiredComboIdx) );
					//ScriptTrace();
					//Function NanoGame.NanoPlayerInput_Base:ButtonPress
					//Function NanoGame.NanoPlayerInput:HandleButtonInput_Y
					//Function NanoGame.NanoPawn:StartForge
					//Function NanoGame.NanoPlan_WeaponBase:StartForge
					//Function NanoGame.NanoPC:SwitchToWeapon
					//Function NanoGame.NanoPlayerInput:SwordAttack
					//Function NanoGame.NanoPC:PerformSwordAttack
					//Function Engine.PlayerController:StartFire
					//Function Engine.Pawn:StartFire
					//Function NanoGame.NanoWeaponBase:StartFire
					//Function Engine.Weapon:StartFire
					//Function NanoGame.NanoWeap_Melee:Attacking.BeginFire

				}

				// If mid-attack and combo window is open then go ahead and start the next combo immediately
				// Otherwise, hang onto DesiredComboIdx and transition to it when the attack is complete
				if( DesiredComboIdx >= 0 )
				{
					if( ( IsTimerActive(nameof(FinishMeleeAttack)) == TRUE )
						//|| ( bAttackRecover_AllowTransitionToBaseAttack == TRUE )
						)
					{
						`log( "TRANSITION VIA STOP ATTACK ANIM" );
						ClearTimer(nameof(FinishMeleeAttack));
						StopAttackAnim(); // this will transition us to the next attack
					}
					// modify these checks to turn back on melee system combos!
					else if( !bDebugIgnoreSweetSpot 
					    	 && !bRepress 
							 && bComboWindowOpen 
							 && IsTimerActive(nameof(StopAttackAnim))  // this timer is never actually set!
							 )
					{
						bComboWindowActivateNextCombo = TRUE;

						//placeholder
						NanoPC(Instigator.Controller).PlaySound(SoundCue'Interface_Audio.Interface.ActiveReloadSuccessCue');
					}
				}
			}
			`sword_log(`location @ `showvar(bDeadZoneActive) @ `showvar(AttackIdx) @ `showvar(DesiredComboIdx) @ `showvar(bComboWindowOpen) @ `showvar(bComboWindowActivateNextCombo) @ `showvar(IsTimerActive(nameof(StopAttackAnim))) @ `showvar(IsTimerActive(nameof(FinishMeleeAttack))) @ `showvar(bDebugIgnoreSweetSpot) @ `showvar(bRepress) );
		}
		else
		{
			DesiredComboIdx = -1;
		}
	}

	simulated function StopFire( byte FireModeNum )
	{
		GotoState( 'Active' );
	}

	/** Called from NanoAnimNotify_ComboSuccessTransition */
	simulated function ComboSuccessTransition()
	{
		Global.ComboSuccessTransition();
		if( bComboWindowActivateNextCombo )
		{
			ReachedComboTransitionPoint();
		}
	}

	/** 
	 * Called from NanoAnimNotify_ComboFailTransition
	 * This is actually what is going to cause the "melee sheet" to progress to the next combo. As it ends up calling  
	 * StopAttackAnim() in the ReachedComboTransitionPoint function.
	 */
	simulated function ComboFailTransition( bool bAllowTransDuringRecovery )
	{
		local NanoPawn NP;

		// Set recovery flag
		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			NP.bRecoveringFromMeleeAttack = TRUE;
			NP.bPreventJumpInMeleeAttack = FALSE;
			NP.bPreventRotationInputInMeleeAttack = TRUE;
		}

		Global.ComboFailTransition( bAllowTransDuringRecovery );
		ReachedComboTransitionPoint();

		// After reaching failed combo point, always activate deadzone
		bDeadZoneActive  = !bAllowTransDuringRecovery;
		bComboWindowOpen =  bAllowTransDuringRecovery;
	}

	/** 
	 * Called from NanoAnimNotify_ComboAllowTransition
	 * This is actually what is going to cause the "melee sheet" to progress to the next combo. As it ends up calling  
	 * StopAttackAnim() in the ReachedComboTransitionPoint function.
	 */
	simulated function ComboAllowTransition( bool bAllowTransDuringRecovery )
	{
		local NanoPawn NP;

		// Set recovery flag
		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			NP.bRecoveringFromMeleeAttack = TRUE;
			NP.bPreventJumpInMeleeAttack = FALSE;
			NP.bPreventRotationInputInMeleeAttack = TRUE;
		}

		Global.ComboFailTransition( bAllowTransDuringRecovery );
		ReachedComboTransitionPoint();

		// After reaching failed combo point, always activate deadzone
		bDeadZoneActive  = !bAllowTransDuringRecovery;
		bComboWindowOpen =  bAllowTransDuringRecovery;
	}



	simulated function ReachedComboTransitionPoint( optional bool bForced )
	{
		if( ( DesiredComboIdx >= 0 ) || ( bForced == TRUE ) )
		{
			ClearTimer(nameof(StopAttackAnim));
			ClearTimer(nameof(FinishMeleeAttack));
			StopAttackAnim(); // this is going to move to the next combo
		}
	}

	/** Checks to see if the player is close enough to the target to start the attack */
	simulated function PossiblyPlayAttackAnim( optional bool bForceUpdate )
	{
		if( bForceUpdate )
		{
			WeaponSheet.SetAttackAnimState( AAS_Attack );
		}
		else if( ComboTargetedActor != None )
		{
			if( !IsInAttackRange( ComboTargetedActor ) )
			{
				// if we've timed out or landed
				if( `TimeSince(AttackStartTime) > 2.f || Instigator.Physics == PHYS_Walking )
				{
					// then abort the attack
					FinishMeleeAttack();
				}
				else
				{
					// try again after a tick
					SetTimer(0.001f,FALSE,nameof(PossiblyPlayAttackAnim));
				}
			}
			else
			{
				WeaponSheet.SetAttackAnimState( AAS_Attack );
			}
		}
		else if( Instigator.Physics != PHYS_Walking && `TimeSince(AttackStartTime) < 2.f )
		{
			SetTimer(0.1f,FALSE,nameof(PossiblyPlayAttackAnim));
		}
		else 
		{
			// lost target, abort the attack
			//FinishMeleeAttack();

			WeaponSheet.SetAttackAnimState( AAS_Attack );
		}
	}

	
	simulated function PossiblyPlayAttackRecoverToReadyPositionAnim()
	{
		WeaponSheet.UpdateAttackAnimState();
	}

	simulated function PossiblyPlayPostAttackAnim()
	{
		WeaponSheet.UpdateAttackAnimState();
	}

	/** Plays the attack animation and sets timer to finish the attack or transition to blocked */
	simulated function PlayAttackAnim()
	{
		local NanoPawn NP;

		ClearTimer(nameof(PossiblyPlayAttackAnim));
		ClearTimer(nameof(PossiblyPlayAttackRecoverToReadyPositionAnim));
		ClearTimer(nameof(PossiblyPlayPostAttackAnim));

		NP = NanoPawn(Instigator);
		NP.ClearTimer(nameof(NP.StopHitReaction));

		AttackSpeedScale = NanoGRI(WorldInfo.GRI).GlobalAttackSpeedScalar;

		WeaponSheet.InitAttackAnim( NP, AttackIdx, AttackSpeedScale );
	}

	/** Instigator of this weapon has landed on the ground */
	simulated function HandleLanded()
	{
		local NanoPawn NP;

		NP = NanoPawn(Instigator);
		if( NP != None && NP.bIsSwordDashing )
		{
			PossiblyPlayAttackAnim( TRUE );
		}

		HandleSpecialEvents( 'Landed' );
	}

	// WOW
	// so basically how this works is that we play an anim
	// and then an anim notify will call ComboSuccessTransition or ComboFailTransition
	// which then calls StopAttackAnim
	// which causes a WeaponSheet.StopAttackAnim()
	// but then it actually looks to see if we should start another attack
	simulated function StopAttackAnim( optional bool bForceStop )
	{
		local NanoPawn NP;
		local NanoPC PC;

		//bAttackRecover_AllowTransitionToBaseAttack = FALSE;

		bLastHitConnected = bCurrentHitConnected;

		ClearTimer(nameof(StopAttackAnim));
		ClearTimer(nameof(PossiblyPlayAttackRecoverToReadyPositionAnim));

		NP = NanoPawn(Instigator);
		PC = NanoPC(Instigator.Controller);

		if( PC != None )
		{
			`sword_log(`location@PC.IsButtonActive(GB_LeftTrigger)@PC.IsButtonActive(GB_RightTrigger)@`showvar(DesiredComboIdx)@`showvar(ComboCount)@`showvar(bForceStop));
		}

		WeaponSheet.StopAttackAnim( NP, AttackIdx );

		NP.bIsSwordDashing = FALSE;

		if( bForceStop )
		{
			`sword_log("transition to blocking");
			FinishMeleeAttack( bForceStop );
		}
		else
		{
			PossiblyDoAComboAttackFromOurBufferedInputs();
		}
	}

	simulated function PossiblyDoAComboAttackFromOurBufferedInputs()
	{	
		local NanoPawn NP;

		NP = NanoPawn(Instigator);

		// If we had chosen a combo
// 		if( ( DesiredComboIdx >= 0 ) && ( bAttackRecover_AllowTransitionToBaseAttack == FALSE ) )
// 		{
// 			`log( "Rechoosing DesiredComboIdx" @ `showvar(DesiredComboIdx) @ "for" @ `showvar(AttackIdx) );
// 
// 			// Try to rechoose a combo given our previous input (in case target has moved/died etc)
// 		//	DesiredComboIdx = ResolveComboAttackIndex( AttackIdx );
// 			`log( "   Chose:" @ `showvar(DesiredComboIdx) );
// 		}

		if( bAttackRecover_AllowTransitionToBaseAttack == FALSE ) 
		{
			if( BufferedComboInput.ButtonPressed != GB_Max )
			{
				ComboInput = BufferedComboInput;

				DesiredComboIdx = ResolveComboAttackIndex( AttackIdx );

				BufferedComboInput.ButtonPressed = GB_Max;
			}

		}

		`log( `showvar(DesiredComboIdx) );

		//we need to check for ( bAttackRecover_AllowTransitionToBaseAttack == TRUE ) and then just do the base attack

		//// check here for why this is active on after the attack and button
		if( ( DesiredComboIdx >= 0 ) )
		{
			NP.RunningFullBodySlot.StopCustomAnim(0.1f);
			NP.FallingFullBodySlot.StopCustomAnim(0.1f);
			NP.FullBodySlot.StopCustomAnim(0.1f);
			if (ComboCount > 1)
			{
				NP.GetPRI().AwardXP(ComboCount * 1.5, "Combo");
			}
			ComboCount++;
			// Set combo target to pending target found in ResolveComboAttackIndex
			ComboTargetedActor = PendingComboTargetedActor;
			PendingComboTargetedActor = None;
			`log( "StartMeleeAttack" @ `showvar(DesiredComboIdx) );
			ScriptTrace();
			// Execute the melee attack
			StartMeleeAttack(DesiredComboIdx);
		}
		else
		{
			// hack?
			if( ( DesiredComboIdx == -1 )
				&& ( bAttackRecover_AllowTransitionToNextCombo == FALSE )
				&& ( bAttackRecover_AllowTransitionToBaseAttack == FALSE )
				)
			{
				// do nothing
				if( NP.IsHumanControlled() == FALSE )
				{
					SetTimer(0.0001,FALSE,nameof(FinishMeleeAttack)); // laugh this is so just insane
				}
				else
				{
					`log( "Doing nothing" @ `showvar(NP) );
					ScriptTrace();
					SetTimer(0.0001,FALSE,nameof(FinishMeleeAttack)); // laugh this is so just insane
				}
			}
			else
			{
				`log( "PostAttackDelay calling FinishMeleeAttack " @ `showvar(FMax(0.0001,WeaponSheet.MeleeAttacks[AttackIdx].PostAttackDelay)) @ `showvar(DesiredComboIdx) @ `showvar(bAttackRecover_AllowTransitionToNextCombo) @ `showvar(bAttackRecover_AllowTransitionToBaseAttack) );

				SetTimer(0.0001,FALSE,nameof(FinishMeleeAttack)); // laugh this is so just insane
				ScriptTrace();
			}
		}
	}


	/** Starts a new attack, el big kahuna, etc */
	simulated function StartMeleeAttack(int NewAttackIdx)
	{
		local NanoPawn NP;
		local NanoPC PC;
		local int Idx;

		bAttackRecover_AllowTransitionToBaseAttack = FALSE;
		bAttackRecover_AllowTransitionToNextCombo = FALSE;

		bCurrentHitConnected = FALSE;
		bTargetDodgedDuringHit = FALSE;

		NP = NanoPawn(Instigator);
		NP.LastSwordComboCount = ComboCount;
		NP.bPreventRotationInputInMeleeAttack = FALSE;
		NP.SetThirdPersonCamera( TRUE );

		PC = NanoPC(Instigator.Controller);
		if( PC != None )
		{
			PC.bPlayerSelectedMeleeTarget = (Abs(ComboInput.RawJoyUp) > 0.2f || Abs(ComboInput.RawJoyRight) > 0.2f);
		}

		for( Idx = 0; Idx < PSC_Trail.Length; Idx++ )
		{
			if( PSC_Trail[Idx] != None )
			{
				PSC_Trail[Idx].ActivateSystem();
			}
		}

		// Reset flags
		DesiredComboIdx = -1;
		bHasDoneDamage = FALSE;
		bComboWindowOpen = FALSE;
		bComboWindowActivateNextCombo = FALSE;
		VictimList.Length = 0;
		ClearTimer( nameof(ResetMeleeAttackAnimDuration) );
		BufferedComboInput.ButtonPressed = GB_Max;

		// ensure the attack is valid
		AttackIdx = Min(WeaponSheet.MeleeAttacks.Length-1,NewAttackIdx);
		LastAttackName = WeaponSheet.MeleeAttacks[AttackIdx].AttackName;
		AttackStartTime = WorldInfo.TimeSeconds;

		`sword_log(`location@`showvar(AttackIdx)@`showvar(LastAttackName)@`showvar(ComboCount) );
		`log("DOING ATTACK:" @ LastAttackName @ `showvar(ComboCount) @ WeaponSheet.MeleeAttacks[AttackIdx].HitReaction[0].Damage );

		ExecuteMeleeAttack( NP );
	}

	/** Actually plays the melee attack animation */
	simulated function ExecuteMeleeAttack( NanoPawn NP )
	{
		`sword_log(`location@`showvar(AttackIdx)@`showvar(bUpdateAttackerRotation)@`showvar(bReleasedThumbStick));

		NP.bIsDoingMeleeAttack = TRUE;
		NP.bIsDoingAttack = TRUE;
		NP.bRecoveringFromMeleeAttack = FALSE;
		NP.bPreventMoveInMeleeAttack = TRUE;
		NP.bPreventJumpInMeleeAttack = FALSE;
		NP.bPreventRotationInputInMeleeAttack = TRUE;

		UpdateAttackerDesiredRotation( bUpdateAttackerRotation );
		bUpdateAttackerRotation = FALSE;
		bReleasedThumbStick = FALSE;
		bSlomoChecked = FALSE;
		bAllowSlomo = FALSE;
		PreviousTimeDilation = WorldInfo.TimeDilation;
		
		// start the attack anim
		PlayAttackAnim();
	}

	simulated function FinishMeleeAttack( optional bool bLeavingState )
	{
		local NanoPawn NP;
		local NanoPC PC;
		local Vector CamLoc;
		local Rotator CamRot;
		local int Idx;

		NP = NanoPawn(Instigator);

		`log( "---> NO COMBO RESETING WORLD STATE" );
		//ScriptTrace();

		`sword_log(`location@`showvar(DesiredComboIdx));

		for( Idx = 0; Idx < PSC_Trail.Length; Idx++ )
		{
			if( PSC_Trail[Idx] != None )
			{
				PSC_Trail[Idx].DeactivateSystem();
			}
		}

		DesiredComboIdx = -1; // need to reset this or we will have residual combo "capability"
		AttackIdx = -1; // need to reset this or we will have residual combo "capability"

		bAttackRecover_AllowTransitionToBaseAttack = FALSE;
		bAttackRecover_AllowTransitionToNextCombo = FALSE;

		bSlashDamaging = FALSE;
		bSlashEffects = FALSE;
		bDoSwordDamageEffect = FALSE;
		HitNanoPawnsPlayEffectsOn.Remove( 0, HitNanoPawnsPlayEffectsOn.Length );
		NP.bIsDoingMeleeAttack = FALSE;
		NP.bIsDoingAttack = FALSE;

		CheckForExtraNoAttackDueToLongAnimDuration();

		NP.bRecoveringFromMeleeAttack = FALSE;
		NP.bPreventJumpInMeleeAttack = FALSE;
		NP.bPreventMoveInMeleeAttack = TRUE;
		NP.bPreventRotationInputInMeleeAttack = TRUE;
		NP.bLockPawnRotation = FALSE;
		NP.bIsDoingStabMantle = FALSE;
		NP.bIsSwordDashing = FALSE;
		NP.RunningFullBodySlot.StopCustomAnim(0.25f);
		NP.FallingFullBodySlot.StopCustomAnim(0.25f);
		NP.FullBodySlot.StopCustomAnim(0.25f);

		PendingComboTargetedActor = None;
		ComboTargetedActor = None;

		ComboInput.ButtonPressed = GB_Max;
		BufferedComboInput.ButtonPressed = GB_Max;

		WeaponSheet.SetAttackAnimState( AAS_None );


		PC = NanoPC(NP.Controller);
		if( PC != None && !Instigator.InFreeCam() )
		{
			PC.GetActorEyesViewPoint(CamLoc,CamRot);
			CamRot.Yaw = NP.Rotation.Yaw;
			//removed for now because it causes a pop with camera rotation
			//PC.SetRotation( CamRot );
		}

		if( !bCurrentHitConnected )
		{
			// If we completely missed anything, fire off an event
			Whiffed();
		}

		EndFire(CurrentFireMode);

		if( !bLeavingState )
		{
			GotoState('Active');
		}
	}


	simulated function CheckForExtraNoAttackDueToLongAnimDuration()
	{
		// so if this is an attack which will cause our AI to not attack then we are going to add ExtraWaitOnLongMeleeAnimations to it to make it really stop
		// the AI from attacking
		if( NanoPawn(Instigator).MeleeAttackAnimDuration > class'NanoAI_Trooper'.default.DurationOfMeleeAttackAnimToForceNotAttacking )
		{
			//`log( "SetTimer for ResetMeleeAttackAnimDuration" );
			SetTimer( class'NanoAI_Trooper'.default.ExtraWaitOnLongMeleeAnimations, FALSE, nameof(ResetMeleeAttackAnimDuration) );
		}
		else
		{
			ResetMeleeAttackAnimDuration();
		}
	}

	event TrailsNotify( const AnimNotify_Trails AnimNotifyData )
	{
		local TrailSample SamplePoint;
		local vector SlashDamageLeadEdge;
		local vector SlashDamageRearEdge;
		local int NotifyIdx;
		local Matrix SourceMatrix;
		
		bSlashDamaging = TRUE;
		bFirstDamageTick = TRUE;
		bHasDoneDamage = FALSE;
		NotifySetSlashDamagingOn();

		SamplePoint = AnimNotifyData.TrailSampledData[0];
		SourceMatrix = Instigator.Mesh.GetTransformMatrix();
		SlashDamageRearEdge = TransformVector(SourceMatrix, SamplePoint.FirstEdgeSample);
		SlashDamageLeadEdge = TransformVector(SourceMatrix, SamplePoint.SecondEdgeSample);

		NotifyIdx = ActiveDamageNotifies.Length;
		ActiveDamageNotifies.Length = NotifyIdx + 1;

		ActiveDamageNotifies[NotifyIdx].Notify				= NanoAnimNotify_MeleeDamage(AnimNotifyData);
		ActiveDamageNotifies[NotifyIdx].LastDamageTime		= AnimNotifyData.CurrentTime;
		ActiveDamageNotifies[NotifyIdx].LastDamagePosition	= MatrixGetOrigin(Instigator.Mesh.LocalToWorld);
		ActiveDamageNotifies[NotifyIdx].LastDamageRotation	= QuatFromRotator(MatrixGetRotator(Instigator.Mesh.LocalToWorld));
		ActiveDamageNotifies[NotifyIdx].OldWeaponBase		= SlashDamageRearEdge;
		ActiveDamageNotifies[NotifyIdx].OldWeaponDir		= Normal(SlashDamageLeadEdge - SlashDamageRearEdge);
		ActiveDamageNotifies[NotifyIdx].LastDamageIndex		= 0;

		if( bSwordDebug )
		{
			DrawDebugBox( SlashDamageRearEdge, vect(4,4,4), 255, 0, 0, TRUE );
			DrawDebugBox( SlashDamageLeadEdge, vect(4,4,4), 0, 255, 0, TRUE );
			DrawDebugLine( SlashDamageRearEdge, SlashDamageLeadEdge, 0, 0, 255, TRUE );
		}
	}

	event TrailsNotifyTick( const AnimNotify_Trails AnimNotifyData )
	{
 		local TrailSample SamplePoint;
		local int StepIdx, NumSteps;
		local vector SlashDamageLeadEdge, SlashDamageRearEdge, DamagePosition;
		local rotator DamageRotator;
		local quat DamageRotation;
		local matrix InterpMatrix;
		
		local vector WeaponBase, WeaponDir, CheckStart, CheckEnd;
		local array<vector> HitLocations, HitNormals;
		local vector OldBase, OldDir;
		local float WeaponCheckLen;
		local array<Actor> HitActors;
		local array<TraceHitInfo> Infos;
		local NanoPawn NP;
		local int NotifyIdx, i, Idx;
		local float CurrEndTime;
		local int ReactionID;

		NotifyIdx = GetDamageNotifyIndex( AnimNotifyData );
		if( NotifyIdx < 0 )
		{
			return;
		}
		NP = NanoPawn(Instigator);

		ReactionID = NanoAnimNotify_MeleeDamage(AnimNotifyData).ReactionID;

		CurrEndTime = AnimNotifyData.CurrentTime + AnimNotifyData.TimeStep;
		if (ActiveDamageNotifies[NotifyIdx].LastDamageIndex >= 0)
		{
			//`log(WorldInfo.TimeSeconds@"trail tick");
			NumSteps = AnimNotifyData.GetNumSteps(ActiveDamageNotifies[NotifyIdx].LastDamageIndex);

			// The current info
			if (NumSteps > 0)
			{
				DamagePosition = MatrixGetOrigin(Instigator.Mesh.LocalToWorld);
				DamageRotator  = MatrixGetRotator(Instigator.Mesh.LocalToWorld);
				DamageRotation = QuatFromRotator(DamageRotator);

				for( StepIdx = 0; StepIdx < NumSteps; StepIdx++ )
				{
					SamplePoint         = AnimNotifyData.TrailSampledData[ActiveDamageNotifies[NotifyIdx].LastDamageIndex + 1 + StepIdx];
					InterpMatrix        = Instigator.Mesh.GetTransformMatrix();
					SlashDamageRearEdge = TransformVector(InterpMatrix, SamplePoint.FirstEdgeSample);
					SlashDamageLeadEdge = TransformVector(InterpMatrix, SamplePoint.SecondEdgeSample);
					
					WeaponBase = SlashDamageRearEdge;
					WeaponDir  = SlashDamageLeadEdge - WeaponBase;
					WeaponCheckLen = VSize(WeaponDir) * WeaponSheet.MeleeAttacks[AttackIdx].AttackWeaponCheckScale;
	
					if( WeaponCheckLen <= 0.f )
					{
						`warn( "Damage notify returning zero length for WeaponCheckLen"@AnimNotifyData.AnimNodeSeq.AnimSeqName@WeaponSheet.MeleeAttacks[AttackIdx].AttackWeaponCheckScale );
					}
	
					WeaponDir /= WeaponCheckLen;
					OldBase  = ActiveDamageNotifies[NotifyIdx].OldWeaponBase;
					OldDir   = ActiveDamageNotifies[NotifyIdx].OldWeaponDir;
				
					for( i = 0; i < NumSwordLineChecks; i++ )
					{
						if( DoMeleeTraces( i, WeaponBase, WeaponDir, OldBase, OldDir, WeaponCheckLen, HitLocations, HitNormals, Infos, CheckStart, CheckEnd, HitActors, None ) )
						{
							for (Idx = 0; Idx < HitActors.Length; Idx++)
							{
								if(  HitActors[Idx] != None && 
									!HasAttackCollidedWithVictim( HitActors[Idx], ReactionID ) && 
									(Pawn(HitActors[Idx]) == None || !NP.IsSameTeam( Pawn(HitActors[Idx]) )) ) // pawncast
								{
									if( NanoInterface_Targetable(HitActors[Idx]) != None )
									{
										if( NanoInterface_Targetable(HitActors[Idx]).IsTargetable() )
										{
											//`log("attacking:"@HitActors[Idx]);
											HandleDamageCollision( NP, HitActors[Idx], HitLocations[Idx], Normal(CheckEnd - CheckStart), Infos[Idx], HitNormals[Idx], ReactionID );
											if( !bSlashDamaging )
											{
												break;
											}
										}
										else if( !Instigator.IsHumanControlled() )
										{
											// Play whiff sound, because the victim was in a non-targetable state (i.e. Ghosted)
											NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_Combat_MeleeCircle_GhostWhiff, Instigator);
										}
									}
								}
							}
						}
					}
	
					bFirstDamageTick = FALSE;
					ActiveDamageNotifies[NotifyIdx].OldWeaponBase = WeaponBase;
					ActiveDamageNotifies[NotifyIdx].OldWeaponDir = WeaponDir;
				}

				ActiveDamageNotifies[NotifyIdx].LastDamageIndex		+= NumSteps;
 				ActiveDamageNotifies[NotifyIdx].LastDamageTime		 = CurrEndTime;
 				ActiveDamageNotifies[NotifyIdx].LastDamagePosition   = DamagePosition;
				ActiveDamageNotifies[NotifyIdx].LastDamageRotation   = DamageRotation;
			}			
		}
	}

	event TrailsNotifyEnd( const AnimNotify_Trails AnimNotifyData )
	{
		local int NotifyIdx;

		NotifyIdx = GetDamageNotifyIndex( AnimNotifyData );
		if( NotifyIdx >= 0 )
		{
			ActiveDamageNotifies.Remove( NotifyIdx, 1 );
		}

		NotifySetSlashDamagingOff();
		bSlashDamaging = FALSE;
	}

	simulated function int GetDamageNotifyIndex( const AnimNotify_Trails AnimNotifyData )
	{
		local int i;

		for( i = 0; i < ActiveDamageNotifies.Length; i++ )
		{
			if( ActiveDamageNotifies[i].Notify == AnimNotifyData )
			{
				return i;
			}
		}

		return -1;
	}
}


simulated function FinishMeleeAttack( optional bool bLeavingState )
{
	`warn( "some unhandled way we got here" );
	ScriptTrace();
}


simulated function DoAreaEffectKnockback()
{
	DoSuperMoveDamage();
}

simulated function HandleSpecialEvents( Name SourceName )
{
	local int Idx;

	for( Idx = 0; Idx < WeaponSheet.MeleeAttacks[AttackIdx].SpecialEvents.Length; Idx++ )
	{
		//debug
		//`log( `location@`showvar(SourceName)@WeaponSheet.MeleeAttacks[AttackIdx].SpecialEvents[Idx] );

		if( SourceName == 'Landed' )
		{
			if( WeaponSheet.MeleeAttacks[AttackIdx].SpecialEvents[Idx] == 'OnLand_AreaKnockback' )
			{
				DoAreaEffectKnockback();
			}
		}
		else if( SourceName == 'PlayPreAttackAnim' )
		{
			if( WeaponSheet.MeleeAttacks[AttackIdx].SpecialEvents[Idx] == 'OnPlayPreAttackAnim_InterceptTarget' )
			{
				SetTimer( 0.25f, FALSE, nameof(SetVelocityToInterceptTarget) );
			}
		}
		else if( SourceName == 'PlayPreLoopAnim' )
		{

		}
		else if( SourceName == 'PlayAttackAnim' )
		{

		}
		else if( SourceName == 'PlayPostLoopAnim' )
		{

		}
		else if( SourceName == 'PlayPostAttackAnim' )
		{

		}
	}
}


simulated state Active
{
	simulated function BeginState( Name PreviousStateName )
	{
		local NanoPawn NP;

		ReflectionTime	  = -1.0;
		ReflectionDelay	  = -1.0;

		Super.BeginState( PreviousStateName );

		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			NP.SetThirdPersonCamera( TRUE );
		}
	}

	simulated function EndState( Name PreviousStateName )
	{
		Super.EndState( PreviousStateName );

		if( ( AC_SwordDragSound != none ) && ( AC_SwordDragSound.IsPlaying() == TRUE ) )
		{
			AC_SwordDragSound.FadeOut( 0.100f, 0.0f );
		}
	}
}

auto state Inactive
{
	simulated event BeginState( Name PreviousStateName )
	{
		local NanoPawn NP;

		Super.BeginState( PreviousStateName );

		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			NP.SetFirstPersonCamera();
		}
	}
}


/** State used for throwing the sword */
simulated state SwordThrow extends WeaponFiring
{
	simulated function Projectile ProjectileFire()
	{
		local NanoPawn NP;
		local float AnimTime;

		NP = NanoPawn(Instigator);

		AnimTime = NP.FullBodySlot.PlayCustomAnim('Attack_Sword_Throw_1st', 1.0, 0.05, 0.05, FALSE, TRUE);

		// Delay before actually spawning projectile
		SetTimer( AnimTime * 0.70f, FALSE, nameof(SpawnThrownSword) );

		//`sword_log( "Throwing sword" );
		return None;
	}

	/** Spawn actual sword projectile and also have pawn drop this weapon */
	simulated function SpawnThrownSword()
	{
		local NanoPC NPC;
		local NanoPawn NP;
		local NanoProj_ThrownSword SpawnedProjectile;
		local vector FireLoc, TargetLoc, AimDir;


		NP = NanoPawn(Instigator);
		if( NP == None )
		{
			return;
		}

		NPC = NanoPC(NP.Controller);
		if (NPC != None)
		{
			// Get where projectile should come from
			//FireLoc = Instigator.GetWeaponStartTraceLocation();
			Instigator.Mesh.GetSocketWorldLocationAndRotation(NanoPawn(Instigator).RightHandSocketName,FireLoc);

			// Find where to throw at
			if( NPC.TargetedActor != none )
			{
				TargetLoc = NPC.TargetedActor.Location;
				if(NanoInterface_Targetable(NPC.TargetedActor) != None)
				{
					TargetLoc = NanoInterface_Targetable(NPC.TargetedActor).GetTargetedLocation();
				}

				// Get vector from proj start to target
				AimDir = Normal(TargetLoc - FireLoc);
			}
			else
			{
				AimDir = vector(NPC.Rotation);
			}

			// Spawn thrown sword
			SpawnedProjectile = Spawn(class'NanoGame.NanoProj_ThrownSword', Self,, FireLoc);
			if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
			{
				SpawnedProjectile.Init(AimDir);
				// this is what determines if we should follow the sword or not
				if( NPC.IsButtonActive( AttackButtonOne ) == TRUE )
				{
					SpawnedProjectile.OrigViewTarget = NP;
					SpawnedProjectile.OrigController = NPC;
					NPC.FollowedThrownWeapon = SpawnedProjectile;

					NPC.SetViewTarget(SpawnedProjectile);
				}
				NPC.PlaySound(SoundCue'Weapon_Sword.Sword.Sword_Throw_Cue');
			}

			// Destroy weapon!
			NP.DiscardCurrentWeapon();
		}
	}
}

simulated function vector SweptDamageCheckExtent()
{
	return vect(10,10,10);
}

simulated function vector SweptEffectsCheckExtent()
{
	return vect(6,6,6);
}

simulated function HandleDamageCollision( NanoPawn NP, Actor HitActor, Vector HitLocation, Vector Dir, const out TraceHitInfo Info, const out vector HitNormal, optional byte ReactionID )
{
	local int DamageDone;
	local bool bPlayImpactAnim;
	local NanoPawn HitNP;
	local NanoPC PC;
	local bool bForceGore;
	local float HoldTime;
	//local SpawnedNanoEmitter BlockedEmit;

	// hack for now
	if( bHasDoneDamage == TRUE )
	{
		return;
	}


	bForceGore = FALSE;

	SetVictimCollision( HitActor, ReactionID );

	`sword_log(`showvar(HitActor) );
	HitNP = NanoPawn(HitActor);
	if( HitNP != None )
	{
		bPlayImpactAnim = TRUE;

		`sword_log(`location@`showvar(Info.HitComponent == HitNP.ShieldMeshComp));
		if( HitNP.bHasShield && Info.HitComponent == HitNP.ShieldMeshComp )
		{
			bPlayImpactAnim = FALSE;
			PlayerController(Instigator.Controller).PlaySound(SoundCue'Weapon_Sword.Sword.Sword_Impact_Shield_Cue');
		}
		else if( HitNP.CurrNanoState == ENS_Dust )
		{
			bPlayImpactAnim = FALSE;
		}

		PC = NanoPC(Instigator.Controller);
		if (PC != None && PC.IsButtonActive( ComboInput.ButtonPressed, TRUE, HoldTime ))
		{
			bForceGore = HoldTime > 0.2f;
			`log(`location@`showvar(HoldTime)@`showvar(bForceGore));
		}

		DamageDone = WeaponSheet.InitVictimReactionAnim( HitNP, AttackIdx, NP, AttackSpeedScale, HitLocation, HitNormal, Dir, ReactionID, bForceGore );
	}
	else
	{
		// And apply damage
		DamageDone = WeaponSheet.MeleeAttacks[AttackIdx].HitReaction[0].Damage;
	}
	DamageDone *= DamageScale * WeaponDamageScale;

	if( HitNP != None )
	{
		//// Logic for determining "right before hit"
		// If we are an AI then let's check to see if we should Evade this attacks
// 		if( ( NanoAIBase(HitNP.Controller) != None )  )
// 		{
// 			// this must come first as it is a "persistent" effect on the pawn
// 			if( HitNP.ShouldITurtleThisAttack() == TRUE )
// 			{
// 				HitNP.DoTheTurtle();
// 
// 				// override the anim being played now
// 				StopAttackAnim( TRUE );
// 				NP.DoSpecialMove( 'NSM_Melee_AttackBlocked', TRUE );
// 
// 				DamageDone = class'NSM_Melee_Turtle'.default.DamageToTakeWhileTurtled;
// 
// 				BlockedEmit = Spawn( class'SpawnedNanoEmitter',,, HitLocation, rotator(HitNormal) );
// 				BlockedEmit.SetTemplate( PS_Blocked, TRUE );
// 				BlockedEmit.ParticleSystemComponent.bAutoActivate = FALSE;
// 				//BlockedEmit.SetBase( Owner,, MeshToAttach, BloodSocketName );
// 				BlockedEmit.ParticleSystemComponent.ActivateSystem();
// 
// 				// if you are blocked you don't do damage.  You don't anything.  There are lots of ways to kill guys. Kill them another way
// 				// mashing buttons is not the way to play the game
// 				return;
// 			}
// 			else if( HitNP.ShouldIEvadeThisAttack() == TRUE )
// 			{
// 				HitNP.DoTheEvade();
// 				return;
// 			}
// 		}
	}


	bCurrentHitConnected = TRUE;
	HitActor.TakeDamage(DamageDone, Instigator.Controller, HitLocation, Dir, DamageCollisionDamageType, Info);

	`log( "DAMAGING!!!!!!!!!!!!" );
	ScriptTrace();

	if( HitNP != None )
	{
		DamagedTarget( HitNP, HitLocation, HitNormal );

		MakeNoise( 1.f );

		// Air: Dash to distant target
		// TODO: need to move this to the melee sheet I think
		if( AttackIdx == 8 )
		{
			NanoGRI(WorldInfo.GRI).AIBlackboard.HandleCombatEvent( NCAT_PlayerExecutedAJumpAttack, NanoAIBase(Instigator.Controller) );
		}

		if( bPlayImpactAnim )
		{
			//`log( "HIIIIIITT!  Look to do effects!" );
			if( Instigator.IsHumanControlled() == TRUE )
			{
				NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_CombatStarts );

				if( NanoPawn(Instigator) != none )
				{
					NanoPawn(Instigator).AddSomeBlood();
				}
			}

			NP.bIsInCombat = TRUE; // be wary of setting this without going through IsInCombat
			bSlashEffects = TRUE;
			HitNanoPawnsPlayEffectsOn.AddItem( HitNP );
			AddSomeBlood();

			if( bDoSwordDamageEffect == TRUE )
			{
				DoSwordDamageEffect_MissedAnimNotify();
			}

			WeaponSheet.PlayVictimImpactAnim( HitNP, AttackIdx, NP, AttackSpeedScale, HitLocation, Dir );

			// aie sounds from all over the place.
			// the tesla seems to use this for its hit effects
			if( SwordHitPawnCue != none )
			{
				PlaySound( SwordHitPawnCue );
			}

			if( HitNP.Health > 0 )
			{
				// Play sound when hitting someone
				PlayMeleeImpactSound( HitNP );

				HitNP.DeathReaction.AnimName = '';
				//PlayerController(Instigator.Controller).ClientPlayCameraShake( HitVictimShake );

				NanoGRI(WorldInfo.GRI).NGM.PossiblyDoDismemberedAndDying( HitNP, WeaponSheet.MeleeAttacks[AttackIdx].OnDeathGoreType, HitLocation, HitNormal );
			}
			// we hit a pawn and killed him and we need to do the death effects
			else
			{
				PlayMeleeImpactAndKilledSound( HitNP );

				NanoGRI(WorldInfo.GRI).NGM.ShouldPlayNanoGoreEffect( TRUE, WeaponSheet.MeleeAttacks[AttackIdx].OnDeathGoreType, HitNP, HitLocation, HitNormal, bForceGore, HitNP.DeathReaction.AnimName, bForceGore );

				HitNP.PlayDeathScreamSound();

				HitNP.NanoPawnFX.BoneNameSpawnedFrom = Info.BoneName;
				HitNP.SetTimer( 0.500f, FALSE, nameof(HitNP.NanoPawnFX.SpawnDelayedSpurtEffects), HitNP.NanoPawnFX );
			}
		}

		ActivateBloodTrail();
	}

	// Avoid hurting more than once during slash
	bHasDoneDamage = TRUE;

	// Tell the pawn we hit something, to build up combo points
	NanoPawn(Owner).RegisterSwordHit(ComboCount*ComboCount);

	HandleSpecialEvents( 'Impact' );
}


/** This will trace along the sword and then trace perpendicular from the sword length's previous location to its current. **/
final simulated function bool DoMeleeTraces
( 
	const out int i, 
	out vector WeaponBase, 
	out vector WeaponDir, 
	out Vector OldBase,
	out Vector OldDir,
	out float WeaponCheckLen, 
	out array<vector> HitLocations, 
	out array<vector> HitNormals, 
	out array<TraceHitInfo> Infos, 
	out vector CheckStart, 
	out vector CheckEnd,
	out array<Actor> HitActors,
	const SkeletalMeshComponent TraceMesh 
)
{
	local Actor HitActor;
	local float Alpha;
	local vector HitL, HitN;
	local TraceHitInfo Info;

	HitLocations.Length = 0;
	HitNormals.Length = 0;
	Infos.Length = 0;
	HitActors.Length = 0;
	// trace along the sword length
	if( i == 0 && TraceMesh == None )
	{
		CheckStart = WeaponBase;
		CheckEnd = CheckStart + (WeaponDir * WeaponCheckLen);
		foreach TraceActors(class'Actor',HitActor,HitL,HitN,CheckEnd,CheckStart,SweptDamageCheckExtent(),Info,TRACEFLAG_Bullet)
		{
			//`log("phase 1"@`showvar(HitActor));
			HitActors.AddItem(HitActor);
			HitLocations.AddItem(HitL);
			HitNormals.AddItem(HitN);
			Infos.AddItem(Info);
		}

		if( bSwordDebug )
		{
			DrawDebugBox( CheckStart, vect(4,4,4), 255, 0, 0, TRUE );
			DrawDebugBox( CheckEnd, vect(4,4,4), 0, 255, 0, TRUE );
			DrawDebugLine( CheckStart, CheckEnd, 0, 0, 255, TRUE );
		}
	}

	// trace perpendicular from the sword along the path we are swinging
	if( HitActors.Length == 0 )
	{
		// Distance along blade
		// you want to start at the tip of the blade and move toward the base
		Alpha = float(i)/float(NumSwordLineChecks-1);

		// Interpolate along old blade pos
		CheckStart = OldBase + (Alpha * OldDir * WeaponCheckLen);

		// Interpolate along current blade position
		CheckEnd = WeaponBase + (Alpha * WeaponDir * WeaponCheckLen);

		// Do line check
		if( bSwordDebug )
		{
			DrawDebugLine(CheckStart, CheckEnd, 0,255,0,TRUE);
		}

		if( TraceMesh != None )
		{
			//`log("-"@`showvar(TraceMesh));
			TraceComponent( HitL, HitN, TraceMesh, CheckEnd, CheckStart, SweptEffectsCheckExtent(), Info );
			if (Info.HitComponent != None)
			{
				HitActors.AddItem(Info.HitComponent.Owner);
				HitLocations.AddItem(HitL);
				HitNormals.AddItem(HitN);
				Infos.AddItem(Info);
			}
		}
		else
		{
			foreach TraceActors(class'Actor',HitActor,HitL,HitN,CheckEnd,CheckStart,SweptDamageCheckExtent(),Info,TRACEFLAG_Bullet)
			{
				//`log("phase 2"@`showvar(HitActor));
				HitActors.AddItem(HitActor);
				HitLocations.AddItem(HitL);
				HitNormals.AddItem(HitN);
				Infos.AddItem(Info);
			}
		}
	}


	return HitActors.Length > 0;
}


/** Do line checks along sword path for the effects we want to display */
simulated function DoSweptEffectsCheck()
{
	local vector WeaponBase, WeaponDir;
	local vector CheckStart, CheckEnd;
	local float WeaponCheckLen;
	local array<vector> HitLocations;
	local array<vector> HitNormals;
	local array<TraceHitInfo> Infos;
	local array<Actor> HitActors;
	local int i, Idx;
	local NanoPawn HitNP;

	GetTraceVars( WeaponBase, WeaponDir, WeaponCheckLen );

	for(i=0; i < HitNanoPawnsPlayEffectsOn.Length; i++)
	{
		// need to chck out each element in HitActorsPlayEffectsOn
		HitNP = HitNanoPawnsPlayEffectsOn[0];
		if (HitNP == None)
		{
			HitNanoPawnsPlayEffectsOn.Remove(0,1);
		}
		if( DoMeleeTraces( i, WeaponBase, WeaponDir, OldWeaponBase, OldWeaponDir, WeaponCheckLen, HitLocations, HitNormals, Infos, CheckStart, CheckEnd, HitActors, HitNP.Mesh ))
		{
			for (Idx = 0; Idx < HitActors.Length; Idx++)
			{
				//`log( `showvar(CheckStart) @ `showvar(CheckEnd) @ `showvar(HitLocation) );
				//DrawDebugSphere( CheckStart, 2.0f, 16, 0, 255, 0, TRUE );
				//DrawDebugSphere( CheckEnd, 2.0f, 16, 0, 0, 255, TRUE );
				//DrawDebugBox( HitLocation, vect(2,2,2), 255,0,0, TRUE );
				//DrawDebugLine( CheckStart, CheckEnd, 255,0,0, TRUE );
		
				//`log(`location@`showvar(Infos[Idx].HitComponent));
				if( Infos[Idx].HitComponent != None )
				{
					// always leave a slash mark
					PlaySliceEffects( HitNP, HitNP.Mesh, Infos[Idx], CheckStart, CheckEnd, CheckStart, CheckEnd );
					//`log( `showvar(Info.BoneName) );
					// TEARS PossiblyChopOffBone( HitNP, Info.BoneName, HitLocation );
		
					if( HitNP.Health > 0 )
					{
		
					}
					// we hit a pawn and killed him and we need to do the death effects
					else
					{
						// so where we need to break off portions of the skeleton like gears
						//PlaySwordImpactEffects( PS_Blood_DeathSpray, Info, HitNP.Mesh, HitLocation, CheckStart, HitNP );
						// TEARS PossiblyChopOffBone( HitNP, Info.BoneName, HitLocation );
					}
		
					// do no further line checks this hit
					HitNanoPawnsPlayEffectsOn.Remove( 0, 1 );
					bSlashEffects = FALSE;
					//bDoTrailSubTicking = TRUE;
					break;
				}
			}
		}

	}

	//`log( "DoSweptEffectsCheck: updating WeaponBase WeaponDir" );
	OldWeaponBase = WeaponBase;
	OldWeaponDir = WeaponDir;
}


function bool CanStunAI()
{
	return FALSE;
}

/** Called from NanoAnimNotify_ComboStart */
simulated function ComboWindowOpen()
{
	bComboWindowOpen = TRUE;
}

/** Called from NanoAnimNotify_ComboEnd */
simulated function ComboWindowClose()
{
	TurnOffSwordTipBloodTrail();
	bComboWindowOpen = FALSE;
}

simulated function AnimNotify_HandleJumpInterupt( bool bAllow )
{
	local NanoPawn NP;

	NP = NanoPawn(Instigator);
	if( NP != None )
	{
		NP.bPreventJumpInMeleeAttack = !bAllow;
	}
}

simulated function AnimNotify_HandleRotationInput( bool bAllow )
{
	local NanoPawn NP;
	NP = NanoPawn(Instigator);
	if( NP != None )
	{
		NP.bPreventRotationInputInMeleeAttack = !bAllow;
	}
}

simulated function AnimNotify_HandleMoveInterupt( bool bAllow )
{
	local NanoPawn NP;

	NP = NanoPawn(Instigator);
	if( NP != None )
	{
		NP.bPreventMoveInMeleeAttack = !bAllow;
	}
}



/** Called from NanoAnimNotify_ComboSuccessTransition */
simulated function ComboSuccessTransition();

/** Called from NanoAnimNotify_ComboFailTransition */
simulated function ComboFailTransition( bool bAllowTransDuringRecovery );

/** Called from NanoAnimNotify_ComboAllowTransition */
simulated function ComboAllowTransition( bool bAllowTransDuringRecovery );

simulated function ReachedComboTransitionPoint( optional bool bForced );


/** Called from NanoAnimNotify_ComboDeadzoneBegin/NanoAnimNotify_ComboDeadzoneEnd */
simulated function EnableDeadzone( bool bSet )
{
	bDeadZoneActive = bSet;
}

/** Called from NanoAnimNotify_ComboSlomo */
simulated function ComboSlomo( float SlomoVal )
{
	local NanoGRI GRI;
	local NanoPC NPC;

	// slomo in the middle of combat at arbitrary times is no good.  Need to have a better system for this
	// for now turning off so we can tune just normal combat without slomo at random times
	//return;

	if( Role != ROLE_Authority || !Instigator.IsHumanControlled() )
	{
		return;
	}

	GRI = NanoGRI(WorldInfo.GRI);
	if( GRI == None )
	{
		return;
	}

	if( WorldInfo.TimeDilation != SlomoVal )
	{
		NPC = NanoPC(Instigator.Controller);

		// attack is over
		// reset to the previous TimeDialation
		if( SlomoVal == 1.f )
		{
			// don't reset to 1.0f time after every melee attack.  Let the ResetGameSlomo below handle it
			//GRI.GameSlomo( SlomoVal );

			if( NPC.IsInCombat(TRUE) )
			{
				NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_CombatStarts );
			}

			NPC.SetSoundMode( 'Default' );
		}
		// start attack and possibly start the slomo
		else 
		{
			if( bAllowSlomo || (!bSlomoChecked && ShouldAllowSlomoChange( SlomoVal )) )
			{
				ComboTimeDilation = SlomoVal;

				GRI.GameSlomo( ComboTimeDilation );
				GRI.SetTimer( 3.0f*ComboTimeDilation, FALSE, nameof(GRI.ResetGameSlomo) );
				
				bAllowSlomo = TRUE;
				if( Instigator != none ) 
				{ 
					Instigator.PlaySound( ComboSlomoSound );
					NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_SlowMotionAttack );
					NPC.SetSoundMode( 'CombatSlowMotion' );
				}
			}
			bSlomoChecked = TRUE;
		}		
	}
}

simulated function bool ShouldAllowSlomoChange( float SlomoVal )
{
	if( ComboCount == ComboCountForSlomo )
	{
		return TRUE;
	}

	if( ComboTargetedActor != None )
	{
		if( FRand() < 0.35f )
		{
			//return TRUE;
		}
	}

	return FALSE;
}

simulated function UpdateByCombatStance( bool bInCombatStance );

/** Draw sword debug info on screen */
simulated function DrawSwordDebugInfo(Canvas Canvas)
{
	Canvas.SetDrawColor(255,64,128);
	Canvas.SetPos(400, 500);
	Canvas.DrawText("DMG:"@bSlashDamaging);
}

/** Do the radial damage/knockdown for a supermove */
simulated function DoSuperMoveDamage()
{
	local NanoPawn NP;
	local Pawn Victim;
	local Actor HitA;
	local Controller Causer;
	local vector HitL, HitN, Dir;
	local Emitter GroundEffect;
	local TeslaCoil ActorToAffect;
	local float MoveScale;

	MoveScale = SuperMoveLevel/4.f;
	`sword_log(`location@`showvar(SuperMoveLevel)@`showvar(MoveScale));
	NP = NanoPawn(Instigator);
	if(NP != None)
	{
		Causer = (NP.Instigator != None ? NP.Instigator.Controller : None);
		// TEMP: do some damage -  this will be a knockdown instead
		foreach NP.CollidingActors( class'Pawn', Victim, FMax(384.f,1024.0f * MoveScale), NP.Location, TRUE )
		{
			if( ( Victim != none ) && ( Victim != NP ) )
			{
				Victim.TakeRadiusDamage( Causer, 200 * MoveScale, 512.0f * MoveScale, class'NDT_DroppingTheHammer', 1.f, NP.Location, FALSE, NP);
				if (NanoPawn(Victim) != None)
				{
					Dir = Normal(Victim.Location - Instigator.Location);
					Dir *= 512.f;
					Dir.Z = 512.f;

					NanoPawn(Victim).Knockback( Dir, TRUE, 'SuperAttack' );
				}
			}
		}

		foreach CollidingActors( class'TeslaCoil', ActorToAffect, 512.0f, NP.Location, TRUE )
		{
			ActorToAffect.SwordSuperMoveImpact();
		}


		// Play sound and do screen shake
		PlayerController(NP.Controller).PlaySound(SuperMoveImpactSound);
		PlayerController(NP.Controller).ClientPlayForceFeedbackWaveform(SuperMoveImpactWaveForm);

		// Spawn effect on ground
		HitA = NP.Trace( HitL, HitN, NP.Location - vect(0,0,512), NP.Location, FALSE );
		if( HitA != None )
		{
			GroundEffect = NanoGRI(WorldInfo.GRI).NOP.GetImpactEmitter( SuperMoveImpactEffect, HitL, rot(0,0,0));
			GroundEffect.SetDrawScale( SuperMoveLevel );
			GroundEffect.ParticleSystemComponent.ActivateSystem();
		}
	}
}

/**
 *	Description: Initialize reflect level and start timer to update it
 *	Network: Both server and client
 */
simulated function StartReflect()
{
	//debug
	`log( self@"StartReflect", bDebugReflect );

	// play a sound.  if we successfully reflect, this sound will be overridden, which is groovy
	PlaySound( ReflectSound );

	ReflectionTime		 = default.ReflectionTime;
	ReflectionDelay		 = default.ReflectionDelay;
	ActiveReflectTime	 = default.ActiveReflectTime;
	bBonusAdded			 = FALSE;
	LastReflectStartTime = WorldInfo.TimeSeconds;

	// Owning client determines if they reflected projectiles
	// Reset highest active window
	if( IsOwningClient() )
	{
		// If successfully reflected initial shot
		if( ReflectProjectiles() )
		{
			// Add bonus time to active reflect time
			bBonusAdded		   = TRUE;
			ActiveReflectTime += ReflectSuccessCount * BonusReflectTime;
			ReflectSuccessCount++;

			//debug
			`logd( self@"ReflectBonus - A"@ReflectSuccessCount, bDebugReflect );
		}

		SetTimer( BonusTimeOut, FALSE, nameof(ResetReflectBonus) );
	}
}

simulated function ResetReflectBonus()
{
	//debug
	`logd( self@"ResetReflectBonus", bDebugReflect );

	ReflectSuccessCount = 0;
}

/**
 *	Description: Resets the reflection index and cancels update timer
 *	Network: Both server and client
 */
simulated final function StopReflect()
{
	//debug
	`log( self@"StopReflect"@CancelOnReflectLevel@bBonusAdded, bDebugReflect );

	ReflectionTime	  = -1.0;
	if( CancelOnReflectLevel < 0 && !bBonusAdded )
	{
		ResetReflectBonus();
	}
}

final reliable server function ServerReflectProjectile( NanoProjectile Proj, int Idx, float Ratio, int AngleDev, bool bLeft )
{
//	local float DmgScale, KnockScale;
	local Pawn ReflectVictim;

	//debug
	`log( Proj@"ServerReflectProjectiles - Ratio"@Ratio@"AngleDev"@AngleDev@"Left?"@bLeft@"Idx"@Idx, bDebugReflect );

	if( Proj == None || Instigator == None || (Proj.Instigator != None && Instigator.IsSameTeam(Proj.Instigator)) )
	{
		return;
	}

//	DmgScale	 = Lerp( ProjReflectList[Idx].HurtScale.X, ProjReflectList[Idx].HurtScale.Y, Ratio );
//	KnockScale	 = Lerp( ProjReflectList[Idx].PushScale.X, ProjReflectList[Idx].PushScale.Y, Ratio );

/*	// notify AI of the reflected projectile
	if( Proj.Instigator != None &&
		Proj.Instigator.Controller != None &&
		Proj.Instigator.Controller.IsA('UCBot'))
	{
		Proj.Instigator.Controller.ReceiveWarning(Instigator,P);
	}*/

	ReflectVictim = Proj.Instigator;

	// Tell projectile to reflect with adjustments to speed/damage/stun
	Proj.Reflect( Instigator, ReflectProjFOV, Ratio, AngleDev, bLeft, Idx, class, 0.0 );

	// Play appropriate fx/sounds
	PlayReflect(Proj.Location, Proj.Rotation, ProjReflectList[Idx].Level, REFLECT_TYPE_PROJECTILE, ReflectVictim);

/*
		// Make instigator take damage from a bad reflect
		if( DmgScale > 0.0 )
		{
			Instigator.TakeDamage(
				Proj.Damage * DmgScale,
				Proj.Instigator,
				Proj.Location,
				(Proj.Velocity / Proj.Speed) * Proj.MomentumTransfer * KnockScale,
				Proj.MyDamageType,
				Proj.StunTime,,
				(Proj.ReflectCount != 0) );
		}
*/

}


/**
 *	Description: Looks for any projectile in the world projectile list
 *	to see if they should be reflected. If successfully reflected
 *	tells the projectile to alter direct/damage/etc.
 *	Network: Client only
 */
simulated final function bool ReflectProjectiles( optional bool bActiveTime )
{
	local bool				bReflected, bLeft;
	local NanoProjectile	Proj;
	local float				ProjDist, Ratio;
	local int				i, AngleDev;
	local Pawn				ReflectVictim;

	// Exit early if this melee weapon can't reflect projectiles at all
	if( !bCanReflectProjectiles || Instigator == None )
	{
		return FALSE;
	}

	// For each entry in world projectile list
	ForEach DynamicActors(class'NanoProjectile', Proj)
	{
		// Don't allow reflect of teammates
		if( Proj.Instigator != None && Instigator.IsSameTeam(Proj.Instigator) )
			continue;

		i = ValidReflectProj( Proj, 0, bActiveTime, ProjDist, Ratio );
		if( i > -1 )
		{
			// Figure out the angle deviation and pass around to keep consistent
			AngleDev = RandRange( -ProjReflectList[i].AngleDeviation, ProjReflectList[i].AngleDeviation );
			bLeft	 = (FRand() > 0.5);

			//debug
			`log( "Reflect!!!"@`showvar(Proj)@`showvar(Ratio)@`showvar(AngleDev)@`showvar(bLeft)@`showvar(bActiveTime), bDebugReflect );

			ReflectVictim = Proj.Instigator;
			// Tell server of successful reflect (This makes me feel dirty)
			ServerReflectProjectile( Proj, i, Ratio, AngleDev, bLeft );
			if( Role < ROLE_Authority )
			{
				// Tell projectile to reflect with adjustments to speed/damage/stun
				Proj.Reflect( Instigator, ReflectProjFOV, Ratio, AngleDev, bLeft, i, class, ReflectProjDelay );

				// Play appropriate fx/sounds
				PlayReflect(Proj.Location, Proj.Rotation, ProjReflectList[i].Level, REFLECT_TYPE_PROJECTILE, ReflectVictim);
			}

			bReflected = TRUE;
		}
	}

	return bReflected;
}


/**
 *	Description: Handles all effects/sounds triggered by a successful reflect.
 *
 *	Input:	Vector	EffectLocation - Location to create the effect
 *		Rotator EffectRotation - Rotation to create the effect
 *		int ReflectLevel - level of the reflect (perfect, good, etc)
 *		byte ReflectType - type of reflect (instant, melee, or projectile)
 *		Pawn ReflectVictim - the pawn whose shots we reflected
 *		bool bShowEffects - whether or not to play reflect effect/sound
 *	Network: Both server and client
 */
simulated final function PlayReflect
(
	 Vector		EffectLocation,
	 Rotator	EffectRotation,
	 int		ReflectLevel,
	 Byte		ReflectType,
	 Pawn		ReflectVictim,
	 optional bool bShowEffects
)
{
	local NanoPawn NP;

	NP = NanoPawn(Instigator);
	if( NP == None || ReflectLevel < 0 )
		return;

	//debug
	`log( self@"PLAYREFLECT"@ReflectLevel, bDebugReflect );

	if( bShowEffects )
	{
		WorldInfo.MyEmitterPool.SpawnEmitter( PS_Reflect, EffectLocation, EffectRotation );
	}

	if( Role == ROLE_Authority )
	{
		// Play reflect sound
		// use reflect type sound if we don't have a specific sound for this level of reflect
		if( `TimeSince(LastReflectSoundTime) > 0.5f)
		{
			Instigator.PlaySound( ReflectLevelSound[ReflectLevel], TRUE );
			LastReflectSoundTime = WorldInfo.TimeSeconds;
		}
	}

	// If reflect level is sufficient to cause cancel
	if( CancelOnReflectLevel >= 0 && ReflectLevel >= CancelOnReflectLevel )
	{
		CancelReflect( TRUE );
	}

	if( ReflectLevel == REFLECT_LEVEL_PERFECT )
	{
		LastPerfectReflectTime = WorldInfo.TimeSeconds;
	}
}

simulated final function CancelReflect( optional bool bKillDelay )
{
	//debug
	`log( self@"CancelReflect"@bKillDelay, bDebugReflect );

	if( bKillDelay )
	{
		ReflectionDelay = -1.0;
	}
	else if( CancelOnReflectLevel > -1 )
	{
		ResetReflectBonus();
	}
}

/**
 *	Can we activate reflect? Make sure not already reflecting
 *	NETWORK: Server/Client, should always be valid on both
 */
simulated function bool CanReflect()
{
	if( !bBonusAdded &&
		(ReflectionTime > 0.f || ReflectionDelay > 0.f) )
	{
		return FALSE;
	}

	return TRUE;
}

simulated final function int ValidReflectProj( NanoProjectile Proj, int StartIdx, bool bActiveTime, out float ProjDist, out float Ratio )
{
	local float		ViewDotVel, ViewDotProj;
	local int		i, j;
	local float		TimeToInst, Spd;
	local Vector	InstToProj, ProjSpeed, InstSpeed;
	local bool		bBadOnly, bNoPerfect;

	// Ignore invalid projectiles
	if( Proj == None || Proj.bDeleteMe )
	{
		return -1;
	}

	// Ignore if...
	if( !Proj.bReflectable							||	// not reflectable
		Proj.Physics == PHYS_None					||	// projectile is not moving
		Proj.NextReflectTime > WorldInfo.TimeSeconds		||	// has been reflected too recently
		(!bReflectProjSpawnedAfterStart && Proj.CreationTime > LastReflectStartTime) ) // was spawned after reflect started and we're not unable to reflect those
	{
		`log( `location@"failed..."@Proj.bReflectable@Proj.Physics@Proj.NextReflectTime@WorldInfo.TimeSeconds@bReflectProjSpawnedAfterStart@Proj.CreationTime@LastReflectStartTime, bDebugReflect && Proj.Physics != PHYS_None );
		return -1;
	}

	// Ignore if projectile shot by owner and proj can't hit owner
	if( Proj.Instigator == Instigator && !Proj.bBlockedByInstigator )
	{
		`log( `location@"failed... can't hit owner"@Instigator@`showvar(Proj), bDebugReflect );
		return -1;
	}

	// Get dot product of the projectiles velocity w/ view direction
	ViewDotVel = NoZDot( Vector(Instigator.GetViewRotation()), Normal(-Proj.Velocity) );
	ViewDotProj = NoZDot( Vector(Instigator.GetViewRotation()), Normal(Proj.Location - Instigator.Location) );

	// Both location and velocity must be within reflection cone
	if( ViewDotVel  >= ReflectProjFOV &&
		ViewDotProj >= ReflectProjFOV )
	{
		// If not a line of sight - exit
		if( !FastTrace( Proj.Location, Instigator.Location ) )
		{
			`log( "Failed by LOS"@`showvar(Proj), bDebugReflect );
			return -1;
		}

		// If proj was in cone but not in hallway - only allow bad reflect
		if( !InCylinder( Proj.Location, Rotator(Proj.Velocity), ReflectionWidth, Instigator.Location ) &&
			!InCylinder( Instigator.Location, Instigator.GetViewRotation(), ReflectionWidth, Proj.Location ) )
		{
			bBadOnly = TRUE;
		}

		// No perfect reflects in the active time area
		bNoPerfect = bActiveTime;

		// Determine time to target by using velocity relative to line between pawn and projectile
		InstToProj	 = (Proj.Location - Instigator.Location);
		ProjDist	 = VSize(InstToProj);
		InstToProj	/= ProjDist;
		ProjDist	-= Instigator.GetCollisionRadius();

		if( ProjDist <= 0 )
		{
			//debug
			`log( `location@"failed proj dist check..."@`showvar(Proj)@`showvar(ProjDist)@Instigator.GetCollisionRadius(), bDebugReflect );
			return -1;
		}

		InstSpeed    = ProjectOnTo(Instigator.Velocity, InstToProj);
		ProjSpeed	 = ProjectOnTo(Proj.Velocity, InstToProj);
		Spd			 = VSize(InstSpeed - ProjSpeed);
		if( Spd <= 0 )
		{
			//debug
			`log( `location@"failed speed check..."@`showvar(Proj)@`showvar(Spd)@`showvar(InstSpeed)@`showvar(ProjSpeed), bDebugReflect );
			return -1;
		}

		TimeToInst	 = ProjDist / Spd;

		// For each item in reflect info list
		for( i = StartIdx; i < ProjReflectList.Length; i++ )
		{
			// If projectile is in the time range and
			// if any level is acceptable (or if only bad is accepted and this level is bad)
			if( TimeToInst >= ProjReflectList[i].TimeRange.X &&
				TimeToInst <= ProjReflectList[i].TimeRange.Y )
			{
				//debug
				`log( `location@"found reflect range"@`showvar(i)@`showvar(TimeToInst)@ProjReflectList[i].TimeRange.X@ProjReflectList[i].TimeRange.Y, bDebugReflect );

				Ratio = 1.0 - ((TimeToInst - ProjReflectList[i].TimeRange.X) /
					(ProjReflectList[i].TimeRange.Y - ProjReflectList[i].TimeRange.X));

				// If only allow bad reflect
				if( bBadOnly )
				{
					// Search for bad reflect index and return it
					for( j = 0; j < ProjReflectList.Length; j++ )
					{
						if( ProjReflectList[j].Level == REFLECT_LEVEL_BAD )
						{
							return j;
						}
					}
				}
				else if( bNoPerfect && ProjReflectList[i].Level == REFLECT_LEVEL_PERFECT )
				{
					// Otherwise, if not allowing perfect reflects and this level is perfect
					// Search for first GOOD level and return it
					for( j = 0; j < ProjReflectList.Length; j++ )
					{
						if( ProjReflectList[j].Level == REFLECT_LEVEL_GOOD )
						{
							return j;
						}
					}
				}

				return i;
			}
		}

		//debug
		`log( `location@"failed to find reflect range"@`showvar(TimeToInst) );
	}
	else
	{
		//debug
		`log( `location@"failed fov checks..."@`showvar(Proj)@`showvar(ViewDotVel)@`showvar(ViewDotProj)@`showvar(ReflectProjFOV), bDebugReflect );

// 		DrawDebugLine(Proj.Location, Proj.Location+Vector(Instigator.GetViewRotation())*64.f, 255, 0, 0, TRUE );
// 		DrawDebugLine(Proj.Location, Proj.Location+Normal(-Proj.Velocity)*64.f, 0, 255, 0, TRUE );
// 		DrawDebugLine(Proj.Location, Proj.Location+Normal(Proj.Location - Instigator.Location)*64.f, 0, 0, 255, TRUE );
	}

	return -1;
}


function PlaySwordImpactEffects( const out ParticleSystem InPS, const out TraceHitInfo HitInfo, const out SkeletalMeshComponent HitMesh, const out vector InHitLocation, const out vector InInstigatorLocation, const Actor AttachTo )
{
	local vector BoneRelativeLocation;
	local rotator DirectionToSprayParticles, BoneRelativeRotation;
	//local ParticleSystemComponent PSC;

	//`log( "PlayFirstSwordImpactEffects" @ Actor(HitMesh.Outer) );

	DirectionToSprayParticles = rotator( InHitLocation - InInstigatorLocation );


	HitMesh.TransformToBoneSpace( HitInfo.BoneName, InHitLocation, DirectionToSprayParticles, BoneRelativeLocation, BoneRelativeRotation );


	if( AttachTo != none )
	{
		WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( InPS, HitMesh, HitInfo.BoneName, FALSE, BoneRelativeLocation, BoneRelativeRotation );
		//DrawDebugCoordinateSystem( PSC.GetPosition(), PSC.GetRotation(), 50.0f, TRUE );
	}
	else
	{
		WorldInfo.MyEmitterPool.SpawnEmitter( InPS, InHitLocation, DirectionToSprayParticles, AttachTo );
		//DrawDebugCoordinateSystem( InHitLocation, DirectionToSprayParticles, 50.0f, TRUE );
	}


	// so now this guy needs to spray some decals on the ground
	NanoGRI(WorldInfo.GRI).SpawnABloodTrail_GibExplode_Ground( InHitLocation );

}


/** This is the Delegate for the Tracing Policy for LeaveADecal **/
simulated delegate SwordSliceDecalTrace( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	out_TraceStart = BloodTraceStart;
	out_TraceDest = BloodTraceEnd;
}


/** This is the Delegate for the Decal Choice Policy for LeaveADecal **/
simulated delegate SwordSliceDecalChoice( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	local float RotationFromYaw;

	out_DecalData = class'NanoPhysicalMaterialProperty'.static.GetBloodDecalData( Physicalmaterial'NanoPhysMats.DefaultPhysMat', NDTT_SwordSlice, WorldInfo );

	//`log( `showvar(BloodRotation) );
	RotationFromYaw = ((BloodRotation.Yaw / 32767.0f ) * 360.0f);

	out_DecalRotation = RotationFromYaw;  // so here we need to find the orientation of the sword slice to the wall

	//`log( "out_DecalData" @ out_DecalData.DecalMaterial @ RotationFromYaw );
}


/** This is the Delegate for the MITV Params Policy for LeaveADecal **/
simulated delegate SwordSliceDecalTimeVaryingParams( out MaterialInstance MI_Decal )
{
}


function PlaySliceEffects( Actor HitActor, const out SkeletalMeshComponent HitMesh, const out TraceHitInfo Info, const out vector TraceStart, const out vector TraceEnd, const out vector PrevTraceStart, const out vector PrevTraceEnd )
{
	//`log( "PlaySliceEffects"  );
	//`log( "  BoneHit: " @ Info.BoneName );

	BloodTraceStart = TraceStart;

	BloodTraceEnd = TraceStart + ( Normal(TraceEnd-TraceStart) * 256 );

	BloodTraceStart = BloodTraceStart - ( Normal(BloodTraceEnd-BloodTraceStart) * 128.0f ); // move the start of the trace back some

	BloodRotation = Rotator( PrevTraceStart - PrevTraceEnd );

	//DrawDebugCoordinateSystem( BloodTraceStart, rot(0,0,0), 5.0f, TRUE );
	//DrawDebugSphere( BloodTraceEnd, 2.0f, 16, 255, 0, 0, TRUE );

	NanoGRI(WorldInfo.GRI).NEM.LeaveADecalMesh( HitActor, HitMesh, SwordSliceDecalTrace, SwordSliceDecalChoice, SwordSliceDecalTimeVaryingParams );
}



function TurnOffSwordTipBloodTrail()
{
	//`log( "TurnOffSwordTipBloodTrail:" @ PSC_Blood_SwordImpactTrail );

	if( PSC_Blood_SwordImpactTrail != none )
	{
		//DrawDebugCoordinateSystem( PSC_Blood_SwordImpactTrail.GetPosition(), PSC_Blood_SwordImpactTrail.GetRotation(), 50.0f, TRUE );

		PSC_Blood_SwordImpactTrail.SetAbsolute( TRUE, TRUE, TRUE );
		PSC_Blood_SwordImpactTrail.DeactivateSystem();
		//DetachComponent( PSC_Blood_SwordImpactTrail );
		PSC_Blood_SwordImpactTrail = none;
	}

	if( Emit_Blood_SwordImpactTrail != none )
	{
		//DrawDebugCoordinateSystem( Emit_Blood_SwordImpactTrail.Location, Emit_Blood_SwordImpactTrail.Rotation, 50.0f, TRUE );
		Emit_Blood_SwordImpactTrail.SetBase( none );
		Emit_Blood_SwordImpactTrail.ParticleSystemComponent.DeactivateSystem();
		Emit_Blood_SwordImpactTrail = none;
	}

		bDoTrailSubTicking = FALSE;
}

/** This is our function to run for SubTicking of the trails **/
simulated native function RunPhysicsSimulationTilEnd( NanoTrailProxy NTP, const out vector StartLocation, const out vector EndLocation );

/** This is called from NanoAnimNotify_SwordDamageEffect **/
function DoSwordDamageEffect()
{
	// only play an effect if we have done damage
	if( bHasDoneDamage == TRUE )
	{
		DoSwordDamageEffect_HitAnimNotify();
	}

	bDoSwordDamageEffect = TRUE;
}


/** Code to activate the blood trail on the tip of the sword **/
function ActivateBloodTrail()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;

	local AudioComponent AC_BloodSpray;

	local name BloodSocketName;
	local SkeletalMeshComponent MeshToAttach;

	GetSocketAndMeshForAnimNotifyBasedEffects( MeshToAttach, BloodSocketName );
	//`log( "kjkgjkg" @ `showvar(MeshToAttach) @ `showvar(BloodSocketName) );

	if( BloodSocketName == '' )
	{
		return;
	}


	//PlaySwordImpactEffects( PS_Blood_SwordSlash, Info, HitNP.Mesh, HitLocation, CheckStart, none );
	//PSC_Blood_SwordImpactTrail = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_Blood_SwordImpactTrail, SkeletalMeshComponent(Mesh), TrailSocket[0], TRUE );

	// spawn here locally so the emitter pool doesn't reuse the effect immediately as we want them to stay in the world for a time
	// PSC method
	//PSC_Blood_SwordImpactTrail = new(self) class'NanoParticleSystemComponent';
	//PSC_Blood_SwordImpactTrail.bAutoActivate = FALSE;
	//PSC_Blood_SwordImpactTrail.SetTickGroup( TG_PreAsyncWork );
	//PSC_Blood_SwordImpactTrail.SetTemplate( PS_Blood_SwordImpactTrail );
	//SkeletalMeshComponent(Mesh).AttachComponentToSocket( PSC_Blood_SwordImpactTrail, TrailSocket[0] );

	// Actor Source method
	//SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation( TrailSocket[0], SpawnLocation, SpawnRotation, 0 );
	//TrailProxy = Spawn( class'NanoTrailProxy',,, SpawnLocation, SpawnRotation );
	//PSC_Blood_SwordImpactTrail.SetActorParameter('TrailActor', TrailProxy);
	//TrailProxy.AttachComponent( PSC_Blood_SwordImpactTrail );

	//PSC_Blood_SwordImpactTrail.ActivateSystem();

	//FlushPersistentDebugLines();

	//AlongSwordLength = i;
	//RunPhysicsSimulationTilEnd( TrailProxy, CheckStart, CheckEnd );

	// Emitter method
	MeshToAttach.GetSocketWorldLocationAndRotation( BloodSocketName, SpawnLocation, SpawnRotation, 0 );
	Emit_Blood_SwordImpactTrail = Spawn( class'SpawnedNanoEmitter',,, SpawnLocation, SpawnRotation );
	Emit_Blood_SwordImpactTrail.SetTemplate( PS_Blood_SwordImpactTrail, TRUE );
	Emit_Blood_SwordImpactTrail.ParticleSystemComponent.bAutoActivate = FALSE;
	Emit_Blood_SwordImpactTrail.SetBase( Owner,, MeshToAttach, BloodSocketName );
	Emit_Blood_SwordImpactTrail.ParticleSystemComponent.ActivateSystem();

	//`log( "spawned" @ Emit_Blood_SwordImpactTrail );

	if( BloodSpraySound != none )
	{
		AC_BloodSpray = new(self) class'AudioComponent';
		if( AC_BloodSpray != none )
		{
			AC_BloodSpray.SoundCue = BloodSpraySound;
			MeshToAttach.AttachComponentToSocket( AC_BloodSpray, BloodSocketName );
			AC_BloodSpray.FadeIn( 0.1f, 1.0f );
		}
	}
}


private function GetSocketAndMeshForAnimNotifyBasedEffects( out SkeletalMeshComponent out_SMC, out name out_SocketName )
{
	local name BloodSocketName;
	local SkeletalMeshComponent MeshToAttach;

	switch( ActiveDamageNotifies[ActiveDamageNotifies.Length-1].Notify.MeleeImpactType )
	{
	case EMIT_Sword:
		BloodSocketName = PS_SwordBloodTrailSocketName;
		MeshToAttach = SkeletalMeshComponent(Mesh);
		break;
	case EMIT_Baton:
		BloodSocketName = PS_SwordBloodTrailSocketName;
		MeshToAttach = SkeletalMeshComponent(Mesh);
		break;
	case EMIT_ElbowLeft:
		BloodSocketName = PS_ElbowLeftBloodTrailSocketName;
		MeshToAttach = Instigator.Mesh;
		break;
	case EMIT_ElbowRight:
		BloodSocketName = PS_ElbowBloodTrailSocketName;
		MeshToAttach = Instigator.Mesh;
		break;
		case EMIT_FootLeft:
		BloodSocketName = PS_FootLeftBloodTrailSocketName;
		MeshToAttach = Instigator.Mesh;
		break;
	case EMIT_FootRight:
		BloodSocketName = PS_FootBloodTrailSocketName;
		MeshToAttach = Instigator.Mesh;
		break;
	case EMIT_Staff:
		BloodSocketName = PS_SwordBloodTrailSocketName;
		MeshToAttach = SkeletalMeshComponent(Mesh);
		break;
	case EMIT_Knife:
		BloodSocketName = PS_SwordBloodTrailSocketName;
		MeshToAttach = SkeletalMeshComponent(Mesh);
		break;

	default:
		BloodSocketName = PS_SwordBloodTrailSocketName;
		MeshToAttach = SkeletalMeshComponent(Mesh);
		break;
	}

	//`log( "GetSocketAndMeshForAnimNotifyBasedEffects" @ `showvar(BloodSocketName) @ `showvar(ActiveDamageNotifies[ActiveDamageNotifies.Length-1].Notify.MeleeImpactType) @ `showvar(MeshToAttach) @`showvar(Instigator) );

	out_SMC = MeshToAttach;
	out_SocketName = BloodSocketName;
}




protected function GetSocketAndMeshForDamagedTargetEffects( out SkeletalMeshComponent out_SMC, out name out_SocketName, out ParticleSystem out_PSToPlay )
{
	local name BloodSocketName;
	local SkeletalMeshComponent MeshToAttach;

	switch( ActiveDamageNotifies[ActiveDamageNotifies.Length-1].Notify.MeleeImpactType )
	{
	case EMIT_Sword:
		BloodSocketName = PS_SwordBloodTrailSocketName;
		MeshToAttach = SkeletalMeshComponent(Mesh);
		break;
	case EMIT_Baton:
		BloodSocketName = PS_SwordBloodTrailSocketName;
		MeshToAttach = SkeletalMeshComponent(Mesh);
		break;
	case EMIT_ElbowLeft:
		BloodSocketName = PS_ElbowLeftBloodTrailSocketName;
		MeshToAttach = Instigator.Mesh;
		out_PSToPlay = ParticleSystem'REB_Knife.Effects.P_ElbowImpact_01';
		break;
	case EMIT_ElbowRight:
		BloodSocketName = PS_ElbowBloodTrailSocketName;
		MeshToAttach = Instigator.Mesh;
		out_PSToPlay = ParticleSystem'REB_Knife.Effects.P_ElbowImpact_01';
		break;
	case EMIT_FootLeft:
		BloodSocketName = PS_FootLeftBloodTrailSocketName;
		MeshToAttach = Instigator.Mesh;
		out_PSToPlay = ParticleSystem'REB_Knife.Effects.P_FootImpact_01';
		break;
	case EMIT_FootRight:
		BloodSocketName = PS_FootBloodTrailSocketName;
		MeshToAttach = Instigator.Mesh;
		out_PSToPlay = ParticleSystem'REB_Knife.Effects.P_FootImpact_01';
		break;
	case EMIT_Staff:
		BloodSocketName = PS_SwordBloodTrailSocketName;
		MeshToAttach = SkeletalMeshComponent(Mesh);
		break;
	case EMIT_Knife:
		BloodSocketName = 'KnifeDamageControlMid';
		MeshToAttach = Instigator.Mesh; // the socket we want is on the pawn's mesh
		out_PSToPlay = ParticleSystem'REB_Knife.Effects.P_KnifeImpact_01';
		break;

	default:
		BloodSocketName = PS_SwordBloodTrailSocketName;
		MeshToAttach = SkeletalMeshComponent(Mesh);
		break;
	}

	//`log( "GetSocketAndMeshForAnimNotifyBasedEffects" @ `showvar(BloodSocketName) @ `showvar(ActiveDamageNotifies[ActiveDamageNotifies.Length-1].Notify.MeleeImpactType) @ `showvar(MeshToAttach) @`showvar(Instigator) );

	out_SMC = MeshToAttach;
	out_SocketName = BloodSocketName;
}




private function DoSwordDamageEffect_HitAnimNotify()
{
	// @todo: look this up on the physical material
	WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'REB_Sword_Effects.Effects.P_Nano_Backstab_Hit', SkeletalMeshComponent(Mesh), TrailSocket[0], TRUE, , );
}

private function DoSwordDamageEffect_MissedAnimNotify()
{
	WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'Effects_Gameplay.Blood.P_ChainSaw_Blood_SkorgeWins_01', SkeletalMeshComponent(Mesh), TrailSocket[0], TRUE, , );
}


function TurnOffPlayerAttackingMusic()
{
	if( (Role == ROLE_Authority) && ( NanoPC(Instigator.Controller) != None ) && ( NanoPC(Instigator.Controller).IsInCombat() == TRUE ) )
	{
		NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_CombatStarts );
	}
}


function AddSomeBlood();

simulated function ModifyPawnRootMotion(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
	if( IsFiring() && AttackIdx >= 0 )
	{
		ExtractedRootMotionDelta.Translation *= WeaponSheet.MeleeAttacks[AttackIdx].AttackRootMotionScale;
	}
}

function PlayMeleeImpactSound( NanoPawn HitNP )
{
	local SoundCue ImpactSound;


	switch( ActiveDamageNotifies[ActiveDamageNotifies.Length-1].Notify.MeleeImpactType )
	{
	case EMIT_Sword:
		if( bDo300Slomo == TRUE )
		{
			//`log( `showvar(HitNP.HitBySwordDismember300Sound) );
			ImpactSound = HitNP.HitBySwordDismember300Sound;
		}
		else
		{
			ImpactSound = HitNP.HitBySwordSound;
		}
		break;
	case EMIT_Baton:
		ImpactSound = HitNP.HitBySwordSound;
		break;
	case EMIT_ElbowRight:
		ImpactSound = ElbowHitPawnCue;
		break;
	case EMIT_FootRight:
		ImpactSound = FootHitPawnCue;
		break;
	case EMIT_Staff:
		ImpactSound =  HitNP.HitByStaffSound;
		break;
	case EMIT_Knife:
		ImpactSound = HitNP.HitBySwordSound;
		break;

	default:
		ImpactSound = HitNP.HitBySwordSound;
		break;
	}


	//`log( "PlayMeleeImpactSound" @ ImpactSound @ ActiveDamageNotifies[ActiveDamageNotifies.Length-1].Notify.MeleeImpactType );

	if( ImpactSound != none )
	{
		HitNP.PlaySound( ImpactSound );
	}
}


function PlayMeleeImpactAndKilledSound( NanoPawn HitNP )
{
	local SoundCue ImpactSound;

	switch( ActiveDamageNotifies[ActiveDamageNotifies.Length-1].Notify.MeleeImpactType )
	{
	case EMIT_Sword:
		ImpactSound = HitNP.HitBySwordAndKilledSound;
		break;
	case EMIT_Baton:
		ImpactSound = HitNP.HitBySwordAndKilledSound;
		break;
	case EMIT_ElbowRight:
		ImpactSound = HitNP.HitByElbowOrFootAndKilledSound;
		break;
	case EMIT_FootRight:
		ImpactSound = HitNP.HitByElbowOrFootAndKilledSound;
		break;
	case EMIT_Staff:
		ImpactSound = HitNP.HitByElbowOrFootAndKilledSound;
		break;
	case EMIT_Knife:
		ImpactSound = HitNP.HitBySwordAndKilledSound;
		break;

	default:
		ImpactSound = HitNP.HitByStaffAndKilledSound;
		break;
	}

	//`log( "PlayMeleeImpactAndKilledSound" @ ImpactSound @ ActiveDamageNotifies[ActiveDamageNotifies.Length-1].Notify.MeleeImpactType );

	if( ImpactSound != none )
	{
		HitNP.PlaySound( ImpactSound );
	}
}


simulated function ResetMeleeAttackAnimDuration()
{
	//`log( "ResetMeleeAttackAnimDurationResetMeleeAttackAnimDurationResetMeleeAttackAnimDurationResetMeleeAttackAnimDuration" );
	NanoPawn(Instigator).MeleeAttackAnimDuration = 0.0f; // @see NanoAICmd_Trooper_Melee_Engage.AmIAllowedToAttack
}


function NotifySetSlashDamagingOn();

/** Called when an attack fails to hit an enemy */
simulated function Whiffed();

/** Called when we damaged the target **/
function DamagedTarget( NanoPawn HitNP, vector HitLocation, vector HitNormal );

function NotifySetSlashDamagingOff();



simulated function RecoveryBegins()
{
	`log( "RecoveryBegins" );

	bAttackRecover_AllowTransitionToNextCombo = FALSE;

}


simulated function AttackRecover_AllowTransitionToBaseAttack()
{
	`log( "AttackRecover_AllowTransitionToBaseAttack" );


	// hack
	if( WeaponSheet.AttackAnimState == AAS_None )
	{
		`log( "race condition guard triggered" );
		return;
	}

	// need to set some bool where we will look at it later
	bAttackRecover_AllowTransitionToBaseAttack = TRUE;

	// bail out of there is no buffered button pressed
	if( BufferedComboInput.ButtonPressed == GB_Max )
	{
		return;
	}

	`log( "BUFFERED TRANSITION" );
	`log( "BUFFERED TRANSITION" );	`log( "BUFFERED TRANSITION" );	`log( "BUFFERED TRANSITION" );	`log( "BUFFERED TRANSITION" );	`log( "BUFFERED TRANSITION" );	`log( "BUFFERED TRANSITION" );	`log( "BUFFERED TRANSITION" );	`log( "BUFFERED TRANSITION" );	`log( "BUFFERED TRANSITION" );

	`log( `showvar(BufferedComboInput.ButtonPressed) );
	
	HACKHACK_AllowInstantTransitionOnEndHoldPose = FALSE;

	WeaponSheet.UpdateAttackAnimState();

	ComboInput = BufferedComboInput;

	DesiredComboIdx = ResolveMeleeAttackIndex(); // Try to resolve our base attack

	ReachedComboTransitionPoint( TRUE );

	BufferedComboInput.ButtonPressed = GB_Max;

}

simulated function AttackRecover_AllowTransitionToNextCombo()
{
	`log( "AttackRecover_AllowTransitionToNextCombo" );
	// need to set some bool where we will look at it later
	bAttackRecover_AllowTransitionToNextCombo = TRUE;

	ProcessBufferedComboInput();
}


simulated function ProcessBufferedComboInput()
{
	// bail out of there is no buffered button pressed
	if( BufferedComboInput.ButtonPressed == GB_Max )
	{
		return;
	}

	`log( "ProcessBufferedComboInput GOIIING" );	`log( "ProcessBufferedComboInput GOIIING" );	`log( "ProcessBufferedComboInput GOIIING" );	`log( "ProcessBufferedComboInput GOIIING" );	`log( "ProcessBufferedComboInput GOIIING" );	`log( "ProcessBufferedComboInput GOIIING" );	`log( "ProcessBufferedComboInput GOIIING" );	`log( "ProcessBufferedComboInput GOIIING" );	`log( "ProcessBufferedComboInput GOIIING" );

	`log( `showvar(BufferedComboInput.ButtonPressed) );

	HACKHACK_AllowInstantTransitionOnEndHoldPose = FALSE;

	WeaponSheet.UpdateAttackAnimState();

	ComboInput = BufferedComboInput;

	DesiredComboIdx = ResolveComboAttackIndex( AttackIdx );

	ReachedComboTransitionPoint( TRUE );

	BufferedComboInput.ButtonPressed = GB_Max;

}


final simulated function BufferedInputAllow()
{
	`log( "BufferedInputAllow" );

	bBufferedInputAllowed = TRUE;
}

final simulated function BufferedInputClear()
{
	`log( "BufferedInputClear" );

	BufferedComboInput.ButtonPressed = GB_Max;
}

final simulated function BufferedInputDisallow()
{
	`log( "BufferedInputDisallow" );

	bBufferedInputAllowed = FALSE;
}




simulated state Grabbing extends Attacking
{
	simulated function EndState( Name NextStateName )
	{
		local NanoPawn NP;

		Super.EndState( NextStateName );

		ClearTimer(nameof(FinishMeleeAttack));

		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			NP.EndSpecialMove();
		}
	}

	simulated function bool CanSwitchAwayFromWeapon()
	{
		return FALSE;
	}

	/** Called from FireAmmunition - only once when state begins, because RefireCheckTimer is empty (see above) */
	simulated function CustomFire()
	{
		FillComboInput();
		// Set combo target to pending target found in ResolveComboAttackIndex
		ComboTargetedActor = FindComboTarget();
		PendingComboTargetedActor = None;

		ExecuteGrabAttack( NanoPawn(Instigator) );
	}

	/** Actually plays the melee attack animation */
	simulated function ExecuteGrabAttack( NanoPawn NP )
	{
		NP.bIsDoingMeleeAttack = TRUE;
		NP.bIsDoingAttack = TRUE;
		NP.bRecoveringFromMeleeAttack = FALSE;

		UpdateAttackerDesiredRotation( bUpdateAttackerRotation );
		bUpdateAttackerRotation = FALSE;
		NP.SetDesiredRotation( AttackerDesiredRotation, FALSE, FALSE, 0.1f );
		// Immediately snap to desired rotation when attack starts (update in tick afterward)
		NP.SetRotation( AttackerDesiredRotation );

		// Reset flags
		DesiredComboIdx = -1;
		bHasDoneDamage = FALSE;
		bComboWindowOpen = FALSE;
		bComboWindowActivateNextCombo = FALSE;
		bReleasedThumbStick = FALSE;
		bSlomoChecked = FALSE;
		bAllowSlomo = FALSE;
		VictimList.Length = 0;

		NP.DoSpecialMove( 'NSM_Melee_GrabAttempt', TRUE );
	}

	simulated function HandleDamageCollision( NanoPawn NP, Actor HitActor, Vector HitLocation, Vector Dir, const out TraceHitInfo Info, const out vector HitNormal, optional byte ReactionID )
	{
		local NSM_Melee_GrabAttempt GA;

		GA = NSM_Melee_GrabAttempt(NP.ActiveSpecialMove);
		if( GA != None )
		{
			GA.HandleDamageCollision( HitActor, HitLocation, Dir, Info, HitNormal );
		}

		// Avoid hurting more than once during slash
		bHasDoneDamage = TRUE;
		// Do no further line checks this swing
		bSlashDamaging = FALSE;
	}

	simulated function GetTraceVars( out vector WeaponBase, out vector WeaponDir, out float WeaponCheckLen )
	{
		local NanoPawn NP;

		NP = NanoPawn(Instigator);

		WeaponBase = NP.Mesh.GetBoneLocation( 'b_MF_Head' );
		WeaponDir = Vector(NP.Rotation);
		WeaponCheckLen = 128.f;
	}

	simulated function UpdateAttackerDesiredRotation( optional bool bCheckPlayerInput )
	{
		local int AttackerIdx;
		local Actor OtherAttacker;
		local NanoPawn NP;

		AttackerDesiredRotation = Instigator.Rotation;

		NP = NanoPawn(Instigator);
		if( NP != None && NP.InteractionPawn != None && NP.InteractionType == PAWNINTER_Grab )
		{
			// turn to face grab victim towards the next active attacker
			for( AttackerIdx = 0; AttackerIdx < NP.InteractionPawn.ActiveAttackerList.Length; AttackerIdx++ )
			{
				if( NP.InteractionPawn.ActiveAttackerList[AttackerIdx] == None )
					continue;

				OtherAttacker = NP.InteractionPawn.ActiveAttackerList[AttackerIdx].GetAttackActor();
				if( OtherAttacker == Instigator )
					continue;

				AttackerDesiredRotation = Rotator(OtherAttacker.Location - Instigator.Location);
			}
		}	
	}

	simulated function Tick( float DeltaTime )
	{
		local NanoPawn NP;

		Super.Tick( DeltaTime );

		NP = NanoPawn(Instigator);
		if( NP.ActiveSpecialMove == None )
		{
			FinishMeleeAttack();
		}
	}
}



simulated state GrabAndBeat extends Attacking
{
	simulated function EndState( Name NextStateName )
	{
		local NanoPawn NP;

		Super.EndState( NextStateName );

		ClearTimer(nameof(FinishMeleeAttack));

		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			NP.EndSpecialMove();
		}
	}

	simulated function bool CanSwitchAwayFromWeapon()
	{
		return FALSE;
	}

	/** Called from FireAmmunition - only once when state begins, because RefireCheckTimer is empty (see above) */
	simulated function CustomFire()
	{
		FillComboInput();
		// Set combo target to pending target found in ResolveComboAttackIndex
		ComboTargetedActor = FindComboTarget();
		PendingComboTargetedActor = None;

		ExecuteGrabAndBeatAttack( NanoPawn(Instigator) );
	}

	/** Actually plays the melee attack animation */
	simulated function ExecuteGrabAndBeatAttack( NanoPawn NP )
	{
		NP.bIsDoingMeleeAttack = TRUE;
		NP.bIsDoingAttack = TRUE;
		NP.bRecoveringFromMeleeAttack = FALSE;

		UpdateAttackerDesiredRotation( bUpdateAttackerRotation );
		bUpdateAttackerRotation = FALSE;
		NP.SetDesiredRotation( AttackerDesiredRotation, FALSE, FALSE, 0.1f );
		// Immediately snap to desired rotation when attack starts (update in tick afterward)
		NP.SetRotation( AttackerDesiredRotation );

		// Reset flags
		DesiredComboIdx = -1;
		bHasDoneDamage = FALSE;
		bComboWindowOpen = FALSE;
		bComboWindowActivateNextCombo = FALSE;
		bReleasedThumbStick = FALSE;
		bSlomoChecked = FALSE;
		bAllowSlomo = FALSE;
		VictimList.Length = 0;

		NP.DoSpecialMove( 'NSM_Melee_GrabAndBeatAttempt', TRUE );
	}

	simulated function HandleDamageCollision( NanoPawn NP, Actor HitActor, Vector HitLocation, Vector Dir, const out TraceHitInfo Info, const out vector HitNormal, optional byte ReactionID )
	{
		local NSM_Melee_GrabAndBeatAttempt GA;

		GA = NSM_Melee_GrabAndBeatAttempt(NP.ActiveSpecialMove);
		if( GA != None )
		{
			GA.HandleDamageCollision( HitActor, HitLocation, Dir, Info, HitNormal );
		}

		// Avoid hurting more than once during slash
		bHasDoneDamage = TRUE;
		// Do no further line checks this swing
		bSlashDamaging = FALSE;
	}

	simulated function GetTraceVars( out vector WeaponBase, out vector WeaponDir, out float WeaponCheckLen )
	{
		local NanoPawn NP;

		NP = NanoPawn(Instigator);

		WeaponBase = NP.Mesh.GetBoneLocation( 'b_MF_Head' );
		WeaponDir = Vector(NP.Rotation);
		WeaponCheckLen = 128.f;
	}

	simulated function UpdateAttackerDesiredRotation( optional bool bCheckPlayerInput )
	{
		local int AttackerIdx;
		local Actor OtherAttacker;
		local NanoPawn NP;

		AttackerDesiredRotation = Instigator.Rotation;

		NP = NanoPawn(Instigator);
		if( NP != None && NP.InteractionPawn != None && NP.InteractionType == PAWNINTER_GrabAndBeat )
		{
			// turn to face grab victim towards the next active attacker
			for( AttackerIdx = 0; AttackerIdx < NP.InteractionPawn.ActiveAttackerList.Length; AttackerIdx++ )
			{
				if( NP.InteractionPawn.ActiveAttackerList[AttackerIdx] == None )
					continue;

				OtherAttacker = NP.InteractionPawn.ActiveAttackerList[AttackerIdx].GetAttackActor();
				if( OtherAttacker == Instigator )
					continue;

				AttackerDesiredRotation = Rotator(OtherAttacker.Location - Instigator.Location);
			}
		}	
	}

	simulated function Tick( float DeltaTime )
	{
		local NanoPawn NP;

		Super.Tick( DeltaTime );

		NP = NanoPawn(Instigator);
		if( NP.ActiveSpecialMove == None )
		{
			FinishMeleeAttack();
		}
	}
}


simulated state GrabAHostage extends Attacking
{
	simulated function EndState( Name NextStateName )
	{
		local NanoPawn NP;

		Super.EndState( NextStateName );

		ClearTimer(nameof(FinishMeleeAttack));

		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			NP.EndSpecialMove();
		}
	}

	simulated function bool CanSwitchAwayFromWeapon()
	{
		return FALSE;
	}

	/** Called from FireAmmunition - only once when state begins, because RefireCheckTimer is empty (see above) */
	simulated function CustomFire()
	{
		FillComboInput();
		// Set combo target to pending target found in ResolveComboAttackIndex
		ComboTargetedActor = FindComboTarget();
		PendingComboTargetedActor = None;

		ExecuteGrabAttack( NanoPawn(Instigator) );
	}

	/** Actually plays the melee attack animation */
	simulated function ExecuteGrabAttack( NanoPawn NP )
	{
		NP.bIsDoingMeleeAttack = TRUE;
		NP.bIsDoingAttack = TRUE;
		NP.bRecoveringFromMeleeAttack = FALSE;

		UpdateAttackerDesiredRotation( bUpdateAttackerRotation );
		bUpdateAttackerRotation = FALSE;
		NP.SetDesiredRotation( AttackerDesiredRotation, FALSE, FALSE, 0.1f );
		// Immediately snap to desired rotation when attack starts (update in tick afterward)
		NP.SetRotation( AttackerDesiredRotation );

		// Reset flags
		DesiredComboIdx = -1;
		bHasDoneDamage = FALSE;
		bComboWindowOpen = FALSE;
		bComboWindowActivateNextCombo = FALSE;
		bReleasedThumbStick = FALSE;
		bSlomoChecked = FALSE;
		bAllowSlomo = FALSE;
		VictimList.Length = 0;

		NP.DoSpecialMove( 'NSM_Melee_GrabAHostageAttempt', TRUE );
	}

	simulated function HandleDamageCollision( NanoPawn NP, Actor HitActor, Vector HitLocation, Vector Dir, const out TraceHitInfo Info, const out vector HitNormal, optional byte ReactionID )
	{
		local NSM_Melee_GrabAHostageAttempt GA;

		GA = NSM_Melee_GrabAHostageAttempt(NP.ActiveSpecialMove);
		if( GA != None )
		{
			GA.HandleDamageCollision( HitActor, HitLocation, Dir, Info, HitNormal );
		}

		// Avoid hurting more than once during slash
		bHasDoneDamage = TRUE;
		// Do no further line checks this swing
		bSlashDamaging = FALSE;
	}

	simulated function GetTraceVars( out vector WeaponBase, out vector WeaponDir, out float WeaponCheckLen )
	{
		local NanoPawn NP;

		NP = NanoPawn(Instigator);

		WeaponBase = NP.Mesh.GetBoneLocation( 'b_MF_Head' );
		WeaponDir = Vector(NP.Rotation);
		WeaponCheckLen = 128.f;
	}

	simulated function UpdateAttackerDesiredRotation( optional bool bCheckPlayerInput )
	{
		local int AttackerIdx;
		local Actor OtherAttacker;
		local NanoPawn NP;

		AttackerDesiredRotation = Instigator.Rotation;

		NP = NanoPawn(Instigator);
		if( NP != None && NP.InteractionPawn != None && NP.InteractionType == PAWNINTER_Grab )
		{
			// turn to face grab victim towards the next active attacker
			for( AttackerIdx = 0; AttackerIdx < NP.InteractionPawn.ActiveAttackerList.Length; AttackerIdx++ )
			{
				if( NP.InteractionPawn.ActiveAttackerList[AttackerIdx] == None )
					continue;

				OtherAttacker = NP.InteractionPawn.ActiveAttackerList[AttackerIdx].GetAttackActor();
				if( OtherAttacker == Instigator )
					continue;

				AttackerDesiredRotation = Rotator(OtherAttacker.Location - Instigator.Location);
			}
		}	
	}

	simulated function Tick( float DeltaTime )
	{
		local NanoPawn NP;

		Super.Tick( DeltaTime );

		NP = NanoPawn(Instigator);
		if( NP.ActiveSpecialMove == None )
		{
			FinishMeleeAttack();
		}
	}
}




defaultproperties
{
	bAllowTracers=FALSE
	MuzzleSocketName=""

	FiringStatesArray(FIREMODE_Attacking)=Attacking
	WeaponFireTypes(FIREMODE_Attacking)=EWFT_Custom
	FireInterval(FIREMODE_Attacking)=0.0

	FiringStatesArray(FIREMODE_Throwing)=SwordThrow
	WeaponFireTypes(FIREMODE_Throwing)=EWFT_Projectile
	FireInterval(FIREMODE_Throwing)=0.900

	FiringStatesArray(FIREMODE_GrabAndBeat)=GrabAndBeat
	WeaponFireTypes(FIREMODE_GrabAndBeat)=EWFT_Custom
	FireInterval(FIREMODE_GrabAndBeat)=0.0

	FiringStatesArray(FIREMODE_Grab)=Grabbing
	WeaponFireTypes(FIREMODE_Grab)=EWFT_Custom
	FireInterval(FIREMODE_Grab)=0.0

	FiringStatesArray(FIREMODE_GrabAHostage)=GrabAHostage
	WeaponFireTypes(FIREMODE_GrabAHostage)=EWFT_Custom
	FireInterval(FIREMODE_GrabAHostage)=0.0




	WeaponRange=176

	NumSwordLineChecks=10
	SwordCheckLen=120.0
	FootDamageCheckLen=80.0
	ElbowDamageCheckLen=40.f

	bAllowTargeting=TRUE

	Begin Object Class=NanoCameraShake Name=HitVictimShake0
		OscillationDuration=0.3f
		RotOscillation={(Yaw=(Amplitude=35.f,Frequency=125.f),
		Roll=(Amplitude=35.f,Frequency=125.f))}
	End Object
	HitVictimShake=HitVictimShake0

	Begin Object Class=NanoCameraShake Name=HitBlockShake0
		OscillationDuration=0.3f
		RotOscillation={(Yaw=(Amplitude=35.f,Frequency=125.f),
		Roll=(Amplitude=35.f,Frequency=125.f))}
	End Object
	HitBlockShake=HitBlockShake0

	Begin Object Class=NanoCameraShake Name=HitAndKillShake0
		OscillationDuration=1.0f
		RotOscillation={(Yaw=(Amplitude=70.f,Frequency=250.f),
		Roll=(Amplitude=70.f,Frequency=250.f))}
	End Object
	HitAndKillShake=HitAndKillShake0

	PS_Reflect=ParticleSystem'Nano_WeaponFX.Sword.Effects.P_FX_Nano_Sword_Reflect'
	PS_Blocked=ParticleSystem'Nano_WeaponFX.Sword.Effects.P_FX_Nano_Sword_BlockSparks'

 	ReflectLevelSound[REFLECT_LEVEL_BAD]=SoundCue'Weapon_Orbital.Orbital.Orbital_ExplosionCue'
	ReflectLevelSound[REFLECT_LEVEL_GOOD]=SoundCue'Weapon_Orbital.Orbital.Orbital_ExplosionCue'
 	ReflectLevelSound[REFLECT_LEVEL_PERFECT]=SoundCue'Weapon_Orbital.Orbital.Orbital_ExplosionCue'
 	ReflectSound=SoundCue'Interface_Audio.Menu.MenuChoose01Cue'
	BlockedSound=SoundCue'Weapon_Sword.Sword.Sword_Impact_Metal_Cue'


	PS_Blood_DeathSpray=ParticleSystem'Effects_Gameplay.Blood.P_ChainSaw_Blood_SkorgeWins_01'
	PS_Blood_SwordSlash=ParticleSystem'Nano_BloodMilk.Blood.P_HackMilky' //ParticleSystem'Nano_Blood.Effects.P_Nano_BloodArc_01'
	PS_Blood_SwordImpactTrail=ParticleSystem'REB_Sword.Effects.P_Nano_SwordHit_01' // is the one that should be on the sword tip socket

	Begin Object Class=NanoParticleSystemComponent Name=TrailEffectComp
		bAutoActivate=FALSE
		TickGroup=TG_PostAsyncWork
	End Object
	PSC_Trail(0)=TrailEffectComp

	ComboSlomoSound=SoundCue'Weapon_Sword.Sword_Impact.Sword_SlomoAttack_Stereo_01Cue'

// 	ReflectLevelColor(0)=(R=255,G=0,B=0)
// 	ReflectLevelColor(1)=(R=0,G=0,B=255)
// 	ReflectLevelColor(2)=(R=0,G=255,B=0)

	bAutoLevelCamera=TRUE
	bAllowCameraSlide=TRUE

	bCanDashWithWeapon=FALSE

	AttackButtonOne=GB_X
	AttackButtonTwo=GB_Y
	AttackButtonThree=GB_B
}
