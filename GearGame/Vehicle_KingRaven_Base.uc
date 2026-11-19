/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Vehicle_KingRaven_Base extends GearVehicle
	native(Vehicle)
	config(Pawn)
	abstract;

// DAMAGE

/** config version of health. */
var()	config int				DefaultRavenHealth;
/** How quickly to heal per second. */
var()	config float			HealthRechargeRate;
/** Used to keep track of partial heal points between ticks. */
var		float					PartialHealth;

/** FOV to use when targeting. */
var()	float					TargetingFOV;

//Weapon effects

/** Minigun */
var	protected const SoundCue			MinigunFireLoop;
var	protected const SoundCue			MinigunFireLoop_Player;
var const protected SoundCue			MinigunFireStopCue;
var const protected SoundCue			MinigunFireStopCue_Player;
var protected const SoundCue			HeatBuildupCue;
var(MuzzleEffects)	float				MinigunMuzzleLightTime;
var(MuzzleEffects)	ParticleSystem		MinigunMuzzleEffect;

//Weapon effects instance data
struct native MinigunEffectsInstance
{
	var transient AudioComponent MinigunFiringLoopAC;
	var AudioComponent HeatBuildUpAC;
	var editconst PointLightComponent MinigunMuzzleLight;
	var ParticleSystemComponent PSC_MinigunMuzzleEffect;
};

var(MuzzleEffects) array<MinigunEffectsInstance> MinigunEffects;

/** Assault Rifle */

/** Sounds to play when firing loop stops. */
var protected const SoundCue	FireSound;
var protected const SoundCue	FireSound_Player;
var protected const SoundCue	StopFireSound;
var protected const SoundCue	StopFireSound_Player;

var(MuzzleEffects) array<AssaultRifleEffectsInstance> RifleEffects;

var array<AssaultRifleInfo> AssaultRifleInfos;

/** Last position passed to AdjustInterpTrackMove... used for worst camera location */
var		transient vector	LastOrigInterpLocation;

// Define all of the variables needed for the turrets
var SkeletalMeshComponent	FRTurretMesh;
var repnotify	vector 		FRTurretFlashLocation;
var repnotify	byte		FRTurretFlashCount;
var repnotify 	Rotator		FRTurretWeaponRotation;

var SkeletalMeshComponent	RRTurretMesh;
var repnotify	vector 		RRTurretFlashLocation;
var repnotify	byte		RRTurretFlashCount;
var repnotify 	Rotator		RRTurretWeaponRotation;

// Replication of the assault rifle
var SkeletalMeshComponent	FRRiflePawnMesh;
var SkeletalMeshComponent	FRRifleMesh;
var repnotify	vector 		FRRifleFlashLocation;
var repnotify	byte		FRRifleFlashCount;
var          	Vector2D	FRRifleWeaponAimOffset;
var             Name        FRRifleSocketName;

var SkeletalMeshComponent	MRRiflePawnMesh;
var SkeletalMeshComponent	MRRifleMesh;
var repnotify	vector 		MRRifleFlashLocation;
var repnotify	byte		MRRifleFlashCount;
var          	Vector2D	MRRifleWeaponAimOffset;
var             Name        MRRifleSocketName;

// Cosmetic meshes
var SkeletalMeshComponent	FLTurretMesh;
var SkeletalMeshComponent	RLTurretMesh;

// Turrets

/** bones where the turret controller places their hands **/
var name LeftHandBoneHandleName;
var name RightHandBoneHandleName;

///////////////////////////////////////////////////////////////////////////
// POST PROCESS EFFECT
/** MI that is used by the post process, that is modified as Reaver rider looks around */
var(PostProcess)		MaterialInstance	OverlayMI;
/** King Raven additional post process chain */
var(PostProcess)		PostProcessChain	OverlayEffect;


/** Amount to increase 'spreead' in effect as we boost */
var(PostProcess)		float				OverlaySpreadFactor;
/** Amount to blend in effect as we boost */
var(PostProcess)		float				OverlayEffectFactor;

/** Allow seat changing to debug cameras, model placement, etc. */
var()                   bool                bDebugAllowSeatChanging;

replication
{
	if (bNetDirty)
		FRTurretFlashLocation, FRRifleFlashLocation, MRRifleFlashLocation, RRTurretFlashLocation;
	if (!IsSeatControllerReplicationViewer(1) || bDemoRecording)
		FRTurretFlashCount, FRTurretWeaponRotation;
	if (!IsSeatControllerReplicationViewer(2) || bDemoRecording)
		FRRifleFlashCount, FRRifleWeaponAimOffset;
	if (!IsSeatControllerReplicationViewer(3) || bDemoRecording)
		MRRifleFlashCount, MRRifleWeaponAimOffset;
	if (!IsSeatControllerReplicationViewer(4) || bDemoRecording)
		RRTurretFlashCount, RRTurretWeaponRotation;
}

