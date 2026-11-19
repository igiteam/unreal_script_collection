
/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
//class Turret extends SVehicle
class Turret extends KynapseSVehicle
	native
	abstract;

/**
 * Base turret code implementation
 *
 */

var() const editconst LightEnvironmentComponent LightEnvironment;

var Controller Claim;

/** Default inventory added via AddDefaultInventory() */
var array<class<Inventory> >	DefaultInventory;

/** Current Turret Aim  */
var	Rotator	AimDir;

/** desired aim dir */
var Rotator DesiredAimDir;

/** limit, in degrees, of how far from center the turret can rotate in the yaw axis */
var() Vector2D YawLimit;

var   Vector2D	AnimYawLimit; // Limits of the animation; used to determine how to aim horizontally
var   Bool		bUseAnimAim;  // See above; set during the post begin play phase

/** Player turning rate scale */
var()		float	TurretTurnRateScale;

var()	Vector	CannonFireOffset;	// from pitch bone, aligned to DesiredAim
var		name	PitchBone;
var		name	BaseBone;

/** True if exit positions are relative offsets to vehicle's location, false if they are absolute world locations */
var		bool			bRelativeExitPos;

struct native sPointOfView
{
	var()	vector	DirOffset;		// BaseRotation relative Offset
	var()	float	Distance;		// relative offset dist
	var()	float	fZAdjust;		// Adjust Z based on pitch
};

var() sPointOfView	POV;	// Camera info

/** Controls how quickly to ramp current velocity toward desired velocity.  Feels like friction in the turret joint */
var() float ViewRotInterpSpeed;

/** Turret look at controllers */
var SkelControlLookAt	Pivot_Latitude, Pivot_Longitude;

var	Name	Pivot_Latitude_BoneName;
var Name	PlayerRefSocketName;
var name	PlayerFixedRefSocketName;
var Name	PlayerEntrySocketName;

/** Normal gunner track speed */
var()	float	TrackSpeed;
/** Speed of tracking when gunner has a spotter */
var()	float	TrackSpeedWithSpotter;
/** Speed of searching */
var()	float	SearchSpeed;

/** TRUE when spotter is tracking something */
var		bool	bSpottedSomething;

/** custom replicated weapon reference */
var repnotify Weapon MyWeapon;

// Projectile stuff
var ParticleSystemComponent	MuzzleFlashPSC;
var ParticleSystem			MuzzleFlashPSCTemplate;
var ParticleSystemComponent	MuzzleSmokePSC;
var ParticleSystem			MuzzleSmokePSCTemplate;
var class<TPProjectile>		ProjectileClass;
var name MuzzleSocketName;
var bool bNeedSmoke;
var float m_ProjectileLoudness;	// How loud is this weapon compared to others?
var config Float			ProjectileSpeed;

//force feedback waveforms
var ForceFeedbackWaveform PlayerFireWaveform;

// Sound stuff
var() SoundCue FireEffectSound;	// Sound for the Firing of the Gun
var AudioComponent FireEffectAudioCmpt;
var() SoundCue NPCFireEffectSound;	// Sound for the Firing of the Gun
var AudioComponent NPCFireEffectAudioCmpt;

var Array<SoundCue>		Sound_StopFire;
var Array<SoundCue>		Sound_Attach;

var float FireRate, CurrentTime, LastTime;

//debug
var(Debug) bool bDebugTurret;

/** bones where the turret controller places their hands **/
var name LeftHandBoneHandleName;
var name RightHandBoneHandleName;

var float EntryRadius;

// Aiming stuff
var bool	bAimDownSight;		// True when aiming down the sight
var name	CloseAimSightName;	// Camera position when aiming down the sight
var name	FarAimSightName;	// Normal camera position
var config  float CloseAimFOV;

// Accuracy
var bool  bFiring;		// Are we currently firing?
var bool  bNeedsToCool; // Do we need to cool down?
var float BarrelTemp;	// What is the current temperature of the barrel?
var() float     PlayerCoolTimeNeeded; // How much time needs to pass before able to fire again after barrel temp is exceeded
var(Temp) float BurstSize;	// How many bullets/sustained burst?
var(Temp) float CooldownTime;	// How long will it take the barrel to cool down?
var Float BulletTemp; // Calculated value; how much will each bullet heat the barrel?
var float MinSpread;
var float MaxSpread;
var float AI_AccCone;

// AI
var bool      bAutomaticFiring; // True if the AI is trying to fire a burst
var bool      bAIControlled;
var(AI) float TooCloseDist;
var(AI) bool  bAbandonGun;		// True if the AI should automatically leave the gun when the enemy is too close
var(AI) bool  bCheckSix;		// True if the AI should check for enemies behind
var(AI) float CheckSixDist;		// How far behind the AI should we check? (-1 = ignore distance check)
var(AI) bool  bCheckSixVisibility; // Should we check to determine if the enemy is visible before hopping off?
var(AI) bool  bCheckPlayerOnly;

var(AI) float m_MinDistToMountTurret;

var vector m_MountLoc;


// Animation
var enum eTurretType {TU_Crouch, TU_Stand} TurretType;


native function InitKynapseEntity(string EntityDefintionName);


replication
{
	if( (bNetInitial || (!bNetOwner && bNetDirty)) && Role==ROLE_Authority )
		AimDir, MyWeapon;
}

native simulated event vector GetEntryLocation();

