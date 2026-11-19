/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_ForgeRockets_Homing extends NanoPlan_ForgeRockets;


defaultproperties
{
	PlanName="Hand Rockets Homing"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Hand Rockets Homing",PlanDescription="Fires rockets which will home in foes",UIMesh=StaticMesh'MET_PacifierMechProto.SM.S_Proto_PacifierMech_Rocket')
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintMissilesHoming',Coords=(U=0,V=0,UL=256,VL=256))

	ProjClass=class'NanoProj_ForgedRocket_Homing'
}