/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_DropTheHammer extends NanoSpecialMove;

/** This is the distance needed to fall to be able to do the DropTheHammer move **/
var protected config float DistanceNeededToDropTheHammer;

/** The Start location of the DropTheHammer Move.  Used to check how far we have fallen for DropTheHammer2 **/
var protected transient vector StartLocationForDropTheHammer;
var protected transient Vector StartVelocityForDropTheHammer;

/** This is the distance that the pawn has fallen while performing drop the hammer move **/
var protected transient float DistanceFallenWhileDroppingTheHammer;

/** How long to free in air pre dropping the hammer **/
var protected config InterpCurveFloat DurationOfMidAirFreezePreHammer;
/** How long to free in post dropping the hammer **/
var protected config InterpCurveFloat DurationOfLandingFreezePostHammer;

/** This is played when you land a drop the hammer move. **/
var const NanoCameraShake DroppingTheHammerScreenShake;
/** The controller vibration waveform for when firing this weapon **/
var const protected ForceFeedbackWaveform DroppingTheHammerWaveForm;
/** Used to push physics when explosion goes off. */
var protected RB_RadialImpulseComponent	DroppingTheHammerImpulse;
/** event Landed is not being triggered on clients and probably won't have all of the correct bVars.  So for Hammer effects we just replicate out a byte **/

var config protected InterpCurveFloat DropTheHammerDamage;
var config protected InterpCurveFloat DropTheHammerDamageRadius;
var config protected InterpCurveFloat DropTheHammerThrowRadius;
var config protected InterpCurveFloat DropTheHammerBreakFracturedMeshesRadius;
var config protected InterpCurveFloat DropTheHammerAffectFlyingCarsRadius;


var config protected InterpCurveFloat DropTheHammerCarThrowVel;
var config protected InterpCurveFloat DropTheHammerCarThrowVelUp;


/** How long to free in post dropping the hammer **/
var protected config InterpCurveFloat ImpactEffectScaleCurve;
/** The effect to play when you land the drop the hammer. **/
var protected ParticleSystem PS_DropTheHammerImpact;

/** Sounds for dropping the hammer **/
var protected SoundCue DroppingTheHammerStartCue;
var protected transient AudioComponent AC_DroppingTheHammerInAirFalling;
var protected SoundCue DroppingTheHammerInAirFallingCue;
var protected SoundCue DroppingTheHammerImpactCue;
var protected SoundCue DroppingTheHammerImpactShortDropCue;

var config bool bLogOutAllInterpCurveValuesWeUsed;

protected function bool InternalCanDoSpecialMove()
{
	local Vector    Start, End, HitLoc, HitNorm;
	local Actor     HitActor;
	
	if( MyNP.bIsDoingMeleeAttack )
	{
		return FALSE;
	}

	Start = MyNP.Location;
	End = Start + (vect(0,0,-1) * DistanceNeededToDropTheHammer );
	HitActor = MyNP.Trace( HitLoc, HitNorm, End, Start, TRUE,,, class'Actor'.const.TRACEFLAG_Bullet );

	if( HitActor != None && HitActor.bBlockActors )
	{
		return FALSE;
	}

	if( HitActor != None && ( HitActor.bBlockActors == FALSE ) )
	{
		return TRUE;
	}

	// need to be up high enough to drop the hammer
	if( HitActor == None )
	{
		return TRUE;
	}


	return FALSE;
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );
	ExtractSpecialMoveFlags( MyNP.SpecialMoveFlags );

	InitDropTheHammer();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.DeactivateSkill(class'NanoSkill_Dense');

	MyNP.FullBodySlot.StopCustomAnim(0.25f);
	MyNP.bInAirFreezeForDropTheHammer = FALSE;
	MyNP.bBRINGDAHAMMER = FALSE;
	MyNP.bUseHammerAnim = FALSE;
	MyNP.bJumpSetIsDirty = TRUE;
	MyNP.bStuckAfterDroppingTheHammer = FALSE;

	MyNP.ClearTimer( nameof(ReleaseHammerMidAirFreeze), self );
	MyNP.ClearTimer( nameof(RestoreMovementPostDroppingTheHammer), self );

	if( bLogOutAllInterpCurveValuesWeUsed == TRUE )
	{
		LogOutAllInterpCurveValuesWeUsed();
	}
}


