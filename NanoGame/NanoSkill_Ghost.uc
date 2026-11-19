/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_Ghost extends NanoSkill_NanoPowerBase
	native(Pawn)
	config(Pawn);


var transient float LastActivationTime;


/** Particle effects for the hands **/
var ParticleSystem HandEffect;
var transient ParticleSystemComponent PSC_HandEffectLeft;
var transient ParticleSystemComponent PSC_HandEffectRight;




struct native GhostLevelDatum
{
	/** The percentage of damage you take from any damage given to you at this level of skill **/
	var config float PercentDamageTaken;

	/** the percentage of damage you take from an explosive damage when you are at this level of skill **/
	var config float PercentDamageTakenFromExplosives;

	var config float FallingVelDampening;

	var config float GravityScale;

	var config float MaxFallSpeed;
};

var config array<GhostLevelDatum> GhostLevels;

/** Goal value we want for the "Run" MIC param **/
var transient float MICRunValueCurr;

simulated function bool ShouldActivate()
{
	local Actor A;
	local Actor HitActor;
	local Vector HitLocation, HitNormal, TraceStart, TraceEnd, TraceExtent;

	if( PawnOwner.bWantsToDash )
	{
		foreach PawnOwner.TouchingActors( class'Actor', A )
		{
			if( NanoVolume_Fan(A) != None || NanoVolume_Dust(A) != None )
			{
				return TRUE;
			}
		}

		TraceStart = PawnOwner.Location;
		TraceEnd = TraceStart + (Vector(PawnOwner.Rotation) * (256.f + PawnOwner.GetCollisionRadius()));
		TraceExtent = PawnOwner.GetCollisionExtent() * 0.95f;
		HitActor = PawnOwner.Trace( HitLocation, HitNormal, TraceEnd, TraceStart, TRUE, TraceExtent );
		if( NanoVolume_Dust(HitActor) != None )
		{
			return TRUE;
		}		
	}

	return FALSE;
}

simulated event Tick( float DeltaTime )
{
	local bool bWantsToGhost;

	Super.Tick( DeltaTime );

	if( (bActive || PawnOwner.bFakeGhostEffects) && ShouldPlayClientEffects() )
	{
		UpdatePowerEffects( DeltaTime, PawnOwner );
	}

	bWantsToGhost = ShouldActivate();
	if( !bActive && bWantsToGhost )
	{
		ActivateSkill();
	}
	else if( bActive && !bWantsToGhost )
	{
		DeactivateSkill();
	}
}

simulated function UpdatePowerEffects( float DeltaTime, NanoPawn NP )
{
	if( MIC_Body != None && MIC_Head != None && MIC_Scarf != None && MIC_HandForge != None )
	{
		if( MICValueCurr != MICValueGoal )
		{
			MICValueCurr = FInterpTo( MICValueCurr, MICValueGoal, DeltaTime, 3 );

			MIC_Body.SetScalarParameterValue( 'Blend', MICValueCurr );
			MIC_Body.SetScalarParameterValue( 'Fade', MICValueCurr );

			MIC_Head.SetScalarParameterValue( 'Blend', MICValueCurr );
			MIC_Head.SetScalarParameterValue( 'Fade', MICValueCurr );

			MIC_Scarf.SetScalarParameterValue( 'Blend', MICValueCurr );
			MIC_Scarf.SetScalarParameterValue( 'Fade', MICValueCurr );

			MIC_HandForge.SetScalarParameterValue( 'Blend', MICValueCurr );
			MIC_HandForge.SetScalarParameterValue( 'Fade', MICValueCurr );

			if( MIC_Weapon != None )
			{
				MIC_Weapon.SetScalarParameterValue( 'Fade', MICValueCurr );
				MIC_Weapon.SetScalarParameterValue( 'Blend', MICValueCurr );
			}

		}

		// interp to our goal (e.g. we are runnnning and then stop immediately we need the "Run" param to go to zero)
		MICRunValueCurr = FInterpTo( MICRunValueCurr, 1.f, DeltaTime, 3 );
	
		MIC_Body.SetScalarParameterValue( 'Run', MICRunValueCurr );
		MIC_Head.SetScalarParameterValue( 'Run', MICRunValueCurr );
		MIC_Scarf.SetScalarParameterValue( 'Run', MICRunValueCurr );
		MIC_HandForge.SetScalarParameterValue( 'Run', MICRunValueCurr );
		if( MIC_Weapon != None )
		{
			MIC_Weapon.SetScalarParameterValue( 'Run', MICRunValueCurr );
		}
	}
}

