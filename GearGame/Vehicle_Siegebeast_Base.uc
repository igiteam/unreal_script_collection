/**
 * Siegebeast base class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Vehicle_Siegebeast_Base extends GearVehicle
	config(Pawn)
	native(Vehicle)
	implements(Interface_NavMeshPathObstacle)
	abstract;

/** Custom anim node **/
var GearAnim_Slot CustomAnimNode;

/** below 3 variables are simulated variables 
 *  However that works because FlashCount gets updated to the client
 *  Will trigger action/animation to update below variabels correctly
 *  As long as flashcounts are updated correctly, this should sync between client/server
 *  Do not replicate them, it creates odd state that clients can't shoot anymore **/
/** If the siegebeast can fire now */
var transient bool bReadyToFire;

/** If cranking animation is playing, don't allow another reload to register (ie from another player) */
var transient bool bIsCranking;

/** If the siegebeast can reload now */
var transient bool bReadyToReload;

/** Server replicating variables to update ammo state to client **/
var transient bool bHasAmmo;

var bool bPlayerDisabled;

/** Name of the fire animation */
var name FireAnimName;

/** Fire sound */
var SoundCue FireSound;

/** Beast fire sound */
var SoundCue BeastFireSound;

/** Crank sound */
var SoundCue CrankSound;

/** Beast crank sound */
var SoundCue BeastCrankSound;

var SoundCue BeastPainSound;

/** Ambient sound loop */
var SoundCue AmbientSoundLoop;

/** Audio component that controls the ambient sound */
var AudioComponent AC_LoopingAmbientSound;

/** Ambient sound loop */
var SoundCue AmbientBreathSoundLoop;

/** Audio component that controls the ambient sound */
var AudioComponent AC_LoopingAmbientBreathSound;

/** The actor that kismet is telling us to aim at */
var Actor AimTarget;

/** How fast the vehicle can turn */
var() float MaxTurnRate;

/** Where the center of the turn restriction should be, all but Yaw ignored */
var() rotator YawCenter;

/** How far should the beast be allowed to turn, all but Yaw ignored */
var() rotator MaxYawDelta;

/** Expose camera base offset for LD tweaking */
var() vector CameraBaseOffset;

/** Expose camera high offset for LD tweaking */
var() vector CameraViewOffsetHigh;

/** Expose camera mid offset for LD tweaking */
var() vector CameraViewOffsetMid;

/** Expose camera low offset for LD tweaking */
var() vector CameraViewOffsetLow;

/** FOV to use when driving */
var() config float DriverFOV;

/** FOV to use when targeting with left trigger */
var() config float TargetingFOV;

/** Flaming cannonball particles */
var ParticleSystemComponent PSC_FlamingCannonballEffect;

var StaticMeshComponent SMC_Cannonball;
var StaticMeshComponent SMC_BlownUp;


/** The current number of times the beast has been cranked */
var transient int CrankCount;

/** How many cranks before the beast is charged */
var const int CranksRequiredForReload;

/** Used to play catapult firing effects for remote players */
var repnotify byte CatapultFlashCount;

/** Used to play firing effects for remote players using the first charging wheel */
var repnotify byte SiegeWheel1FlashCount;

/** Used to play firing effects for remote players using the second charging wheel */
var repnotify byte SiegeWheel2FlashCount;

/** List of anim sets to add for pawn turning the wheel */
var array<AnimSet>  WheelTurnAnimSetList;

/** The animation to play when a player mounts a charging wheel */
var BodyStance WheelTurnStartStance;
/** The animation to play when a player is idle on a charging wheel */
var BodyStance WheelTurnIdleStance;
/** The animation to play when a player turns a charging wheel */
var BodyStance WheelTurnStance;
/** The animation to play when a player dismounts a charging wheel */
var BodyStance WheelTurnEndStance;
/** The animation to play when a player is idle on a gunner position */
var BodyStance GunnerIdleStance;
/** Offsets for left/right crank handles to IK loader hand bones to */
var() Name      CrankIKBoneName_Left, CrankIKBoneName_Right;
var() Vector    CrankIKEffectorLocation_Left, CrankIKEffectorLocation_Right;
var() Rotator   CrankIKRotation_Left, CrankIKRotation_Right;
/** Offsets for left/right gunner handles to IK hand bones to */
var() Name      GunnerIKBoneName_Left, GunnerIKBoneName_Right;
var() Vector    GunnerIKEffectorLocation_Left, GunnerIKEffectorLocation_Right;
var() Rotator   GunnerIKRotation_Left, GunnerIKRotation_Right;

var     GearAnim_BlendPerBone   BiteMaskNode;
var()   float                   BiteDamage;
var()   float                   BiteRadius;
var()   float                   LastBiteTime;
var()   repnotify   bool        bBite;
var     SoundCue                BiteSound;

/** How close does the player need to be in order to get a seat */
var const int MaxDistanceToDrive;

/** The hud icons to draw for the wheel charge players */
var ActionInfo WheelTurnAction;

/** Have we already updated the obstacle registration */
var bool bUpdatedObstacleRegistration;

/** How far the Siegebeast has rotated since it last registered as an obstacle */
var int YawTravelSinceLastObstacleRegistration;

/** How much ammo the Siegebeast will have when a player is firing it, 0 means unlimited */
var() int PlayerAmmoCount;

/** The last projectile we spawned */
var transient Projectile SpawnedProjectile;

/** The minimum angle the siegebeast should aim up if it doesn't have a proper target */
var const float MinimumAimUp;

/** Anim node blend **/
var transient AnimNodeBlendList BehaviorBlendNode;
var transient AnimNodeSequence  ReloadNode;

/** Wheels - this is faking since it uses phys_Interpolating and only thing this wheel does is to roll wheels **/
var transient SkelControlSingleBone LtWheel;
var transient SkelControlSingleBone RtWheel;
/** How fast the wheel rolls per second **/
var transient FLOAT                 WheelRollSpeedPerSecond;
/** Last Yaw of the vehicle **/
var transient INT                   LastYaw;
/** Turning or not... this is used for wheel rolling **/
var transient bool                  bTurning;

/** Explosion template */
var GearExplosion SiegebeastExplosionTemplate;

/** Whether first round has been auto loaded for player so they don't need to wait for AI to arrive */
var bool bAutoLoadedFirstRoundForPlayer;

/** Whether this siege beast is invulnerable */
var bool bInvulnerable;

var GearAI LoaderClaim;
var GearAI GunnerClaim;

struct CheckpointRecord
{
	var vector Location;
	var rotator Rotation;
	var bool bDeadVehicle;
};

/** List of kismet actions who are waiting for outputs */
var array<SeqAct_ManageSiegebeast> CrankActions;
var array<SeqAct_ManageSiegebeast> FireActions;
var array<SeqAct_ManageSiegebeast> LookAtActions;

