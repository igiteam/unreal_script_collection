/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ModifyNanoMissionWayPoint extends SeqAct_ModifyNanoTargetPoint;


/** If we are interactable or just a place holder to show up on the map **/
var() bool bInteractable;

/** Whether or not this way point is interactable during chaos. **/
var() bool bInteractableDuringChaos;

/** Text to display when showing the interact tool tip **/
var() string TextToDisplayForInteraction;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}



defaultproperties
{
	ObjName="Modify Nano Mission WayPoint"
	ObjCategory="Nano Procedural"


	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="NanoMissionWayPoint",PropertyName=Targets)
}