/** Called on active skills to allow them to modify the damage.  (e.g. you are shot and are Ghosting) */
function ModifyDamage( const Pawn Victim, out int Damage, const Controller InstigatedBy, const vector HitLocation, const vector Momentum, const class<DamageType> DamageType, const optional TraceHitInfo HitInfo, const optional Actor DamageCauser)
{
	if( bActive )
	{
		// if we are Ghosting and are hit by Explosive Damage then we take more damage
		if( ClassIsChildOf(DamageType, class'NDT_Explosive') == TRUE )
		{
			Damage *= (GhostLevels[SkillLevel].PercentDamageTakenFromExplosives);
		}
		else
		{
			Damage *= (GhostLevels[SkillLevel].PercentDamageTaken);
			//`log( "ModifyDamage GHOST" );
		}
	}
}

simulated protected function PowerActivated()
{
	Super.PowerActivated();

	PawnOwner.DustGravityZScale = GhostLevels[SkillLevel].GravityScale;

	// Play anim when shifting into altered state
	PawnOwner.RunningTopHalfSlot.PlayCustomAnim('Dust_Sprint_Activate_Start', 1.0, 0.1, -1.0, FALSE, TRUE);
	PawnOwner.FallingFullBodySlot.PlayCustomAnim('NW_Dust_Sprint_Glide',1.0,0.5,-1.f,FALSE,TRUE);

	// ghosting reduces falling velocity
	if (PawnOwner.WorldInfo.TimeSeconds - LastActivationTime > 5.f && PawnOwner.Velocity.Z < 0)
	{
		PawnOwner.Velocity.Z = FMin(PawnOwner.Velocity.Z + GhostLevels[SkillLevel].FallingVelDampening,0);
	}

	// if standing on something that ignores dusted collision
	if (NanoVolume_Dust(PawnOwner.Base) != None)
	{
		// then clear the base so we fall through
		PawnOwner.SetBase(None);
	}

	LastActivationTime = PawnOwner.WorldInfo.TimeSeconds;

	// Update effects that are not needed on dedicated servers
	if( ShouldPlayClientEffects() )
	{
		DoGhostFansOn();
		NanoPC(PawnOwner.Controller).ClientSpawnCameraLensEffect( class'Emit_Camera_Ghost' );

		ActivePowerParticleSystems( PawnOwner );

		// swap to ghost materials
		// Step 1:   at  .18 sec switch to these materials
		PawnOwner.SetTimer( PawnOwner.TimeToInterpMaskMIC, FALSE, nameof(TimerSwitchToPowerActivatedMaterials), self );
	}
}

/** This should be overridden in the subclass to do any skill specific "deactivated" functionality **/
simulated protected function InternalDeactivated()
{
//	local NanoPC PC;
//	local Vector StickDir;
//	local Rotator CamRot;
//	local Vector CamLoc;

	// Clear the timer
	PawnOwner.ClearTimer(nameof(TimerSwitchToPowerActivatedMaterials), self);

	PawnOwner.RunningTopHalfSlot.PlayCustomAnim('Dense_Sprint_Activate_End', 1.0, 0.1, 0.1, FALSE, TRUE);
	PawnOwner.FallingFullBodySlot.StopCustomAnim(0.3f);

	if( ShouldPlayClientEffects() )
	{
		NanoPC(PawnOwner.Controller).ClientSpawnCameraLensEffect( class'Emit_Camera_Ghost' );
		DoGhostFansOff();

		DeactivePowerParticleSystems( PawnOwner );

		// Because of the delayed material swap, we have to make sure these have actually been created by the time we deactivate the power, otherwise we get spammed
		if( ( MIC_Body != None ) && ( MIC_Head != None ) && ( MIC_Scarf != None ) && ( MIC_HandForge != None ) )
		{
			MIC_Body.SetScalarParameterValue( 'Run', 0.0f );
			MIC_Head.SetScalarParameterValue( 'Run', 0.0f );
			MIC_Scarf.SetScalarParameterValue( 'Run', 0.0f );
			MIC_HandForge.SetScalarParameterValue( 'Run', 0.0f );
		}

		if( MIC_Weapon != None )
		{
			MIC_Weapon.SetScalarParameterValue( 'Run', 0.0f );
			MIC_Weapon = None;
		}

		MIC_Body = None;
		MIC_Head = None;
		MIC_Scarf = None;
		MIC_HandForge = None;
		RestoreDefaultMaterials( PawnOwner );
	}

	Super.InternalDeactivated();
}

simulated function ActivePowerParticleSystems( NanoPawn NP, optional float MaskGoal = 0.4f )
{
	if( NP.WorldInfo.MyEmitterPool != None )
	{
		PSC_HandEffectLeft = NP.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( HandEffect, NP.Mesh, 'LeftHand', TRUE );
		PSC_HandEffectRight = NP.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( HandEffect, NP.Mesh, 'RightHand', TRUE );
	}
	
	NP.MaskMICValueCurr = 2.7;
	NP.InterpMaskMIC(MaskGoal,0.25f);
}