/** Whether kismet is currently rotation the siegebeast to a target */
var bool bKismetIsRotating;

var float ObsSizeX;
var float ObsSizeY;
var Vector ObsTranslation;

replication
{
	if (bNetDirty)
		CatapultFlashCount, SiegeWheel1FlashCount, SiegeWheel2FlashCount, bBite, bPlayerDisabled, bHasAmmo;
}

cpptext
{
	/**
	 * Make a hole in the NavMesh so AI paths around the Siegebeast
	 *
	 * @param out_PolyShape - output array which holds the vertex buffer for this obstacle's bounding polyshape
	 *
	 * @return TRUE if this object should block things right now (FALSE means this obstacle shouldn't affect the mesh)
	 */
	virtual UBOOL GetBoundingShape(TArray<FVector>& out_PolyShape);

	/**
	 * Don't want any polys inside of our obstacle registration
	 *
	 * @return FALSE to get rid of the polys
	 */
	virtual UBOOL PreserveInternalPolys() { return FALSE; }

	virtual void BeginDestroy()
	{
		Super::BeginDestroy();
		UnRegisterObstacle();
	}

	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL VerifyObstacle()
	{
		return !IsPendingKill();
	}
}

/** Register the Siegebeast as an obstacle with NavMesh */
native function RegisterObstacle();

/** Unregister the Siegebeast as an obstacle with NavMesh */
native function UnRegisterObstacle();

native event bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy);

/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
		case 'bBite' :
			StartBiteAttack();
			break;
	}

	Super.ReplicatedEvent( VarName );
}

/**
 * Don't hurt yourself
 *
 * @param DamageAmount - the incoming damage to possibly adjust
 *
 * @param EventInstigator - the damage creator
 *
 * @param HitLocation - where the damage occurred
 *
 * @param Momentum - the direction of the damage
 *
 * @param DamageType - the type of damage inflicted
 *
 * @param HitInfo - misc info about the damage
 *
 * @param DamageCauser - the actor that caused the damage
 */
event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// Take no damage if we have no controller and are marked as invulnerable OR
	// If we threw the projectile
	if( (PlayerController(Controller) == None && bInvulnerable) || (DamageCauser != None && SpawnedProjectile == DamageCauser) )
	{
		DamageAmount = 0;
	}

	Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

function OnToggleGodMode( SeqAct_ToggleGodMode inAction )
{
	if( inAction.InputLinks[0].bHasImpulse )
	{
		bInvulnerable = TRUE;
	}
	else
	if( inAction.InputLinks[1].bHasImpulse )
	{
		bInvulnerable = FALSE;
	}
	else
	{
		bInvulnerable = !bInvulnerable;
	}
}

function OnToggle(SeqAct_Toggle InAction)
{
	local bool bShouldDisable;

	// Turn ON
	if( InAction.InputLinks[0].bHasImpulse )
	{
		bShouldDisable = FALSE;
	}
	// Turn OFF
	else if (InAction.InputLinks[1].bHasImpulse)
	{
		bShouldDisable = TRUE;
	}
	// Toggle
	else if (InAction.InputLinks[2].bHasImpulse)
	{
		bShouldDisable = !bPlayerDisabled;
	}

	SetPlayerDisabledStatus( bShouldDisable );
}

function SetPlayerDisabledStatus( bool InbDisabled )
{
	bPlayerDisabled = InbDisabled;
}   

function PlayHit(float Damage, Controller InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, TraceHitInfo HitInfo)
{
	Super.PlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);

	if( ClassIsChildOf( DamageType, class'GDT_Explosive' ) )
	{
		PlaySound(BeastPainSound);
	}
}

/** Put the dummy cannon ball on */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Mesh.AttachComponentToSocket( PSC_FlamingCannonballEffect, 'cannon_attach' );
	Mesh.AttachComponentToSocket( SMC_Cannonball, 'cannon_attach' );

	if (AC_LoopingAmbientSound == none)
	{
		AC_LoopingAmbientSound = CreateAudioComponent(AmbientSoundLoop, FALSE, TRUE, TRUE);
	}

	if (AC_LoopingAmbientSound != none)
	{
		AC_LoopingAmbientSound.FadeIn(0.1f, 1.0f);
	}

	if (AC_LoopingAmbientBreathSound == none)
	{
		AC_LoopingAmbientBreathSound = CreateAudioComponent(AmbientBreathSoundLoop, FALSE, TRUE, TRUE);
	}

	if (AC_LoopingAmbientBreathSound != none)
	{
		AC_LoopingAmbientBreathSound.FadeIn(0.1f, 1.0f);
	}

	// Allow LDs to tweak the camera offsets to speed up iteration time
	Seats[0].CameraBaseOffset = CameraBaseOffset;
	Seats[0].CameraViewOffsetHigh = CameraViewOffsetHigh;
	Seats[0].CameraViewOffsetMid = CameraViewOffsetMid;
	Seats[0].CameraViewOffsetLow = CameraViewOffsetLow;

	Seats[0].ViewYawDelta = MaxYawDelta.Yaw;
	Seats[0].ViewYawCenter = YawCenter.Yaw;

	RegisterObstacle();

	if (Weapon != None)
	{
		if (PlayerAmmoCount == 0)
		{
			GearWeapon(Weapon).bInfiniteSpareAmmo = TRUE;
		}

		GearWeapon(Weapon).AmmoUsedCount = 1;
		GearWeapon(Weapon).SpareAmmoCount = PlayerAmmoCount;
	}

	LastYaw = Rotation.Yaw;

	HideCannonball();
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.Location = Location;
	Record.Rotation = Rotation;
	Record.bDeadVehicle = bDeadVehicle;
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	// make sure collision doesn't cause any issues
	bCollideWorld = false;
	bNoEncroachCheck = false;
	SetLocation(Record.Location);
	bCollideWorld = default.bCollideWorld;
	bNoEncroachCheck = default.bNoEncroachCheck;

	SetRotation(Record.Rotation);
	if (Record.bDeadVehicle)
	{
		bDeadVehicle = true;
		ConvertContentToBlownUp();
	}
}

simulated event Destroyed()
{
	ClearTimer('StopReloadAnimation');
	ClearTimer('StartTurning');
	ClearTimer('StopTurning');

	if( AC_LoopingAmbientSound != None )
	{
		AC_LoopingAmbientSound.FadeOut( 0.1f, 0.f );
	}
	if( AC_LoopingAmbientBreathSound != None )
	{
		AC_LoopingAmbientBreathSound.FadeOut( 0.1f, 0.f );
	}


	UnRegisterObstacle();
	Super.Destroyed();
}

/**
 * Abuse this function to make the camera function in world space limits instead of relative to the vehicle
 *
 * @return the rotation of the vehicle to use for camera calculation
 */