cpptext
{
	// Actor interface.
	virtual void TickSpecial(FLOAT DeltaSeconds);

	void UpdateAimOffset(INT SeatIndex, FVector2D& NewAimOffsetPct, FLOAT DeltaTime);

	/**
	 * Replicate the aim offset for a given seat
	 *
	 * @param SeatIndex - the seat that is getting a new aim offset
	 *
	 * @param AimOffsetPct - the new aim offset
	 */
	void SetReplicatedAimOffsetRot(INT SeatIndex, const FVector2D& AimOffsetPct);

	/**
	 * Retrieve the replicated aim offset for a given seat
	 *
	 * @param SeatIndex - the seat that is getting a new aim offset
	 *
	 * @param out_AimOffsetPct - the new aim offset
	 */
	void GetReplicatedAimOffsetRot(INT SeatIndex, FVector2D& out_AimOffsetPct);

	/**
	 * Used for SkelControlLimb in BCS_BaseMeshSpace mode.
	 *
	 * @param SkelControlled - the mesh being modified by the skel control
	 *
	 * @return the skeletal mesh component to use for the transform calculation
	 */
	virtual USkeletalMeshComponent* GetMeshForSkelControlLimbTransform(const USkeletalMeshComponent* SkelControlled);
}

/** Attach components etc - (client + server) */
simulated event PostBeginPlay()
{
	// Set the seat meshes
	Seats[1].Mesh = FRTurretMesh;
	//Seats[2].Mesh = FRRifleMesh;
	//Seats[3].Mesh = MRRifleMesh;
	Seats[4].Mesh = RRTurretMesh;

	//Attach the miniguns
	Mesh.AttachComponentToSocket(FRTurretMesh, 'FR_Gunner_Mount');
	Mesh.AttachComponentToSocket(RRTurretMesh, 'BR_Gunner_Mount');
	Mesh.AttachComponentToSocket(FLTurretMesh, 'FL_Gunner_Mount');
	Mesh.AttachComponentToSocket(RLTurretMesh, 'BL_Gunner_Mount');

	//Create the rifle array for storing aim offsets
	AssaultRifleInfos.length = 4;

	//Attach the rifle turrets (player to heli, rifle to player)
	Mesh.AttachComponentToSocket(FRRiflePawnMesh, 'FR_Rifle_Mount');
	FRRiflePawnMesh.SetTranslation(Seats[2].SeatOffset);
	Mesh.AttachComponentToSocket(MRRiflePawnMesh, 'MR_Rifle_Mount');
	MRRiflePawnMesh.SetTranslation(Seats[3].SeatOffset);

	FRRiflePawnMesh.AttachComponentToSocket(FRRifleMesh, FRRifleSocketName);
	MRRiflePawnMesh.AttachComponentToSocket(MRRifleMesh, MRRifleSocketName);

	FRRiflePawnMesh.SetHidden(TRUE);
	FRRifleMesh.SetHidden(TRUE);
	MRRiflePawnMesh.SetHidden(TRUE);
	MRRifleMesh.SetHidden(TRUE);

	//All attachments must happen above to allow InitializeSeats() to find things properly
	Super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		Health = DefaultRavenHealth;
	}

	AttachMinigunComponents();
	AttachRifleComponents();

	//Start helicopter sounds/blades?
}

/** All foley/effects for the assault rifle weapon on the raven */
simulated function AttachRifleComponents()
{
	local name MuzzleSocketName;
	local vector MuzzleLightOffsetFromCannon;

	// position so it lights better the character when firing
	MuzzleLightOffsetFromCannon.X=10;
	MuzzleLightOffsetFromCannon.Y=5;
	MuzzleLightOffsetFromCannon.Z=10;

	MuzzleSocketName = Seats[2].GunSocket[GetBarrelIndex(2)];

	// attach muzzle flash emitter, and position to fire offset
	if( RifleEffects[2].MuzFlashEmitter != None )
	{
		FRRifleMesh.AttachComponentToSocket(RifleEffects[2].MuzFlashEmitter, MuzzleSocketName);
		RifleEffects[2].MuzFlashEmitter.SetHidden(TRUE);
	}

	// Muzzle Flash dynamic light
	if( RifleEffects[2].MuzzleFlashLight != None )
	{
		RifleEffects[2].MuzzleFlashLight.SetTranslation(MuzzleLightOffsetFromCannon);
		FRRifleMesh.AttachComponentToSocket(RifleEffects[2].MuzzleFlashLight, MuzzleSocketName);
	}

	MuzzleSocketName = Seats[3].GunSocket[GetBarrelIndex(3)];

	// attach muzzle flash emitter, and position to fire offset
	if( RifleEffects[3].MuzFlashEmitter != None )
	{
		MRRifleMesh.AttachComponentToSocket(RifleEffects[3].MuzFlashEmitter, MuzzleSocketName);
		RifleEffects[3].MuzFlashEmitter.SetHidden(TRUE);
	}

	// Muzzle Flash dynamic light
	if( RifleEffects[3].MuzzleFlashLight != None )
	{
		RifleEffects[3].MuzzleFlashLight.SetTranslation(MuzzleLightOffsetFromCannon);
		MRRifleMesh.AttachComponentToSocket(RifleEffects[3].MuzzleFlashLight, MuzzleSocketName);
	}
}

