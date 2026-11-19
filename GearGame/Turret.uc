
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Turret extends Vehicle
	native
	abstract;

/**
 * Base turret code implementation
 *
 */

var Controller Claim;

/** Default inventory added via AddDefaultInventory() */
var array<class<Inventory> >	DefaultInventory;

/** Current Turret Aim  */
var rotator AimDir;

/** desired aim dir */
var rotator DesiredAimDir;

/** limit, in rotator units, of how far from center the turret can rotate in the yaw axis */
var() Vector2D YawLimit;

/** The center of the yaw limit */
var protected int YawCenter;

/** Player turning rate scale */
var()		float	TurretTurnRateScale;
/** Player turning rate scale when aiming */
var()		float	AimingTurretTurnRateScale;

var()	Vector	CannonFireOffset;	// from pitch bone, aligned to DesiredAim
var		name	PitchBone;
var		name	BaseBone;

var		vector	EntryPosition;		// Offset for entry

/** True if exit positions are relative offsets to vehicle's location, false if they are absolute world locations */
var		bool			bRelativeExitPos;

/** Pawn confined to this turret is not allowed to leave until this flag is unchecked */
var		bool			bUnableToLeave;

struct native sPointOfView
{
	var()	vector	DirOffset;		// BaseRotation relative Offset
	var()	float	Distance;		// relative offset dist
	var()	float	fZAdjust;		// Adjust Z based on pitch
};

var() sPointOfView	POV;	// Camera info


/** TRUE when spotter is tracking something */
var		bool	bSpottedSomething;

/** Action displayed on the HUD */
var ActionInfo InteractAction;

/** custom replicated weapon reference */
var repnotify Weapon MyWeapon;

//debug
var(Debug) bool bDebugTurret;

/** bones where the turret controller places their hands **/
var name LeftHandBoneHandleName;
var name RightHandBoneHandleName;

var float InitialEntryZOffset;

/** Whether this turret should only be mounted from the rear or not */
var() bool bRearMountOnly;

var protected const SoundCue DriverEnterSound;
var protected const SoundCue DriverLeaveSound;

var protected const SoundCue			RotateLoopSound;
var protected transient AudioComponent	RotateLoopAC;
var protected transient bool			bPlayingRotAudio;
var() protected const float				RotAudioStartVelThreshold;
var() protected const float				RotAudioStopVelThreshold;
var protected transient int				LastControllerYaw;
var() protected const vector2d			RotAudioVolumeVelRange;
var() protected const vector2d			RotAudioVolumeRange;

replication
{
	if (bNetInitial || (!bNetOwner && bNetDirty))
		AimDir, MyWeapon;
	if (bNetDirty)
		InitialEntryZOffset;
	if (bNetInitial)
		YawLimit, YawCenter;
}

cpptext
{
	virtual UBOOL IgnoreBlockingBy( const AActor *Other) const;
};

native simulated function UpdateDriver(FLOAT DeltaTime);

/**
 * Get Driver idle location when manning this turret.
 * Physics will try to place the player there. See UpdateDriver().
 */
simulated event vector GetDriverIdealPosition()
{
	// Code is implented in GetEntryLocation().
	return GetEntryLocation();
}

simulated event rotator GetDriverIdealRotation()
{
	return AimDir;
}

simulated function PostBeginPlay()
{
	local GearPC PC;

	Super.PostBeginPlay();

	ForEach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.bCheckVehicles = TRUE;
	}

	// define AimDir, as where the turret is originally looking at when placed in the level
	AimDir			= Rotation;
	DesiredAimDir	= AimDir;

	if (Role == ROLE_Authority)
	{
		// if we're on a moving base, yaw center is relative to the rotation of the base
		if( Base != none )
		{
			YawCenter = Rotation.Yaw - Base.Rotation.Yaw;
		}
		else
		{
			YawCenter = Rotation.Yaw;
		}
	}
}

function Restart()
{
	if (Role == ROLE_Authority)
	{
		AddDefaultInventory();
	}
}

