/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ActorFactoryOLWaypoint extends ActorFactory
	config(Editor)
	collapsecategories
	hidecategories(Object)
	native(AI);

defaultproperties
{
	MenuName="Add OLWaypoint"
	NewActorClass=class'OLGame.OLWaypoint'
	bShowInEditorQuickMenu=true
}