simulated function AttachMinigunComponents()
{
	// Create PSC for minigun muzzle effects
	MinigunEffects[1].PSC_MinigunMuzzleEffect = new(self) class'ParticleSystemComponent';
	FRTurretMesh.AttachComponentToSocket( MinigunEffects[1].PSC_MinigunMuzzleEffect, Seats[1].GunSocket[0] );
	MinigunEffects[1].PSC_MinigunMuzzleEffect.SetTemplate( MinigunMuzzleEffect );

	MinigunEffects[4].PSC_MinigunMuzzleEffect = new(self) class'ParticleSystemComponent';
	RRTurretMesh.AttachComponentToSocket( MinigunEffects[4].PSC_MinigunMuzzleEffect, Seats[4].GunSocket[0] );
	MinigunEffects[4].PSC_MinigunMuzzleEffect.SetTemplate( MinigunMuzzleEffect );
}

/** Cache pointers to anim nodes - (client + server) */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local int SeatIndex;
	local GearAnim_VehicleSeatAimOffset Node;

	Super.PostInitAnimTree(SkelComp);

	//Find the rifle aim offset node for runtime manipulation
	if (SkelComp == MRRiflePawnMesh)
	{
		SeatIndex = 3;
	}
	else if (SkelComp == FRRiflePawnMesh)
	{
		SeatIndex = 2;
	}

	if (SeatIndex > 0)
	{
		//Should only be one rifle aim node per mesh
		foreach SkelComp.AllAnimNodes(class'GearAnim_VehicleSeatAimOffset', Node)
		{
			Node.MyVehicle = self;
			Node.MySeatIndex = SeatIndex;
			break;
		}
	}
}

/** Return the aimoffsetpct for use in a GearAnim_AimOffset by seat index */
simulated event vector2d GetAimOffsetForSeat(int SeatIndex)
{
	return AssaultRifleInfos[SeatIndex].AimOffset;
}

/** Handle repnotify vars (client only) */
simulated function ReplicatedEvent(name VarName)
{
	Super.ReplicatedEvent(VarName);

	if (VarName == 'SeatMask')
	{
		SeatMaskUpdated();
	}
}

/** (client + server) */
simulated function int GetVehicleDefaultHealth()
{
	return DefaultRavenHealth;
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	local VehicleSeat SeatData;

	Super.OnToggleHidden(Action);

	// Also hide any driver/gunner
	if(Driver != None)
	{
		Driver.OnToggleHidden(Action);
	}

	foreach Seats(SeatData)
	{
		// SeatPawns can be set to the vehicle, usually seat 0, avoid infinite recursion
		if (SeatData.SeatPawn != None && SeatData.SeatPawn != Self)
		{
			SeatData.SeatPawn.OnToggleHidden(Action);
		}
	}
}

/** (client + server) */
simulated event Tick(float DeltaTime)
{
	local GearPC GPC;
	local int HealAmount;

	Super.Tick(DeltaTime);

	// Try and find a controller to look at its input
	if(Controller != None)
	{
		GPC = GearPC(Controller);
	}
	else if(Seats[1].SeatPawn != None)
	{
		GPC = GearPC(Seats[1].SeatPawn.Controller);
	}

	// Got a controller, pass input to server
	if(GPC != None)
	{
		// Only do this stuff on owning client
		if(LocalPlayer(GPC.Player) != None)
		{
		}

		UpdateOverlayEffects( GPC );
	}

	// Handle healing
	if(Role == ROLE_Authority)
	{
		// If hurt, heal
		if(Health < DefaultRavenHealth)
		{
			// We need to save off partially healed points
			PartialHealth += DeltaTime * HealthRechargeRate;
			if ( PartialHealth >= 1.f )
			{
				HealAmount = FFloor(PartialHealth);
				PartialHealth -= HealAmount;
				Health += HealAmount;
			}
		}
		// Not healing, reset heal counter
		else
		{
			PartialHealth = 0.0;
		}
	}

	UpdateTurret(1, DeltaTime);
	UpdateRifleTurret(2, DeltaTime);
	UpdateRifleTurret(3, DeltaTime);
	UpdateTurret(4, DeltaTime);
}