simulated function protected AudioComponent TurretPlaySoundLocal(SoundCue Sound, optional AudioComponent AC, optional float FadeInTime)
{
	if (Sound != None)
	{
		if (AC == None || AC.IsPendingKill())
		{
			AC = CreateAudioComponent(Sound, FALSE, TRUE);
			if (AC != None)
			{
				AC.bUseOwnerLocation	= TRUE;
				AC.bAutoDestroy			= FALSE;        // so we reuse it
				AttachComponent(AC);
			}
		}
		if (AC != None)
		{
			AC.FadeIn(FadeInTime, 1.f);
		}
	}

	return AC;
}


simulated function Tick(float DeltaTime)
{
	local GearWeapon MyGearWeapon;
	local bool	bIsControllerFireInputPressed, bIsWeaponPendingFire, bIsPawnCommitToFiring;
	local byte	AltFiringMode;
	
	local float AimRotVel, RotAudioPct;
	local bool bPlayRotAudio;

	super.Tick(DeltaTime);

	// If locally controlled, handle firing
	if( IsLocallyControlled() )
	{
		bIsWeaponPendingFire = IsWeaponPendingFire(0);
		bIsControllerFireInputPressed = IsControllerFireInputPressed(0);
		bIsPawnCommitToFiring = PawnCommitToFiring(0);
		if( !bIsWeaponPendingFire && bIsPawnCommitToFiring )
		{
			StartFire( 0 );
		}
		else
		if( bIsWeaponPendingFire && !bIsControllerFireInputPressed )
		{
			StopFire( 0 );
		}

		MyGearWeapon = GearWeapon(MyWeapon);
		if( MyGearWeapon != None && MyGearWeapon.bAltFireWeapon )
		{
			AltFiringMode = class'GearWeapon'.const.ALTFIRE_FIREMODE;
			bIsWeaponPendingFire = IsWeaponPendingFire(AltFiringMode);
			bIsControllerFireInputPressed = IsControllerFireInputPressed(AltFiringMode);
			bIsPawnCommitToFiring = PawnCommitToFiring(AltFiringMode);

			if( !bIsWeaponPendingFire && bIsPawnCommitToFiring )
			{
				StartFire(AltFiringMode);
			}
			else if( bIsWeaponPendingFire && !bIsControllerFireInputPressed )
			{
				StopFire(AltFiringMode);
			}
		}
	}

	// rotation audio
	if ( (Controller != None) && (RotateLoopSound != None) )
	{
		AimRotVel = Abs(float(Controller.Rotation.Yaw - LastControllerYaw) / DeltaTime);
		if ( (!bPlayingRotAudio && (AimRotVel > RotAudioStartVelThreshold)) ||
			(bPlayingRotAudio && (AimRotVel > RotAudioStopVelThreshold)) )
		{
			bPlayRotAudio = TRUE;
		}

		// start/stop audio as necessary
		if (bPlayRotAudio)
		{
			if (!bPlayingRotAudio)
			{
				RotateLoopAC = TurretPlaySoundLocal(RotateLoopSound, RotateLoopAC, 0.15f);
				bPlayingRotAudio = (RotateLoopAC != None);
			}
		}
		else
		{
			if (bPlayingRotAudio)
			{
				RotateLoopAC.FadeOut(0.15f, 0.f);
				bPlayingRotAudio = FALSE;
			}
		}

		if (bPlayingRotAudio)
		{
			RotAudioPct = FClamp(GetRangePctByValue(RotAudioVolumeVelRange, AimRotVel), 0.f, 1.f);
			RotateLoopAC.VolumeMultiplier = FInterpTo(RotateLoopAC.VolumeMultiplier, GetRangeValueByPct(RotAudioVolumeRange, RotAudioPct), DeltaTime, 8.f);
		}

		LastControllerYaw = Controller.Rotation.Yaw;
	}

}

final function bool IsWeaponPendingFire(byte InFiringMode )
{
	return (InvManager != None && InvManager.IsPendingFire(MyWeapon, InFiringMode));
}

