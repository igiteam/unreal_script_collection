/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 *
 * Base class for all TM turrets.
 */
class TGTurret extends Turret
	abstract
	//config(TGPawn)
	native(TG);

/** View point offset for high player view pitch */
var(Camera) editconst vector	CameraViewOffsetHigh;
/** View point offset for medium (horizon) player view pitch */
var(Camera) editconst vector	CameraViewOffsetMid;
/** View point offset for low player view pitch */
var(Camera) editconst vector	CameraViewOffsetLow;

/** True to allow player to target while driving this turret, false otherwise */
var(Camera) editconst bool		bAllowTargetingCamera;

/** View point offset for high player view pitch (targeting mode) */
var(Camera) editconst vector	CameraTargetingViewOffsetHigh;
/** View point offset for medium (horizon) player view pitch (targeting mode) */
var(Camera) editconst vector	CameraTargetingViewOffsetMid;
/** View point offset for low player view pitch (targeting mode) */
var(Camera) editconst vector	CameraTargetingViewOffsetLow;

/** Fov in degrees while using this turret */
var(Camera) /*config*/ float		CameraFOV;
/** Fov in degrees while using this turret (targeting mode) */
var(Camera) /*config*/ float		CameraTargetingFOV;

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

struct CheckpointRecord
{
	var bool bHidden;
};

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)



simulated function bool ShouldTargetingModeZoomCamera()
{
	local TGPC GPC;
	GPC = TGPC(Controller);
	return ( (GPC != None) && GPC.bIsTargeting );
}

function bool DriverEnter(Pawn P)
{
	local TGPawn GP;

	// drop shield if player tries to enter turret while carrying it
	GP = TGPawn(P);
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

	if (TGPC(Controller) != None)
	{
		// zero any roll
		NewRot = Controller.Rotation;
		NewRot.Roll = 0;
		Controller.SetRotation(NewRot);
	}

	return super.DriverLeave(bForceLeave);
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	local TGWeapon MyGW;
	Super.PossessedBy(C, bVehicleTransition);

	// cache a reference to the AI controller
	MyGW = TGWeapon(Weapon);
	if(MyGW != none)
	{
		MyGW.TGAIController = TGAI(Controller);
		//MyGW.AIController = MyGW.TGAIController;
	}
}

//simulated function OnGearExitVehicle( SeqAct_GearExitVehicle inAction )
//{
//	local TGAI_Cover GAI;
//	if (inAction != None && TGTurret(inAction.TargetVehicle) != None)
//	{
//		GAI = TGAI_Cover(Controller);
//		DriverLeave(TRUE);
//		if(GAI != none)
//		{
//			GAI.StopUsingTurret(self);
//		}
//	}
//}

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

simulated function bool IsWithinRotationClamps(vector Loc)
{
	return true;
}

simulated function bool WantsCrosshair(PlayerController PC)
{
	return FALSE;
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
}
function NotifyDriverTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> DamageType, vector Momentum)
{
	local int iDam;

	Super.NotifyDriverTakeHit(InstigatedBy,HitLocation,Damage,DamageType,Momentum);

	iDam = Clamp(Damage,0,250);
	if ( (iDam > 0 || Controller.bGodMode) && (Controller.Pawn != None) )
	{
		TMPlayerController(Controller).ClientPlayTakeHit(hitLocation - Controller.Pawn.Location, iDam, damageType);
	}
}




