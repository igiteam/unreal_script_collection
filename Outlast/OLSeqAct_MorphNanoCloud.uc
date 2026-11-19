/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class OLSeqAct_MorphNanoCloud extends SequenceAction;

var() bool bInstantMorph;
var() float TimeScale;

defaultproperties
{
	ObjName="Morph Nano Cloud"
	ObjCategory="Outlast - Gameplay"

	TimeScale=1.0

	InputLinks(0)=(LinkDesc="To Swarm")
	InputLinks(1)=(LinkDesc="To Human")
}