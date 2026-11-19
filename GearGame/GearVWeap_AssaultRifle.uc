/**
 * GearVWeap_RocketCannon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearVWeap_AssaultRifle extends GearVehicleWeapon
	config(Weapon);

/** Whether or not this weapon should spawn a decal.  Perf improvement when the AI doesn't always spawn a decal.  Especially as most of them are behind you or on the cover in front of you **/
var bool bShouldSpawnDecal;

/** Chainsaw effects */
var ParticleSystemComponent		ChainSawSmokeEffect;
/** The ChainSaw MaterialInstaneConstant**/
var MaterialInstanceConstant	ChainSawMIC;
/** AudioComponents to play sounds on */
var AudioComponent				AC_IdleLoop;
var SoundCue					SpecialMeleeAttackIdleLoopSound;

/** Chainsaw revving! **/
var bool bRevTapping;
var bool bRevReady;

// FROM REAL ASSAULT RIFLE
simulated event PostBeginPlay()
{
	//removed impact effect
	SkeletalMeshComponent(Mesh).AttachComponentToSocket(ChainSawSmokeEffect, MuzzleFlash.MuzzleSocketName);

	ChainSawMIC = new(outer) class'MaterialInstanceConstant';
	ChainSawMIC.SetParent( Material'COG_AssaultRifle.BlurringBlades' );
	Mesh.SetMaterial( 1, ChainSawMIC );

	Super.PostBeginPlay();
}

simulated function Destroyed()
{
	// Removed slashing

	// Removed ripping

	// Removed sputter

	Super.Destroyed();
}

simulated function PlayShellCaseEject()
{
	local GearPawn	GP;
	local Rotator	NewRot;

	// shell eject particle system
	if( (PSC_ShellEject != None) && (WorldInfo.NetMode != NM_DedicatedServer) )
	{
		GP = GearPawn(Instigator);

		// If pawn is mirrored, then mirror shell ejection Y axis as well
		if( GP != None )
		{
			// we need to manually flip the meshes on the emitters so they are not backwards
			if( GP.bIsMirrored )
			{
				PSC_ShellEject.SetVectorParameter( 'MeshOrientation', vect(1,1,1) );
			}
			else
			{
				PSC_ShellEject.SetVectorParameter( 'MeshOrientation', vect(0,0,0) );
			}

			// LAURENT: forced offsets, because Component.default.Property doesn't work ATM.
			if( GP.bIsMirrored )
			{
				NewRot.Yaw = 16384;
			}
			else
			{
				NewRot.Yaw = -16384;
			}

			if( PSC_ShellEject.Rotation != NewRot )
			{
				PSC_ShellEject.SetRotation(NewRot);
			}
		}

		if (IsTimerActive( 'HidePSC_ShellEject' ))
		{
			ClearTimer( 'HidePSC_ShellEject' );
			if (PSC_ShellEject != none)
			{
				PSC_ShellEject.ActivateSystem();
				PSC_ShellEject.RewindEmitterInstances();
			}
		}

		if ( PSC_ShellEject.HiddenGame )
		{
			PSC_ShellEject.SetHidden( FALSE );
			PSC_ShellEject.ActivateSystem();
		}
	}
}

simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
	if (GearPawn(Instigator) == None || !GearPawn(Instigator).bWantChainsawBash)
	{
		if (FiringMode == MELEE_ATTACK_FIREMODE)
		{
			//Cosmetic version
			StartBlade();
		}
		else if (PreviousFiringMode == MELEE_ATTACK_FIREMODE)
		{
			//Cosmetic version
			StopBlade();
		}
	}

	super.FireModeUpdated(FiringMode, bViaReplication);
}

simulated function SendToFiringState(byte FireModeNum)
{
	//Was melee bash

	Super.SendToFiringState(FireModeNum);
}

