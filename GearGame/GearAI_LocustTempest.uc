/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GearAI_LocustTempest extends GearAI
	native(AI);

var config float HoveringHeight;
var config float CirclingRadius;
var config float CirclingPeriod;
var() config float EnemyAcquiredGracePeriod;

var transient float CircleCounter;

/** Max yaw of cone (9102) - UU */
var config int MaxBeamHalfCone;
/** cleared at StartFire/Recalculated in every tick **/
var transient int ModifiedYawValue;
/** Current BeamSpeed including direction **/
var transient int CurrentBeamSpeed; 

//Number of times the beam will go back and forth
var config transient int NumBeamPasses;

//How long a sweep will take
var config transient float BeamAttackTime;

var instanced AIReactCond_GenericCallDelegate LostEnemyReaction;

//Amount to offset the AimLocation - using it to aim above his head so it goes farther
var config transient vector BeamOffsetVector;

//Target of the beam attack
var transient Actor BeamAttackTarget;

/** Starting point for a sweep-to-location beam attack */
var transient Actor BeamAttackStartSweep;
/** Stopping point for a sweep-to-location beam attack */
var transient Actor BeamAttackStopSweep;

//The direction the beam is sweeping from. Either 1 or -1
var transient int BeamDirection;

//How long to vent
var config float VentTime;

/** Whether the tempest can currently be distracted or not */
var transient bool bCanBeDistracted;

/** Amount of damage the tempest must take to get distracted */
var transient int DamageForDistraction;

//How much damage it will take before it will attempt to turn around
var config int DamageAmtToForceTurn;

/** Values to use for dot product of tempest to enemy for warning AI of the beam */
var config float WarnAIOfBeamValue;

cpptext
{
	/** Possibly block normal UpdatePawnRotation */
	virtual void UpdatePawnRotation();
};


function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Super.CreateCheckpointRecord(Record);

	if (GearPawn_LocustTempestBase(Pawn) != None)
	{
		Record.TempestStage = (GearPawn_LocustTempestBase(Pawn)).DamageStage;
	}
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	Super.ApplyCheckpointRecord(Record);

	if (GearPawn_LocustTempestBase(Pawn) != None)
	{
		(GearPawn_LocustTempestBase(Pawn)).DamageStage = Record.TempestStage;
	}
}

/** @return TRUE if we should skip doing normal UpdatePawnRotation */
event bool OverridePawnRotation()
{
	local GearPawn_LocustTempestBase Tempest;
	local vector FocalPoint;

	Tempest = GearPawn_LocustTempestBase(MyGearPawn);
	if (Tempest.bSweepAttack)
	{
		FocalPoint = Tempest.GetCurrentSweepAttackLocation();
		SetFocalPoint(FocalPoint);
		Pawn.SetDesiredRotation(rotator(FocalPoint-Pawn.Location));
		return TRUE;
	}

	if (Tempest.bSkipFaceEnemy)
	{
		return TRUE;
	}

	return FALSE;
}

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget);

function OnLostEnemy(Actor InInstigator, AIReactChannel OrigChannel)
{
	GearPawn_LocustTempestBase(MyGearPawn).OnLostEnemy();
	BeginCombatCommand(none,"Lost LOS, restarting");
}

// FIXME this doesnt' sound right
function OnNewEnemy()
{
	`AILog(GetFuncName());

	GearPawn_LocustTempestBase(MyGearPawn).OnAcquireEnemy();
}

/** Selects a target from the TargetList or selects an enemy normally */
function bool SelectTarget()
{
	local GearPawn_LocustTempestBase Tempest;
	
	Tempest = GearPawn_LocustTempestBase(Pawn);

	// if BeamAttack is in progress, sets BeamAttack as target and focus
	if ( Tempest.SpecialMove == SM_Tempest_BeamInAir && BeamAttackTarget != None )
	{
		FireTarget = BeamAttackTarget;
		Enemy = Pawn(FireTarget);
		Focus = FireTarget;

		return TRUE;
	}

	return Super.SelectTarget();
}


/** figures out where the AI should aim to hit its target
 * @param StartLoc - where the weapon fire comes from
 * @param bActuallyFiring - set when this function is being called as part of actually firing a shot (not just visual stuff)
 * @return target vector
 */
event vector GetAimLocation(vector StartLoc, optional bool bActuallyFiring, optional Actor AimTarget )
{
	local GearPawn_LocustTempestBase Tempest;
	
	Tempest = GearPawn_LocustTempestBase(Pawn);
	if (Tempest.bSweepAttack)
	{
		AimTarget = None;

		//DrawDebugSphere(Tempest.GetCurrentSweepAttackLocation(), 10, 10, 255, 255, 0, TRUE);

		return Tempest.GetCurrentSweepAttackLocation();
	}

	// if beam attack, make sure it focuses at beamattack target, not aimtarget	
	if ( Tempest.SpecialMove == SM_Tempest_BeamInAir )
	{
		Focus = BeamAttackTarget;
		return Super.GetAimLocation(StartLoc, bActuallyFiring, BeamAttackTarget);
	}

	return Super.GetAimLocation(StartLoc, bActuallyFiring, AimTarget);
}

function bool CanFireWeapon(Weapon Wpn, byte FireModeNum)
{
	return bWeaponCanFire;
}

/** do not auto reload for tempest **/
function bool ShouldAutoReload()
{
	return FALSE;
}

/** Notify all AI to hide from the beam attack */
event StartFiring(optional int InBurstsToFire = -1)
{
	SetTimer(0.25f, true, nameof(WarnAIOfBeamAttack));
	Super.StartFiring(InBurstsToFire);
}

/** Notify all AI to not hide from the beam attack anymore and reset the beam speed */
event StopFiring()
{
	CurrentBeamSpeed = 0;

	ClearTimer(nameof(WarnAIOfBeamAttack));
	ClearBeamAttackWarnings();

	Super.StopFiring();
}

/** Warns the AI that the beam is near them so they can hide from it */
function WarnAIOfBeamAttack()
{
	local GearAI CurrAI;
	local Vector TempestLoc;
	local Rotator TempestRot;
	local Vector EnemyToTempestRot;

	Pawn.Mesh.GetSocketWorldLocationAndRotation('breath', TempestLoc, TempestRot);

	foreach WorldInfo.AllControllers(class'GearAI', CurrAI)
	{
		if (!CurrAI.bTurtle && CurrAI.Pawn != None && CurrAI != self)
		{
			EnemyToTempestRot = Normal(CurrAI.Pawn.Location - TempestLoc);
			if (Vector(TempestRot) dot EnemyToTempestRot > WarnAIOfBeamValue)
			{
				CurrAI.bTurtle = true;
				CurrAI.StopFiring();
				CurrAI.SetEnemy(Pawn);
			}
		}
	}
}

/** Removes the warning that AI might have been handling when a beam attack was near them */
function ClearBeamAttackWarnings()
{
	local GearAI CurrAI;

	foreach WorldInfo.AllControllers(class'GearAI', CurrAI)
	{
		CurrAI.bTurtle = false;
	}
}

DefaultProperties
{
	DefaultCommand=class'AICmd_Base_LocustTempest'

	DefaultReactConditions.Empty()
	DefaultReactConditionClasses.Empty()

	Begin Object class=AIReactCond_GenericCallDelegate Name=Pusher0
		AutoSubscribeChannels(0)=LostEnemyVisibility
		OutputFunction=OnLostEnemy
	End Object
	DefaultReactConditions.Add(Pusher0)
	LostEnemyReaction=Pusher0

	bCanMelee=FALSE
	
	CurrentBeamSpeed=0
}
