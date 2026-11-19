/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_Dense extends NanoSkill_NanoPowerBase
	native(Pawn)
	config(Pawn);

struct native DenseLevelDatum
{
	/** The percentage of damage you take from any damage given to you at this level of skill **/
	var config float PercentDamageTaken;

	/** the percentage of damage you take from an explosive damage when you are at this level of skill **/
	var config float PercentDamageTakenFromExplosives;
	
	/** Amount we divide our falling speed ratio by **/
	var config float DenseFallingDivider;

	/** Pawn AccelRate while densed */
	var config float DenseAccelRate;
};

var config array<DenseLevelDatum> DenseLevels;

var ParticleSysParam WipeParticleSysParam;

/** If we are playing an anim **/
var transient bool bPlayingHealBustableActorAnim;


var protected transient RadialBlurComponent ExplosionRadialBlur;


simulated function bool ShouldActivate()
{
	local Actor A;
	local Actor HitActor;
	local Vector HitLocation, HitNormal, TraceStart, TraceEnd, TraceExtent;
	local NSM_PerchOnPoint PerchSM;

	PerchSM = NSM_PerchOnPoint(PawnOwner.ActiveSpecialMove);
	if( PerchSM != None )
	{
		if( PerchSM.bDenseCharging && !PerchSM.bPawnLaunched )
		{
			return TRUE;
		}
		else if( PawnOwner.bWantsToDash )
		{
			return TRUE;
		}
	}
	else if( PawnOwner.bWantsToDash )
	{
		foreach PawnOwner.TouchingActors( class'Actor', A )
		{
			if( NanoBustableActor(A) != None )
			{
				return TRUE;
			}
		}

		TraceStart = PawnOwner.Location;
		TraceEnd = TraceStart + (Vector(PawnOwner.Rotation) * (256.f + PawnOwner.GetCollisionRadius()));
		TraceExtent = PawnOwner.GetCollisionExtent() * 0.95f;
		HitActor = PawnOwner.Trace( HitLocation, HitNormal, TraceEnd, TraceStart, TRUE, TraceExtent );
		if( NanoBustableActor(HitActor) != None )
		{
			return TRUE;
		}

		// check to see if we are hilding down the Y button and if we are then we are going to dense
		if( ( NanoPC(PawnOwner.Controller) != None ) && ( NanoPC(PawnOwner.Controller).IsButtonActive(GB_Y) == TRUE ) )
		{
			return TRUE;
		}
	}

	return FALSE;
}

simulated event Tick( float DeltaTime )
{
	local bool bWantsToDense;

	Super.Tick( DeltaTime );

	if( bActive && ShouldPlayClientEffects() )
	{
		UpdatePowerEffects( DeltaTime, PawnOwner );
	}

	bWantsToDense = ShouldActivate();
	if( !bActive && bWantsToDense )
	{
		ActivateSkill();
	}
	else if( bActive && !bWantsToDense )
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

			//`log( `showvar(MICValueCurr) @ `showvar(MICValueGoal) );

			MIC_Body.SetScalarParameterValue( 'Dense', MICValueCurr );
			MIC_Body.SetScalarParameterValue( 'Glow', MICValueCurr );

			MIC_Head.SetScalarParameterValue( 'Dense', MICValueCurr );
			MIC_Head.SetScalarParameterValue( 'Glow', MICValueCurr );

			MIC_Scarf.SetScalarParameterValue( 'Dense', MICValueCurr );
			MIC_Scarf.SetScalarParameterValue( 'Glow', MICValueCurr );

			MIC_HandForge.SetScalarParameterValue( 'Dense', MICValueCurr );
			MIC_HandForge.SetScalarParameterValue( 'Glow', MICValueCurr );

			if( MIC_Weapon != None )
			{
				MIC_Weapon.SetScalarParameterValue( 'Dense', MICValueCurr );
				MIC_Weapon.SetScalarParameterValue( 'Glow', MICValueCurr );
			}
		}
	}
}