simulated state ChainsawMeleeAttacking extends MeleeAttacking
{
	simulated function BeginState(Name PreviousStateName)
	{
		SetCurrentFireMode(MELEE_ATTACK_FIREMODE);

		DoChainsawSpecialMove();
	}

	/** attempts to do the chainsaw hold move, delaying the melee attack if it's not possible right now */
	simulated function DoChainsawSpecialMove()
	{
		local GearPawn GP;

		GP = GearPawn(MyVehicle.Seats[SeatIndex].StoragePawn);
		if (GP != None)
		{
			if (GP.CanDoSpecialMove(SM_ChainsawHold))
			{
				MeleeAttackStarted();

				GP.DoSpecialMove(SM_ChainsawHold);
				SetTimer(0.5f, false, nameof(EnableRev));

				if (Role == ROLE_Authority && !bSlaveWeapon)
				{
					// Alert AI about chainsaw sound and set timer for continuation of sound
					Instigator.MakeNoise(1.f, 'MeleeAttack');
					SetTimer(0.5f, true, nameof(SpecialMeleeAttackMakeNoiseTimer));
				}
		//Remove special chainsaw adhesion
			}
			else
			{
				// if we can't do the move yet, try again later
				SetTimer(0.03, false, nameof(DoChainsawSpecialMove));
			}
		}
	}

	simulated function EndState( Name NextStateName )
	{
		local GearPawn GP;
		//`log(self@GetStateName()@GetFuncName());

		// if server or locally owned client
		GP = GearPawn(MyVehicle.Seats[SeatIndex].StoragePawn);
		if (Instigator != None && GetWeaponController() != None)
		{
			// Set up chainsaw-specific friction params
			// Removed friction

			// cancel out the hold special move
			if (GP != None)
			{
				GP.EndSpecialMove(SM_ChainsawHold);
			}
		}

		ClearTimer('SpecialMeleeAttackMakeNoiseTimer');

		Super.EndState( NextStateName );
	}

	simulated function bool HandleButtonPress( coerce Name ButtonName )
	{
		if( ButtonName == 'R2' )
		{
			// just rev
			bRevTapping = TRUE;
			return TRUE;
		}
		else
		{
			return Global.HandleButtonPress(ButtonName);
		}
	}

	simulated function Tick( float DeltaTime )
	{
		local GearPC PC;
		local GearPawn GP;

		Super.Tick( DeltaTime );

		GP = GearPawn(MyVehicle.Seats[SeatIndex].StoragePawn);
		PC = GearPC(GetWeaponController());
		if( PC != None && PC.IsLocalPlayerController() )
		{
			if (bRevTapping && bRevReady && GP != None && GP.IsDoingSpecialMove(SM_ChainsawHold))
			{
				bRevTapping = FALSE;
				bRevReady = FALSE;
				SetTimer( 0.85f,FALSE,nameof(EnableRev) );
				WeaponPlaySound(SoundCue'Weapon_AssaultRifle.Melee.ChainsawRevMediumCue');
				if (bSlaveWeapon)
				{
					ServerDoChainsawRev();
				}
			}
		}
	}

	// When melee button is released, we go back to the active state.
	// There is code in GearPawn::Tick() to prevent the button from being released if we're in the middle of an attack
	simulated function EndFire(byte FireModeNum)
	{
		Super.EndFire(FireModeNum);

		if (FireModeNum == CurrentFireMode)
		{
			GotoState('Active');
		}
	}
}

unreliable server function ServerDoChainsawRev()
{
	WeaponPlaySound(SoundCue'Weapon_AssaultRifle.Melee.ChainsawRevMediumCue');
}

simulated function EnableRev()
{
	bRevReady = TRUE;
}

simulated function WeaponStoppedFiring( byte FiringMode )
{
	super.WeaponStoppedFiring( FiringMode );

	// Stop playing weapon animation.
	FreezeWeaponAnim();

	StopMuzzleFlashEffect();
}

/** Starts the blade spinning */
simulated function StartBlade()
{
	ClearTimer('HalfStopBlade');
	ClearTimer('FullStopBlade');
	ChainSawMIC.SetScalarParameterValue( 'BladeSpeed', 1.0f);

	// Play Idle looping sound
	if( AC_IdleLoop == None )
	{
		AC_IdleLoop = GearWeaponPlaySoundLocalEx(SpecialMeleeAttackIdleLoopSound,,, AC_IdleLoop, 0.3f);
	}

	// start the smoke
	ClearTimer( 'HideSmokeEffect' );
	ChainSawSmokeEffect.SetHidden( FALSE );
	ChainSawSmokeEffect.ActivateSystem();
}

/** Stops the blade spinning */
simulated function StopBlade()
{
	ChainSawMIC.SetScalarParameterValue( 'BladeSpeed', 0.7f);
	SetTimer( 1.0f, false, nameof(HalfStopBlade) );
	SetTimer( 2.0f, FALSE, nameof(FullStopBlade) );
	// Shut down idle looping sound
	if( AC_IdleLoop != None )
	{
		AC_IdleLoop.FadeOut(0.2f, 0.f);
		AC_IdleLoop = None;
	}
	// clear the smoke
	ChainSawSmokeEffect.DeActivateSystem();
	SetTimer( 2.0f, FALSE, nameof(HideSmokeEffect) );
}