simulated function UpdateDriverHeadTracking()
{
	local SkelControlLookAt hTrack;
	local rotator			temp, AimRot;
	local vector			vTgtDir, TargetPoint, MuzzlePoint, MyEyePoint;

	htrack = SkelControlLookAt(Driver.Mesh.FindSkelControl('HeadTrack'));
	if (hTrack == None)
		return;
	
	if (!hTrack.bSkelControlEnabled)
		return;
	
	// Determine the target viewpoint
	Mesh.GetSocketWorldLocationAndRotation(MuzzleSocketName, MuzzlePoint, temp);
	AimRot = GetTurretAimDir();
	TargetPoint = MuzzlePoint + vector(AimRot) * 1000;
	
	Driver.GetActorEyesViewPoint(MyEyePoint, temp);
	
	vTgtDir = Normal(TargetPoint - MyEyePoint);
	if (Vector(Driver.Rotation) dot vTgtDir > 0.5)
	{
		hTrack.ControlStrength = 1;
		hTrack.StrengthTarget = 1;
		hTrack.BlendIntime = 1;
		hTrack.BlendOutTime = 1;
		hTrack.TargetLocation = TargetPoint;
	}
	else
	{
		hTrack.ControlStrength = 1;
		hTrack.StrengthTarget = 0;
		hTrack.BlendInTime = 1;
		hTrack.BlendOutTime = 1;
		hTrack.TargetLocation = MyEyePoint;
	}
}

simulated function UpdateDriver( float DeltaTime )
{
	local vector	DesiredRelativeDrivingLocation;
	local Rotator	DesiredAimYaw, AimRot;

	// Set driver's rotation to match aiming
	if (!bUseAnimAim)
		AimRot = GetTurretAimDir();
	else
		AimRot = Rotation;

	DesiredAimYaw.Yaw = AimRot.Yaw;
	Driver.SetRotation( DesiredAimYaw );

	// Move player to entry (he's not attached)
	DesiredRelativeDrivingLocation = GetEntryLocation();

    Driver.SetLocation( DesiredRelativeDrivingLocation );

	// Look in the correct spot
	UpdateDriverHeadTracking();
}

/**
 * Get Driver idle location when manning this turret.
 * Physics will try to place the player there. See UpdateDriver().
 */
simulated event vector GetDriverIdealPosition()
{
	// Code is implented in GetEntryLocation().
	return GetEntryLocation();
}

simulated function CacheAnimNodes()
{
	Pivot_Latitude	= SkelControlLookAt(Mesh.FindSkelControl('Pivot_Latitude'));
	Pivot_Longitude = SkelControlLookAt(Mesh.FindSkelControl('Pivot_Longitude'));
//	SpinSeqNode		= AnimNodeSequence(Mesh.FindAnimNode('SpinSeqNode'));
}


/** Clear references to anim nodes. */
simulated function ClearAnimNodes()
{
	Pivot_Latitude	= None;
	Pivot_Longitude	= None;
//	SpinSeqNode		= None;
}


simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	CacheAnimNodes();

	// define AimDir, as where the turret is originally looking at when placed in the level
	AimDir			= Rotation;
	DesiredAimDir	= AimDir;

	// Set the variables for the projectiles
	if (MuzzleFlashPSCTemplate != none)
	{
		MuzzleFlashPSC  = new(Outer) class'ParticleSystemComponent';
		MuzzleFlashPSC.SetTemplate(MuzzleFlashPSCTemplate);
		Mesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleSocketName);
		MuzzleFlashPSC.SetDepthPriorityGroup(SDPG_World);
		MuzzleFlashPSC.DeactivateSystem();
	}

	if (MuzzleSmokePSCTemplate != none)
	{
		MuzzleSmokePSC  = new(Outer) class'ParticleSystemComponent';
		MuzzleSmokePSC.SetTemplate(MuzzleSmokePSCTemplate);
		Mesh.AttachComponentToSocket(MuzzleSmokePSC, MuzzleSocketName);
		MuzzleSmokePSC.SetDepthPriorityGroup(SDPG_World);
		MuzzleSmokePSC.DeactivateSystem();
	}

	// Weapon temp
	bFiring = FALSE;
	BarrelTemp = 0;
	
	// Can we aim using only the animations?
	bUseAnimAim = (YawLimit.X > AnimYawLimit.X - 5) && (YawLimit.Y < AnimYawLimit.Y + 5);
	//bUseAnimAim = true;
	
	// Audio components
	if (FireEffectSound != none)
	{
		FireEffectAudioCmpt.SoundCue = FireEffectSound;
		AttachComponent(FireEffectAudioCmpt);
	}
	if (NPCFireEffectSound != none)
	{
		NPCFireEffectAudioCmpt.SoundCue = NPCFireEffectSound;
		AttachComponent(NPCFireEffectAudioCmpt);
	}
	
	// Calculate how much each bullet will heat the barrel
	BulletTemp = (1.0 / BurstSize) + (FireRate / CoolDownTime);
	
	// AI
	bAutomaticFiring = FALSE;

	m_MountLoc = (GetEntryLocation() + Location) /2.0f;
	m_MountLoc.Z = Location.Z;
}

simulated function Destroyed()
{
	// Clear references to animations nodes
	ClearAnimNodes();

	Super.Destroyed();
}


function Restart()
{
	AddDefaultInventory();
}

// Get the barrel temperature; should be normalized to 0-100%
simulated function Float GetTemperature()
{
	return BarrelTemp;
}

// Can we fire off at least one more round before the barrel is too hot?
simulated function Bool AbleToFire()
{
	return (BarrelTemp + BulletTemp) < 1.0f;
}

