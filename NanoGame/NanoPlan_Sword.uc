/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_Sword extends NanoPlan_WeaponBase;

defaultproperties
{
	PlanName="Sword"
	WeaponClass=class'NanoWeap_Sword'
	PlanSlot=EPS_Melee

	ForgeUIData=(PlanName="Sword",PlanDescription="Sharp melee weapon that attacks extremely fast",UIMesh=StaticMesh'REB_Sword.SM_REB_Sword',Scale=0.25f,MeshRotation=(Pitch=16384,Roll=0,Yaw=0)))
	PlanIcon=(IconTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_WeaponIcons',Coords=(U=64,V=0,UL=64,VL=64))	
}