/* Given a seat index, return the orientation and position of the muzzle socket defined by Seats */
simulated native function GetBarrelLocationAndRotation(int SeatIndex, out vector OutLocation, optional out rotator OutRotation);

event bool DriverLeave(bool bForceLeave)
{
	local bool	 bLeft;
	local GearPC GPC;

	GPC = GearPC(Controller);
	bLeft = Super.DriverLeave( bForceLeave );
	if( bLeft && GPC != None )
	{
		ClientSetCameraEffect( GPC, FALSE );
	}
	return bLeft;
}

/** Update the overlay parameters for a local GearPC */
simulated function UpdateOverlayEffects( GearPC PC )
{
	local Vector  FwdDir, CamLoc;
	local Rotator CamRot;
	local float	  DotP;

	// Only do this for local players
	if( PC == None || OverlayMI == None || LocalPlayer(PC.Player) == None)
		return;

	FwdDir = Vector(Rotation);
	PC.GetPlayerViewPoint( CamLoc, CamRot );

	DotP = Abs(FwdDir DOT Vector(CamRot));
	OverlayMI.SetScalarParameterValue( 'UseEffect',		DotP * OverlayEffectFactor );
	OverlayMI.SetScalarParameterValue( 'OverallSpread', DotP * OverlaySpreadFactor );
}

/** turns on or off the camera effect */
simulated function SetCameraEffect(Controller C, bool bEnabled)
{
	local GearPC PC;
	local LocalPlayer LP;
	local MaterialEffect NewEffect;
	local int i;
	local MaterialInstanceConstant CurrentMI;

	PC = GearPC(C);
	if (PC != None)
	{
		LP = LocalPlayer(PC.Player);
		if (LP != None)
		{
			if (bEnabled && !PC.bHasVehicleOverlay)
			{
				LP.InsertPostProcessingChain(OverlayEffect, INDEX_NONE, true);

				NewEffect = MaterialEffect(LP.PlayerPostProcess.FindPostProcessEffect('MotionEffect'));
				if(NewEffect != None)
				{
					// Create instance for this reaver if necessary
					if(OverlayMI == None)
					{
						CurrentMI = MaterialInstanceConstant(NewEffect.Material);
						OverlayMI = new(None) class'MaterialInstanceConstant';
						OverlayMI.SetParent(CurrentMI);
					}

					NewEffect.Material = OverlayMI;
				}

				PC.bHasVehicleOverlay = TRUE;
			}
			else if (!bEnabled && PC.bHasVehicleOverlay)
			{
				for (i = 0; i < LP.PlayerPostProcessChains.length; i++)
				{
					if (LP.PlayerPostProcessChains[i].FindPostProcessEffect('MotionEffect') != None)
					{
						LP.RemovePostProcessingChain(i);
						i--;
					}
				}

				PC.bHasVehicleOverlay = FALSE;
			}
		}
	}
}

/** turns on or off the camera effect */
reliable client function ClientSetCameraEffect(Controller C, bool bEnabled)
{
	SetCameraEffect(C, bEnabled);
}


simulated function BlowupVehicle(Controller Killer)
{
	Super.BlowupVehicle(Killer);

	// hide driver and turret
	//DriverComp.DetachFromAny();
	//PassengerComp.DetachFromAny();
	StopTurretEffects(false, 1);
	StopRifleEffects(false, 2);
	StopRifleEffects(false, 3);
	StopTurretEffects(false, 4);
}

/* Update the IK, rotation of the pawn sitting in the given seat */
native simulated function UpdateTurret(int SeatIndex, float DeltaTime);

native simulated function UpdateRifleTurret(int SeatIndex, float DeltaTime);

/**
* @Returns true if a seat is not occupied
* overloaded to avoid the driver seat 0
*/
function bool SeatAvailable(int SeatIndex)
{
	return SeatIndex != 0 && (Seats[SeatIndex].SeatPawn == none || Seats[SeatIndex].SeatPawn.Controller == none);
}

/**
* returns true if Pawn P successfully became driver of this vehicle
*/
function bool TryToDrive(Pawn P)
{
	if( !CanEnterVehicle( P ) )
	{
		return FALSE;
	}

	return PassengerEnter(P, GetFirstAvailableSeat());
}

/** Return the rotation of the vehicle used as basis for vehicle-space camera */
simulated function rotator GetVehicleSpaceCamRotation(float DeltaTime, bool bPassenger, optional int SeatIndex=-1)
{
	local rotator RelRot;

	if (SeatIndex > 0 && SeatIndex < Seats.length)
	{
		RelRot.Yaw = Seats[SeatIndex].BaseYawOffset;
		return RTransform(RelRot, Rotation);
	}

	return Rotation;
}