simulated function HalfStopBlade()
{
	ChainSawMIC.SetScalarParameterValue( 'BladeSpeed', 0.25f);
}
simulated function FullStopBlade()
{
	ChainSawMIC.SetScalarParameterValue( 'BladeSpeed', 0.0f);
}

simulated function HideSmokeEffect()
{
	ChainSawSmokeEffect.SetHidden( TRUE );
}

simulated function StartFire(byte FireModeNum)
{
	local Actor Target;

	// don't bother firing if the enemy is really far away
	if (GearAIController != None && FireModeNum == 0)
	{
		Target = (GearAIController.FireTarget != None) ? GearAIController.FireTarget : GearAIController.Enemy;
		if (Target != None && VSize(Target.Location - GearAIController.Pawn.Location) > Range_Long * 1.5)
		{
			return;
		}
	}

	//removed chainsaw melee/bash check

	Super.StartFire(FireModeNum);
}

/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease()
{
	local SkeletalMeshComponent	SkelMesh;
	local Vector				MagLoc;
	local Rotator				MagRot;

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Hide Ammo part on weapon mesh
	SetWeaponAmmoBoneDisplay( FALSE );

	// Spawn physics magazine instead
	SkelMesh = SkeletalMeshComponent(Mesh);
	SkelMesh.GetSocketWorldLocationAndRotation('Magazine', MagLoc, MagRot);

	// Spawn physics Magazine
	SpawnPhysicsMagazine(MagLoc, MagRot);
}


/** notification fired from Pawn animation when player grabs another magazine. */
simulated function Notify_AmmoGrab()
{
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE);
}

/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload()
{
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Detach magazine mesh from instigator's left
	SetPawnAmmoAttachment(FALSE);

	// Show Ammo part on weapon mesh.
	SetWeaponAmmoBoneDisplay(TRUE);
}

/**
* Event called when melee attack begins.
* This means when weapon is entering melee attacking state on local player and server.
* When Pawn.FiringMode == MELEE_ATTACK_FIREMODE is replicated on remote clients.
*/
simulated function MeleeAttackStarted()
{
	//removed chainsaw bash

	bUseMeleeHitTimer = false;
	// Forward event to pawn owner
	GearPawn(Instigator).MeleeAttackStarted(self);
}

simulated function SpecialMeleeAttackMakeNoiseTimer()
{
	// sometimes you can get your gun into a state where it is stuck in MeleeAttacking with no owner
	if( Instigator == None )
	{
		ClearTimer('SpecialMeleeAttackMakeNoiseTimer');
	}
	else
	{
		Instigator.MakeNoise( 0.75f, 'SpecialMeleeAttackMakeNoiseTimer' );
	}
}

/*
 * For AI controlled weapons we only spawn 1/2 decals.  For Human players we spawn 1/1 decals
 *
 * This will spawn a PhysicalMaterial based effect.	 It looks up the PhysicalMaterial
 * tree until it finds a valid effect to Spawn.	 If it does not find one then
 * it defaults the effect coded in to the .uc file for that specific weapon
 * @param TheInstigator - Pawn that fired the weapon (none from dummy fire)
 * @param Weapon - Reference to weapon (dummy fire has a weapon but no instigator, so Instigator.Weapon is not possible)
 * @param GearDmgType - damage type reference for effects
 * @param Impact - information about the impact
 * @param PhysMaterial - physical material properties for the impact
 */
simulated static function SpawnImpactDecal( Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, const out ImpactInfo Impact, PhysicalMaterial PhysMaterial )
{
	local GearWeap_AssaultRifle AR;

	// always spawn a decal for the local player
	if( TheInstigator != None && TheInstigator.IsHumanControlled() && TheInstigator.IsLocallyControlled() )
	{
		Super.SpawnImpactDecal( TheInstigator, Weapon, GearDmgType, Impact, PhysMaterial );
	}
	// 50% of the time spawn a decal for others
	else
	{
		AR = GearWeap_AssaultRifle(Weapon);
		if( AR == None || AR.bShouldSpawnDecal )
		{
			Super.SpawnImpactDecal( TheInstigator, Weapon, GearDmgType, Impact, PhysMaterial );
		}

		if (AR != None)
		{
			AR.bShouldSpawnDecal = !AR.bShouldSpawnDecal;
		}
	}
}

function float GetAIMeleeAttackRange()
{
	// override to the distance that GSM_ChainsawHold checks for targets
	return 95.0; // 64.0 sphere check, but it uses overlap so add in smallest cylinder radius
}

simulated function float GetAdjustedFOV(float BaseFOV)
{
	return BaseFOV;
}

