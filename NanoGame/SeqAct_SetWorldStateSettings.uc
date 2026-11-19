/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetWorldStateSettings extends SequenceAction;


// need to keep these separate as otherwise people will just end up overwriting each other's settings
enum EWorldStateSettings
{
	EWSS_None,
	EWSS_CinematicAndAIShouldBeIdle,
	EWSS_RoofTraversalIsOutlawed,
	EWSS_MusicManagerEnabled,
};

/** Which worldstate to modify **/
var() EWorldStateSettings WhatToModify;

/** The new value of the worldstate property **/
var() bool bNewValue;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

/**
 * Called when this event is activated.
 */
event Activated()
{
	local NanoGRI NGRI;


	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);


	switch( WhatToModify )
	{

	case EWSS_CinematicAndAIShouldBeIdle:
		NGRI.WorldStateSettings.bCinematicAndAIShouldBeIdle = bNewValue;
		break;
	case EWSS_RoofTraversalIsOutlawed:
		NGRI.WorldStateSettings.bRoofTraversalIsOutlawed = bNewValue;
		break;
	case EWSS_MusicManagerEnabled:
		NGRI.WorldStateSettings.bMusicManagerEnabled = bNewValue;
		break;

	default:
		break;

	}
}




defaultproperties
{
	ObjName="Set World State Settings"
	ObjCategory="Nano Procedural"

	VariableLinks.Empty()
	bCallHandler=FALSE

	InputLinks.Empty()
	InputLinks(0)=(LinkDesc="In")
}