/**
* Called after AttachDriver (Vehicle or WeaponPawn), orients the driver in the vehicle
* turns off physics
* Network : ALL
* @param WP - pawn to orient in the vehicle
* @param SeatIndex - Seat to put pawn in
*/
simulated function SitDriver( GearPawn WP, int SeatIndex)
{
	Super.SitDriver(WP, SeatIndex);

	if (SeatIndex == 1 || SeatIndex == 4)
	{
		WP.HolsterWeapon();
	}

	WP.bCanDBNO = FALSE;
}

/**
* Called when a passenger enters the vehicle
*
* @param P				The Pawn entering the vehicle
* @param SeatIndex		The seat where he is to sit
*/

function bool PassengerEnter(Pawn P, int SeatIndex)
{
	local bool bEntered;
	local GearAI AIController;

	AIController = GearAI(P.Controller);

	bEntered = Super.PassengerEnter(P, SeatIndex);
	if ((AIController != None) && bEntered)
	{
		if (SeatIndex == 1 || SeatIndex == 4)
		{
			SetupTurretAI(AIController);
		}
		else
		{
			SetupAssaultRifleAI(AIController);
		}
	}

	SeatMaskUpdated();

	return bEntered;
}

/**
* Called when a passenger leaves the vehicle
*
* @param	SeatIndex		Leaving from which seat
*/
function PassengerLeave(int SeatIndex)
{
	if (Seats[SeatIndex].StoragePawn != None)
	{
		GearPawn(Seats[SeatIndex].StoragePawn).bCanDBNO = TRUE;
	}

	Super.PassengerLeave(SeatIndex);

	SeatMaskUpdated();
}

simulated function SeatMaskUpdated()
{
	local int Mask;

	Mask = (1 << 2);
	if ((SeatMask & Mask) > 0)
	{
		FRRiflePawnMesh.SetHidden(FALSE);
		FRRifleMesh.SetHidden(FALSE);
	}
	else
	{
		FRRiflePawnMesh.SetHidden(TRUE);
		FRRifleMesh.SetHidden(TRUE);
	}

	Mask = (1 << 3);
	if ((SeatMask & Mask) > 0)
	{
		MRRiflePawnMesh.SetHidden(FALSE);
		MRRifleMesh.SetHidden(FALSE);
	}
	else
	{
		MRRiflePawnMesh.SetHidden(TRUE);
		MRRifleMesh.SetHidden(TRUE);
	}
}

/** (client + server) */
simulated event float GetCameraFOV(int SeatIndex)
{
	local Controller UseC;

	// Find controller to look at for targetting
	if(SeatIndex == 0)
	{
		UseC = Controller;
	}
	else
	{
		UseC = Seats[SeatIndex].SeatPawn.Controller;
	}

	if(UseC != None && GearPC(UseC).bIsTargeting)
	{
		return TargetingFOV;
	}
	else
	{
		return DefaultFOV;
	}
}

simulated function vector GetCameraWorstCaseLoc( int SeatIndex )
{
	local Vector CamLoc;

	if (SeatIndex < 3)
	{
		Mesh.GetSocketWorldLocationAndRotation('WorstCameraFront', CamLoc);
	}
	else
	{
		Mesh.GetSocketWorldLocationAndRotation('WorstCameraRear', CamLoc);
	}

	CamLoc += (Seats[SeatIndex].WorstCameraLocOffset >> Rotation);
	return CamLoc;
}

/**
* Get the camera start location for a weapon pawn on this vehicle
* @param SeatIndex - seat requesting the starting view location
*/
simulated event vector GetPawnViewLocationForSeat(int SeatIndex)
{
	local SkeletalMeshComponent RifleMesh;
	local vector MuzzleLoc;

	if (SeatIndex == 2)
	{
		RifleMesh = FRRifleMesh;
	}
	else if (SeatIndex == 3)
	{
		RifleMesh = MRRifleMesh;
	}

	if (RifleMesh != None && RifleMesh.GetSocketWorldLocationAndRotation('Muzzle', MuzzleLoc))
	{
		return MuzzleLoc;
	}

	return Super.GetPawnViewLocationForSeat(SeatIndex);
}

simulated function bool ShouldShowWeaponOnHUD(GearPC PC)
{
	local GearWeaponPawn WP;

	WP = GearWeaponPawn(PC.Pawn);
	return (WP != None && WP.MyVehicle == self);
}

function SetupTurretAI(GearAI AIController)
{
	// abort current combat command if there is one
	AIController.AbortCommand(None, AIController.DefaultCommand);
	// switch to mounted gunner
	class'AICmd_Base_MountedGunner'.static.InitCommand(AIController);
}

