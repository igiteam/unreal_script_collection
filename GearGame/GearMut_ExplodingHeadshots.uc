/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_ExplodingHeadshots extends GearMutator
	config(Game);

var GearExplosion ExplosionTemplate;

/** amount of time headshot enemies run around headless before dying */
var config float HeadlessTime;

function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	local GearPawn GP;
	local GearExplosionActorReplicated ExplosionActor;
	local GearAI AI;

	if (Injured.GetTeamNum() == 1)
	{
		GP = GearPawn(Injured);
		if (GP != None && GP.bLastHitWasHeadShot && GP.bCanPlayHeadShotDeath && !GP.bHasPlayedHeadShotDeath)
		{
			// count as damage credit even though it will be negated to make the enemy continue on headless
			if (InstigatedBy != None && InstigatedBy.PlayerReplicationInfo != GP.PlayerReplicationInfo)
			{
				GearPRI(GP.PlayerReplicationInfo).AddPlayerDamage(GearPRI(InstigatedBy.PlayerReplicationInfo), GP.Health, class<GearDamageType>(DamageType));
			}

			// play headshot effects
			GP.bCanDBNO = false;
			GP.bForceHeadShotGib = true;
			GP.PlayHeadShotDeath();
			GP.SetTimer(HeadlessTime, false, nameof(GP.Suicide));

			// make AI charge
			AI = GearAI(GP.Controller);
			if (AI != None)
			{
				AI.BanzaiAttack();
			}

			// needs to be after the banzai call so the command doesn't blow away the AI's wait command for the cringe
			GP.Cringe();

			Damage = 0;

			// set god mode for explosion so that the pawn whose head is exploding survives
			if (GP.Controller != None)
			{
				GP.Controller.bGodMode = true;
			}
			// spawn the explosion
			ExplosionTemplate.InitFromContentTemplate();
			ExplosionTemplate.MyDamageType = DamageType;
			ExplosionActor = Spawn(class'GearExplosionActorReplicated',,, HitLocation, rotator(Momentum));
			ExplosionActor.Instigator = InstigatedBy.Pawn;
			ExplosionActor.InstigatorController = InstigatedBy;
			ExplosionActor.Explode(ExplosionTemplate);
			// reset god mode
			if (GP.Controller != None)
			{
				GP.Controller.bGodMode = false;
			}
		}
	}

	Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

defaultproperties
{
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MomentumTransferScale=1.f	// Scale momentum defined in DamageType
		FractureMeshRadius=100.0
		FracturePartVel=300.0
		Damage=2000
		DamageRadius=1000
		DamageFalloffExponent=1.0
		ContentTemplate=GearExplosionContent'GearExplosion_Arch.Mutator.ExplodingHeadshots.GearMut_ExplodingHeadshots_Explo'
	End Object
	ExplosionTemplate=ExploTemplate0
}