simulated function DeactivePowerParticleSystems( NanoPawn NP )
{
	if( PSC_HandEffectLeft != None )
	{
		PSC_HandEffectLeft.DeactivateSystem();
	}
	if( PSC_HandEffectRight != None )
	{
		PSC_HandEffectRight.DeactivateSystem();
	}
}

simulated function TimerSwitchToPowerActivatedMaterials()
{
	SwitchToPowerActivatedMaterials( PawnOwner );
}

simulated function SwitchToPowerActivatedMaterials( NanoPawn NP, optional float MaskGoal = 1.f )
{
	Super.SwitchToPowerActivatedMaterials( NP, MaskGoal );

	if( ( NanoWeapon(NP.Weapon) != none ) && ( NanoWeapon(NP.Weapon).Mesh != none ) )
	{
		MIC_Weapon = new(self) class'MaterialInstanceConstant';
		MIC_Weapon.SetParent( NanoWeapon(NP.Weapon).MI_WeaponGhost );
		NanoWeapon(NP.Weapon).Mesh.SetMaterial( 0, MIC_Weapon );
	}

	// set our material specific values
	MICValueCurr = 0.0f;
	MICValueGoal = MaskGoal;
}

simulated function NanoPowerParticleBodyEffects_Off( NanoPawn NP )
{
	Super.NanoPowerParticleBodyEffects_Off( NP );
	NP.bFakeGhostEffects = FALSE;
}

simulated function RestoreDefaultMaterials( NanoPawn NP )
{
	Super.RestoreDefaultMaterials( NP );

	NP.InterpMaskMIC(NP.default.MaskMICValueGoal,1.5f);
}

simulated function DoGhostFansOn()
{
	DoGhostFans_Worker( 1.0f );
}

simulated function DoGhostFansOff()
{
	DoGhostFans_Worker( 0.0f );
}

simulated function DoGhostFans_Worker( float VertOffsetValue )
{
	local NanoFanBase PingAffectable;
	local float NanoPingDistance;

	NanoPingDistance = 10000.0f;

	// this has a race condition in that makes it so if you call this and then move out of distance you will not reset what you
	// changed
	// @todo:  have the "on" store things into a list and then off use that list
	foreach PawnOwner.CollidingActors( class'NanoFanBase', PingAffectable, NanoPingDistance, PawnOwner.Location, FALSE )
	{
		//PingAffectable.MIC_PlumeSwirlPinged.SetScalarParameterValue( 'VertOffset', VertOffsetValue );
		PingAffectable.PlumeBrightnessGoal = VertOffsetValue;
	}
}



defaultproperties
{
	bHideFromSkillUI=TRUE

	SkillType=NS_Ghost

	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)

	LastActivationTime=-5.f

	NanoPowerArchetype=NanoPowerSpawnedEffects'NanoPowerEffects.Ghost'

	//LeftHand socket and RightHand socket should have this effect attached, ramping Opacity from 0 to 1 in .2 secs when in Ghost state.
	// for now just activate deactivate in code
	HandEffect=ParticleSystem'Nano_Effects_Ghost.Effects.P_Nano_GhostHand'

	NanoPowerParticleBodyEffectLimb=ParticleSystem'Nano_Effects_Ghost.Effects.P_Nano_Effects_Limb'
	NanoPowerParticleBodyEffectHead=ParticleSystem'Nano_Effects_Ghost.Effects.P_Nano_Effects_Head'
	NanoPowerParticleBodyEffectBody=ParticleSystem'Nano_Effects_Ghost.Effects.P_Nano_Effects_Body'

	PowerActivateSound=SoundCue'Gameplay_Audio.Ghost.NewGhost_Standing_Cue' 
	PowerDeactivateSound=SoundCue'Gameplay_Audio.Ghost.NewGhost_End_Cue'
	NanoState=ENS_Dust

	MICValueCurr=1.0f
	MI_Body=MaterialInstanceConstant'Nano_Effects_Ghosting.Test_Player_Materials.M_LyricBody_Trans_INST'
	MI_Head=MaterialInstanceConstant'Nano_Effects_Ghosting.Test_Player_Materials.M_LyricHead_Trans_INST'
	MI_Scarf=MaterialInstanceConstant'Nano_Effects_Ghosting.Test_Player_Materials.M_LyricCloth_Trans_INST'
	MI_HandForge=MaterialInstanceConstant'Nano_Effects_Ghosting.Test_Player_Materials.M_LyricBody_Trans_INST'

	GameButton=GB_RightBumper
}