simulated function UpdateTurret(float DeltaTime)
{
	local rotator AimRot, BaseRot;
	local vector AimTargetLoc;
	local vector PivotLatLoc, PivotLatTarget;
	
	local Float PitchAimPercent, YawAimPercent, Yaw;

	// Get location of latitude pivot
	PivotLatLoc = Mesh.GetBoneLocation(Pivot_Latitude_BoneName);

	AimRot = GetTurretAimDir();
	BaseRot = Rotation;

	//`log(" ChadAI - Turret: " @ Self @ " UpdateTurret - AimRot.Yaw : " @ AimRot.Yaw @ " BaseRot.Yaw: " @ BaseRot.Yaw @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	// Pick a point well in front of the pivot point
	AimTargetLoc = PivotLatLoc + Vector(AimRot) * 16384;

	if( Pivot_Latitude != None )
	{
		PivotLatTarget					= AimTargetLoc;
		PivotLatTarget.Z				= PivotLatLoc.Z;
		Pivot_Latitude.TargetLocation	= PivotLatTarget;
	}

	if( Pivot_Longitude != None )
	{
		Pivot_Longitude.TargetLocation	= AimTargetLoc;
	}
	
	// Set the aim offset for the driver
	if (Driver != None)
	{
		// Determine what our desired aim angle as a percentage of the limits (of the animation)
		if (AimRot.Pitch > 32768) // Rotators are unsigned ints
			PitchAimPercent = (65536-AimRot.Pitch) / ViewPitchMin;
		else
			PitchAimPercent = AimRot.Pitch / ViewPitchMax;

		if (!bUseAnimAim)
			YawAimPercent = 0.0;
		else
		{
			Yaw = AimRot.Yaw - BaseRot.Yaw;
			if (Yaw < 0)
				Yaw += 65536;
			else if (Yaw > 65536)
				Yaw -= 65536;
			
			if (Yaw > 32768)
				YawAimPercent = (65536 - Yaw) / (AnimYawLimit.X * 182); // Degrees -> Unreal Units
			else
				YawAimPercent = Yaw / (AnimYawLimit.Y * 182);
		}
		
		AimOffset.x = YawAimPercent;
		AimOffset.y = PitchAimPercent;

		//`log(" ChadAI - Turret: " @ Self @ " UpdateTurret - bUseAnimAim : " @ bUseAnimAim @ " AimOffset.X : " @ AimOffset.x @ " AimOffset.Y: " @ AimOffset.y @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	}
}

function bool PlaceExitingDriver(optional Pawn Who)
{
	// Do not re position driver when exiting.
	return TRUE;
}


simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	// If the barrel is hot, then cool-down the barrel
	BarrelTemp -= DeltaTime / CooldownTime;
	if (BarrelTemp < 0)
		BarrelTemp = 0;
	

	UpdateTurret(DeltaTime);
	if( Driver != None )
	{
		UpdateDriver(DeltaTime);
	}
	
	// If locally controlled, handle firing
	if( IsLocallyControlled() )
	{
		// If this is a player-controled MG, then we'll need to keep firing as long as the trigger is
		// held
		if (!bAIControlled && Controller != None && Controller.bFire == 1)
			bAutomaticFiring = true;

		if (bAutomaticFiring)
			FireRound();
	}
}

