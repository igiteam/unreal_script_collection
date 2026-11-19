/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_Orbitals extends NanoPlan_WeaponBase;

defaultproperties
{
	PlanName="Orbitals"
	WeaponClass=class'NanoWeap_Orbitals'
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Orbitals",PlanDescription="Shoots orbitals our from handforge that will crawl up enemies and explode",UIMesh=StaticMesh'Nano_Effects_OrbitalSpheres.Mesh.S_Nano_Effects_Proto_OrbitalSphere02',Scale=10.0f)
	PlanIcon=(IconTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_WeaponIcons',Coords=(U=0,V=64,UL=64,VL=64))	
}