function SetupAssaultRifleAI(GearAI AIController)
{
	// abort current combat command if there is one
	AIController.AbortCommand(None, AIController.DefaultCommand);
	// switch to mounted gunner
	class'AICmd_Base_MountedGunner'.static.InitCommand(AIController);
}

/** Called when a client presses X while in the vehicle. (server only) */
reliable server function ServerPressedX()
{
	if (bDebugAllowSeatChanging)
	{
		ServerAdjacentSeat(1, Controller);
	}
}

/** Called when a passenger presses X */
simulated function PassengerPressedX(Controller C)
{
	if (bDebugAllowSeatChanging)
	{
		ServerAdjacentSeat(1, C);
	}
}

/** Used so we can override damage using our own table */
simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// make sure we are the server and we're alive
	if (Role < ROLE_Authority || Health <= 0 || InGodMode() || Seats[1].SeatPawn.InGodMode() )
	{
		return;
	}

	// Ignore yourself doing damage
	if((EventInstigator != None) && (EventInstigator == Controller || EventInstigator == Seats[1].SeatPawn.Controller))
	{
		return;
	}
}

simulated function PlayTurretEffects(int SeatIndex, vector HitLocation)
{
	local float HitDistance;
	local vector MuzzleLocation;
	local rotator MuzzleRotation;

	//Start looping minigun sound
	if (MinigunEffects[SeatIndex].MinigunFiringLoopAC == None)
	{
		MinigunEffects[SeatIndex].MinigunFiringLoopAC = VehiclePlayLocalSound(MinigunFireLoop, MinigunFireLoop_Player);
	}
	//Start looping heat buildup sound
	if (MinigunEffects[SeatIndex].HeatBuildUpAC == None)
	{
		MinigunEffects[SeatIndex].HeatBuildUpAC = VehiclePlayLocalSound(HeatBuildupCue);
	}

	//Spawn tracer on owning client
	HitDistance = VSize(HitLocation - Location);
	GetBarrelLocationAndRotation(SeatIndex, MuzzleLocation, MuzzleRotation);
	Seats[SeatIndex].GunClass.static.SpawnTracerEffect( Instigator, MuzzleLocation, MuzzleRotation, HitLocation, HitDistance );

	//Muzzle light/particles
	MinigunEffects[SeatIndex].PSC_MinigunMuzzleEffect.ActivateSystem(FALSE);
	TriggerVehicleMuzzleLight(MinigunEffects[SeatIndex].MinigunMuzzleLight, Seats[SeatIndex].GunSocket[0], MinigunMuzzleLightTime, SeatIndex);
}

simulated function StopTurretEffects(bool bViaReplication, int SeatIndex)
{
	if (MinigunEffects[SeatIndex].MinigunFiringLoopAC != None)
	{
		MinigunEffects[SeatIndex].MinigunFiringLoopAC.FadeOut(0.2f, 0.f);
		MinigunEffects[SeatIndex].MinigunFiringLoopAC = None;
	}

	if (MinigunEffects[SeatIndex].HeatBuildUpAC != None)
	{
		MinigunEffects[SeatIndex].HeatBuildUpAC.FadeOut(0.2f, 0.0f);
		MinigunEffects[SeatIndex].HeatBuildUpAC = None;
	}

	VehiclePlayLocalSound(MinigunFireStopCue, MinigunFireStopCue_Player);
}

simulated function PlayRifleEffects(int SeatIndex, vector HitLocation)
{
	local float HitDistance;
	local Controller PawnController;
	local vector MuzzleLocation;
	local rotator MuzzleRotation;
	PawnController = Seats[SeatIndex].SeatPawn.Controller;

	//AssaultRifle.PlayFireSounds();
	PlayRifleFireSound(SeatIndex);

	//AssaultRifle.PlayMuzzleFlashEffect();
	PlayRifleMuzzleFlashEffect(SeatIndex);

	//Weapon anim?
	//Force feedback handled by content class override
	//Shell case?

	// Play fire effects for owned player
	if (WorldInfo.Netmode != NM_Client || (Instigator != None && Instigator.IsLocallyControlled(PawnController)))
	{
		//Spawn tracer on owning client
		HitDistance = VSize(HitLocation - Location);

		GetBarrelLocationAndRotation(SeatIndex, MuzzleLocation, MuzzleRotation);
		Seats[SeatIndex].GunClass.static.SpawnTracerEffect( Instigator, MuzzleLocation, MuzzleRotation, HitLocation, HitDistance );
	//camerashake, recoil effect on view

		//DrawDebugSphere(MuzzleLocation, 10, 10, 0, 255, 0, TRUE);
	}

}

