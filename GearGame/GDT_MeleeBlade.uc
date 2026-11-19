/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_MeleeBlade extends GDT_Melee;

/**
 * Called on all clients when a pawn has taken damage, used to kick off damage type specific FX.
 * Overloaded to allow GearPC to know if it has inflicted melee damage to an enemy
 */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPC GPC;

	Super.HandleDamageFX(DamagedPawn, HitInfo);

	GPC = DamagedPawn.GetPC();
	if (GPC != None && LocalPlayer(GPC.Player) != None)
	{
		GPC.ClientSpawnCameraLensEffect(DamagedPawn.ShotgunCameraLensEffectTemplate);
	}
	GPC = GearPC(HitInfo.InstigatedBy.Controller);
	if (GPC != None && LocalPlayer(GPC.Player) != None)
	{
		GPC.ClientSpawnCameraLensEffect(DamagedPawn.ShotgunCameraLensEffectTemplate);
	}
}


defaultproperties
{
}