simulated function bool PawnCommitToFiring( byte InFiringMode )
{
	return (IsWeaponPendingFire(InFiringMode) || IsControllerFireInputPressed(InFiringMode));
}

final simulated function bool IsControllerFireInputPressed(byte InFiringMode)
{
	if( InFiringMode == class'GearWeapon'.const.DEFAULT_FIREMODE )
	{
		return (Controller != None && Controller.bFire == 1);
	}

	if( InFiringMode == class'GearWeapon'.const.ALTFIRE_FIREMODE )
	{
		return (GearPC(Controller) != None && GearPC(Controller).IsButtonActive(GB_LeftTrigger) );
	}

	return FALSE;
}


/** @See Vehicle::DriverEnter */
function bool DriverEnter(Pawn P)
{
	local bool	bSuccess;

	// if we don't have pre-defined exit positions here, we use the original player location as an exit point
	if( !bRelativeExitPos )
	{
		ExitPositions[0] =  P.Location + Vect(0,0,16);
	}

	// Controller possesses turret.
	bSuccess = Super.DriverEnter(P);

	if (bSuccess)
	{
		// force the controller to be looking in the same direction as the turret
		if (Controller != None)
		{
			Controller.SetRotation(AimDir);
			if (PlayerController(Controller) != None)
			{
				Controller.ClientSetRotation(AimDir);
			}
		}
		TriggerEventClass(class'SeqEvt_VehicleDriven',P,0);
	}

	InitialEntryZOffset = Driver.Location.Z - GetEntryLocation().Z;
	return bSuccess;
}

simulated function DrivingStatusChanged()
{
	Super.DrivingStatusChanged();

	if (bDriving)
	{
		if (DriverEnterSound != None)
		{
			PlaySound(DriverEnterSound);
		}

		if (Controller != None)
		{
			LastControllerYaw = Controller.Rotation.Yaw;
		}
	}
	else
	{
		if (DriverLeaveSound != None)
		{
			PlaySound(DriverLeaveSound);
		}
	}
}

event bool DriverLeave( bool bForceLeave )
{
	local Pawn OldDriver;

	if( bUnableToLeave && !bForceLeave )
	{
		return FALSE;
	}

	OldDriver = Driver;
	if (Super.DriverLeave(bForceLeave))
	{
		bUnableToLeave = FALSE;
		TriggerEventClass(class'SeqEvt_VehicleDriven',OldDriver,1);
		return TRUE;
	}
	return FALSE;
}

/** Overridden to redirect to driver */
simulated function OnTeleport(SeqAct_Teleport Action)
{
	local Pawn OldDriver;

	if( Action != None && Driver != None )
	{
		OldDriver = Driver;
		if( DriverLeave(true) )
		{
			OldDriver.OnTeleport(Action);
		}
	}
	else
	{
		Super.OnTeleport(Action);
	}
}


function bool ClaimTurret(Controller C)
{
	local GearAI_Cover AI;

	if (Driver == None && (Claim == None || Claim.Pawn == None || !WorldInfo.GRI.OnSameTeam(Claim, C)))
	{
		Claim = C;

		AI = GearAI_Cover(C);
		if (AI != None)
		{
			AI.CurrentTurret = self;
		}
		return true;
	}
	else
	{
		return false;
	}
}

function bool UnclaimTurret(Controller C)
{
	local GearAI_Cover AI;

	AI = GearAI_Cover(C);
	if (AI != None && AI.CurrentTurret == self)
	{
		AI.CurrentTurret = None;
	}
	if (Claim == C)
	{
		Claim = None;
		return true;
	}

	return false;
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
			// spawn with self as starting owner so it is spawned in the same streaming level the turret is in
			Inv = Spawn(DefaultInventory[i], self);
			if (Inv != None)
			{
				if(InvManager != None)
				{
					InvManager.AddInventory(Inv);
				}

				if (Weapon(Inv) != None)
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
		Weapon.bForceNetUpdate = TRUE;
		Weapon.ClientWeaponSet(false);
	}
}

