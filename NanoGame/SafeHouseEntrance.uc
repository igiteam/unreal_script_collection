/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SafeHouseEntrance extends NanoTargetPoint;

/** Whether or not this safe house is unlocked **/
var() bool bUnlocked;


simulated function OnModifySafeHouse( SeqAct_ModifySafeHouse InAction )
{
	//`log( `showvar(InAction.bUnlocked) );
	bUnlocked = InAction.bUnlocked;
}

defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'UI_HUD.MiniMap.SafeHouse'
	End Object

	Begin Object Name=UIIconComponent0
		MiniMap=(bShown=TRUE,Icon=Texture2D'UI_HUD.MiniMap.SafeHouse',IconScale=0.125f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=TRUE,AboveBelowIconScale=0.100f)
	End Object

	bUnlocked=TRUE
}