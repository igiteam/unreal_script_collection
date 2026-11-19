/**
 * This will do:
 *   -enlarge the plumes of all nano ticks
 *   -TODO:  show the subliminal messges ont he bulletin boards
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_Ping extends NanoSkill;

struct PingLevelDatum
{
	/** This is the distance that that ping will affect objects. **/
	var config float AffectDistance;

	/** The nano cost of the ping at his skill level **/
	var config float NanoCost;
};
var config array<PingLevelDatum> PingLevels;


/** Sound to play when firing off this skill. **/
var SoundCue PingSound_Outward;
var SoundCue PingSound_Inward;
var SoundCue PingSound_ActiveReload;

/** This is the wave that flows outward from the player into the world **/
var ParticleSystem OutwardWaveEffect;
var transient ParticleSystemComponent PSC_OutwardWaveEffect;

/** This is the wave that flows inward towards the player from the world **/
var ParticleSystem InwardWaveEffect;
var transient ParticleSystemComponent PSC_InwardWaveEffect;

/** This is the efect that plays when you get an "ActiveReload" ping **/
var ParticleSystem ActiveReloadEffect;
var transient ParticleSystemComponent PSC_ActiveReloadEffect;


/** If this wave is emitting outward or inward **/
var transient bool bOutwardWave;

/** When the first outward ping is fired we keep track of the time so we can determine how far it went and if we should spawn an ActiveReload effect **/
var transient float TimeOutwardPingFired;


/** This will slow the pawn down by this % when the ping is active. **/
var config float VelocityPercentWhenPingIsActive;

/** how long the ping effects should last on an affected object. **/
var config float DurationOfPingEffectsOnAffectedActors;

/** Used for determining if we got an active reload or not **/
var transient float TimeSinceOutwardPing;

/** The location of the pawn is center of the cylinder and the ping needs to spawn down some.  So this is how much we push it down. **/
var vector PingSpawnOffsetFromPawnLocation;


/** We don't want the player being able to ping then move and then unping at a diffent location **/
var transient vector LocationOfPingStart;


simulated function float GetPingDistance( float InPercentageOfPerfect )
{
	return PingLevels[SkillLevel].AffectDistance * InPercentageOfPerfect;
}


simulated function float GetPingNanoCost()
{
	return PingLevels[SkillLevel].NanoCost;
}



/** This should be overridden in the subclass to do any skill specific "activated" functionality **/
simulated protected function InternalActivated()
{
	local Vector Loc;
	local Rotator Rot;


	// handle the case for release the button after attempting to fire off a ping without enough juice
	if( ( bOutwardWave == FALSE )
		&& ( TimeOutwardPingFired == 0.0f )
		)
	{
		return;
	}

	// don't allow a ping if you are moving.  You must be stationary
	if( VSize(PawnOwner.Velocity) > 0.0f )
	{
		return;
	}


	// grab camera location/rotation
	NanoPC(PawnOwner.Controller).GetPlayerViewPoint( Loc, Rot );

	//`log( "Rot" @ Rot );

	// rot doesn't matter for this emitter atm as it is just a ring on xy plane
	if( bOutwardWave == TRUE )
	{
		LocationOfPingStart = PawnOwner.Location;

		PawnOwner.ConsumeNanoPower( GetPingNanoCost() );

		PawnOwner.PlaySound( PingSound_Outward );
		PSC_OutwardWaveEffect = PawnOwner.WorldInfo.MyEmitterPool.SpawnEmitter( OutwardWaveEffect, PawnOwner.Location-PingSpawnOffsetFromPawnLocation, Rot );

		TimeOutwardPingFired = PawnOwner.WorldInfo.TimeSeconds;
		//`log( "Outward" @ TimeOutwardPingFired );
	}
	else
	{
		// if you moved a lot then you do not get to have the inward wave
		if( VSize(LocationOfPingStart - PawnOwner.Location) > 10.0f )
		{
			return;
		}


		TimeSinceOutwardPing = PawnOwner.WorldInfo.TimeSeconds - TimeOutwardPingFired;
		//`log( `showvar(TimeSinceOutwardPing) );

		if( TimeSinceOutwardPing <= 0.8f )
		{
			TimeSinceOutwardPing += 1.0f;
			// go ahead and just allow the ping to go out and come back as the user didn't try for an active reload
           	PawnOwner.SetTimer( 1.0f, FALSE, nameof(FireOffInwardPing), self );
		}
		else
		{
			FireOffInwardPing();
		}
	}
}