simulated function ClientRestart()
{
	Super.ClientRestart();

	// sanity check we got the weapon set up
	if (Weapon != None)
	{
		Weapon.ClientWeaponSet(false);
	}
}

/** @See Pawn::ProcessViewRotation */
simulated function ProcessViewRotation(float DeltaTime, out rotator OutViewRot, out Rotator OutDeltaRot)
{
	local float RateScale;
	local GearPC GPC;

	// Change scale if aiming
	GPC = GearPC(Controller);
	RateScale = ((GPC != None) && GPC.bIsTargeting) ? AimingTurretTurnRateScale : TurretTurnRateScale;

	// Scale player turning input
	OutDeltaRot *= RateScale;
	super.ProcessViewRotation(DeltaTime, OutViewRot, OutDeltaRot);
}


/** @See Pawn::FaceRotation */
simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	// Define relative turret rotation as being the controller rotation
	if( Controller != none )
	{
		AimDir = Controller.Rotation;
	}
}


/**
 * Perform update for AI controller.
 * tracks targets and such...
 */
function UpdateAIController(GearAI C, float DeltaTime)
{
	// if we have an target, track it down
	if (C.HasValidTarget())
	{
		DesiredAimDir = rotator(C.GetFocalPoint() - Location);
	}

	AimDir = RInterpTo(AimDir, DesiredAimDir, DeltaTime, 1.f);
}


/**
 * Called every second when AI is Idle.
 */
function AIIdleNotification(GearAI_Cover C)
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
function rotator GetRandomRotForTurretScan(GearAI_Cover C)
{
	local rotator DesiredRot;

	// pick a random orientation
	// if we saw an target, pick a destination close to where we last saw him
	if (C.HasValidTarget())
	{
		DesiredRot = rotator(C.GetFocalPoint() - C.Pawn.Location);
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

	AimRot = AimDir;

	//CamLookAt = Mesh.GetBoneLocation( PitchBone ) + vector(AimRot) * 2048;
	CamLookAt = Location + vector(AimRot) * 16384;

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

	//
	// rotate camera to match focus point
	//
	out_CamRot = Rotator(CamLookAt - out_CamLoc);
	return true;
}

/** Physical fire start location. (from weapon's barrel in world coordinates) */
simulated native event vector GetPhysicalFireStartLoc(vector FireOffset);

simulated native event Vector GetPawnViewLocation();

/**
 * returns base Aim Rotation without any adjustment (no aim error, no autolock, no adhesion.. just clean initial aim rotation!)
 *
 * @return	base Aim rotation.
 */
simulated singular event Rotator GetBaseAimRotation()
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
	POVRot = AimDir;

	// If our Pitch is 0, then use RemoveViewPitch
	if( POVRot.Pitch == 0 )
	{
		POVRot.Pitch = RemoteViewPitch << 8;
	}

	return POVRot;
}


simulated native function bool TurretClampYaw( out Rotator Rot );

simulated function TurretOverRotated();

simulated function name GetDefaultCameraMode( PlayerController RequestedBy )
{
	return 'Default';
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Destroy();
}

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (bCanBeDamaged)
	{
		Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	}
}

function StartSpotting();
function StopSpotting();

function AISpotterIdleNotification(GearAI_Cover C);
function UpdateAISpotter(GearAI_Cover C, float DeltaTime);
function bool ClaimSpotter( GearAI_Cover AI );
function bool UnclaimSpotter( GearAI_Cover AI );

function bool ClaimLoader( GearAI_Cover AI );
function bool UnclaimLoader( GearAI_Cover AI );

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
simulated function FlashLocationUpdated(Weapon InWeapon, Vector InFlashLocation, bool bViaReplication)
{
	local GearWeapon GearWeap;

	//@warning: doesn't support multiple weapons at once
	GearWeap = GearWeapon(MyWeapon);
	if (GearWeap != None)
	{
		GearWeap.FlashLocationUpdated(GetWeaponFiringMode(MyWeapon), FlashLocation, bViaReplication);
	}
}


