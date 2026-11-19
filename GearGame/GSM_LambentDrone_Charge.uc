/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_LambentDrone_Charge extends GearSpecialMove;

// Since Peon drudge can't change tree for this behavior
// This speed blending is kind of coded. 

// Drudge pawn owner
var transient GearPawn_LambentDroneBase DrudgePawn;

// Charge animation
var BodyStance BS_ChargeAnimation;
var int       ChargeAnimationSpeed; 
var float     ChargeAnimationCycleLength; // in time
var int       ChargeAnimationNumCycles; 

// Walk Charge animation
var BodyStance BS_ChargeWalkAnimation;
var int       ChargeWalkAnimationSpeed; 
var int       ChargeWalkAnimationMaxSpeed;
var float     ChargeWalkAnimationCycleLength; // in time
var int       ChargeWalkAnimationNumCycles;

// SM Charge start time
var transient float TotalChargeTime;

// Accel rate for warmup
var() config float WarmUpAccelRate;

// Min/MaxSpeed
var() config int MinSpeed;
var() config int MaxSpeed;

// Find best match point for run cycle from input of walk cycle position
function float FindBestMatchPoint(float CurrentWalkPosition)
{
	// this Local position is within one cycle
	local float LocalPosition, BestMatchPosition;
	LocalPosition = (CurrentWalkPosition % (ChargeWalkAnimationCycleLength))/ChargeWalkAnimationCycleLength;
	BestMatchPosition = GetRandomStartPosition(FALSE) + (ChargeAnimationCycleLength)*LocalPosition;

	return BestMatchPosition;
}

// Get Random Start Position so that we can start from any random position
function float GetRandomStartPosition(bool ChargeWalk)
{
	if (ChargeWalk)
	{
		return (ChargeWalkAnimationCycleLength) * Rand(ChargeWalkAnimationNumCycles);
	}

	return (ChargeAnimationCycleLength) * Rand(ChargeAnimationNumCycles);
}

// Play Chrage animation - custom animation
function UpdateChargeAnimation()
{
	local float CurrentPosition;

	if (PawnOwner.GroundSpeed < ChargeWalkAnimationMaxSpeed)
	{
		// make sure it doesn't restart if already playing. It will reset position
		if (PawnOwner.BS_IsPlaying(BS_ChargeWalkAnimation) == FALSE)
		{
			CurrentPosition = GetRandomStartPosition(TRUE);
			PawnOwner.BS_Play(BS_ChargeWalkAnimation, 1.f, 0.25f, 0.25f, TRUE, , , CurrentPosition);
			//`log(PawnOwner@" Walk - CurrentPosition is "@CurrentPosition);
		}

		PawnOwner.BS_SetPlayRate(BS_ChargeWalkAnimation, PawnOwner.GroundSpeed/ChargeWalkAnimationSpeed);
	}
	else 
	{
		// it will loop until end 
		// make sure it doesn't restart if already playing. It will reset position
		if (PawnOwner.BS_IsPlaying(BS_ChargeAnimation) == FALSE)
		{
			// if so far, playing walk animation, get position and set position for it
			if (PawnOwner.BS_IsPlaying(BS_ChargeWalkAnimation))
			{
				CurrentPosition = FindBestMatchPoint(PawnOwner.BS_GetPosition(BS_ChargeWalkAnimation));
			}
			else
			{
				// since now we don't use walk animation, we might not start from random position
				CurrentPosition = 0.0f;// GetRandomStartPosition(FALSE);
			}

			PawnOwner.BS_Play(BS_ChargeAnimation, 1.f, 0.25f, 0.25f, TRUE,TRUE, ,CurrentPosition);
			//`log(PawnOwner@" Run - CurrentPosition is "@CurrentPosition);
		}

		PawnOwner.BS_SetPlayRate(BS_ChargeAnimation, PawnOwner.GroundSpeed/ChargeAnimationSpeed);
	}
}


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	DrudgePawn = GearPawn_LambentDroneBase(PawnOwner);

	Super.SpecialMoveStarted(bForced,PrevMove);

	DrudgePawn.StartChargingSounds();
}
	
/** Script Tick function. */
function Tick(float DeltaTime)
{
	TotalChargeTime += DeltaTime;
	// adjust groundspeed
	PawnOwner.GroundSpeed = MinSpeed + WarmUpAccelRate*(TotalChargeTime)*(TotalChargeTime)*(TotalChargeTime);
	PawnOwner.GroundSpeed = Min(PawnOwner.GroundSpeed, MaxSpeed);
	UpdateChargeAnimation();
	DrudgePawn.UpdatePreExplodeEffects(FClamp((TotalChargeTime / 2.f), 0.f, 1.f));
	//`log(PawnOwner@" - GroundSpeed is "@PawnOwner.GroundSpeed);
	Super.Tick( DeltaTime );
}

defaultproperties
{
	BS_ChargeAnimation=(Stance=((Slot=BS_FullBody,AnimName="Charge_Fwd")))
	BS_ChargeWalkAnimation=(Stance=((Slot=BS_FullBody,AnimName="Charge_walk_Fwd")))

	ChargeWalkAnimationSpeed = 100 
	ChargeWalkAnimationMaxSpeed = 200 
	ChargeAnimationSpeed = 400

	// these values are animation data dependent. 
	// if animation data changes for charge_fwd/walk 
	// this also has to change
	ChargeAnimationCycleLength = 0.8
	ChargeAnimationNumCycles = 6

	ChargeWalkAnimationCycleLength  = 1.333325
	ChargeWalkAnimationNumCycles = 4
	
}