simulated function rotator GetVehicleSpaceCamRotation(float DeltaTime, bool bPassenger, optional int SeatIndex=-1)
{
	local rotator VehicleRotation;

	if (bPassenger)
	{
		return Super.GetVehicleSpaceCamRotation(DeltaTime, bPassenger, SeatIndex);
	}

	VehicleRotation = Rotation;
	VehicleRotation.Yaw = YawCenter.Yaw;

	return VehicleRotation;
}

/**
 * 0 out the pitch and rotate the pawn, also replicate to the server
 *
 * @param NewRotation - the desired pawn rotation
 *
 * @param DeltaTime - the length of the last frame
 */
simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	local int DeltaYaw;
	local int Idx;

	NewRotation.Pitch = 0;
	NewRotation.Roll = 0;

	// Clamp using MaxTurnRate
	NewRotation.Yaw = fixedTurn(Rotation.Yaw, NewRotation.Yaw, MaxTurnRate * DeltaTime);

	// Clamp using MaxYawDelta
	if (MaxYawDelta.Yaw != 0)
	{
		NewRotation.Yaw = ClampRotAxisFromBase(NewRotation.Yaw, YawCenter.Yaw, MaxYawDelta.Yaw);
	}

	DeltaYaw = (Rotation.Yaw & 65535) - (NewRotation.Yaw & 65535);

	if (NewRotation.Yaw != Rotation.Yaw)
	{
		if(DeltaYaw > 32768)
			DeltaYaw -= 65536;
		else if(DeltaYaw < -32768)
			DeltaYaw += 65536;

		YawTravelSinceLastObstacleRegistration += DeltaYaw;

		bUpdatedObstacleRegistration = FALSE;

		ServerFaceRotation(NewRotation.Yaw);

		SetRotation(NewRotation);
	}
	else if (!bUpdatedObstacleRegistration && abs(YawTravelSinceLastObstacleRegistration) > 1000)
	{
		bUpdatedObstacleRegistration = TRUE;
		YawTravelSinceLastObstacleRegistration = 0;
		UpdateObstacleRegistration();
	}

	if (bKismetIsRotating && DeltaYaw == 0)
	{
		bKismetIsRotating = false;
		for (Idx = 0; Idx < LookAtActions.Length; Idx++)
		{
			LookAtActions[Idx].OutputLinks[3].bHasImpulse = true;
		}
	}
}

reliable server function UpdateObstacleRegistration()
{
	//`log(GetFuncName());

	UnRegisterObstacle();
	RegisterObstacle();
}

/**
 * Server side rotation replication
 *
 * @param RotationYaw - the yaw is the only important part of the rotation
 */
unreliable server function ServerFaceRotation(int RotationYaw)
{
	local rotator NewRotation;

	NewRotation.Yaw = RotationYaw;

	SetRotation(NewRotation);
}

/** Called when a client presses X while in the vehicle. (server only) */
reliable server function ServerPressedX()
{
	DriverLeave(FALSE);
}

/**
 * Called when a passenger presses X
 *
 * @param C - which controller pressed X
 */
simulated function PassengerPressedX(Controller C)
{
	if (C.Pawn != None)
	{
		GearWeaponPawn(C.Pawn).DriverLeave(FALSE);
	}
}

/**
 * Return the orientation and position of the muzzle socket
 *
 * @param SeatIndex - which seat to inspect
 *
 * @param OutLocation - the location to return
 *
 * @param OutRotation - the rotation to return
 */
simulated native function GetBarrelLocationAndRotation(int SeatIndex, out vector OutLocation, optional out rotator OutRotation);

/**
 * Find the anim slot in the anim tree
 *
 * @param SkelComp - the skeletal mesh that was just initialized
 */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	Super.PostInitAnimTree(SkelComp);

	if (SkelComp == Mesh)
	{
		CustomAnimNode = GearAnim_Slot(Mesh.FindAnimNode('Custom_FullBody'));

		// load animnode blends
		BehaviorBlendNode = AnimNodeBlendList(Mesh.FindAnimNode('SiegeBeastBehavior'));
		// set idle active
		BehaviorBlendNode.SetActiveChild(0, 0.25f);

		ReloadNode = AnimNodeSequence (Mesh.FindAnimNode('ReloadNode'));

		LtWheel = SkelControlSingleBone(Mesh.FindSkelControl('Lt_Front_Wheel'));
		RtWheel = SkelControlSingleBone(Mesh.FindSkelControl('Rt_Front_Wheel'));

		BiteMaskNode = GearAnim_BlendPerBone(Mesh.FindAnimNode('BiteNode'));
	}
}

function StartBiteAttack()
{
	local AnimNodeSequence Seq;
	local float AnimTime;

	if( BiteMaskNode.MaskList[0].DesiredWeight != 1.f )
	{
		BiteMaskNode.SetMaskWeight( 0, 1.f, 0.1f );

		Seq = AnimNodeSequence(BiteMaskNode.Children[1].Anim);
		Seq.SetAnim( 'Bite' );
		Seq.PlayAnim();

		AnimTime = Seq.GetAnimPlaybackLength();
		SetTimer( AnimTime, FALSE, nameof(FinishBiteAttack) );

		bBite = TRUE;
		LastBiteTime = WorldInfo.TimeSeconds;

		PlaySound( BiteSound );
	}
}

function FinishBiteAttack()
{
	if( BiteMaskNode.MaskList[0].DesiredWeight != 0.f )
	{
		BiteMaskNode.SetMaskWeight( 0, 0.f, 0.25f );
		bBite = FALSE;
	}
}

function AnimNotify_BiteDamage()
{
	local Vector DamageLocation;
	Mesh.GetSocketWorldLocationAndRotation( 'Bite', DamageLocation );
	HurtRadius( BiteDamage, BiteRadius, class'GDT_Melee', 0, DamageLocation, self,, TRUE );
}

