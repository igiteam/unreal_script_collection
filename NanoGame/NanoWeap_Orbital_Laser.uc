/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Orbital_Laser extends NanoWeap_Orbital_Base;

/** Amount of time for laser to warm up */
var() config float	LaserWarmupTime;
/** Amount of time for laser to fire */
var() config float	LaserFireTime;
/** Amount of time between explosion actor placement during the fire */
var() config float	LaserPlaceExplosionsInterval;
/** Amount of time to delay before first impact explosion */
var() config float	LaserInitialExplodeDelay;
/** Amount of time between sequential explosions after initial */
var() config float	LaserExplosionDelay;
/** Number of explosions placed this firing sequence */
var()		 int	LaserExplosionCnt;

/** Amount of delay before explosion damage is done */
var() config float		DelayBeforeTriggerDamage;
/** Amount of damage done at the epicenter. */
var() config float		ExploDamage;
/** Damage range. */
var() config float	ExploDamageRadius;
/** Defines how damage falls off.  High numbers cause faster falloff, lower (closer to zero) cause slower falloff.  1 is linear. */
var() config float	ExploDamageFalloffExp;

var(Debug)	bool bDrawDebugLaser;

simulated state WeaponFiring
{
	simulated event BeginState( Name PreviousStateName )
	{
//		PlaySound( SpinUpCue );
		if( LaserWarmupTime > 0.f )
		{
			SetTimer( LaserWarmupTime, FALSE, nameof(WarmupTimeExpired) );
		}
		else
		{
			WarmupTimeExpired();
		}
	}

	simulated function WarmupTimeExpired()
	{
		if( ShouldRefire() )
		{
			// Fire the first
			FireAmmunition();
		}
		else
		{
			HandleFinishedFiring();
		}
	}

	simulated event EndState( Name NextStateName )
	{
		ClearTimer( nameof(WarmupTimeExpired) );
		Super.EndState( NextStateName );
	}
	
	simulated function CustomFire()
	{
		local NanoPawn_MetaCorp_OrbitalBot Bot;
		local Vector X, Y, Z;
		local Vector StartLoc, EndLoc;
		local Actor MyEnemy;
		local float CollisionHeight;

		LaserExplosionCnt = 0;

		Bot = NanoPawn_MetaCorp_OrbitalBot(Instigator);
		MyEnemy = NanoAIBase(Bot.Controller).FireTarget;
		
		GetAxes( Bot.Rotation, X, Y, Z );
		if( (Y DOT MyEnemy.Velocity) > 0.f )
		{
			Y = -Y;
		}
		
		// Pick location to start/end firing
		CollisionHeight = Pawn(MyEnemy) != None ? Pawn(MyEnemy).GetCollisionHeight() : 0.0f;
		
		StartLoc = MyEnemy.Location + (Y * 512.f) - (X * 256.f) - (Z * CollisionHeight);
		EndLoc = MyEnemy.Location - (Y * 512.f) - (X * 256.f) - (Z * CollisionHeight);

		if( bDrawDebugLaser )
		{
			FlushPersistentDebugLines();
			DrawDebugBox( StartLoc, vect(5,5,5), 0, 255, 0, TRUE );
			DrawDebugBox( EndLoc, vect(5,5,5), 0, 0, 255, TRUE );
			DrawDebugBox( MyEnemy.Location, vect(5,5,5), 255, 255, 255, TRUE );
		}

		Bot.FirePrimaryLaser( StartLoc, EndLoc, LaserFireTime );

		PlaceExplosionPoint();
					
		WeaponFired(CurrentFireMode);
	}

	function PlaceExplosionPoint()
	{
		local NanoExplosionActor_OrbitalLaser ExplosionActor;
		local NanoPawn_MetaCorp_OrbitalBot Bot;
		local Vector ExplosionPt, ExplosionNorm;

		Bot = NanoPawn_MetaCorp_OrbitalBot(Instigator);
		if( Bot.GetCurrentPrimaryLaserImpactLocation( ExplosionPt, ExplosionNorm ) )
		{
			// Set timer for next explosion - small decrease in interval so we fit them all in 
			SetTimer( LaserPlaceExplosionsInterval*0.95f, FALSE, nameof(PlaceExplosionPoint) );

			if( bDrawDebugLaser )
			{
				DrawDebugBox( ExplosionPt, vect(10,10,10), 255, 0, 0, TRUE );
			}

			// Add new pending explosion
			ExplosionActor = Spawn(class'NanoExplosionActor_OrbitalLaser',,, ExplosionPt, Rotator(ExplosionNorm) );
			if( ExplosionActor != None )
			{
				ExplosionActor.Init( self, ExplosionPt, ExplosionNorm, LaserInitialExplodeDelay + (LaserExplosionCnt * LaserExplosionDelay) );
				LaserExplosionCnt++;
			}
		}
	}

	simulated function Tick( float DeltaTime )
	{
		local NanoPawn_MetaCorp_OrbitalBot Bot;
		local Vector ExplosionPt, ExplosionNorm;

		Super.Tick( DeltaTime );

		Bot = NanoPawn_MetaCorp_OrbitalBot(Instigator);
		if( !IsTimerActive( nameof(WarmupTimeExpired) ) )
		{
			if( Bot.GetCurrentPrimaryLaserImpactLocation( ExplosionPt, ExplosionNorm ) )
			{
				if( bDrawDebugLaser )
				{
					DrawDebugBox( ExplosionPt, vect(5,5,5), 255, 0, 0, TRUE );
					DrawDebugLine( Bot.GetPrimaryLaserStartLocation(), ExplosionPt, 255, 0, 0, FALSE );
				}
			}
			else
			{
				Bot.StopFiring();
				HandleFinishedFiring();
			}
		}
	}
}



defaultproperties
{
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	Spread(0)=0.05f
	WeaponProjectiles(0)=none
	InstantHitDamageTypes(0)=class'NDT_MP7'
	InstantHitDamage(0)=0.0f
	InstantHitMomentum(0)=0.0f
	FireInterval(0)=+0.1f

	bDrawDebugLaser=TRUE
}