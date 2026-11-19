/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_Suitcase extends NanoPlan_WeaponBase;

defaultproperties
{
	PlanName="Suitcase"
	WeaponClass=class'NanoWeap_Suitcase'
	PlanSlot=EPS_Gun

	ForgeUIData=(PlanName="Suitcase of Doom",PlanDescription="Holds a mini gun which will deploy for a massive burst of fire",UIMesh=StaticMesh'HU_Deco6.SM.Mesh.S_HU_Deco_Sm_Boxes')
	PlanIcon=(IconTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_WeaponIcons',Coords=(U=0,V=0,UL=64,VL=64))
}