function CheckForBiteAttack()
{
	local Vector DamageLocation;
	local GearPawn GP;

	if( `TimeSince( LastBiteTime ) < 5.f || bDeadVehicle )
	{
		return;
	}

	Mesh.GetSocketWorldLocationAndRotation( 'Bite', DamageLocation );

	foreach WorldInfo.AllPawns( class'GearPawn', GP, DamageLocation, BiteRadius )
	{
		if( GP.GetTeamNum() == TEAM_COG )
		{
			StartBiteAttack();
			break;
		}
	}
}

/**
 * Prevent being too far from the driver's seat when attaching
 *
 * @param P - the Pawn trying to drive the Siegebeast
 *
 * @return TRUE if in the correct area to ride the Siegebeast
 */
simulated function bool CanEnterVehicle(Pawn P)
{
	local vector SeatSocketLoc;
	local bool bCanEnter;
	local int i;

	if( bDeadVehicle )
	{
		return FALSE;
	}

	if( P.IsHumanControlled() && bPlayerDisabled )
	{
		return FALSE;
	}

	if ( bHasAmmo == FALSE )
	{
		return FALSE;
	}

	for (i = 0; i < Seats.Length && !bCanEnter; i++)
	{
		Mesh.GetSocketWorldLocationAndRotation(Seats[i].SeatBone, SeatSocketLoc);

		if (Seats[i].SeatPawn.Driver == none && 
			VSize(SeatSocketLoc - P.Location) < MaxDistanceToDrive && 
			(i < 1 || !bReadyToFire) )
		{
			bCanEnter = Super.CanEnterVehicle(P);
			break;
		}
	}

	return bCanEnter;
}

/**
 * Match the pawn up with the nearest seat
 *
 * @param P - the pawn that wants to drive
 */
function bool TryToDrive(Pawn P)
{
	local vector SeatSocketLoc;
	local int i;

	if( bDeadVehicle )
	{
		return FALSE;
	}

	for (i = 0; i < Seats.Length; i++)
	{
		Mesh.GetSocketWorldLocationAndRotation(Seats[i].SeatBone, SeatSocketLoc);

		if (VSize(SeatSocketLoc - P.Location) < MaxDistanceToDrive)
		{
			// Don't allow cranks to be used when Siegebeast is loaded
			if (i > 0 && bReadyToFire)
			{
				return FALSE;
			}
			return TryToDriveSpecificSeat(P, i);
		}
	}

	return TryToDriveSpecificSeat(P, 0);
}

/** Server version of crank **/
function TriggerCrank()
{
	Seats[1].Gun.StartFire(2);
}

/**
 * Kismet handler for SeqAct_ManageSiegebeast
 *
 * @param inAction - the kismet action that called us
 */
function OnManageSiegebeast(SeqAct_ManageSiegebeast inAction)
{
	local Controller C;

	// Make sure we're not dead
	if (bDeadVehicle)
	{
		inAction.bActionIsDone = true;
		inAction.OutputLinks[0].bHasImpulse = true;
		return;
	}

	if (inAction.InputLinks[0].bHasImpulse)
	{
		if (CrankActions.Find(inAction) == INDEX_NONE)
		{
			CrankActions.AddItem(inAction);
		}

		if (!bReadyToFire)
		{
			// fire crank
			TriggerCrank();
			// set second crank
			// need to set timer so that it try again
			SetTimer(2.f, FALSE, nameof(TriggerCrank));

			// Make sure we don't reload more ammo than allowed
			GearWeapon(Weapon).SpareAmmoCount = Min(GearWeapon(Weapon).SpareAmmoCount, PlayerAmmoCount);
		}
	}
	else if (inAction.InputLinks[1].bHasImpulse)
	{
		if (FireActions.Find(inAction) == INDEX_NONE)
		{
			FireActions.AddItem(inAction);
		}

		if (bReadyToFire)
		{
			// Make sure the AI can fire even when out of ammo
			GearWeapon(Weapon).AmmoUsedCount = 0;

			StartFire(0);

			// Put ammo back in the weapon
			GearWeapon(Weapon).SpareAmmoCount = Min(GearWeapon(Weapon).SpareAmmoCount + 1, PlayerAmmoCount);
		}
	}
	else if (inAction.InputLinks[2].bHasImpulse)
	{
		if (LookAtActions.Find(inAction) == INDEX_NONE)
		{
			LookAtActions.AddItem(inAction);
		}

		bKismetIsRotating = true;

		C = Controller(InAction.FocusTarget);

		if (C != None && C.Pawn != None)
		{
			AimTarget = C.Pawn;
		}
		else
		{
			AimTarget = inAction.FocusTarget;
		}
	}
	else if (inAction.InputLinks[3].bHasImpulse)
	{
		AimTarget = None;
	}

	inAction.OutputLinks[0].bHasImpulse = true;
}

/**
 * Only allow firemode 0 and only if we're ready to fire
 *
 * @param FireModeNum - the index of the desired fire mode
 */
simulated function StartFire(byte FireModeNum)
{
	if( FireModeNum == 0 && bReadyToFire )
	{
		// here I need to stop fire for seat (wheel) weapons, that way, we make sure whoever joins between will see weapon is loaded. 
		// StopFire didn't work. It's in Active state not WeaponFiring
		Seats[1].Gun.ClearFlashCount();
		Seats[2].Gun.ClearFlashCount();

		Super.StartFire(0);
		StopFire(0);
	}
}

/**
 * A player is using the charging wheel, play sounds and animations.
 *
 * @param HitLocation - unused in this case
 *
 * @param SeatIndex - where the player turning the wheel is sitting
 */
simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
	if( SeatIndex != 0 )
	{
		if( CanReload() )
		{
			PlayReloadAnimation( SeatIndex == 1, CrankCount + 1 );
		}
	}
	else
	{
		PlayFireAnimation();
	}
}

simulated function PlayFireAnimation()
{
	bReadyToFire    = FALSE;
	bReadyToReload  = FALSE;
	bIsCranking     = FALSE;

	CustomAnimNode.PlayCustomAnim( FireAnimName, 1.f, 0.25f, -1.0f, FALSE, TRUE );
	CustomAnimNode.SetActorAnimEndNotification(TRUE);

	PlaySound( FireSound );
	PlaySound( BeastFireSound );

	if( Role == ROLE_Authority )
	{
		TriggerEventClass( class'SeqEvt_VehicleFired', Driver, 0 );
	}
}

simulated function StopFireAnimation()
{
	local int Idx;

	CustomAnimNode.StopCustomAnim(0.25f);
	CustomAnimNode.SetActorAnimEndNotification(FALSE);
	// behavior transfer - switch back to idle
	BehaviorBlendNode.SetActiveChild(0, 0.25f);

	AllowReload();
	UpdatePassengerHUDActions();

	for (Idx = 0; Idx < FireActions.Length; Idx++)
	{
		FireActions[Idx].OutputLinks[2].bHasImpulse = true;
	}
}

/**
 * Watch for the end of the reload and fire animations
 *
 * @param SeqNode - the animation node sequence that just finished
 *
 * @param PlayedTime - the length of the animation
 *
 * @param ExcessTime - how far over the expected time did the animation take
 */
simulated event OnAnimEnd( AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime )
{
	if( SeqNode.AnimSeqName == FireAnimName )
	{
		StopFireAnimation();
	}
}

/** Set the ReadyToReload flag */
simulated function AllowReload()
{
	if( bHasAmmo )
	{
		bIsCranking     = FALSE;
		bReadyToReload  = TRUE;
		CrankCount      = 0;
	}
}

simulated function bool CanReload()
{
	if( bReadyToReload && CrankCount < CranksRequiredForReload && !bIsCranking )
	{
		return TRUE;
	}

	return FALSE;
}

/** Play the reload animation and associated sounds */
simulated function PlayReloadAnimation( bool LeftCrank , INT InCrankCount)
{
	local FLOAT AnimTime;

	CrankCount = InCrankCount;
	if( CrankCount > CranksRequiredForReload )
	{
		CrankCount = CranksRequiredForReload;
	}

	if( CrankCount == CranksRequiredForReload )
	{
		bReadyToReload = FALSE;
	}

	PlaySound(CrankSound);
	PlaySound(BeastCrankSound);

	// if idle, it needs to reset all reload info
	if( BehaviorBlendNode.ActiveChildIndex == 0 )
	{
		// switch to reload blend
		BehaviorBlendNode.SetActiveChild(1, 0.25f);

		ReloadNode.SetAnim('ADD_Reload');

		ReloadNode.PlayAnim();
		PlayLoaderReloadAnimation();

		AnimTime = ReloadNode.GetAnimPlaybackLength()*FLOAT(InCrankCount)/FLOAT(CranksRequiredForReload);
		SetTimer(AnimTime, FALSE, nameof(StopReloadAnimation));

		bIsCranking = TRUE;
	}
	// in the middle of playing reload
	else if( BehaviorBlendNode.ActiveChildIndex == 1 )
	{
		// calculate new timer
		AnimTime = ReloadNode.GetAnimPlaybackLength()*FLOAT(InCrankCount)/FLOAT(CranksRequiredForReload) - ReloadNode.CurrentTime;
		ReloadNode.PlayAnim(,,ReloadNode.CurrentTime );
		PlayLoaderReloadAnimation( ReloadNode.CurrentTime );
		// set new timer
		ClearTimer('StopReloadAnimation');
		SetTimer(AnimTime, FALSE, nameof(StopReloadAnimation));

		bIsCranking = TRUE;
	}
	else
	{
		`log("ERROR: "@self@":Wrong state to reload");
	}
}

