/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class KryllVolumeBase extends Volume
	implements(Interface_NavMeshPathObstacle)
	abstract
	native;

/** How many Kryll are in an attack flock. */
var() float					NumKryllPerFlock;

/** Flock class to use for kryll in this volume */
var() class<KryllFlockBase>		FlockClass;

/** The max number of flocks that can exist at once for this volume.  To avoid pathological framerate-killing cases. */
const MaxSimultaneousFlocks = 4;

/** array of the flocks we've defined for this volume */
var array<KryllFlockBase>		Flocks;

/** Possible targets for the flock */
var array<Gearpawn>				PotentialTargets;

/** Last time the targets were considered */
var array<float>				PotentialTargetTimeStamp;

/** Whether the kryll are going to attack from this volume */
var() bool						bKryllEnabled;

/** The time from entering a Kryll zone to them attacking. */
var() float						TimeUntilAttack;

/** Height above target to begin attack run,  */
var(KryllParams) vector			AttackRunStartOffset;

/** How tight the flock should be */
var(KryllParams) float			FlockMigrationFactor;

/** Minimum avoidance factor for the flock */
var(KryllParams) float			AvoidanceFactorMin;

/** Maximum avoidance factor for the flock */
var(KryllParams) float			AvoidanceFactorMax;

/** Top end of the max flock speed range */
var(KryllParams) float			MaxFlockSpeedSquaredMax;

/** Bottom end of the max flock speed range */
var(KryllParams) float			MaxFlockSpeedSquaredMin;

/** The maximum radius we should pull random spawn locations from */
var(KryllParams) float			RandomSpawnRadius;

/** Sound to play when kryll are about to rush you */
var SoundCue SwooshSoundCue;

/** Sound to play when leaving a kryll volume */
var SoundCue FlybySoundCue;

cpptext
{
	/**
	 * Make a hole in the NavMesh so AI paths around the KryllVolume
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

/** Register the volume as an obstacle with NavMesh */
native function RegisterObstacle();

/** Unregister the volume as an obstacle with NavMesh */
native function UnRegisterObstacle();

/** Make sure to unregister the obstacle */
simulated event Destroyed()
{
	UnRegisterObstacle();
	Super.Destroyed();
}

/**
 * Spawns specified number of kryll flocks and appends them to the Flocks array.
 * 
 * @return index into flocks array of new flock.
 */
private function int SpawnFlock()
{
	local int FlockIdx;
	local KryllFlockBase NewFlock;

	// replace a None'd out entry first, if available
	FlockIdx = INDEX_NONE;
	for (FlockIdx = Flocks.Length - 1; FlockIdx >= 0; --FlockIdx)
	{
		if ( (Flocks[FlockIdx] == None) || (Flocks[FlockIdx].bDeleteMe) )
		{
			break;
		}
	}

	if ( FlockIdx == INDEX_NONE && Flocks.Length < MaxSimultaneousFlocks )
	{
		// if we couldn't find any empty slots for the new flock, create a new slot if we aren't at the max number of flocks
		FlockIdx = Flocks.Length;
	}

	if ( FlockIdx != INDEX_NONE )
	{
		NewFlock = Spawn(FlockClass, self);

		// let's add the new flock to the array before doing anything to it in case calling one of the below functions has side-effects which
		// assume that this new flock is already part of the array.
		Flocks[FlockIdx] = NewFlock;

		NewFlock.FlockMigrationFactor = FlockMigrationFactor;
		NewFlock.AvoidanceFactorMax = AvoidanceFactorMax;
		NewFlock.AvoidanceFactorMin = AvoidanceFactorMin;
		NewFlock.MaxFlockSpeedSquaredMax = MaxFlockSpeedSquaredMax;
		NewFlock.MaxFlockSpeedSquaredMin = MaxFlockSpeedSquaredMin;
		NewFlock.RandomSpawnRadius = RandomSpawnRadius;
		NewFlock.RespawnKryll();
		NewFlock.SetNumKryll(NumKryllPerFlock);
	}

	return FlockIdx;
}

/**
 * Determine if a pawn is ok to attack
 * 
 * @param GP - the pawn to test
 * 
 * @return TRUE if the pawn is a valid target for the Kryll to chomp on
 */
private function bool IsValidKryllTarget(GearPawn GP)
{
	if (ClassIsChildOf(GP.Class, class'GearPawn_SilverbackBase'))
	{
		return FALSE;
	}

	return (GP.IsAliveAndWell() && !IsInSafeZone(GP));
}

/**
 * Check if a pawn is touching a protection volume
 * 
 * @param GP - the pawn to test
 * 
 * @return TRUE if the pawn is touching a KryllProtectionVolume
 */
private function bool IsInSafeZone(GearPawn GP)
{
	local KryllProtectionVolume KPV;

	foreach GP.TouchingActors(class'KryllProtectionVolume', KPV)
	{
		if (KPV.bEnabled)
		{
			return TRUE;
		}
	}

	return FALSE;
}

/**
 * Find any flock that might be attacking a given pawn
 * 
 * @param GP - the pawn to check
 * 
 * @return kryll flock index of flock attacking GP or -1 if none are attacking or -2 if it's a potential target
 */
private function int FindFlockAttackingTarget(GearPawn GP)
{
	local int Idx;

	for (Idx=0; Idx<Flocks.Length; ++Idx)
	{
		if ((Flocks[Idx] != None) && (Flocks[Idx].CurrentTarget == GP))
		{
			return Idx;
		}
	}

	for (Idx=0; Idx<PotentialTargets.Length; ++Idx)
	{
		if (PotentialTargets[Idx] == GP)
		{
			return -2;
		}
	}

	return -1;
}

/**
 * Attack a given pawn
 * 
 * @param GP - the pawn to attack
 */
private function AttackTarget(GearPawn GP)
{
	if (PotentialTargets.Find(GP) == INDEX_NONE)
	{
		// add to queue
		PotentialTargets[PotentialTargets.Length] = GP;
		PotentialTargetTimeStamp[PotentialTargetTimeStamp.Length] =	WorldInfo.TimeSeconds;
	}
}

/** Try to attack any available target */
private function AttemptToAttack()
{
	local GearPawn WP;
	local int FlockIdx, NumAttacks;

	while (PotentialTargets.Length > 0 && (WorldInfo.TimeSeconds - PotentialTargetTimeStamp[0] > TimeUntilAttack))
	{
		WP = PotentialTargets[0];
		PotentialTargets.Remove(0,1); // queue style
		PotentialTargetTimeStamp.Remove(0,1);

		if(IsValidKryllTarget(WP))
		{
			FlockIdx = SpawnFlock();
			if (FlockIdx >= 0)
			{
				Flocks[FlockIdx].BeginAttackRun(WP, AttackRunStartOffset);
			}
		}
		else
		{
			WP.PlaySound(SwooshSoundCue);
		}

		// encountering a loop somewhere, break out if too many targets
		if (NumAttacks++ > 10)
		{
			break;
		}
	}
}

/**
 * Stop a flock from attacking
 * 
 * @param FlockIdx - the flock to stop
 */
private function StopAttackingTarget(int FlockIdx)
{
	Flocks[FlockIdx].AbortAttackRun();
}

/**
 * Tell our flocks to attack or stop attacking
 * 
 * @param DeltaTime - the length of the last frame
 */
function Tick(float DeltaTime)
{
	local GearPawn WP;
	local int FlockIdx;
	
	if (bKryllEnabled)
	{
		foreach TouchingActors(class'GearPawn', WP)
		{
			FlockIdx = FindFlockAttackingTarget(WP);
			if ( (FlockIdx == -1) && IsValidKryllTarget(WP) ) // FlockIdx -2 means on list but not yet attacked
			{
				AttackTarget(WP);
			}
			else if ( (FlockIdx >= 0) && !IsValidKryllTarget(WP) )
			{
				StopAttackingTarget(FlockIdx);
			}
		}

		// can happen if our victim dies
		for (FlockIdx=0; FlockIdx<Flocks.Length; ++FlockIdx)
		{
			if ( (Flocks[FlockIdx] != None) && (Flocks[FlockIdx].CurrentTarget == None) )
			{
				Flocks[FlockIdx].AbortAttackRun();
			}
		}

		AttemptToAttack();
	}

	super.Tick(DeltaTime);
}

/**
 * Enable or disable kryll attacking
 * 
 * @param bEnabled - whether we should be enabled
 */
function SetKryllEnabled(bool bEnabled)
{
	local int Idx;

	bKryllEnabled = bEnabled;

	if (!bKryllEnabled)
	{
		for (Idx=0; Idx<Flocks.Length; ++Idx)
		{
			if (Flocks[Idx].CurrentTarget != None)
			{
				StopAttackingTarget(Idx);
			}
		}

		UnRegisterObstacle();
	}
	else
	{
		RegisterObstacle();
	}
}

/**
 * Handling Toggle event from Kismet.
 * 
 * @param Action - the kismet action that is toggling us
 */
simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if( Action.InputLinks[0].bHasImpulse )
	{
		SetKryllEnabled(TRUE);
	}
	// Turn OFF
	else if( Action.InputLinks[1].bHasImpulse )
	{
		SetKryllEnabled(FALSE);
	}
	// Toggle
	else if( Action.InputLinks[2].bHasImpulse )
	{
		SetKryllEnabled(!bKryllEnabled);
	}
}

