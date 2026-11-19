/**
 * Actor which holds all of the ground pound data
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GroundPoundEffect extends Actor
	config(Game);





/** This is played when you land a drop the hammer move. **/
var const NanoCameraShake GroundPoundScreenShake;
/** The controller vibration waveform for when firing this weapon **/
var const protected ForceFeedbackWaveform GroundPoundWaveForm;
/** Used to push physics when explosion goes off. */
var protected RB_RadialImpulseComponent	GroundPoundImpulse;


var config float GroundPoundDamageRadius;

var config float GroundPoundThrowRadius;


var config protected InterpCurveFloat GroundPoundDamage;
var config protected InterpCurveFloat GroundPoundDamagePlayer;


var config protected float GroundPoundBreakFracturedMeshesRadius;

var config protected float GroundPoundAffectFlyingCarsRadius;

var config protected float GroundPoundSmashDownTeslaCoilsRadius;

/** The effect to play when you land the drop the hammer. **/
var protected ParticleSystem PS_GroundPoundImpact;



var ParticleSystem OutwardWaveEffect;
var transient ParticleSystemComponent PSC_OutwardWaveEffect;

/** The location of the pawn is center of the cylinder and the ping needs to spawn down some.  So this is how much we push it down. **/
var vector PingSpawnOffsetFromPawnLocation;


var SoundCue GroundPoundExplosionSound;




function DoGroundPoundEffects( Pawn InstigatorPawn )
{
	local Actor HitA;
	local vector HitN, HitL;
	local Emitter GroundEffect;


	`log( "Doing GroundPound EFFECTS" );

	AttachComponent( GroundPoundImpulse );
	NanoGRI(WorldInfo.GRI).BreakFracturedMeshes( Location, class'NDT_GroundPound', GroundPoundBreakFracturedMeshesRadius, FALSE );
	NanoGRI(WorldInfo.GRI).AffectFlyingCars( Location, class'NDT_GroundPound', GroundPoundAffectFlyingCarsRadius );
	NanoGRI(WorldInfo.GRI).SmashDownTeslaCoils( Location, class'NDT_GroundPound', GroundPoundSmashDownTeslaCoilsRadius );
	GroundPoundImpulse.FireImpulse( Location ); //@todo - explosive damage that damages on hammer!

	PlaySound( GroundPoundExplosionSound );

	HitA = Trace( HitL, HitN, Location - vect(0,0,512), Location, FALSE );
	if( HitA != None )
	{
		GroundEffect = NanoGRI(WorldInfo.GRI).NOP.GetImpactEmitter( PS_GroundPoundImpact, HitL, rot(0,0,0));
		GroundEffect.SetDrawScale( 5.0f );
		GroundEffect.ParticleSystemComponent.ActivateSystem();
	}



	PSC_OutwardWaveEffect = InstigatorPawn.WorldInfo.MyEmitterPool.SpawnEmitter( OutwardWaveEffect, InstigatorPawn.Location-PingSpawnOffsetFromPawnLocation, rot(0,0,0) );

	// Scare crowd people
	//CauseCrowdPanic();


}



function DoGroundPoundDamage( Pawn InstigatorPawn )
{
	local float DamageBasedOnDistance;
	local NanoPawn Victim;
	local float VictimDist;

	// quick hack to get this prototyped.  (need to convert to using GameExplosion and modifying it to have AffectFlyingCars)
	foreach CollidingActors( class'NanoPawn', Victim, FMax(GroundPoundDamageRadius, GroundPoundThrowRadius), Location, TRUE )
	{
		if( ( Victim != none ) && ( Victim != InstigatorPawn ) )
		{
			if( Victim.bImmuneToGroundPoundAttack == TRUE )
			{
				continue;
			}

			VictimDist = VSize(Location - Victim.Location);


			// check for player or ai
			if( Victim.IsHumanControlled() == TRUE )
			{
				DamageBasedOnDistance = EvalInterpCurveFloat( GroundPoundDamagePlayer, VictimDist );
			}
			else
			{
				DamageBasedOnDistance = EvalInterpCurveFloat( GroundPoundDamage, VictimDist );
			}

			//`log( `showvar(DamageBasedOnDistance)  @ `showvar(VictimDist) );

			// First see if pawn is within damage radius
			if( VictimDist <= GroundPoundDamageRadius )
			{
				// If so, do damage
				Victim.TakeRadiusDamage( (Instigator != None ? Instigator.Controller : None), DamageBasedOnDistance, GroundPoundDamageRadius, class'NDT_GroundPound', 1.f, InstigatorPawn.Location, TRUE, InstigatorPawn );
			}

			// Now see if they are still alive, and within throw radius
			if( (Victim.Health > 0) && (VictimDist <= GroundPoundThrowRadius) )
			{
				Victim.DoSpecialMove( 'NSM_Melee_AgentGroundPound_Victim', TRUE,, InstigatorPawn );
			}
		}
	}

	// add stimulus for the AI.  We just dropped the hammer and that is all "alert alert"
	NanoGRI(WorldInfo.GRI).AddStimuliInARadiusAroundEvent( 2048, self, Location, TRUE, FALSE, TRUE, FALSE );

}






defaultproperties
{
	LifeSpan=20.0f

	GroundPoundExplosionSound=SoundCue'Gameplay_Audio.DropHammer.DropHammer_Explosion_Cue'

	PS_GroundPoundImpact=ParticleSystem'Nano_FX.Effects.P_FX_Nano_GroundImpact'


	Begin Object Class=RB_RadialImpulseComponent Name=GroundPoundImpulseComp
		ImpulseRadius=4096.0f
		ImpulseStrength=768.0f
		bVelChange=TRUE
		ImpulseFalloff=RIF_Constant
	End Object
	GroundPoundImpulse=GroundPoundImpulseComp

	OutwardWaveEffect=ParticleSystem'Nano_FX.Effects.P_Nano_FX_RingPulse_01'
	PingSpawnOffsetFromPawnLocation=(X=0,Y=0,Z=77)
}