simulated function PlayRifleMuzzleFlashEffect(int SeatIndex)
{
	if( !RifleEffects[SeatIndex].bPlayingMuzzleFlashEffect && !RifleEffects[SeatIndex].bSuppressMuzzleFlash ) // && IsMuzzleFlashRelevant() )
	{
		RifleEffects[SeatIndex].bPlayingMuzzleFlashEffect = TRUE;

		// activate muzzle flash particle system
		if( RifleEffects[SeatIndex].MuzFlashEmitter != None )
		{
			//ClearTimer( 'HideMuzzleFlashEmitter' );
			RifleEffects[SeatIndex].MuzFlashEmitter.SetHidden( FALSE );
			RifleEffects[SeatIndex].MuzFlashEmitter.ActivateSystem();
		}

		if( RifleEffects[SeatIndex].MuzzleFlashLight != None && !GearGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator) )
		{
			RifleEffects[SeatIndex].MuzzleFlashLight.SetEnabled(TRUE);
		}
	}
}

simulated function StopRifleMuzzleFlashEffect(int SeatIndex)
{
	if( RifleEffects[SeatIndex].bPlayingMuzzleFlashEffect )
	{
		RifleEffects[SeatIndex].bPlayingMuzzleFlashEffect = FALSE;

		// deactivate muzzle flash particle system
		if( RifleEffects[SeatIndex].MuzFlashEmitter != None )
		{
			RifleEffects[SeatIndex].MuzFlashEmitter.DeactivateSystem();
			//SetTimer( 0.1f, FALSE, nameof(HideMuzzleFlashEmitter) );
			RifleEffects[SeatIndex].MuzFlashEmitter.SetHidden( TRUE );
		}

		// turn off muzzle flash light
		if( RifleEffects[SeatIndex].MuzzleFlashLight != None )
		{
			RifleEffects[SeatIndex].MuzzleFlashLight.SetEnabled(FALSE);
		}
	}
}

simulated function PlayRifleFireSound(int SeatIndex)
{
	if ( (RifleEffects[SeatIndex].FireLoopAC == None) || !RifleEffects[SeatIndex].FireLoopAC.IsPlaying() )
	{
		// start loop
		RifleEffects[SeatIndex].FireLoopAC = VehiclePlayLocalSound(FireSound, FireSound_Player, RifleEffects[SeatIndex].FireLoopAC);
		if( RifleEffects[SeatIndex].FireLoopAC != None )
		{
			RifleEffects[SeatIndex].FireLoopAC.bStopWhenOwnerDestroyed = TRUE;
		}
	}

	// Maybe alert AI of the noise
	if ( (WorldInfo.Netmode != NM_Client) && Instigator != None )
	{
		Instigator.MakeNoise( 1.f,'PlayFireSound' );
	}
}

simulated function StopRifleFireLoopingAudio(int SeatIndex)
{
	if (RifleEffects[SeatIndex].FireLoopAC != None)
	{
		RifleEffects[SeatIndex].FireLoopAC.FadeOut(0.1f, 0.f);
		RifleEffects[SeatIndex].FireLoopAC = None;
	}

	VehiclePlayLocalSound(StopFireSound, StopFireSound_Player);
}

simulated function StopRifleEffects(bool bViaReplication, int SeatIndex)
{
	StopRifleFireLoopingAudio(SeatIndex);
	StopRifleMuzzleFlashEffect(SeatIndex);

	//Freeze anim
}

simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
	Super.VehicleWeaponFireEffects(HitLocation, SeatIndex);

	if (SeatIndex == 1 || SeatIndex == 4)
	{
		PlayTurretEffects(SeatIndex, HitLocation);
	}
	else
	{
		PlayRifleEffects(SeatIndex, HitLocation);
	}
}

simulated function VehicleWeaponStoppedFiring( bool bViaReplication, int SeatIndex )
{
	if (SeatIndex == 1 || SeatIndex == 4)
	{
		StopTurretEffects(bViaReplication, SeatIndex);
	}
	else
	{
		StopRifleEffects(bViaReplication, SeatIndex);
	}

	Super.VehicleWeaponStoppedFiring(bViaReplication, SeatIndex);
}

