/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CameraSetFOV extends SequenceAction;

var() float DesiredFOV<autocomment=true | ClampMin=0.0 | ClampMax=179.0>;

defaultproperties
{
	bSuppressAutoComment=false
	ObjName="Set FOV"
	ObjCategory="Camera"

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
}