//START VEHICLE WEAPON


simulated function PlayWeaponAnimation(Name AnimName, float Rate, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
	`log("Play Weapon Anim");

	// Play looping weapon fire animation
	if( !IsPlayingAnim(AnimName, TRUE) )
	{
		PlayWeaponAnim(AnimName, 1.f, 0.f, 0.f, TRUE);
	}
}

/**
 * Generate the tracer effect for the weapon
 *
 * @param bIsActiveReload - whether this is an active reload shot or not
 * @param bIsLocalPlayer - whether this is a local player or not
 * @param SpawnLocation - tracer originates here
 * @param SpawnRotation - tracer orientation
 * @param TargetLoc - where the tracer is ending up
 * @param InInstigator - optional actor that triggered this
 *
 * @return the projectile that is the tracer
 */
simulated static function GearProj_BulletTracer GetTracer(bool bIsActiveReload, bool bIsLocalPlayer, vector SpawnLocation, rotator SpawnRotation, vector TargetLoc,optional Actor InInstigator)
{
	local WorldInfo WI;
	local GearProj_BulletTracer NewTracer;

	WI = class'Engine'.static.GetCurrentWorldInfo();
	NewTracer = GearEmitterPool(WI.MyEmitterPool).SpawnTracer(default.TracerType, SpawnLocation, SpawnRotation, TargetLoc, bIsLocalPlayer);
	NewTracer.bAllowTracersMovingFromTarget = true;

	return NewTracer;
}

simulated state Active
{
	/** Override BeginFire so we can stop it from firing if unpossessed */
	simulated function BeginFire(byte FireModeNum)
	{
		if (Instigator.Controller != None || bDummyFireWeapon)
		{
			Super.BeginFire(FireModeNum);
		}
	}

	simulated function Tick(float DeltaTime)
	{
		local GearPC GPC;
		local GearPlayerInput GPI;
		local bool bR1Pressed;

		// poll input directly, for more robustness with with respect to when the
		// R1 button goes up/down

		GPC = (Instigator != None) ? GearPC(Instigator.Controller) : None;
		GPI = (GPC != None) ? GearPlayerInput(GPC.PlayerInput) : None;

		if (GPI != None)
		{
			bR1Pressed = GPI.IsButtonActive(GB_RightBumper);
			if (bR1Pressed)
			{
				//chainsaw rev
			}
		}

		Global.Tick(DeltaTime);
	}
}

simulated function float GetWeaponDistanceForEnemyTrace()
{
	//Really far for helicopter?
	return 30000.0f;
}

defaultproperties
{
	bWeaponCanBeReloaded=true
	bInfiniteSpareAmmo=true

	FiringStatesArray(MELEE_ATTACK_FIREMODE)=ChainsawMeleeAttacking

	InstantHitDamageTypes(0)=class'GDT_AssaultRifle'
	InstantHitDamageTypes(MELEE_ATTACK_FIREMODE)=class'GDT_ChainSaw'

	AmmoTypeClass=class'GearAmmoType_AssaultRifle'

	MeleeAttackCameraBoneAnims(0)=(AnimName="Camera_Melee_Saw_A",CollisionTestVector=(X=68.f,Y=149.f,Z=78.f))
	MeleeAttackCameraBoneAnims(1)=(AnimName="Camera_Melee_Saw_B",CollisionTestVector=(X=-36.f,Y=97.f,Z=129.f))
	MeleeAttackCameraBoneAnims(2)=(AnimName="Camera_Melee_Saw_C",CollisionTestVector=(X=68.f,Y=-162.f,Z=74.f))
	MeleeAttackCameraBoneAnims(3)=(AnimName="Camera_Melee_Saw_D",CollisionTestVector=(X=-14.f,Y=-111.f,Z=95.f))

	//SpecialMeleeAttackStartSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawStart01Cue'
	SpecialMeleeAttackIdleLoopSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawLoopIdle01Cue'
	//SpecialMeleeAttackStopSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawStop01Cue'
	//SpecialMeleeAttackSputterSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawStallCue'

	//FireSound=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopEnemyCue'			// looping
	//FireSound_Player=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopPlayerCue'	// looping
	//StopFireSound=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireStopEnemyCue'
	//StopFireSound_Player=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireStopPlayerCue'

	FireNoAmmoSound=SoundCue'Weapon_AssaultRifle.Firing.CogRifleFireEmptyCue'
	NoAmmoFireSoundDelay=0.25f

	WeaponReloadSound=None
	BulletWhipArchetype=GearBulletWhip'GearSoundGroupArchetypes.BulletWhips.AssaultRifle'

	WeaponEquipSound=SoundCue'Weapon_AssaultRifle.Actions.CogRiflePickupCue'
	WeaponDeEquipSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleLowerCue'

	//PickupSound=SoundCue'Weapon_AssaultRifle.Actions.CogRiflePickupCue'
	//WeaponDropSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleDropCue'

	AIRating=1.f

	// Weapon Animation
	WeaponFireAnim="AR_Fire"
	WeaponReloadAnim="AR_Reload"
	WeaponReloadAnimFail="AR_Reload_Fumble"

	// Weapon Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'COG_AssaultRifle.Mesh.COGAssaultRifle'
		PhysicsAsset=PhysicsAsset'COG_AssaultRifle.Mesh.COGAssaultRifle_Physics'
		AnimTreeTemplate=AnimTree'COG_AssaultRifle.AT_COG_AssaultRifle'
		AnimSets(0)=AnimSet'COG_AssaultRifle.Animations.COG_AssaultRifle'
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	FireOffset=(X=61,Y=-0.5,Z=7.25)

	// shell case ejection emitter
	Begin Object Name=PSC_WeaponShellCaseComp
		Template=ParticleSystem'COG_AssaultRifle.Effects.P_GOG_AssaultRifle_Shells'
		Translation=(X=16,Z=6)
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp

	// reload barrel smoke
	Begin Object Name=PSC_WeaponReloadBarrelSmokeComp
		Template=ParticleSystem'COG_AssaultRifle.EffectS.P_COG_AssaultRifle_Smoke'
	End Object
	PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp

	Begin Object Class=ParticleSystemComponent Name=ChainSawSmokeEffect0
		bAutoActivate=FALSE
		Template=ParticleSystem'COG_AssaultRifle.Effects.P_COG_AssaultRifle_ChainSaw_Smoke'
		TickGroup=TG_PostUpdateWork
	End Object
	ChainSawSmokeEffect=ChainSawSmokeEffect0

	Begin Object Class=StaticMeshComponent Name=MagazineMesh0
		StaticMesh=StaticMesh'COG_AssaultRifle.Assault_Rifle_Magazine'
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=FALSE
	End Object
	MagazineMesh=MagazineMesh0

	bCanDisplayReloadTutorial=TRUE
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=222,V=100,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=305,UL=128,VL=34)
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Assault'

	bInstantHit=true

	TracerType=WTT_Lancer
	TracerTypeAR=WTT_Lancer_AR

	NeedReloadNotifyThreshold=5

	LC_EmisDefaultCOG=(R=2.0,G=4.0,B=8.0,A=1.0)
	LC_EmisDefaultLocust=(R=60.0,G=1.0,B=0.1,A=1.0)

	Recoil_Hand={(
		TimeDuration=0.2f,
		RotAmplitude=(X=1000,Y=150,Z=0),
		RotFrequency=(X=10,Y=10,Z=0),
		RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
		LocAmplitude=(X=-8,Y=0,Z=0),
		LocFrequency=(X=10,Y=0,Z=0),
		LocParams=(X=ERS_Zero,Y=ERS_Zero,Z=ERS_Random)
	)}

	Recoil_Spine={(
		TimeDuration=0.2f,
		RotAmplitude=(X=500,Y=150,Z=0),
		RotFrequency=(X=10,Y=10,Z=0),
		RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero)
	)}

	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.25f
		RotOscillation={(Pitch=(Amplitude=45.f,Frequency=80.f),
						Yaw=(Amplitude=22.5f,Frequency=50.f),
						Roll=(Amplitude=11.25f,Frequency=20.f))}
		bOverrideTargetingDampening=TRUE
		TargetingDampening=0.5
	End Object
	FireCameraShake=FireCameraShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	WeaponID=WC_Lancer

	Spread(0)=0.0f
	Spread(1)=0.0f

	bUseMeleeHitTimer=FALSE

	MeleeTraceExtent=(X=32,Y=32,Z=32)
	MeleeImpactSound=SoundCue'Weapon_AssaultRifle.Reloads.CogRifleHitCue'

	bShouldSpawnDecal=TRUE

	bAllowTracers=TRUE
	bCanParryMelee=false

	bSupportsBarrelHeat=TRUE
	BarrelHeatInterpSpeed=6.f
	BarrelHeatPerShot=0.3f
	BarrelHeatCooldownTime=1.25f
	MaxBarrelHeat=2.f
	BarrelHeatMaterialParameterName="AssaultRifle_Heat"

	MaxFinalAimAdjustment=0.2
}