/** Forward FlashCount updates to weapon. */
simulated function FlashCountUpdated(Weapon InWeapon, byte InFlashCount, bool bViaReplication)
{
	local GearWeapon InGearWeapon;

	//@warning: doesn't support multiple weapons at once
	InGearWeapon = GearWeapon(MyWeapon);
	if (InGearWeapon != None)
	{
		InGearWeapon.FlashCountUpdated(InFlashCount, GetWeaponFiringMode(MyWeapon), bViaReplication);
	}
}


/** @see Pawn::WeaponFired */
simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional vector HitLocation)
{
	// increment number of consecutive shots.
	ShotCount++;
}


/** @see Pawn::WeaponStoppedFiring */
simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
	// reset number of consecutive shots fired.
	ShotCount = 0;
}


/** Play proper character animation when firing mode changes */
simulated function FiringModeUpdated(Weapon InWeapon, byte InFiringMode, bool bViaReplication)
{
	//@warning: doesn't support multiple weapons at once
	if (MyWeapon != None)
	{
		MyWeapon.FireModeUpdated(InFiringMode, bViaReplication);
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

simulated function StartFire(byte FireModeNum)
{
	if (Controller != None)
	{
		Super.StartFire(FireModeNum);
	}
}

/** overridden so it's simulated for GearPC checks and so we skip the WorldInfo.Game check as we doesn't care about that */
simulated function bool CanEnterVehicle(Pawn P)
{
	if( Driver != None ||
		 P.bIsCrouched ||
		 P.DrivenVehicle != None ||
		 P.Controller == None ||
		!P.Controller.bIsPlayer ||
		 P.IsA('Vehicle') ||
		 Health <= 0 ||
		 P.IsA('GearPawnRidable_Base') )
	{
		return false;
	}

	if (GearPawn(P) != None && GearPawn(P).bWantToUseCommLink)
	{
		return false;
	}

	// Force human players to be in a good position. Due to the pivot point on some turrets, just give close pawns a pass.
	if (bRearMountOnly && P.IsHumanControlled() && NoZDot(Location - P.Location, vector(AimDir)) < -0.2f && VSize(Location - P.Location) > 50)
	{
		return false;
	}

	return true;
}

/** turrets shouldn't be killing things through encroachment */
function PancakeOther(Pawn Other);

defaultproperties
{
	Physics=PHYS_None
	AimingTurretTurnRateScale=1.f
	TurretTurnRateScale=1.f
	DriverDamageMult=1.f
	LandMovementState=PlayerTurreting
	ViewPitchMin=-4096
	ViewPitchMax=8192
	YawLimit=(X=-16384,Y=+16384)
	POV=(DirOffset=(X=-5,Y=0,Z=4),Distance=200,fZAdjust=-350)
	bAttachDriver=false
	bPathColliding=true
	bStationary=true
	bSimulateGravity=false
	bCanBeDamaged=false
	bRearMountOnly=true

	Begin Object Class=CylinderComponent Name=PathCollisionCylinder
		CollisionHeight=50.000000
	    CollisionRadius=60.000000
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockActors=true
		CollideActors=true
		AlwaysLoadOnClient=false	// exists only in editor
		AlwaysLoadOnServer=false
		Translation=(X=70)
	End Object
	Components.Add(PathCollisionCylinder)

	InteractAction={(
		ActionName=UseTurret,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=109,V=425,UL=122,VL=87)))	),
		)}

	SupportedEvents.Add(class'SeqEvt_VehicleDriven')

	bAlwaysRelevant=TRUE

	RotAudioStartVelThreshold=2500.f
	RotAudioStopVelThreshold=1500.f
	RotAudioVolumeVelRange=(X=5000.f,Y=15000.f)
	RotAudioVolumeRange=(X=0.1f,Y=1.f)
}