/** @See Vehicle::DriverEnter */
function bool DriverEnter(Pawn P)
{
	local bool	bSuccess;

	local TPPlayerController TPController;
	local TPPawn thePawn;
	
	// if we don't have pre-defined exit positions here, we use the original player location as an exit point
	if( !bRelativeExitPos )
	{
		ExitPositions[0] =  P.Location + Vect(0,0,16);
	}

    TPController = TPPlayerController(P.Controller);
    if (TPController != None)
    {
        TPController.CancelGrenadeSwitch();
        TPController.StopSprint();
        TPController.DisableAimDownSight();
        TPController = None;
        
        thePawn = TPPawn(P);
        thePawn.HideWeapon(TRUE);
    }

	// Controller possesses turret.
	bSuccess = Super.DriverEnter(P);
	//bSuccess = DriverEnter(P);

	//`log(" ChadAI - Pawn: " @ P @ " Turret DriverEnter- after  Super.DriverEnter - Pawn.bIsCrouched: " @ P.bIsCrouched @ "  - bWantsToCrouch: " @ p.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	if (bSuccess)
	{
		// force the controller to be looking in the same direction as the turret
		if( Controller != None )
		{
			Controller.SetRotation(AimDir);

			//`log(" ChadAI - Pawn: " @ P @ " Turret DriverEnter- after  Controller.SetRotation(AimDir) - Pawn.bIsCrouched: " @ P.bIsCrouched @ "  - bWantsToCrouch: " @ p.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			
            TPController = TPPlayerController(Controller);

			bAimDownSight = false;
			if (TPController != None)
			{
                Driver.Mesh.SetHidden(true);
				//`log(" ChadAI - Pawn: " @ P @ " Turret DriverEnter- after  Driver.Mesh.SetHidden(true); - Pawn.bIsCrouched: " @ P.bIsCrouched @ "  - bWantsToCrouch: " @ p.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

				TPController.SetDesiredFOV (TPController.DefaultFOV);
				bAIControlled = false;
				//`log(" ChadAI - Pawn: " @ P @ " Turret DriverEnter- after  TPController.SetDesiredFOV (TPController.DefaultFOV); - Pawn.bIsCrouched: " @ P.bIsCrouched @ "  - bWantsToCrouch: " @ p.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			}
			else
				bAIControlled = true;
		}
		
		TriggerEventClass(class'SeqEvt_VehicleDriven',P,0);
	}

	//`log(" ChadAI - Pawn: " @ P @ " Turret DriverEnter- after  if (bSuccess) - Pawn.bIsCrouched: " @ P.bIsCrouched @ "  - bWantsToCrouch: " @ p.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

	
	bNeedSmoke = FALSE;

	return bSuccess;
}




// /** DriverEnter()
// Make Pawn P the new driver of this vehicle
// */
// function bool DriverEnter2(Pawn P)
// {
// 	local Controller C;
// 
// 	// Set pawns current controller to control the vehicle pawn instead
// 	C = P.Controller;
// 	Driver = P;
// 	Driver.StartDriving( self );
// 	if ( Driver.Health <= 0 )
// 	{
// 		Driver = None;
// 		return false;
// 	}
// 
// 	//`log(" ChadAI - Pawn: " @ P @ " Turret DriverEnter2- Before SetDriving - Pawn.bIsCrouched: " @ P.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 	SetDriving(true);
// 
// 	//`log(" ChadAI - Pawn: " @ P @ " Turret DriverEnter2- After SetDriving - Pawn.bIsCrouched: " @ P.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 	// Disconnect PlayerController from Driver and connect to Vehicle.
// 	C.Unpossess();
// 	Driver.SetOwner( Self ); // This keeps the driver relevant.
// 	C.Possess( Self, true );
// 
// 	if( PlayerController(C) != None )
// 	{
// 		PlayerController(C).GotoState( LandMovementState );
// 	}
// 
// 	WorldInfo.Game.DriverEnteredVehicle(self, P);
// 
// 	//`log(" ChadAI - Pawn: " @ P @ " Turret DriverEnter2- After DriverEnteredVehicle - Pawn.bIsCrouched: " @ P.bIsCrouched @ "  -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
// 
// 	return true;
// }









event bool DriverLeave( bool bForceLeave )
{
	local TPPawn thePawn;
	local Vector entryLoc, Up, Right, Fwd;
	local Rotator entryRot;
	
/*	if( Driver != None )
	{
		//`log(" ChadAI - Driver: " @ Driver @ " Turret:DriverLeave Start - Driver.bIsCrouched: " @ Driver.bIsCrouched @ " - bWantsToCrouch: " @ Driver.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	else
	{
		//`log(" ChadAI - Turret: " @ Self @ " Turret:DriverLeave Start - Diver is Gone -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}*/

	// Stop firing, also killing any looping sounds, effects, etc.
	StopFire(0);

	// Ensure the particles have stopped.
	MuzzleFlashPSC.DeactivateSystem();

	if (Claim != None)
	{
		UnclaimTurret(Claim);
	}
	
	TriggerEventClass(class'SeqEvt_VehicleDriven',Self,1);
	
    if (Driver != None && Driver.IsA('PlayerPawn'))
    {
        Driver.Mesh.SetHidden(false);
        thePawn = TPPawn(Driver);
        thePawn.HideWeapon(FALSE);

		// Keep the driver from getting trapped in the turret when he dismounts.        
		Mesh.GetSocketWorldLocationAndRotation(PlayerFixedRefSocketName, entryLoc, entryRot);
		entryRot.pitch = 0;
		entryRot.roll = 0;
		GetAxes(EntryRot, Fwd, Right, Up);
		entryLoc -= Right * 50.0f;
        Driver.SetLocation(entryLoc);
    }
	
	if (Super.DriverLeave(bForceLeave))
	{
/*		if( Driver != None )
		{
			//`log(" ChadAI - Driver: " @ Driver @ " Turret:DriverLeave After Super Call - Driver.bIsCrouched: " @ Driver.bIsCrouched @ " - bWantsToCrouch: " @ Driver.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}
		else
		{
			//`log(" ChadAI - Turret: " @ Self @ " Turret:DriverLeave After Super Call - Diver is Gone -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		}*/

		bAIControlled = false;
		return TRUE;
	}

	return FALSE;
}

function bool ClaimTurret( Controller C )
{
	local TPSoldierAIController AI;
	
	if (Claim == None)
	{
		Claim = C;
		bStasis = FALSE;
	
		AI = TPSoldierAIController(C);
		if (AI != None)
		{
			AI.m_CurrentTurret = self;
			AI.bForceDesiredRotation = TRUE;
		}
		return TRUE;
	}
	
	return FALSE;
}

function bool UnclaimTurret( Controller C )
{
	local TPSoldierAIController AI;
	if( Claim == C )
	{
		Claim = None;
		bStasis = TRUE;

		AI = TPSoldierAIController(C);
		if (AI != None)
		{
			AI.m_CurrentTurret = None;
			AI.bForceDesiredRotation = TRUE;
		}
	
		return TRUE;
	}

	return FALSE;
}


/**
 * Overridden to iterate through the DefaultInventory array and
 * give each item to this Pawn.
 *
 * @see			GameInfo.AddDefaultInventory
 */
function AddDefaultInventory()
{
	local int		i;
	local Inventory	Inv;

	for( i=0; i<DefaultInventory.Length; i++ )
	{
		// Ensure we don't give duplicate items
		if( FindInventoryType(DefaultInventory[i]) == None )
		{
			Inv = CreateInventory( DefaultInventory[i] );
			if( Weapon(Inv) != None )
			{
				// make weapon always replicated so it works on clients automatically
				Inv.bAlwaysRelevant = true;
				// don't allow default weapon to be thrown out
				Weapon(Inv).bCanThrow = FALSE;
				SetActiveWeapon(Weapon(Inv));
			}
		}
	}
}

simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
	// set replicated var
	MyWeapon = NewWeapon;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'MyWeapon')
	{
		PlayWeaponSwitch(Weapon, MyWeapon);
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C, bVehicleTransition);

	// make sure our new owner has the correct weapon set
	if (Weapon != None)
	{
		Weapon.bNetDirty = true;
		//SPARK OCT CODEDROP
		//Weapon.NetUpdateTime = WorldInfo.TimeSeconds - 1.0;
		Weapon.ClientWeaponSet(false);
	}
}

