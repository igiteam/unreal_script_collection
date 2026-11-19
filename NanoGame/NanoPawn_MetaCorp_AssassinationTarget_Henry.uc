/**
 * AssassinationTarget
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_AssassinationTarget_Henry extends NanoPawn_MetaCorp_AssassinationTarget
	config(Pawn);





defaultproperties
{
	ControllerClass=class'NanoAI_AssassinationTarget_Henry'

	Begin Object Name=NanoPawnMesh
		Materials(0)=MaterialInstanceConstant'MET_Executive.Materials.MET_Executive_Body_01_INST'
	End Object

	Begin Object Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,bShownEvenIfClamped=FALSE,DistancesToDrawIcon=(X=0,Y=0),Icon=Texture2D'UI_HUD.Minimap.EnemyBoss',IconScale=0.15f,IconColor=(R=255,G=64,B=64,A=255),bAlternateAboveBelowIcon=TRUE,AboveBelowIconScale=0.05f,TextName="",TextDescription="",TextVerticalOffset=0.0f,bShowEvenIfNoChaos=TRUE)
	End Object
	UIComponent=UIIconComponent0


	NanoAIAction_RunAway_RunToDesignatedFleeSpot


}