simulated function StopReloadAnimation()
{
	local int Idx;

	ClearTimer(nameof(StopReloadAnimation));

	// stop animation
	ReloadNode.StopAnim();
	StopLoaderReloadAnimation();

	bIsCranking = FALSE;

	// if played until end, stop
	if ( Abs(ReloadNode.CurrentTime-ReloadNode.GetAnimPlaybackLength()) < 0.3f )
	{
		GearWeapon(Weapon).PerformReload();

		bReadyToReload  = FALSE;
		bReadyToFire    = TRUE;

		for (Idx = 1; Idx < Seats.Length; ++Idx)
		{
			if (Seats[Idx].SeatPawn != None)
			{
				Seats[Idx].SeatPawn.DriverLeave(FALSE);
			}
		}

		// behavior transfer to struggle state

		// If canister was ready to fire go to idle with arms raised a bit to prevent camera obstruction
		if( Driver == None && bAutoLoadedFirstRoundForPlayer )
		{
			BehaviorBlendNode.SetActiveChild( 3, 0.25f );
		}
		else
		{
			BehaviorBlendNode.SetActiveChild( 2, 0.25f );
		}

		for (Idx = 0; Idx < CrankActions.Length; Idx++)
		{
			CrankActions[Idx].OutputLinks[1].bHasImpulse = true;
		}
	}
}

simulated function PlayLoaderReloadAnimation( optional float StartTime )
{
	local GearPawn GP;
	local GSM_SiegeBeast_Loader SM;
	local int SeatIdx;

	for( SeatIdx = 1; SeatIdx < Seats.Length; SeatIdx++ )
	{
		GP = GearPawn(Seats[SeatIdx].SeatPawn.Driver);
		if( GP == None )
		{
			continue;
		}

		if( GP.IsDoingSpecialMove(GSM_SiegeBeast_Loader) )
		{
			SM = GSM_SiegeBeast_Loader(GP.SpecialMoves[GSM_SiegeBeast_Loader]);
			SM.PlayLoaderCrankAnimation( StartTime );
		}
	}
}

simulated function StopLoaderReloadAnimation()
{
	local GearPawn GP;
	local GSM_SiegeBeast_Loader SM;
	local int SeatIdx;

	for( SeatIdx = 1; SeatIdx < Seats.Length; SeatIdx++ )
	{
		GP = GearPawn(Seats[SeatIdx].StoragePawn);
		if( GP == None )
		{
			continue;
		}

		if( GP.IsDoingSpecialMove(GSM_SiegeBeast_Loader) )
		{
			SM = GSM_SiegeBeast_Loader(GP.SpecialMoves[GSM_SiegeBeast_Loader]);
			SM.StopLoaderCrankAnimation();
		}
	}
}


/** Anim event that tells us to hide the cannonball and spawn the projectile */
simulated function ThrowCannonball()
{
	local GearVehicleWeapon VWeap;
	local vector ThrowVelocity, UnusedVector, WeaponAim, TraceEnd, Destination;
	local Actor CurrentTarget;

	HideCannonball();

	if( Role==ROLE_Authority && !bDeadVehicle )
	{
		VWeap = GearVehicleWeapon(Weapon);
		SpawnedProjectile = Spawn(Weapon.GetProjectileClass(),,, GetPhysicalFireStartLoc(VWeap));

		if (SpawnedProjectile != None)
		{
			WeaponAim = vector(GetWeaponAim(VWeap));

			if( IsHumanControlled() && GearPC(Controller).TargetedPawn != None)
			{
				CurrentTarget = GearPC(Controller).TargetedPawn;
				Destination = CurrentTarget.Location;
				TraceEnd = Destination;
			}
			else if( !IsHumanControlled() && AimTarget != None )
			{
				CurrentTarget = AimTarget;
				Destination = CurrentTarget.Location;
				TraceEnd = Destination;
			}
			else
			{
				TraceEnd = SpawnedProjectile.Location + WeaponAim * 16000;
			}

			if ((CurrentTarget != None || Trace(Destination, UnusedVector, TraceEnd, SpawnedProjectile.Location, TRUE) != None) &&
				CalculateMinSpeedTrajectory(ThrowVelocity, Destination, SpawnedProjectile.Location, Weapon.GetProjectileClass().default.MaxSpeed, Weapon.GetProjectileClass().default.Speed,, Weapon.GetProjectileClass().default.MaxSpeed, SpawnedProjectile.GetGravityZ()))
			{
				SpawnedProjectile.Speed = VSize(ThrowVelocity);
				SpawnedProjectile.Init(Normal(ThrowVelocity));

`if(`notdefined(FINAL_RELEASE))
				if( bDebug )
				{
					`log( `location@`showvar(CurrentTarget)@`showvar(SpawnedProjectile.Location)@`showvar(Destination) );
					DrawDebugLine(Destination, SpawnedProjectile.Location, 255, 255, 255, TRUE);
				}
`endif
			}
			else
			{
				// always lob
				WeaponAim.Z = FMax(WeaponAim.Z, MinimumAimUp);

				SpawnedProjectile.Speed = Weapon.GetProjectileClass().default.MaxSpeed * 0.65f;
				SpawnedProjectile.Init(WeaponAim);
			}
		}
	}
}

