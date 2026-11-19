/**
 * Damage type for the Vulcan coop machine gun in Convoy
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_HeavyCoopMG_Convoy extends GDT_HeavyCoopMG;

/** Overridden to add a blood effect to the killer's camera */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPC PC;

	Super.HandleDamageFX(DamagedPawn, HitInfo);

	if ( DamagedPawn.WorldInfo.GRI.ShouldShowGore() && HitInfo.InstigatedBy != None && HitInfo.Damage >= 30 &&
		DamagedPawn.Health <= 0 &&
		DamagedPawn.ShotgunCameraLensEffectTemplate != None &&
		VSizeSq(HitInfo.InstigatedBy.Location - DamagedPawn.Location) <= default.MaxGibDistance*default.MaxGibDistance )
	{
		PC = GearPC(HitInfo.InstigatedBy.Controller);
		if (PC != None && LocalPlayer(PC.Player) != None)
		{
			PC.ClientSpawnCameraLensEffect(DamagedPawn.ShotgunCameraLensEffectTemplate);
		}
	}
}

/** Gib baby corpsers */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
 	if( GearPawn_LocustBabyCorpserBase(TestPawn) != None )
 	{
 		return true;
 	}

	return Super.ShouldGib(TestPawn, Instigator);
}

defaultproperties
{
	
}
