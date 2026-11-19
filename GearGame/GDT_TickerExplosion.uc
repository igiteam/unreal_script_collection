/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GDT_TickerExplosion extends GDT_Explosive
	config(Weapon);


/** Overridden to add a blood effect to the victim's camera */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPC PC;
	Super.HandleDamageFX(DamagedPawn,HitInfo);
	PC = DamagedPawn.GetPC();
	if (PC != None && PC.IsLocalPlayerController() && DamagedPawn.WorldInfo.GRI.ShouldShowGore() && HitInfo.InstigatedBy != None && VSize(HitInfo.InstigatedBy.Location - DamagedPawn.Location) <= 256.f)
	{
		PC.ClientSpawnCameraLensEffect( class'Emit_CameraBlood_ShotGun' );
	}
}

static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	local GearPawn_LocustTickerBase Ticker;
	local GearSquad DamagerSquad;
	local GearPC GPC;
	local GearAI GAI;

	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);

	if (DamageCauser != None)
	{
		Ticker = GearPawn_LocustTickerBase(DamageCauser.Owner);
		if ( Ticker != None && Ticker.bExplosionInvoluntary && Ticker.LastDamageInstigator != None && Victim.IsHumanControlled() &&
			Victim.Controller != Ticker.LastDamageInstigator )
		{
			GAI = GearAI(Ticker.LastDamageInstigator);
			if (GAI != None)
			{
				DamagerSquad = GAI.Squad;
			}
			else
			{
				GPC = GearPC(Ticker.LastDamageInstigator);
				if (GPC != None)
				{
					DamagerSquad = GPC.Squad;
				}
			}

			// if the dude that blew me up is in the same squad as the player taking damage, drop the damage by 50%
			if (DamagerSquad != None && GearPC(Victim.Controller).Squad == DamagerSquad)
			{
				Damage *= Ticker.DamageMultiplierToSquadMatesOfExploder;
			}
		}
	}
}

defaultproperties
{
	bEnvironmentalDamage=FALSE
}