/** Anim event that tells us to show the cannonball */
simulated function ShowCannonball()
{
	if( !bDeadVehicle )
	{
		PSC_FlamingCannonballEffect.SetHidden(FALSE);
		PSC_FlamingCannonballEffect.ActivateSystem();

		SMC_CannonBall.SetHidden(FALSE);
	}
}

/** Turn off the cannonball particles */
simulated function HideCannonball()
{
	PSC_FlamingCannonballEffect.SetHidden(TRUE);
	PSC_FlamingCannonballEffect.DeactivateSystem();

	SMC_CannonBall.SetHidden(TRUE);
}

/**
 * Trigger the vehicle exited event if the driver leaves
 *
 * @param bForceLeave - whether to skip all checks and force the player out of the vehicle
 *
 * @return true if the driver has been removed
 */
event bool DriverLeave(bool bForceLeave)
{
	local bool bSuccess;
	local Pawn OldDriver;

	OldDriver = Driver;
	bSuccess = Super.DriverLeave(bForceLeave);

	if (bSuccess)
	{
		TriggerEventClass(class'SeqEvt_VehicleDriven', OldDriver, 1);
	}

	return bSuccess;
}

/**
 * Trigger the vehicle entered event if the pawn gets in successfully
 *
 * @param P - the Pawn that wants to enter the vehicle
 *
 * @return true if the driver has entered
 */
function bool DriverEnter(Pawn P)
{
	local bool	bSuccess;

	if( bDeadVehicle )
	{
		return FALSE;
	}

	bSuccess = Super.DriverEnter(P);

	if (bSuccess)
	{
		TriggerEventClass(class'SeqEvt_VehicleDriven', P, 0);

		// Match the player view up with the current rotation
		if (Controller != None)
		{
			Controller.SetRotation(Rotation);
		}
	}

	return bSuccess;
}

/**
 * Play an animation when a passenger sits down
 *
 * @param WP - the passenger sitting down
 *
 * @param SeatIndex - which seat the passenger is in
 */
simulated function SitDriver(GearPawn WP, int SeatIndex)
{
	local GearAI AIC;
	local GearPC GPC;
	local int   PlayerCount;
	local GearVWeap_SiegebeastWheel Weap;

	// Clients may have already possessed the seat pawn
	GPC = GearPC(WP.Controller);
	if( GPC == None )
	{
		GPC = GearPC(Seats[SeatIndex].SeatPawn.Controller);
	}

	// If a player gets on, clear the AimTarget so when they get off the beast doesn't auto turn and crush them :)
	if( GPC != None )
	{
		AimTarget = None;
	}

	if (WP.Weapon != None)
	{
		WP.Weapon.Mesh.SetHidden(TRUE);
	}

	if( SeatIndex == 0 )
	{
		WP.DoSpecialMove( GSM_SiegeBeast_Gunner, TRUE );

		if( bReadyToFire )
		{
			BehaviorBlendNode.SetActiveChild( 2, 0.25f );
		}
	}
	else
	{
		WP.DoSpecialMove( GSM_SiegeBeast_Loader, TRUE,, SeatIndex );


		UpdateHUDAction(GPC);

		AIC = GearAI(WP.Controller);
		if (AIC != None)
		{
			Weap = GearVWeap_SiegebeastWheel(GearWeaponPawn(Seats[SeatIndex].SeatPawn).MyVehicleWeapon);
			Weap.SetTimer(class'GearVWeap_SiegebeastWheel'.default.CrankLength + 0.5f, TRUE, nameof(Weap.AITurnWheel) );
		}
	}

	// If gunner is human and we haven't loaded the first round for them yet
	if( WP.IsHumanControlled() && !bAutoLoadedFirstRoundForPlayer )
	{
		bAutoLoadedFirstRoundForPlayer = TRUE;

		if( SeatIndex == 0 )
		{
			foreach WorldInfo.AllControllers( class'GearPC', GPC )
			{
				PlayerCount++;
			}

			// call crank to trigger wheel turning, this way it will replicate to the client who joins later
			if (PlayerCount <= 1)
			{
				TriggerCrank();
			}
		}
	}

	WP.ClearTimer( nameof(WP.ResetCanBeRunOverFlag) );
	WP.bCanBeRunOver = FALSE;

	Super.SitDriver(WP, SeatIndex);
}

/**
 * Play an animation when a passenger gets out
 *
 * @param WP - the passenger sitting down
 *
 * @param SeatIndex - which seat the passenger is in
 */
simulated function UnSitDriver(GearPawn WP, int SeatIndex)
{
	local GearAI AIC;
	local GearVWeap_SiegebeastWheel Weap;

	if (WP.Weapon != None)
	{
		WP.Weapon.Mesh.SetHidden(FALSE);
	}

	if( SeatIndex == 0 )
	{
		if( WP.IsDoingSpecialMove(GSM_SiegeBeast_Gunner) )
		{
			GSM_SiegeBeast_Gunner(WP.SpecialMoves[GSM_SiegeBeast_Gunner]).PlayReleaseGunnerAnimation();
		}

		// If canister was ready to fire go to idle with arms raised a bit to prevent camera obstruction
		if( bReadyToFire )
		{
			BehaviorBlendNode.SetActiveChild( 3, 0.25f );
		}
	}
	else
	{
		if( WP.IsDoingSpecialMove(GSM_SiegeBeast_Loader) )
		{
			GSM_SiegeBeast_Loader(WP.SpecialMoves[GSM_SiegeBeast_Loader]).PlayReleaseLoaderAnimation();
		}

		AIC = GearAI(WP.Controller);
		if (AIC != None)
		{
			Weap = GearVWeap_SiegebeastWheel(GearWeaponPawn(Seats[SeatIndex].SeatPawn).MyVehicleWeapon);
			Weap.ClearTimer(nameof(Weap.AITurnWheel));
		}
	}

	WP.bCanBeRunOver = FALSE;
	WP.SetTimer( 2.f, FALSE, nameof(WP.ResetCanBeRunOverFlag) );

	Super.UnSitDriver(WP, SeatIndex);
}

/** Search for any passengers on the server and update their HUD actions */
simulated function UpdatePassengerHUDActions()
{
	local int i;
	for (i = 1; i < Seats.Length; i++)
	{
		if (Seats[i].SeatPawn != None)
		{
			UpdateHUDAction(GearPC(Seats[i].SeatPawn.Controller));
		}
	}
}

/**
 * Use the wheel turn action when it can charge, exit when already charged
 *
 * @param GPC - the passenger's controller
 */
