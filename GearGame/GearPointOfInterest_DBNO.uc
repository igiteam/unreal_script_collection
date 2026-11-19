/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class GearPointOfInterest_DBNO extends GearPointOfInterest
	notplaceable;

/** Whether the controller should add/remove this POI */
simulated function bool ShouldControllerHavePOI(GearPC GearPCToTest)
{
	return ( GearPawn_Infantry(GearPCToTest.MyGearPawn) != None &&
		(GearPCToTest.MyGearPawn.SpecialMoveClasses[SM_ReviveTeammate] != None || GearPCToTest.MyGearPawn.SpecialMoveClasses[GSM_Kantus_ReviveScream] != None) &&
		WorldInfo.GRI.OnSameTeam(AttachedToActor, GearPCToTest.Pawn) && VSize(GearPCToTest.MyGearPawn.Location - Location) < 2500.0 );
}


defaultproperties
{
	RemoteRole=ROLE_None
	ActionIconType=AT_DownedTeammate

	ActionLookAt={(ActionName=DBNO,
				   ActionIconDatas=((ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))), // Y Button
								    (ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=175,V=269,UL=70,VL=42)))),
	)}
}
