/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_Staff extends NanoPlan_WeaponBase;

defaultproperties
{
	PlanName="Staff"
	WeaponClass=class'NanoWeap_Staff'
	PlanSlot=EPS_Melee

	ForgeUIData=(PlanName="Staff",PlanDescription="Blunt melee weapon with large area of attack",UIMesh=StaticMesh'NYC_Midtown.Mesh.SM_ShockStickMid')
	PlanIcon=(IconTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_WeaponIcons',Coords=(U=64,V=0,UL=64,VL=64))	
}