simulated function UpdateHUDAction(GearPC GPC)
{
	if (GPC != None && GPC.MyGearHud != None)
	{
		if ( bHasAmmo )
		{
			if (!bReadyToFire)
			{
				GPC.MyGearHud.SetActionInfo(AT_VehicleControl, WheelTurnAction);
			}
			else
			{
				GPC.MyGearHud.SetActionInfo(AT_VehicleControl, InteractAction);
			}
		}
		else
		{
			GPC.MyGearHud.ClearActionInfoByType(AT_VehicleControl);
		}
	}
}


/**
 * Hide the mesh, turn off collision and show the destructed mesh
 *
 * @param Killer - the player that instigated the explosion
 */
simulated function BlowupVehicle(Controller Killer)
{
	Super.BlowupVehicle(Killer);

	ConvertContentToBlownUp();

	TriggerExplosion();

	TriggerEventClass(class'SeqEvent_Death', self);

	if( AC_LoopingAmbientSound != None )
	{
		AC_LoopingAmbientSound.FadeOut( 0.1f, 0.f );
	}
	if( AC_LoopingAmbientBreathSound != None )
	{
		AC_LoopingAmbientBreathSound.FadeOut( 0.1f, 0.f );
	}
}

/** Explode! */
simulated function TriggerExplosion()
{
	local vector ExplosionLocation;
	local rotator ExplosionRotation;
	local GearExplosionActor GEA;

	Mesh.GetSocketWorldLocationAndRotation('Explo', ExplosionLocation, ExplosionRotation);

	GEA = Spawn(class'GearExplosionActor', Self,, ExplosionLocation, ExplosionRotation);
	if (GEA != None)
	{
		GEA.Instigator = Self;
		GEA.InstigatorController = Controller;

		SiegebeastExplosionTemplate.InitFromContentTemplate();

		GEA.Explode(SiegebeastExplosionTemplate);
	}
}

/** @hack until we have a real destroyed mesh */
simulated function ConvertContentToBlownUp()
{
	Mesh.SetHidden(TRUE);
	Mesh.SetActorCollision( FALSE, FALSE );
	Mesh.SetBlockRigidBody( FALSE );
	Mesh.SetAnimTreeTemplate( None ); // Clear anim tree so Sound notifies no longer fire after it's dead

	SMC_BlownUp.SetHidden(FALSE);
	SMC_BlownUp.SetActorCollision( TRUE, TRUE );
	SMC_BlownUp.SetBlockRigidBody( TRUE );

	CollisionComponent = SMC_BlownUp;

	SetPhysics(PHYS_None);

	HideCannonball();
}

/**
 * If this is being fired via Kismet, just shoot at the forced location
 *
 * @param VWeapon - the weapon being inspected
 *
 * @return the rotator representing the weapon aim
 */
function rotator GetWeaponAim(GearVehicleWeapon VWeapon)
{
	local vector SocketLocation;

	if (Controller == None && AimTarget != None)
	{
		GetBarrelLocationAndRotation(0, SocketLocation);

		return rotator(AimTarget.Location - SocketLocation);
	}

	return Super.GetWeaponAim(VWeapon);
}


/**
 * Rotate towards the target if under kismet control
 *
 * @param DeltaTime - the length of the last frame
 */
simulated function Tick(float DeltaTime)
{
	local rotator ForcedLookRotation;
	local int YawDiff;

	if (AimTarget != None && Controller == None)
	{
		ForcedLookRotation = rotator(AimTarget.Location - Location);
		FaceRotation(ForcedLookRotation, DeltaTime);
	}

	// roll wheel
	if (bTurning)
	{
		RollWheels(DeltaTime);
	}

	// if not same, turn
	// this is totally fake!
	YawDiff = (Rotation.Yaw & 65535) - (LastYaw & 65535);
 	if (YawDiff == 0)
 	{
		// this all timer system is to simulate slowly starting tire and slowly stop rolling
		// and the direction is the wheel on the direction of moving moves forward, the other one rolls backward
		// slowly stop - do not stop in one tick
		if (bTurning && IsTimerActive('StopTurning') == FALSE)
		{
			SetTimer(1.f, FALSE, 'StopTurning');
		}
		// if it's starting turning, clear it
		if (IsTimerActive('StartTurning'))
		{
			ClearTimer();
		}
 	}
	else
	{
		// if moving to right, positive
		if ( YawDiff > 0 )
		{
			WheelRollSpeedPerSecond = default.WheelRollSpeedPerSecond;
		}
		else
		{
			// else roll to different direction
			// even if this is fake and even if doesn't make sense,
			// it made worse sense if they roll to same direction
			WheelRollSpeedPerSecond = -default.WheelRollSpeedPerSecond;
		}

		// if it hasn't started, slowly start
		if (bTurning == FALSE &&  IsTimerActive('StartTurning') == FALSE)
		{
			SetTimer(1.f, FALSE, 'StartTurning');
		}
		// if stop is active, clear it
		if ( IsTimerActive('StopTurning') )
		{
			ClearTimer('StopTurning');
		}
	}

	LastYaw = Rotation.Yaw;

	if( Role == ROLE_Authority )
	{
		if ( !bBite )
		{
			CheckForBiteAttack();
		}

		bHasAmmo = Weapon != None ? Weapon.HasAnyAmmo() : FALSE;
	}

	Super.Tick(DeltaTime);
}

// start turning
simulated function StartTurning()
{
	ClearTimer('StopTurning');
	bTurning = TRUE;
}

// stop turning
simulated function StopTurning()
{
	ClearTimer('StartTurning');
	bTurning = FALSE;
}

// roll wheel
simulated function RollWheels(float DeltaTime)
{
	local FLOAT DeltaRoll;

 	DeltaRoll = WheelRollSpeedPerSecond*DeltaTime;
	RtWheel.BoneRotation.Yaw -= DeltaRoll;
	LtWheel.BoneRotation.Yaw += DeltaRoll;

	if (RtWheel.BoneRotation.Yaw > 65536)
	{
		RtWheel.BoneRotation.Yaw -= 65536;
	}

	if (LtWheel.BoneRotation.Yaw > 65536)
	{
		LtWheel.BoneRotation.Yaw -= 65536;
	}

	//`log("RT wheel yaw:"@RtWheel.BoneRotation.Yaw@", LT wheel yaw:"@LtWheel.BoneRotation.Yaw);
}
/**
 * Find an acceptable offset to place the exiting driver pawn, and move it there.
 *
 * @return TRUE if pawn was successfully placed.
 */