/** @See Pawn::ProcessViewRotation */
simulated function ProcessViewRotation(float DeltaTime, out rotator OutViewRot, out Rotator OutDeltaRot)
{
	local float Perc;
	local TPPlayerController TPController;
	local Float FOV, DefaultFOV, a, b;

	TPController = TPPlayerController(Controller);
	
	if (TPController != None)
	{
		FOV = TPController.DesiredFOV;
		DefaultFOV = TPController.DefaultFOV;

		// Scale the inputs when we zoom in so that the controller moves at a predictable
		// rate regardless of the field-of-view
		if ( FOV < DefaultFOV )	// If we are zoomed
		{
			a = sin(FOV*0.01745);
			b = sin(DefaultFOV*0.01745);
			Perc = a / b;
			OutDeltaRot *= Perc;
		}
	}

	// Scale player turning input
	OutDeltaRot *= TurretTurnRateScale;

	// let parents have their way...
	super.ProcessViewRotation(DeltaTime, OutViewRot, OutDeltaRot);

	if( !InFreeCam() )
	{
		// then put the clamps on!
		TurretClampYaw(OutViewRot);
	}
}



/** @See Pawn::FaceRotation */
simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	// Define relative turret rotation as being the controller rotation
	AimDir = Controller.Rotation;
}


/**
 * Perform update for AI controller.
 * tracks targets and such...
 */
function UpdateAIController(TPSoldierAIController C, float DeltaTime)
{
	//local int red;
	//local vector muzzle;
	local float		InterpSpeed, DistToTarg;
	local Vector	TargLoc, FireLoc;

	//muzzle = GetPhysicalFireStartLoc();
	
	// by default, slowest speed
	InterpSpeed = SearchSpeed;

	// Check for somebody sneaking up on us from behind
	if (bCheckSix)
	{
		if (C.EnemyBehind(CheckSixDist, bCheckSixVisibility, bCheckPlayerOnly))
		{
			//`Log("Leaving turret - somebody is behind me!");
			DriverLeave(TRUE);
			if (C.IsInState('AttackUsingCoverGoal', TRUE))
			{
				C.PopState();
			}
			else if (C.IsInState('Free_Attack_Goal', TRUE))
			{
				C.PopState();
			}
			else
				C.GotoState('Idle');
			return;
		}
	}
	
	// if we have a visible target, track it down
	if( C.HasValidTarget() )
	{
		InterpSpeed		= TrackSpeed;
		TargLoc			= C.GetFireTargetLocation();

		// If distance to target is inside our fire offset range
		DistToTarg = VSize(Location-TargLoc);
		if( DistToTarg < TooCloseDist )
		{
			// Notify AI that enemy is too close - abandon gun
			if (bAbandonGun)
			{
				//`Log("Leaving turret - somebody's close!");
				DriverLeave(TRUE);
				if (C.IsInState('AttackUsingCoverGoal', TRUE))
					C.PopState();
				else
					C.GotoState('Idle');
			}
			else
				C.TargetInsideFireArc();
			return;
		}
		
		FireLoc			= GetPhysicalFireStartLoc();
		DesiredAimDir	= Rotator(TargLoc - FireLoc);
	}
	
	// keep desired aim within limits
	if (TurretClampYaw(DesiredAimDir))
	{
		TurretOverRotated();
	}

	//DrawDebugLine(FireLoc + vector(GetTurretAimDir()) * 16384, FireLoc, 0, 128, 0);

	// Interpolate to the desired aim direction
	AimDir = RInterpTo( AimDir, DesiredAimDir, DeltaTime, InterpSpeed );

	// Update controllers rotation
	C.DesiredRotation = AimDir;

	//DrawDebugLine(FireLoc + vector(DesiredAimDir) * 16384, FireLoc, 0, 0, 255);

	//DrawDebugLine(FireLoc + vector(AimDir) * 16384, FireLoc, 255, 0, 0);
}


/**
 * Called every second when AI is Idle.
 */
function AIIdleNotification(TPSoldierAIController C)
{
	// pick a random orientation
	if( FRand() < 0.33 )
	{
		DesiredAimDir = GetRandomRotForTurretScan(C);
	}
}

/**
 * Get a random rotation for turret scanning.
 */
function Rotator GetRandomRotForTurretScan(TPSoldierAIController C)
{
	local Rotator DesiredRot;

	// pick a random orientation
	// if we saw an target, pick a destination close to where we last saw him
	if( C.HasValidTarget() )
	{
		DesiredRot = Rotator( C.GetFireTargetLocation() - C.Pawn.Location);
	}
	// otherwise just scan the area around where turret is facing
	else
	{
		DesiredRot	= Rotation;
	}

	DesiredRot.Pitch	+= Rand(2048)	- 512;
	DesiredRot.Yaw		+= Rand(8192)	- 4096;

	return DesiredRot;
}


/**
 *	Calculate camera view point, when viewing this pawn.
 *
 * @param	fDeltaTime	delta time seconds since last update
 * @param	out_CamLoc	Camera Location
 * @param	out_CamRot	Camera Rotation
 * @param	out_FOV		Field of View
 *
 * @return	true if Pawn should provide the camera point of view.
 */
