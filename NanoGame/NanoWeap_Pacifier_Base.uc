/**
 * Pacifier Bot Weapon Base
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Pacifier_Base extends NanoWeaponBase
	abstract
	config(Weapon);

/** Limb this weapon is associated with */
var Pacifier_LimbBase	Limb;

/** Number of shots per burst */
var config int NumShotsPerBurst;
/** Delay range between bursts */
var config Vector2d DelayBetweenBursts;
/** Number of bursts left to fire */
var int NumBurstsRemaining;
/** Number of shots in current burst left to fire */
var int NumShotsRemaining;

/** Time before firing is fully finished - build in delay so fire ticket isn't released immediately */
var config float DelayFinishFiringTime;

function InitWeapon( Pacifier_LimbBase L, Pawn NewInstigator )
{
	Limb = L;
	Instigator = NewInstigator;
	CacheAIController();

	Mesh = Instigator.Mesh;
	MuzzleSocketName = Limb.MuzzleSocketName;

	AttachMuzzleEffectsComponents(SkeletalMeshComponent(Mesh));
}

simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	return TRUE;
}

function SetupWeaponFire( Byte FireModeNum )
{
	NumBurstsRemaining = GetNumBursts();
	NumShotsRemaining = GetNumShotsPerBurst();
}

simulated function int GetNumBursts()
{
	return 1;
}

simulated function int GetNumShotsPerBurst()
{
	return NumShotsPerBurst;
}

auto simulated state Active
{
	/** Initialize the weapon as being active and ready to go. */
	simulated event BeginState(Name PreviousStateName)
	{
		if( Role == ROLE_Authority )
		{
			// Cache a reference to the AI controller
			CacheAIController();
		}
	}

	/** Override BeginFire so that it will enter the firing state right away. */
	simulated function BeginFire(byte FireModeNum)
	{
		if( !bDeleteMe && Instigator != None )
		{
			// in the active state, fire right away if we have the ammunition
			if( HasAmmo(FireModeNum) )
			{
				SendToFiringState(FireModeNum);
			}
		}
	}
}

simulated function bool CheckDelayRefire()
{
	NumShotsRemaining--;
	if( NumShotsRemaining <= 0 )
	{
		NumBurstsRemaining--;
		if( NumBurstsRemaining > 0 )
		{
			if( !IsTimerActive( nameof(DelayedBurstFire) ) )
			{
				NumShotsRemaining = NumShotsPerBurst;
				ClearTimer(nameof(RefireCheckTimer));
				SetTimer( GetBurstDelay(), FALSE, nameof(DelayedBurstFire) );
			}
			return TRUE;
		}
	}

	return FALSE;
}

simulated function bool ShouldRefire()
{
	if( NumShotsRemaining <= 0 )
	{
		return FALSE;
	}
	if( Limb == None || !Limb.AbleToFire() )
	{
		return FALSE;
	}
	return TRUE;
}

simulated function float GetBurstDelay()
{
	return RandRange( DelayBetweenBursts.X, DelayBetweenBursts.Y );
}

simulated function DelayedBurstFire();

simulated function float GetDelayFinishFiringTime()
{
	return DelayFinishFiringTime;
}
simulated function DelayFinishedFiring()
{
	HandleFinishedFiring();
}

simulated state WeaponFiring
{
	/**
	 * Timer event, call is set up in Weapon::TimeWeaponFiring().
	 * The weapon is given a chance to evaluate if another shot should be fired.
	 * This event defines the weapon's rate of fire.
	 */
	simulated function RefireCheckTimer()
	{
		local float DelayFinish;
		if( CheckDelayRefire() )
		{
			return;
		}

		// If weapon should keep on firing, then do not leave state and fire again.
		if( ShouldRefire() )
		{
			FireAmmunition();
			return;
		}

		// Otherwise we're done firing
		DelayFinish = GetDelayFinishFiringTime();
		if( DelayFinish <= 0 )
		{
			HandleFinishedFiring();
		}
		else
		{
			ClearTimer(nameof(RefireCheckTimer));
			ClearTimer(nameof(DelayedBurstFire));
			SetTimer( DelayFinish, FALSE, nameof(DelayFinishedFiring) );
		}
	}

	simulated function DelayedBurstFire()
	{
		if( ShouldRefire() )
		{
			FireAmmunition();
			TimeWeaponFiring( CurrentFireMode );
		}
		else
		{
			// Otherwise we're done firing
			HandleFinishedFiring();
		}
	}
	
	simulated function EndFire(byte FireModeNum)
	{
		HandleFinishedFiring();
	}

	simulated event EndState( Name NextStateName )
	{
		ClearTimer(nameof(DelayedBurstFire));
		if( Limb != None )
		{
			Limb.StopFire();
		}
		StopFireEffects( CurrentFireMode );
		Super.EndState( NextStateName );
	}
}

