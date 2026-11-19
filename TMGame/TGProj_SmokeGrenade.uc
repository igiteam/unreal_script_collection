/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class TGProj_SmokeGrenade extends TGProj_Grenade;

/** Effect to play on the grenade after grenade tagging someone but before it blows up. */
var() const protected ParticleSystem		GrenadeTagPreExplosionSmokeEffect;
var() const protected ParticleSystem        GrenadeTagPreExplosionSmokeEffectPlanted;
/** Ref to the spawned pre-explosion grenade tag emitter. */
var protected transient SpawnedTGEmitter	GrenadeTagPreExplosionSmokeEmitter;

/** How long to emit smoke. */
var() protected const config float 			CloudDuration;

simulated function TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local Emit_SmokeGrenade Smoke;

	if (!bIsSimulating && !bGrenadeHasExploded)
	{
		// regular explosion
		Super.TriggerExplosion(HitLocation, HitNormal, HitActor);

		// plus smoke!
		// @todo, if attached to a pawn, spawn the smoke at the pawns feet?
		Smoke = Spawn( SmokeEmitterClass,,, HitLocation + HitNormal*3, rotator(HitNormal) );
		if (Smoke != None)
		{
			Smoke.bTriggeredByMartyr = (HoldVictim != None);
			Smoke.bTriggeredBySticky = (MeleeVictim != None && Pawn(MeleeVictim) == None);
			if ( MeleeVictim != None && Pawn(MeleeVictim) != None )
			{
				Smoke.IgnoringDamagePawn = Pawn(MeleeVictim);
			}
			Smoke.InstigatorController = InstigatorController;
			Smoke.SetEmissionDuration(CloudDuration);
		}
	}
}

simulated function name AttachInit(Actor Attachee)
{
	local Pawn TaggedPawn;
	local name BoneName;

	BoneName = super.AttachInit(Attachee);

    GrenadeTagPreExplosionSmokeEmitter = Spawn(class'SpawnedTGEmitter',,, Mesh.GetPosition());
    if (GrenadeTagPreExplosionSmokeEmitter != None)
    {
    	TaggedPawn = Pawn(Attachee);
    	if (TaggedPawn != None)
    	{
    		// attach a special particle system to the mesh
	    GrenadeTagPreExplosionSmokeEmitter.SetTemplate(GrenadeTagPreExplosionSmokeEffect, true);
	    GrenadeTagPreExplosionSmokeEmitter.SetBase(TaggedPawn,, TaggedPawn.Mesh, BoneName);
    	}
	else if (GrenadeTagPreExplosionSmokeEffectPlanted != None)
	{
	    GrenadeTagPreExplosionSmokeEmitter.SetLocation(Mesh.GetPosition() + vect(0,0,12));
	    GrenadeTagPreExplosionSmokeEmitter.SetTemplate(GrenadeTagPreExplosionSmokeEffectPlanted, true);
	    GrenadeTagPreExplosionSmokeEmitter.SetBase(Attachee);
	}
    }
	return BoneName;
}

simulated function Destroyed()
{
	super.Destroyed();

	// destroy the pre-explosion tag emitter as well, if playing
	if (GrenadeTagPreExplosionSmokeEmitter != None)
	{
		// will destroy itself when it's done
		GrenadeTagPreExplosionSmokeEmitter.ParticleSystemComponent.DeactivateSystem();
		GrenadeTagPreExplosionSmokeEmitter = None;
	}
}

static function float GetAIEffectiveRadius()
{
	return default.KnockdownRadius;
}

/**
 * @STATS
 * Records a grenade tag or mine planting
 *
 * @Param Attachee - The pawn that the grenade is attached to
 */

function RecordTagStat(actor Attachee)
{
	local TGPawn GP;
	GP = TGPawn(Attachee);
	if (GP != none)
	{
		TGPRI(GP.PlayerReplicationInfo).NoTimesGrenadeTagged++;
		TGPRI(Instigator.PlayerReplicationInfo).NoGrenadeTags++;
	}
	else
	{
		TGPRI(Instigator.PlayerReplicationInfo).NoGrenadeMines++;
	}
}

/**
 * @STATS
 * Records the # of times someone triggers a mine
 *
 * @Param TrippedBy - The pawn that tripped the mine
 */
function RecordMineStat(actor TrippedBy)
{
	local TGPawn GP;
	GP = TGPawn(TrippedBy);
	if (GP != none)
	{
		TGPRI(GP.PlayerReplicationInfo).NoGrenadeMinesTriggeredByMe++;
		TGPRI(Instigator.PlayerReplicationInfo).NoGrenadeMinesTriggered++;
	}

}