simulated function bool CalcCamera(float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV)
{
	local Rotator	TempRotation, AimRot;
	local vector	CamLookAt, HitLocation, HitNormal;
	local vector	dirX, dirY, dirZ;
	local float		Elevation;

	local vector Loc;//, entry, right;
	local rotator Rot, BaseRot;
	local bool Result;

	Mesh.GetSocketWorldLocationAndRotation(MuzzleSocketName, Loc, BaseRot);
	AimRot = GetTurretAimDir();
	CamLookAt = Loc + vector(AimRot) * 16384;

	// Base Direction (Only YAW)
	TempRotation.Pitch	= 0;
	TempRotation.Yaw	= AimRot.Yaw;
	TempRotation.Roll	= 0;
	GetAxes(TempRotation, dirX, dirY, dirZ);
	out_CamLoc = Location + POV.Distance * (dirX*POV.DirOffset.X + dirY*POV.DirOffset.Y + dirZ*POV.DirOffset.Z);

	Elevation = float(NormalizeRotAxis( AimRot.Pitch ));	// elevation angle the controller is aiming at

	// Z Adjust based on pitch
	out_CamLoc = out_CamLoc + vect(0,0,1) * POV.fZAdjust * (Elevation / FMax(-ViewPitchMin,ViewPitchMax));

	if( Trace( HitLocation, HitNormal, out_CamLoc, Location, false, vect(10, 10, 10) ) != None )
	{
		out_CamLoc = HitLocation + HitNormal * 10;
	}


	// If we have a usable socket, just use that as the camera's eye point
	if (bAimDownSight)
		result = Mesh.GetSocketWorldLocationAndRotation(CloseAimSightName, Loc, Rot);
	else
		result = Mesh.GetSocketWorldLocationAndRotation(FarAimSightName, Loc, Rot);
		
	if (result)
	{
		// Look at the turret from the right side - used for testing
/*		entry = Loc;
		CamLookAt = entry;
		
		right = -dirY * 200.0f;
		Loc = entry - right;*/
		
		out_CamLoc = Loc;
	}

	//
	// rotate camera to match focus point
	//
	out_CamRot = Rotator(CamLookAt - out_CamLoc);

	return true;
}

/** Physical fire start location. (from weapon's barrel in world coordinates) */
simulated function vector GetPhysicalFireStartLoc()
{
	local vector	MuzzleLoc;
	local rotator	MuzzleRot;

	Mesh.GetSocketWorldLocationAndRotation(MuzzleSocketName, MuzzleLoc, MuzzleRot);
	return MuzzleLoc;
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	return GetPhysicalFireStartLoc();
}

simulated function Rotator GetViewRotation()
{
	return AimDir;
}

simulated function Vector GetPawnViewLocation()
{
	// If there is no driver, then use the muzzle, otherwise use the driver's viewpoint
	if (Driver != None)
		return Driver.GetPawnViewLocation();
	else
		return GetPhysicalFireStartLoc();
}

/**
 * returns base Aim Rotation without any adjustment (no aim error, no autolock, no adhesion.. just clean initial aim rotation!)
 *
 * @return	base Aim rotation.
 */
simulated singular function Rotator GetBaseAimRotation()
{
	local vector	POVLoc;
	local rotator	POVRot;

	// If we have a controller, by default we aim at the player's 'eyes' direction
	// that is by default Controller.Rotation for AI, and camera (crosshair) rotation for human players.
	if( Controller != None && !InFreeCam() )
	{
		Controller.GetPlayerViewPoint(POVLoc, POVRot);
		return POVRot;
	}

	// If we have no controller, we simply use our rotation
	POVRot = GetTurretAimDir();

	// If our Pitch is 0, then use RemoveViewPitch
	if( POVRot.Pitch == 0 )
	{
		POVRot.Pitch = RemoteViewPitch << 8;
	}

	return POVRot;
}

// Limit how far the user (player/AI) can rotate the turret.
simulated final function bool TurretClampYaw( out Rotator Rot )
{
	local int		DeltaFromCenter, YawAdj;
	local bool		bResult;
	local Vector2D	YawLimitR;

	DeltaFromCenter = NormalizeRotAxis(Rot.Yaw - Rotation.Yaw);
	
	// Convert the limits from degrees to Unreal units.
	YawLimitR.X = YawLimit.X * 32768.0 / 180.0;
	YawLimitR.Y = YawLimit.Y * 32768.0 / 180.0;

	if( DeltaFromCenter > YawLimitR.Y )
	{
		YawAdj	= YawLimitR.Y - DeltaFromCenter;
		bResult = TRUE;
	}
	else if( DeltaFromCenter < YawLimitR.X )
	{
		YawAdj	= -(DeltaFromCenter - YawLimitR.X);
		bResult = TRUE;
	}


	Rot.Yaw += YawAdj;

	return bResult;
}

// Function to notify the AI when the turret has been over-rotated
simulated function TurretOverRotated()
{
	local TPSoldierAIController DriveAI;

	if( Driver != None )
	{
		DriveAI = TPSoldierAIController(Controller);
		if( DriveAI != None )
			DriveAI.NotifyTurretRotationClamped();
	}
//	ViewRotVel = vect(0,0,0);
}


/** returns absolute Aim direction of turret */
simulated function rotator GetTurretAimDir()
{
	return AimDir;
}

simulated function name GetDefaultCameraMode( PlayerController RequestedBy )
{
	return 'Default';
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Destroy();
}

