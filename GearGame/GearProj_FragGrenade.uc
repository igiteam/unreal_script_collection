/**
 * Grenade_Frag
 * Frag Grenade projectile implementation
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_FragGrenade extends GearProj_Grenade
	config(Weapon);

/** Effect to play when grenade explodes in the air */
var() protected const GearExplosionContent InAirExplosionEmitterTemplate;
/** Effect to play when grenade explodes on a surface without a material-specific effect */
var() protected const GearExplosionContent DefaultOnGroundExplosionEmitterTemplate;
/** Effect to play when grenade explodes on a surface without a material-specific effect */
var() protected const GearExplosionContent DefaultTaggedEmitterTemplate;

/** Effect to play when grenade explodes when attached to player */
var() protected const GearExplosionContent StuckInPawnExplosionTemplate, StuckInPawnExplosionTemplateLambent;
var() protected const GearExplosionContent StuckInPawnExplosionNoGoreTemplate;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	Disable('Tick');
}


simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local GearSpawner_EmergenceHoleBase Hole;
	local vector Momentum;
	local Emit_SmokeGrenade Smoke;
	local GearExplosionActor GEA;

	if (!bIsSimulating && !bGrenadeHasExploded)
	{
		// @fixme, not sure why hitlocation is passed in for momentum, but that's how the old code was...
		// double check this to see if this a bug
		//Momentum = MomentumTransfer;
		Momentum = HitLocation + HitNormal * 3;

		if( Role == Role_Authority )
		{
			// blow up melee/held guys
			// this stops any exploits of some how getting the HurtOrigin inside a wall or object such that the line checks will fail to hurt the victim
			if( Pawn(TagVictim) != none )
			{
				TagVictim.TakeDamage( 9999.f, InstigatorController, HitLocation, Momentum, PawnTaggedDamageType,, self );
			}
			if ( MartyrVictim != None )
			{
				MartyrVictim.TakeDamage( 9999.f, InstigatorController, HitLocation, Momentum, MartyrDamageType,, self );
			}
		}

		// plus smoke!
		// @todo, if attached to a pawn, spawn the smoke at the pawns feet?
		Smoke = Spawn( SmokeEmitterClass,,, HitLocation + HitNormal*3, rotator(HitNormal) );
		if (Smoke != None)
		{
			Smoke.bTriggeredByMartyr = (MartyrVictim != None);
			Smoke.bTriggeredBySticky = (TagVictim != None && Pawn(TagVictim) == None);
			Smoke.InstigatorController = InstigatorController;
			Smoke.SetEmissionDuration(6.0f);
		}

		GEA = Super.TriggerExplosion(HitLocation, HitNormal, HitActor);

		if( Role == Role_Authority )
		{
			// check for e-hole near-misses to give player feedback
			// do this after the super call, so the damage has been applied
			foreach CollidingActors(class'GearSpawner_EmergenceHoleBase', Hole, ExploDamageRadius*2, HitLocation)
			{
				if (Hole.HoleStatus == HS_Open)
				{
					// didn't die in the hurtradius call, notify
					GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_EHoleGrenadeMissed, Instigator);
				}
			}
		}
	}

	return GEA;
}

//simulated function Bounce(Vector HitLocation, Vector HitNormal)
//{
//	Super.Bounce(HitLocation, HitNormal);
//
//}

function SetupAvoidanceCylinder()
{
	local float AvoidRadius;

	if( !bIsSimulating && !bGrenadeHasExploded && !bDeleteMe && AvoidanceCylinder == None )
	{
		AvoidRadius = GetAvoidanceRadius();
		AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);
		if(AvoidanceCylinder!=none)
		{
			AvoidanceCylinder.SetBase(self);
			AvoidanceCylinder.SetCylinderSize(AvoidRadius,AvoidRadius*2.0f);
			AvoidanceCylinder.SetDontAffectMesh(true);
			AvoidanceCylinder.SetEnabled(true);
		}
		//DrawDebugSphere(Location,AvoidRadius,16,255,0,0,TRUE);
	}

}


simulated protected function PrepareExplosionTemplate()
{
	DetermineWhichContentTemplateToUse();
	super.PrepareExplosionTemplate();
	// choose which effect to play
	DetermineWhichParticleSystemToPlay();
}


