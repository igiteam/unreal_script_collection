/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_MP7 extends NanoPlan_WeaponBase;

defaultproperties
{
	PlanName="MP7"
	WeaponClass=class'NanoWeap_MP7'
	PlanSlot=EPS_Gun

	ForgeUIData=(PlanName="MP7",PlanDescription="Lightweight with a high rate of fire",UIMesh=StaticMesh'REB_SMGv2.Meshes.SM_REB_SMGv2_LOD1')
	PlanIcon=(IconTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_WeaponIcons',Coords=(U=0,V=0,UL=64,VL=64))
}