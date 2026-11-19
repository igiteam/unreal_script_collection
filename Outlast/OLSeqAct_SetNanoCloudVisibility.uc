/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class OLSeqAct_SetNanoCloudVisibility extends SequenceAction;

var() float AlwaysVisibleDistance;
var() float FullOpacityDistance;
var() float DistanceBasedVisibilityMorphTimeScale;

defaultproperties
{
	ObjName="Set NanoCloud Visibility"
	ObjCategory="Outlast - Gameplay"

	AlwaysVisibleDistance=500.0;
	FullOpacityDistance=0.0
	DistanceBasedVisibilityMorphTimeScale=12.0;

	InputLinks(0)=(LinkDesc="Set")
}