/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoRooftopAccessIndicator extends NanoTargetPoint;


defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'UI_HUD.MiniMap.RoofAccess'
	End Object


	Begin Object Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,Icon=Texture2D'UI_HUD.MiniMap.RoofAccess',IconScale=0.08f,IconColor=(R=255,G=255,B=255,A=64),IconScaleWithChaos=0.100f,IconColorWithChaos=(R=255,G=255,B=255,A=164))
		// IRIS! //InGameInfo_Icon=Texture2D'UI_HUD.MiniMap.RoofAccess'
	End Object
	UIComponent=UIIconComponent0
	Components.Add(UIIconComponent0)

}

