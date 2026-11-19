/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AISetSightRadius extends SequenceAction;

/** New max sight radius for COG. If -1, uses normal default settings */
var() float				SightRadius_COG;
/** New max hearing radius for COG. If -1, uses normal default settings */
var() float				HearingRadius_COG;
/** New max sight radius for Locust. If -1, uses normal default settings */
var() float				SightRadius_Locust;
/** New max hearing radius for Locust. If -1, uses normal default settings */
var() float				HearingRadius_Locust;

event Activated()
{
	local GearGame Game;

	Game = GearGame(GetWorldInfo().Game);
	if( Game != None )
	{
		Game.MaxSightRadius_COG = SightRadius_COG;
		Game.MaxSightRadius_Locust = SightRadius_Locust;

		Game.MaxHearingRadius_COG = HearingRadius_COG;
		Game.MaxHearingRadius_Locust = HearingRadius_Locust;
	}

	Super.Activated();
}

defaultproperties
{
    ObjName="AI: Set Awareness Radius"
    ObjCategory="AI"

	SightRadius_COG=-1
	HearingRadius_COG=-1
	SightRadius_Locust=-1
	HearingRadius_Locust=-1

	VariableLinks.Empty
}
