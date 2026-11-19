/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_Pistol extends NanoPlan_WeaponBase;

defaultproperties
{
	PlanName="Pistol"
	WeaponClass=class'NanoWeap_Pistol'
	PlanSlot=EPS_Gun

	ForgeUIData=(PlanName="Pistol",PlanDescription="",UIMesh=StaticMesh'Weapon_Proto.Meshes.SM_WeaponProto_Colt45')
	PlanIcon=(IconTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_WeaponIcons',Coords=(U=0,V=0,UL=64,VL=64))
}