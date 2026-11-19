/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Melee extends GearDamageType;

/**
 * Called on all clients when a pawn has taken damage, used to kick off damage type specific FX.
 * Overloaded to allow GearPC to know if it has inflicted melee damage to an enemy
 */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPawn GP;
	local GearPC GPC;

	Super.HandleDamageFX(DamagedPawn, HitInfo);

	GP = GearPawn(HitInfo.InstigatedBy);
	if (GP != None)
	{
		GPC = GearPC(GP.Controller);
		// Trigger the melee delegates in the GearPC
		if (GPC != None)
		{
			GPC.TriggerGearEventDelegates(eGED_Melee);
		}
	}
}


defaultproperties
{
	KDamageImpulse=100

	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=69,V=349,UL=77,VL=29)
	KillGUDEvent=GUDEvent_KilledEnemyMelee
}