simulated function FireOffInwardPing()
{
	local Vector Loc;
	local Rotator Rot;

	local vector PingSize;
	local bool bDidActiveReloadPing;
	local float PercentageOfPerfect;
	local float NanoPingDistance;
	local Actor PingAffectable;

	//`log( "FireOffInwardPing FIRED OFF" );

	// grab camera location/rotation
	NanoPC(PawnOwner.Controller).GetPlayerViewPoint( Loc, Rot );


	PSC_OutwardWaveEffect.SetHidden( TRUE );
	PSC_OutwardWaveEffect.DeactivateSystem();


	PingSize = vect(1,1,1) * ( ((TimeSinceOutwardPing * 1000.0f) * 3.55f) / 128.0f );
	//`log( "PingSize" @ PingSize );

	PSC_InwardWaveEffect = PawnOwner.WorldInfo.MyEmitterPool.SpawnEmitter( InwardWaveEffect, PawnOwner.Location-PingSpawnOffsetFromPawnLocation, Rot );
	PSC_InwardWaveEffect.SetVectorParameter( 'PingSize', PingSize );

	// so the normal ping lasts ~1.6s before it fully fades so we will say and AR is 250ms before that.
	if( ( TimeSinceOutwardPing > 1.40f ) && ( TimeSinceOutwardPing < 1.8f ) )
	{

		PSC_ActiveReloadEffect = PawnOwner.WorldInfo.MyEmitterPool.SpawnEmitter( ActiveReloadEffect, PawnOwner.Location-PingSpawnOffsetFromPawnLocation, Rot );
		PSC_ActiveReloadEffect.SetVectorParameter( 'PingSize', PingSize );
		PSC_ActiveReloadEffect.SetFloatParameter( 'PingLife', 1.0f );

		PawnOwner.PlaySound( PingSound_ActiveReload );

		bDidActiveReloadPing = TRUE;
		//`log( "AR AR AR AR AR!!!" );
	}
	else
	{
		PawnOwner.PlaySound( PingSound_Inward );
	}

	PercentageOfPerfect = TimeSinceOutwardPing / 1.7f;  // we can get a bonus by being at the sweet spot

	//`log( "Inward" @ TimeSinceOutwardPing @ PercentageOfPerfect );
		
	NanoPingDistance = GetPingDistance( PercentageOfPerfect );

	foreach PawnOwner.CollidingActors( class'Actor', PingAffectable, NanoPingDistance, PawnOwner.Location, FALSE, class'NanoInterface_PingAffectable' )
	{
		NanoInterface_PingAffectable(PingAffectable).DoPingEffects( bDidActiveReloadPing );
	}

	PawnOwner.SetTimer( 1.0f, FALSE, nameof(ResetTimeOutwardPingFired), self );

}


simulated function ResetTimeOutwardPingFired()
{
	//`log( "RESEET" );
	TimeOutwardPingFired = 0.0f; // reset
}

/** This should be overridden in the subclass to do any skill specific "deactivated" functionality **/
simulated protected function InternalDeactivated()
{
}



defaultproperties
{
	SkillType=NS_Ping


	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)

	PingSound_Outward=SoundCue'Gameplay_Audio.NanoPing.NanoPing_Pulse_01Cue'
	PingSound_Inward=SoundCue'Gameplay_Audio.NanoPing.NanoPing_Return_01Cue'
	PingSound_ActiveReload=SoundCue'Gameplay_Audio.NanoPing.NanoPing_Active_01Cue'

	// PingLife (time effect will exist, default is 1.8 seconds)
	// 1.8 seconds to get to 6400 units so  6400uu/1800ms  = 3.55 units every 1ms
	//PingSize (Overall reach of effect, vector param, scale factor is approx. x*128, so a PingSize of 2,2,2 will give you an effective radius of 256 units) 
	OutwardWaveEffect=ParticleSystem'Nano_FX.Effects.P_Nano_FX_RingPulse_01'
	InwardWaveEffect=ParticleSystem'Nano_FX.Effects.P_Nano_FX_RingPulse_02'

	ActiveReloadEffect=ParticleSystem'Nano_FX.Effects.P_Nano_FX_RingPulse_Critical' // Uses PingLife and PingSize just the same.  Probably set PingLife to 1 or so for this one.

	PingSpawnOffsetFromPawnLocation=(X=0,Y=0,Z=77)

}