simulated function Protected DetermineWhichContentTemplateToUse()
{
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;
	local TraceHitInfo HitInfo;

	// if we are attached to a pawn we want to the the tagged explosion template
	if (Pawn(TagVictim) != None)
	{
		//`log( "using player TAGGED Emitter!" );
		if (WorldInfo.GRI.ShouldShowGore() && !TagVictim.IsA('Vehicle') && !TagVictim.IsA('GearPawn_SilverbackBase'))
		{
			if (GearPawn(TagVictim) != None && GearPawnFX_Lambent(GearPawn(TagVictim).GearPawnFX) != None)
			{
				ExplosionTemplate.ContentTemplate = StuckInPawnExplosionTemplateLambent;
			}
			else
			{
				ExplosionTemplate.ContentTemplate = StuckInPawnExplosionTemplate;
			}
		}
		else
		{
			ExplosionTemplate.ContentTemplate = StuckInPawnExplosionNoGoreTemplate;
		}
	}
	// attached to wall from wall tag
	else if (TagVictim != None)
	{
		ExplosionTemplate.ContentTemplate = DefaultTaggedEmitterTemplate;
	}
	// use the material based effect
	else
	{
		// we need to trace and see if the grenade is still doing small
		// bounces or if it is actually in the air
		TraceStart = Location;
		TraceDest = Location - vect(0, 0, 5);

		// trace down and see what we are standing on
		// once the material system is updated we will be able to get the material type and play
		// something off that!  TTP 13101
		Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, TRACEFLAG_PhysicsVolumes);

		// if there is no material then we can not do anything
		if (HitInfo.Material == None)
		{
			ExplosionTemplate.ContentTemplate = InAirExplosionEmitterTemplate;
		}
		else
		{
			// Default
			ExplosionTemplate.ContentTemplate = DefaultOnGroundExplosionEmitterTemplate;
		}
	}
}

simulated function protected DetermineWhichParticleSystemToPlay()
{
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;
	local TraceHitInfo HitInfo;
	local PhysicalMaterial ParentPhysMaterial;
	local ParticleSystem ImpactEffect;

    // if we are attached to a pawn we want to the the tagged explosion template
	if( TagVictim == None )
	{
		// we need to trace and see if the grenade is still doing small
		// bounces or if it is actually in the air
		TraceStart = Location;
		TraceDest = Location - vect(0, 0, 5);

		// trace down and see what we are standing on
		// once the material system is updated we will be able to get the material type and play
		// something off that!  TTP 13101
		Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, TRACEFLAG_PhysicsVolumes );

		// if there is no material then we can not do anything
		if( none == HitInfo.Material )
		{
			return;
		}

		// so here we need to look up the "hierarchy" if we have a none in the attribute we want
		ImpactEffect = GetImpactEffect( HitInfo.Material.PhysMaterial );
		//`log("GetImpactEffect returned"@ImpactEffect);

		if( none == HitInfo.Material.PhysMaterial )
		{
			ParentPhysMaterial = none;
		}
		else
		{
			ParentPhysMaterial = HitInfo.Material.PhysMaterial.Parent;
		}


		// this will walk the tree until our parent is null
		// at which point we will break out (which is basically an exception case)
		// but there are no exceptions in .uc land
		while( ( none == ImpactEffect )
			&& ( none != ParentPhysMaterial )
			)
		{
			// look at our parent's data
			ImpactEffect = GetImpactEffect( ParentPhysMaterial );
			ParentPhysMaterial = ParentPhysMaterial.Parent;
		}

		//`log( "use the material based effect" );
		if( ImpactEffect != None )
		{
			ExplosionTemplate.ParticleEmitterTemplate = ImpactEffect;
		}
	}
}


/**
* Looks to see if the Effect on the current PhysicalMaterial is valid.
**/
simulated function ParticleSystem GetImpactEffect( PhysicalMaterial PMaterial )
{
	local ParticleSystem Retval;

	Retval = None;

	if (PMaterial != None && GearPhysicalMaterialProperty(PMaterial.PhysicalMaterialProperty) != None)
	{
		Retval = GetWeaponSpecificImpactEffect(GearPhysicalMaterialProperty(PMaterial.PhysicalMaterialProperty));
	}

	return Retval;
}

/**
 * Force the particle system for regular explosion to be oriented with the X axis up
 *
 * @param GEA - the explosion actor that was spawned by the grenade
 */