function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
	local int i;
	local vector tryPlace, startPlace, Extent, HitLocation, HitNormal;

	if ( ExitingDriver == None )
		ExitingDriver = Driver;

	if ( ExitingDriver == None )
		return false;

	Extent = ExitingDriver.GetCollisionRadius() * vect(1,1,0);
	Extent.Z = ExitingDriver.GetCollisionHeight();

	// specific exit positions specified
	for( i=0; i<ExitPositions.Length; i++)
	{
		tryPlace = ExitingDriver.Location + (ExitPositions[i] >> ExitingDriver.Rotation);
		startPlace = ExitingDriver.Location;
		startPlace.Z = tryPlace.Z;

		// First, do a line check (stops us passing through things on exit).
		if( Trace(HitLocation, HitNormal, tryPlace, startPlace, false, Extent) != None )
			continue;

		// Then see if we can place the player there.
		if ( !ExitingDriver.SetLocation(tryPlace) )
			continue;

		return true;
	}

	return false;
}

/**
 * Don't draw crosshair for anyone but the driver.
 *
 * @param PC - the controller that is drawing a hud
 *
 * @return TRUE if we should draw a crosshair
 */
simulated function bool WantsCrosshair(PlayerController PC)
{
	return PC.Pawn == Self;
}

/**
 * Whether to draw the HUD as if the player is still in a normal HUD mode
 *
 * @param PC - the controller that is drawing a hud
 *
 * @return TRUE if we should draw a normal hud
 */
simulated function bool WantsNormalHUD(PlayerController PC)
{
	return true;
}

/** Returns the health values for the player passed in */
simulated function GetPlayerHealth(PlayerController PC, out int CurrHealth, out int TotalHealth)
{
	local int Idx;
	local GearPawn GP;

	for (Idx = 0; Idx < Seats.Length; Idx++)
	{
		if (Seats[Idx].SeatPawn != None && Seats[Idx].SeatPawn.Controller == PC)
		GP = GearPawn(Seats[Idx].SeatPawn.Driver);
		if (GP != None)
		{
			CurrHealth = GP.Health;
			TotalHealth = GP.DefaultHealth;
			return;
		}
	}
}

/**
 * Eject driver and then teleport them
 *
 * @param Action - the kismet teleport action
 */
simulated function OnTeleport(SeqAct_Teleport Action)
{
	local Pawn OldDriver;
	local GearPC PC;

	OldDriver = Driver;
	if (OldDriver != None && DriverLeave(TRUE))
	{
		OldDriver.OnTeleport(Action);

		PC = GearPC(OldDriver.Controller);
		if (PC != None)
		{
			PC.MyGearHud.ClearActionInfoByType(AT_VehicleControl);
		}
	}
}

/**
 * Eject passengers and then teleport them
 *
 * @param SeatIndex - the seat trying to teleport
 *
 * @param Action - the kismet teleport action
 */
simulated function OnPassengerTeleport(int SeatIndex, SeqAct_Teleport Action)
{
	local Pawn OldDriver;
	local GearPC PC;

	OldDriver = Seats[SeatIndex].SeatPawn.Driver;
	if (OldDriver != None && Seats[SeatIndex].SeatPawn.DriverLeave(TRUE))
	{
		OldDriver.OnTeleport(Action);

		PC = GearPC(OldDriver.Controller);
		if (PC != None)
		{
			PC.MyGearHud.ClearActionInfoByType(AT_VehicleControl);
		}
	}
}

/**
 * Change the FOV if the driver is targeting
 *
 * @param SeatIndex - which seat are we looking at
 *
 * @return the FOV for the camera to use
 */
simulated event float GetCameraFOV(int SeatIndex)
{
	if (SeatIndex == 0)
	{
		if (GearPC(Controller) != None && GearPC(Controller).bIsTargeting)
		{
			return TargetingFOV;
		}
		else
		{
			return DriverFOV;
		}
	}

	return Super.GetCameraFOV(SeatIndex);
}


defaultproperties
{
	LandMovementState=PlayerDrivingSiegebeast

	FireAnimName="Throw"

	MaxTurnRate=1000

	Health=20000

	CranksRequiredForReload=1

	MaxDistanceToDrive=200

	bNetInitialRotation=TRUE
	bReplicateMovement=TRUE
	bUpdateSimulatedPosition=TRUE
	bKickDriverOnTeleport=TRUE

	bReadyToReload=TRUE

	PlayerAmmoCount=0

	SupportedEvents.Add(class'SeqEvt_VehicleFired')
	SupportedEvents.Add(class'SeqEvt_VehicleDriven')

	CameraBaseOffset=(X=-600,Z=700)
	CameraViewOffsetHigh=(X=0,Y=0,Z=1500)
	CameraViewOffsetMid=(X=-300,Y=0,Z=-300)
	CameraViewOffsetLow=(X=0,Y=0,Z=-300)

	ExitPositions(0)=(X=-100,Z=100)
	ExitPositions(1)=(X=-200,Z=100)
	ExitPositions(2)=(X=-300,Z=100)

	bVehicleSpaceViewLimits=TRUE

	WheelTurnStartStance=(Stance=((Slot=BS_FullBody,AnimName="SiegeBeast_Reload_Crank_Start")))
	WheelTurnIdleStance=(Stance=((Slot=BS_FullBody,AnimName="SiegeBeast_Reload_Crank_IdlePose")))
	WheelTurnStance=(Stance=((Slot=BS_FullBody,AnimName="SiegeBeast_Reload_Crank")))
	WheelTurnEndStance=(Stance=((Slot=BS_FullBody,AnimName="SiegeBeast_Reload_Crank_End")))
	GunnerIdleStance=(Stance=((Slot=BS_FullBody,AnimName="SiegeBeast_Idle_Gunner")))

	CrankIKBoneName_Left=L_Gear_Crank
	CrankIKBoneName_Right=R_Gear_Crank
	CrankIKEffectorLocation_Left=(X=15,Y=90,Z=-13)
	CrankIKEffectorLocation_Right=(X=-15,Y=-90,Z=13)
	CrankIKRotation_Left=(Pitch=-182,Yaw=16384,Roll=-14560)
	CrankIKRotation_Right=(Pitch=-182,Yaw=16384,Roll=-14560)

	GunnerIKBoneName_Right=Player_Fire_Attach
	GunnerIKBoneName_Left=Player_Fire_Attach
	GunnerIKEffectorLocation_Left=(X=15,Y=-47,Z=115)
	GunnerIKEffectorLocation_Right=(X=15,Y=47,Z=115)
	GunnerIKRotation_Left=(Pitch=-5460,Yaw=16384,Roll=-20020)
	GunnerIKRotation_Right=(Pitch=-5460,Yaw=16384,Roll=-10922)

	SupportedEvents.Add(class'SeqEvent_Death')

	MinimumAimUp=0.4

	WheelRollSpeedPerSecond = 2400

	BiteDamage=600.f
	BiteRadius=128.f

	bDisableDriverCollision=FALSE
	bDisablePassengerCollision=FALSE

	ObsSizeX=412
	ObsSizeY=308
	ObsTranslation=(X=18,Y=0,Z=0)
}
