/**
 * Player attached to rat truck
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_RidingRatTruck extends GearSpecialMove;

/** Limits to how much the player should be able to pitch */
var() config int MinPitchRotation;
var() config int MaxPitchRotation;

/** The max amount the player should be able to rotate from the base */
var() config float MaxYawRotation;
/** Amount of influence the Rat Truck's rotation has on the player camera rotation */
var() config float BaseYawInfluence;
/** Keeps track of the Rat Truck's yaw from the previous frame for camera adjustments */
var transient float LastBaseYaw;

/**
 * Setup collision and controller state for riding the Rat Truck
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);
	

	if( PlayerController(PawnOwner.Controller) != none)
	{
		PawnOwner.Controller.GotoState('PlayerRidingVehicle');
	}
	PawnOwner.SetCollision(true,false);

	if (PawnOwner.Base != None)
	{
		LastBaseYaw = PawnOwner.GetBaseMost().Rotation.Yaw;
	}
}

/**
 * Reset collision and state
 *
 * @param PrevMove - the previous special move to run
 * 
 * @param NextMove - the next special move to run
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{

	if( PlayerController(PawnOwner.Controller) != none)
	{
		PawnOwner.Controller.GotoState(PawnOwner.LandMovementState);
	}
	PawnOwner.bIgnoreBaseRotation = PawnOwner.default.bIgnoreBaseRotation;
	PawnOwner.SetCollision(true,true);

}

/**
 * Don't let the special move base class zero out the aim offset
 * 
 * @param DeltaRot - the current aim offset delta
 * 
 * @return FALSE to signify the aim offset should not be changed
 */
event bool DisableAimOffset()
{
	return FALSE;
}


/**
 * Restrict yaw rotation while riding the Rat Truck
 * 
 * @param out_ViewRotation - the limited viewed rotation to pass to the camera system
 */
function LimitViewRotation(out Rotator out_ViewRotation)
{
	local Actor MyBase;

	if (PawnOwner.Base != None)
	{
		MyBase = PawnOwner.GetBaseMost();
		
		// Adjust view yaw by a portion of the Rat Truck's yaw rotation this frame
		out_ViewRotation.Yaw += NormalizeRotAxis(MyBase.Rotation.Yaw - LastBaseYaw) * FClamp(BaseYawInfluence, 0.0f, 1.0f);

		// Clamp view yaw to be within bounds
		out_ViewRotation.Yaw = ClampRotAxisFromBase(out_ViewRotation.Yaw, MyBase.Rotation.Yaw, MaxYawRotation);

		// Set LastBaseYaw to be used in the next frame
		LastBaseYaw = MyBase.Rotation.Yaw;

		// Clamp view pitch to be within bounds
		out_ViewRotation.Pitch = ClampRotAxisFromRange(out_ViewRotation.Pitch, MinPitchRotation, MaxPitchRotation);
	}
}

/** Overridden to dampen camera anims while targeting */
function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if (PCOwner != None && PCOwner.bIsTargeting && 
		GearPlayerCamera(PCOwner.PlayerCamera) != None && Vehicle_RatTruck_Base(PawnOwner.Base) != None)
	{
		GearPlayerCamera(PCOwner.PlayerCamera).ApplyTransientCameraAnimScale(Vehicle_RatTruck_Base(PawnOwner.Base).TargetingShakeDampening);
	}
}

defaultproperties
{
	bCanSwitchWeapons=TRUE
	bDisallowDBNO=TRUE
	bShowHUDActions=TRUE
}