simulated protected function PrepareExplosionActor(GearExplosionActor GEA)
{
	local rotator ExplosionParticleSystemRotation;

	Super.PrepareExplosionActor(GEA);

	if (ExplosionTemplate.ContentTemplate == DefaultOnGroundExplosionEmitterTemplate)
	{
		ExplosionParticleSystemRotation = GEA.ExplosionParticleSystemRotation;
		ExplosionParticleSystemRotation.Pitch = 16384;

		GEA.SetParticleSystemRotation(ExplosionParticleSystemRotation);
	}

	// If those are set, ignore traditional explosion damage for those, since we directly damage separately them in DoExplosion()
	if( Pawn(TagVictim) != None )
	{
		ExplosionTemplate.ActorToIgnoreForDamage = TagVictim;
	}
	if( MartyrVictim != None )
	{
		ExplosionTemplate.ActorToIgnoreForDamage = MartyrVictim;
	}
}

simulated function ParticleSystem GetWeaponSpecificImpactEffect(GearPhysicalMaterialProperty ImpactEffects);

simulated function name AttachInit(Actor Attachee)
{
	local GearPawn VictimGP;

	VictimGP = GearPawn(Attachee);
	if (VictimGP != None && !GearPawn(Instigator).IsDoingSpecialMove(SM_Kidnapper_GrenadeRelease))
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_StuckExplosiveToEnemy, Instigator, VictimGP, 1.f);
	}

	return super.AttachInit(Attachee);
}

defaultproperties
{
    bNetTemporary=false

	InFlightSoundTemplate=SoundCue'Weapon_Grenade.Firing.GrenadeInAirLoopCue'
	GrenadeAttachingToFoeSound=SoundCue'Weapon_Grenade.Actions.GrenadeStick01Cue'
	GrenadeAttachingToWorldSound=SoundCue'Weapon_Grenade.Actions.GrenadeStick01Cue'
	BeepBeepAboutToExplodeSound=SoundCue'Weapon_Grenade.Actions.GrenadeBeep01Cue'
	GrenadeBounceSound=SoundCue'Weapon_Grenade.Impacts.GrenadeBounceCue'


	Begin Object Class=SkeletalMeshComponent Name=COGGrenadeMesh0
		SkeletalMesh=SkeletalMesh'COG_Bolo_Grenade.Frag_Grenade'
		PhysicsAsset=PhysicsAsset'COG_Bolo_Grenade.Frag_Grenade_Physics'
		AnimTreeTemplate=AnimTree'COG_Bolo_Grenade.Animations.AT_BoloGrenade'
		AnimSets(0)=AnimSet'COG_Bolo_Grenade.GrenadeAnims'
		BlockActors=false
		bCastDynamicShadow=false
		BlockZeroExtent=true
		BlockNonZeroExtent=false
		CollideActors=true
		BlockRigidBody=true
		RBCollideWithChannels=(Default=true,Untitled2=true)
		Scale=1.5
		LightEnvironment=MyLightEnvironment
		bAcceptsDynamicDecals=false
    End Object
	Mesh=COGGrenadeMesh0
	Components.Add(COGGrenadeMesh0)

	Begin Object Name=CollisionCylinder
		CollideActors=true
	End Object

	TrailTemplate=ParticleSystem'COG_Frag_Grenade.Effects.SmokeTrail'

	InAirExplosionEmitterTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.FragGrenade.FragGrenade_Proj_Explo'
	DefaultOnGroundExplosionEmitterTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.FragGrenade.FragGrenade_Proj_Explo'
	DefaultTaggedEmitterTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.FragGrenade.FragGrenade_Wall_Tag_Explo'
	StuckInPawnExplosionTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.FragGrenade.FragGrenade_FragTAG_Player_Explo'
	StuckInPawnExplosionTemplateLambent=GearExplosionContent'GearExplosion_Arch.Weapon.TorqueBow.Arrow_In_Player_Lambent_Explo'
	StuckInPawnExplosionNoGoreTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.FragGrenade.FragGrenade_FragTAG_Player_Explo_NO_GORE'

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_FragGrenade'
		MomentumTransferScale=1.0	// Scale momentum defined in DamageType

		ContentTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.FragGrenade.FragGrenade_Proj_Explo'

		FractureMeshRadius=200.0
		FracturePartVel=500.0

		bAllowPerMaterialFX=true
		bUsePerMaterialFogVolume=true
	End Object
	ExplosionTemplate=ExploTemplate0

	GrenadeTagPreExplosionSmokeEffectPlanted=ParticleSystem'COG_Frag_Grenade.Effects.P_COG_Frag_Grenade_Tagged_Smoke'
}