/** Called on active skills to allow them to modify the damage.  (e.g. you are shot and are Ghosting) */
function ModifyDamage( const Pawn Victim, out int Damage, const Controller InstigatedBy, const vector HitLocation, const vector Momentum, const class<DamageType> DamageType, const optional TraceHitInfo HitInfo, const optional Actor DamageCauser)
{
	if( bActive == TRUE )
	{
		// if we are Ghosting and are hit by Explosive Damage then we take more damage
		if( ClassIsChildOf(DamageType, class'NDT_Explosive') == TRUE )
		{
			Damage *= (DenseLevels[SkillLevel].PercentDamageTakenFromExplosives);
		}
		else
		{
			Damage *= (DenseLevels[SkillLevel].PercentDamageTaken);
			//`log( "ModifyDamage DENSE" );
		}
	}
}


simulated function float GetDenseFallingDivider()
{
	return DenseLevels[SkillLevel].DenseFallingDivider;
}


simulated protected function InternalActivated()
{
	local NanoBustableActor FracActor;
	local float AnimTimeForStartSummoning;

	Super.InternalActivated();

	FracActor = FindClosestBustableActorWhichIsBusted();

	if( FracActor != none )
	{
		FracActor.bBusted = FALSE;
		FracActor.bHealing = TRUE;
		FracActor.ClientHealingStateChanged();
		// play absorbing anim
		AnimTimeForStartSummoning = PawnOwner.PreAimFullBodySlot.PlayCustomAnim('NW_Summon_Generic_Start', 1.0f, 0.05f, 0.1f, FALSE, TRUE);
		PawnOwner.PreAimFullBodySlot.PlayCustomAnim('NW_Summon_Generic_Loop', 1.0f, AnimTimeForStartSummoning, 0.1f, TRUE, TRUE);
		bPlayingHealBustableActorAnim = TRUE;
	}
	else
	{
		PawnOwner.RunningTopHalfSlot.PlayCustomAnim('Dense_Sprint_Activate_Start', 1.0, 0.1, -1.0, FALSE, TRUE);
	}

	if( ShouldPlayClientEffects() )
	{
		SwitchToPowerActivatedMaterials( PawnOwner );

		if( NanoPowerArchetype.bUseRadialBlur == TRUE )
		{
			if( ExplosionRadialBlur == None )
			{
				ExplosionRadialBlur = new(self) class'RadialBlurComponent' (NanoPowerArchetype.RadialBlurCompTemplate);
				PawnOwner.Mesh.AttachComponentToSocket( ExplosionRadialBlur, NanoPowerArchetype.SocketToAttachBlurToo );
			}

			ExplosionRadialBlur.SetBlurScale( 1.0f );
		}

		NanoPawn_RebelsBase(PawnOwner).DenseMeshBlendGoal = 1.0f;
		NanoPawn_RebelsBase(PawnOwner).DenseMesh.SetHidden( FALSE );
	}

	PawnOwner.AccelRate = DenseLevels[SkillLevel].DenseAccelRate;
}

simulated event DeactivateSkill()
{
	// Only deactivate the skill if we're not in the middle of dropping the hammer
	if( !PawnOwner.IsDroppingTheHammer() )
	{
		Super.DeactivateSkill();
	}
}

simulated protected function InternalDeactivated()
{
	scripttrace();
	if( bPlayingHealBustableActorAnim == TRUE )
	{
		PawnOwner.PreAimFullBodySlot.StopCustomAnim( 0.1f );
	}
	else
	{
		PawnOwner.RunningTopHalfSlot.PlayCustomAnim('Dense_Sprint_Activate_End', 1.0, 0.1, 0.1, FALSE, TRUE);
	}

	if( ShouldPlayClientEffects() )
	{
		MIC_Body = None;
		MIC_Head = None;
		MIC_Scarf = None;
		MIC_Weapon = None;
		MIC_HandForge = None;

		RestoreDefaultMaterials( PawnOwner );

		MICValueCurr = 1.0f;

		if( ExplosionRadialBlur != none )
		{
			ExplosionRadialBlur.SetBlurScale(0.0f);
			PawnOwner.Mesh.DetachComponent( ExplosionRadialBlur );
			ExplosionRadialBlur = None;
		}

		NanoPawn_RebelsBase(PawnOwner).DenseMeshBlendGoal = 0.0f;
		//NanoPawn_Rebels_Lyrik(PawnOwner).DenseMesh.SetHidden( TRUE );
	}


	PawnOwner.AccelRate = PawnOwner.default.AccelRate;
	
	Super.InternalDeactivated();
}




