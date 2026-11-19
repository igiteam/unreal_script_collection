/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Base class for all Gear turrets.
 */
class GearTurret extends Turret
	abstract
	config(Pawn)
	native;

/** View point offset for high player view pitch */
var(Camera) vector	CameraViewOffsetHigh;
/** View point offset for medium (horizon) player view pitch */
var(Camera) vector	CameraViewOffsetMid;
/** View point offset for low player view pitch */
var(Camera) vector	CameraViewOffsetLow;

/** True to allow player to target while driving this turret, false otherwise */
var(Camera) editconst bool		bAllowTargetingCamera;

/** View point offset for high player view pitch (targeting mode) */
var(Camera) vector	CameraTargetingViewOffsetHigh;
/** View point offset for medium (horizon) player view pitch (targeting mode) */
var(Camera) vector	CameraTargetingViewOffsetMid;
/** View point offset for low player view pitch (targeting mode) */
var(Camera) vector	CameraTargetingViewOffsetLow;

/** Fov in degrees while using this turret */
var(Camera) config float		CameraFOV;
/** Fov in degrees while using this turret (targeting mode) */
var(Camera) config float		CameraTargetingFOV;

/** Adjustment to apply when untargeted */
var(Camera) protected Rotator UnTargetedAimOffsetAdjusment;

/** Name of worst camera loc socket */
var(Camera) Name				WorstCamLocSocketName;

/** Current rotational velocity */
var protected vector ViewRotVel;

/** Controls how quickly to ramp current velocity toward desired velocity.  Feels like friction in the turret joint */
var() float ViewRotInterpSpeed;

/** True to apply rotational momemtum, so the turret feels heavier.  False for perfectly crisp aiming. */
var() bool bRotationalMomentum;

/** LocalToWorld of the turret's Base actor last tick. */
var protected transient matrix LastBaseTM;

/** TRUE to self-enforce bHardAttach, regardless of bBlockActors. */
var() protected const bool	bEnforceHardAttach;

/** hack */
var protected transient bool bMovingToEnforceHardAttach;

/** The light environment for this Pickup so we can see the item in our statically lit levels **/
var DynamicLightEnvironmentComponent MyLightEnvironment;

/** offset to Location when testing how close a player is to the vehicle for purposes of entering it, for use when the turret mesh is off center */
var vector EntryTestOffset;

/** when spawned by a fortification, reference to that fortification */
var GearFortification OwnerFort;

/** Mesh used for rendering in taccom */
var transient SkeletalMeshComponent TaccomMesh;

/** The material to use for the taccom preview */
var protected Material TaccomViewMaterial;

/** Last time driver left the turret */
var transient float LastTimeDriverLeft;
/** Amount of time before AI can try to get back on this turret */
var float TimeBeforeAvailableToAI;

/** Health bar to draw if a fortification */
var CanvasIcon HealthIcon;

/** What the player's cylinder radius should be set to when using the turret. If 0 don't modify it */
var() protected float NewDriverCylRad;
/** Save off the collision so it can be restored later */
var protected transient vector BackedUpDriverCollisionSize;


/** list of coverslots this turret has direct line of fire to */
var array<CoverReference> CoverSlotsExposedToMe;

/** offset to use when determingin if we expose any cover */
var() vector CoverExposureFireOffset;
/** cover that has LOS to this turret within this radius will be marked as exposed */
var() float CoverExposureRadius;

struct CheckpointRecord
{
	var bool bHidden;   
};

cpptext
{
	virtual void PostBeginPlay();
	virtual UBOOL IgnoreBlockingBy( const AActor *Other) const;
	virtual UBOOL ShouldDriverBeValidTargetFor( const APawn* Other) const
	{
		return TRUE;
	}

	virtual void GetActorReferences(TArray<FActorReference*> &ActorRefs, UBOOL bIsRemovingLevel);

	#if WITH_EDITOR
	virtual INT AddMyMarker(AActor *S);
	#endif

	/**
	 * @param Link - link owning the slot to check
	 * @param SlotIdx - index of slot in the link we're checking
	 * @return will return TRUE if this turret has a fireline to the passed coverlink/slot
	 */
	UBOOL HasExposedFireLineTo(ACoverLink* Link, INT SlotIdx);
};


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	CreateTaccomMesh();
}

