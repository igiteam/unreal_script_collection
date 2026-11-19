/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_Mine extends NanoPlan_ForgeRockets;




defaultproperties
{
	PlanName="Mine"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Mine",PlanDescription="Placed on the ground, any AI that walks near it will be cause it to explode",UIMesh=StaticMesh'Locust_PoisonGrenade.Meshes.Locust_PoisonGrenade_Pickup1_SM')
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintMines',Coords=(U=0,V=0,UL=256,VL=256))

	ProjClass=class'NanoMine'
}