simulated protected function NanoBustableActor FindClosestBustableActorWhichIsBusted()
{
	local NanoBustableActor FracActor;

	// check around us to see if there is a bustable actor that we can repair
	foreach PawnOwner.CollidingActors( class'NanoBustableActor', FracActor, 1024, PawnOwner.Location, TRUE )
	{
		if( ( FracActor.bBusted == TRUE ) 
			&& ( PawnOwner.Controller.IsAimingAt( FracActor, 0.90f ) )
			)
		{
			return FracActor;
		}
	}

	return none;
}


/** This will deactivate all the body effects for this power **/
simulated function NanoPowerParticleBodyEffects_Off( NanoPawn NP )
{
	Super.NanoPowerParticleBodyEffects_Off( NP );
	NP.bFakeDenseEffects = FALSE;

	SendWipeEventToNanoPowerParticleBodyEffects();
}

native function SendWipeEventToNanoPowerParticleBodyEffects();

simulated function SwitchToPowerActivatedMaterials( NanoPawn NP, optional float MaskGoal = 1.f )
{
	Super.SwitchToPowerActivatedMaterials( NP, MaskGoal );

	//`log( "ahhhhhhhh SwitchToPowerActivatedMaterialsSwitchToPowerActivatedMaterials" );

	if( ( NanoWeapon(NP.Weapon) != none ) && ( NanoWeapon(NP.Weapon).Mesh != none ) )
	{
		MIC_Weapon = new(self) class'MaterialInstanceConstant';
		MIC_Weapon.SetParent( NanoWeapon(NP.Weapon).MI_WeaponDense );
		NanoWeapon(NP.Weapon).Mesh.SetMaterial( 0, MIC_Weapon );
	}

	//`log( "SwitchToPowerActivatedMaterialsSwitchToPowerActivatedMaterialsSwitchToPowerActivatedMaterials" );

	// set our material specific values
	MICValueCurr = 1.0f;
	MICValueGoal = 0.0f;
}




defaultproperties
{
	bHideFromSkillUI=TRUE

	SkillType=NS_Dense


	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)

	NanoPowerArchetype=NanoPowerSpawnedEffects'NanoPowerEffects.Dense'

	NanoPowerParticleBodyEffectLimb=none//ParticleSystem'Nano_Effects_Test.Effects.P_Nano_Bits'  // this needs some better deactivate it seems
	NanoPowerParticleBodyEffectHead=none//ParticleSystem'Nano_Effects_Test.Effects.P_Nano_Bits'  // this needs some better deactivate it seems

	MICValueCurr=1.0f
	MI_Body=MaterialInstanceConstant'REB_Lyrik.M_Base_INST'
	MI_Head=MaterialInstanceConstant'REB_Lyrik.M_Base_Head_INST'
	MI_Scarf=MaterialInstanceConstant'REB_Lyrik.M_Base_Head_INST'
	MI_HandForge=MaterialInstanceConstant'REB_Lyrik.M_Base_INST'

	PowerActivateSound=SoundCue'Gameplay_Audio.Densify.NewDense_Activate_01_Cue'
	PowerDeactivateSound=SoundCue'Gameplay_Audio.Densify.NewDense_End_01_Cue'
	

	NanoState=ENS_Dense

	WipeParticleSysParam=(Name="Wipe",ParamType=PSPT_Scalar)

	GameButton=GB_LeftBumper
}