/**
 * An actor has left the volume
 * 
 * @param Other - which actor left the volume
 */
event Untouch(Actor Other)
{
	local int Idx;

	// Don't bother searching the flocks if it's not a pawn
	if (GearPawn(Other) == None)
	{
		return;
	}

	// see if dude is being attacked, and if so, call off the dogs
	for (Idx=0; Idx<Flocks.Length; ++Idx)
	{
		if ((Flocks[Idx] != None) && Flocks[Idx].CurrentTarget == Other)
		{
			StopAttackingTarget(Idx);
		}
	}
	// see if he's in the queue, and if so, same
	for (Idx=0; Idx<PotentialTargets.Length; ++Idx)
	{
		if ((PotentialTargets[Idx] != None) && PotentialTargets[Idx] == Other)
		{
			PotentialTargets.Remove(Idx,1);
			PotentialTargetTimeStamp.Remove(Idx,1);
			PlaySound(FlybySoundCue);
		}
	}

	super.Untouch(Other);
}

/** Register as an obstacle if we're on */
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if (bKryllEnabled)
	{
		RegisterObstacle();
	}
}

defaultproperties
{
	FlockMigrationFactor=3.5f
	AvoidanceFactorMax=200.f
	AvoidanceFactorMin=50.f
	MaxFlockSpeedSquaredMax=1500.f
	MaxFlockSpeedSquaredMin=800.f
	RandomSpawnRadius=128.f

	AttackRunStartOffset=(X=0,Y=0,Z=1250);
	bKryllEnabled=TRUE

	// volume properties
	bColored=true
	BrushColor=(R=128,G=128,B=0,A=255)

	// set false to allow ticking
	bStatic=FALSE
	bProcessAllActors=TRUE

	NumKryllPerFlock=10
	TimeUntilAttack = 1.5f;
}