/** Origin used for AimOffset calculation. (Stolen from GearPawn.uc) */
simulated event Vector GetAimOffsetOriginForSeat(int SeatIndex)
{
	local SkeletalMeshComponent	RiflePawnMesh;
	local Name					RifleHandName, PelvisBoneName;
	local Vector				VectorLoc, SocketLoc, X, Y, Z;
	local Rotator				SocketRot;
	local quat					BoneQuat;

	if( Mesh == None  )
	{
		return Location;
	}

	//Return the mesh set in the seat if there is a valid one
	if (SeatIndex == 2)
	{
		RiflePawnMesh = FRRiflePawnMesh;
		RifleHandName = FRRifleSocketName;
	}
	else if (SeatIndex == 3)
	{
		RiflePawnMesh = MRRiflePawnMesh;
		RifleHandName = MRRifleSocketName;
	}

	if (RiflePawnMesh != None)
	{
		// Use weapon location as aimoffset origin, for better alignment.
		if (Seats[SeatIndex].SeatPawn.IsHumanControlled())
		{
			// Try as a socket first
			if( RiflePawnMesh.GetSocketWorldLocationAndRotation(RifleHandName, SocketLoc, SocketRot) )
			{
				GetAxes(SocketRot, X, Y, Z);
				return SocketLoc + Z * 12.f;
			}

			// try as a bone reference next;
			if( RiflePawnMesh.MatchRefBone(RifleHandName) != INDEX_NONE )
			{
				BoneQuat = RiflePawnMesh.GetBoneQuaternion(RifleHandName);
				SocketRot = QuatToRotator(BoneQuat);
				GetAxes(SocketRot, X, Y, Z);
				return RiflePawnMesh.GetBoneLocation(RifleHandName) + Z * 12.f;
			}
		}

		PelvisBoneName = 'b_MF_Pelvis';
		if( RiflePawnMesh.MatchRefBone(PelvisBoneName) != INDEX_NONE )
		{
			VectorLoc = RiflePawnMesh.GetBoneLocation(PelvisBoneName);
			VectorLoc.Z = GetPawnViewLocation().Z;

			return VectorLoc;
		}
	}

	// Otherwise take default view location
	return Location;
}

/** Properly manipulate the rifle proxy meshes from EditActor */
event OnPropertyChange(name PropName)
{
	//Attach the rifle turrets
	FRRiflePawnMesh.SetTranslation(Seats[2].SeatOffset);

	MRRiflePawnMesh.SetTranslation(Seats[3].SeatOffset);

	Super.OnPropertyChange(PropName);
}

defaultproperties
{
	// so the matinees can link to the reaver correctly - could be done differently if bNoDelete causes pain
	bNoDelete=true

	// matinee controlled, so shouldn't need any of this stuff
	bReplicateMovement=false
	bUpdateSimulatedPosition=false

	Begin Object Class=AudioComponent Name=FaceAudioComponent
	End Object
	FacialAudioComp=FaceAudioComponent
	Components.Add(FaceAudioComponent)

	Begin Object Class=SkeletalMeshComponent Name=TurretMesh0
		//BlockZeroExtent=TRUE
		//CollideActors=TRUE
		//BlockActors=TRUE
		//BlockRigidBody=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object

	Begin Object Class=SkeletalMeshComponent Name=TurretMesh1
		//BlockZeroExtent=TRUE
		//CollideActors=TRUE
		//BlockActors=TRUE
		//BlockRigidBody=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object

	Begin Object Class=SkeletalMeshComponent Name=TurretMesh2
		//BlockZeroExtent=TRUE
		//CollideActors=TRUE
		//BlockActors=TRUE
		//BlockRigidBody=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object

	Begin Object Class=SkeletalMeshComponent Name=TurretMesh3
		//BlockZeroExtent=TRUE
		//CollideActors=TRUE
		//BlockActors=TRUE
		//BlockRigidBody=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object

	Begin Object Class=SkeletalMeshComponent Name=RiflePawnMesh1
		//BlockZeroExtent=TRUE
		//CollideActors=TRUE
		//BlockActors=TRUE
		//BlockRigidBody=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
		bForceUpdateAttachmentsInTick=TRUE
	End Object

	Begin Object Class=SkeletalMeshComponent Name=RiflePawnMesh2
		//BlockZeroExtent=TRUE
		//CollideActors=TRUE
		//BlockActors=TRUE
		//BlockRigidBody=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
		bForceUpdateAttachmentsInTick=TRUE
	End Object

	Begin Object Class=SkeletalMeshComponent Name=RifleMesh1
		//BlockZeroExtent=TRUE
		//CollideActors=TRUE
		//BlockActors=TRUE
		//BlockRigidBody=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
		bForceUpdateAttachmentsInTick=TRUE
	End Object

	Begin Object Class=SkeletalMeshComponent Name=RifleMesh2
		//BlockZeroExtent=TRUE
		//CollideActors=TRUE
		//BlockActors=TRUE
		//BlockRigidBody=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
		bForceUpdateAttachmentsInTick=TRUE
	End Object

	bVehicleSpaceViewLimits=TRUE
	bVehicleSpaceCamera=FALSE
	bOnlyInheritVehicleSpaceYaw=FALSE
	bShowWeaponOnHUD=FALSE

	TargetingFOV=70.0

	LeftHandBoneHandleName=L_Hand_IK
	RightHandBoneHandleName=R_Hand_IK

	bCollideWithCamera=true

	//bDebugAllowSeatChanging=TRUE
}