// Turrets don't take damage, but their drivers might
event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, 
				optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (Driver != None)
	{
		Driver.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	
		if( Driver != None && Driver.Health < 1  )
		{
			//`log(" ChadAI - Driver: " @ Driver @ " Turret:TakeDamage Before Should Crouch Pawn.bIsCrouched: " @ Driver.bIsCrouched @ " - bWantsToCrouch: " @ Driver.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
			//`log(" ChadAI - Driver: " @ Driver @ " Turret TakeDamage from: " @ EventInstigator.Pawn @ " for DamageL " @ Damage @ " With Health: " @ Driver.Health @ " So Making Sure Crouched -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	
			Driver.ShouldCrouch(true);
			//`log(" ChadAI - Driver: " @ Driver @ " Turret:TakeDamage After Should Crouch Pawn.bIsCrouched: " @ Driver.bIsCrouched @ " - bWantsToCrouch: " @ Driver.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		
		}	
	}

	//`log(" ChadAI - Driver: " @ Driver @ " After Turret:NotifyTakeHit - Damage: " @ Damage @ " Health: " @ Driver.Health @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

}

function StartSpotting();
function StopSpotting();

function AISpotterIdleNotification(TPSoldierAIController C);
function UpdateAISpotter(TPSoldierAIController C, float DeltaTime);
function bool ClaimSpotter( TPSoldierAIController AI );
function bool UnclaimSpotter( TPSoldierAIController AI );

function bool ClaimLoader( TPSoldierAIController AI );
function bool UnclaimLoader( TPSoldierAIController AI );

/**
 * list important Pawn variables on canvas.  HUD will call DisplayDebug() on the current ViewTarget when
 * the ShowDebug exec is used
 *
 * @param	HUD		- HUD with canvas to draw on
 * @input	out_YL		- Height of the current font
 * @input	out_YPos	- Y position on Canvas. out_YPos += out_YL, gives position to draw text for next debug line.
 */
simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas	Canvas;

	super.DisplayDebug(HUD, out_YL, out_YPos);

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255, 255, 255);

	Canvas.DrawText(" AimDir:" @ AimDir);
	out_YPos += out_YL;
	Canvas.SetPos(4, out_YPos);
}

/************************************************************************************
 * Weapon / Firing
 ***********************************************************************************/


/**
 * Forward FlashLocation updates to weapon.
 */
simulated function FlashLocationUpdated( bool bViaReplication )
{
/*	if( WarWeapon(MyWeapon) != None )
	{
		WarWeapon(MyWeapon).FlashLocationUpdated( FiringMode, FlashLocation, bViaReplication );
	}*/
}


/**
 * Forward FlashCount updates to weapon.
 */

simulated function FlashCountUpdated( bool bViaReplication )
{
/*	if( WarWeapon(MyWeapon) != None )
	{
		WarWeapon(MyWeapon).FlashCountUpdated( FlashCount, FiringMode, bViaReplication );
	}*/
}


/** @see Pawn::WeaponFired */
simulated function WeaponFired( bool bViaReplication, optional vector HitLocation )
{
	// increment number of consecutive shots.
	ShotCount++;
}


/** @see Pawn::WeaponStoppedFiring */
simulated function WeaponStoppedFiring( bool bViaReplication )
{
	// reset number of consecutive shots fired.
	ShotCount = 0;
}


/** Play proper character animation when firing mode changes */
simulated function FiringModeUpdated( bool bViaReplication )
{
	if( MyWeapon != None )
	{
		MyWeapon.FireModeUpdated(FiringMode, bViaReplication);
	}
}

function Reset()
{
	StopFiring();
	DetachFromController();
}

function UnPossessed()
{
	StopFiring();
	Super.UnPossessed();
}

/**
 * Adds any fire spread offset to the passed in rotator
 * @param Aim the base aim direction
 * @return the adjusted aim direction
 */
simulated function rotator AddSpread(rotator BaseAim, float CurrentSpread)
{
	local vector X, Y, Z;
	local float RandY, RandZ;

	if (CurrentSpread == 0)
	{
		return BaseAim;
	}
	else
	{
		// Add in any spread.
		GetAxes(BaseAim, X, Y, Z);
		RandY = FRand() - 0.5;
		RandZ = Sqrt(0.5 - Square(RandY)) * (FRand() - 0.5);
		return rotator(X + RandY * CurrentSpread * Y + RandZ * CurrentSpread * Z);
	}
}

simulated function PlayFiringSound()
{
	if (Driver == None || !Driver.IsA('PlayerPawn'))
	{
		if (!NPCFireEffectAudioCmpt.bWasPlaying)
			NPCFireEffectAudioCmpt.Play();
	}
	else
	{
		if (!FireEffectAudioCmpt.bWasPlaying)
			FireEffectAudioCmpt.Play();
	}
}

simulated function StopFiringSound()
{
	if (Driver == None || !Driver.IsA('PlayerPawn'))
	{
		if (NPCFireEffectAudioCmpt.bWasPlaying)
			NPCFireEffectAudioCmpt.Stop();
		if (Sound_StopFire.Length > 1 && Sound_StopFire[1]!=None)
			PlaySound(Sound_StopFire[1]);
	}
	else
	{
		if (FireEffectAudioCmpt.bWasPlaying)
			FireEffectAudioCmpt.Stop();
		if (Sound_StopFire.Length > 0 && Sound_StopFire[0]!=None)
			PlaySound(Sound_StopFire[0]);
	}
}

simulated function CooledDown()
{
    bNeedsToCool=false;
}