final function LogOutAllInterpCurveValuesWeUsed()
{
`if(`notdefined(FINAL_RELEASE))
	local float DistDropped;

	DistDropped = VSize(StartLocationForDropTheHammer - MyNP.Location);

	`log( `showvar(DistDropped) );
	`log( `showvar(EvalInterpCurveFloat( DurationOfMidAirFreezePreHammer, DistDropped )) );
	`log( `showvar(EvalInterpCurveFloat( DropTheHammerDamage, DistDropped )) );
	`log( `showvar(EvalInterpCurveFloat( DropTheHammerDamageRadius, DistDropped )) );
	`log( `showvar(EvalInterpCurveFloat( DropTheHammerThrowRadius, DistDropped )) );
	`log( `showvar(EvalInterpCurveFloat( DurationOfLandingFreezePostHammer,DistDropped )) );

	`log( `showvar(EvalInterpCurveFloat( DropTheHammerBreakFracturedMeshesRadius, DistDropped )) );
	`log( `showvar(EvalInterpCurveFloat( DropTheHammerAffectFlyingCarsRadius, DistDropped )) );
	`log( `showvar(EvalInterpCurveFloat( ImpactEffectScaleCurve, DistDropped )) );
`endif
}


final function float DetermineDistanceToGround()
{
	local Vector Start, End, HitLoc, HitNorm;
	local Actor HitActor;
	local float MaxDistToTrace;

	MaxDistToTrace = 5000;

	Start = MyNP.Location;
	End = Start + (vect(0,0,-1) * MaxDistToTrace );
	HitActor = MyNP.Trace( HitLoc, HitNorm, End, Start, TRUE,,, class'Actor'.const.TRACEFLAG_Bullet );
	if( HitActor != None  )
	{
		return VSize( Start - HitLoc);
	}

	return MaxDistToTrace;
}


simulated function InitDropTheHammer()
{
	local float DistToGround;

	StartVelocityForDropTheHammer = MyNP.Velocity;
	StartLocationForDropTheHammer = MyNP.Location;
	MyNP.bBRINGDAHAMMER = TRUE;
	MyNP.bInAirFreezeForDropTheHammer = TRUE;

	DistToGround = DetermineDistanceToGround();


	MyNP.SetTimer( EvalInterpCurveFloat( DurationOfMidAirFreezePreHammer, DistToGround ), FALSE, nameof(ReleaseHammerMidAirFreeze), self );

	if( DistToGround > 1024.0f )
	{
		MyNP.PlaySound( DroppingTheHammerStartCue );
	}

	MyNP.bUseHammerAnim = TRUE;
	MyNP.BlendFallNode.bResetFall = TRUE;
	MyNP.BlendFallNode.ChangeFallState( FBT_None );

    NanoGRI(MyNP.WorldInfo.GRI).ModifyChaosLevel( MyNP.GetChaosZone(), MyNP, class'NanoCausingChaosValues'.default.DroppingTheHammer );
	MyNP.UpdateJumpAnimSet();

	// Disable collision to prevent landing on pawn hands
	MyNP.SetCollision( FALSE, FALSE, FALSE );

	MyNP.ActivateSkill(class'NanoSkill_Dense');
}

simulated function ReleaseHammerMidAirFreeze()
{
	local float DistToGround;
	DistToGround = DetermineDistanceToGround();

	MyNP.bInAirFreezeForDropTheHammer = FALSE;
	//MyNP.Velocity = StartVelocityForDropTheHammer * vect(0.8f,0.8f,0.f);  hammer drop is ALWAYS straight down

	if( DistToGround > 1024.0f )
	{
		if( AC_DroppingTheHammerInAirFalling == None )
		{
			AC_DroppingTheHammerInAirFalling = new(MyNP) class'AudioComponent';
			MyNP.AttachComponent( AC_DroppingTheHammerInAirFalling );
			AC_DroppingTheHammerInAirFalling.SoundCue = DroppingTheHammerInAirFallingCue;
		}
		AC_DroppingTheHammerInAirFalling.FadeIn( 0.100f, 1.0f );
	}
}

function HandleLanded( Vector HitNormal, Actor FloorActor )
{
	local bool bBustingThroughWithHammer;
	local float DistDropped;
	local float DamageBasedOnDistance;
	local float DropTheHammerDamageRadiusDist;
	local float DropTheHammerThrowRadiusDist;
	local float CarThowVel, CarThowVelUp;
	local float VictimDist;
	local Actor DropHammerVictim;
	local NanoPawn DropHammerVictimNP;
	local NanoVehicleAgent DropHammerVictimNVA;
	local NanoPC PC;
	local Nano_KActor NK;

	PC = NanoPC(MyNP.Controller);
	bBustingThroughWithHammer = (FracturedStaticMeshActor(FloorActor) != None);

	MyNP.UpdateJumpAnimSet( 'DropTheHammer' );
	DistDropped = VSize(StartLocationForDropTheHammer - MyNP.Location);

	if( !bBustingThroughWithHammer )
	{
		if( AC_DroppingTheHammerInAirFalling != None )
		{
			AC_DroppingTheHammerInAirFalling.FadeOut( 0.250f, 0.0f );
			AC_DroppingTheHammerInAirFalling.FadeOut( 0.100f, 1.0f );
		}

		if( DistDropped > 700 )
		{
			MyNP.PlaySound( DroppingTheHammerImpactCue );
			//`log( "long" @ `showvar(DistDropped) );
		}
		else
		{
			MyNP.PlaySound( DroppingTheHammerImpactShortDropCue );
			//`log( "short" @ `showvar(DistDropped) );
		}


		if( PC != None )
		{
			PC.ClientPlayCameraShake( DroppingTheHammerScreenShake );
			PC.ClientPlayForceFeedbackWaveform( DroppingTheHammerWaveForm );
		}
	}
	
	// Do drop effects, since this is what busts fracture actors, etc
	DoDropTheHammerEffects();

	
	DamageBasedOnDistance = EvalInterpCurveFloat( DropTheHammerDamage, DistDropped );
	DropTheHammerDamageRadiusDist = EvalInterpCurveFloat( DropTheHammerDamageRadius, DistDropped );
	DropTheHammerThrowRadiusDist = EvalInterpCurveFloat( DropTheHammerThrowRadius, DistDropped );

	CarThowVel = EvalInterpCurveFloat( DropTheHammerCarThrowVel, DistDropped );
	CarThowVelUp = EvalInterpCurveFloat( DropTheHammerCarThrowVelUp, DistDropped );


	//`log( `showvar(DamageBasedOnDistance) @ `showvar(DropTheHammerDamageRadiusDist) @ `showvar(DropTheHammerThrowRadiusDist) @ `showvar(StartLocationForDropTheHammer) @ `showvar(DistDropped) );

	// quick hack to get this prototyped.  (need to convert to using GameExplosion and modifying it to have AffectFlyingCars)
	foreach MyNP.CollidingActors( class'Actor', DropHammerVictim, FMax( DropTheHammerDamageRadiusDist, DropTheHammerThrowRadiusDist ), MyNP.Location, TRUE )
	{
		if( DropHammerVictim != None && DropHammerVictim != MyNP )
		{
			VictimDist = VSize(MyNP.Location - DropHammerVictim.Location);

			// First see if pawn is within damage radius
			if( VictimDist <= DropTheHammerDamageRadiusDist )
			{
				// If so, do damage
				DropHammerVictim.TakeRadiusDamage( (MyNP.Instigator != None ? MyNP.Instigator.Controller : None), DamageBasedOnDistance, DropTheHammerDamageRadiusDist, class'NDT_DroppingTheHammer', 1.f, MyNP.Location, TRUE, MyNP);
			}

			DropHammerVictimNP = NanoPawn(DropHammerVictim);
			//`log( `showvar(DropHammerVictimNP.AffectedByHitEffects() ) );

			// we have to check here because this NSM is forced so we can't check in the CanDoSpecialMove
			if( ( DropHammerVictimNP != None ) && ( DropHammerVictimNP.AffectedByHitEffects() == TRUE ) )
			{
				// Now see if they are still alive, and within throw radius
				if((DropHammerVictimNP.Health > 0) && (VictimDist <= DropTheHammerThrowRadiusDist))
				{
					DropHammerVictimNP.DoSpecialMove( 'NSM_Melee_DropTheHammer_Victim', TRUE,, MyNP );
				}

				if( DropHammerVictimNP.Health <= 0 )
				{
					NanoGRI(MyNP.WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.HighestDropTheHammerWithAKillAtEnd, DistDropped );
				}
			}

			DropHammerVictimNVA = NanoVehicleAgent(DropHammerVictim);

			if( ( DropHammerVictimNVA != None ) &&  (VictimDist <= DropTheHammerThrowRadiusDist) )
			{
				DropHammerVictimNVA.SmashNanoVehicleAgent( (MyNP.Location - DropHammerVictimNVA.Location), CarThowVel, CarThowVelUp, (MyNP.Instigator != None ? MyNP.Instigator.Controller : None), class'NDT_DroppingTheHammer' );
			}			
		}
	}

	if( !bBustingThroughWithHammer )
	{
		MyNP.bStuckAfterDroppingTheHammer = TRUE;
		MyNP.SetTimer( EvalInterpCurveFloat( DurationOfLandingFreezePostHammer, DistDropped ), FALSE, nameof(RestoreMovementPostDroppingTheHammer), self );

		MyNP.bBRINGDAHAMMER = FALSE;
		MyNP.DeactivateSkill(class'NanoSkill_Dash');
		MyNP.DeactivateSkill(class'NanoSkill_Dense');

		// Re-enable collision
		MyNP.SetCollision( MyNP.default.bCollideActors, MyNP.default.bBlockActors, MyNP.default.bIgnoreEncroachers );

		MyNP.ZeroMovementVariables();
	}

	NK = Nano_KActor(FloorActor);
	if( NK != None )
	{
		NK.HammerDropHit( MyNP );
	}

	// fire off event for kismet usage
	MyNP.TriggerEventClass( class'SeqEvt_DroppedTheHammer', MyNP, 0 );

	// add stimulus for the AI.  We just dropped the hammer and that is all "alert alert"
	NanoGRI(MyNP.WorldInfo.GRI).AddStimuliInARadiusAroundEvent( 2048, MyNP, MyNP.Location, TRUE, FALSE, TRUE, FALSE );
}

protected simulated function RestoreMovementPostDroppingTheHammer()
{
	MyNP.EndSpecialMove();
}

simulated function DoDropTheHammerEffects()
{
	local Actor HitA;
	local vector HitN, HitL;
	local Emitter GroundEffect;
	local NanoGRI GRI;
	local float DistDroppedHammer;

	GRI = NanoGRI(MyNP.WorldInfo.GRI);

	DistDroppedHammer = VSize(StartLocationForDropTheHammer - MyNP.Location);

	MyNP.AttachComponent( DroppingTheHammerImpulse );

	if( GRI != None )
	{
		GRI.BreakFracturedMeshes( MyNP.Location, class'NDT_DroppingTheHammer', EvalInterpCurveFloat( DropTheHammerBreakFracturedMeshesRadius, DistDroppedHammer ), FALSE );
		GRI.AffectFlyingCars( MyNP.Location, class'NDT_DroppingTheHammer', EvalInterpCurveFloat( DropTheHammerAffectFlyingCarsRadius, DistDroppedHammer ) );
	}
	DroppingTheHammerImpulse.FireImpulse( MyNP.Location ); //@todo - explosive damage that damages on hammer!

	HitA = MyNP.Trace( HitL, HitN, MyNP.Location - vect(0,0,512), MyNP.Location, FALSE,,, class'Actor'.const.TRACEFLAG_Bullet );
	if( HitA != None )
	{
		if( GRI != None )
		{
			GroundEffect = GRI.NOP.GetImpactEmitter( PS_DropTheHammerImpact, HitL, rot(0,0,0));
			GroundEffect.SetDrawScale( EvalInterpCurveFloat( ImpactEffectScaleCurve, DistDroppedHammer ));
			GroundEffect.ParticleSystemComponent.ActivateSystem();
		}
	}

	// Scare crowd people
	MyNP.CauseCrowdPanic();
}

defaultproperties
{
	Begin Object Class=NanoCameraShake Name=DroppingTheHammerScreenShake0
		OscillationDuration=0.3f
		RotOscillation={(Yaw=(Amplitude=35.f,Frequency=125.f),
						Roll=(Amplitude=35.f,Frequency=125.f))}
	End Object
	DroppingTheHammerScreenShake=DroppingTheHammerScreenShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformDroppingTheHammer1
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.500)
	End Object
	DroppingTheHammerWaveForm=ForceFeedbackWaveformDroppingTheHammer1

	DroppingTheHammerStartCue=SoundCue'Gameplay_Audio.DropHammer.DropHammer_Activate_Cue'
	DroppingTheHammerInAirFallingCue=SoundCue'Foley_Body.Player.Body_FlyingWind_Loop_Cue'
	DroppingTheHammerImpactCue=SoundCue'Gameplay_Audio.DropHammer.DropHammer_Explosion_Cue'
	DroppingTheHammerImpactShortDropCue=SoundCue'Foley_Crashes.Explosions.G3_ExplosionGenericC_ShortCue'

	Begin Object Class=RB_RadialImpulseComponent Name=DroppingTheHammerImpulseComp
	    ImpulseRadius=4096.0f
		ImpulseStrength=768.0f
		bVelChange=TRUE
		ImpulseFalloff=RIF_Constant
	End Object
	DroppingTheHammerImpulse=DroppingTheHammerImpulseComp
	//Components.Add(DroppingTheHammerImpulse)

	PS_DropTheHammerImpact=ParticleSystem'Nano_FX.Effects.P_FX_Nano_GroundImpact'
}