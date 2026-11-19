/**
 * Jetpack
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class JetPackBase extends Actor
	native
	implements( NanoInterface_PowerAffect, NanoInterface_Targetable )
	abstract
	config(Pawn);

/** Jetpack is being used to hover/fly */
var bool bEnabled;

/** Amount of health before jetpack is destroyed */
var config int Health;
/** The jetpack's current NanoState **/
var transient ENanoState CurrNanoState;
/** How long nano state lasts for */
var config float StateChangeAttackDuration;
/** Whether jetpack has exploded already */
var bool	bExploded;
/** Defines the explosion. */
var() instanced editinline NanoExplosion	ExplosionTemplate;
/** Effect for damage trail */
var ParticleSystem PS_Damaged;
/** Particle system attached to JetPackMesh for damage trail */
var transient ParticleSystemComponent PSC_Damaged;

/** The skeletal mesh component for the jet pack */
var SkeletalMeshComponent   JetPackMesh;
/** Effect for thrusters */
var ParticleSystem PS_Thruster;
/** Particle system attached to JetPackMesh for thrusters */
var transient ParticleSystemComponent PSC_Thruster;
/** Effect for exhaust */
var ParticleSystem PS_Exhaust;
/** Particle system attached to JetPackMesh for exhausts */
var transient ParticleSystemComponent PSC_Exhaust[2];


simulated function PlayExplode();

simulated function Tick( float DeltaTime )
{
	UpdateMesh( DeltaTime );
}

simulated function UpdateMesh( float DeltaTime );

simulated function bool CanFly()
{
	return (Health > 0);
}

function SetEnabled( bool bInEnabled )
{
	if( bInEnabled != bEnabled )
	{
		bEnabled = TRUE;
		PlayJetPackEnabled();
	}
}

simulated function PlayJetPackEnabled()
{
	if( bEnabled )
	{
		PSC_Exhaust[0].ActivateSystem();
		PSC_Exhaust[1].ActivateSystem();
	}
}

event TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	local float HealthPct;

	Health -= DamageAmount;
	if( Health <= 0 )
	{
		PlayExplode();
	}
	else
	{
		HealthPct = Health/float(default.Health);
		if( PSC_Damaged == None )
		{
			PSC_Damaged = new(self) class'NanoParticleSystemComponent';
			PSC_Damaged.SetTemplate(PS_Damaged);
		}
		PSC_Damaged.SetFloatParameter( 'DamageAmount', HealthPct );
	}
}



/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_PowerAffect ////////
/////////////////////////////////////////////////////
/** Used to change the nano state of an object */
simulated function bool SetNanoState(ENanoState NewState, Actor InInstigator, optional float NanoPowerAmount)
{
	if( NewState != CurrNanoState )
	{
		if( Role < ROLE_Authority )
		{
			ServerSetNanoState( NewState );
		}

		if( NewState == ENS_Normal )
		{
			//			class'NanoTypes'.static.SetMaterialInstanceToDefault( LimbMIC );
		}
		else if( NewState == ENS_Dust )
		{
			//			class'NanoTypes'.static.SetMaterialInstanceToDusted( LimbMIC );
		}
		else if(NewState == ENS_Dense)
		{
			//			class'NanoTypes'.static.SetMaterialInstanceToDensed( LimbMIC );
		}

		CurrNanoState = NewState;

		// If force to different state, set timer for turning back.
		if( CurrNanoState != ENS_Normal )
		{
			SetTimer( StateChangeAttackDuration, FALSE, nameof(RestoreDefaultNanoState) );
		}
	}
	return TRUE;
}



reliable server function ServerSetNanoState(ENanoState NewState);

/** Used to restore the nano state of an object to default */
simulated function RestoreDefaultNanoState()
{
	SetNanoState(ENS_Normal,self);
}



simulated function bool CanBeChanged( ENanoState NewState )
{
	if( NewState == ENS_Dust )
	{
		return CanBeDusted();
	}
	if( NewState == ENS_Dense )
	{
		return CanBeDensed();
	}
	return TRUE;
}

simulated function bool CanBeDusted()
{
	return FALSE;
}

simulated function bool CanBeDensed()
{
	return FALSE;
}

simulated function bool IsDusted()
{
	return (CurrNanoState == ENS_Dust);
}

simulated function bool IsDensed()
{
	return (CurrNanoState == ENS_Dense);
}

simulated function OnModifyNanoAffectedActor( SeqAct_ModifyNanoAffectedActor InAction );

/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_Targetable /////////
/////////////////////////////////////////////////////
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	if( Health <= 0 )
	{
		return -1.f;
	}
	return 1;
}

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return (Health > 0);
}

/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}

simulated function bool ShouldRateTarget()
{
	// if we have not seen this actor for 2 second then don't allow targeting of it
	return (`TimeSince(LastRenderTime) < 1.f);
}

simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}

/** When this NanoPawn is targetted, which location should we focus on */
simulated event vector GetTargetedLocation()
{
	return Location;
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );


simulated event BoxSphereBounds GetTargetableBounds()
{
	return JetPackMesh.Bounds;
}





defaultproperties
{

}