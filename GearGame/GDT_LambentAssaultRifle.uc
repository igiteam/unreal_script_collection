/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_LambentAssaultRifle extends GDT_Ballistic;

/** Overridden to add a blood effect to the victim's camera */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPC PC;

	Super.HandleDamageFX(DamagedPawn, HitInfo);

	if ( DamagedPawn.WorldInfo.GRI.ShouldShowGore() && HitInfo.InstigatedBy != None 
		&& !DamagedPawn.IsA('Vehicle') && !DamagedPawn.IsA('GearPawn_SilverbackBase'))
	{
		PC = DamagedPawn.GetPC();
		if (PC != None && LocalPlayer(PC.Player) != None)
		{
			PC.ClientSpawnCameraLensEffect(class'Emit_BulletImpact_Drudge');
		}
		PC = GearPC(HitInfo.InstigatedBy.Controller);
		if (PC != None && LocalPlayer(PC.Player) != None)
		{
			PC.ClientSpawnCameraLensEffect(class'Emit_BulletImpact_Drudge');
		}
	}
}

defaultproperties
{
	ImpactTypeBallisticID=ITB_LambentHammerburst
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=78,V=60,UL=77,VL=29)
	WeaponID=WC_LambentHammerburst
}