/**
 *  Clones the mesh, changes the materials for it, and changes the DPG
 *  Does nothing if the mesh already exists.
 */
simulated function CreateTaccomMesh()
{
	local int MaterialIndex;
	local GearGRI GRI;

	GRI = GearGRI(WorldInfo.GRI);

	//If the GRI is not here yet, wait awhile then come back
	if (GRI == None)
	{
		SetTimer(0.2f, FALSE, nameof(CreateTaccomMesh));
		return;
	}

	//If there already isn't one... and we should have it
	if ( GRI != None && GRI.GameClass != None &&
		class<GearGame>(GRI.GameClass).default.bShouldDisplayWeaponPickupsViaTaccom && Mesh != None )
	{
		if (TaccomMesh == none)
		{
			// Clone the mesh and set the material and DPG
			TaccomMesh = new(Self) Mesh.Class;
			if (TaccomMesh != None)
			{
				TaccomMesh.SetSkeletalMesh(Mesh.SkeletalMesh);
				for (MaterialIndex = 0; MaterialIndex < TaccomMesh.GetNumElements(); MaterialIndex++)
				{
					TaccomMesh.SetMaterial(MaterialIndex,TaccomViewMaterial);
				}
				TaccomMesh.SetParentAnimComponent(Mesh);
				TaccomMesh.SetDepthPriorityGroup(SDPG_Foreground);
				TaccomMesh.CastShadow = false;
				AttachComponent(TaccomMesh);

			}
		}
		GRI.AddTaccomTurret(self);
	}
}