simulated function FireRound()
{
	local vector Loc;
	local rotator Rot, BaseRot, AccRot;
	local TPProjectile Proj;
	local Float Spread;
	local TPSoldierAIController tpSoldier;
	
	CurrentTime = WorldInfo.TimeSeconds;
	if (CurrentTime - LastTime > FireRate && !bNeedsToCool)
	{
		// Check the barrel temperature before actually firing.
		if (BarrelTemp + BulletTemp >= 1.00) // Too hot; don't actually fire
		{
			if (Driver.IsA('PlayerPawn'))
            {
                bNeedsToCool = true;
                SetTimer(PlayerCoolTimeNeeded,,'CooledDown');
            }
            
			if (BarrelTemp > 1.00)
				BarrelTemp = 1.00; // But do fix the temp. at max.
			StopFire(0);
			// Play 'cool-down' sound?
		}
		else
		{
            StartFire(0);
            
            if(Controller.IsA('TPSoldierAIController'))
			   BarrelTemp += BulletTemp;
			   
			// Determine where the weapon is pointing
			Mesh.GetSocketWorldLocationAndRotation(MuzzleSocketName, Loc, BaseRot);

			//DrawDebugLine(Loc + vector(BaseRot) * 16384, Loc, 255, 0, 0);
			
			// Add in the inaccuracy based on number of rounds fired, barrel temp, etc.
			Spread = MinSpread + (MaxSpread - MinSpread) * BarrelTemp;
			Rot = AddSpread(BaseRot, Spread);

			//DrawDebugLine(Loc + vector(Rot) * 16384, Loc, 0, 0, 255);
			
			// If this is an AI-controlled weapon, add in the inaccuracy
			if (Controller.IsA('TPSoldierAIController'))
			{
				tpSoldier = TPSoldierAIController(Controller);
				
				AccRot = 2 * tpSoldier.CalcTurretInaccuracy();
				Rot += AccRot;
				//DrawDebugLine(Loc + vector(Rot) * 16384, Loc, 255, 255, 0);
			}

			// Create the actual projectile as well as the muzzle flash and the sound				
			MuzzleFlashPSC.ActivateSystem();
			Proj = Spawn(ProjectileClass, Self,, Loc);
			if (ProjectileSpeed > 0)
			{
				Proj.Speed = ProjectileSpeed;
				Proj.MaxSpeed = ProjectileSpeed;
			}
			Proj.SpawnTracer();
			Proj.Init(vector(Rot));
			PlayFiringSound();

			//DrawDebugLine(Loc + vector(Rot) * 16384, Loc, 0, 255, 0);

			//Rumble the controller for the projectile fire.
			if (Controller.IsA('TPPlayerController'))
			{
				TPPlayerController(Controller).ClientPlayForceFeedbackWaveform(PlayerFireWaveform);
			}
			
			LastTime += FireRate;
			if (LastTime + FireRate < CurrentTime)
				LastTime = CurrentTime;

			bNeedSmoke = TRUE;
	        bFiring = TRUE;
		}
	}
}

simulated function StartFire(byte FireModeNum)
{
    if (!bNeedsToCool)
	    bAutomaticFiring = TRUE;
}

simulated function StopFire(byte FireModeNum)
{
	if (bFiring)
	{
		if (Controller != None)
		{
			Super.StopFire(FireModeNum);
		}

		if (bNeedSmoke)
		{
			bNeedSmoke = FALSE;
			MuzzleSmokePSC.ActivateSystem();
		}

		StopFiringSound();
	
		bFiring = FALSE;
	}
	
	bAutomaticFiring = FALSE;
}

simulated function bool CanEnterVehicle(Pawn P)
{
	Local PlayerPawn Player;
	
	if (Driver != None || // Somebody is already there
		P.DrivenVehicle != None || // We're already driving something
		P.Controller == None ||
		!P.Controller.bIsPlayer ||
		P.IsA('Vehicle') ||
		Health <= 0 )
	{
		return false;
	}
	else
	{
		// Don't allow dead or dying players to use the turret.
		Player = PlayerPawn(P);
		return (Player == None || !Player.bShellShockKillPlayer);
	}
}

function DriverDied()
{
	// force the controller to destroy so Kynapse entity is destroyed
	if (Controller != None)
	{
		//KynapseAIController(Controller).DestroyKynapseEntity(); // better to kill entity as soon as possible
		Controller.Destroy();
		Controller = None;
	}

	if( Driver != None )
	{
		//`log(" ChadAI - Driver: " @ Driver @ " Turret:DriverDied After Should Crouch Driver.bIsCrouched: " @ Driver.bIsCrouched @ " - bWantsToCrouch: " @ Driver.bWantsToCrouch @ " -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}
	else
	{
		//`log(" ChadAI - Turret: " @ Self @ " Turret:DriverDied Driver Gone -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
	}

	// Kick the driver off, then do whatever else we need...
	DriverLeave(TRUE);
	Super.DriverDied();
}

simulated function ToggleAimDownSight(TPPlayerController TPController)
{
	bAimDownSight =	!bAimDownSight;
	//`Log("AimDownSight");
	
	if (bAimDownSight)
		TPController.SetDesiredFOV (CloseAimFOV);
	else
		TPController.SetDesiredFOV (TPController.DefaultFOV);
}

simulated function AimDownSight(TPPlayerController TPController, Bool bNewAimDownSight)
{
	bAimDownSight =	bNewAimDownSight;
	//`Log("AimDownSight");
	
	if (bAimDownSight)
		TPController.SetDesiredFOV (CloseAimFOV);
	else
		TPController.SetDesiredFOV (TPController.DefaultFOV);
}

