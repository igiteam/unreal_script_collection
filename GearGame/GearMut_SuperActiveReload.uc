/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** makes active reload give a huge damage boost and make all the active reload bullets "free" shots (don't consume ammo) */
class GearMut_SuperActiveReload extends GearMutator
	dependson(GearEmitterPool);

var array<GearTracerEffect> OverrideTracerDataList;

auto state FirstTick
{
	simulated event Tick(float DeltaTime)
	{
		local GearEmitterPool Pool;
		local int i;

		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			// replace AR tracer entries with our bigger effects
			Pool = GearEmitterPool(WorldInfo.MyEmitterPool);
			for (i = 0; i < OverrideTracerDataList.length; i++)
			{
				if (OverrideTracerDataList[i].Mesh != None)
				{
					Pool.TracerDataList[i] = OverrideTracerDataList[i];
				}
			}
		}

		GotoState('');
	}
}

function bool CheckReplacement(Actor Other)
{
	local GearWeapon W;

	W = GearWeapon(Other);
	if (W != None)
	{
		W.bFreeARShots = true;
		W.AR_MagicBulletsTimeoutDuration = 0.0;
	}

	return true;
}

function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	local GearPawn GP;
	local GearProjectile Proj;

	Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);

	if (InstigatedBy != None && InstigatedBy.Pawn != Injured && DamageType != class'GDT_Melee')
	{
		GP = GearPawn(InstigatedBy.Pawn);
		Proj = GearProjectile(DamageCauser);
		if ( GP != None && (GP.bActiveReloadBonusActive || (Proj != None && Proj.bActiveReloadBonusActive)) &&
			(GP.GetTeamNum() == 0 || (WorldInfo.GRI.IsMultiplayerGame() && !WorldInfo.GRI.IsCoopMultiplayerGame())) )
		{
			Damage *= 8;
		}
	}
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=true
	NetUpdateFrequency=0.1

	OverrideTracerDataList[WTT_LongSkinnyAR]=GearTracerEffect'GearTracerEffects.LongSkinnyActiveReload_SuperMUT'
	OverrideTracerDataList[WTT_HammerburstAR]=GearTracerEffect'GearTracerEffects.HammerburstTracerActiveReload_SuperMUT'
}