simulated function bool CanEnterVehicle(Pawn P)
{
	// Don't allow enemy AI in campaign game to use turret until timer has expired after previous driver left/killed
	if( !P.IsHumanControlled() && P.GetTeamNum() != TEAM_COG &&
		(!WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.IsCoopMultiplayerGame()) )
	{
		if( LastTimeDriverLeft > 0.f && `TimeSince(LastTimeDriverLeft) < TimeBeforeAvailableToAI )
		{
			return FALSE;
		}
	}

	if(  P.bIsCrouched ||
		 P.DrivenVehicle != None ||
		 P.Controller == None ||
		!P.Controller.bIsPlayer ||
		 P.PlayerReplicationInfo == None ||
		 P.IsA('Vehicle') ||
		 Health <= 0 ||
		 P.IsA('GearPawnRidable_Base') )
	{
		return FALSE;
	}

	if( Driver != None )
	{
		if( P.PlayerReplicationInfo.bBot || !PlayerReplicationInfo.bBot || !IsSameTeam(P) )
		{
			return FALSE;
		}
	}

	if( GearPawn(P) != None && GearPawn(P).bWantToUseCommLink )
	{
		return FALSE;
	}

	// Force human players to be in a good position. Due to the pivot point on some turrets, just give close pawns a pass.
	if (bRearMountOnly && P.IsHumanControlled() && NoZDot(Location - P.Location, vector(AimDir)) < -0.2f && VSize(Location - P.Location) > 50)
	{
		return FALSE;
	}

	return TRUE;
}


simulated function bool ShouldTargetingModeZoomCamera()
{
	local GearPC GPC;
	GPC = GearPC(Controller);
	return ( (GPC != None) && GPC.bIsTargeting );
}

function bool DriverEnter(Pawn P)
{
	local GearPawn GP;

	if( Driver != None )
	{
		GP = GearPawn(Driver);
		if( GP != None )
		{
			GP.KickPawnOffTurret();
		}
		else
		{
			DriverLeave( TRUE );
		}
		return FALSE;
	}

	GP = GearPawn(P);

	if( GP != None )
	{
		// Cannot man a turret if in cover.
		if( GP.CoverType != CT_None )
		{
			return FALSE;
		}
	}

	// drop shield if player tries to enter turret while carrying it
	if (GP != None && GP.EquippedShield != None)
	{
		GP.DropShield();
	}
	ViewRotVel = vect(0,0,0);
	return super.DriverEnter(P);
}

function bool DriverLeave( bool bForceLeave )
{
	local Rotator NewRot;

	if (GearPC(Controller) != None)
	{
		// zero any roll
		NewRot = Controller.Rotation;
		NewRot.Roll = 0;
		Controller.SetRotation(NewRot);
	}

	LastTimeDriverLeft = WorldInfo.TimeSeconds;

	return super.DriverLeave(bForceLeave);
}

function TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum,
			class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	local GearPRI PRI;
	local GearPawn GP;
	local int OldHealth;
	local float Score;

	if (OwnerFort == None)
	{
		Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	}
	else
	{
		if (EventInstigator != None)
		{
			// check for enemy type that causes instant destruction
			GP = GearPawn(EventInstigator.Pawn);
			if (GP != None && GP.bInstakillsFortifications)
			{
				DamageAmount = Max(DamageAmount, Health);
			}
		}

		OldHealth = Health;
		Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
		DamageAmount = OldHealth - Max(Health, 0);

		if (DamageAmount > 0 && EventInstigator != None)
		{
			// award score
			PRI = GearPRI(EventInstigator.PlayerReplicationInfo);
			if (PRI != None)
			{
				Score = PRI.ModifyScore(Max(1, OwnerFort.ScoringValue * (float(DamageAmount) / float(OwnerFort.StartingHealth[OwnerFort.UpgradeLevel]))), eEXP_Kills);
				if (Score > 0 && GearPC(EventInstigator) != None)
				{
					GearPC(EventInstigator).ClientAddKillPoints(Score);
				}
			}
		}

		if (Health <= 0)
		{
			if (GearPC(EventInstigator) != None)
			{
				GearPC(EventInstigator).ClientModifyStat(name(OwnerFort.StatName$"Destroyed"), 1);
			}
		}
	}
}

/** Kismet hook for kicking a pawn out of a vehicle */
simulated function OnGearExitVehicle( SeqAct_GearExitVehicle inAction )
{
	local GearAI_Cover GAI;
	if (inAction != None && GearTurret(inAction.TargetVehicle) != None)
	{
		GAI = GearAI_Cover(Controller);
		DriverLeave(TRUE);
		if(GAI != none)
		{
			GAI.StopUsingTurret(self);
		}
	}
}

/** overridden for turrets to give some momentum.  move into turret code? */
simulated function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, out Rotator OutDeltaRot )
{
	local vector DesiredViewRotVel;

	// now apply momentum effects
	if (bRotationalMomentum)
	{
		DesiredViewRotVel.X = float(OutDeltaRot.Roll) / DeltaTime;
		DesiredViewRotVel.Y = float(OutDeltaRot.Pitch) / DeltaTime;
		DesiredViewRotVel.Z = float(OutDeltaRot.Yaw) / DeltaTime;

		ViewRotVel = VInterpTo(ViewRotVel, DesiredViewRotVel, DeltaTime, ViewRotInterpSpeed);

		OutDeltaRot.Roll = NormalizeRotAxis(ViewRotVel.X * DeltaTime);
		OutDeltaRot.Pitch = NormalizeRotAxis(ViewRotVel.Y * DeltaTime);
		OutDeltaRot.Yaw = NormalizeRotAxis(ViewRotVel.Z * DeltaTime);
	}

	// let parents do their thing
	super.ProcessViewRotation(DeltaTime, out_ViewRotation, OutDeltaRot);
}

/**
* Returns the "worst case" camera location for this camera mode.
* This is the position that the camera ray is shot from, so it should be
* a guaranteed safe place to put the camera.
*/
simulated function vector GetCameraWorstCaseLoc()
{
	local vector WorstLoc;
	local rotator UnusedRot;

	Mesh.GetSocketWorldLocationAndRotation(WorstCamLocSocketName, WorstLoc, UnusedRot);
	return WorstLoc;
}

function bool StopFiring()
{
	if( Weapon != None )
	{
		Weapon.StopFire(0);
	}

	return TRUE;
}

/** Handle any motion by the actor this turret is base on. */
simulated protected native function UpdateForMovingBase(Actor BaseActor);

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if ( (Base != None) && !Base.bStatic )
	{
		UpdateForMovingBase(Base);
	}
}

simulated native function bool IsWithinRotationClamps(vector Loc);

simulated function bool WantsCrosshair(PlayerController PC)
{
	return FALSE;
}

simulated event ReplicationEnded()
{
	// we teleport our Driver around, so we need to clear it if we lose relevance
	// so that we don't keep teleporting the Driver if it leaves while we're not relevant
	Driver = None;
}

function bool ShouldSaveForCheckpoint()
{
	return (Controller == None);
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.bHidden = bHidden;
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	SetHidden(Record.bHidden);
	SetForcedInitialReplicatedProperty(Property'Engine.Actor.bHidden', (bHidden == default.bHidden));
}

/**
 * @return the current ammo used count
 */
simulated function int GetAmmoUsedCount()
{
	return GearWeapon(Weapon).AmmoUsedCount;
}

/** sets how much ammo has been used already */
function SetAmmoUsedCount(int NewUsedCount)
{
	GearWeapon(Weapon).AmmoUsedCount = NewUsedCount;
}

/**
 * Resupply the turret with ammo
 *
 * @param AmmoCount - how much ammo to add to the turret
 */
function GiveAmmo(int AmmoCount)
{
	GearWeapon(Weapon).AmmoUsedCount -= AmmoCount;
}

/**
 * Set the maximum ammo a turret has
 *
 * @param AmmoCount - the maximum ammo count
 */
function SetMaxAmmo(float AmmoCount)
{
	GearWeapon(Weapon).bInfiniteSpareAmmo = false;
	GearWeapon(Weapon).WeaponMagSize = AmmoCount;
	GearWeapon(Weapon).SpareAmmoCount = 0;
}

/** Ignore for most turrets */
simulated function UpdateAimToFocusPoint();

simulated function bool ShouldShowWeaponOnHUD()
{
	return TRUE;
}

/** Shrink the player's collision */
simulated function DrivingStatusChanged()
{
	super.DrivingStatusChanged();

	if (bDriving && NewDriverCylRad > 0.0f)
	{
		// shrink radius of drivers cylinder
		// this is a hack to make him able to spin freely around the turret's fake collision
		BackedUpDriverCollisionSize = Driver.GetCollisionExtent();
		Driver.SetCollisionSize(NewDriverCylRad, BackedUpDriverCollisionSize.Z);
	}
}

/**
* Restore the old collision information correctly on the client and server. It's here because we need access to the old driver
* 
* @param P - the Pawn detaching
*/
simulated function DetachDriver(Pawn P)
{
	Super.DetachDriver(P);
	if (NewDriverCylRad > 0.0f)
	{	
		P.SetCollisionSize(BackedUpDriverCollisionSize.X, BackedUpDriverCollisionSize.Z);
	}
}

/**
 * A gearpawn has just attached
 * 
 * @param GP - the pawn that just got on
 */
simulated function TurretManned(GearPawn GP);

/**
 * returns base Aim Rotation without any adjustment (no aim error, no autolock, no adhesion.. just clean initial aim rotation!)
 *
 * @return	base Aim rotation.
 */
simulated event Rotator GetBaseAimRotation()
{
	local rotator	POVRot;	
	local GearPC    GPC;
	
	GPC = GearPC(Controller);
	POVRot = Super.GetBaseAimRotation();

	if( GPC != None && IsHumanControlled(GPC) && !GPC.bIsTargeting)
	{
		// Apply an untargeted offset, to deal with camera angle differences
		POVRot += UnTargetedAimOffsetAdjusment;
	}

	return POVRot;
}

defaultproperties
{
	bNoDelete=TRUE
	bPushedByEncroachers=FALSE
	bRotationalMomentum=TRUE
	bAllowTargetingCamera=TRUE
	ViewRotInterpSpeed=40.0

	WorstCamLocSocketName="WorstCamLoc"

	Begin Object Name=PathCollisionCylinder
		CollisionRadius=20.000000
	End Object


	// define here as lot of sub classes which have moving parts will utilize this
	Begin Object Class=DynamicLightEnvironmentComponent Name=TurretLightEnvironment
	    bDynamic=FALSE		
		AmbientGlow=(R=0.3f,G=0.3f,B=0.3f,A=1.0f)
		TickGroup=TG_DuringAsyncWork
	End Object
	MyLightEnvironment=TurretLightEnvironment
	Components.Add(TurretLightEnvironment)

	TaccomViewMaterial=Material'ALL_WeaponShaders.WeaponPickupTaccomView'

	TimeBeforeAvailableToAI=5.f

	HealthIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=494,UL=106,VL=7)

	CoverExposureFireOffset=(X=50,Z=72)

	CoverExposureRadius=3500
	ControllerClass=None
}