simulated function InstantFire()
{
	local vector			StartTrace, EndTrace;
	local Rotator			FireDir;
	local Array<ImpactInfo>	ImpactList;
	local int				Idx;
//	local ImpactInfo		RealImpact;
	local Actor				TargetActor;
	local NanoPawn			PawnOwner;

	PawnOwner = NanoPawn(Instigator);

	// Servers proceed as normal
	if (WorldInfo.Netmode != NM_Client || (bClientSideInstantHit && Instigator != None && Instigator.IsLocallyControlled()))
	{
		// If InteractionPawn is Based on PawnOwner, then disable his collision when firing.
		// This is to prevent kidnapper from firing through the hostage
		if( PawnOwner != None && PawnOwner.InteractionPawn != None && PawnOwner.InteractionPawn.IsBasedOn(PawnOwner) )
		{
			PawnOwner.InteractionPawn.Mesh.SetTraceBlocking(FALSE, PawnOwner.InteractionPawn.Mesh.BlockNonZeroExtent);
		}

		// define range to use for CalcWeaponFire()
		Limb.GetWeaponFireInfo( StartTrace, FireDir, TargetActor );
		FireDir = AddSpread( FireDir );
		EndTrace = StartTrace + Vector(FireDir) * GetTraceRange();

		// Perform shot
		CalcWeaponFire(StartTrace, EndTrace, ImpactList);
//		RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);

		if (Role == ROLE_Authority || bClientSideInstantHit)
		{
//			FlushPersistentDebugLines();
//			DrawDebugSphere( StartTrace, 10, 10, 0, 255, 0, TRUE );
//			DrawDebugSphere( EndTrace, 10, 10, 255, 0, 0, TRUE );
//			DrawDebugSphere( RealImpact.HitLocation, 10, 10, 0, 0, 255, TRUE );
//			DrawDebugLine(StartTrace,RealImpact.HitLocation, 0, 0, 255, TRUE );
//			`log( self@GetFuncName()@Instigator@RealImpact.HitLocation@RealImpact.HitActor );

			IncrementFlashCount();
		}

		// Process all Instant Hits on local player and server (gives damage, spawns any effects).
		for (Idx = 0; Idx < ImpactList.Length; Idx++)
		{
			ProcessInstantHit(CurrentFireMode, ImpactList[Idx]);
		}

		// Restore collision
		if( PawnOwner != None && PawnOwner.InteractionPawn != None && PawnOwner.InteractionPawn.IsBasedOn(PawnOwner) )
		{
			PawnOwner.InteractionPawn.Mesh.SetTraceBlocking(TRUE, PawnOwner.InteractionPawn.Mesh.BlockNonZeroExtent);
		}
	}
	else if( Instigator != None && Instigator.IsLocallyControlled() )
	{
		// local player simulates firing locally, to give instant response.
		// FlashLocation will only replicate the exact impact location, and play impact effects.
		WeaponFired( CurrentFireMode );
	}
}

simulated function Projectile ProjectileFire()
{
	local vector			StartLoc;
	local Rotator			FireDir;
	local NanoProjectile	SpawnedProjectile;
	local Actor				TargetActor;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		Limb.GetWeaponFireInfo( StartLoc, FireDir, TargetActor );
		FireDir = AddSpread( FireDir );

		// Spawn projectile
		SpawnedProjectile = NanoProjectile(Spawn(GetProjectileClass(), Self,, StartLoc));
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.NanoProjInit( Vector(FireDir), TargetActor );
		}

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}

simulated function IncrementFlashCount()
{
	if( Limb != None )
	{
		Limb.IncrementFlashCount( Self, CurrentFireMode );
	}
}

simulated function LimbNanoStateChanged( Pacifier_LimbBase L );

simulated function HandleTouch( Actor Other, PrimitiveComponent OtherComp );

defaultproperties
{
}