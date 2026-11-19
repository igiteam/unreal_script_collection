
/**
 * GearPawn_LocustBabyCorpserBase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustBabyCorpserBase extends GearPawn_LocustCreatureBase
	native(Pawn)
	config(Pawn)
	abstract;


/* Material used to control the material params for emerging */
var transient MaterialInstanceConstant EmergeMaterial;

/** Time we started emerging */
var transient float TimeOfEmerge;

/** Constrain where we can melee */
var config float MeleeArc;

/** Trigger melee damage and effect */
simulated function DoMeleeImpact()
{
	local GearWeap_BabyCorpserMelee Wpn;
	local Actor Target;

	if (MyGearAI != None)
	{
		Target = MyGearAI.FireTarget;
	}
	else
	{
		foreach VisibleCollidingActors(class'Actor', Target, 24.0, Location + vector(Rotation) * 64.0,,, true)
		{
			if (!Target.bWorldGeometry)
			{
				break;
			}
		}
	}

	if (IsDoingSpecialMove(GSM_CorpserLarva_Melee))
	{
		Wpn = GearWeap_BabyCorpserMelee(Weapon);
		if (Wpn != None && Target != None && NoZDot(Normal(Target.Location - Location), vector(Rotation)) > MeleeArc)
		{
			Wpn.DoMeleeDamage(Target, Target.Location, 1.0);
		}
	}
}

event PostAIFactorySpawned(SeqAct_AIFactory SpawningFactory, INT SpawnSetIdx)
{
	Super.PostAIFactorySpawned(SpawningFactory,SpawnSetIdx);
	// make sure we have a melee weapon
	AddDefaultInventory();
}

/** Initialize the material parameters */
simulated function InitEmergeMaterials()
{
	if (EmergeMaterial == None)
	{
		EmergeMaterial = new(Outer) class'MaterialInstanceConstant';
		EmergeMaterial.SetParent(Mesh.GetMaterial(0));
		Mesh.SetMaterial(0, EmergeMaterial);
		EmergeMaterial.SetScalarParameterValue('Blood', 1.0f);
		EmergeMaterial.SetScalarParameterValue('Glow_Ramp', 0.5f);
	}

	TimeOfEmerge = WorldInfo.TimeSeconds;
}

/** Overloaded to handle the material params */
simulated function Tick(float DeltaTime)
{
	local float TimeSinceEmgerge;
	local float ParamValue;

	if (TimeOfEmerge > 0)
	{
		TimeSinceEmgerge = WorldInfo.TimeSeconds - TimeOfEmerge;
		if (TimeSinceEmgerge < 7.0f)
		{
			if (EmergeMaterial != None)
			{
				if (TimeSinceEmgerge >= 1.9f && TimeSinceEmgerge <= 6.0f)
				{
					ParamValue = 1.0f - (TimeSinceEmgerge - 1.9f)/4.1f;
					ParamValue = FClamp(ParamValue, 0.0f, 1.0f);
					EmergeMaterial.SetScalarParameterValue('Blood', 0.4f + ParamValue * 0.6f);
				}

				if (TimeSinceEmgerge >= 1.5f && TimeSinceEmgerge <= 3.0f)
				{
					ParamValue = 1.0f - (TimeSinceEmgerge - 1.5f)/1.5f;
					ParamValue = FClamp(ParamValue, 0.0f, 1.0f);
					EmergeMaterial.SetScalarParameterValue('Glow_Ramp', 0.05f + ParamValue * 0.45f);
				}
			}
		}
		else
		{
			TimeOfEmerge = 0.0f;
		}
	}

	Super.Tick(DeltaTime);
}

/** Overidden so the creature doesn't take damage as it's emerging from the egg */
function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	Super.AdjustPawnDamage(Damage, InstigatedBy, HitLocation, Momentum, GearDamageType, DamageCauser, HitInfo);

	if (IsDoingSpecialMove(SM_Emerge_Type1) || IsDoingSpecialMove(SM_Emerge_Type2))
	{
		Damage = 0;
	}
}

/** Overridden to use simple death effect when hit by Rat Truck */
simulated function bool ShouldUseSimpleEffectDeath(class<GearDamageType> GearDamageType)
{
	if( GearDamageType == class'GDT_HitByRatTruck' || GearDamageType == class'GDT_HeavyCoopMG_Convoy' )
	{
		return true;
	}
	return Super.ShouldUseSimpleEffectDeath(GearDamageType);
}

defaultproperties
{
	ControllerClass=class'GearAI_BabyCorpser'

	DefaultInventory.Empty()
	DefaultInventory(0)=class'GearGame.GearWeap_BabyCorpserMelee'

	bAllowInventoryDrops=false
// 	bShouldChainsawAttackInstantKillMe=false

	SpecialMoveClasses.Empty
	SpecialMoveClasses(SM_Emerge_Type1)=class'GSM_BabyCorpser_Emerge1'
	SpecialMoveClasses(SM_Emerge_Type2)=class'GSM_BabyCorpser_Emerge2'
	SpecialMoveClasses(GSM_CorpserLarva_Melee)=class'GSM_BabyCorpser_Melee'
	SpecialMoveClasses(SM_ChainsawVictim)=class'GSM_CorpserLarva_ChainsawVictim'

	NoticedGUDSEvent=GUDEvent_NoticedMiniCorpser

	SimpleDeathEffectScale=4.0
}
